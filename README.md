# Bildserver – E-Motion Rennteam Aalen e.V.

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

## Hinweise

- Max. 8 MB pro Bild (Limit der Website-Upload-Route).
- Bilder niemals überschreiben – neue Datei = neue URL (Cache bei GitHub Raw ca. 5 Min.).
- Repo-Größe im Blick behalten (GitHub empfiehlt < 5 GB).
