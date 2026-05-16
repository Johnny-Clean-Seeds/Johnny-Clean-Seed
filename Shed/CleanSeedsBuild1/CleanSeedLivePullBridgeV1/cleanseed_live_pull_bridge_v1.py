#!/usr/bin/env python3
"""CleanSeed Live Pull Bridge V1 - local read-only evidence bridge."""
from __future__ import annotations

import argparse
import datetime as _dt
import hashlib
import json
import mimetypes
import os
from pathlib import Path
import posixpath
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, unquote, urlparse

BRIDGE_NAME = "CleanSeed Live Pull Bridge"
VERSION = "1.0.0"
DEFAULT_HOST = "127.0.0.1"
DEFAULT_PORT = 8791
SIZE_CAP = 262144
BUILD_DIR = Path(__file__).resolve().parent
CHECKPOINT_PATH = BUILD_DIR / "checkpoint_manifest_v1.json"
PID_PATH = BUILD_DIR / "bridge_v1.pid"

APPROVED_ROOTS = {
    "PROJECT": Path(r"C:\Users\13527\Desktop\Clean Milk not-BLOAT"),
    "SHED": Path(r"C:\Users\13527\Desktop\Shed"),
}

SAFE_TEXT_EXTENSIONS = {
    ".txt", ".md", ".json", ".jsonl", ".csv", ".tsv", ".log", ".yaml", ".yml", ".xml",
    ".html", ".htm", ".css", ".lua", ".py", ".js", ".ts", ".tsx", ".jsx", ".java", ".cs",
    ".cpp", ".c", ".h", ".hpp", ".rs", ".go", ".rb", ".php", ".sql", ".ini", ".cfg", ".conf",
}
BLOCKED_EXTENSIONS = {
    ".exe", ".dll", ".sys", ".com", ".msi", ".bat", ".cmd", ".ps1", ".psm1", ".psd1", ".vbs", ".wsf",
    ".lnk", ".url", ".zip", ".7z", ".rar", ".tar", ".gz", ".bz2", ".xz", ".iso", ".png", ".jpg", ".jpeg",
    ".gif", ".webp", ".bmp", ".ico", ".mp3", ".wav", ".mp4", ".mov", ".avi", ".mkv", ".pdf", ".doc",
    ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".sqlite", ".db", ".bin",
}
SUSPICIOUS_NAMES = (
    "secret", "password", "passwd", "token", "api-key", "api_key", "private-key", "private_key",
    "credential", "credentials", "auth", "cookie", "session",
)
NO_ACTION_BOUNDARIES = {
    "read_only_bridge": "YES",
    "project_files_edited": "NO",
    "ACTIVE_GUIDES_edited": "NO",
    "CURRENT_TRUTH_INDEX_edited": "NO",
    "files_deleted": "NO",
    "files_moved": "NO",
    "files_renamed": "NO",
    "scripts_from_scanned_folders_executed": "NO",
    "shortcuts_executed": "NO",
    "archives_extracted": "NO",
    "external_network_used": "NO",
    "public_url_created": "NO",
}


def utc_now() -> str:
    return _dt.datetime.now(_dt.UTC).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest().upper()


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest().upper()


def rel_for(root: Path, path: Path) -> str:
    return str(path.relative_to(root)).replace("\\", "/")


def is_suspicious_name(path: Path) -> bool:
    name = path.name.lower()
    return any(part in name for part in SUSPICIOUS_NAMES)


def is_safe_text_path(path: Path) -> bool:
    return path.suffix.lower() in SAFE_TEXT_EXTENSIONS and path.suffix.lower() not in BLOCKED_EXTENSIONS


def role_guess(path: Path) -> str:
    name = path.name.lower()
    suffix = path.suffix.lower()
    if suffix in BLOCKED_EXTENSIONS:
        return "BLOCKED_METADATA_ONLY"
    if is_suspicious_name(path):
        return "SUSPICIOUS_NAME_METADATA_ONLY"
    if "receipt" in name:
        return "RECEIPT"
    if "manifest" in name:
        return "MANIFEST"
    if "index" in name:
        return "INDEX"
    if "backup" in name:
        return "BACKUP"
    if "current_truth_index" in name:
        return "CURRENT_TRUTH_INDEX_COPY_OR_ACTIVE"
    if name in {"agents.md", "agents.txt"}:
        return "LOCAL_BRIDGE_GUIDANCE"
    if suffix in SAFE_TEXT_EXTENSIONS:
        return "SAFE_TEXT"
    return "METADATA_ONLY"


def safe_resolve(root_label: str, rel_path: str) -> tuple[Path | None, str | None]:
    root = APPROVED_ROOTS.get(root_label.upper())
    if root is None:
        return None, "UNKNOWN_ROOT"
    try:
        root_resolved = root.resolve(strict=True)
    except FileNotFoundError:
        return None, "ROOT_MISSING"
    rel_path = unquote(rel_path).replace("\\", "/")
    norm = posixpath.normpath(rel_path)
    if norm in {".", ""} or norm.startswith("../") or norm == ".." or posixpath.isabs(norm):
        return None, "PATH_TRAVERSAL_BLOCKED"
    candidate = (root_resolved / Path(norm)).resolve(strict=False)
    try:
        candidate.relative_to(root_resolved)
    except ValueError:
        return None, "PATH_TRAVERSAL_BLOCKED"
    return candidate, None


