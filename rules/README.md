# Claude Code Starter Kit -- Rules

> **ALWAYS-FOLLOW guidelines for every session.**

Rules are loaded into context and enforced automatically. Place these files in your `.claude/rules/` directory (global) or your project's `.claude/rules/` directory (project-specific).

---

## What Are Rules?

Rules are markdown files that Claude Code loads into context at the start of every session. They define coding standards, workflows, and quality gates that Claude will follow automatically. Unlike Skills (which are loaded on-demand), Rules are always active.

| Aspect | Rules | Skills |
|--------|-------|--------|
| Loading | Always active | On-demand |
| Scope | Global | Feature-specific |
| Enforcement | Mandatory | Optional |
| Override | Never | User can skip |

---

## Rule Files

### Core Rules

| File | Purpose | What It Covers |
|------|---------|----------------|
| `coding-style.md` | Code quality standards | Immutability, file organization, naming conventions |
| `git-workflow.md` | Version control process | Conventional commits, PR process, branch strategy |
| `testing.md` | Test requirements | TDD workflow, 80% coverage minimum, anti-patterns |
| `security.md` | Security checklist | Pre-commit security checks, secret management, OWASP |
| `performance.md` | Context & model management | Context window strategy, model selection, MCP limits |
| `agents.md` | Agent delegation | When to delegate, agent teams, parallel execution |

### Audit Rules

The audit system provides a structured quality gate before commits and after plan implementations.

| File | Purpose | What It Covers |
|------|---------|----------------|
| `audit-workflow.md` | Audit orchestration | Trigger rules, execution flow, blocking logic |
| `audit-bug.md` | Bug detection | Exception handling, null safety, async patterns |
| `audit-security.md` | Security scanning | OWASP Top 10 checklist, vulnerability patterns |
| `audit-test.md` | Test verification | Coverage requirements, test quality, edge cases |
| `audit-plan-verification.md` | Plan completion check | Implementation verification, Definition of Done |

---

## How They Work Together

```
Before Feature:
  performance.md  ->  Check context window, choose model
  agents.md       ->  Consider delegation for complex tasks

During Coding:
  coding-style.md ->  Immutability, small files, naming
  testing.md      ->  TDD workflow (Red-Green-Refactor)
  security.md     ->  No hardcoded secrets, input validation

Before Commit:
  git-workflow.md ->  Conventional commit format
  security.md     ->  Pre-commit security checklist
  testing.md      ->  All tests passing, 80%+ coverage

After Plan Implementation:
  audit-workflow.md  ->  Triggers full audit
  audit-bug.md       ->  Bug patterns check (parallel)
  audit-security.md  ->  OWASP scan (parallel)
  audit-test.md      ->  Test coverage check (parallel)
  audit-plan-verification.md  ->  Plan completion (sequential, last)
```

---

## Quick Reference

### Before Commit
- [ ] Security checklist (security.md)
- [ ] Tests pass (testing.md)
- [ ] Conventional commit (git-workflow.md)
- [ ] **Run `/audit` for important commits**

### Before Feature
- [ ] Check context window (performance.md)
- [ ] Consider agent delegation (agents.md)

### After Plan Implementation
- [ ] **Run `/audit` - Full audit (Bug, Security, Test, Plan Verify)**
- [ ] Check audit report in `docs/audits/`
- [ ] Fix any CRITICAL/HIGH issues before proceeding

### During Coding
- [ ] Immutability (coding-style.md)
- [ ] Small files (coding-style.md)

---

## Audit Commands

```
/audit           -> Full Audit (recommended)
/audit-bug       -> Bug detection only
/audit-security  -> Security scan only
/audit-test      -> Test verification only
/audit-verify    -> Plan completion only
```

**Output:** `docs/audits/audit-YYYY-MM-DD-HHMMSS.md`

---

## Getting Started

1. Copy the `rules/` directory into your `.claude/rules/` folder
2. Customize project-specific sections (e.g., test paths, endpoint patterns)
3. Remove any rules that don't apply to your stack
4. Claude Code will automatically load and follow these rules in every session

**Tip:** Start with `coding-style.md`, `git-workflow.md`, and `security.md` as a minimal set. Add audit rules when your project matures.
