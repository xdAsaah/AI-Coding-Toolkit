---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

# Test-Driven Development (TDD)

## Overview

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

## When to Use

**Always:**
- New features
- Bug fixes
- Refactoring
- Behavior changes

## Inputs

- Read `docs/superpowers/specs/{feature}-spec.md` (technical spec from writing-plans)
- Read `docs/superpowers/plans/{feature}-plan.md` (implementation plan from writing-plans)
- Read `docs/superpowers/status/{feature}-status.md` (current feature status)

## Outputs

- Implementation code + tests (per the plan)
- Update `docs/superpowers/specs/{feature}-spec.md` (append test coverage report at end)
- Update `docs/superpowers/status/{feature}-status.md`

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

## Red-Green-Refactor

### RED - Write Failing Test

Write one minimal test showing what should happen.

**Requirements:**
- One behavior
- Clear name
- Real code (no mocks unless unavoidable)

### Verify RED - Watch It Fail

**MANDATORY. Never skip.**

Confirm:
- Test fails (not errors)
- Failure message is expected
- Fails because feature missing (not typos)

**Test passes?** You're testing existing behavior. Fix test.
**Test errors?** Fix error, re-run until it fails correctly.

### GREEN - Minimal Code

Write simplest code to pass the test.

Don't add features, refactor other code, or "improve" beyond the test.

### Verify GREEN - Watch It Pass

**MANDATORY.**

Confirm:
- Test passes
- Other tests still pass
- Output pristine (no errors, warnings)

**Test fails?** Fix code, not test.
**Other tests fail?** Fix now.

### REFACTOR - Clean Up

After green only:
- Remove duplication
- Improve names
- Extract helpers

Keep tests green. Don't add behavior.

### Repeat

Next failing test for next feature.

## Good Tests

| Quality | Good | Bad |
|---------|------|-----|
| **Minimal** | One thing. "and" in name? Split it. | `test('validates email and domain and whitespace')` |
| **Clear** | Name describes behavior | `test('test1')` |
| **Shows intent** | Demonstrates desired API | Obscures what code should do |

## Verification Checklist

Before marking work complete:

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass
- [ ] Output pristine (no errors, warnings)
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered

Can't check all boxes? You skipped TDD. Start over.

## Post-Implementation: Update Spec and Status

### Append Test Coverage Report to Spec

Append to the end of `docs/superpowers/specs/{feature}-spec.md`:

```markdown
## 测试覆盖报告

> 更新时间: {YYYY-MM-DD HH:MM}

### 已覆盖验收标准
| 验收标准 | 测试文件 | 测试用例 | 状态 |
|---------|---------|---------|------|
| {criteria} | {test file} | {test name} | ✅ 通过 |

### 未覆盖项
- (列出未覆盖的边界场景,说明原因)

### 测试统计
- 测试用例总数: {N}
- 通过: {N}
- 失败: 0
```

### Update Status File

Update `docs/superpowers/status/{feature}-status.md`:

```markdown
## 当前阶段
test-driven-development

## 待处理
- 下一步: doc-checker (before merge)

## 历史记录
| 追加一行 | test-driven-development | 完成 |
```

## When Stuck

| Problem | Solution |
|---------|----------|
| Don't know how to test | Write wished-for API. Write assertion first. Ask your human partner. |
| Test too complicated | Design too complicated. Simplify interface. |
| Must mock everything | Code too coupled. Use dependency injection. |

## Debugging Integration

Bug found? Write failing test reproducing it. Follow TDD cycle. Test proves fix and prevents regression.

Never fix bugs without a test.

## Final Rule

```
Production code → test exists and failed first
Otherwise → not TDD
```

No exceptions without your human partner's permission.