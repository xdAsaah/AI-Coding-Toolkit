---
name: using-superpowers
description: "Core orchestrator skill. Before any reply or action, check and invoke relevant superpowers skills. Enforces strict workflow rules and skill priority ordering with process hooks, size sensing, and state passing."
---

# Using Superpowers

## Read-Index (Step 0, ALWAYS FIRST)

Before any work, read project indexes to load context.

### Execution Steps

```
1. Check CLAUDE.md exists
   - If missing → invoke claude-md-creator, stop here
   - If exists → continue

2. Read code indexes:
   - docs/project-index.md (always)
   - docs/dependency-map.md (if cross-module work)
   - docs/conventions.md (if unsure about conventions)

3. Read document index:
   - docs/doc-index.md (always)
   - Check if related PRD/ADR/spec already exist for current task

4. Check index freshness:
   - If any index file not updated in 7 days → warn user "索引可能过期，是否更新？"
   - If user confirms → invoke claude-md-creator to regenerate code indexes

5. Load all index content into context
```

### Index Freshness Check

For each index file:
- Read file's last modified date
- If > 7 days: `⚠️ {filename} 已 {N} 天未更新，可能不准确。是否现在更新？`
- If user confirms: invoke claude-md-creator to update stale indexes

## Workflow Enforcement

Before any reply or action, check if a relevant skill should be invoked first.

**Skill Priority Order:**

1. **read-index** - ALWAYS first, load project context
2. **brainstorming** - For any creative work
3. **non-goals-clarify** - After brainstorming, before prd-generator
4. **prd-generator** - After non-goals confirmed
5. **adr-creator** - After prd-generator, with intelligent filtering
6. **writing-plans** - After prd (and adr if triggered)
7. **test-driven-development** - During implementation
8. **doc-checker** - Before merge (code vs document compliance)
9. **spec-sync** - After commit (change impact analysis)
10. **spec-archive** - Final step, after spec-sync confirmed

## Hard Rules

- **NO CODE before brainstorming completes**
- **NO IMPLEMENTATION before writing-plans completes**
- **NO PRODUCTION CODE before test-driven-development**
- **NO WRITING-PLANS before non-goals-clarify completes**
- **NO PRD before non-goals-clarify completes**
- **NO MARKING DONE before spec-archive completes**
- **NO SKIPPING DOCUMENTATION at any step**
- **NO WORK before reading project index**
- **NO DUPLICATE DOCUMENTS** - Check doc-index.md before creating any new document

## Data Flow Between Steps

```
brainstorming
    ↓ outputs: {feature}-design.md (设计草稿: What/Why/Constraints/Acceptance)
    ↓ creates: {feature}-status.md (状态文件)
    │
non-goals-clarify
    ↓ reads: {feature}-design.md
    ↓ outputs: updates CLAUDE.md (Non-Goals section)
    ↓ updates: {feature}-status.md
    │
prd-generator
    ↓ reads: {feature}-design.md (原料)
    ↓ outputs: {feature}.md (PRD成品: 用户故事/业务流程/验收标准/对外契约)
    ↓ updates: {feature}-status.md
    │
adr-creator (if triggered)
    ↓ reads: {feature}.md (PRD)
    ↓ outputs: {sequence}-{title}.md (ADR)
    ↓ updates: {feature}-status.md
    │
writing-plans
    ↓ reads: {feature}.md (PRD) + {feature}-design.md (草稿)
    ↓ outputs: {feature}-spec.md (技术spec成品: 组件设计/数据流/模块交互)
    ↓ outputs: {feature}-plan.md (实现计划: 任务拆解/依赖/验证命令)
    ↓ updates: {feature}-status.md
    │
test-driven-development
    ↓ reads: {feature}-spec.md + {feature}-plan.md
    ↓ updates: {feature}-spec.md (添加测试覆盖报告)
    ↓ updates: {feature}-status.md
    │
doc-checker (before merge)
    ↓ reads: {feature}-spec.md + docs/arch/api-contract.md + PRD验收标准
    ↓ checks: 代码是否违反文档约定 (API路径不符/缺少测试/ADR未落实)
    ↓ outputs: consistency-report.md
    ↓ updates: {feature}-status.md
    │
[merge]
    │
spec-sync (after commit)
    ↓ reads: git diff
    ↓ analyzes: 代码变更影响哪些文档 (哪些PRD/ADR/spec需要更新)
    ↓ outputs: change-impact-report.md (不自动修改文档)
    ↓ checks: 是否有结构变更需要更新索引
    ↓ updates: {feature}-status.md
    │
spec-archive
    ↓ reads: {feature}-status.md + change-impact-report.md
    ↓ updates: {feature}-spec.md (状态→已实现)
    ↓ updates: {feature}.md (PRD状态→已实现)
    ↓ updates: docs/doc-index.md (更新文档索引)
    ↓ updates: docs/superpowers/changelog.md (变更记录)
    ↓ deletes: {feature}-status.md (清理状态文件)
```

