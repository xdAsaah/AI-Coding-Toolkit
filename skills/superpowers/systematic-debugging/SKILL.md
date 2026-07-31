---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes.

**The Iron Law:** NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
 - Read stack traces completely
 - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
 - Can you trigger it reliably?
 - If not reproducible → gather more data, don't guess

3. **Check Recent Changes**
 - Git diff, recent commits
 - New dependencies, config changes

4. **Gather Evidence in Multi-Component Systems**
 - Log what data enters/exits each component
 - Verify environment/config propagation
 - Check state at each layer

5. **Trace Data Flow**
 - Where does bad value originate?
 - Keep tracing up until you find the source
 - Fix at source, not at symptom

### Phase 2: Pattern Analysis

1. **Find Working Examples**
 - Locate similar working code in same codebase

2. **Compare Against References**
 - Read reference implementation COMPLETELY

3. **Identify Differences**
 - List every difference, however small

4. **Understand Dependencies**
 - What other components does this need?

### Phase 3: Hypothesis and Testing

1. **Form Single Hypothesis**
 - State clearly: "I think X is the root cause because Y"

2. **Test Minimally**
 - Make the SMALLEST possible change
 - One variable at a time

3. **Verify Before Continuing**
 - Did it work? Yes → Phase 4
 - Didn't work? Form NEW hypothesis

### Phase 4: Implementation

1. **Create Failing Test Case**
 - Simplest possible reproduction
 - MUST have before fixing

2. **Implement Single Fix**
 - Address the root cause
 - ONE change at a time
 - No "while I'm here" improvements

3. **Verify Fix**
 - Test passes now?
 - No other tests broken?

4. **If 3+ Fixes Failed:** Question Architecture
 - STOP and discuss with human partner
 - Pattern indicates architectural problem

## Red Flags

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "I don't fully understand but this might work"
- "One more fix attempt" (after 2+ failures)

**STOP. Return to Phase 1.**

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |