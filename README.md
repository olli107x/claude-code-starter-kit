# Claude Code Starter Kit

> Battle-tested Claude Code Konfiguration, destilliert aus Monaten produktiver Nutzung. Rules, Skills, Agents, Plugins & MCP-Empfehlungen für euer Team.

---

## Neues Projekt starten — Der Workflow

Das hier ist der wichtigste Teil. So sieht ein erprobter Workflow aus, wenn ihr ein neues Projekt mit Claude Code aufsetzt.

### Schritt 1: CLAUDE.md erstellen

**Das Erste, was ihr macht.** Die `CLAUDE.md` ist das Briefing für Claude — sie liegt im Projekt-Root und wird automatisch bei jedem Start gelesen. Ohne CLAUDE.md arbeitet Claude blind.

```bash
cp CLAUDE.md.template mein-projekt/CLAUDE.md
```

**Was rein muss (Minimum):**
- Tech Stack (Sprachen, Frameworks, Datenbank)
- Projektstruktur (wo liegt was)
- Konventionen (Naming, Patterns, Anti-Patterns)
- Definition of Done (wann ist ein Feature fertig)

**Was den Unterschied macht:**
- Wichtige Dateien mit Beschreibung (damit Claude weiß wo es nachschauen soll)
- Entity Relationships / Datenmodell
- Security-Regeln (was Claude NICHT tun darf)
- Feature-Checkliste (Backend → Frontend Reihenfolge)

Template: `CLAUDE.md.template` in diesem Kit.

### Schritt 2: PRD schreiben (Product Requirements Document)

Bevor ihr Claude auch nur eine Zeile Code schreiben lasst — schreibt ein PRD. Entweder selbst oder lasst Claude dabei helfen:

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

**Warum?** Ohne PRD fehlt Claude der Gesamtkontext. Es baut Features die nicht zusammenpassen, wählt den falschen Tech Stack, oder übersieht Abhängigkeiten. Das PRD ist das Fundament.

### Schritt 3: Plan Mode nutzen

**Plan Mode ist extrem wertvoll.** Statt Claude direkt coden zu lassen, lasst es erst einen Plan erstellen:

```
Lies docs/PRD.md und die CLAUDE.md.
Erstelle einen Implementierungsplan für [Feature/MVP].
Nutze den Plan Mode.
```

**Was Plan Mode macht:**
1. Claude analysiert die Codebase (liest Dateien, versteht Struktur)
2. Erstellt einen detaillierten Plan mit konkreten Dateien und Änderungen
3. Ihr reviewed den Plan und gebt Feedback
4. Erst nach Approval beginnt die Implementierung

**Wann Plan Mode nutzen:**
- Neue Features (immer)
- Architektur-Entscheidungen
- Refactoring über mehrere Dateien
- Alles was mehr als 2-3 Dateien betrifft

**Wann NICHT:**
- Einzelne Bugfixes
- Kleine Tweaks (CSS, Texte)
- Wenn ihr genau wisst was geändert werden muss

### Schritt 4: Implementieren

Nach Plan-Approval implementiert Claude den Plan Schritt für Schritt. Wichtige Patterns:

**Upfront Constraints setzen (spart Token und Fehlversuche):**
```
Implementiere Schritt 3 aus dem Plan.
Constraints:
- Nutze NUR die bestehende DB-Struktur
- Kein neues npm Package
- Maximale Dateigröße: 400 Zeilen
- Tests mit Vitest, nicht Jest
```

**Session-Kontinuität bei langen Tasks:**
```
Lies HANDOFF.md und PROGRESS.md und mach weiter wo wir aufgehört haben.
```

### Schritt 5: /audit nach Feature-Completion

Nach jeder größeren Implementierung:
```
/audit
```

Prüft automatisch: Bugs, Security, Test Coverage, Plan-Vollständigkeit.

---

## Agent Teams (Fortgeschritten)

Agent Teams = mehrere Claude Code Instanzen, die **parallel** arbeiten. Extrem mächtig für große Features — aber **tokenintensiv**.

### Wann Agent Teams Sinn machen

| Situation | Agent Team? | Begründung |
|-----------|-------------|------------|
| Full-Stack Feature (BE + FE + Tests) | **Ja** | 3 unabhängige Arbeitsbereiche |
| Paralleler Code Review (Security + Performance) | **Ja** | Verschiedene Perspektiven gleichzeitig |
| Großes Refactoring (>5 Files, verschiedene Module) | **Ja** | Unabhängige Module parallel |
| Single-File Bug Fix | **Nein** | Overhead > Nutzen |
| Sequentielle Abhängigkeiten | **Nein** | Agents würden aufeinander warten |
| Gleiches File betroffen | **Nein** | File-Konflikte |

### Token-Kosten Vergleich

