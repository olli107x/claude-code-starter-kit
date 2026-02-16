# Plugin Guide

> Plugins erweitern Claude Code um zusaetzliche Tools, Skills und Workflows.

---

## Was sind Plugins?

Plugins sind Erweiterungspakete fuer Claude Code. Sie fuegen fertige Workflows hinzu -- z.B. einen kompletten TDD-Workflow, einen Code-Review-Prozess oder Git-Operationen. Einmal installiert, stehen sie in jeder Session zur Verfuegung.

**Installation:**
```bash
claude plugins install {name}@{publisher}
```

**Installierte Plugins anzeigen:**
```bash
claude plugins list
```

---

## Empfohlene Plugins

| Plugin | Beschreibung | Install-Befehl | Prioritaet |
|--------|-------------|----------------|------------|
| **superpowers** | Brainstorming, TDD, Debugging, Verification -- das Schweizer Taschenmesser | `claude plugins install superpowers@claude-plugins-official` | MUST |
| **commit-commands** | Git Commit, Push, PR Workflow -- saubere Git-Operationen | `claude plugins install commit-commands@claude-plugins-official` | MUST |
| **code-review** | PR Code Review -- strukturierte Reviews mit Findings | `claude plugins install code-review@claude-plugins-official` | MUST |
| **feature-dev** | Guided Feature Development -- Schritt-fuer-Schritt Features bauen | `claude plugins install feature-dev@claude-plugins-official` | SHOULD |
| **security-guidance** | Security Best Practices -- OWASP-basierte Checks | `claude plugins install security-guidance@claude-plugins-official` | SHOULD |
| **frontend-design** | High-quality Frontend Code -- UI/UX-fokussiert | `claude plugins install frontend-design@claude-plugins-official` | NICE |
| **typescript-lsp** | TypeScript Language Server -- Typchecking, Autocomplete | `claude plugins install typescript-lsp@claude-plugins-official` | NICE |
| **pyright-lsp** | Python Type Checking -- statische Analyse | `claude plugins install pyright-lsp@claude-plugins-official` | NICE |
| **explanatory-output-style** | Erklaert Schritte ausfuehrlich -- gut zum Lernen | `claude plugins install explanatory-output-style@claude-code-plugins` | NICE |
| **supabase** | Supabase Integration -- DB, Auth, Storage | `claude plugins install supabase@claude-plugins-official` | NICE |
| **vercel** | Vercel Deployment -- Deploy-Workflow | `claude plugins install vercel@claude-plugins-official` | NICE |

### Prioritaets-Stufen

- **MUST** -- Sofort installieren. Diese Plugins machen Claude Code deutlich produktiver.
- **SHOULD** -- Installieren, wenn du in dem Bereich arbeitest. Klarer Mehrwert.
- **NICE** -- Optional. Installieren bei Bedarf, nicht auf Vorrat.

---

## WARNUNG: Nicht alle gleichzeitig!

Jedes aktive Plugin belegt Platz im Context Window. Bei zu vielen Plugins gleichzeitig:
- Schrumpft das verfuegbare Context Window
- Claude vergisst fruehere Konversationsteile schneller
- Die Qualitaet der Antworten kann sinken

**Empfehlung: Max 5-6 Plugins gleichzeitig aktiv.**

Deaktiviere Plugins, die du gerade nicht brauchst:
```bash
claude plugins disable {name}@{publisher}
```

---

## Empfohlene Kombinationen

Je nach Projekt-Typ empfehlen wir diese Plugin-Sets:

### Python Backend

```bash
claude plugins install superpowers@claude-plugins-official
claude plugins install commit-commands@claude-plugins-official
claude plugins install code-review@claude-plugins-official
claude plugins install security-guidance@claude-plugins-official
claude plugins install pyright-lsp@claude-plugins-official
```

5 Plugins -- fokussiert auf Code-Qualitaet, Security und Python-Typchecking.

### React / TypeScript Frontend

```bash
claude plugins install superpowers@claude-plugins-official
claude plugins install commit-commands@claude-plugins-official
claude plugins install code-review@claude-plugins-official
claude plugins install frontend-design@claude-plugins-official
claude plugins install typescript-lsp@claude-plugins-official
```

5 Plugins -- fokussiert auf UI-Qualitaet und TypeScript-Unterstuetzung.

### Full-Stack (Python + React/TS)

```bash
claude plugins install superpowers@claude-plugins-official
claude plugins install commit-commands@claude-plugins-official
claude plugins install code-review@claude-plugins-official
claude plugins install feature-dev@claude-plugins-official
claude plugins install security-guidance@claude-plugins-official
```

5 Plugins -- breites Set fuer Full-Stack Entwicklung. Bei Bedarf `typescript-lsp` oder `pyright-lsp` einzeln dazu (dann aber ein anderes deaktivieren).

---

## Schnellinstallation (MUST-Plugins)

Alle drei MUST-Plugins auf einmal:

```bash
claude plugins install superpowers@claude-plugins-official
claude plugins install commit-commands@claude-plugins-official
claude plugins install code-review@claude-plugins-official
```

Das `setup.sh` / `setup.ps1` Script macht genau das automatisch.

---

## Tipps

- **Starte minimal.** Die drei MUST-Plugins reichen fuer den Anfang voellig aus.
- **Fuege Plugins einzeln hinzu**, wenn du merkst, dass du sie brauchst.
- **`explanatory-output-style`** ist gut zum Lernen -- Claude erklaert dann jeden Schritt. Spaeter deaktivieren, wenn du schneller arbeiten willst.
- **LSP-Plugins** (`typescript-lsp`, `pyright-lsp`) lohnen sich nur, wenn du in der jeweiligen Sprache arbeitest. Nicht beide gleichzeitig noetig.

---

*Siehe auch: `mcps.md` fuer MCP-Server Empfehlungen.*
