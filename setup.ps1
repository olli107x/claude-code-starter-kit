# Claude Code Starter Kit - Setup Script (Windows PowerShell)
# Installiert Rules, Skills, Agents und Plugins

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "=== Claude Code Starter Kit Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check if Claude Code is installed
$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claudeCmd) {
    Write-Host "FEHLER: Claude Code ist nicht installiert." -ForegroundColor Red
    Write-Host "Installiere es zuerst: npm install -g @anthropic-ai/claude-code"
    exit 1
}

# Step 1: Install MUST plugins
Write-Host "[1/5] Installiere empfohlene Plugins..." -ForegroundColor Yellow
try { claude plugins install superpowers@claude-plugins-official 2>$null } catch { Write-Host "  superpowers bereits installiert" }
try { claude plugins install commit-commands@claude-plugins-official 2>$null } catch { Write-Host "  commit-commands bereits installiert" }
try { claude plugins install code-review@claude-plugins-official 2>$null } catch { Write-Host "  code-review bereits installiert" }
Write-Host "  Plugins installiert."

# Step 2: Copy rules
Write-Host "[2/5] Kopiere Rules nach $ClaudeDir\rules\..." -ForegroundColor Yellow
$rulesDir = Join-Path $ClaudeDir "rules"
if (-not (Test-Path $rulesDir)) { New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null }

$sourceRules = Join-Path $ScriptDir "rules"
if (Test-Path $sourceRules) {
    Get-ChildItem -Path $sourceRules -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $rulesDir $_.Name
        if (-not (Test-Path $dest)) {
            Copy-Item $_.FullName $dest
            Write-Host "  + $($_.Name)"
        } else {
            Write-Host "  ~ $($_.Name) (existiert bereits, uebersprungen)"
        }
    }
} else {
    Write-Host "  WARNUNG: rules\ Verzeichnis nicht gefunden." -ForegroundColor Yellow
}
Write-Host "  Rules kopiert."

# Step 3: Copy skills
Write-Host "[3/5] Kopiere Skills nach $ClaudeDir\skills\..." -ForegroundColor Yellow
$categories = @("development", "testing", "productivity", "documents", "utilities")
foreach ($category in $categories) {
    $sourceCategory = Join-Path $ScriptDir "skills\$category"
    if (Test-Path $sourceCategory) {
        $destCategory = Join-Path $ClaudeDir "skills\$category"
        if (-not (Test-Path $destCategory)) { New-Item -ItemType Directory -Path $destCategory -Force | Out-Null }

        Get-ChildItem -Path $sourceCategory -Directory | ForEach-Object {
            $dest = Join-Path $destCategory $_.Name
            if (-not (Test-Path $dest)) {
                Copy-Item $_.FullName $dest -Recurse
                Write-Host "  + $category\$($_.Name)\"
            } else {
                Write-Host "  ~ $category\$($_.Name)\ (existiert bereits)"
            }
        }
    }
}
Write-Host "  Skills kopiert."

# Step 4: Copy agents
Write-Host "[4/5] Kopiere Agents nach $ClaudeDir\agents\..." -ForegroundColor Yellow
$departments = @("engineering", "design", "testing", "utility")
foreach ($dept in $departments) {
    $sourceDept = Join-Path $ScriptDir "agents\$dept"
    if (Test-Path $sourceDept) {
        $destDept = Join-Path $ClaudeDir "agents\$dept"
        if (-not (Test-Path $destDept)) { New-Item -ItemType Directory -Path $destDept -Force | Out-Null }

        Get-ChildItem -Path $sourceDept -Filter "*.md" | ForEach-Object {
            $dest = Join-Path $destDept $_.Name
            if (-not (Test-Path $dest)) {
                Copy-Item $_.FullName $dest
                Write-Host "  + $dept\$($_.Name)"
            } else {
                Write-Host "  ~ $dept\$($_.Name) (existiert bereits)"
            }
        }
    }
}
$agentsReadme = Join-Path $ScriptDir "agents\README.md"
$agentsReadmeDest = Join-Path $ClaudeDir "agents\README.md"
if ((Test-Path $agentsReadme) -and (-not (Test-Path $agentsReadmeDest))) {
    Copy-Item $agentsReadme $agentsReadmeDest
    Write-Host "  + agents\README.md"
}
Write-Host "  Agents kopiert."

# Step 5: Merge settings
Write-Host "[5/5] Pruefe Settings..." -ForegroundColor Yellow
$settingsFile = Join-Path $ClaudeDir "settings.json"
if (-not (Test-Path $settingsFile)) {
    $templateFile = Join-Path $ScriptDir "settings-template.json"
    Copy-Item $templateFile $settingsFile
    Write-Host "  settings.json erstellt."
} else {
    Write-Host "  settings.json existiert bereits (nicht ueberschrieben)."
    Write-Host "  Vergleiche manuell mit settings-template.json."
}

Write-Host ""
Write-Host "=== Setup abgeschlossen ===" -ForegroundColor Green
Write-Host ""
Write-Host "Naechste Schritte:"
Write-Host "  1. Kopiere CLAUDE.md.template in dein Projekt-Root und passe es an"
Write-Host "  2. Lies plugins.md fuer weitere Plugin-Empfehlungen"
Write-Host "  3. Lies mcps.md fuer MCP-Server Empfehlungen"
Write-Host "  4. Starte Claude Code in deinem Projekt: claude"
Write-Host ""
Write-Host "Tipp: Nicht zu viele Plugins/MCPs gleichzeitig aktivieren!" -ForegroundColor Yellow
Write-Host "      Max 5-6 Plugins + 5 MCPs (Context Window!)"
