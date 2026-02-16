# Claude Code Starter Kit

> Battle-tested Workflow-Konfiguration fuer Claude Code, destilliert aus Monaten produktiver Nutzung. Zusammengestellt fuer DVC-Entwickler, die Claude Code zum ersten Mal einsetzen.

---

## Was ist Claude Code?

Claude Code ist **nicht** wie ChatGPT oder die Claude-Web-UI. Es ist ein **CLI-Tool**, das direkt in deinem Terminal laeuft. Stell es dir so vor:

- Du oeffnest dein Terminal (PowerShell, Bash, etc.)
- Du tippst `claude` und drueckst Enter
- Du unterhaltst dich mit Claude -- aber Claude kann dabei **Dateien lesen und schreiben**, **Terminal-Befehle ausfuehren**, **Git-Operationen durchfuehren** und **mit APIs interagieren**

Claude Code ist ein **autonomer Coding-Agent**. Du beschreibst, was du willst, und Claude setzt es um -- liest deinen Code, schreibt neue Dateien, fuehrt Tests aus, erstellt Commits. Das ist ein fundamental anderes Arbeiten als Copy-Paste zwischen Browser und Editor.

**Dieses Starter Kit** gibt dir eine erprobte Grundkonfiguration mit:
- Regeln, die Claude automatisch befolgt (Coding Style, Security, Git Workflow)
- Skills, die du bei Bedarf abrufst (TDD, Code Review, Debugging)
- Agent-Definitionen fuer komplexe Aufgaben (Security Audits, Architektur-Entscheidungen)

---

## Was ist in diesem Kit?

```
claude-code-starter-kit/
|
|-- rules/              Globale Regeln (12 Dateien)
|   |-- coding-style.md      Immutability, File-Organisation, Naming
|   |-- git-workflow.md       Conventional Commits, PR-Prozess
|   |-- testing.md            TDD-Workflow, 80% Coverage
|   |-- security.md           Pre-Commit Security Checklist
|   |-- performance.md        Context Window Management, Model-Auswahl
|   |-- agents.md             Agent-Delegation, Parallel Execution
|   |-- audit-workflow.md     Audit-Orchestrierung
|   |-- audit-bug.md          Bug-Audit Checkliste
|   |-- audit-security.md     OWASP Top 10 Checks
|   |-- audit-test.md         Test Coverage Audit
|   |-- audit-plan-verification.md  Plan-Verifizierung
|   +-- README.md             Uebersicht aller Rules
|
|-- skills/             Wiederverwendbare Skills (35+ in 5 Kategorien)
|   |-- development/          Feature-Entwicklung, Refactoring, Debugging
|   |-- testing/              TDD, Test-Fixing, Verification
|   |-- documents/            Dokumentation, Changelogs
|   |-- productivity/         Session Management, Planning
|   +-- utilities/            Diverse Hilfsfunktionen
|
|-- agents/             Spezialisierte Agent-Definitionen (18 Agents)
|   |-- engineering/          Backend, Frontend, DB-Architektur
|   |-- design/               UI, Dashboard, Brand, UX
|   |-- testing/              QA, Security, API-Testing
|   +-- utility/              Explorer, Historian, Research
|
|-- docs/               Generische Dokumentations-Templates
|   |-- debugging.md          Debugging-Leitfaden
|   |-- definition-of-done.md Code-Standards
|   +-- ...
|
|-- plugins.md          Plugin-Empfehlungen mit Install-Befehlen
|-- mcps.md             MCP-Server Guide fuer Einsteiger
|-- CLAUDE.md.template  Vorlage fuer projekt-spezifische CLAUDE.md
|-- settings-template.json  Empfohlene Claude Code Einstellungen
|-- setup.sh            Installations-Script (Linux/Mac)
+-- setup.ps1           Installations-Script (Windows)
```

---

## Quick Start (5 Minuten)

### 1. Claude Code installieren

Falls noch nicht geschehen:

```bash
npm install -g @anthropic-ai/claude-code
```

Offizielle Anleitung: [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code/overview)

### 2. Setup-Script ausfuehren

**Linux / Mac:**
```bash
cd claude-code-starter-kit
chmod +x setup.sh
./setup.sh
```

**Windows (PowerShell):**
```powershell
cd claude-code-starter-kit
.\setup.ps1
```

Das Script:
- Installiert die wichtigsten Plugins (superpowers, commit-commands, code-review)
- Kopiert Rules, Skills und Agents nach `~/.claude/`
- Erstellt eine Settings-Datei (falls noch keine existiert)

### 3. In ein Projekt navigieren und Claude starten

```bash
cd mein-projekt
claude
```

### 4. CLAUDE.md fuer dein Projekt erstellen

```bash
cp claude-code-starter-kit/CLAUDE.md.template mein-projekt/CLAUDE.md
```

Dann die Platzhalter in der CLAUDE.md mit deinen Projekt-Infos fuellen. Diese Datei ist wie eine `.env` -- aber fuer Claude. Sie gibt Claude Kontext ueber dein Projekt.

### 5. Loslegen!

Starte Claude Code in deinem Projekt und probiere z.B.:
- "Erklaere mir die Projektstruktur"
- "Schreibe einen Test fuer die UserService-Klasse"
- `/review` -- Code Review des letzten Commits

---

## Konzepte erklaert

### Rules (Regeln)

**Immer aktiv. Werden automatisch geladen.**

