# Claude Code Starter Kit

> Battle-tested Konfiguration aus Monaten produktiver Nutzung. Rules, Skills, Agents, Plugins & MCP-Empfehlungen.

---

## Setup

```bash
git clone https://github.com/olli107x/claude-code-starter-kit.git
cd claude-code-starter-kit
./setup.sh        # Linux/Mac
.\setup.ps1       # Windows
```

Kopiert Rules, Skills und Agents nach `~/.claude/` und installiert die wichtigsten Plugins.

---

## Neues Projekt starten

### 1. CLAUDE.md erstellen

Die `CLAUDE.md` im Projekt-Root wird bei jedem `claude`-Start automatisch geladen. Ohne die arbeitet Claude ohne Kontext.

```bash
cp CLAUDE.md.template mein-projekt/CLAUDE.md
```

**Minimum:** Tech Stack, Projektstruktur, Konventionen, Definition of Done.

**Was den Unterschied macht:** Wichtige Dateien mit Beschreibung, Entity Relationships, Security-Regeln (was Claude NICHT darf), Feature-Checkliste (Backend → Frontend Reihenfolge).

Template: `CLAUDE.md.template`

### 2. PRD schreiben

Bevor Claude Code schreibt — PRD erstellen. Selbst oder mit Claude:

```
Ich starte ein neues Projekt: [Beschreibung].
Hilf mir ein PRD zu schreiben mit:
- Problem Statement
- Zielgruppe
- Core Features (priorisiert)
- Tech Stack Empfehlung
- MVP Scope vs. V2
Speichere es als docs/PRD.md
```

Ohne PRD fehlt der Gesamtkontext. Claude baut Features die nicht zusammenpassen, wählt den falschen Stack, oder übersieht Abhängigkeiten.

### 3. Plan Mode (Aktivieren mit SHIFT + TAB)

Statt direkt coden zu lassen — erst planen lassen:

```
Lies docs/PRD.md und die CLAUDE.md.
Erstelle einen Implementierungsplan für [Feature/MVP].
Nutze den Plan Mode.
```

Claude analysiert die Codebase, erstellt einen Plan mit konkreten Dateien und Änderungen, ihr reviewed und gebt Feedback, erst nach Approval wird implementiert.

**Nutzen bei:** Neue Features, Architektur-Entscheidungen, Refactoring über mehrere Dateien.
**Überspringen bei:** Einzelne Bugfixes, kleine Tweaks, klare Aufgaben.

### 4. Implementieren

Nach Plan-Approval — Constraints mitgeben um Fehlversuche zu vermeiden:

```
Implementiere Schritt 3 aus dem Plan.
Constraints:
- Nutze NUR die bestehende DB-Struktur
- Kein neues npm Package
- Maximale Dateigröße: 400 Zeilen
- Tests mit Vitest, nicht Jest
```

Session-Kontinuität bei langen Tasks:
```
Lies HANDOFF.md und PROGRESS.md und mach weiter wo wir aufgehört haben.
```

### 5. /audit nach Feature-Completion

```
/audit
```

Prüft Bugs, Security, Test Coverage, Plan-Vollständigkeit — parallel mit Subagents.

---

## Subagents vs. Agent Teams

### Subagent — Fire & Forget

Eigenständiger Prozess. Bekommt **nur seinen Prompt**, keinen Session-Kontext. Macht seine Aufgabe, liefert Ergebnis, Prozess endet.

```
Ihr → "Mach Security Review von backend/routes/"
       ↓
   [Subagent startet]
   - Bekommt NUR diesen Prompt
   - Kein Kontext aus eurer Session
   - Analysiert, liefert Ergebnis zurück
   - Prozess endet ← weg
       ↓
Ihr ← "3 Findings: SQL Injection in auth.py, ..."
```

Mehrere Subagents laufen parallel, wissen aber nichts voneinander:

```
Nutze parallele Subagents um:
1. Security Review von backend/app/routes/
2. Test Coverage Check von frontend/src/hooks/
3. Type-Check des gesamten Projekts
Berichte die Ergebnisse, ändere nichts.
```

### Agent Team — Koordinierte Zusammenarbeit

