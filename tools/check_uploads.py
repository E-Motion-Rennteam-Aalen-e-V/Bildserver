#!/usr/bin/env python3
"""Prüft uploads/ auf kaputte Bilder (0 Byte, falsches Format).

Nutzung:
  python3 tools/check_uploads.py                 # Arbeitsverzeichnis prüfen
  python3 tools/check_uploads.py --history       # zusätzlich: welcher Commit hat die Datei eingeführt
Exit-Code 1, wenn Probleme gefunden wurden.
"""
import os, subprocess, sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'uploads')
SKIP_NAMES = {'.gitkeep', 'security.txt'}
MAGIC = {
    '.jpg': lambda b: b[:3] == b'\xff\xd8\xff',
    '.jpeg': lambda b: b[:3] == b'\xff\xd8\xff',
    '.png': lambda b: b[:8] == b'\x89PNG\r\n\x1a\n',
    '.gif': lambda b: b[:4] == b'GIF8',
    '.webp': lambda b: b[:4] == b'RIFF' and b[8:12] == b'WEBP',
}

def problems():
    empty, badfmt = [], []
    for dp, dns, fns in os.walk(ROOT):
        dns[:] = [d for d in dns if d != '.well-known']
        for fn in fns:
            if fn in SKIP_NAMES or fn.startswith('.'):
                continue
            p = os.path.join(dp, fn)
            rel = os.path.relpath(p, os.path.join(ROOT, '..'))
            if os.path.getsize(p) == 0:
                empty.append(rel); continue
            ext = os.path.splitext(fn)[1].lower()
            if ext in MAGIC:
                with open(p, 'rb') as f:
                    head = f.read(16)
                if not MAGIC[ext](head):
                    badfmt.append(rel)
    return sorted(empty), sorted(badfmt)

def introduced_by(path):
    out = subprocess.run(['git', 'log', '--all', '--diff-filter=A', '--format=%h %cs %s', '--', path],
                         capture_output=True, text=True).stdout.strip().splitlines()
    return out[-1] if out else 'unbekannt'

def main():
    empty, badfmt = problems()
    hist = '--history' in sys.argv
    for title, items in (('0 Byte', empty), ('Format passt nicht', badfmt)):
        if items:
            print(f'FEHLER {title}: {len(items)}')
            for p in items:
                extra = f'  <- {introduced_by(p)}' if hist else ''
                print(f'  {p}{extra}')
    if empty or badfmt:
        print(f'\n{len(empty) + len(badfmt)} Problem(e). Originale neu hochladen, dann erneut prüfen.')
        return 1
    print('OK: alle Uploads sind nicht leer und haben ein gültiges Bildformat.')
    return 0

if __name__ == '__main__':
    sys.exit(main())