def scan_roots() -> dict:
    files = []
    folder_count = 0
    root_status = []
    errors = []
    for label, root in APPROVED_ROOTS.items():
        root_exists = root.exists()
        root_status.append({"label": label, "path": str(root), "exists": "YES" if root_exists else "NO"})
        if not root_exists:
            continue
        root_resolved = root.resolve()
        for dirpath, dirnames, filenames in os.walk(root_resolved):
            current = Path(dirpath)
            kept_dirs = []
            for dirname in dirnames:
                child = current / dirname
                try:
                    if child.is_symlink() or bool(child.stat().st_file_attributes & getattr(os, "FILE_ATTRIBUTE_REPARSE_POINT", 0)):
                        errors.append({"root": label, "path": rel_for(root_resolved, child), "error": "REPARSE_POINT_SKIPPED"})
                        continue
                except Exception as exc:
                    errors.append({"root": label, "path": str(child), "error": f"DIR_STAT_FAILED: {exc}"})
                    continue
                kept_dirs.append(dirname)
            dirnames[:] = kept_dirs
            folder_count += len(kept_dirs)
            for filename in filenames:
                path = current / filename
                try:
                    if path.is_symlink():
                        errors.append({"root": label, "path": rel_for(root_resolved, path), "error": "SYMLINK_FILE_SKIPPED"})
                        continue
                    stat = path.stat()
                    files.append({
                        "root": label,
                        "relative_path": rel_for(root_resolved, path),
                        "size_bytes": stat.st_size,
                        "modified_utc": _dt.datetime.fromtimestamp(stat.st_mtime, _dt.UTC).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
                        "sha256": sha256_file(path),
                        "mode": "file",
                        "role_guess": role_guess(path),
                    })
                except Exception as exc:
                    errors.append({"root": label, "path": str(path), "error": f"FILE_SCAN_FAILED: {exc}"})
    files.sort(key=lambda item: (item["root"], item["relative_path"].lower()))
    return {
        "bridge_name": BRIDGE_NAME,
        "version": VERSION,
        "generated_utc": utc_now(),
        "approved_roots": root_status,
        "file_count": len(files),
        "folder_count": folder_count,
        "files": files,
        "scan_errors": errors,
        "no_action_boundaries": NO_ACTION_BOUNDARIES,
    }


def load_checkpoint() -> dict | None:
    if not CHECKPOINT_PATH.exists():
        return None
    with CHECKPOINT_PATH.open("r", encoding="utf-8") as f:
        return json.load(f)


def key_for(item: dict) -> str:
    return f"{item['root']}::{item['relative_path']}"


def file_metadata_refusal(root_label: str, rel_path: str, reason: str, path: Path | None = None) -> dict:
    payload = {"allowed": "NO", "reason": reason, "root": root_label, "relative_path": rel_path}
    if path and path.exists() and path.is_file():
        try:
            stat = path.stat()
            payload.update({
                "size_bytes": stat.st_size,
                "modified_utc": _dt.datetime.fromtimestamp(stat.st_mtime, _dt.UTC).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
                "sha256": sha256_file(path),
                "role_guess": role_guess(path),
            })
        except Exception as exc:
            payload["metadata_error"] = str(exc)
    return payload


def maybe_text_content(root_label: str, rel_path: str, sha256_value: str | None = None) -> dict:
    path, err = safe_resolve(root_label, rel_path)
    if err:
        return file_metadata_refusal(root_label, rel_path, err, path)
    if not path or not path.exists() or not path.is_file():
        return file_metadata_refusal(root_label, rel_path, "FILE_NOT_FOUND", path)
    if is_suspicious_name(path):
        return file_metadata_refusal(root_label, rel_path, "SUSPICIOUS_NAME_METADATA_ONLY", path)
    if path.suffix.lower() in BLOCKED_EXTENSIONS:
        return file_metadata_refusal(root_label, rel_path, "BLOCKED_EXTENSION_METADATA_ONLY", path)
    if not is_safe_text_path(path):
        return file_metadata_refusal(root_label, rel_path, "NOT_SAFE_TEXT_EXTENSION", path)
    stat = path.stat()
    if stat.st_size > SIZE_CAP:
        return file_metadata_refusal(root_label, rel_path, "SIZE_CAP_METADATA_ONLY", path)
    data = path.read_bytes()
    if b"\x00" in data:
        return file_metadata_refusal(root_label, rel_path, "BINARY_CONTENT_METADATA_ONLY", path)
    text = data.decode("utf-8", errors="replace")
    return {
        "allowed": "YES",
        "root": root_label,
        "relative_path": rel_path,
        "size_bytes": stat.st_size,
        "modified_utc": _dt.datetime.fromtimestamp(stat.st_mtime, _dt.UTC).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
        "sha256": sha256_value or sha256_bytes(data),
        "content": text,
    }


