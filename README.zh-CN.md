# AI Coding Toolkit

[English](./README.md) | **简体中文**

完整的 AI Coding 技能包，融合工程纪律（Superpowers）与文档驱动开发。

一站式解决方案：安装一个仓库，获得 21 个技能的完整开发工作流。

兼容 **Claude Code**、**Trae**、**Codex CLI**、**Gemini CLI**、**Cursor** 以及任何读取 `SKILL.md` 文件的工具。

---

## 包含什么

### 工程纪律技能（来自 Superpowers，14 个）

| 技能 | 功能 |
|------|------|
| brainstorming | 需求澄清，强制前置设计 |
| writing-plans | 任务拆解，2-5 分钟粒度 |
| test-driven-development | TDD 强制，红灯-绿灯-重构 |
| subagent-driven-development | 子代理并行开发 |
| executing-plans | 计划执行 |
| requesting-code-review | 请求代码审查 |
| receiving-code-review | 接收代码审查反馈 |
| finishing-a-development-branch | 分支收尾 |
| systematic-debugging | 系统化调试 |
| verification-before-completion | 完成前验证 |
| using-git-worktrees | Git 工作树管理 |
| dispatching-parallel-agents | 并行代理分发 |
| writing-skills | 编写技能 |
| using-superpowers | 核心编排（增强版，集成文档驱动流程） |

### 文档驱动技能（原创，7 个）

| 技能 | 功能 |
|------|------|
| claude-md-creator | 创建 CLAUDE.md 和项目索引 |
| non-goals-clarify | Non-Goals 确认，防止过度实现 |
| prd-generator | PRD 生成，场景完整性检查 |
| adr-creator | ADR 创建，智能过滤触发 |
| doc-checker | 文档一致性检查，兼容变更安全阀 |
| spec-sync | 变更影响分析，AI 发现 / 人类决策 |
| spec-archive | Spec 归档，文档生命周期闭环 |

---

## 快速开始

### 一键安装

**Linux/macOS:**
```bash
git clone https://github.com/xdAsaah/AI-Coding-Toolkit.git
cd AI-Coding-Toolkit
./scripts/install.sh
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/xdAsaah/AI-Coding-Toolkit.git
cd AI-Coding-Toolkit
.\scripts\install.ps1
```

安装脚本会：
1. 自动检测你的工具（Claude Code / Trae / Codex CLI / Gemini CLI）
2. 复制所有 21 个技能到对应的 skills 目录
3. 复制文档模板到 `docs/templates/`
4. 输出下一步操作指引

### 手动安装

技能就是普通的 `SKILL.md` 文件，兼容任何支持该格式的工具。把它们复制到你的工具的 skills 目录即可：

| 工具 | Skills 目录 | 指令文件 |
|------|------------|---------|
| **Claude Code** | `.claude/skills/` | `CLAUDE.md` |
| **Trae** | `.trae/skills/` | `CLAUDE.md` |
| **Codex CLI** | `.agents/skills/`（全局：`~/.agents/skills/`） | `AGENTS.md` |
| **Gemini CLI** | `.gemini/skills/` | `GEMINI.md` |
| **Cursor** | `.cursor/skills/` | `.cursorrules` |

```bash
# 示例：Claude Code
cp -r skills/superpowers/* .claude/skills/
cp -r skills/doc-driven/*  .claude/skills/
cp -r templates/*          docs/templates/

# 示例：Codex CLI（项目级）
mkdir -p .agents/skills
cp -r skills/superpowers/* .agents/skills/
cp -r skills/doc-driven/*  .agents/skills/
cp -r templates/*          docs/templates/

# 示例：Trae
cp -r skills/superpowers/* .trae/skills/
cp -r skills/doc-driven/*  .trae/skills/
cp -r templates/*          docs/templates/
```

> **关于指令文件：** `claude-md-creator` 技能默认生成 `CLAUDE.md`。如果使用 Codex CLI，把它指向 `AGENTS.md`；Gemini CLI 指向 `GEMINI.md`。文件内容结构在各工具间完全一致。

---

## 完整工作流

```
用户需求
    ↓
read-index (读取项目索引)                            [DD]
    ↓
brainstorming (需求澄清)                             [SP]
    ↓
non-goals-clarify (确认不做哪些)                      [DD]
    ↓
prd-generator (生成 PRD)                             [DD]
    ↓
adr-creator (技术决策记录，智能过滤)                  [DD]
    ↓
writing-plans (任务拆解)                             [SP]
    ↓
subagent-driven-development (并行开发)               [SP]
    ↓
test-driven-development (TDD)                        [SP]
    ↓
requesting-code-review (代码审查)                    [SP]
    ↓
doc-checker (文档一致性检查)                          [DD]
    ↓
verification-before-completion (完成验证)             [SP]
    ↓
spec-sync (变更影响分析)                              [DD]
    ↓
spec-archive (归档 Spec)                             [DD]
    ↓
finishing-a-development-branch (分支收尾)            [SP]

SP = Superpowers 技能
DD = Doc-Driven 技能
```

---

## 设计原则

1. **CLAUDE.md 只做路由** — 详细信息放在单独索引文件，按需读取
2. **AI 发现，人类决策** — spec-sync 不自动更新文档
3. **Non-Goals 防过度实现** — 明确不做什么
4. **规模感应** — 小项目用简化模板，大项目用完整模板
5. **ADR 智能过滤** — 不泛滥，只在关键决策时触发
6. **文档生命周期完整** — 创建 → 更新 → 实现 → 废弃

---

## 仓库结构

```
ai-coding-toolkit/
├── skills/
│   ├── superpowers/          # 14 个工程纪律技能（来自 Superpowers）
│   └── doc-driven/           # 7 个文档驱动技能（原创）
├── templates/                # 4 个文档模板（prd-full / prd-light / adr / spec）
├── docs/                     # 项目文档
├── scripts/                  # 安装脚本
├── README.md                 # 英文文档
├── README.zh-CN.md           # 中文文档
├── LICENSE
└── CHANGELOG.md
```

---

## 致谢

本工具包包含来自 [Superpowers](https://github.com/obra/superpowers) 的技能，由 Jesse Vincent 创建，采用 MIT 许可证。

## 许可证

MIT
