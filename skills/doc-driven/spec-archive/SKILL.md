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
   - Status: → "Implemented"
   - Add implementation date

2. Update docs/prd/features/{feature}.md
   - Status: → "Implemented"
   - Add implementation date
```

### Step 3: Update Document Index

Update `docs/doc-index.md`:
- Update feature's PRD status to "Implemented"
- Update feature's spec status to "Implemented"
- Update "Last updated" date

### Step 4: Update Changelog

Update `docs/superpowers/changelog.md`:

```markdown
## {YYYY-MM-DD} - {feature-name}

### Completed
- Feature: {feature-name}
- Description: {brief description}
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

- **Do not archive if code tests not passed**
- **Do not archive if spec-sync not confirmed**
- **Must update doc-index.md**
- **Must update changelog**
- **Must clean up status and reports files**
- **Only spec-archive writes to changelog**

## Quality Check

```
□ {feature}-spec.md status updated to "Implemented"
□ {feature}.md (PRD) status updated to "Implemented"
□ docs/doc-index.md updated
□ docs/superpowers/changelog.md updated
□ status file deleted
□ reports file deleted
```

## Deprecation Support

When archiving a DEPRECATED feature (not a completed one):

### Step 1: Mark PRD as deprecated
- Update `docs/prd/features/{feature}.md` status to "Deprecated"
- Add deprecation reason and date
- Do NOT delete the file

### Step 2: Mark spec as deprecated
- Update `docs/superpowers/specs/{feature}-spec.md` status to "Deprecated"

### Step 3: Create superseding ADR (if deprecation is due to architecture change)
- Create new ADR referencing the old one
- Mark old ADR as "Deprecated"

### Step 4: Update doc-index.md
- Update feature's PRD status to "Deprecated"
- Update feature's spec status to "Deprecated"

### Step 5: Update changelog
- Record deprecation in `docs/superpowers/changelog.md`

### Step 6: Cleanup
- Delete status file
- Delete report files