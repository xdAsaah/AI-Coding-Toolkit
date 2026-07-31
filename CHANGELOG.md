# Changelog

## [1.0.0] - 2026-07-31

### Added
- 14 engineering discipline skills (from Superpowers)
  - brainstorming, writing-plans, test-driven-development
  - subagent-driven-development, executing-plans
  - requesting-code-review, receiving-code-review
  - finishing-a-development-branch, systematic-debugging
  - verification-before-completion, using-git-worktrees
  - dispatching-parallel-agents, writing-skills
  - using-superpowers (enhanced version, integrating document-driven workflows)
- 7 document-driven skills (original)
  - claude-md-creator, non-goals-clarify, prd-generator
  - adr-creator, doc-checker, spec-sync, spec-archive
- 4 document templates: prd-full.md, prd-light.md, adr.md, spec.md
- one-click install scripts (install.sh / install.ps1)
- complete workflow orchestration: read-index → brainstorming → ... → spec-archive
- project index system: project-index.md, dependency-map.md, conventions.md, doc-index.md
- status file tracking: {feature}-status.md runs through the entire development workflow
- ADR intelligent filtering: triggers only on key decisions
- doc-checker compatibility safety valve: non-breaking changes don't block merge
