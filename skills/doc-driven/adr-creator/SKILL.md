---
name: adr-creator
description: Create Architecture Decision Records (ADR) to document technical decisions, their background, alternatives, and consequences.
---

# ADR Creator

## Overview

Create ADR documents to record technical decisions. ADRs explain why technical choices were made and provide context for future maintenance.

## When to Use

- User says "tech selection", "architecture decision", "technical solution"
- **Process hook:** After prd-generator completes, with intelligent filtering (before writing-plans)

## Inputs

- Read `docs/prd/features/{feature}.md` (PRD from prd-generator)
- Read `docs/superpowers/status/{feature}-status.md` (current feature status)
- Read `docs/doc-index.md` (check existing ADRs to avoid duplicates)

## Outputs

- `docs/arch/decisions/{sequence}-{title}.md` (ADR document)
- Update `docs/doc-index.md` (add new ADR entry)
- Update `docs/superpowers/status/{feature}-status.md`

## Intelligent Filtering Rules

Only trigger when PRD contains:
- ✅ New third-party dependencies (npm packages, pip packages, go modules)
- ✅ Cross-module boundary changes (modifying interfaces of multiple independent modules)
- ✅ Explicit technical selection or trade-offs (choosing between A and B)
- ✅ Architecture-level changes (microservice splitting, database migration)

Do NOT trigger for:
- ❌ Single module internal logic changes
- ❌ Bug fixes only
- ❌ Performance optimizations only

## Trigger Phrase

"本次PRD涉及[具体触发条件]，是否创建ADR记录技术决策？"

## Core Capabilities

1. Extract decision background
2. Analyze pros/cons of multiple alternatives
3. Record consequences (positive/negative)
4. Link to related decisions

## Workflow

### Step 1: Read PRD and Extract Decision Context
- Read `docs/prd/features/{feature}.md`
- Identify: What problem are we solving? What constraints exist?
- Identify: Are there technical selections that need documentation?

### Step 2: Identify Alternatives
- List all considered options
- For each option, describe pros and cons

### Step 3: Document Decision
- What was chosen?
- Why was this choice made over alternatives?

### Step 4: Record Consequences
- Positive impacts
- Negative impacts

### Step 5: Link Related Decisions
- Reference related ADRs
- Note any dependencies

### Step 6: Update doc-index.md

Add new ADR entry to `docs/doc-index.md` ADR section:

```markdown
## ADR 文档
| 序号 | 标题 | 文件路径 | 状态 |
|------|------|---------|------|
| {seq} | {title} | docs/arch/decisions/{seq}-{title}.md | 已接受 |
```

### Step 7: Update Status File

Update `docs/superpowers/status/{feature}-status.md`:

```markdown
## 当前阶段
adr-creator

## 文件位置
| ADR | docs/arch/decisions/{seq}-{title}.md | ✅ 已创建 |

## 待处理
- 下一步: writing-plans

## 历史记录
| 追加一行 | adr-creator | 完成 |
```

## Output Location

`docs/arch/decisions/{sequence}-{title}.md`

**Sequence numbering:** Use next available number in the directory.

## Lifecycle

### Creation
- Created by adr-creator when triggered by intelligent filtering rules
- Status: "已接受"

### Deprecation
- ADRs are NEVER deleted
- When a decision is overturned:
  1. Mark old ADR status as "已废弃"
  2. Add deprecation reason and date
  3. Create new ADR that references the old one in "相关决策"
  4. New ADR explains why the old decision was overturned

### Supersession
- When a new ADR supersedes an old one:
  1. Old ADR: Add "被 ADR-{新序号} 替代" to status section
  2. New ADR: Add "替代 ADR-{旧序号}" to related decisions

## Quality Gate

Before marking complete:
- File exists at correct location
- Background is clear
- At least 2 alternatives analyzed
- Decision is explicit
- Consequences are listed
- Related decisions are linked

## Template Reference

`docs/templates/adr.md`

## Anti-Patterns

❌ Creating ADR for every small change
❌ ADR without alternative analysis
❌ ADR without consequences
❌ ADR that only states the decision without explaining why
❌ Deleting an ADR (should mark as deprecated instead)
❌ Overwriting an ADR (should create new one and mark old as superseded)