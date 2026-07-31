---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**The Iron Law:** NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE

## The Gate Function

```
BEFORE claiming any status:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
 - If NO: State actual status with evidence
 - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command: 0 failures | Previous run, "should pass" |
| Linter clean | Linter: 0 errors | Partial check |
| Build succeeds | Build: exit 0 | Linter passing |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |

## Red Flags

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification
- About to commit/push/PR without verification
- Trusting agent success reports

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Agent said success" | Verify independently |
| "Partial check is enough" | Partial proves nothing |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now"
```

**Regression tests (TDD):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green)
```

**Build:**
```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed"
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- Committing, PR creation, task completion
- Moving to next task

**This is non-negotiable.**