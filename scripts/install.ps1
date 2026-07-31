# AI Coding Toolkit 一键安装脚本 (Windows)

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  AI Coding Toolkit Installer" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Split-Path -Parent $SCRIPT_DIR

# 检测目标目录
if (Test-Path ".trae\skills") {
    $TARGET = ".trae\skills"
    $IDE = "Trae"
} elseif (Test-Path ".claude\skills") {
    $TARGET = ".claude\skills"
    $IDE = "Claude Code"
} else {
    Write-Host "未检测到已安装的IDE，请选择：" -ForegroundColor Yellow
    Write-Host "1) Trae"
    Write-Host "2) Claude Code"
    $choice = Read-Host "请输入选项 (1/2)"

    switch ($choice) {
        "1" { $TARGET = ".trae\skills"; $IDE = "Trae" }
        "2" { $TARGET = ".claude\skills"; $IDE = "Claude Code" }
        default { Write-Host "无效选项" -ForegroundColor Red; exit 1 }
    }
}

Write-Host "检测到: $IDE"
Write-Host "安装目录: $TARGET"
Write-Host ""

# 创建目录
New-Item -ItemType Directory -Force -Path $TARGET | Out-Null
New-Item -ItemType Directory -Force -Path "docs\templates" | Out-Null

# 安装Superpowers技能
Write-Host "[1/3] 安装工程纪律技能 (Superpowers)..." -ForegroundColor Green
Copy-Item -Path "$PROJECT_ROOT\skills\superpowers\*" -Destination $TARGET -Recurse -Force
Write-Host "  14个技能已安装"

# 安装文档驱动技能
Write-Host "[2/3] 安装文档驱动技能 (Doc-Driven)..." -ForegroundColor Green
Copy-Item -Path "$PROJECT_ROOT\skills\doc-driven\*" -Destination $TARGET -Recurse -Force
Write-Host "  7个技能已安装"

# 安装文档模板
Write-Host "[3/3] 安装文档模板..." -ForegroundColor Green
Copy-Item -Path "$PROJECT_ROOT\templates\*" -Destination "docs\templates" -Recurse -Force
Write-Host "  4个模板已安装"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  安装完成！" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "已安装 $IDE 的 21 个技能："
Write-Host "  - 14 个工程纪律技能 (Superpowers)"
Write-Host "  - 7 个文档驱动技能 (Doc-Driven)"
Write-Host "  - 4 个文档模板"
Write-Host ""
Write-Host "下一步："
Write-Host "1. 创建CLAUDE.md: 说'创建项目'触发claude-md-creator"
Write-Host "2. 开始开发: 说'创建一个XXX应用'启动完整工作流"
Write-Host ""
