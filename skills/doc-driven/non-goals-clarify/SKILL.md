---
name: non-goals-clarify
description: "Use after brainstorming completes and before prd-generator. Confirms what NOT to build in v1 to prevent AI over-engineering."
---

# Non-Goals Clarify

## Purpose

Prevent AI from building features the user never asked for.

> "明确不做什么"比"明确要做什么"更重要

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
输入: "创建一个电商后台管理系统"

推断Non-Goals:
- OAuth第三方登录
- 移动端适配
- 多语言支持
- 支付网关集成
- 数据导出
- 第三方平台对接
```

### Step 2: Present to User

```
向用户提问:
"基于需求分析，为防止AI过度实现，请确认v1不做哪些功能：

□ OAuth第三方登录（微信/Google）
□ 手机号登录（仅邮箱）
□ 移动端适配（仅桌面端）
□ 多语言支持（仅中文）
□ 支付网关集成
□ 数据导出功能
□ 第三方平台对接（ERP/CRM）
□ 实时通知推送
□ 其他不做的事项：____"
```

### Step 3: Update CLAUDE.md Non-Goals Section

Append confirmed Non-Goals to the `## Non-Goals` section in CLAUDE.md:

```markdown
## Non-Goals

- v1不做 OAuth第三方登录
- v1不做 移动端适配
- v1不做 多语言支持
- v1不做 支付网关集成

> 触及Non-Goals时必须停止并询问用户
> 用户确认日期: YYYY-MM-DD
```

If CLAUDE.md doesn't have a Non-Goals section, create one. If it already has one, merge new items (avoid duplicates).

### Step 4: Update Status File

Update `docs/superpowers/status/{feature}-status.md`:

```markdown
## 当前阶段
non-goals-clarify

## 待处理
- 下一步: prd-generator

## 历史记录
| 追加一行 | non-goals-clarify | 完成 |
```

### Step 5: Pass to prd-generator

Non-Goals now in CLAUDE.md are automatically available as constraints for prd-generator (which reads CLAUDE.md via read-index).

## Hard Rules

- **必须向用户确认** - 不能由AI自行决定
- **必须记录到CLAUDE.md** - 不能只在对话中确认,也不能存到独立文件
- **必须传递给下游技能** - prd-generator通过读取CLAUDE.md获取Non-Goals
- **触及Non-Goals时必须停止** - AI发现需求接近Non-Goals时，必须停止并询问

## Quality Check

```
□ 读取了 {feature}-design.md
□ 基于设计草稿推断Non-Goals
□ 向用户展示确认列表
□ 用户已确认
□ 已更新CLAUDE.md的Non-Goals section
□ 已更新 {feature}-status.md
```