Team Lead erstellt Tasks, verteilt an Teammates. Die arbeiten parallel, kommunizieren aber **dauerhaft untereinander** und mit dem Lead. Jeder hat eigenen Kontext und kann Nachrichten schicken/empfangen.

```
Team Lead erstellt Task List:
  ├── Task 1: "Backend API" → Teammate 1
  ├── Task 2: "Frontend"    → Teammate 2
  └── Task 3: "Tests"       → Teammate 3

Teammate 1 → Lead: "API fertig, Endpoint ist POST /api/orders"
Lead → Teammate 2: "API-Signatur steht, hier die Types..."
Teammate 2 → Teammate 3: "Komponente fertig, teste bitte OrderCard"
Teammate 3 → Lead: "2 Tests failen, Teammate 1 muss Schema fixen"
Lead → Teammate 1: "Fix das Schema, Details von Teammate 3..."
```

### Der Unterschied

| | Subagent | Agent Team |
|---|---|---|
| **Kontext** | Nur der Prompt | Eigener Kontext + Kommunikation |
| **Kommunikation** | Keine — Ergebnis zurück, fertig | Dauerhaft untereinander + Lead |
| **Koordination** | Unabhängig | Lead verteilt, verhindert File-Konflikte |
| **Lebensdauer** | Endet nach Aufgabe | Aktiv bis Lead beendet |
| **Token-Kosten** | Mittel | Hoch (3-5x Single Session) |

### Wann was

| Situation | Ansatz |
|-----------|--------|
| Parallele Analyse/Reviews | **Subagents** |
| Full-Stack Feature (BE + FE + Tests) | **Agent Team** |
| Großes Refactoring über Module hinweg | **Agent Team** |
| Alles in einem File / sequentiell | **Single Session** |

### Agent Teams aktivieren

```json
// ~/.claude/settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**Wichtigste Regel:** Jeder Teammate arbeitet an **eigenen Dateien**. File-Konflikte sind das größte Risiko.

---

## Context Window

200k Tokens — aber **jedes Plugin/MCP schrumpft es**. Bei 20+ MCPs bleibt euch ~70k.

- Max **5-6 Plugins** gleichzeitig
- Max **5 MCPs** gleichzeitig
- Nicht gebrauchte per Projekt deaktivieren:

```json
// .claude/settings.local.json im Projekt
{
  "disabledMcpServers": ["memory", "filesystem"]
}
```

---

## Prompt-Patterns

**Constraint-First** (verhindert falsche Richtung):
```
Implementiere Feature X.
Constraints:
- Bestehende DB-Struktur, KEINE neuen Tabellen
- Kein neues npm Package
- Max 400 Zeilen pro Datei
```

**Scope-Definition** (verhindert Scope Creep):
```
Ändere NUR die Datei src/api/users.ts.
Füge einen neuen Endpoint GET /api/users/:id/stats hinzu.
Ändere NICHTS anderes.
```

**Exclude-Pattern** (wenn Claude zu viel macht):
```
Refactore den Auth-Flow.
ÜBERSPRINGE: Tests, Docs, Frontend.
NUR Backend-Änderungen.
```

---

## Session-Management

**Über mehrere Sessions:**
1. Am Ende: `/wrapup` — committet, pushed, erstellt HANDOFF.md
2. Nächste Session: `Lies HANDOFF.md und mach weiter`

**Kurze Notiz ohne Commit:**
1. `/handoff` — erstellt nur HANDOFF.md

---

## Architektur des Kits

| Konzept | Beschreibung | Ort |
|---------|-------------|-----|
| **Rules** | Immer aktiv, automatisch geladen | `~/.claude/rules/` |
| **Skills** | On-demand via `/skill-name` | `~/.claude/skills/` |
| **Agents** | Spezialisierte Sub-Agenten | `~/.claude/agents/` |
| **Plugins** | Erweitern Tools + Skills | `claude plugins install ...` |
| **MCPs** | Externe Integrationen (DB, Browser, APIs) | `claude mcp add ...` |
| **CLAUDE.md** | Projekt-Kontext im Repo-Root | `./CLAUDE.md` |

```
Rules (immer aktiv)       → Coding Style, Security, Git-Konventionen
    ↓
