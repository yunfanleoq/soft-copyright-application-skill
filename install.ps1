# 安装到 Cursor 全局技能目录：~/.cursor/skills/soft-copyright-application/
$ErrorActionPreference = "Stop"
$Src = $PSScriptRoot
$Dest = Join-Path $env:USERPROFILE ".cursor\skills\soft-copyright-application"

Write-Host "安装 soft-copyright-application Skill" -ForegroundColor Cyan
Write-Host "  源: $Src"
Write-Host "  目标: $Dest"

New-Item -ItemType Directory -Force -Path (Split-Path $Dest -Parent) | Out-Null
if (Test-Path $Dest) {
    Remove-Item -Recurse -Force $Dest
}

$exclude = @(".git", ".github")
Get-ChildItem -Path $Src -Force | Where-Object { $exclude -notcontains $_.Name } | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $Dest -Recurse -Force
}

Write-Host "安装 Python 依赖..." -ForegroundColor Cyan
py -3.12 -m pip install -r (Join-Path $Dest "requirements.txt")

Write-Host ""
Write-Host "完成。请重启 Cursor，或在项目中运行：" -ForegroundColor Green
Write-Host "  py -3.12 $Dest\scripts\init_soft_copyright_scope.py" -ForegroundColor Gray
