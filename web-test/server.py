from http.server import HTTPServer, SimpleHTTPRequestHandler

class WebHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Content-Security-Policy", "script-src 'self' 'unsafe-eval';")
        super().end_headers()

server = HTTPServer(("localhost", 8000), WebHandler)

print("Fantasy Computer 128 - Web Test")
print("http://localhost:8000")

server.serve_forever()