| Ansatz | Wann | Token-Kosten |
|--------|------|-------------|
| **Single Session** | Einfache Tasks, sequentielle Arbeit | Niedrig |
| **Subagents (Task Tool)** | Parallele Recherche, Ergebnis zurück an Haupt-Session | Mittel |
| **Agent Teams** | Parallele Implementierung, Teammates kommunizieren | **Hoch** (3-5x Single Session) |

### Agent Teams aktivieren

```json
// In ~/.claude/settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**Wichtigste Regel:** Jeder Teammate arbeitet an **eigenen Dateien** — keine Überschneidungen. File-Konflikte sind das größte Risiko.

---

## Was ist in diesem Kit?

```
claude-code-starter-kit/
|
|-- rules/              Globale Regeln (14 Dateien)
|   |-- coding-style.md        Immutability, File-Organisation, Naming
|   |-- git-workflow.md         Conventional Commits, PR-Prozess
|   |-- testing.md              TDD-Workflow, 80% Coverage
|   |-- security.md             Pre-Commit Security Checklist
|   |-- performance.md          Context Window Management, Model-Auswahl
|   |-- agents.md               Agent-Delegation, Parallel Execution
|   |-- critical-behaviors.md   Verhaltensregeln (Exclusions, Data Verify, Types)
|   |-- usage-patterns.md       Upfront Constraints, Parallel Agents, Session Continuity
|   |-- audit-workflow.md       Audit-Orchestrierung
|   |-- audit-bug.md            Bug-Audit Checkliste
|   |-- audit-security.md       OWASP Top 10 Checks
|   |-- audit-test.md           Test Coverage Audit
|   |-- audit-plan-verification.md  Plan-Verifizierung
|   +-- README.md               Übersicht aller Rules
|
|-- skills/              Wiederverwendbare Skills (40+ in 5 Kategorien)
|   |-- development/            17 Skills
|   |   |-- systematic-debugging/     Hypothesen-basierte Bug-Analyse
|   |   |-- test-driven-development/  Red-Green-Refactor Workflow
|   |   |-- bug-pipeline/             Autonome Bug-Fix Pipeline (parallel, max 3 Retries)
|   |   |-- orchestrate/              Multi-Agent Dispatch mit Scope-Validation
|   |   |-- doc-sync/                 Auto-Sync aller Docs mit Code-Stand
|   |   |-- verification-before-completion/  Pre-Commit Verification
|   |   |-- software-architecture/    Clean Architecture, DDD
|   |   |-- skill-creator/            Eigene Skills bauen
|   |   |-- mcp-builder/              MCP Server bauen (Python + TS)
|   |   |-- finishing-a-development-branch/  Branch-Completion Workflow
|   |   |-- git-pushing/              Smart Commit + Push
|   |   |-- review-implementing/      Code Review Feedback umsetzen
|   |   |-- subagent-driven-development/   Parallele Task-Ausführung
|   |   |-- prompt-engineering/       LLM Prompting Best Practices
|   |   |-- changelog-generator/      Git Commits -> Release Notes
|   |   |-- test-fixing/              Systematisch Tests fixen
|   |   +-- using-git-worktrees/      Isolierte Workspaces
|   |-- testing/              2 Skills (PICT, Playwright)
|   |-- productivity/         5 Skills
|   |   |-- wrapup/                   Session-Ende Ritual (6 Phasen)
|   |   |-- handoff/                  Leichtgewichtige Kontextübergabe
|   |   |-- kaizen/                   Iterative Verbesserung
|   |   |-- ship-learn-next/          Lerninhalte -> Action Plans
|   |   +-- tapestry/                 Content Extraction + Planning
|   |-- documents/            5 Skills (DOCX, XLSX, PDF, PPTX, EPUB)
|   +-- utilities/            11 Skills (Article Extractor, Connect, CSV, etc.)
|
|-- agents/              Spezialisierte Agent-Definitionen (18 Agents)
|   |-- engineering/          Backend, Frontend, DB-Architektur
|   |-- design/               UI, Dashboard, Brand, UX
|   |-- testing/              QA, Security, API-Testing, Debugging
|   +-- utility/              Explorer, Historian, Research, Doc-Updater
|
|-- docs/                Generische Dokumentations-Templates
|   |-- debugging-methodology.md    Systematischer Debugging-Leitfaden
|   |-- debugging-cheatsheet.md     Quick Reference
|   |-- definition-of-done.md       Feature-Completion Checkliste
|   +-- code-standards.md           Python + TypeScript Standards
|
|-- plugins.md           Plugin-Empfehlungen mit Install-Befehlen
|-- mcps.md              MCP-Server Guide
|-- CLAUDE.md.template   Vorlage für projekt-spezifische CLAUDE.md
|-- settings-template.json  Empfohlene Einstellungen
|-- setup.sh             Installations-Script (Linux/Mac)
+-- setup.ps1            Installations-Script (Windows)
```

---

## Quick Start

### 1. Setup-Script ausführen

**Linux / Mac:**
```bash
git clone https://github.com/olli107x/claude-code-starter-kit.git
cd claude-code-starter-kit
chmod +x setup.sh
./setup.sh
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/olli107x/claude-code-starter-kit.git
cd claude-code-starter-kit
.\setup.ps1
```

Das Script installiert die wichtigsten Plugins und kopiert Rules, Skills und Agents nach `~/.claude/`.

### 2. CLAUDE.md für euer Projekt erstellen

```bash
cp CLAUDE.md.template mein-projekt/CLAUDE.md
```

Platzhalter mit euren Projekt-Infos füllen. Ohne CLAUDE.md arbeitet Claude blind.

### 3. Loslegen

```bash
cd mein-projekt
claude
```

---

## Konzepte auf einen Blick

| Konzept | Was | Wo |
|---------|-----|-----|
| **Rules** | Immer aktive Regeln, automatisch geladen | `~/.claude/rules/` |
| **Skills** | On-demand via `/skill-name` | `~/.claude/skills/` |
| **Agents** | Spezialisierte Sub-Agenten für komplexe Tasks | `~/.claude/agents/` |
| **Plugins** | Erweiterungen (Tools + Skills) | `claude plugins install ...` |
| **MCPs** | Externe Tool-Integrationen (DB, Browser, APIs) | `claude mcp add ...` |
| **CLAUDE.md** | Projekt-spezifischer Kontext im Repo-Root | `./CLAUDE.md` |

### Wie Rules, Skills und Agents zusammenspielen

```
Rules (immer aktiv)          → Claude befolgt automatisch Coding Style, Security, Git-Konventionen
                                ↓
