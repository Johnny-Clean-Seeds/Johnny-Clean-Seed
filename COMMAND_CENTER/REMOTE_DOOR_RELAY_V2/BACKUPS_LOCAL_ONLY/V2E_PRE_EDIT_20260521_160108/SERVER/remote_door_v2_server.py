#!/usr/bin/env python3
"""Remote Door Relay V2 quiet local ear.

This server intentionally exposes only narrow GET endpoints:
  /door/v2/status
  /door/v2/probe
  /door/v2/probe_async
  /door/v2/receipt

It binds to 127.0.0.1 only. The only action it can place into Child Shell is
read_command_center_status. Async proof readback is latched into /door/v2/status
through LATEST_REMOTE_DOOR_RESULT.json, so callers do not need dynamic receipt
URLs to prove consumption.
"""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import hmac
import json
import os
import re
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
BOUNDARY = [
    "assistant arbitrary shell blocked",
    "raw shell blocked",
    "broad crawl blocked",
    "delete blocked",
    "cleanup blocked",
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
    "no cleanup",
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

        for path in [
            self.dropzone,
            self.inbox,
            self.outbox,
            self.processed,
            self.rejected,
            self.tokens,
            self.nonces,
            self.logs,
            self.receipts,
            self.runs,
        ]:
            path.mkdir(parents=True, exist_ok=True)

        self.token_state = self.load_token_state()
        self.run_id = str(self.token_state.get("run_id") or "REMOTE_DOOR_RELAY_V2_UNKNOWN_RUN")

    def log(self, event: str, **fields: Any) -> None:
        safe_fields = {k: v for k, v in fields.items() if "token" not in k.lower()}
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
            "run_id": str(state.get("run_id") or self.run_id),
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

    def status_payload(self) -> dict[str, Any]:
        state = self.load_token_state()
        latest = self.refresh_latest_result()
        return {
            "verdict": "PASS / REMOTE DOOR V2 QUIET EAR READY",
            "run_id": str(state.get("run_id") or self.run_id),
            "bind": "127.0.0.1",
            "port": self.port,
            "server_path": str(Path(__file__).resolve()),
            "token_expires_at_utc": state.get("expires_at_utc"),
            "child_shell": {
                "root_exists": self.child.exists(),
                "dropzone_exists": self.dropzone.exists(),
                "outbox_exists": self.outbox.exists(),
                "dispatcher_exists": self.dispatcher.exists(),
            },
            "allowed_action": ALLOWED_ACTION,
            "latest_job_id": latest.get("latest_job_id"),
            "latest_state": latest.get("latest_state"),
            "latest_verdict": latest.get("latest_verdict"),
            "latest_receipt_sha256": latest.get("latest_receipt_sha256"),
            "latest_receipt_path": latest.get("latest_receipt_path"),
            "latest_updated_at": latest.get("latest_updated_at"),
            "latest_nonce_hash": latest.get("latest_nonce_hash"),
            "latest_processed_path": latest.get("latest_processed_path"),
            "latest_rejected_path": latest.get("latest_rejected_path"),
            "latest_boundary": latest.get("latest_boundary"),
            "latest_result_path": str(self.latest_result_path),
            "latest_result": latest,
            "boundary": BOUNDARY,
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
        if parsed.path not in ["/door/v2/status", "/door/v2/probe", "/door/v2/probe_async", "/door/v2/receipt"]:
            self.send_json(404, self.door.blocked("REJECTED / UNKNOWN ENDPOINT", "unknown endpoint"))
            return

        ok, status, payload = self.door.validate_token(query)
        if not ok:
            self.send_json(status, payload)
            return

        try:
            if parsed.path == "/door/v2/status":
                self.send_json(200, self.door.status_payload())
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