Rules liegen in `~/.claude/rules/` und gelten fuer JEDE Claude Code Session. Du musst sie nicht manuell aufrufen -- Claude liest sie automatisch und befolgt sie.

Beispiele:
- `coding-style.md` -- Claude schreibt immutable Code, haelt Dateien klein
- `git-workflow.md` -- Claude nutzt Conventional Commits, macht keine Force-Pushes
- `security.md` -- Claude prueft vor jedem Commit auf hardcoded Secrets

### Skills (Faehigkeiten)

**On-demand. Werden via `/skill-name` aufgerufen.**

Skills sind wie Rezepte fuer bestimmte Aufgaben. Du rufst sie auf, wenn du sie brauchst:

```
/tdd          → Test-Driven Development starten
/review       → Code Review durchfuehren
/debug        → Systematisches Debugging
/plan         → Feature-Planung
```

### Agents (Sub-Agenten)

**Fuer komplexe Tasks. Werden automatisch oder manuell delegiert.**

Agents sind spezialisierte Rollen, die Claude einnimmt. Bei einem Security-Problem wird z.B. der `security-reviewer` Agent aktiviert, der gezielt nach OWASP Top 10 Schwachstellen sucht.

| Department | Agents |
|------------|--------|
| Engineering | db-architect, backend-architect, frontend-developer |
| Design | ui-designer, dashboard-crafter, brand-guardian, ux-polisher |
| Testing | api-tester, qa-engineer, security-reviewer, brutal-critic, debugger |
| Utility | explorer, historian, research-documenter |

### Plugins

**Erweiterungen, die Claude zusaetzliche Tools und Skills geben.**

Plugins werden einmal installiert und sind dann verfuegbar. Sie erweitern Claude um fertige Workflows (z.B. TDD, Code Review, Git-Operationen).

```bash
claude plugins install superpowers@claude-plugins-official
```

Siehe `plugins.md` fuer alle Empfehlungen.

### MCPs (Model Context Protocol Server)

**Externe Tool-Integrationen, die als lokale Server laufen.**

MCPs geben Claude Zugriff auf externe Systeme: Datenbanken, Browser, GitHub API, etc. Sie laufen im Hintergrund als Server.

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

Siehe `mcps.md` fuer alle Empfehlungen.

### CLAUDE.md

**Projekt-spezifischer Kontext. Liegt im Projekt-Root.**

Die `CLAUDE.md` ist wie eine Briefing-Datei fuer Claude. Sie beschreibt dein Projekt, den Tech Stack, die Struktur, und wichtige Konventionen. Claude liest sie automatisch, wenn sie im Projekt-Root liegt.

---

## WARNUNG: Context Window Management

Dies ist das **wichtigste Konzept**, das Einsteiger oft uebersehen:

Claude Code hat ein Context Window von **200.000 Tokens**. Das klingt viel -- aber:

- **Jedes aktive Plugin** belegt einen Teil des Windows (Tool-Definitionen)
- **Jeder aktive MCP** belegt einen Teil des Windows (Tool-Definitionen)
- Bei **20+ MCPs** kann das Window auf **~70.000 Tokens schrumpfen**
- Das bedeutet: Claude vergisst fruehere Teile der Konversation schneller

**Empfehlung:**
- Max **5-6 Plugins** gleichzeitig aktiv
- Max **5 MCPs** gleichzeitig aktiv
- Nicht gebrauchte MCPs pro Projekt deaktivieren:

```json
// In .claude/settings.local.json im Projekt
{
  "disabledMcpServers": ["memory", "filesystem"]
}
```

**Faustregel:** Weniger ist mehr. Installiere nur, was du wirklich brauchst.

---

## Empfohlene Lernreihenfolge

Nimm dir Zeit und geh Schritt fuer Schritt vor:

### Woche 1: Grundlagen
1. **Rules lesen** -- Starte mit `coding-style.md`, `git-workflow.md`, `testing.md`
2. **MUST-Plugins installieren** -- superpowers, commit-commands, code-review
3. **CLAUDE.md erstellen** -- Fuer dein Hauptprojekt

### Woche 2: Skills ausprobieren
4. **Skills nutzen** -- `/tdd` fuer Test-Driven Development, `/review` fuer Code Reviews
5. **Context7 MCP installieren** -- Verhindert Halluzinationen bei Library-Docs

### Woche 3: Fortgeschritten
6. **Agents kennenlernen** -- Fuer komplexe Tasks wie Security Audits
7. **Weitere MCPs** nach Bedarf hinzufuegen
8. **Audit-System** ausprobieren (`/audit`)

---

## Links

| Ressource | URL |
|-----------|-----|
| Claude Code Docs | https://docs.anthropic.com/en/docs/claude-code/overview |
| Claude Code GitHub | https://github.com/anthropics/claude-code |
| MCP Server Registry | https://github.com/modelcontextprotocol/servers |
| Claude Model Docs | https://docs.anthropic.com/en/docs/about-claude/models |

---

## Credits

Zusammengestellt von **Olli** fuer das DVC-Entwicklerteam.

Basierend auf Monaten produktiver Claude Code Nutzung -- die Rules, Skills und Agents in diesem Kit sind keine Theorie, sondern in echten Projekten erprobt und iterativ verbessert worden.

---

*Bei Fragen: Einfach Olli ansprechen oder ein Issue in diesem Repo erstellen.*
