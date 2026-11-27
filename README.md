# AI Coding Toolkit

**English** | [简体中文](./README.zh-CN.md)

A complete AI coding skill pack combining engineering discipline (Superpowers) with document-driven development.

A one-stop solution: install one repository and get 21 skills covering the full development workflow.

Compatible with **Claude Code**, **Trae**, **Codex CLI**, **Gemini CLI**, **Cursor**, and any tool that reads `SKILL.md` files.

---

## What's Included

### Engineering Discipline Skills (from Superpowers, 14)

| Skill | Function |
|-------|----------|
| brainstorming | Requirement clarification, enforced upfront design |
| writing-plans | Task breakdown, 2-5 min granularity |
| test-driven-development | TDD enforcement, red-green-refactor |
| subagent-driven-development | Sub-agent parallel development |
| executing-plans | Plan execution |
| requesting-code-review | Request code review |
| receiving-code-review | Respond to code review feedback |
| finishing-a-development-branch | Branch wrap-up |
| systematic-debugging | Systematic debugging |
| verification-before-completion | Verification before completion |
| using-git-worktrees | Git worktree management |
| dispatching-parallel-agents | Parallel agent dispatch |
| writing-skills | Write skills |
| using-superpowers | Core orchestration (enhanced, integrates doc-driven flow) |

### Document-Driven Skills (original, 7)

| Skill | Function |
|-------|----------|
| claude-md-creator | Create CLAUDE.md and project indexes |
| non-goals-clarify | Non-Goals confirmation, prevent over-engineering |
| prd-generator | PRD generation, scenario completeness check |
| adr-creator | ADR creation, intelligent trigger filtering |
| doc-checker | Document consistency check, compatible-change safety valve |
| spec-sync | Change impact analysis, AI discovers / human decides |
| spec-archive | Spec archiving, document lifecycle closure |

---

## Quick Start

### One-Click Install

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

The install script will:
1. Auto-detect your IDE (Claude Code / Trae / Codex CLI / Gemini CLI)
2. Copy all 21 skills to the correct skills directory
3. Copy document templates to `docs/templates/`
4. Print next-step guidance

### Manual Install

Skills are plain `SKILL.md` files and work with any compatible tool. Copy them into your tool's skills directory:

| Tool | Skills Directory | Instruction File |
|------|-----------------|-----------------|
| **Claude Code** | `.claude/skills/` | `CLAUDE.md` |
| **Trae** | `.trae/skills/` | `CLAUDE.md` |
| **Codex CLI** | `.agents/skills/` (global: `~/.agents/skills/`) | `AGENTS.md` |
| **Gemini CLI** | `.gemini/skills/` | `GEMINI.md` |
| **Cursor** | `.cursor/skills/` | `.cursorrules` |

```bash
# Example: Claude Code
cp -r skills/superpowers/* .claude/skills/
cp -r skills/doc-driven/*  .claude/skills/
cp -r templates/*          docs/templates/

# Example: Codex CLI (project-level)
mkdir -p .agents/skills
cp -r skills/superpowers/* .agents/skills/
cp -r skills/doc-driven/*  .agents/skills/
cp -r templates/*          docs/templates/

# Example: Trae
cp -r skills/superpowers/* .trae/skills/
cp -r skills/doc-driven/*  .trae/skills/
cp -r templates/*          docs/templates/
```

> **Note on instruction files:** `claude-md-creator` generates a `CLAUDE.md` by default. For Codex CLI, point it at `AGENTS.md`; for Gemini CLI, `GEMINI.md`. The content structure is identical across tools.

---

## Complete Workflow

```
User requirement
    ↓
read-index (load project indexes)                    [DD]
    ↓
brainstorming (requirement clarification)            [SP]
    ↓
non-goals-clarify (confirm what NOT to build)        [DD]
    ↓
prd-generator (generate PRD)                         [DD]
    ↓
adr-creator (record technical decisions, filtered)   [DD]
    ↓
writing-plans (task breakdown)                       [SP]
    ↓
subagent-driven-development (parallel dev)           [SP]
    ↓
test-driven-development (TDD)                        [SP]
    ↓
requesting-code-review (code review)                 [SP]
    ↓
doc-checker (document consistency check)             [DD]
    ↓
verification-before-completion (completion verify)   [SP]
    ↓
spec-sync (change impact analysis)                   [DD]
    ↓
spec-archive (archive spec)                          [DD]
    ↓
finishing-a-development-branch (branch wrap-up)     [SP]

SP = Superpowers skill
DD = Doc-Driven skill
```

---

## Design Principles

1. **CLAUDE.md is routing only** — details live in separate index files, loaded on demand
2. **AI discovers, human decides** — spec-sync never auto-updates documents
3. **Non-Goals prevent over-engineering** — explicitly state what NOT to build
4. **Size sensing** — light templates for small projects, full templates for large ones
5. **ADR intelligent filtering** — triggers only on key decisions, never spammy
6. **Complete document lifecycle** — creation → update → implementation → deprecation

---

## Repository Structure

```
ai-coding-toolkit/
├── skills/
│   ├── superpowers/          # 14 engineering discipline skills (from Superpowers)
│   └── doc-driven/           # 7 document-driven skills (original)
├── templates/                # 4 document templates (prd-full / prd-light / adr / spec)
├── docs/                     # project docs
├── scripts/                  # install scripts
├── README.md                 # English documentation
├── README.zh-CN.md           # Chinese documentation
├── LICENSE
└── CHANGELOG.md
```

---

## Uninstall

The installer only copies files into your project — nothing is registered globally and no system settings change. To remove the toolkit, delete what it copied:

- **Skills** — the 14 Superpowers directories (`brainstorming`, `writing-plans`, `test-driven-development`, `subagent-driven-development`, `executing-plans`, `requesting-code-review`, `receiving-code-review`, `finishing-a-development-branch`, `systematic-debugging`, `verification-before-completion`, `using-git-worktrees`, `dispatching-parallel-agents`, `writing-skills`, `using-superpowers`) and the 7 Doc-Driven ones (`claude-md-creator`, `non-goals-clarify`, `prd-generator`, `adr-creator`, `doc-checker`, `spec-sync`, `spec-archive`) from your tool's skills directory.
- **Templates** — the four files the installer placed in `docs/templates/`.
- **Clone** — the repository directory itself.

```bash
# Claude Code example; use .trae/skills, .agents/skills, .gemini/skills or .cursor/skills for other tools
rm -rf .claude/skills/{brainstorming,writing-plans,test-driven-development,subagent-driven-development,executing-plans,requesting-code-review,receiving-code-review,finishing-a-development-branch,systematic-debugging,verification-before-completion,using-git-worktrees,dispatching-parallel-agents,writing-skills,using-superpowers,claude-md-creator,non-goals-clarify,prd-generator,adr-creator,doc-checker,spec-sync,spec-archive}
rm -rf docs/templates
```

On Windows, delete the same directories with `Remove-Item` in PowerShell.

> The `CLAUDE.md` / `AGENTS.md` / `GEMINI.md` in your project is generated by the toolkit but owned by your project — keep it, it records your project's own decisions.

---

## Attribution

This toolkit includes skills from [Superpowers](https://github.com/obra/superpowers) by Jesse Vincent, licensed under MIT.

## License

MIT
