# Publish to GitHub (run gh auth login first)
$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot
$Gh = Get-ChildItem -Path "$env:LOCALAPPDATA\gh-cli" -Recurse -Filter gh.exe -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

if (-not $Gh) {
    Write-Host "gh CLI not found under %LOCALAPPDATA%\gh-cli" -ForegroundColor Yellow
    exit 1
}

& $Gh auth status 1>$null 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Please login first:" -ForegroundColor Yellow
    Write-Host "  $Gh auth login" -ForegroundColor Cyan
    exit 1
}

Set-Location $RepoRoot
$Name = "soft-copyright-application-skill"
$hasOrigin = $false
git remote get-url origin 1>$null 2>$null
if ($LASTEXITCODE -eq 0) { $hasOrigin = $true }

if ($hasOrigin) {
    Write-Host "Pushing to origin..." -ForegroundColor Cyan
    git push -u origin main
} else {
    & $Gh repo create $Name --public `
        --description "Cursor Agent Skill for China software copyright application materials" `
        --source=. `
        --remote=origin `
        --push
}

Write-Host ""
Write-Host "Repo URL:" -ForegroundColor Green
& $Gh repo view --json url -q .url
