---
name: dispatching-parallel-agents
description: Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies
---

# Dispatching Parallel Agents

## Overview

Delegate tasks to specialized agents with isolated context. They should never inherit your session's context or history.

**Core principle:** Dispatch one agent per independent problem domain.

## When to Use

**Use when:**
- 3+ test files failing with different root causes
- Multiple subsystems broken independently
- Each problem can be understood without context from others
- No shared state between investigations

**Don't use when:**
- Failures are related
- Need to understand full system state
- Agents would interfere with each other

## The Pattern

### 1. Identify Independent Domains

Group failures by what's broken.

### 2. Create Focused Agent Tasks

Each agent gets:
- **Specific scope:** One test file or subsystem
- **Clear goal:** Make these tests pass
- **Constraints:** Don't change other code
- **Expected output:** Summary of what you found and fixed

### 3. Dispatch in Parallel

Issue all subagent dispatches in the same response.

### 4. Review and Integrate

When agents return:
- Read each summary
- Verify fixes don't conflict
- Run full test suite
- Integrate all changes

## Agent Prompt Structure

Good prompts are:
1. **Focused** - One clear problem domain
2. **Self-contained** - All context needed
3. **Specific about output** - What should the agent return?

## Common Mistakes

**❌ Too broad:** "Fix all the tests"
**✅ Specific:** "Fix agent-tool-abort.test.ts"

**❌ No context:** "Fix the race condition"
**✅ Context:** Paste error messages and test names

**❌ No constraints:** Agent might refactor everything
**✅ Constraints:** "Do NOT change production code"

## Verification

After agents return:
1. **Review each summary**
2. **Check for conflicts**
3. **Run full suite**
4. **Spot check**