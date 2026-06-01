# 首次发布到 GitHub（需先 gh auth login）
$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot
$Gh = Get-ChildItem -Path "$env:LOCALAPPDATA\gh-cli" -Recurse -Filter gh.exe -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

if (-not $Gh) {
    Write-Host "未找到 gh CLI。请先运行：" -ForegroundColor Yellow
    Write-Host '  Invoke-WebRequest -Uri "https://github.com/cli/cli/releases/latest/download/gh_windows_amd64.zip" -OutFile "$env:TEMP\gh.zip"' -ForegroundColor Gray
    Write-Host '  Expand-Archive "$env:TEMP\gh.zip" "$env:LOCALAPPDATA\gh-cli"' -ForegroundColor Gray
    exit 1
}

& $Gh auth status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "请先登录 GitHub：" -ForegroundColor Yellow
    Write-Host "  & `"$Gh`" auth login" -ForegroundColor Cyan
    exit 1
}

Set-Location $RepoRoot
$Name = "soft-copyright-application-skill"
if (git remote get-url origin 2>$null) {
    Write-Host "已有 origin，执行 push..." -ForegroundColor Cyan
    git push -u origin main
} else {
    & $Gh repo create $Name --public `
        --description "Cursor Agent Skill for China software copyright (软著) application materials" `
        --source=. `
        --remote=origin `
        --push
}

Write-Host ""
Write-Host "仓库地址：" -ForegroundColor Green
& $Gh repo view --web 2>$null
& $Gh repo view --json url -q .url
