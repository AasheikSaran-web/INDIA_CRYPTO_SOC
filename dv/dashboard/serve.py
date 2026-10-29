#!/usr/bin/env python3
"""
serve.py — Serve CRIYA verification dashboard at http://localhost:8080
Run from dv/dashboard/: python3 serve.py
Or from dv/: python3 dashboard/serve.py
"""
import http.server, socketserver, subprocess, os, sys, json
from urllib.parse import urlparse

PORT = 8080
DASHBOARD_DIR = os.path.dirname(os.path.abspath(__file__))
DV_DIR = os.path.dirname(DASHBOARD_DIR)

class DashboardHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DASHBOARD_DIR, **kwargs)

    def do_GET(self):
        parsed = urlparse(self.path)
        if parsed.path == "/refresh":
            # Re-run collector and return updated JSON
            try:
                subprocess.run(
                    [sys.executable, os.path.join(DASHBOARD_DIR, "collect_results.py")],
                    cwd=DV_DIR, capture_output=True, timeout=30
                )
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.send_header("Access-Control-Allow-Origin", "*")
                self.end_headers()
                results_path = os.path.join(DASHBOARD_DIR, "results.json")
                if os.path.exists(results_path):
                    self.wfile.write(open(results_path, "rb").read())
                else:
                    self.wfile.write(b'{"error": "results.json not found"}')
            except Exception as e:
                self.send_error(500, str(e))
        elif parsed.path == "/results.json":
            # Serve the latest results.json directly
            results_path = os.path.join(DASHBOARD_DIR, "results.json")
            if os.path.exists(results_path):
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.send_header("Access-Control-Allow-Origin", "*")
                self.end_headers()
                self.wfile.write(open(results_path, "rb").read())
            else:
                self.send_error(404, "results.json not found — run collect_results.py first")
        else:
            super().do_GET()

    def log_message(self, fmt, *args):
        pass  # suppress request logging

os.chdir(DASHBOARD_DIR)
# Generate initial results
subprocess.run([sys.executable, os.path.join(DASHBOARD_DIR, "collect_results.py")],
               cwd=DV_DIR, capture_output=True)

with socketserver.TCPServer(("", PORT), DashboardHandler) as httpd:
    print(f"╔══════════════════════════════════════════════╗")
    print(f"║  CRIYA DV Dashboard  →  http://localhost:{PORT}  ║")
    print(f"╚══════════════════════════════════════════════╝")
    print(f"  Ctrl+C to stop")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
