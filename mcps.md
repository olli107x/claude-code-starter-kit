# MCP Server Guide

> MCPs (Model Context Protocol Server) geben Claude Zugriff auf externe Tools und Systeme.

---

## Was sind MCPs?

MCP steht fuer **Model Context Protocol** -- ein offener Standard fuer Tool-Integrationen. MCPs laufen als **lokale Server im Hintergrund** und geben Claude zusaetzliche Faehigkeiten:

- Datenbank-Zugriff (PostgreSQL, SQLite)
- Browser-Steuerung (Playwright)
- GitHub-Integration (Issues, PRs, Repos)
- Dateisystem-Operationen
- Und vieles mehr

Der Unterschied zu Plugins: Plugins fuegen Skills und Workflows hinzu. MCPs fuegen **externe Tool-Verbindungen** hinzu.

---

## Installation

```bash
claude mcp add {name} -- {command}
```

**Installierte MCPs anzeigen:**
```bash
claude mcp list
```

**MCP entfernen:**
```bash
claude mcp remove {name}
```

---

## Empfohlene MCP-Server

| MCP | Zweck | Install-Befehl | Prioritaet |
|-----|-------|----------------|------------|
| **context7** | Aktuelle Library-Docs abrufen -- verhindert Halluzinationen | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest` | MUST |
| **playwright** | Browser-Testing und Web-Scraping | `claude mcp add playwright -- npx @anthropic/mcp-playwright` | SHOULD |
| **github** | GitHub Issues, PRs, Repos direkt bearbeiten | `claude mcp add github -- npx @modelcontextprotocol/server-github` | SHOULD |
| **filesystem** | Erweiterter Dateizugriff (ausserhalb Projekt) | `claude mcp add filesystem -- npx @anthropic/mcp-filesystem` | NICE |
| **memory** | Persistenter Speicher zwischen Sessions | `claude mcp add memory -- npx @modelcontextprotocol/server-memory` | NICE |

### Prioritaets-Stufen

- **MUST** -- Sofort installieren. Context7 allein ist den Aufwand wert.
- **SHOULD** -- Installieren, wenn du in dem Bereich arbeitest.
- **NICE** -- Optional. Bei Bedarf hinzufuegen.

---

## Details zu den MCPs

### context7 (MUST)

**Was:** Laedt aktuelle Dokumentation fuer Libraries und Frameworks direkt in den Kontext.

**Warum:** Claude hat einen Wissens-Cutoff. Bei neuen Library-Versionen kann Claude veraltete APIs vorschlagen oder halluzinieren. Context7 loest das, indem es die aktuelle Doku live abruft.

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

**Beispiel-Nutzung:** Wenn du Claude fragst "Nutze die neue React Server Components API", holt Context7 automatisch die aktuelle React-Doku.

### playwright (SHOULD)

**Was:** Gibt Claude die Faehigkeit, einen Browser zu steuern -- Seiten oeffnen, klicken, Formulare ausfuellen, Screenshots machen.

**Warum:** Nützlich fuer E2E-Tests, Web-Scraping und visuelles Debugging.

```bash
claude mcp add playwright -- npx @anthropic/mcp-playwright
```

### github (SHOULD)

**Was:** Direkter Zugriff auf GitHub -- Issues erstellen, PRs reviewen, Repos durchsuchen.

**Warum:** Claude kann direkt mit deinem GitHub-Repo interagieren, ohne dass du zwischen Terminal und Browser wechseln musst.

```bash
claude mcp add github -- npx @modelcontextprotocol/server-github
```

**Voraussetzung:** Du brauchst ein GitHub Personal Access Token:
```bash
# Token als Umgebungsvariable setzen
export GITHUB_TOKEN=ghp_dein_token_hier
```

Unter Windows (PowerShell):
```powershell
$env:GITHUB_TOKEN = "ghp_dein_token_hier"
```

Am besten in deinem Shell-Profil (`.bashrc`, `.zshrc`, PowerShell `$PROFILE`) dauerhaft setzen.

### filesystem (NICE)

**Was:** Erweiterter Dateizugriff, auch ausserhalb des aktuellen Projektverzeichnisses.

```bash
claude mcp add filesystem -- npx @anthropic/mcp-filesystem
```

### memory (NICE)

**Was:** Persistenter Key-Value Speicher, der zwischen Sessions erhalten bleibt.

**Warum:** Claude vergisst alles nach einer Session. Mit Memory kann Claude sich Dinge merken -- z.B. Projekt-Konventionen, haeufige Fehler, persoenliche Praeferenzen.

```bash
claude mcp add memory -- npx @modelcontextprotocol/server-memory
```

---

## MCPs pro Projekt deaktivieren

Nicht jedes Projekt braucht alle MCPs. Deaktiviere unbenoetigte MCPs, um Context Window zu sparen:

Erstelle oder bearbeite `.claude/settings.local.json` im Projekt-Root:

```json
{
  "disabledMcpServers": ["memory", "filesystem"]
}
```

Diese Datei gilt nur fuer dieses Projekt. Global bleiben die MCPs verfuegbar.

---

## WARNUNG: Context Window

Genau wie Plugins belegen MCPs Platz im Context Window -- und oft **mehr** als Plugins, weil MCPs viele Tool-Definitionen mitbringen.

**Empfehlung: Max 5 MCPs gleichzeitig aktiv.**

Wenn du merkst, dass Claude fruehere Teile der Konversation vergisst oder die Qualitaet nachlasst, hast du wahrscheinlich zu viele MCPs aktiv.

---

## Empfohlene Kombinationen

### Web Development
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
claude mcp add playwright -- npx @anthropic/mcp-playwright
claude mcp add github -- npx @modelcontextprotocol/server-github
```
3 MCPs -- Library-Docs, Browser-Testing, GitHub-Integration.

### Backend / API Development
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
claude mcp add github -- npx @modelcontextprotocol/server-github
```
2 MCPs -- Minimal und fokussiert. Bei PostgreSQL-Projekten ggf. einen DB-MCP dazu.

### Data Analysis / Scripting
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
claude mcp add filesystem -- npx @anthropic/mcp-filesystem
claude mcp add memory -- npx @modelcontextprotocol/server-memory
```
3 MCPs -- Dateizugriff und persistenter Speicher fuer laengere Analysen.

---

## Schnellinstallation (MUST)

Nur das Wichtigste:

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

Context7 allein macht schon einen spuerbaren Unterschied bei der Qualitaet von Claudes Code-Vorschlaegen.

---

## Weitere MCP-Server finden

Das MCP-Oekosystem waechst staendig. Hier findest du weitere Server:

- **Offizielles MCP Registry:** https://github.com/modelcontextprotocol/servers
- **Community MCPs:** Suche nach "mcp-server" auf GitHub oder npm

---

## Tipps

- **Starte mit context7.** Es ist das nuetzlichste MCP fuer die meisten Entwickler.
- **Fuege MCPs einzeln hinzu** und teste, ob sie funktionieren.
- **Deaktiviere MCPs pro Projekt**, die du dort nicht brauchst.
- **Pruefe regelmaessig** mit `claude mcp list`, welche MCPs aktiv sind.
- Bei Problemen: `claude mcp remove {name}` und neu installieren.

---

*Siehe auch: `plugins.md` fuer Plugin-Empfehlungen.*