## File Naming Convention

| File Type | Path | Created By |
|-----------|------|------------|
| 设计草稿 | `docs/superpowers/specs/{feature}-design.md` | brainstorming |
| 技术spec | `docs/superpowers/specs/{feature}-spec.md` | writing-plans |
| PRD | `docs/prd/features/{feature}.md` | prd-generator |
| ADR | `docs/arch/decisions/{sequence}-{title}.md` | adr-creator |
| 实现计划 | `docs/superpowers/plans/{feature}-plan.md` | writing-plans |
| 状态文件 | `docs/superpowers/status/{feature}-status.md` | brainstorming (创建), 各步骤更新 |
| 一致性报告 | `docs/superpowers/reports/{feature}-consistency.md` | doc-checker |
| 变更影响报告 | `docs/superpowers/reports/{feature}-impact.md` | spec-sync |

## Status File Format

`docs/superpowers/status/{feature}-status.md`:

```markdown
# Feature: {feature-name} 状态

## 当前阶段
{当前步骤名称}

## 分支
{git分支名}

## 文件位置
| 文件类型 | 路径 | 状态 |
|----------|------|------|
| 设计草稿 | docs/superpowers/specs/{feature}-design.md | ✅ 已创建 |
| PRD | docs/prd/features/{feature}.md | ✅ 已创建 |
| spec | docs/superpowers/specs/{feature}-spec.md | ⏳ 待创建 |
| plan | docs/superpowers/plans/{feature}-plan.md | ⏳ 待创建 |
| ADR | (无) | - |

## 待处理
- 下一步: writing-plans
- 需要ADR: 是（涉及Redis技术选型）

## 历史记录
| 时间 | 步骤 | 结果 |
|------|------|------|
| 2026-07-16 10:00 | brainstorming | 完成 |
| 2026-07-16 10:30 | non-goals-clarify | 完成 |
| 2026-07-16 11:00 | prd-generator | 完成 |
```

## doc-checker vs spec-sync 边界

| 维度 | doc-checker | spec-sync |
|------|-------------|-----------|
| **时机** | 合并前 | 提交后 |
| **问题** | 代码是否违反文档约定？ | 代码变更影响哪些文档？ |
| **检查内容** | API路径/方法是否与契约一致、PRD验收标准是否有关联测试、ADR决策是否在代码中落实 | 哪些PRD需要更新、哪些ADR需要补充、哪些spec需要同步 |
| **输出** | 一致性报告（阻断/不阻断） | 变更影响清单（建议，不阻断） |
| **阻断** | 是（破坏性变更阻断合并） | 否 |
| **修改文档** | 否 | 否（只建议，人类确认后修改） |

## Process Hooks

| Workflow Node | Action |
|---------------|--------|
| Task received | Auto-trigger read-index |
| brainstorming completes | Proactively trigger prd-generator |
| prd-generator completes | With intelligent filtering, trigger adr-creator |
| Before code merge | Auto-trigger doc-checker |
| After code commit | Auto-trigger spec-sync |
| spec-sync confirmed | Auto-trigger spec-archive |
| CLAUDE.md doesn't exist | Auto-trigger claude-md-creator |

