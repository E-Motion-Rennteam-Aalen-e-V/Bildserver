# Bildserver – E-Motion Rennteam Aalen e.V.

> ⚠️ AI-assisted – Die Anbindung dieses Bildservers an die Website wurde mit KI-Unterstützung (Claude) entwickelt und umgesetzt.

Bilder-Repo für die Website. GitHub = Entwicklung/Auslieferung, Codeberg = automatisches Backup.

```
CMS (Website) → POST /api/admin/upload → Commit in uploads/ (dieses Repo)
Website       → https://raw.githubusercontent.com/<owner>/<repo>/main/uploads/<datei>
Push (GitHub) → Action "Mirror to Codeberg" → Backup auf Codeberg
```

## Struktur

- `uploads/` – alle Bilder (JPG, PNG, WebP, GIF; Dateiname `<zeitstempel-ms>-<name>.<ext>`)
- `.github/workflows/mirror-codeberg.yml` – Mirror bei jedem Push

## Einrichtung

### 1. GitHub
1. Repo **public** stellen (Settings → General → Danger Zone → Change visibility). Raw-URLs privater Repos sind im Browser nicht ladbar.
2. Fine-grained Token (https://github.com/settings/tokens): nur dieses Repo, *Contents: Read and write* → `GITHUB_TOKEN_IMAGES` in der Website.

### 2. Website-Env
```
GITHUB_TOKEN_IMAGES=<token>
GITHUB_OWNER_IMAGES=E-Motion-Rennteam-Aalen-e-V
GITHUB_REPO_IMAGES=Bildserver
GITHUB_BRANCH_IMAGES=main
```
Details: `docs/bildserver.md` im Website-Repo.

### 3. Codeberg-Backup
1. Auf https://codeberg.org leeres Repo anlegen (z. B. `emotion-rennteam/emotion-rennteam-bilder`).
2. Codeberg → Settings → Applications → Access Token mit Scope `write:repository`.
3. GitHub-Repo → Settings → Secrets and variables → Actions:
   - Secret `CODEBERG_USERNAME` – Codeberg-Nutzername des Tokens
   - Secret `CODEBERG_TOKEN` – Token aus Schritt 2
   - Variable `CODEBERG_REPO` – `<codeberg-owner>/<repo>`
4. Actions → *Mirror to Codeberg* → *Run workflow* zum Testen.

## Lokaler Ablauf (Bilder manuell hochladen)

Bilder können direkt per Git in den Bildserver übertragen werden, ohne die CMS-Upload-Route zu nutzen.

1. Repo klonen (einmalig):
   ```powershell
   git clone https://github.com/E-Motion-Rennteam-Aalen-e-V/Bildserver H:\Bildserver
   ```
2. Bilder in `H:\Bildserver\uploads\` ablegen.
3. Skript ausführen:
   ```powershell
   cd H:\Bildserver
   .\sync.ps1
   ```
   Das Skript prüft, ob Änderungen vorhanden sind, erstellt einen Commit mit Zeitstempel und pusht nach `main`.

4. Die Raw-URL lautet dann:
   ```
   https://raw.githubusercontent.com/E-Motion-Rennteam-Aalen-e-V/Bildserver/main/uploads/<dateiname>
   ```
   Diese URL kann direkt in CMS-Feldern vom Typ „Bild" eingetragen werden.

## Hinweise

- Max. 8 MB pro Bild (Limit der Website-Upload-Route).
- Bilder niemals überschreiben – neue Datei = neue URL (Cache bei GitHub Raw ca. 5 Min.).
- Repo-Größe im Blick behalten (GitHub empfiehlt < 5 GB).
