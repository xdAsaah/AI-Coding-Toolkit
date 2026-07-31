---
name: doc-checker
description: Check consistency between documents and code. Detect outdated or missing documents. Start with simple automatable checks, gradually add semantic understanding.
---

# Document Checker

## Overview

Check if code VIOLATES document conventions. Phase 1 focuses on simple automatable checks. Phase 2 will add semantic understanding.

## Boundary (vs spec-sync)

| Dimension | doc-checker (before merge) | spec-sync (after commit) |
|-----------|----------------------------|--------------------------|
| Question | Does code violate document conventions? | Which documents are affected by code changes? |
| Check | Do API paths/methods match contract | Which PRDs need updating |
| Check | Do PRD acceptance criteria have linked tests | Which ADRs need supplementing |
| Check | Are ADR decisions reflected in code | Which specs need syncing |
| Block | Yes (breaking changes) | No |
| Modify Docs | No | No (suggest only) |

**doc-checker does NOT:**
- Analyze which documents are affected by changes (that's spec-sync's job)
- Suggest which PRD/ADR to update (that's spec-sync's job)
- Modify any documents

**doc-checker DOES:**
- Check if code matches API contract (path, method, parameters)
- Check if PRD acceptance criteria have linked test cases
- Check if ADR decisions are reflected in code
- Block merge on breaking changes

## When to Use

- **Process hook:** Before code merge, auto-trigger
- User says "check documents", "document consistency"

## Phase 1: Simple Automatable Checks

### Check 1: API Contract Consistency
- Check if API paths match between code and contract
- Check if HTTP methods match
- Check if parameter names match

**Compatibility Safety Valve:**

| Change Type | Result | Action |
|-------------|--------|--------|
| New endpoint | ✅ Compatible | Suggest updating document, don't block merge |
| New optional parameter | ✅ Compatible | Suggest updating document, don't block merge |
| New response field | ✅ Compatible | Suggest updating document, don't block merge |
| Modified path | ❌ Breaking | Block merge, require document update |
| Modified HTTP method | ❌ Breaking | Block merge, require document update |
| Deleted parameter | ❌ Breaking | Block merge, require document update |
| Modified required parameter | ❌ Breaking | Block merge, require document update |
| Deleted response field | ❌ Breaking | Block merge, require document update |

**Decision Logic:**
1. First check for breaking changes
2. If breaking changes exist → Block merge, require document update
3. If only compatible changes → Don't block merge, generate "suggested document update"
4. Compatible change suggestions are collected by spec-sync after merge

### Check 2: Acceptance Criteria Test Coverage
- Check if acceptance criteria in PRD have linked test cases
- Match via test naming/convention (e.g., test names containing acceptance criteria keywords)

### Check 3: ADR Implementation Verification
- Check if ADR-recorded decisions are reflected in code
- Example: If ADR says "use PostgreSQL", check for PostgreSQL import/driver usage

### Check 4: Missing Documents Detection
- Check if required documents exist for implemented features
- Check if PRD exists for each feature in specs/

## Phase 2: Semantic Understanding (Future)

- Check if feature implementation matches PRD description
- Check if error handling matches PRD description
- Check if performance metrics meet requirements

## Output

Generate report to `docs/superpowers/reports/{feature}-consistency.md`:

```
## Document Consistency Report

### ✅ Passed Checks
- API path: /api/v1/auth/register matches contract
- HTTP method: POST matches contract

### ⚠️ Compatible Changes (Non-blocking)
- New optional parameter 'phone' added to register endpoint
- Suggestion: Update API contract document after merge

### ❌ Breaking Changes (Blocking)
- API path changed from /api/v1/users to /api/v1/accounts
- Action required: Update API contract document before merge
```

## Post-Check: Update Status File

Update `docs/superpowers/status/{feature}-status.md`:

```markdown
## Current Stage
doc-checker

## File Locations
| Consistency report | docs/superpowers/reports/{feature}-consistency.md | ✅ Generated |

## Pending
- Next step: [merge] → spec-sync (after commit)
- Blocking issues: {N} items (must fix before merge)
- Or: No blocking issues, can merge

## History
| Append a row | doc-checker | Done ({N} blocking/{M} compatible) |
```

## Quality Gate

**Blocking issues:**
- Breaking API contract changes without document updates
- Missing required documents

**Non-blocking issues:**
- Compatible API changes (document update suggested)
- Missing test coverage for acceptance criteria

## Anti-Patterns

❌ Using strict matching for all changes (ignoring compatibility)
❌ Blocking merge for trivial compatible changes
❌ Skipping checks for "small changes"