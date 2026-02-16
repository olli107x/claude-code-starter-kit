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
| Security concerns | security-reviewer | Auto |
| Build errors | build-error-resolver | `/build-fix` |
| Dead code cleanup | refactor-cleaner | `/refactor-clean` |
| Doc out of sync | doc-updater | Auto |
| **Production down/crash/502/503** | debugger | **`/prod-debug`** |
| **Server logs with errors** | debugger | **`/prod-debug`** |
| **Health Check failed** | debugger | **`/prod-debug`** |
| **Plan-Umsetzung abgeschlossen** | audit-system | **`/audit`** |
| **Vor wichtigem Commit** | audit-system | **`/audit`** |
| **Bug-Suche** | debugger, brutal-critic | `/audit-bug` |
| **Security Check** | security-reviewer | `/audit-security` |
| **Test Verification** | qa-engineer | `/audit-test` |
| **Parallelisierbarer Task (3+ unabhaengige Teile)** | Agent Team | Vorschlagen + Bestaetigung |
| **Architecture Review** | architecture-reviewer | Plan mode |
| **Performance Issues** | performance-profiler | Auto |
| **Plan Verification (deep)** | superpowers:code-reviewer | `/audit-verify` |

---

## KRITISCH: Production Debugging

**Bei JEDEM Production-Problem ZUERST:**

1. **Frage:** "Hast du kürzlich etwas geändert?" (Code, ENV, Passwort, Config)
2. **Logs:** Server Logs anfordern und VOLLSTÄNDIG lesen
3. **Hypothese:** Bilden und VERIFIZIEREN bevor Fix
4. **Rollback:** Nach 15 Min ohne Lösung → Rollback empfehlen

**NIEMALS:**
- Blind Code ändern ohne Root Cause
- Mehrere Fixes gleichzeitig
- Logs nur überfliegen

Siehe: `.claude/skills/production-debugging.md`

---

## Agent Teams (Experimentell)

**Agent Teams = mehrere Claude Code Instanzen, die parallel arbeiten und untereinander kommunizieren.**

### PFLICHT: User muss bestaetigen!

Agent Teams NIEMALS ohne Bestaetigung des Users starten. Immer vorschlagen + begruenden:

```
"Dieses Feature hat 3 unabhaengige Teile (Backend, Frontend, Tests).
 Soll ich ein Agent Team mit 3 Teammates aufsetzen?"
```

### Wann Agent Teams vorschlagen

| Situation | Vorschlagen? | Begruendung |
|-----------|-------------|-------------|
| Full-Stack Feature (BE + FE + Tests) | **Ja** | 3 unabhaengige Arbeitsbereiche |
| Parallel Code Review (Security + Perf + Tests) | **Ja** | Verschiedene Perspektiven gleichzeitig |
| Debugging mit mehreren Hypothesen | **Ja** | Hypothesen parallel testen |
| Grosse Refactoring-Tasks (>5 Files, verschiedene Module) | **Ja** | Unabhaengige Module parallel |
| Research + Implementation parallel | **Ja** | Recherche blockiert nicht Coding |
| Single-File Bug Fix | **Nein** | Overhead > Nutzen |
| Sequentielle Abhaengigkeiten | **Nein** | Teammates wuerden aufeinander warten |
| Gleiches File betroffen | **Nein** | File-Konflikte vermeiden |
| Kleine UI-Anpassung | **Nein** | Single Session reicht |

### Agent Teams vs. Subagents vs. Single Session

| Ansatz | Wann | Token-Kosten |
|--------|------|-------------|
| **Single Session** | Einfache Tasks, sequentielle Arbeit | Niedrig |
| **Subagents** | Fokussierte Recherche, Ergebnis zurueck an Haupt-Session | Mittel |
| **Agent Teams** | Parallele Arbeit, Teammates muessen kommunizieren | Hoch |

### Team-Vorlagen

**Full-Stack Feature:**
```
Team Lead: Koordination + Code Review
Teammate 1: Backend (Model → Schema → Service → Route)
Teammate 2: Frontend (Types → Hook → Page → Components)
Teammate 3: Tests (pytest + vitest)
```

**Audit Team:**
```
Team Lead: Ergebnisse zusammenfuehren
Teammate 1: Bug Audit (debugger)
Teammate 2: Security Audit (security-reviewer)
Teammate 3: Test Audit (qa-engineer)
```

