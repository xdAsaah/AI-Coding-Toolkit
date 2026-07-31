---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans
---

# Using Git Worktrees

## Overview

Ensure work happens in an isolated workspace. Prefer native tools. Fall back to git worktrees only when no native tool is available.

**Core principle:** Detect existing isolation first. Then use native tools. Then fall back to git.

## Step 0: Detect Existing Isolation

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
```

**If `GIT_DIR != GIT_COMMON`:** Already in a linked worktree. Skip creation.

**If `GIT_DIR == GIT_COMMON`:** Normal repo checkout. Ask for consent before creating worktree.

## Step 1: Create Isolated Workspace

### 1a. Native Worktree Tools (preferred)

Use your platform's native worktree tool if available.

### 1b. Git Worktree Fallback

**Only use if no native tool.**

#### Directory Selection

Priority:
1. Explicit user preference
2. Existing `.worktrees/` or `worktrees/` directory
3. Default: `.worktrees/`

#### Safety Verification

**MUST verify directory is ignored:**
```bash
git check-ignore -q .worktrees || git check-ignore -q worktrees
```

**If NOT ignored:** Add to .gitignore, commit, then proceed.

#### Create the Worktree

```bash
git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

## Step 2: Project Setup

Auto-detect and run appropriate setup:

```bash
if [ -f package.json ]; then npm install; fi
if [ -f Cargo.toml ]; then cargo build; fi
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f go.mod ]; then go mod download; fi
```

## Step 3: Verify Clean Baseline

```bash
npm test / cargo test / pytest / go test ./...
```

**If tests fail:** Report failures, ask whether to proceed.

**If tests pass:** Report ready.

## Quick Reference

| Situation | Action |
|-----------|--------|
| Already in linked worktree | Skip creation |
| Native worktree tool available | Use it |
| No native tool | Git worktree fallback |
| `.worktrees/` exists | Use it (verify ignored) |
| Directory not ignored | Add to .gitignore + commit |
| Tests fail during baseline | Report + ask |

## Red Flags

**Never:**
- Create a worktree when already in one
- Use `git worktree add` when native tool available
- Skip Step 0 detection
- Create worktree without verifying it's ignored
- Proceed with failing tests without asking