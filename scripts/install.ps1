# AI Coding Toolkit one-click install script (Windows)
# Supports: Claude Code / Trae / Codex CLI / Gemini CLI / Cursor

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  AI Coding Toolkit Installer" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Split-Path -Parent $SCRIPT_DIR

# Detection rules: marker file/dir -> skills dir -> tool name
function Detect-Tool {
    if (Test-Path ".claude\skills") { return @(".claude\skills", "CLAUDE.md", "Claude Code") }
    if (Test-Path ".trae\skills")   { return @(".trae\skills",   "CLAUDE.md", "Trae") }
    if (Test-Path ".agents\skills") { return @(".agents\skills", "AGENTS.md", "Codex CLI") }
    if (Test-Path "AGENTS.md")      { return @(".agents\skills", "AGENTS.md", "Codex CLI") }
    if (Test-Path ".gemini\skills") { return @(".gemini\skills", "GEMINI.md", "Gemini CLI") }
    if (Test-Path "GEMINI.md")      { return @(".gemini\skills", "GEMINI.md", "Gemini CLI") }
    if (Test-Path ".cursor\skills") { return @(".cursor\skills", ".cursorrules", "Cursor") }
    if (Test-Path ".cursorrules")   { return @(".cursor\skills", ".cursorrules", "Cursor") }
    return $null
}

$detected = Detect-Tool

if (-not $detected) {
    Write-Host "No supported IDE detected. Please choose:" -ForegroundColor Yellow
    Write-Host "1) Claude Code   (.claude\skills\,  CLAUDE.md)"
    Write-Host "2) Trae          (.trae\skills\,    CLAUDE.md)"
    Write-Host "3) Codex CLI     (.agents\skills\,  AGENTS.md)"
    Write-Host "4) Gemini CLI    (.gemini\skills\,  GEMINI.md)"
    Write-Host "5) Cursor        (.cursor\skills\,  .cursorrules)"
    $choice = Read-Host "Enter option (1-5)"

    switch ($choice) {
        "1" { $TARGET = ".claude\skills"; $IDE = "Claude Code" }
        "2" { $TARGET = ".trae\skills";   $IDE = "Trae" }
        "3" { $TARGET = ".agents\skills"; $IDE = "Codex CLI" }
        "4" { $TARGET = ".gemini\skills"; $IDE = "Gemini CLI" }
        "5" { $TARGET = ".cursor\skills"; $IDE = "Cursor" }
        default { Write-Host "Invalid option" -ForegroundColor Red; exit 1 }
    }
} else {
    $TARGET = $detected[0]
    $IDE = $detected[2]
}

Write-Host "Detected: $IDE"
Write-Host "Skills dir: $TARGET"
Write-Host ""

# Create directories
New-Item -ItemType Directory -Force -Path $TARGET | Out-Null
New-Item -ItemType Directory -Force -Path "docs\templates" | Out-Null

# Install Superpowers skills
Write-Host "[1/3] Installing engineering discipline skills (Superpowers)..." -ForegroundColor Green
Copy-Item -Path "$PROJECT_ROOT\skills\superpowers\*" -Destination $TARGET -Recurse -Force
Write-Host "  14 skills installed"

# Install doc-driven skills
Write-Host "[2/3] Installing document-driven skills (Doc-Driven)..." -ForegroundColor Green
Copy-Item -Path "$PROJECT_ROOT\skills\doc-driven\*" -Destination $TARGET -Recurse -Force
Write-Host "  7 skills installed"

# Install document templates
Write-Host "[3/3] Installing document templates..." -ForegroundColor Green
Copy-Item -Path "$PROJECT_ROOT\templates\*" -Destination "docs\templates" -Recurse -Force
Write-Host "  4 templates installed"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Installation complete!" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed 21 skills for $IDE:"
Write-Host "  - 14 engineering discipline skills (Superpowers)"
Write-Host "  - 7 document-driven skills (Doc-Driven)"
Write-Host "  - 4 document templates"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Create instruction file: say 'create project' to trigger claude-md-creator"
Write-Host "   (Generates CLAUDE.md / AGENTS.md / GEMINI.md depending on tool)"
Write-Host "2. Start development: say 'create a XXX app' to launch the full workflow"
Write-Host ""
