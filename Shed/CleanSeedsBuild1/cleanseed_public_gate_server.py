import hashlib
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from urllib.parse import urlparse, parse_qs

PUBLIC_ROOT = Path.home() / "Desktop" / "CleanSeed_LiveBridge_V0" / "PUBLIC_GATE"
TOKEN_PATH = PUBLIC_ROOT / "TOKEN.txt"
LATEST_PATH = PUBLIC_ROOT / "LATEST_DELTA_UPLOAD_BUNDLE.txt"
STATUS_PATH = PUBLIC_ROOT / "STATUS.json"

def read_token():
    try:
        return TOKEN_PATH.read_text(encoding="utf-8-sig").strip()
    except Exception:
        return ""

def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest().upper()

class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        return

    def send_text(self, code, text, ctype="text/plain; charset=utf-8"):
        data = text.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(data)

    def authorized(self, qs):
        token = read_token()
        return token and qs.get("key", [""])[0] == token

    def do_GET(self):
        parsed = urlparse(self.path)
        qs = parse_qs(parsed.query)

        if parsed.path == "/":
            self.send_text(200, "CleanSeed Public Gate is running. Use /status?key=TOKEN or /latest?key=TOKEN.")
            return

        if not self.authorized(qs):
            self.send_text(403, "FORBIDDEN")
            return

        if parsed.path == "/status":
            status = {
                "gate": "CLEANSEED_PUBLIC_GATE_V0",
                "latest_exists": LATEST_PATH.exists(),
                "latest_path": str(LATEST_PATH),
            }

            if STATUS_PATH.exists():
                try:
                    status["watcher_status"] = json.loads(STATUS_PATH.read_text(encoding="utf-8-sig"))
                except Exception as e:
                    status["watcher_status_error"] = str(e)

            if LATEST_PATH.exists():
                status["latest_size_bytes"] = LATEST_PATH.stat().st_size
                status["latest_sha256"] = sha256_file(LATEST_PATH)

            self.send_text(200, json.dumps(status, indent=2), "application/json; charset=utf-8")
            return

        if parsed.path == "/latest":
            if not LATEST_PATH.exists():
                self.send_text(404, "NO LATEST DELTA BUNDLE YET")
                return
            self.send_text(200, LATEST_PATH.read_text(encoding="utf-8-sig"))
            return

        self.send_text(404, "NOT FOUND")

if __name__ == "__main__":
    PUBLIC_ROOT.mkdir(parents=True, exist_ok=True)
    print("CleanSeed Public Gate server running on http://127.0.0.1:8787")
    print("Keep this window open.")
    HTTPServer(("127.0.0.1", 8787), Handler).serve_forever()
