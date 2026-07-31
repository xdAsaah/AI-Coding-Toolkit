---
name: "claude-md-creator"
description: "Create and maintain CLAUDE.md and project index files for Superpowers. Invoke when: new project, optimize existing CLAUDE.md, or project structure changed."
---

# CLAUDE.md Creator

## 执行规则

- CLAUDE.md只做路由，不存放详细信息（避免上下文腐烂）
- 详细项目索引单独存放在docs/目录，按需读取
- 必须包含Constitution（不可协商原则）
- 必须包含Non-Goals（明确不做）
- 必须向用户确认Non-Goals
- 项目索引文件由本技能生成（冷启动时），由spec-sync技能维护（开发过程中）
- 本技能只在冷启动和手动"更新索引"时扫描项目结构

---

## 冷启动

### 步骤1：解析需求

提取：
- What: 做什么
- Why: 为什么
- Constraints: 约束
- Non-Goals: 推断的Non-Goals（待确认）

### 步骤2：确认Non-Goals（必须）

```
向用户提问:
"请确认v1不做哪些功能（防止AI过度实现）：
□ OAuth第三方登录
□ 移动端适配
□ 多语言支持
□ 支付网关集成
□ 数据导出
□ 其他不做的事项？"
```

### 步骤3：生成项目索引文件（4个）

扫描项目结构，生成以下4个索引文件：

#### 文件1: `docs/project-index.md`

```markdown
# 项目文件索引

> AI开发前必读，避免重复探索目录结构。

## 入口点
| 入口类型 | 文件路径 | 说明 |
|----------|---------|------|
| 应用入口 | src/main.ts | 程序启动入口 |
| 路由入口 | src/router/index.ts | API路由注册 |
| 配置入口 | src/config/index.ts | 配置加载 |

## 目录用途
| 目录 | 用途 | 关键文件 |
|------|------|---------|
| src/api/ | API接口层 | routes.ts, middleware.ts |
| src/services/ | 业务逻辑层 | auth.service.ts |
| src/models/ | 数据模型 | user.model.ts |
| src/utils/ | 工具函数 | logger.ts, validator.ts |
| tests/ | 测试文件 | 按模块组织 |

## 关键配置文件
| 文件 | 用途 |
|------|------|
| .env.example | 环境变量模板 |
| tsconfig.json | TypeScript配置 |
| docker-compose.yml | 本地开发环境 |
```

#### 文件2: `docs/dependency-map.md`

```markdown
# 模块依赖关系

> 跨模块修改前必读，理解影响范围。

## 依赖方向
api/ → services/ → models/ → utils/
api/ → middleware/ (认证、日志、错误处理)

## 模块职责边界
| 模块 | 职责 | 对外接口 |
|------|------|---------|
| api/ | 接收请求、参数校验、返回响应 | HTTP路由 |
| services/ | 业务逻辑编排 | Service类方法 |
| models/ | 数据持久化 | Model CRUD方法 |
| utils/ | 通用工具 | 纯函数 |

## 禁止的依赖方向
- models/ → services/ （数据层不依赖业务层）
- utils/ → services/ （工具层不依赖业务层）
```

#### 文件3: `docs/conventions.md`

```markdown
# 代码约定

> 代码中看不出的约定，开发前必读。

## 命名约定
- API路由统一在 src/api/routes.ts 注册
- 新增Service必须在 src/services/index.ts 导出
- 数据库迁移文件命名: {timestamp}_{action}.ts

## 错误处理约定
- 统一使用 AppError 类
- 错误码格式: {模块}_{错误类型}_{序号}

## 测试约定
- 测试文件与源文件同目录
- 命名: {filename}.test.ts
- 每个验收标准至少1个测试用例
```

#### 文件4: `docs/doc-index.md`

```markdown
# 文档索引

> 最后更新: 2026-07-16
> AI开发前必读，避免重复创建已有文档。

## PRD 文档
| 功能 | 文件路径 | 状态 | 最后更新 |
|------|---------|------|---------|
| (空) | | | |

## Spec 文档
| 功能 | 设计草稿 | 技术spec | 状态 |
|------|---------|---------|------|
| (空) | | | |

## ADR 文档
| 序号 | 标题 | 文件路径 | 状态 |
|------|------|---------|------|
| (空) | | | |

## API契约
| 文件 | 状态 | 最后更新 |
|------|------|---------|
| docs/arch/api-contract.md | (待创建) | - |
```

### 步骤4：生成CLAUDE.md（精简，只做路由）

```markdown
# Project Constitution

## What
[做什么]

## Why
[为什么]

## Constitution

### 技术标准
- [技术栈]

### 质量要求
- 测试覆盖率 ≥ 80%
- 所有代码必须通过 lint
- 所有API必须有错误处理

### 简化原则
- 初始特性数 ≤ 3
- 禁止引入未列出的依赖

## Non-Goals

- v1不做[功能A]
- v1不做[功能B]

> 触及Non-Goals时必须停止并询问用户

## 构建命令
```bash
[命令列表]
```

## 项目索引（按需读取）

| 何时读取 | 索引文件 |
|----------|---------|
| 开始新功能开发前 | docs/project-index.md |
| 跨模块修改时 | docs/dependency-map.md |
| 不确定代码约定时 | docs/conventions.md |
| 检查已有文档时 | docs/doc-index.md |

## 文档地图（按需读取）

| 任务类型 | 必读文档 |
|----------|----------|
| 新功能 | docs/prd/features/{feature}.md |
| 修改现有功能 | docs/prd/features/{feature}.md |
| Bug修复 | docs/superpowers/plans/{feature}.md |
| 重构 | docs/arch/decisions/ + docs/superpowers/specs/ |

## 红线

- 禁止违反Constitution
- 禁止实现Non-Goals
- 禁止改代码不更新文档
- 禁止跳过Superpowers流程

## Superpowers Workflow

brainstorming → non-goals-clarify → prd-generator → writing-plans → test-driven-development → doc-checker → spec-archive
```

---

## 质量检查

```
□ Constitution已定义
□ Non-Goals已确认
□ CLAUDE.md只包含路由信息（无详细索引）
□ docs/project-index.md已生成
□ docs/dependency-map.md已生成
□ docs/conventions.md已生成
□ docs/doc-index.md已生成
□ 构建命令完整
□ 文档地图完整
□ Superpowers工作流已包含
```

---

## 触发场景

| 用户说 | 执行 |
|--------|------|
| "创建项目" | 冷启动流程（生成CLAUDE.md + 3个索引文件）|
| "优化CLAUDE.md" | 检查缺失项并补充 |
| "更新索引" | 重新扫描项目结构，更新3个索引文件 |
| 项目结构变更 | 由spec-sync提示触发索引更新 |