def build_delta() -> dict:
    current = scan_roots()
    checkpoint = load_checkpoint()
    current_map = {key_for(item): item for item in current["files"]}
    old_map = {key_for(item): item for item in checkpoint.get("files", [])} if checkpoint else {}
    new_files = []
    changed_files = []
    missing_files = []
    unchanged_count = 0
    for key, item in current_map.items():
        old = old_map.get(key)
        if old is None:
            entry = dict(item)
            entry["safe_text"] = maybe_text_content(item["root"], item["relative_path"], item["sha256"])
            new_files.append(entry)
        elif old.get("sha256") != item.get("sha256") or old.get("size_bytes") != item.get("size_bytes"):
            entry = dict(item)
            entry["previous_sha256"] = old.get("sha256")
            entry["safe_text"] = maybe_text_content(item["root"], item["relative_path"], item["sha256"])
            changed_files.append(entry)
        else:
            unchanged_count += 1
    for key, old in old_map.items():
        if key not in current_map:
            missing_files.append(old)
    return {
        "generated_utc": utc_now(),
        "checkpoint_exists": "YES" if checkpoint else "NO",
        "new_files": new_files,
        "changed_files": changed_files,
        "missing_files": missing_files,
        "unchanged_count": unchanged_count,
        "clean_rule": "Delta is evidence, not truth. Detection is not promotion.",
        "no_action_boundaries": NO_ACTION_BOUNDARIES,
    }


class Handler(BaseHTTPRequestHandler):
    server_version = "CleanSeedLivePullBridgeV1/1.0"

    def log_message(self, fmt: str, *args) -> None:
        return

    def send_json(self, payload: dict, status: int = 200) -> None:
        body = json.dumps(payload, indent=2, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self) -> None:
        parsed = urlparse(self.path)
        try:
            if parsed.path == "/status":
                manifest = scan_roots()
                self.send_json({
                    "bridge_name": BRIDGE_NAME,
                    "version": VERSION,
                    "server_running": "YES",
                    "bind_host": self.server.server_address[0],
                    "port": self.server.server_address[1],
                    "approved_roots": manifest["approved_roots"],
                    "current_file_count": manifest["file_count"],
                    "current_folder_count": manifest["folder_count"],
                    "checkpoint_exists": "YES" if CHECKPOINT_PATH.exists() else "NO",
                    "checkpoint_path": str(CHECKPOINT_PATH),
                    "no_action_boundaries": NO_ACTION_BOUNDARIES,
                })
            elif parsed.path == "/manifest":
                self.send_json(scan_roots())
            elif parsed.path == "/delta":
                self.send_json(build_delta())
            elif parsed.path == "/file":
                qs = parse_qs(parsed.query)
                root = qs.get("root", [""])[0].upper()
                rel = qs.get("path", [""])[0]
                path, err = safe_resolve(root, rel)
                if err:
                    self.send_json(file_metadata_refusal(root, rel, err, path), status=400)
                else:
                    payload = maybe_text_content(root, rel)
                    self.send_json(payload, status=200 if payload.get("allowed") == "YES" else 403)
            else:
                self.send_json({"error": "NOT_FOUND"}, status=404)
        except Exception as exc:
            self.send_json({"error": "SERVER_ERROR", "detail": str(exc)}, status=500)

    def do_POST(self) -> None:
        parsed = urlparse(self.path)
        if parsed.path != "/checkpoint":
            self.send_json({"error": "NOT_FOUND"}, status=404)
            return
        try:
            manifest = scan_roots()
            CHECKPOINT_PATH.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
            self.send_json({
                "checkpoint_path": str(CHECKPOINT_PATH),
                "timestamp": utc_now(),
                "counts": {"files": manifest["file_count"], "folders": manifest["folder_count"]},
                "checkpoint_sha256": sha256_file(CHECKPOINT_PATH),
                "files_deleted": "NO",
                "files_moved": "NO",
                "files_renamed": "NO",
                "project_files_edited": "NO",
                "ACTIVE_GUIDES_edited": "NO",
                "CURRENT_TRUTH_INDEX_edited": "NO",
                "clean_rule": "Checkpoint is bridge evidence only. It is not active doctrine and not promotion.",
            })
        except Exception as exc:
            self.send_json({"error": "CHECKPOINT_FAILED", "detail": str(exc)}, status=500)


def main() -> int:
    parser = argparse.ArgumentParser(description="CleanSeed Live Pull Bridge V1")
    parser.add_argument("--host", default=DEFAULT_HOST)
    parser.add_argument("--port", type=int, default=DEFAULT_PORT)
    args = parser.parse_args()
    if args.host != DEFAULT_HOST:
        raise SystemExit("BLOCKED: host must be 127.0.0.1")
    PID_PATH.write_text(str(os.getpid()), encoding="ascii")
    server = ThreadingHTTPServer((args.host, args.port), Handler)
    print(f"{BRIDGE_NAME} v{VERSION} running on http://{args.host}:{args.port}", flush=True)
    try:
        server.serve_forever()
    finally:
        server.server_close()
        try:
            PID_PATH.unlink(missing_ok=True)
        except Exception:
            pass
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
