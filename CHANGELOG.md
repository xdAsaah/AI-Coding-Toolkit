# Changelog

## [1.0.0] - 2026-07-31

### Added
- 14 个工程纪律技能（来自 Superpowers）
  - brainstorming, writing-plans, test-driven-development
  - subagent-driven-development, executing-plans
  - requesting-code-review, receiving-code-review
  - finishing-a-development-branch, systematic-debugging
  - verification-before-completion, using-git-worktrees
  - dispatching-parallel-agents, writing-skills
  - using-superpowers（增强版，集成文档驱动流程）
- 7 个文档驱动技能（原创）
  - claude-md-creator, non-goals-clarify, prd-generator
  - adr-creator, doc-checker, spec-sync, spec-archive
- 4 个文档模板：prd-full.md, prd-light.md, adr.md, spec.md
- 一键安装脚本（install.sh / install.ps1）
- 完整的工作流编排：read-index → brainstorming → ... → spec-archive
- 项目索引体系：project-index.md, dependency-map.md, conventions.md, doc-index.md
- 状态文件追踪：{feature}-status.md 贯穿整个开发流程
- ADR 智能过滤：仅在关键决策时触发
- doc-checker 兼容性安全阀：非破坏性变更不阻断合并
