#!/bin/bash
# AI Coding Toolkit one-click install script
# Supports: Claude Code / Trae / Codex CLI / Gemini CLI / Cursor

set -e

echo "========================================="
echo "  AI Coding Toolkit Installer"
echo "========================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Detection rules: marker file/dir -> skills dir -> instruction file -> tool name
detect_tool() {
    if [ -d ".claude/skills" ] || [ -f ".claude/config.json" ]; then
        echo ".claude/skills|CLAUDE.md|Claude Code"
    elif [ -d ".trae/skills" ] || [ -f ".trae/config.json" ]; then
        echo ".trae/skills|CLAUDE.md|Trae"
    elif [ -d ".agents/skills" ] || [ -f "AGENTS.md" ]; then
        echo ".agents/skills|AGENTS.md|Codex CLI"
    elif [ -d ".gemini/skills" ] || [ -f "GEMINI.md" ]; then
        echo ".gemini/skills|GEMINI.md|Gemini CLI"
    elif [ -d ".cursor/skills" ] || [ -f ".cursorrules" ]; then
        echo ".cursor/skills|.cursorrules|Cursor"
    else
        echo ""
    fi
}

DETECTED=$(detect_tool)

if [ -z "$DETECTED" ]; then
    echo "No supported IDE detected. Please choose:"
    echo "1) Claude Code   (.claude/skills/,  CLAUDE.md)"
    echo "2) Trae          (.trae/skills/,   CLAUDE.md)"
    echo "3) Codex CLI     (.agents/skills/, AGENTS.md)"
    echo "4) Gemini CLI    (.gemini/skills/, GEMINI.md)"
    echo "5) Cursor        (.cursor/skills/, .cursorrules)"
    read -p "Enter option (1-5): " choice

    case $choice in
        1) TARGET=".claude/skills"; IDE="Claude Code" ;;
        2) TARGET=".trae/skills";   IDE="Trae" ;;
        3) TARGET=".agents/skills"; IDE="Codex CLI" ;;
        4) TARGET=".gemini/skills"; IDE="Gemini CLI" ;;
        5) TARGET=".cursor/skills"; IDE="Cursor" ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
else
    TARGET=$(echo "$DETECTED" | cut -d'|' -f1)
    INSTR_FILE=$(echo "$DETECTED" | cut -d'|' -f2)
    IDE=$(echo "$DETECTED" | cut -d'|' -f3)
fi

echo "Detected: $IDE"
echo "Skills dir: $TARGET"
echo ""

# Create directories
mkdir -p "$TARGET"
mkdir -p docs/templates

# Install Superpowers skills
echo "[1/3] Installing engineering discipline skills (Superpowers)..."
cp -r "$PROJECT_ROOT/skills/superpowers/"* "$TARGET/"
echo "  14 skills installed"

# Install doc-driven skills
echo "[2/3] Installing document-driven skills (Doc-Driven)..."
cp -r "$PROJECT_ROOT/skills/doc-driven/"* "$TARGET/"
echo "  7 skills installed"

# Install document templates
echo "[3/3] Installing document templates..."
cp -r "$PROJECT_ROOT/templates/"* docs/templates/
echo "  4 templates installed"

echo ""
echo "========================================="
echo "  Installation complete!"
echo "========================================="
echo ""
echo "Installed 21 skills for $IDE:"
echo "  - 14 engineering discipline skills (Superpowers)"
echo "  - 7 document-driven skills (Doc-Driven)"
echo "  - 4 document templates"
echo ""
echo "Next steps:"
echo "1. Create instruction file: say 'create project' to trigger claude-md-creator"
echo "   (Generates CLAUDE.md / AGENTS.md / GEMINI.md depending on tool)"
echo "2. Start development: say 'create a XXX app' to launch the full workflow"
echo ""