Skills (on-demand)        → /tdd, /audit, /wrapup, /bug-pipeline
    ↓
Agents (komplexe Tasks)   → security-reviewer, debugger, qa-engineer
    ↓
Plugins (erweitern)       → superpowers, commit-commands, code-review
    ↓
MCPs (extern)             → context7 (Docs), playwright (Browser)
```

---

## Skills (Highlights)

| Skill | Was es tut |
|-------|-----------|
| `/wrapup` | Session-Ende: Tests → Commit → Push → HANDOFF.md → Summary |
| `/handoff` | Nur HANDOFF.md, kein Commit/Push |
| `/bug-pipeline` | Autonome Bug-Fix Pipeline, parallele Agents, max 3 Retries, Revert bei Failure |
| `/orchestrate` | Multi-Agent Dispatch mit Scope-Validation und Test-Gates |
| `/doc-sync` | Docs automatisch mit Code-Stand synchronisieren |
| `/tdd` | Red-Green-Refactor Workflow |
| `/review` | Code Review mit Security-Check |
| `/audit` | Bug + Security + Test + Plan-Verification |
| `/varlock` | Secret Protection (scannt .env, Git History, Code) |

---

## Was ist drin

```
claude-code-starter-kit/
|
|-- rules/              14 Regeln (immer aktiv)
|   |-- coding-style.md        Immutability, File-Organisation, Naming
|   |-- git-workflow.md         Conventional Commits, PR-Prozess
|   |-- testing.md              TDD-Workflow, 80% Coverage
|   |-- security.md             Pre-Commit Security Checklist
|   |-- performance.md          Context Window, Model-Auswahl
|   |-- agents.md               Agent-Delegation, Parallel Execution
|   |-- critical-behaviors.md   Exclusions, Data Verify, Type Propagation
|   |-- usage-patterns.md       Upfront Constraints, Session Continuity
|   |-- audit-workflow.md       Audit-Orchestrierung
|   |-- audit-bug.md            Bug-Audit Checkliste
|   |-- audit-security.md       OWASP Top 10
|   |-- audit-test.md           Test Coverage Audit
|   +-- audit-plan-verification.md  Plan-Verifizierung
|
|-- skills/              45+ Skills in 5 Kategorien
|   |-- development/     18 Skills (TDD, Debugging, Architecture, Git, ...)
|   |-- testing/          3 Skills (PICT, Browser-Testing, Website-Audit)
|   |-- productivity/     5 Skills (Wrapup, Handoff, Kaizen, ...)
|   |-- documents/        5 Skills (DOCX, XLSX, PDF, PPTX, EPUB)
|   +-- utilities/       12 Skills (Varlock, Article Extractor, CSV, ...)
|
|-- agents/              20 Agents
|   |-- engineering/     Backend, Frontend, DB, Architektur-Review, Performance
|   |-- design/          UI, Dashboard, Brand, UX
|   |-- testing/         QA, Security, API-Testing, Debugging, Brutal-Critic
|   +-- utility/         Explorer, Historian, Research, Doc-Updater
|
|-- docs/                Templates
|   |-- debugging-methodology.md
|   |-- debugging-cheatsheet.md
|   |-- definition-of-done.md
|   +-- code-standards.md
|
|-- plugins.md           Plugin-Empfehlungen + Install
|-- mcps.md              MCP-Server Guide
|-- CLAUDE.md.template   Projekt-CLAUDE.md Vorlage
|-- settings-template.json
|-- setup.sh             Linux/Mac
+-- setup.ps1            Windows
```

---

## Links

| Ressource | URL |
|-----------|-----|
| Claude Code Docs | https://docs.anthropic.com/en/docs/claude-code/overview |
| Claude Code GitHub | https://github.com/anthropics/claude-code |
| MCP Server Registry | https://github.com/modelcontextprotocol/servers |
| Claude Model Docs | https://docs.anthropic.com/en/docs/about-claude/models |

---

*Von Olli für das DVC-Entwicklerteam. Issues oder Olli direkt ansprechen.*
