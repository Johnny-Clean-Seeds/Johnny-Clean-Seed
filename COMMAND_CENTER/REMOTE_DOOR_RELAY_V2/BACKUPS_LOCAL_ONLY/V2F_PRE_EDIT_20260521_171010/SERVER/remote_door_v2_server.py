#!/usr/bin/env python3
"""Remote Door Relay V2 quiet local ear.

This server intentionally exposes only narrow GET endpoints:
  /door/v2/status
  /door/v2/probe/<print>
  /door/v2/receipt

It binds to 127.0.0.1 only. The only action it can place into Child Shell is
read_command_center_status. The PC keeps a local-only one-use print vault,
rotates prints after accepted use, and latches proof readback into
/door/v2/status through LATEST_REMOTE_DOOR_RESULT.json.
"""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import hmac
import json
import os
import re
import secrets
import shutil
import subprocess
import sys
import threading
import time
import traceback
import urllib.parse
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any


ALLOWED_ACTION = "read_command_center_status"
JOB_RE = re.compile(r"^CHILDJOB-\d{8}-\d{6}-[A-Z0-9-]+$")
PRINT_RE = re.compile(r"^[A-Fa-f0-9]{64}$")
PRINT_TTL_MINUTES = 120
BOUNDARY = [
    "assistant arbitrary shell blocked",
    "raw shell blocked",
    "broad crawl blocked",
    "delete blocked",
    "cleanup through V2 blocked except local proved checkpoint archive",
    "repo write through V2 blocked",
    "git through V2 blocked",
    "Level 3 through V2 blocked",
    "ACTIVE_GUIDES rewrite blocked",
    "CURRENT_TRUTH_INDEX rewrite blocked",
    "doctrine rewrite blocked",
    "permission expansion blocked",
    "junction/symlink teleporter blocked",
]
PROBE_BOUNDARY = [
    "Level 1 read-status only",
    "no repo write",
    "no git write",
    "no delete",
    "no cleanup through V2 except local proved checkpoint archive",
    "no broad crawl",
    "no arbitrary shell",
    "no raw command",
    "no Level 3 save",
]


def utc_now() -> dt.datetime:
    return dt.datetime.now(dt.timezone.utc)


def iso_utc(value: dt.datetime | None = None) -> str:
    if value is None:
        value = utc_now()
    return value.astimezone(dt.timezone.utc).isoformat().replace("+00:00", "Z")


def parse_time(value: str) -> dt.datetime:
    parsed = dt.datetime.fromisoformat(value.replace("Z", "+00:00"))
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=dt.timezone.utc)
    return parsed.astimezone(dt.timezone.utc)


