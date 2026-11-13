# sync.ps1 – Lokale Bilder in den Bildserver pushen
# Ausführung: .\sync.ps1  (im Clone-Verzeichnis, z. B. H:\Bildserver)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Git über vollen Pfad aufrufen, falls nicht im PATH
$gitExe = 'git'
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    $fallback = 'C:\Program Files\Git\cmd\git.exe'
    if (Test-Path $fallback) {
        $gitExe = $fallback
    } else {
        Write-Error "git.exe nicht gefunden. Bitte Git installieren oder den PATH anpassen."
        exit 1
    }
}

function Invoke-Git {
    & $gitExe @args
    if ($LASTEXITCODE -ne 0) { throw "git $args schlug fehl (Exit $LASTEXITCODE)" }
}

$root = $PSScriptRoot
Set-Location $root

# Vor dem Commit erst pullen, um Push-Konflikte mit CMS-Commits zu vermeiden
Invoke-Git pull --rebase --autostash

# Guard: leere Dateien (0 Byte) nie committen – sonst sind die Bilder auf der Website kaputt
$empty = Get-ChildItem -Path (Join-Path $root 'uploads') -Recurse -File |
    Where-Object { $_.Length -eq 0 -and $_.Name -ne '.gitkeep' -and -not $_.Name.StartsWith('.') }
if ($empty) {
    Write-Host "Abbruch: $($empty.Count) leere Datei(en) in uploads/:" -ForegroundColor Red
    $empty | ForEach-Object { Write-Host "  $($_.FullName)" -ForegroundColor Red }
    Write-Host "Originale neu kopieren (oder Platzhalter/OneDrive-Dateien vorher laden) und erneut ausführen." -ForegroundColor Red
    exit 1
}

Invoke-Git add uploads

# Nur prüfen, ob uploads/ gestagede Änderungen hat (nicht andere Dateien im Repo)
$status = & $gitExe diff --cached --name-only -- uploads
if (-not $status) {
    Write-Host "Keine Änderungen – nichts zu pushen." -ForegroundColor Yellow
    exit 0
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Invoke-Git commit -m "sync: Bilder hochladen $timestamp"
Invoke-Git push -u origin main

Write-Host "Fertig. Bilder sind jetzt im Bildserver." -ForegroundColor Green
