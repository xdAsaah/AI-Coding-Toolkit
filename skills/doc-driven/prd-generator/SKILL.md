---
name: prd-generator
description: Generate high-quality PRD documents with scenario completeness check, logical consistency check, and development perspective. Automatically selects full or light template based on project type.
---

# PRD Generator

## Overview

Generate PRD documents that are complete, consistent, and developer-friendly. Based on project type, automatically select full template or light template.

**PRD vs Spec boundary:**
- PRD: Focus on problem space - user stories, business flow, acceptance criteria, external API contracts
- Spec: Focus on solution space - component design, data flow implementation, module interaction

## When to Use

- User says "write PRD", "requirement document", "product requirements"
- **Process hook:** After brainstorming completes, proactively ask "Generate PRD draft?"

## Project Type Detection

**Light mode (exploratory prototype / single-person tool):**
- Use prd-light.md template
- Contains: User story + Main flow + Acceptance criteria
- Skip ADR, API contract steps

**Standard mode (medium project):**
- Use prd-full.md template
- Contains all sections

**Full mode (large project / team collaboration):**
- Use prd-full.md template
- Add ADR steps
- Add multi-person review

## Core Capabilities

### 1. Scenario Completeness Check
- Normal flow ✓
- Abnormal flow (network error, duplicate submission, concurrent conflict) ✓
- Boundary scenarios (empty data, extreme values, permission denied) ✓
- Degradation scenarios (API timeout, dependency service down) ✓

### 2. Logical Consistency Check
- Consistent descriptions throughout
- Closed data flow
- Complete state machine

### 3. Development Perspective Completion
- External API contracts (input/output/error codes)
- Database design hints (key fields, index suggestions)
- Technical risk labeling

### 4. Testability Check
- Each feature has clear acceptance criteria
- Test data examples provided
- Performance requirements stated

### 5. Structured Output
- Factory standard template
- Mermaid flow diagrams
- Data dictionary tables

## Workflow

### Step 1: Read Design Draft
- Read `docs/superpowers/specs/{feature}-design.md` (created by brainstorming)
- This is the SOURCE MATERIAL, not the final PRD
- Extract: What, Why, Constraints, Acceptance Criteria

### Step 2: Detect Project Type
- Ask user if unsure: "Is this a prototype, medium project, or large project?"

### Step 3: Generate PRD
- Transform design draft into formal PRD (different file, different content)
- Select template based on project type
- Fill in all sections
- Run scenario completeness check
- Run logical consistency check

### Step 4: Update Status File
- Update `docs/superpowers/status/{feature}-status.md` with PRD location

### Step 5: Self-Check
- Verify all sections are complete
- Verify Mermaid diagrams render correctly
- Verify acceptance criteria are quantifiable

## Data Flow

```
Input:  docs/superpowers/specs/{feature}-design.md  (Design Draft: What/Why/Constraints/Acceptance)
  ↓ Transform
Output: docs/prd/features/{feature}.md  (PRD Final: User stories/Business flow/Acceptance criteria/External contracts)
```

**Design draft is NOT modified.** It remains as source material for writing-plans.

## Output Location

`docs/prd/features/{feature-name}.md`

## Lifecycle

### Creation
- Created by prd-generator after brainstorming and non-goals-clarify
- Source: Transform design draft ({feature}-design.md) into formal PRD
- Status: "Draft" → "In Review"

### Update
- Updated by spec-sync when code changes affect PRD content
- All updates must be approved by human first

### Implementation
- Updated by spec-archive when feature is complete
- Status: "In Review" → "Implemented"

### Deprecation
- PRDs are NEVER deleted
- When a feature is deprecated:
  1. Update PRD status to "Deprecated"
  2. Add deprecation reason and date to changelog section
  3. Do NOT delete the file

## Quality Gate

Before marking complete:
- File exists at correct location
- All required sections are filled
- Mermaid diagrams are present and valid
- Acceptance criteria are quantifiable
- Abnormal scenarios are listed

## Template Reference

- Full template: `docs/templates/prd-full.md`
- Light template: `docs/templates/prd-light.md`

## Anti-Patterns

❌ PRD includes implementation details (component design, module interaction)
❌ PRD omits abnormal scenarios
❌ Acceptance criteria are vague and unmeasurable
❌ Using heavy template for exploratory prototypes