**Research Team:**
```
Team Lead: Synthese
Teammate 1: API-Dokumentation lesen
Teammate 2: Codebase analysieren
Teammate 3: Prototyp bauen
```

### Steuerung (In-Process Modus)

| Aktion | Shortcut |
|--------|----------|
| Teammate wechseln | **Shift+Up/Down** |
| Task List anzeigen | **Ctrl+T** |
| Teammate-Session oeffnen | **Enter** |
| Delegate Mode (Lead nur Koordination) | **Shift+Tab** |

### Regeln fuer Teammates

- Jeder Teammate arbeitet an **eigenen Files** — keine Ueberschneidungen
- Lead erstellt Tasks und weist zu — Teammates claimen selbstaendig nach
- Plan Approval aktivieren fuer riskante Aenderungen
- File-Konflikte = groesstes Risiko → Arbeit klar aufteilen

---

## Parallel Execution (Subagents)

**ALWAYS use parallel Task execution for independent operations!**

### CORRECT (Parallel):
```
Task 1: Security analysis
Task 2: Performance review     → Run ALL simultaneously
Task 3: Type checking
```

### WRONG (Sequential):
```
Task 1: Security analysis → wait →
Task 2: Performance review → wait →
Task 3: Type checking
```

---

## Available Agents

### Engineering Agents
| Agent | Use For |
|-------|---------|
| `db-architect` | Schema design, migrations, queries |
| `backend-architect` | API design, service layer |
| `frontend-developer` | React components, hooks |
| `architecture-reviewer` | SOLID, separation of concerns, scalability review |
| `performance-profiler` | Re-render analysis, async bottlenecks, query perf |

### Design Agents
| Agent | Use For |
|-------|---------|
| `ui-designer` | Component design, layouts |
| `dashboard-crafter` | Data viz, charts |
| `brand-guardian` | Brand compliance |
| `ux-polisher` | Interactions, accessibility |

### Data Agents
| Agent | Use For |
|-------|---------|
| `data-specialist` | External data sources, data pipeline |
| `analytics-reporter` | KPIs, reports |

### Testing Agents
| Agent | Use For |
|-------|---------|
| `api-tester` | Backend tests |
| `qa-engineer` | Test planning |
| `security-reviewer` | Security audit |
| `brutal-critic` | Pre-ship review |
| `debugger` | Systematic debugging |

### Utility Agents
| Agent | Use For |
|-------|---------|
| `explorer` | Code navigation |
| `historian` | Session checkpoints |
| `research-documenter` | API research |

---

## Multi-Perspective Analysis

For complex challenges, use split-role sub-agents:

1. **Factual Reviewer** - Accuracy check
2. **Senior Engineer** - Code quality
3. **Security Expert** - Vulnerability scan
4. **Consistency Reviewer** - Pattern adherence
5. **Redundancy Checker** - DRY violations

---

## Audit System

**Nach Plan-Umsetzung oder vor wichtigen Commits automatisch ausfuehren!**

### Audit Workflow

```
┌──────────┐  ┌──────────┐  ┌──────────┐
│Bug Audit │  │Security  │  │Test Audit│  ← PARALLEL
└────┬─────┘  └────┬─────┘  └────┬─────┘
     └─────────────┼─────────────┘
                   ▼
         ┌─────────────────┐
         │Plan Verification│              ← SEQUENTIAL (last)
         └────────┬────────┘
                  ▼
            FINAL REPORT
```

### Audit Commands

| Command | Beschreibung |
|---------|--------------|
| `/audit` | Full Audit (alle 4) |
| `/audit-bug` | Nur Bug Audit |
| `/audit-security` | Nur Security Audit |
| `/audit-test` | Nur Test Audit |
| `/audit-verify` | Nur Plan Verification |

### Blocking Rules

| Severity | Action |
|----------|--------|
| CRITICAL/HIGH | ❌ Hard Block - MUSS gefixt werden |
| MEDIUM | ⚠️ Warning - Sollte gefixt werden |
| LOW | ℹ️ Info - Optional |

**Details:** `audit-workflow.md`, `audit-bug.md`, `audit-security.md`, `audit-test.md`, `audit-plan-verification.md`

---

## Quick Reference

```
/tdd         → Test-driven development
/review      → Code review
/build-fix   → Fix build errors
/refactor-clean → Remove dead code
/deploy      → Pre-deployment checklist
/audit       → Full code audit (Bug, Security, Test, Plan)
/prod-debug  → Production debugging
```

*Source: Adapted from everything-claude-code/rules/agents.md*
