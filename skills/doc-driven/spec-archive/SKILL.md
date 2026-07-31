---
name: spec-archive
description: "Use after code implementation completes and tests pass. Archives specs, updates document index, and cleans up status files."
---

# Spec Archive

## Purpose

Finalize feature development: update document statuses, record changelog, and clean up temporary files.

## When to Use

- After spec-sync confirmed (change impact report reviewed)
- After all tests pass
- Before marking task as done

## Execution Steps

### Step 1: Read Status File

- Read `docs/superpowers/status/{feature}-status.md`
- Get current feature status and file locations
- Read `docs/superpowers/reports/{feature}-impact.md` (from spec-sync)

### Step 2: Update Document Statuses

```
1. Update docs/superpowers/specs/{feature}-spec.md
   - Status: → "已实现"
   - Add implementation date

2. Update docs/prd/features/{feature}.md
   - Status: → "已实现"
   - Add implementation date
```

### Step 3: Update Document Index

Update `docs/doc-index.md`:
- Update feature's PRD status to "已实现"
- Update feature's spec status to "已实现"
- Update "最后更新" date

### Step 4: Update Changelog

Update `docs/superpowers/changelog.md`:

```markdown
## {YYYY-MM-DD} - {feature-name}

### 完成
- 功能: {feature-name}
- 描述: {brief description}
- PRD: docs/prd/features/{feature}.md
- Spec: docs/superpowers/specs/{feature}-spec.md
- ADR: {ADR links if any}
```

**Only spec-archive writes to changelog.**

### Step 5: Cleanup

```
□ Delete docs/superpowers/status/{feature}-status.md
□ Delete docs/superpowers/reports/{feature}-consistency.md
□ Delete docs/superpowers/reports/{feature}-impact.md
□ Confirm all statuses updated
```

## Hard Rules

- **代码未测试通过不归档**
- **spec-sync未确认不归档**
- **必须更新doc-index.md**
- **必须更新changelog**
- **必须清理status和reports文件**
- **Only spec-archive writes to changelog**

## Quality Check

```
□ {feature}-spec.md 状态已更新为"已实现"
□ {feature}.md (PRD) 状态已更新为"已实现"
□ docs/doc-index.md 已更新
□ docs/superpowers/changelog.md 已更新
□ status文件已删除
□ reports文件已删除
```

## Deprecation Support

When archiving a DEPRECATED feature (not a completed one):

### Step 1: Mark PRD as deprecated
- Update `docs/prd/features/{feature}.md` status to "已废弃"
- Add deprecation reason and date
- Do NOT delete the file

### Step 2: Mark spec as deprecated
- Update `docs/superpowers/specs/{feature}-spec.md` status to "已废弃"

### Step 3: Create superseding ADR (if deprecation is due to architecture change)
- Create new ADR referencing the old one
- Mark old ADR as "已废弃"

### Step 4: Update doc-index.md
- Update feature's PRD status to "已废弃"
- Update feature's spec status to "已废弃"

### Step 5: Update changelog
- Record deprecation in `docs/superpowers/changelog.md`

### Step 6: Cleanup
- Delete status file
- Delete report files