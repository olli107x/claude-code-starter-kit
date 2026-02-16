# Claude Code Starter Kit

> Battle-tested Claude Code Konfiguration, destilliert aus Monaten produktiver Nutzung. Rules, Skills, Agents, Plugins & MCP-Empfehlungen fuer euer Team.

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
|   +-- README.md               Uebersicht aller Rules
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
|   |   |-- subagent-driven-development/   Parallele Task-Ausfuehrung
|   |   |-- prompt-engineering/       LLM Prompting Best Practices
|   |   |-- changelog-generator/      Git Commits -> Release Notes
|   |   |-- test-fixing/              Systematisch Tests fixen
|   |   +-- using-git-worktrees/      Isolierte Workspaces
|   |-- testing/              2 Skills (PICT, Playwright)
|   |-- productivity/         5 Skills
|   |   |-- wrapup/                   Session-Ende Ritual (6 Phasen)
|   |   |-- handoff/                  Leichtgewichtige Kontext-Uebergabe
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
|-- CLAUDE.md.template   Vorlage fuer projekt-spezifische CLAUDE.md
|-- settings-template.json  Empfohlene Einstellungen
|-- setup.sh             Installations-Script (Linux/Mac)
+-- setup.ps1            Installations-Script (Windows)
```

---

## Quick Start

### 1. Setup-Script ausfuehren

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

### 2. CLAUDE.md fuer euer Projekt erstellen

```bash
cp claude-code-starter-kit/CLAUDE.md.template mein-projekt/CLAUDE.md
```

Die Platzhalter mit euren Projekt-Infos fuellen. Diese Datei gibt Claude Kontext ueber euer Projekt - Tech Stack, Struktur, Konventionen.

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
| **Agents** | Spezialisierte Sub-Agenten fuer komplexe Tasks | `~/.claude/agents/` |
| **Plugins** | Erweiterungen (Tools + Skills) | `claude plugins install ...` |
| **MCPs** | Externe Tool-Integrationen (DB, Browser, APIs) | `claude mcp add ...` |
| **CLAUDE.md** | Projekt-spezifischer Kontext im Repo-Root | `./CLAUDE.md` |

---

## WARNUNG: Context Window

Claude Code hat 200k Tokens Context Window - aber **jedes Plugin/MCP schrumpft es**.
Bei 20+ MCPs kann das Window auf ~70k schrumpfen.

**Empfehlung:**
- Max **5-6 Plugins** gleichzeitig aktiv
- Max **5 MCPs** gleichzeitig aktiv
- Nicht gebrauchte per Projekt deaktivieren:

```json
{
  "disabledMcpServers": ["memory", "filesystem"]
}
```

---

## Empfohlene Reihenfolge

### Woche 1: Grundlagen
1. `rules/` lesen - starte mit `coding-style.md`, `git-workflow.md`, `testing.md`
2. MUST-Plugins installieren (siehe `plugins.md`)
3. `CLAUDE.md` fuer euer Hauptprojekt erstellen

### Woche 2: Skills
4. Skills ausprobieren: `/tdd`, `/review`, `/debug`, `/wrapup`
5. Context7 MCP installieren (siehe `mcps.md`)

### Woche 3: Fortgeschritten
6. Agents kennenlernen fuer komplexe Tasks
7. `/orchestrate` und `/bug-pipeline` fuer paralleles Arbeiten
8. Audit-System ausprobieren (`/audit`)

---

## Highlights

### Neue Skills (besonders wertvoll)

| Skill | Beschreibung |
|-------|-------------|
| `/wrapup` | 6-Phasen Session-Ende: Tests, Commit, Push, Progress, Handoff, Summary |
| `/handoff` | Leichtgewichtige Kontext-Uebergabe (kein Commit/Push) |
| `/bug-pipeline` | Autonome Bug-Fix Pipeline mit parallelen Agents, max 3 Retries, Revert bei Failure |
| `/orchestrate` | Multi-Agent Dispatch mit Scope-Validation und Test-Gates |
| `/doc-sync` | Alle Docs automatisch mit Code-Stand synchronisieren |

### Audit System

Strukturiertes Code-Audit mit parallelen Checks:

```
Bug Audit + Security Audit + Test Audit  (parallel)
                    |
            Plan Verification             (sequentiell)
                    |
               FINAL REPORT
```

Ausfuehren mit `/audit` (alle 4) oder einzeln: `/audit-bug`, `/audit-security`, `/audit-test`

---

## Links

| Ressource | URL |
|-----------|-----|
| Claude Code Docs | https://docs.anthropic.com/en/docs/claude-code/overview |
| Claude Code GitHub | https://github.com/anthropics/claude-code |
| MCP Server Registry | https://github.com/modelcontextprotocol/servers |
| Claude Model Docs | https://docs.anthropic.com/en/docs/about-claude/models |

---

*Zusammengestellt von Olli fuer das DVC-Entwicklerteam. Bei Fragen: Issue erstellen oder Olli ansprechen.*
