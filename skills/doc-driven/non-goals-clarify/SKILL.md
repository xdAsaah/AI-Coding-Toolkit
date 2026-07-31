---
name: non-goals-clarify
description: "Use after brainstorming completes and before prd-generator. Confirms what NOT to build in v1 to prevent AI over-engineering."
---

# Non-Goals Clarify

## Purpose

Prevent AI from building features the user never asked for.

> "Defining what NOT to do" is more important than "defining what to do"

## When to Use

- After brainstorming completes
- Before prd-generator starts
- When user says "add feature" without scope boundaries

## Inputs

- Read `docs/superpowers/specs/{feature}-design.md` (design draft from brainstorming)
- Read `docs/superpowers/status/{feature}-status.md` (current feature status)
- Read CLAUDE.md (check existing Non-Goals section)

## Outputs

- Update `CLAUDE.md` (append/merge into Non-Goals section)
- Update `docs/superpowers/status/{feature}-status.md`

**Non-Goals live in CLAUDE.md**, not in a separate file. This ensures the project constitution stays the single source of truth for scope boundaries.

## Execution Steps

### Step 1: Infer Non-Goals

Based on design draft from brainstorming, infer likely Non-Goals:

```
Input: "Create an e-commerce backend management system"

Inferred Non-Goals:
- OAuth third-party login
- Mobile adaptation
- Multi-language support
- Payment gateway integration
- Data export
- Third-party platform integration
```

### Step 2: Present to User

```
Ask user:
"Based on requirement analysis, to prevent AI over-implementation, please confirm which features v1 will NOT do:

□ OAuth third-party login (WeChat/Google)
□ Phone number login (email only)
□ Mobile adaptation (desktop only)
□ Multi-language support (Chinese only)
□ Payment gateway integration
□ Data export functionality
□ Third-party platform integration (ERP/CRM)
□ Real-time notification push
□ Other items not to do: ____"
```

### Step 3: Update CLAUDE.md Non-Goals Section

Append confirmed Non-Goals to the `## Non-Goals` section in CLAUDE.md:

```markdown
## Non-Goals

- v1 does NOT do OAuth third-party login
- v1 does NOT do Mobile adaptation
- v1 does NOT do Multi-language support
- v1 does NOT do Payment gateway integration

> Must stop and ask user when touching Non-Goals
> User confirmation date: YYYY-MM-DD
```

If CLAUDE.md doesn't have a Non-Goals section, create one. If it already has one, merge new items (avoid duplicates).

### Step 4: Update Status File

Update `docs/superpowers/status/{feature}-status.md`:

```markdown
## Current Stage
non-goals-clarify

## Pending
- Next step: prd-generator

## History
| Append a row | non-goals-clarify | Done |
```

### Step 5: Pass to prd-generator

Non-Goals now in CLAUDE.md are automatically available as constraints for prd-generator (which reads CLAUDE.md via read-index).

## Hard Rules

- **Must confirm with user** - Cannot be decided by AI alone
- **Must record to CLAUDE.md** - Cannot be confirmed only in conversation, cannot be stored in a separate file
- **Must pass to downstream skills** - prd-generator obtains Non-Goals by reading CLAUDE.md
- **Must stop when touching Non-Goals** - When AI finds requirements approaching Non-Goals, it must stop and ask

## Quality Check

```
□ Read {feature}-design.md
□ Inferred Non-Goals based on design draft
□ Presented confirmation list to user
□ User confirmed
□ Updated CLAUDE.md Non-Goals section
□ Updated {feature}-status.md
```