Skills (on-demand)           → /tdd startet TDD-Workflow, /audit prüft Code-Qualität
                                ↓
Agents (bei komplexen Tasks) → security-reviewer scannt nach OWASP, debugger isoliert Root Cause
                                ↓
Plugins (erweitern Tools)    → superpowers fügt /tdd, /debug, /verify Skills hinzu
                                ↓
MCPs (externe Integrationen) → context7 liefert aktuelle Library-Docs, playwright testet im Browser
```

---

## WARNUNG: Context Window

Claude Code hat 200k Tokens Context Window — aber **jedes Plugin/MCP schrumpft es**. Bei 20+ MCPs kann das Window auf ~70k schrumpfen.

**Empfehlung:**
- Max **5-6 Plugins** gleichzeitig aktiv
- Max **5 MCPs** gleichzeitig aktiv
- Nicht gebrauchte per Projekt deaktivieren:

```json
// In .claude/settings.local.json im Projekt
{
  "disabledMcpServers": ["memory", "filesystem"]
}
```

**Faustregel:** Weniger ist mehr. Lieber 5 gut gewählte Tools als 15 die das Context Window auffressen.

---

## Tipps aus der Praxis

### Prompt-Patterns die funktionieren

**Constraint-First (verhindert falsche Richtung):**
```
Implementiere Feature X.
Constraints:
- Bestehende DB-Struktur nutzen, KEINE neuen Tabellen
- Kein neues npm Package installieren
- Max 400 Zeilen pro Datei
- Python Backend, React Frontend
```

**Scope-Definition (verhindert Scope Creep):**
```
Ändere NUR die Datei src/api/users.ts.
Füge einen neuen Endpoint GET /api/users/:id/stats hinzu.
Ändere NICHTS anderes.
```

**Exclude-Pattern (wenn Claude zu viel macht):**
```
Refactore den Auth-Flow.
ÜBERSPRINGE: Tests, Docs, Frontend.
NUR Backend-Änderungen.
```

### Session-Management

**Lange Tasks über mehrere Sessions:**
1. Am Ende: `/wrapup` (committet, pushed, erstellt HANDOFF.md)
2. Am Anfang der nächsten Session: "Lies HANDOFF.md und mach weiter"

**Kurze Kontextnotiz ohne Commit:**
1. `/handoff` (erstellt nur HANDOFF.md, kein Commit/Push)

### Subagents vs. Agent Teams — Der Unterschied

Zwei grundverschiedene Konzepte, die oft verwechselt werden:

**Subagent (Task Tool) — Fire & Forget:**

Ein Subagent ist ein eigenständiger Prozess, der **nur seinen Prompt bekommt** — keinen Kontext aus eurer Session. Er führt seine Aufgabe aus, liefert das Ergebnis zurück, und ist dann weg. Kein Gedächtnis, keine Kommunikation, kein Shared State.

```
Ihr → "Mach Security Review von backend/routes/"
       ↓
   [Subagent startet]
   - Bekommt NUR diesen Prompt
   - Hat keinen Kontext aus eurer Session
   - Liest die Dateien, analysiert, schreibt Report
   - Liefert Ergebnis zurück
   - Prozess endet ← fertig, weg
       ↓