def sha256_text(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest().upper()


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest().upper()


def sha256_file(path: Path) -> str | None:
    if not path.exists():
        return None
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest().upper()


def read_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8-sig") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"JSON root is not an object: {path}")
    return data


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_name(f"{path.name}.tmp")
    with temp.open("w", encoding="utf-8", newline="\n") as handle:
        json.dump(payload, handle, indent=2)
        handle.write("\n")
    os.replace(temp, path)


def write_json_direct(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as handle:
        json.dump(payload, handle, indent=2)
        handle.write("\n")


class DoorState:
    def __init__(self, root: Path, port: int, wait_seconds: float, fallback_after: float) -> None:
        self.root = root.resolve()
        self.cc = self.root.parent
        self.child = self.cc / "CHILD_SHELL"
        self.dropzone = self.child / "DROPZONE"
        self.inbox = self.child / "INBOX"
        self.outbox = self.child / "OUTBOX"
        self.processed = self.child / "PROCESSED"
        self.rejected = self.child / "REJECTED"
        self.dispatcher = self.child / "RUNNERS" / "RUN_CHILD_SHELL_DISPATCH_ONCE.ps1"
        self.tokens = self.root / "TOKENS_LOCAL_ONLY"
        self.nonces = self.root / "NONCES"
        self.print_vault = self.root / "PRINT_VAULT_LOCAL_ONLY"
        self.current_print_path = self.print_vault / "CURRENT_PRINT.json"
        self.next_print_path = self.print_vault / "NEXT_PRINT.json"
        self.print_ledger_path = self.print_vault / "PRINT_LEDGER.jsonl"
        self.used_prints_path = self.print_vault / "USED_PRINTS.jsonl"
        self.print_checkpoints = self.print_vault / "PRINT_CHECKPOINTS"
        self.print_checkpoint_archive = self.print_checkpoints / "ARCHIVE"
        self.recovery_dir = self.print_vault / "RECOVERY_LOCAL_ONLY"
        self.print_secret_path = self.print_vault / "LOCAL_SECRET.key"
        self.logs = self.root / "LOGS"
        self.receipts = self.root / "RECEIPTS"
        self.runs = self.root / "RUNS"
        self.token_state_path = self.tokens / "token_state.json"
        self.pid_path = self.runs / "remote_door_v2_server.pid"
        self.state_path = self.runs / "current_server_state.json"
        self.latest_result_path = self.root / "LATEST_REMOTE_DOOR_RESULT.json"
        self.log_path = self.logs / "remote_door_v2_server.log"
        self.port = port
        self.wait_seconds = wait_seconds
        self.fallback_after = fallback_after
        self.dispatch_lock = threading.Lock()
        self.latest_lock = threading.Lock()
        self.print_lock = threading.Lock()
        self.last_checkpoint: dict[str, Any] | None = None

        for path in [
            self.dropzone,
            self.inbox,
            self.outbox,
            self.processed,
            self.rejected,
            self.tokens,
            self.nonces,
            self.print_vault,
            self.print_checkpoints,
            self.recovery_dir,
            self.logs,
            self.receipts,
            self.runs,
        ]:
            path.mkdir(parents=True, exist_ok=True)

        self.token_state = self.load_token_state()
        self.run_id = str(self.token_state.get("run_id") or "REMOTE_DOOR_RELAY_V2_UNKNOWN_RUN")
        try:
            if self.current_print_path.exists():
                current_print = read_json(self.current_print_path)
                self.run_id = str(current_print.get("run_id") or self.run_id)
        except Exception as exc:
            self.log("print_run_id_read_failed", error=str(exc))

    def log(self, event: str, **fields: Any) -> None:
        unsafe_keys = {"print", "current_print", "next_print", "supplied_print"}
        safe_fields = {
            k: v
            for k, v in fields.items()
            if "token" not in k.lower()
            and "secret" not in k.lower()
            and k.lower() not in unsafe_keys
        }
        payload = {"time_utc": iso_utc(), "event": event, **safe_fields}
        with self.log_path.open("a", encoding="utf-8", newline="\n") as handle:
            handle.write(json.dumps(payload, sort_keys=True) + "\n")

    def load_token_state(self) -> dict[str, Any]:
        if not self.token_state_path.exists():
            return {}
        try:
            return read_json(self.token_state_path)
        except Exception as exc:  # compact operational proof only
            self.log("token_state_read_failed", error=str(exc))
            return {}

    def validate_token(self, query: dict[str, list[str]]) -> tuple[bool, int, dict[str, Any]]:
        token_values = query.get("token", [])
        if not token_values or not token_values[0]:
            return False, 401, self.blocked("REJECTED / MISSING TOKEN", "missing token")

        state = self.load_token_state()
        expected_hash = str(state.get("token_sha256") or "")
        expires_at_raw = str(state.get("expires_at_utc") or "")
        run_id = str(state.get("run_id") or self.run_id)
        if not expected_hash or not expires_at_raw:
            return False, 503, self.blocked("REJECTED / TOKEN STATE MISSING", "token state missing")

        try:
            expires_at = parse_time(expires_at_raw)
        except Exception:
            return False, 503, self.blocked("REJECTED / TOKEN STATE INVALID", "token expiry invalid")

        if utc_now() > expires_at:
            return False, 401, {
                **self.blocked("REJECTED / TOKEN EXPIRED", "expired token"),
                "run_id": run_id,
                "expires_at_utc": expires_at_raw,
            }

        supplied_hash = sha256_text(token_values[0])
        if not hmac.compare_digest(supplied_hash.upper(), expected_hash.upper()):
            return False, 401, self.blocked("REJECTED / WRONG TOKEN", "wrong token")

        self.token_state = state
        self.run_id = run_id
        return True, 200, {}

    def blocked(self, verdict: str, error: str) -> dict[str, Any]:
        return {
            "verdict": verdict,
            "run_id": self.run_id,
            "error": error,
            "boundary": BOUNDARY,
        }

    def write_state(self) -> None:
        state = self.load_token_state()
        payload = {
            "verdict": "RUNNING",
            "run_id": self.run_id,
            "bind": "127.0.0.1",
            "port": self.port,
            "pid": os.getpid(),
            "started_at_utc": iso_utc(),
            "token_expires_at_utc": state.get("expires_at_utc"),
            "server_path": str(Path(__file__).resolve()),
            "boundary": BOUNDARY,
        }
        write_json(self.state_path, payload)
        self.pid_path.write_text(str(os.getpid()), encoding="utf-8")

    def append_jsonl(self, path: Path, payload: dict[str, Any]) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open("a", encoding="utf-8", newline="\n") as handle:
            handle.write(json.dumps(payload, sort_keys=True) + "\n")

    def load_print_secret(self) -> bytes:
        if not self.print_secret_path.exists():
            raise RuntimeError("print local secret missing; run the local-only reset/reseed script")
        raw = self.print_secret_path.read_text(encoding="utf-8").strip()
        if not re.fullmatch(r"[A-Fa-f0-9]{64}", raw):
            raise RuntimeError("print local secret invalid; run the local-only reset/reseed script")
        return bytes.fromhex(raw)

    def compute_print_value(self, print_record: dict[str, Any]) -> str:
        secret = self.load_print_secret()
        material = "|".join(
            [
                str(print_record.get("run_id") or ""),
                str(print_record.get("action") or ""),
                str(print_record.get("expires_at_utc") or ""),
                str(print_record.get("random_material") or ""),
                str(print_record.get("print_id") or ""),
            ]
        ).encode("utf-8")
        return hmac.new(secret, material, hashlib.sha256).hexdigest().upper()

    def build_print_record(self, slot: str, ttl_minutes: int = PRINT_TTL_MINUTES) -> dict[str, Any]:
        now = utc_now()
        expiry = now + dt.timedelta(minutes=ttl_minutes)
        record: dict[str, Any] = {
            "schema": "remote_door_relay_v2e_print",
            "slot": slot,
            "run_id": self.run_id,
            "print_id": f"PRINT-{now:%Y%m%d-%H%M%S}-{secrets.token_hex(4).upper()}",
            "action": ALLOWED_ACTION,
            "issued_at_utc": iso_utc(now),
            "expires_at_utc": iso_utc(expiry),
            "random_material": secrets.token_hex(32).upper(),
            "print_algorithm": "HMAC-SHA256(local_secret, run_id|action|expiry|random_material|print_id)",
        }
        record["print_sha256"] = sha256_text(self.compute_print_value(record))
        return record

    def read_print_pair(self) -> tuple[dict[str, Any], dict[str, Any]]:
        current_print = read_json(self.current_print_path)
        next_print = read_json(self.next_print_path)
        return current_print, next_print

    def validate_print_record(self, record: dict[str, Any], expected_slot: str) -> list[str]:
        errors: list[str] = []
        for key in ["schema", "slot", "run_id", "action", "expires_at_utc", "random_material", "print_id", "print_sha256"]:
            if not record.get(key):
                errors.append(f"missing {expected_slot}.{key}")
        if str(record.get("slot") or "") != expected_slot:
            errors.append(f"{expected_slot} slot mismatch")
        if str(record.get("action") or "") != ALLOWED_ACTION:
            errors.append(f"{expected_slot} action mismatch")
        try:
            computed_hash = sha256_text(self.compute_print_value(record))
            if not hmac.compare_digest(computed_hash, str(record.get("print_sha256") or "").upper()):
                errors.append(f"{expected_slot} print hash mismatch")
        except Exception as exc:
            errors.append(f"{expected_slot} print verification failed: {exc}")
        try:
            parse_time(str(record.get("expires_at_utc") or ""))
        except Exception:
            errors.append(f"{expected_slot} expiry invalid")
        return errors

    def is_used_print_hash(self, print_hash: str) -> bool:
        if not print_hash or not self.used_prints_path.exists():
            return False
        try:
            with self.used_prints_path.open("r", encoding="utf-8-sig") as handle:
                for line in handle:
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        payload = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    if str(payload.get("print_sha256") or "").upper() == print_hash.upper():
                        return True
        except Exception as exc:
            self.log("used_prints_read_failed", error=str(exc))
        return False

    def checkpoint_name(self, phase: str) -> str:
        stamp = dt.datetime.now().astimezone().strftime("%Y%m%d_%H%M%S_%f")
        return f"PRE_PRINT_CHECKPOINT_{stamp}_{phase}.json"

    def write_pre_print_checkpoint(
        self,
        phase: str,
        current_print: dict[str, Any],
        next_print: dict[str, Any],
        latest: dict[str, Any],
        request_id: str | None = None,
        supplied_print_hash: str | None = None,
    ) -> dict[str, Any]:
        errors = []
        errors.extend(self.validate_print_record(current_print, "CURRENT_PRINT"))
        errors.extend(self.validate_print_record(next_print, "NEXT_PRINT"))
        if not isinstance(latest, dict):
            errors.append("latest result state unreadable")
        if not current_print.get("run_id") or not next_print.get("run_id"):
            errors.append("run_id missing")
        if not current_print.get("expires_at_utc") or not next_print.get("expires_at_utc"):
            errors.append("expiry missing")
        if errors:
            raise RuntimeError("; ".join(errors))

        checkpoint = {
            "schema": "remote_door_relay_v2e_pre_print_checkpoint",
            "phase": phase,
            "run_id": self.run_id,
            "request_id": request_id,
            "created_at_utc": iso_utc(),
            "vault_path": str(self.print_vault),
            "current_print_hash": current_print.get("print_sha256"),
            "current_print_id": current_print.get("print_id"),
            "current_print_expires_at_utc": current_print.get("expires_at_utc"),
            "next_print_hash": next_print.get("print_sha256"),
            "next_print_id": next_print.get("print_id"),
            "next_print_expires_at_utc": next_print.get("expires_at_utc"),
            "latest_result_readable": isinstance(latest, dict),
            "latest_job_id": latest.get("latest_job_id"),
            "latest_state": latest.get("latest_state"),
            "latest_receipt_sha256": latest.get("latest_receipt_sha256"),
            "supplied_print_hash": supplied_print_hash,
            "allowed_action": ALLOWED_ACTION,
            "boundary": BOUNDARY,
        }
        path = self.print_checkpoints / self.checkpoint_name(phase)
        write_json(path, checkpoint)
        checkpoint_hash = sha256_file(path)
        reread_hash = sha256_file(path)
        if not checkpoint_hash or checkpoint_hash != reread_hash:
            raise RuntimeError("checkpoint hash verification failed")
        reread = read_json(path)
        if reread.get("current_print_hash") != current_print.get("print_sha256"):
            raise RuntimeError("checkpoint reread verification failed")
        result = {
            "checkpoint_path": str(path),
            "checkpoint_sha256": checkpoint_hash,
            "phase": phase,
        }
        self.last_checkpoint = result
        self.log("pre_print_checkpoint_verified", phase=phase, checkpoint_path=str(path), checkpoint_sha256=checkpoint_hash)
        return result

    def print_recovery_summary(
        self,
        current_print: dict[str, Any] | None,
        next_print: dict[str, Any] | None,
        latest: dict[str, Any],
        errors: list[str],
    ) -> dict[str, str]:
        if errors:
            joined = "; ".join(errors)
            if current_print and next_print and current_print.get("print_sha256") and self.is_used_print_hash(str(current_print.get("print_sha256"))):
                return {
                    "recovery_state": "RECOVERABLE / print burned but next print exists",
                    "recovery_detail": "current print hash is already in USED_PRINTS; run the local-only reset/reseed script or inspect vault locally",
                }
            return {
                "recovery_state": "LOCKED / local-only reset required",
                "recovery_detail": joined,
            }
        latest_job_id = str(latest.get("latest_job_id") or "")
        latest_state = str(latest.get("latest_state") or "")
        latest_receipt_path = str(latest.get("latest_receipt_path") or "")
        if latest_receipt_path and Path(latest_receipt_path).exists() and latest_state != "PROCESSED_PASS":
            return {
                "recovery_state": "RECOVERABLE / receipt exists but latch stale",
                "recovery_detail": "status refresh should relatch from receipt evidence",
            }
        if latest_job_id and latest_state == "PENDING" and current_print and not self.is_used_print_hash(str(current_print.get("print_sha256") or "")):
            return {
                "recovery_state": "RECOVERABLE / job written but print not burned",
                "recovery_detail": "wait for receipt, then use local-only reset/reseed if the same print remains armed",
            }
        return {
            "recovery_state": "CLEAN / no recovery needed",
            "recovery_detail": "vault pair and latest latch are readable",
        }

    def print_status(self, base_url: str, latest: dict[str, Any]) -> dict[str, Any]:
        try:
            current_print, next_print = self.read_print_pair()
        except Exception as exc:
            return {
                "print_state": "LOCKED",
                "current_print_hash": None,
                "next_print_hash": None,
                "next_probe_url": None,
                "expiry": None,
                "checkpoint_path": None,
                "checkpoint_sha256": None,
                "recovery_state": "LOCKED / local-only reset required",
                "recovery_detail": f"print vault unreadable: {exc}",
            }

        errors = []
        errors.extend(self.validate_print_record(current_print, "CURRENT_PRINT"))
        errors.extend(self.validate_print_record(next_print, "NEXT_PRINT"))
        current_hash = str(current_print.get("print_sha256") or "")
        next_hash = str(next_print.get("print_sha256") or "")
        expires_raw = str(current_print.get("expires_at_utc") or "")
        print_state = "READY"
        next_probe_url = None
        checkpoint = {"checkpoint_path": None, "checkpoint_sha256": None}

        if self.is_used_print_hash(current_hash):
            print_state = "USED"
            errors.append("current print has already been burned")
        try:
            expires_at = parse_time(expires_raw)
            if utc_now() > expires_at:
                print_state = "EXPIRED"
        except Exception:
            errors.append("current print expiry invalid")

        if errors:
            if print_state == "READY":
                print_state = "RECOVERY_REQUIRED"
        else:
            checkpoint = self.write_pre_print_checkpoint("PRE_STATUS", current_print, next_print, latest)
            if print_state == "READY":
                current_value = self.compute_print_value(current_print)
                next_probe_url = f"{base_url}/door/v2/probe/{urllib.parse.quote(current_value, safe='')}"

        recovery = self.print_recovery_summary(current_print, next_print, latest, errors)
        return {
            "print_state": print_state,
            "current_print_hash": current_hash or None,
            "next_print_hash": next_hash or None,
            "next_probe_url": next_probe_url,
            "expiry": expires_raw or None,
            "checkpoint_path": checkpoint.get("checkpoint_path"),
            "checkpoint_sha256": checkpoint.get("checkpoint_sha256"),
            **recovery,
        }

    def atomic_write_vault_pair(self, current_print: dict[str, Any], next_print: dict[str, Any]) -> None:
        stamp = dt.datetime.now().astimezone().strftime("%Y%m%d_%H%M%S_%f")
        temp_current = self.print_vault / f"CURRENT_PRINT.{stamp}.tmp"
        temp_next = self.print_vault / f"NEXT_PRINT.{stamp}.tmp"
        write_json_direct(temp_current, current_print)
        write_json_direct(temp_next, next_print)
        for temp_path, expected_slot in [(temp_current, "CURRENT_PRINT"), (temp_next, "NEXT_PRINT")]:
            payload = read_json(temp_path)
            errors = self.validate_print_record(payload, expected_slot)
            if errors:
                raise RuntimeError(f"vault temp verification failed for {expected_slot}: {'; '.join(errors)}")
            if not sha256_file(temp_path):
                raise RuntimeError(f"vault temp hash failed for {expected_slot}")
        os.replace(temp_current, self.current_print_path)
        os.replace(temp_next, self.next_print_path)
        final_current = read_json(self.current_print_path)
        final_next = read_json(self.next_print_path)
        final_errors = self.validate_print_record(final_current, "CURRENT_PRINT") + self.validate_print_record(final_next, "NEXT_PRINT")
        if final_errors:
            raise RuntimeError(f"vault final verification failed: {'; '.join(final_errors)}")

    def create_print_probe_job_atomic(self, request_id: str, checkpoint: dict[str, Any]) -> tuple[str, Path, str]:
        if not self.child.exists():
            raise RuntimeError(f"Child Shell missing: {self.child}")
        suffix = "REMOTE-DOOR-V2E-PRINT-PROBE"
        job_id = self.next_job_id(suffix=suffix)
        receipt_path = self.outbox / f"{job_id}.receipt.txt"
        job_path = self.dropzone / f"{job_id}.childjob.json"
        temp_path = self.dropzone / f".{job_id}.{request_id}.tmp"
        job = {
            "job_id": job_id,
            "id": job_id,
            "created_at": dt.datetime.now().astimezone().isoformat(),
            "requested_by": "remote_door_relay_v2e_print",
            "route": "REMOTE_DOOR_RELAY_V2E_PRINT_TO_CHILD_SHELL",
            "request_id": request_id,
            "run_id": self.run_id,
            "action": ALLOWED_ACTION,
            "allowed_action": ALLOWED_ACTION,
            "type": ALLOWED_ACTION,
            "target_path": str(self.cc),
            "expected_receipt": str(receipt_path),
            "pre_print_checkpoint_path": checkpoint.get("checkpoint_path"),
            "pre_print_checkpoint_sha256": checkpoint.get("checkpoint_sha256"),
            "boundary": PROBE_BOUNDARY,
        }
        write_json_direct(temp_path, job)
        temp_hash = sha256_file(temp_path)
        reread = read_json(temp_path)
        if not temp_hash or reread.get("job_id") != job_id or reread.get("action") != ALLOWED_ACTION:
            raise RuntimeError("childjob temp verification failed")
        if job_path.exists():
            raise RuntimeError(f"childjob already exists: {job_path}")
        os.replace(temp_path, job_path)
        final_hash = sha256_file(job_path)
        if final_hash != temp_hash:
            raise RuntimeError("childjob atomic move verification failed")
        self.log("print_probe_job_created", request_id=request_id, job_id=job_id, job_path=str(job_path), childjob_sha256=final_hash)
        return job_id, job_path, final_hash

    def reject_print(self, status_code: int, verdict: str, error: str, request_id: str, supplied_print_hash: str | None = None) -> tuple[int, dict[str, Any]]:
        payload = {
            **self.blocked(verdict, error),
            "request_id": request_id,
            "print_state": verdict.replace("REJECTED / ", ""),
            "supplied_print_hash": supplied_print_hash,
            "status_url": "/door/v2/status",
            "allowed_action": ALLOWED_ACTION,
        }
        return status_code, payload

    def handle_print_probe(self, supplied_print: str, request_id: str, base_url: str) -> tuple[int, dict[str, Any]]:
        supplied_print = supplied_print.strip()
        supplied_print_hash = sha256_text(supplied_print) if supplied_print else None
        if not PRINT_RE.match(supplied_print):
            return self.reject_print(400, "REJECTED / WRONG PRINT", "print outside expected format", request_id, supplied_print_hash)

        with self.print_lock:
            if self.is_used_print_hash(str(supplied_print_hash)):
                return self.reject_print(409, "REJECTED / USED PRINT", "print already used", request_id, supplied_print_hash)

            try:
                current_print, next_print = self.read_print_pair()
            except Exception as exc:
                return self.reject_print(423, "REJECTED / LOCKED PRINT", f"print vault unreadable: {exc}", request_id, supplied_print_hash)

            errors = self.validate_print_record(current_print, "CURRENT_PRINT") + self.validate_print_record(next_print, "NEXT_PRINT")
            if errors:
                return self.reject_print(423, "REJECTED / LOCKED PRINT", "; ".join(errors), request_id, supplied_print_hash)

            current_hash = str(current_print.get("print_sha256") or "").upper()
            current_value = self.compute_print_value(current_print)
            if not hmac.compare_digest(supplied_print.upper(), current_value.upper()):
                if self.is_used_print_hash(str(supplied_print_hash)):
                    return self.reject_print(409, "REJECTED / USED PRINT", "print already used", request_id, supplied_print_hash)
                return self.reject_print(403, "REJECTED / WRONG PRINT", "wrong print", request_id, supplied_print_hash)

            if utc_now() > parse_time(str(current_print.get("expires_at_utc") or "")):
                return self.reject_print(410, "REJECTED / EXPIRED PRINT", "print expired", request_id, supplied_print_hash)

            latest = self.read_latest_result()
            checkpoint = self.write_pre_print_checkpoint("PRE_USE", current_print, next_print, latest, request_id, supplied_print_hash)
            job_id, job_path, childjob_sha256 = self.create_print_probe_job_atomic(request_id, checkpoint)
            proof = self.compact_receipt(job_id, request_id, job_path)
            self.write_latest_from_proof(proof, current_hash)

            burned_at = iso_utc()
            self.append_jsonl(
                self.used_prints_path,
                {
                    "schema": "remote_door_relay_v2e_used_print",
                    "print_sha256": current_hash,
                    "print_id": current_print.get("print_id"),
                    "run_id": self.run_id,
                    "request_id": request_id,
                    "job_id": job_id,
                    "burned_at_utc": burned_at,
                    "checkpoint_path": checkpoint.get("checkpoint_path"),
                    "checkpoint_sha256": checkpoint.get("checkpoint_sha256"),
                },
            )

            promoted_current = dict(next_print)
            promoted_current["slot"] = "CURRENT_PRINT"
            promoted_current["promoted_at_utc"] = burned_at
            promoted_current["promoted_from_next_print_hash"] = next_print.get("print_sha256")
            promoted_current["previous_current_print_hash"] = current_hash
            new_next = self.build_print_record("NEXT_PRINT")
            self.atomic_write_vault_pair(promoted_current, new_next)

            self.append_jsonl(
                self.print_ledger_path,
                {
                    "schema": "remote_door_relay_v2e_print_ledger_entry",
                    "event": "PRINT_USED_AND_ROTATED",
                    "time_utc": iso_utc(),
                    "run_id": self.run_id,
                    "request_id": request_id,
                    "job_id": job_id,
                    "used_print_hash": current_hash,
                    "new_current_print_hash": promoted_current.get("print_sha256"),
                    "new_next_print_hash": new_next.get("print_sha256"),
                    "checkpoint_path": checkpoint.get("checkpoint_path"),
                    "checkpoint_sha256": checkpoint.get("checkpoint_sha256"),
                    "childjob_sha256": childjob_sha256,
                },
            )
            self.schedule_dispatcher_fallback(job_id)

            return 202, {
                "verdict": "ACCEPTED / PRINT CHILD SHELL JOB CREATED",
                "run_id": self.run_id,
                "request_id": request_id,
                "job_id": job_id,
                "expected_receipt": str(self.outbox / f"{job_id}.receipt.txt"),
                "latest_status_url": f"{base_url}/door/v2/status",
                "status_url": f"{base_url}/door/v2/status",
                "print_state": "USED_AND_ROTATED",
                "used_print_hash": current_hash,
                "current_print_hash": promoted_current.get("print_sha256"),
                "next_print_hash": new_next.get("print_sha256"),
                "checkpoint_path": checkpoint.get("checkpoint_path"),
                "checkpoint_sha256": checkpoint.get("checkpoint_sha256"),
                "childjob_sha256": childjob_sha256,
                "boundary": BOUNDARY,
                "error": None,
            }

    def status_payload(self, base_url: str) -> dict[str, Any]:
        latest = self.refresh_latest_result()
        with self.print_lock:
            print_status = self.print_status(base_url, latest)
        return {
            "verdict": "PASS / REMOTE DOOR V2E PRINT DOOR READY" if print_status.get("print_state") == "READY" else "PASS / REMOTE DOOR V2E STATUS READABLE",
            "run_id": self.run_id,
            "bind": "127.0.0.1",
            "port": self.port,
            "server_path": str(Path(__file__).resolve()),
            "allowed_action": ALLOWED_ACTION,
            "latest_job_id": latest.get("latest_job_id"),
            "latest_state": latest.get("latest_state"),
            "latest_verdict": latest.get("latest_verdict"),
            "latest_receipt_sha256": latest.get("latest_receipt_sha256"),
            "latest_receipt_path": latest.get("latest_receipt_path"),
            "latest_updated_at": latest.get("latest_updated_at"),
            "latest_processed_path": latest.get("latest_processed_path"),
            "latest_rejected_path": latest.get("latest_rejected_path"),
            "latest_boundary": latest.get("latest_boundary"),
            **print_status,
            "stop_command": f"& '{self.root / 'TOOLS' / 'STOP_REMOTE_DOOR_V2.ps1'}'",
            "boundary": BOUNDARY,
            "blocked_powers": BOUNDARY,
        }

    def empty_latest_result(self, error: str | None = None) -> dict[str, Any]:
        return {
            "schema": "remote_door_relay_v2_latest_result",
            "slot": "LATEST_REMOTE_DOOR_RESULT",
            "run_id": self.run_id,
            "latest_job_id": None,
            "latest_state": "NONE",
            "latest_verdict": "NONE / NO LATEST REMOTE DOOR RESULT",
            "latest_receipt_sha256": None,
            "latest_receipt_path": None,
            "latest_updated_at": None,
            "latest_nonce_hash": None,
            "latest_request_id": None,
            "latest_job_path": None,
            "latest_processed_path": None,
            "latest_rejected_path": None,
            "latest_boundary": PROBE_BOUNDARY[0],
            "boundary": BOUNDARY,
            "error": error,
        }

    def latest_state_value(self, state: str) -> str:
        normalized = state.upper().replace(" / ", "_").replace(" ", "_").replace("-", "_")
        return normalized or "UNKNOWN"

    def latest_from_proof(self, proof: dict[str, Any], nonce_hash: str | None = None) -> dict[str, Any]:
        return {
            "schema": "remote_door_relay_v2_latest_result",
            "slot": "LATEST_REMOTE_DOOR_RESULT",
            "run_id": self.run_id,
            "latest_job_id": proof.get("job_id"),
            "latest_state": self.latest_state_value(str(proof.get("state") or "")),
            "latest_verdict": proof.get("verdict"),
            "latest_receipt_sha256": proof.get("receipt_sha256"),
            "latest_receipt_path": proof.get("receipt_path"),
            "latest_updated_at": iso_utc(),
            "latest_nonce_hash": nonce_hash,
            "latest_request_id": proof.get("request_id"),
            "latest_job_path": proof.get("job_path"),
            "latest_processed_path": proof.get("processed_path"),
            "latest_rejected_path": proof.get("rejected_path"),
            "latest_boundary": PROBE_BOUNDARY[0],
            "boundary": BOUNDARY,
            "error": proof.get("error"),
        }

    def write_latest_from_proof(self, proof: dict[str, Any], nonce_hash: str | None = None) -> dict[str, Any]:
        latest = self.latest_from_proof(proof, nonce_hash)
        with self.latest_lock:
            write_json(self.latest_result_path, latest)
        self.log(
            "latest_result_latched",
            job_id=str(latest.get("latest_job_id")),
            state=str(latest.get("latest_state")),
        )
        return latest

    def read_latest_result(self) -> dict[str, Any]:
        if not self.latest_result_path.exists():
            return self.empty_latest_result()
        try:
            return read_json(self.latest_result_path)
        except Exception as exc:
            self.log("latest_result_read_failed", error=str(exc))
            return self.empty_latest_result(error=f"latest result read failed: {exc}")

    def refresh_latest_result(self) -> dict[str, Any]:
        latest = self.read_latest_result()
        job_id = str(latest.get("latest_job_id") or "")
        if not JOB_RE.match(job_id):
            return latest

        job_name = f"{job_id}.childjob.json"
        expected_receipt_path = self.outbox / f"{job_id}.receipt.txt"
        latched_receipt_raw = str(latest.get("latest_receipt_path") or "")
        latched_receipt_path = Path(latched_receipt_raw) if latched_receipt_raw else expected_receipt_path
        if latched_receipt_path.name != expected_receipt_path.name:
            latched_receipt_path = expected_receipt_path

        processed_path = self.processed / job_name
        rejected_job_path = self.rejected / job_name
        rejected_note_path = self.rejected / f"{job_id}.rejected.txt"
        dispatch_rejected_note_path = self.rejected / f"{job_id}.dispatch.rejected.txt"

        receipt_path = latched_receipt_path if latched_receipt_path.exists() else expected_receipt_path
        receipt_exists = receipt_path.exists()
        rejected_paths = [
            path
            for path in [rejected_job_path, rejected_note_path, dispatch_rejected_note_path]
            if path.exists()
        ]

        refreshed = dict(latest)
        refreshed["schema"] = "remote_door_relay_v2_latest_result"
        refreshed["slot"] = "LATEST_REMOTE_DOOR_RESULT"
        refreshed["run_id"] = self.run_id
        refreshed["latest_job_id"] = job_id
        refreshed["latest_receipt_path"] = str(receipt_path)
        refreshed["latest_processed_path"] = str(processed_path) if processed_path.exists() else None
        refreshed["latest_rejected_path"] = str(rejected_paths[0]) if rejected_paths else None
        refreshed["latest_boundary"] = PROBE_BOUNDARY[0]
        refreshed["boundary"] = BOUNDARY
        refreshed["latest_updated_at"] = iso_utc()

        if receipt_exists:
            refreshed["latest_state"] = "PROCESSED_PASS"
            refreshed["latest_verdict"] = "PASS / CHILD SHELL RECEIPT CREATED"
            refreshed["latest_receipt_sha256"] = sha256_file(receipt_path)
            refreshed["error"] = None
        elif rejected_paths:
            refreshed["latest_state"] = "REJECTED"
            refreshed["latest_verdict"] = "REJECTED / CHILD SHELL REJECTED JOB"
            refreshed["latest_receipt_sha256"] = None
            refreshed["error"] = "job rejected by Child Shell"
        else:
            refreshed["latest_state"] = "PENDING"
            refreshed["latest_verdict"] = "PENDING / RECEIPT NOT READY"
            refreshed["latest_receipt_sha256"] = None
            refreshed["error"] = None

        with self.latest_lock:
            write_json(self.latest_result_path, refreshed)
        self.log(
            "latest_result_refreshed",
            job_id=job_id,
            state=str(refreshed.get("latest_state")),
            receipt_exists=receipt_exists,
        )
        return refreshed

    def reserve_nonce(self, nonce: str, request_id: str) -> tuple[bool, dict[str, Any]]:
        if not nonce:
            return False, self.blocked("REJECTED / MISSING NONCE", "missing nonce")
        if len(nonce) > 160:
            return False, self.blocked("REJECTED / NONCE TOO LONG", "nonce too long")
        nonce_hash = sha256_text(nonce)
        nonce_path = self.nonces / f"{nonce_hash}.nonce.json"
        payload = {
            "nonce_sha256": nonce_hash,
            "request_id": request_id,
            "run_id": self.run_id,
            "first_seen_utc": iso_utc(),
        }
        try:
            fd = os.open(str(nonce_path), os.O_WRONLY | os.O_CREAT | os.O_EXCL)
        except FileExistsError:
            return False, {
                **self.blocked("REJECTED / DUPLICATE NONCE", "duplicate nonce"),
                "request_id": request_id,
            }
        with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as handle:
            json.dump(payload, handle, indent=2)
            handle.write("\n")
        return True, {"nonce_sha256": nonce_hash}

    def requested_action(self, query: dict[str, list[str]]) -> str:
        seen = []
        for key in ["action", "allowed_action", "type"]:
            if key in query and query[key]:
                seen.append(str(query[key][0]))
        if not seen:
            return ALLOWED_ACTION
        if any(value != ALLOWED_ACTION for value in seen):
            return ",".join(seen)
        return ALLOWED_ACTION

    def next_job_id(self, suffix: str = "REMOTE-DOOR-V2-PROBE") -> str:
        for _ in range(7):
            local = dt.datetime.now().astimezone()
            job_id = f"CHILDJOB-{local:%Y%m%d-%H%M%S}-{suffix}"
            if not any((lane / f"{job_id}.childjob.json").exists() for lane in [self.dropzone, self.inbox, self.processed, self.rejected]):
                if not (self.outbox / f"{job_id}.receipt.txt").exists():
                    return job_id
            time.sleep(1.0)
        raise RuntimeError("could not allocate unique V2 job id")

    def create_probe_job(self, request_id: str, async_probe: bool = False) -> tuple[str, Path]:
        if not self.child.exists():
            raise RuntimeError(f"Child Shell missing: {self.child}")
        if not self.dispatcher.exists():
            raise RuntimeError(f"Child Shell dispatcher missing: {self.dispatcher}")
        suffix = "REMOTE-DOOR-V2-ASYNC-PROBE" if async_probe else "REMOTE-DOOR-V2-PROBE"
        job_id = self.next_job_id(suffix=suffix)
        receipt_path = self.outbox / f"{job_id}.receipt.txt"
        job_path = self.dropzone / f"{job_id}.childjob.json"
        job = {
            "job_id": job_id,
            "id": job_id,
            "created_at": dt.datetime.now().astimezone().isoformat(),
            "requested_by": "remote_door_relay_v2",
            "route": "REMOTE_DOOR_RELAY_V2_ASYNC_TO_CHILD_SHELL" if async_probe else "REMOTE_DOOR_RELAY_V2_TO_CHILD_SHELL",
            "request_id": request_id,
            "run_id": self.run_id,
            "action": ALLOWED_ACTION,
            "allowed_action": ALLOWED_ACTION,
            "type": ALLOWED_ACTION,
            "target_path": str(self.cc),
            "expected_receipt": str(receipt_path),
            "boundary": PROBE_BOUNDARY,
        }
        write_json(job_path, job)
        self.log("probe_job_created", request_id=request_id, job_id=job_id, job_path=str(job_path))
        return job_id, job_path

    def compact_receipt(self, job_id: str, request_id: str | None = None, job_path: Path | None = None) -> dict[str, Any]:
        receipt_path = self.outbox / f"{job_id}.receipt.txt"
        job_name = f"{job_id}.childjob.json"
        original_job_path = job_path or (self.dropzone / job_name)
        processed_path = self.processed / job_name
        rejected_job_path = self.rejected / job_name
        rejected_note_path = self.rejected / f"{job_id}.rejected.txt"
        dispatch_rejected_note_path = self.rejected / f"{job_id}.dispatch.rejected.txt"

        seen_anywhere = any(
            path.exists()
            for path in [
                receipt_path,
                self.dropzone / job_name,
                self.inbox / job_name,
                processed_path,
                rejected_job_path,
                rejected_note_path,
                dispatch_rejected_note_path,
            ]
        )

        if receipt_path.exists():
            verdict = "PASS / CHILD SHELL RECEIPT CREATED"
            state = "PROCESSED / PASS"
            error = None
        elif rejected_job_path.exists() or rejected_note_path.exists() or dispatch_rejected_note_path.exists():
            verdict = "REJECTED / CHILD SHELL REJECTED JOB"
            state = "REJECTED"
            error = "job rejected by Child Shell"
        elif seen_anywhere:
            verdict = "PENDING / RECEIPT NOT READY"
            state = "PENDING"
            error = None
        else:
            verdict = "MISSING / JOB STATE NOT FOUND"
            state = "MISSING"
            error = "job state not found"

        payload: dict[str, Any] = {
            "verdict": verdict,
            "state": state,
            "run_id": self.run_id,
            "request_id": request_id,
            "job_id": job_id,
            "job_path": str(original_job_path),
            "dropzone_path": str(self.dropzone / job_name) if (self.dropzone / job_name).exists() else None,
            "inbox_path": str(self.inbox / job_name) if (self.inbox / job_name).exists() else None,
            "processed_path": str(processed_path) if processed_path.exists() else None,
            "rejected_path": str(rejected_job_path) if rejected_job_path.exists() else None,
            "rejected_note_path": str(rejected_note_path) if rejected_note_path.exists() else (str(dispatch_rejected_note_path) if dispatch_rejected_note_path.exists() else None),
            "receipt_path": str(receipt_path) if receipt_path.exists() else str(receipt_path),
            "receipt_sha256": sha256_file(receipt_path),
            "boundary": BOUNDARY,
            "error": error,
        }
        return payload

    def accepted_async_payload(self, request_id: str, job_id: str, job_path: Path) -> dict[str, Any]:
        receipt_path = self.outbox / f"{job_id}.receipt.txt"
        return {
            "verdict": "ACCEPTED / ASYNC CHILD SHELL JOB CREATED",
            "run_id": self.run_id,
            "request_id": request_id,
            "job_id": job_id,
            "job_path": str(job_path),
            "expected_receipt": str(receipt_path),
            "readback": "/door/v2/status",
            "latest_result_path": str(self.latest_result_path),
            "boundary": BOUNDARY,
            "error": None,
        }

    def run_dispatcher_fallback(self, job_id: str) -> None:
        with self.dispatch_lock:
            job_name = f"{job_id}.childjob.json"
            drop_path = self.dropzone / job_name
            inbox_path = self.inbox / job_name
            if drop_path.exists() and not inbox_path.exists():
                shutil.move(str(drop_path), str(inbox_path))
                self.log("fallback_moved_dropzone_to_inbox", job_id=job_id)
            if inbox_path.exists():
                shell = shutil.which("pwsh") or shutil.which("powershell")
                if not shell:
                    raise RuntimeError("PowerShell executable not found for dispatcher fallback")
                command = [
                    shell,
                    "-NoProfile",
                    "-ExecutionPolicy",
                    "Bypass",
                    "-File",
                    str(self.dispatcher),
                ]
                result = subprocess.run(command, capture_output=True, text=True, timeout=25)
                self.log(
                    "fallback_dispatcher_finished",
                    job_id=job_id,
                    returncode=result.returncode,
                    stdout_tail=result.stdout[-800:],
                    stderr_tail=result.stderr[-800:],
                )

    def schedule_dispatcher_fallback(self, job_id: str) -> None:
        def worker() -> None:
            try:
                time.sleep(max(0.0, self.fallback_after))
                deadline = time.time() + 18.0
                while time.time() < deadline:
                    proof = self.compact_receipt(job_id)
                    if proof["state"] != "PENDING":
                        return
                    self.run_dispatcher_fallback(job_id)
                    time.sleep(0.75)
            except Exception as exc:
                self.log("async_fallback_dispatcher_failed", job_id=job_id, error=str(exc))

        thread = threading.Thread(target=worker, name=f"remote-door-v2-fallback-{job_id}", daemon=True)
        thread.start()
        self.log("async_fallback_scheduled", job_id=job_id, delay_seconds=self.fallback_after)

    def wait_for_receipt(self, job_id: str, request_id: str, job_path: Path) -> dict[str, Any]:
        started = time.time()
        fallback_done = False
        while time.time() - started < self.wait_seconds:
            proof = self.compact_receipt(job_id, request_id, job_path)
            if proof["verdict"].startswith("PASS") or proof["verdict"].startswith("REJECTED"):
                return proof
            if not fallback_done and time.time() - started >= self.fallback_after:
                fallback_done = True
                try:
                    self.run_dispatcher_fallback(job_id)
                except Exception as exc:
                    self.log("fallback_dispatcher_failed", job_id=job_id, error=str(exc))
            time.sleep(0.5)
        proof = self.compact_receipt(job_id, request_id, job_path)
        proof["verdict"] = "BLOCKED / RECEIPT TIMEOUT"
        proof["error"] = "probe created job but receipt did not arrive before timeout"
        return proof


class Handler(BaseHTTPRequestHandler):
    server_version = "RemoteDoorRelayV2/1.0"

    @property
    def door(self) -> DoorState:
        return self.server.door_state  # type: ignore[attr-defined]

    def log_message(self, fmt: str, *args: Any) -> None:
        try:
            path = urllib.parse.urlparse(self.path).path
            self.door.log("http_request", client=self.client_address[0], path=path)
        except Exception:
            pass

    def send_json(self, status: int, payload: dict[str, Any]) -> None:
        body = json.dumps(payload, indent=2).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Cache-Control", "no-store, no-cache, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def endpoint_base(self) -> str:
        host = self.headers.get("Host") or f"127.0.0.1:{self.door.port}"
        proto = self.headers.get("X-Forwarded-Proto") or ("http" if host.startswith("127.0.0.1") or host.startswith("localhost") else "https")
        return f"{proto}://{host}"

    def receipt_poll_url(self, token: str, job_id: str) -> str:
        return (
            f"{self.endpoint_base()}/door/v2/receipt"
            f"?token={urllib.parse.quote(token, safe='')}"
            f"&job_id={urllib.parse.quote(job_id, safe='')}"
        )

    def do_GET(self) -> None:  # noqa: N802 - BaseHTTPRequestHandler API
        parsed = urllib.parse.urlparse(self.path)
        query = urllib.parse.parse_qs(parsed.query, keep_blank_values=True)
        is_print_probe = parsed.path.startswith("/door/v2/probe/") and len(parsed.path.split("/")) == 5
        if parsed.path not in ["/door/v2/status", "/door/v2/probe", "/door/v2/probe_async", "/door/v2/receipt"] and not is_print_probe:
            self.send_json(404, self.door.blocked("REJECTED / UNKNOWN ENDPOINT", "unknown endpoint"))
            return

        try:
            if parsed.path == "/door/v2/status":
                self.send_json(200, self.door.status_payload(self.endpoint_base()))
                return

            if is_print_probe:
                request_id = f"REQ-{dt.datetime.now():%Y%m%d-%H%M%S}-{os.urandom(3).hex().upper()}"
                action = self.door.requested_action(query)
                if action != ALLOWED_ACTION:
                    self.send_json(
                        403,
                        {
                            **self.door.blocked("REJECTED / BLOCKED ACTION", f"blocked action: {action}"),
                            "request_id": request_id,
                            "allowed_action": ALLOWED_ACTION,
                        },
                    )
                    return
                supplied_print = urllib.parse.unquote(parsed.path.rsplit("/", 1)[-1])
                status_code, payload = self.door.handle_print_probe(supplied_print, request_id, self.endpoint_base())
                self.send_json(status_code, payload)
                return

            ok, status, payload = self.door.validate_token(query)
            if not ok:
                self.send_json(status, payload)
                return

            if parsed.path == "/door/v2/receipt":
                job_id = str(query.get("job_id", [""])[0])
                if not JOB_RE.match(job_id):
                    self.send_json(400, self.door.blocked("REJECTED / BAD JOB ID", "job_id outside expected pattern"))
                    return
                self.send_json(200, self.door.compact_receipt(job_id))
                return

            request_id = f"REQ-{dt.datetime.now():%Y%m%d-%H%M%S}-{os.urandom(3).hex().upper()}"
            action = self.door.requested_action(query)
            if action != ALLOWED_ACTION:
                self.send_json(
                    403,
                    {
                        **self.door.blocked("REJECTED / BLOCKED ACTION", f"blocked action: {action}"),
                        "request_id": request_id,
                        "allowed_action": ALLOWED_ACTION,
                    },
                )
                return

            nonce = str(query.get("nonce", [""])[0])
            nonce_ok, nonce_payload = self.door.reserve_nonce(nonce, request_id)
            if not nonce_ok:
                self.send_json(409 if nonce_payload["error"] == "duplicate nonce" else 400, nonce_payload)
                return
            nonce_hash = str(nonce_payload.get("nonce_sha256") or "")

            if parsed.path == "/door/v2/probe_async":
                job_id, job_path = self.door.create_probe_job(request_id, async_probe=True)
                self.door.write_latest_from_proof(self.door.compact_receipt(job_id, request_id, job_path), nonce_hash)
                self.door.schedule_dispatcher_fallback(job_id)
                self.send_json(202, self.door.accepted_async_payload(request_id, job_id, job_path))
                return

            job_id, job_path = self.door.create_probe_job(request_id, async_probe=False)
            self.door.write_latest_from_proof(self.door.compact_receipt(job_id, request_id, job_path), nonce_hash)
            proof = self.door.wait_for_receipt(job_id, request_id, job_path)
            self.door.write_latest_from_proof(proof, nonce_hash)
            self.send_json(200 if proof["verdict"].startswith("PASS") else 502, proof)
        except Exception as exc:
            self.door.log("request_failed", path=parsed.path, error=str(exc), traceback=traceback.format_exc()[-1600:])
            self.send_json(500, self.door.blocked("BLOCKED / SERVER ERROR", str(exc)))


class LoopbackHTTPServer(ThreadingHTTPServer):
    allow_reuse_address = True


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=str(Path(__file__).resolve().parents[1]))
    parser.add_argument("--port", type=int, default=8792)
    parser.add_argument("--wait-seconds", type=float, default=24.0)
    parser.add_argument("--fallback-after", type=float, default=5.0)
    args = parser.parse_args()

    state = DoorState(Path(args.root), args.port, args.wait_seconds, args.fallback_after)
    state.write_state()
    state.log("server_start", bind="127.0.0.1", port=args.port, pid=os.getpid())

    server = LoopbackHTTPServer(("127.0.0.1", args.port), Handler)
    server.door_state = state  # type: ignore[attr-defined]
    print(f"Remote Door Relay V2 listening on http://127.0.0.1:{args.port}", flush=True)
    try:
        server.serve_forever()
    finally:
        state.log("server_stop", pid=os.getpid())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
