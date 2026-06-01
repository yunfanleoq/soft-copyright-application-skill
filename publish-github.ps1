# Publish to GitHub (run gh auth login first)
$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot
$Gh = $null
if (Get-Command gh -ErrorAction SilentlyContinue) {
    $Gh = (Get-Command gh).Source
}
if (-not $Gh) {
    $Gh = Get-ChildItem -Path "$env:LOCALAPPDATA\gh-cli", "C:\Program Files\GitHub CLI" -Recurse -Filter gh.exe -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
}

if (-not $Gh) {
    Write-Host "未找到 gh CLI。请先安装：" -ForegroundColor Yellow
    Write-Host "  winget install GitHub.cli" -ForegroundColor Cyan
    Write-Host "或下载: https://cli.github.com/" -ForegroundColor Cyan
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
