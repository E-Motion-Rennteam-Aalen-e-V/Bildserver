# sync.ps1 – Lokale Bilder in den Bildserver pushen
# Ausführung: .\sync.ps1  (im Clone-Verzeichnis, z. B. H:\Bildserver)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
Set-Location $root

git add uploads

$status = git status --porcelain
if (-not $status) {
    Write-Host "Keine Änderungen – nichts zu pushen." -ForegroundColor Yellow
    exit 0
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "sync: Bilder hochladen $timestamp"
git push -u origin main

Write-Host "Fertig. Bilder sind jetzt im Bildserver." -ForegroundColor Green
