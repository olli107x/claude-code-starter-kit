# Agent Delegation Rules

> **WHEN TO DELEGATE**: Use specialized agents for complex tasks.

---

## Automatic Delegation Triggers

| Trigger | Agent | Command |
|---------|-------|---------|
| Complex feature request | planner | `/plan` |
| Code written | code-reviewer | `/review` |
| Bug fix or new feature | tdd-guide | `/tdd` |
| Architectural decisions | architect | Plan mode |
| Architecture review | architecture-reviewer | Plan mode |
| Security concerns | security-reviewer | Auto |
| Performance issues | performance-profiler | Auto |
| Build errors | build-error-resolver | `/build-fix` |
| Dead code cleanup | refactor-cleaner | `/refactor-clean` |
| Doc out of sync | doc-updater | Auto |
| Production down/crash | debugger | `/prod-debug` |
| Plan-Umsetzung abgeschlossen | audit-system | `/audit` |
| Vor wichtigem Commit | audit-system | `/audit` |
| Parallelisierbarer Task (3+) | Subagents oder Agent Team | Vorschlagen |

---

## Parallel Execution (Subagents)

**ALWAYS use parallel Task execution for independent operations!**

```
CORRECT (Parallel):
Task 1: Security analysis
Task 2: Performance review     → Run ALL simultaneously
Task 3: Type checking

WRONG (Sequential):
Task 1 → wait → Task 2 → wait → Task 3
```

---

## Agent Teams

**Agent Teams NIEMALS ohne Bestätigung starten.** Immer vorschlagen + begründen.

| Ansatz | Wann | Token-Kosten |
|--------|------|-------------|
| **Single Session** | Einfache Tasks, sequentiell | Niedrig |
| **Subagents** | Parallele Recherche, Fire & Forget | Mittel |
| **Agent Teams** | Parallele Arbeit, Kommunikation nötig | Hoch (3-5x) |

**Wichtigste Regel:** Jeder Teammate arbeitet an **eigenen Dateien**. File-Konflikte sind das größte Risiko.

---

## Audit System

Nach Plan-Umsetzung oder vor wichtigen Commits:

| Command | Beschreibung |
|---------|--------------|
| `/audit` | Full Audit (Bug + Security + Test + Plan) |
| `/audit-bug` | Nur Bug Audit |
| `/audit-security` | Nur Security Audit |
| `/audit-test` | Nur Test Audit |
| `/audit-verify` | Nur Plan Verification |

---

## Quick Reference

```
/tdd            → Test-driven development
/review         → Code review
/build-fix      → Fix build errors
/refactor-clean → Remove dead code
/audit          → Full code audit
/prod-debug     → Production debugging
```
