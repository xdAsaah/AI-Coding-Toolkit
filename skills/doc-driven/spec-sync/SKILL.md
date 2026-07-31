---
name: spec-sync
description: Change impact analyzer. Detect which documents may be affected by code changes, generate a pending update checklist (do NOT auto-update documents).
---

# Spec Sync

## Overview

Analyze code changes to identify which documents may be affected. Generate a pending update checklist with suggested changes. **Do NOT automatically update documents** - wait for human confirmation.

**Core Principle:** AI discovers and suggests, human decides and approves.

## When to Use

- **Process hook:** After code commit, auto-trigger
- User says "sync documents", "change impact analysis"

## Core Capabilities

1. Detect code change types (API changes, logic changes, data changes)
2. Find affected documents (PRD, ADR, spec, API contract)
3. Generate pending update checklist with suggested changes
4. Wait for human confirmation before modifying documents
5. Detect project structure changes and directly update index files (after human confirmation)

## Boundary (vs doc-checker)

| Dimension | doc-checker (before merge) | spec-sync (after commit) |
|-----------|----------------------------|--------------------------|
| Question | Does code violate document conventions? | Which documents are affected by code changes? |
| Check | Do API paths/methods match contract | Which PRDs need updating |
| Check | Do PRD acceptance criteria have linked tests | Which ADRs need supplementing |
| Check | Are ADR decisions reflected in code | Which specs need syncing |
| Block | Yes (breaking changes) | No |
| Modify Docs | No | No (suggest only) |

**spec-sync does NOT:**
- Check if API path matches contract (that's doc-checker's job)
- Check if ADR decision is implemented (that's doc-checker's job)
- Write to changelog (only spec-archive writes changelog)

**spec-sync DOES:**
- Analyze which documents are AFFECTED by code changes
- Directly update index files (project-index.md, dependency-map.md, conventions.md, doc-index.md) after human confirmation

## Automation Boundary

- ✅ AI discovers: Analyze change types, find affected documents
- ✅ AI suggests: Generate pending update checklist with suggested changes
- ❌ AI does NOT execute: Do NOT automatically update documents
- ✅ AI modifies: After human confirmation, modify documents as directed

## Workflow

### Step 1: Analyze Code Changes
- Get git diff
- Classify changes: API changes, logic changes, data changes, configuration changes, **structure changes**

### Step 2: Identify Affected Documents
- API changes → Check PRD (external contracts), API contract document
- Logic changes → Check PRD (business rules), spec (implementation details)
- Data changes → Check PRD (data design), spec (data flow), ADR (database decisions)
- Configuration changes → Check ADR (configuration decisions)
- **Structure changes** → Check project index files (see Step 2b)

### Step 2b: Structure Change Detection

**Detect these structure changes:**
- New directory created
- Directory deleted
- New entry point file (main.ts, index.ts, app.ts)
- New module/service added
- Module dependency direction changed
- New configuration file
- package.json/go.mod/pom.xml dependencies changed

**If structure changes detected, add to checklist:**

| Structure Change | Index File to Update |
|-----------------|---------------------|
| New/deleted directory | docs/project-index.md (Directory Purposes table) |
| New entry point | docs/project-index.md (Entry Points table) |
| New module/service | docs/dependency-map.md (Dependency Direction) |
| Module dependency changed | docs/dependency-map.md (Dependency Direction, Forbidden Dependency Directions) |
| New convention pattern | docs/conventions.md |
| New config file | docs/project-index.md (Key Config Files table) |

### Step 3: Generate Pending Update Checklist
- List each affected document
- Describe what needs to be updated
- Provide suggested update content (but don't apply)

### Step 4: Present Checklist to Human
- Show checklist with priority (high/medium/low)
- Wait for human approval
- Apply changes only after human confirmation

### Step 5: Execute Approved Changes

**For regular documents (PRD, ADR, spec, API contract):**
- Only modify documents approved by human
- Do NOT write to changelog (that's spec-archive's responsibility)

**For index files (project-index.md, dependency-map.md, conventions.md, doc-index.md):**
- Directly update index files after human confirmation
- Update content is already explicit (new directory, new entry point, etc.)
- No need to call claude-md-creator for index updates
- For doc-index.md: update document status when documents are created/deprecated

## Output Format

Generate report to `docs/superpowers/reports/{feature}-impact.md`:

```
## Change Impact Analysis Report

### High Priority Updates Required:
1. [Document] docs/prd/features/user-auth.md
   - Reason: API endpoint path changed
   - Suggested change: Update API contract section

2. [Document] docs/arch/api-contract.md
   - Reason: New optional parameter added to login endpoint
   - Suggested change: Add new parameter to login API definition

### Medium Priority Updates Suggested:
1. [Document] docs/superpowers/specs/user-auth.md
   - Reason: Logic change in token validation
   - Suggested change: Update implementation notes

### Low Priority Updates (Optional):
1. [Document] docs/arch/decisions/001-use-jwt.md
   - Reason: Token expiration time changed
   - Suggested change: Update consequence section

### Action Required:
Please review and approve changes, or provide guidance on which documents to update.
```

## Post-Analysis: Update Status File

Update `docs/superpowers/status/{feature}-status.md`:

```markdown
## Current Stage
spec-sync

## File Locations
| Change impact report | docs/superpowers/reports/{feature}-impact.md | ✅ Generated |

## Pending
- Next step: spec-archive (after human reviews impact report)
- Document updates pending confirmation: {N} items

## History
| Append a row | spec-sync | Done (pending human confirmation) |
```

## Anti-Patterns

❌ Automatically updating documents without human confirmation
❌ Generating overly broad change suggestions
❌ Missing documents that are actually affected
❌ Not prioritizing changes (treating all changes equally)