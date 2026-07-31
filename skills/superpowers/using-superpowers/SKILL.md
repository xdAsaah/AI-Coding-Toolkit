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
   - If any index file not updated in 7 days → warn user "Indexes may be outdated, update now?"
   - If user confirms → invoke claude-md-creator to regenerate code indexes

5. Load all index content into context
```

### Index Freshness Check

For each index file:
- Read file's last modified date
- If > 7 days: `⚠️ {filename} has not been updated for {N} days, may be inaccurate. Update now?`
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
    ↓ outputs: {feature}-design.md (design draft: What/Why/Constraints/Acceptance)
    ↓ creates: {feature}-status.md (status file)
    │
non-goals-clarify
    ↓ reads: {feature}-design.md
    ↓ outputs: updates CLAUDE.md (Non-Goals section)
    ↓ updates: {feature}-status.md
    │
prd-generator
    ↓ reads: {feature}-design.md (raw material)
    ↓ outputs: {feature}.md (PRD output: user stories/business flow/acceptance criteria/external contracts)
    ↓ updates: {feature}-status.md
    │
adr-creator (if triggered)
    ↓ reads: {feature}.md (PRD)
    ↓ outputs: {sequence}-{title}.md (ADR)
    ↓ updates: {feature}-status.md
    │
writing-plans
    ↓ reads: {feature}.md (PRD) + {feature}-design.md (draft)
    ↓ outputs: {feature}-spec.md (technical spec output: component design/data flow/module interaction)
    ↓ outputs: {feature}-plan.md (implementation plan: task breakdown/dependencies/verification commands)
    ↓ updates: {feature}-status.md
    │
test-driven-development
    ↓ reads: {feature}-spec.md + {feature}-plan.md
    ↓ updates: {feature}-spec.md (append test coverage report)
    ↓ updates: {feature}-status.md
    │
doc-checker (before merge)
    ↓ reads: {feature}-spec.md + docs/arch/api-contract.md + PRD acceptance criteria
    ↓ checks: Whether code violates document conventions (API path mismatch/missing tests/ADR not implemented)
    ↓ outputs: consistency-report.md
    ↓ updates: {feature}-status.md
    │
[merge]
    │
spec-sync (after commit)
    ↓ reads: git diff
    ↓ analyzes: Which documents are affected by code changes (which PRD/ADR/spec need updating)
    ↓ outputs: change-impact-report.md (do not auto-modify documents)
    ↓ checks: Whether structural changes require index updates
    ↓ updates: {feature}-status.md
    │
spec-archive
    ↓ reads: {feature}-status.md + change-impact-report.md
    ↓ updates: {feature}-spec.md (status→Implemented)
    ↓ updates: {feature}.md (PRD status→Implemented)
    ↓ updates: docs/doc-index.md (update document index)
    ↓ updates: docs/superpowers/changelog.md (change records)
    ↓ deletes: {feature}-status.md (cleanup status file)
```

## File Naming Convention

| File Type | Path | Created By |
|-----------|------|------------|
| Design draft | `docs/superpowers/specs/{feature}-design.md` | brainstorming |
| Technical spec | `docs/superpowers/specs/{feature}-spec.md` | writing-plans |
| PRD | `docs/prd/features/{feature}.md` | prd-generator |
| ADR | `docs/arch/decisions/{sequence}-{title}.md` | adr-creator |
| Implementation plan | `docs/superpowers/plans/{feature}-plan.md` | writing-plans |
| Status file | `docs/superpowers/status/{feature}-status.md` | brainstorming (create), updated by each step |
| Consistency report | `docs/superpowers/reports/{feature}-consistency.md` | doc-checker |
| Change impact report | `docs/superpowers/reports/{feature}-impact.md` | spec-sync |

## Status File Format

`docs/superpowers/status/{feature}-status.md`:

```markdown
# Feature: {feature-name} Status

## Current Stage
{current step name}

## Branch
{git branch name}

## File Locations
| File Type | Path | Status |
|----------|------|------|
| Design draft | docs/superpowers/specs/{feature}-design.md | ✅ Created |
| PRD | docs/prd/features/{feature}.md | ✅ Created |
| spec | docs/superpowers/specs/{feature}-spec.md | ⏳ To be created |
| plan | docs/superpowers/plans/{feature}-plan.md | ⏳ To be created |
| ADR | (none) | - |

## Pending
- Next step: writing-plans
- ADR needed: Yes (involves Redis tech selection)

## History
| Time | Step | Result |
|------|------|------|
| 2026-07-16 10:00 | brainstorming | Done |
| 2026-07-16 10:30 | non-goals-clarify | Done |
| 2026-07-16 11:00 | prd-generator | Done |
```

## doc-checker vs spec-sync Boundary

| Dimension | doc-checker | spec-sync |
|------|-------------|-----------|
| **Timing** | Before merge | After commit |
| **Question** | Does code violate document conventions? | Which documents are affected by code changes? |
| **Check Content** | Whether API paths/methods match contract, whether PRD acceptance criteria have associated tests, whether ADR decisions are implemented in code | Which PRDs need updating, which ADRs need supplementing, which specs need syncing |
| **Output** | Consistency report (blocks/does not block) | Change impact list (suggestion, does not block) |
| **Block** | Yes (breaking changes block merge) | No |
| **Modify Docs** | No | No (suggestions only, modified after human confirmation) |

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
├── doc-index.md                 # Document index (status list of all documents)
├── project-index.md             # Project file index (code structure)
├── dependency-map.md            # Module dependency relationships
├── conventions.md               # Code conventions
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
│   │   ├── {feature}-design.md  # Design draft
│   │   └── {feature}-spec.md    # Technical spec
│   ├── plans/
│   │   └── {feature}-plan.md
│   ├── status/
│   │   └── {feature}-status.md  # Status file (temporary, deleted after archiving)
│   ├── reports/
│   │   ├── {feature}-consistency.md  # Consistency report
│   │   └── {feature}-impact.md       # Change impact report
│   └── changelog.md
└── templates/
```

## doc-index.md Format

`docs/doc-index.md`:

```markdown
# Document Index

> Last updated: 2026-07-16

## PRD Documents
| Feature | File Path | Status | Last Updated |
|------|---------|------|---------|
| User auth | docs/prd/features/user-auth.md | Implemented | 2026-07-15 |
| Payment system | docs/prd/features/payment.md | In Review | 2026-07-16 |

## Spec Documents
| Feature | Design Draft | Technical Spec | Status |
|------|---------|---------|------|
| User auth | specs/user-auth-design.md | specs/user-auth-spec.md | Implemented |
| Payment system | specs/payment-design.md | (to be created) | In Design |

## ADR Documents
| Sequence | Title | File Path | Status |
|------|------|---------|------|
| 001 | Use PostgreSQL | decisions/001-use-postgres.md | Accepted |
| 002 | JWT session management | decisions/002-jwt-session.md | Deprecated |
| 003 | Redis cache solution | decisions/003-redis-cache.md | Accepted |

## API Contract
| File | Status | Last Updated |
|------|------|---------|
| docs/arch/api-contract.md | Latest | 2026-07-16 |
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
