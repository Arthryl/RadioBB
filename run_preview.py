import http.server
import socketserver
import webbrowser
import os
import sys
import urllib.request

# Ensure UTF-8 output if possible
if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

PORT = 8080
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def do_GET(self):
        # Proxy endpoint dla pobierania aktualnie granego utworu bez blokady CORS
        if self.path == '/api/now-playing':
            try:
                req = urllib.request.Request(
                    'https://radiobb.pl/wp-json/radio-bb/v1/now-playing',
                    headers={'User-Agent': 'RadioBB-Preview/1.0'}
                )
                with urllib.request.urlopen(req, timeout=5) as resp:
                    data = resp.read()
                self.send_response(200)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
                self.end_headers()
                self.wfile.write(data)
                return
            except Exception as e:
                self.send_response(500)
                self.send_header('Content-Type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(b'{"error": "Failed to fetch metadata"}')
                return

        super().do_GET()

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        super().end_headers()

def main():
    os.chdir(DIRECTORY)
    socketserver.TCPServer.allow_reuse_address = True
    
    # Próba uruchomienia na porcie 8080 lub alternatywnym
    selected_port = PORT
    httpd = None
    for p in [8080, 8081, 8082, 8090, 5000]:
        try:
            httpd = socketserver.TCPServer(("", p), Handler)
            selected_port = p
            break
        except OSError:
            continue

    if not httpd:
        print("[BLAD] Nie udalo sie otworzyc zadnego wolnego portu HTTP.")
        sys.exit(1)

    with httpd:
        url_local = f"http://localhost:{selected_port}/preview/index.html"
        url_ip = f"http://127.0.0.1:{selected_port}/preview/index.html"
        print("=" * 65)
        print(" [RADIO BB] - Podglad Aplikacji Mobilnej (Android Preview)")
        print(f" Adres lokalny: {url_local}")
        print(f" Adres IP:      {url_ip}")
        print(" Serwer dziala pomyslnie. Otwieram przegladarke...")
        print(" Nacisnij Ctrl+C w tym oknie, aby zakonczyc dzialanie serwera.")
        print("=" * 65)
        sys.stdout.flush()
        try:
            webbrowser.open(url_local)
        except Exception:
            pass

        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nZatrzymano serwer podgladu.")
            sys.exit(0)

if __name__ == '__main__':
    main()
