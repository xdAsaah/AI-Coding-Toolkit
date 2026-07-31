#!/bin/bash
# AI Coding Toolkit 一键安装脚本

set -e

echo "========================================="
echo "  AI Coding Toolkit Installer"
echo "========================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 检测目标目录
if [ -d ".trae/skills" ] || [ -f ".trae/config.json" ]; then
    TARGET=".trae/skills"
    IDE="Trae"
elif [ -d ".claude/skills" ] || [ -f ".claude/config.json" ]; then
    TARGET=".claude/skills"
    IDE="Claude Code"
else
    echo "未检测到已安装的IDE，请选择："
    echo "1) Trae"
    echo "2) Claude Code"
    read -p "请输入选项 (1/2): " choice

    case $choice in
        1) TARGET=".trae/skills"; IDE="Trae";;
        2) TARGET=".claude/skills"; IDE="Claude Code";;
        *) echo "无效选项"; exit 1;;
    esac
fi

echo "检测到: $IDE"
echo "安装目录: $TARGET"
echo ""

# 创建目录
mkdir -p "$TARGET"
mkdir -p docs/templates

# 安装Superpowers技能
echo "[1/3] 安装工程纪律技能 (Superpowers)..."
cp -r "$PROJECT_ROOT/skills/superpowers/"* "$TARGET/"
echo "  14个技能已安装"

# 安装文档驱动技能
echo "[2/3] 安装文档驱动技能 (Doc-Driven)..."
cp -r "$PROJECT_ROOT/skills/doc-driven/"* "$TARGET/"
echo "  7个技能已安装"

# 安装文档模板
echo "[3/3] 安装文档模板..."
cp -r "$PROJECT_ROOT/templates/"* docs/templates/
echo "  4个模板已安装"

echo ""
echo "========================================="
echo "  安装完成！"
echo "========================================="
echo ""
echo "已安装 $IDE 的 21 个技能："
echo "  - 14 个工程纪律技能 (Superpowers)"
echo "  - 7 个文档驱动技能 (Doc-Driven)"
echo "  - 4 个文档模板"
echo ""
echo "下一步："
echo "1. 创建CLAUDE.md: 说'创建项目'触发claude-md-creator"
echo "2. 开始开发: 说'创建一个XXX应用'启动完整工作流"
echo ""
