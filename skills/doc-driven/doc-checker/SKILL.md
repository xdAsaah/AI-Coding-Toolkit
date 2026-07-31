---
name: doc-checker
description: Check consistency between documents and code. Detect outdated or missing documents. Start with simple automatable checks, gradually add semantic understanding.
---

# Document Checker

## Overview

Check if code VIOLATES document conventions. Phase 1 focuses on simple automatable checks. Phase 2 will add semantic understanding.

## Boundary (vs spec-sync)

| 维度 | doc-checker (合并前) | spec-sync (提交后) |
|------|----------------------|-------------------|
| 问题 | 代码是否违反文档约定？ | 代码变更影响哪些文档？ |
| 检查 | API路径/方法是否与契约一致 | 哪些PRD需要更新 |
| 检查 | PRD验收标准是否有关联测试 | 哪些ADR需要补充 |
| 检查 | ADR决策是否在代码中落实 | 哪些spec需要同步 |
| 阻断 | 是（破坏性变更） | 否 |
| 修改文档 | 否 | 否（只建议） |

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
## 当前阶段
doc-checker

## 文件位置
| 一致性报告 | docs/superpowers/reports/{feature}-consistency.md | ✅ 已生成 |

## 待处理
- 下一步: [merge] → spec-sync (after commit)
- 阻断问题: {N} 项 (需修复后才能合并)
- 或: 无阻断问题,可合并

## 历史记录
| 追加一行 | doc-checker | 完成 ({N}阻断/{M}兼容) |
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