Ihr ← "3 Findings: SQL Injection in auth.py, ..."
```

Typischer Einsatz: Parallele Recherche, Code-Analyse, Type-Checking — alles wo das Ergebnis einfach zurückfließen soll.

```
Nutze parallele Subagents um:
1. Security Review von backend/app/routes/
2. Test Coverage Check von frontend/src/hooks/
3. Type-Check des gesamten Projekts
Berichte die Ergebnisse, ändere nichts.
```

**Agent Team — Koordinierte Zusammenarbeit:**

Ein Agent Team hat einen **Team Lead**, der Tasks erstellt und an **Teammates** verteilt. Die Teammates arbeiten parallel, kommunizieren aber **dauerhaft untereinander** und mit dem Lead. Jeder Teammate hat seinen eigenen Kontext und kann Nachrichten schicken/empfangen.

```
Team Lead erstellt Task List:
  ├── Task 1: "Backend API für Deals" → Teammate 1
  ├── Task 2: "Frontend Komponenten"  → Teammate 2
  └── Task 3: "Tests schreiben"       → Teammate 3

Teammate 1 → Lead: "API fertig, Endpoint ist POST /api/deals"
Lead → Teammate 2: "API-Signatur steht, hier die Types..."
Teammate 2 → Teammate 3: "Komponente fertig, teste bitte DealCard"
Teammate 3 → Lead: "2 Tests failen, Teammate 1 muss Schema fixen"
Lead → Teammate 1: "Fix das Schema, Details von Teammate 3..."
```

**Der entscheidende Unterschied:** Subagents wissen nichts voneinander. Teammates koordinieren sich aktiv — der Lead teilt die Arbeit auf und stellt sicher, dass niemand die gleichen Dateien bearbeitet.

| | Subagent | Agent Team |
|---|---|---|
| **Kontext** | Nur der Prompt, kein Session-Kontext | Eigener Kontext + Kommunikation |
| **Kommunikation** | Keine — Ergebnis zurück und fertig | Dauerhaft untereinander + Lead |
| **Koordination** | Keine — unabhängig | Lead verteilt Tasks, verhindert Konflikte |
| **Lebensdauer** | Einmalig, endet nach Aufgabe | Bleibt aktiv bis Lead sie beendet |
| **Token-Kosten** | Mittel | Hoch (3-5x einer Single Session) |
| **Typischer Einsatz** | Recherche, Analyse, Reviews | Full-Stack Features, große Refactorings |

---

## Empfohlene Reihenfolge

### Woche 1: Grundlagen
1. `rules/` lesen — starte mit `coding-style.md`, `git-workflow.md`, `testing.md`
2. MUST-Plugins installieren (siehe `plugins.md`)
3. `CLAUDE.md` für euer Hauptprojekt erstellen

### Woche 2: Skills & Plan Mode
4. Plan Mode ausprobieren für ein echtes Feature
5. Skills nutzen: `/tdd`, `/review`, `/wrapup`
6. Context7 MCP installieren (siehe `mcps.md`)

### Woche 3: Fortgeschritten
7. Agents kennenlernen für komplexe Tasks
8. `/orchestrate` und `/bug-pipeline` für paralleles Arbeiten
9. Audit-System ausprobieren (`/audit`)

---

## Highlight Skills

| Skill | Beschreibung |
|-------|-------------|
| `/wrapup` | 6-Phasen Session-Ende: Tests, Commit, Push, Progress, Handoff, Summary |
| `/handoff` | Leichtgewichtige Kontextübergabe (kein Commit/Push) |
| `/bug-pipeline` | Autonome Bug-Fix Pipeline mit parallelen Agents, max 3 Retries, Revert bei Failure |
| `/orchestrate` | Multi-Agent Dispatch mit Scope-Validation und Test-Gates |
| `/doc-sync` | Alle Docs automatisch mit Code-Stand synchronisieren |
| `/tdd` | Test-Driven Development (Red-Green-Refactor) |
| `/review` | Code Review mit Security-Check |
| `/audit` | Vollständiges Code-Audit (Bug + Security + Test + Plan) |

---

## Links

| Ressource | URL |
|-----------|-----|
| Claude Code Docs | https://docs.anthropic.com/en/docs/claude-code/overview |
| Claude Code GitHub | https://github.com/anthropics/claude-code |
| MCP Server Registry | https://github.com/modelcontextprotocol/servers |
| Claude Model Docs | https://docs.anthropic.com/en/docs/about-claude/models |

---

*Zusammengestellt von Olli für das DVC-Entwicklerteam. Bei Fragen: Issue erstellen oder Olli ansprechen.*
