#!/usr/bin/env python3
"""
Minimal HTTP/HTTPS forward proxy for manually testing iCurlHTTP's
"Override System Proxy" setting (see Settings > Proxy Settings).

Usage:
    python3 proxy_server.py [port]        # default port 8899

Then in iCurlHTTP (Settings > Proxy Settings):
    - Enable "Override System Proxy"
    - Set Proxy to <your-mac's-lan-ip>:8899  (e.g. 192.168.1.42:8899)
    - Run a request (http:// or https://) and watch this terminal log it

Listens on both IPv4 (0.0.0.0) and IPv6 ([::]) on the same port. For an IPv6
literal address, bracket it: [fe80::1]:8899

Leaving the Proxy field blank with the override enabled forces iCurlHTTP to
bypass any proxy entirely (direct connection) - no server needed for that case.

Only standard library is used, no dependencies required.
"""
import socket
import sys
import threading
from http.server import BaseHTTPRequestHandler
from socketserver import ThreadingMixIn, TCPServer
import urllib.request
import urllib.error

DEFAULT_PORT = 8899
BUFFER_SIZE = 8192


class ProxyHandler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def log_message(self, fmt, *args):
        sys.stderr.write("[proxy] %s - %s\n" % (self.client_address[0], fmt % args))

    def do_CONNECT(self):
        # HTTPS: tunnel raw bytes between client and destination
        host, _, port = self.path.partition(":")
        port = int(port) if port else 443
        try:
            upstream = socket.create_connection((host, port), timeout=15)
        except OSError as e:
            self.send_error(502, f"Cannot connect to {host}:{port} ({e})")
            return

        self.send_response(200, "Connection Established")
        self.end_headers()

        client_socket = self.connection
        self._relay(client_socket, upstream)

    def _relay(self, client_socket, upstream):
        def pump(src, dst):
            try:
                while True:
                    data = src.recv(BUFFER_SIZE)
                    if not data:
                        break
                    dst.sendall(data)
            except OSError:
                pass
            finally:
                for s in (src, dst):
                    try:
                        s.shutdown(socket.SHUT_RDWR)
                    except OSError:
                        pass

        t1 = threading.Thread(target=pump, args=(client_socket, upstream), daemon=True)
        t2 = threading.Thread(target=pump, args=(upstream, client_socket), daemon=True)
        t1.start()
        t2.start()
        t1.join()
        t2.join()

    def _forward(self, method):
        # Plain HTTP: forward the request and relay the response
        # Always close after one response - we don't reuse the upstream connection, so
        # there's no benefit to HTTP/1.1 keep-alive here and it just makes clients wait.
        self.close_connection = True
        url = self.path
        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length) if length else None

        headers = {k: v for k, v in self.headers.items() if k.lower() not in ("proxy-connection", "connection")}

        req = urllib.request.Request(url, data=body, headers=headers, method=method)
        try:
            with urllib.request.urlopen(req, timeout=15) as resp:
                self.send_response(resp.status)
                for k, v in resp.getheaders():
                    if k.lower() not in ("transfer-encoding", "connection"):
                        self.send_header(k, v)
                self.send_header("Connection", "close")
                self.end_headers()
                self.wfile.write(resp.read())
        except urllib.error.HTTPError as e:
            self.send_response(e.code)
            self.end_headers()
            self.wfile.write(e.read() if e.fp else b"")
        except OSError as e:
            self.send_error(502, f"Upstream request failed ({e})")

    def do_GET(self):
        self._forward("GET")

    def do_POST(self):
        self._forward("POST")

    def do_HEAD(self):
        self._forward("HEAD")

    def do_PUT(self):
        self._forward("PUT")

    def do_DELETE(self):
        self._forward("DELETE")

    def do_OPTIONS(self):
        self._forward("OPTIONS")


class ThreadingHTTPServer(ThreadingMixIn, TCPServer):
    allow_reuse_address = True
    daemon_threads = True


class ThreadingHTTPServerV6(ThreadingHTTPServer):
    address_family = socket.AF_INET6

    def server_bind(self):
        # IPv6-only, so this can coexist with the separate IPv4 listener on the same port
        self.socket.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 1)
        super().server_bind()


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_PORT
    servers = []
    for server_cls, bind_addr, label in (
        (ThreadingHTTPServer, ("0.0.0.0", port), f"0.0.0.0:{port}"),
        (ThreadingHTTPServerV6, ("::", port), f"[::]:{port}"),
    ):
        try:
            servers.append((server_cls(bind_addr, ProxyHandler), label))
        except OSError as e:
            print(f"Skipping {label} ({e})")

    if not servers:
        sys.exit("Failed to bind on IPv4 or IPv6")

    print(f"Test proxy listening on {', '.join(label for _, label in servers)} (Ctrl+C to stop)")
    for server, _ in servers[1:]:
        threading.Thread(target=server.serve_forever, daemon=True).start()
    try:
        servers[0][0].serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        for server, _ in servers:
            server.shutdown()
