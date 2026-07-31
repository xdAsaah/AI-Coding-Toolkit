---
name: writing-skills
description: Use when creating new skills, editing existing skills, or verifying skills work before deployment
---

# Writing Skills

## Overview

**Writing skills IS Test-Driven Development applied to process documentation.**

**Core principle:** If you didn't watch an agent fail without the skill, you don't know if the skill teaches the right thing.

**REQUIRED BACKGROUND:** You MUST understand superpowers:test-driven-development.

## What is a Skill?

**Skills are:** Reusable techniques, patterns, tools, reference guides

**Skills are NOT:** Narratives about how you solved a problem once

## TDD Mapping

| TDD Concept | Skill Creation |
|-------------|----------------|
| Test case | Pressure scenario with subagent |
| Production code | SKILL.md |
| Test fails (RED) | Agent violates rule without skill |
| Test passes (GREEN) | Agent complies with skill present |
| Refactor | Close loopholes |

## When to Create a Skill

**Create when:**
- Technique wasn't intuitively obvious
- You'd reference this again across projects
- Pattern applies broadly

**Don't create for:**
- One-off solutions
- Project-specific conventions
- Mechanical constraints (automate with regex)

## SKILL.md Structure

**Frontmatter:**
- `name`: letters, numbers, hyphens only
- `description`: Start with "Use when..." - ONLY triggering conditions

```markdown
---
name: skill-name-with-hyphens
description: Use when [specific triggering conditions]
---
```

**Body:**
- Overview (1-2 sentences)
- When to Use (symptoms, use cases)
- Core Pattern
- Quick Reference
- Common Mistakes

## Skill Discovery Optimization

**CRITICAL: Description = When to Use, NOT What the Skill Does**

```yaml
# ❌ BAD: Summarizes workflow
description: Use when executing plans - dispatches subagent per task

# ✅ GOOD: Triggering conditions only
description: Use when executing implementation plans with independent tasks
```

**Keyword Coverage:** Use words an agent would search for.

**Token Efficiency:**
- getting-started: <150 words
- Frequently-loaded: <200 words
- Other skills: <500 words

## Cross-Referencing

```markdown
**REQUIRED SUB-SKILL:** Use superpowers:test-driven-development
**REQUIRED BACKGROUND:** You MUST understand superpowers:systematic-debugging
```

**Never use @ links** - they force-load files immediately.

## The Iron Law

```
NO SKILL WITHOUT A FAILING TEST FIRST
```

**No exceptions.**

## Testing All Skill Types

### Discipline-Enforcing Skills
**Test with:** Academic questions, pressure scenarios

### Technique Skills
**Test with:** Application scenarios, edge cases

### Pattern Skills
**Test with:** Recognition scenarios, counter-examples

### Reference Skills
**Test with:** Retrieval scenarios, gap testing

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Skill is obviously clear" | Clear to you ≠ clear to other agents |
| "Testing is overkill" | Untested skills have issues. Always. |
| "I'll test if problems emerge" | Problems = agents can't use skill |

**Test before deploying. No exceptions.**