## Size Sensing

| Project Type | Template | Workflow |
|--------------|----------|----------|
| **Exploratory prototype** | prd-light.md | read-index → brainstorming → writing-plans → TDD → spec-archive |
| **Medium project** | prd-full.md | read-index → brainstorming → non-goals → prd-generator → writing-plans → TDD → doc-checker → spec-sync → spec-archive |
| **Large project** | prd-full.md + ADR | read-index → brainstorming → non-goals → prd-generator → adr-creator → writing-plans → TDD → doc-checker → spec-sync → spec-archive |

## Parallel Development

When developing multiple features simultaneously:

- Each feature uses its own branch name as identifier
- Status files are per-feature: `{feature}-status.md`
- spec-sync analyzes changes based on current branch's feature name
- changelog records each feature separately
- doc-index.md tracks all features' document status

## Anti-Patterns

❌ Skipping read-index
❌ Creating duplicate documents (always check doc-index.md first)
❌ brainstorming writing to PRD file
❌ Multiple skills writing to changelog (only spec-archive writes changelog)
❌ doc-checker analyzing "which documents are affected" (that's spec-sync's job)
❌ spec-sync checking "if code violates API contract" (that's doc-checker's job)
❌ Writing design draft and spec to the same file
❌ Skipping status file updates

## Document Directory Structure

```
docs/
├── doc-index.md                 # 文档索引（所有文档的状态清单）
├── project-index.md             # 项目文件索引（代码结构）
├── dependency-map.md            # 模块依赖关系
├── conventions.md               # 代码约定
├── prd/
│   ├── overview.md
│   └── features/
│       └── {feature}.md
├── arch/
│   ├── system.md
│   ├── api-contract.md
│   └── decisions/
│       └── {sequence}-{title}.md
├── superpowers/
│   ├── specs/
│   │   ├── {feature}-design.md  # 设计草稿
│   │   └── {feature}-spec.md    # 技术spec
│   ├── plans/
│   │   └── {feature}-plan.md
│   ├── status/
│   │   └── {feature}-status.md  # 状态文件（临时，归档后删除）
│   ├── reports/
│   │   ├── {feature}-consistency.md  # 一致性报告
│   │   └── {feature}-impact.md       # 变更影响报告
│   └── changelog.md
└── templates/
```

## doc-index.md Format

`docs/doc-index.md`:

```markdown
# 文档索引

> 最后更新: 2026-07-16

## PRD 文档
| 功能 | 文件路径 | 状态 | 最后更新 |
|------|---------|------|---------|
| 用户认证 | docs/prd/features/user-auth.md | 已实现 | 2026-07-15 |
| 支付系统 | docs/prd/features/payment.md | 评审中 | 2026-07-16 |

## Spec 文档
| 功能 | 设计草稿 | 技术spec | 状态 |
|------|---------|---------|------|
| 用户认证 | specs/user-auth-design.md | specs/user-auth-spec.md | 已实现 |
| 支付系统 | specs/payment-design.md | (待创建) | 设计中 |

## ADR 文档
| 序号 | 标题 | 文件路径 | 状态 |
|------|------|---------|------|
| 001 | 使用PostgreSQL | decisions/001-use-postgres.md | 已接受 |
| 002 | JWT会话管理 | decisions/002-jwt-session.md | 已废弃 |
| 003 | Redis缓存方案 | decisions/003-redis-cache.md | 已接受 |

## API契约
| 文件 | 状态 | 最后更新 |
|------|------|---------|
| docs/arch/api-contract.md | 最新 | 2026-07-16 |
```

## ADR Intelligent Filtering

Trigger ADR only when plans contain:
- New third-party dependencies
- Cross-module boundary changes
- Explicit technical selection or trade-offs
- Architecture-level changes

Do NOT trigger for:
- Single module internal logic changes
- Bug fixes only
- Performance optimizations only