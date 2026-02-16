#!/bin/bash
# Claude Code Starter Kit - Setup Script
# Installiert Rules, Skills, Agents und Plugins

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== Claude Code Starter Kit Setup ==="
echo ""

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "FEHLER: Claude Code ist nicht installiert."
    echo "Installiere es zuerst: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

# Step 1: Install MUST plugins
echo "[1/5] Installiere empfohlene Plugins..."
claude plugins install superpowers@claude-plugins-official 2>/dev/null || echo "  superpowers bereits installiert"
claude plugins install commit-commands@claude-plugins-official 2>/dev/null || echo "  commit-commands bereits installiert"
claude plugins install code-review@claude-plugins-official 2>/dev/null || echo "  code-review bereits installiert"
echo "  Plugins installiert."

# Step 2: Copy rules
echo "[2/5] Kopiere Rules nach $CLAUDE_DIR/rules/..."
mkdir -p "$CLAUDE_DIR/rules"
if [ -d "$SCRIPT_DIR/rules" ]; then
    for file in "$SCRIPT_DIR/rules/"*.md; do
        [ -f "$file" ] || continue
        dest="$CLAUDE_DIR/rules/$(basename "$file")"
        if [ ! -f "$dest" ]; then
            cp "$file" "$dest"
            echo "  + $(basename "$file")"
        else
            echo "  ~ $(basename "$file") (existiert bereits, uebersprungen)"
        fi
    done
else
    echo "  WARNUNG: rules/ Verzeichnis nicht gefunden."
fi
echo "  Rules kopiert."

# Step 3: Copy skills (recursive - skills are in subdirectories)
echo "[3/5] Kopiere Skills nach $CLAUDE_DIR/skills/..."
for category in development testing productivity documents utilities; do
    if [ -d "$SCRIPT_DIR/skills/$category" ]; then
        mkdir -p "$CLAUDE_DIR/skills/$category"
        for skill_dir in "$SCRIPT_DIR/skills/$category/"*/; do
            [ -d "$skill_dir" ] || continue
            skill_name="$(basename "$skill_dir")"
            dest="$CLAUDE_DIR/skills/$category/$skill_name"
            if [ ! -d "$dest" ]; then
                cp -r "$skill_dir" "$dest"
                echo "  + $category/$skill_name/"
            else
                echo "  ~ $category/$skill_name/ (existiert bereits)"
            fi
        done
    fi
done
echo "  Skills kopiert."

# Step 4: Copy agents
echo "[4/5] Kopiere Agents nach $CLAUDE_DIR/agents/..."
for dept in engineering design testing utility; do
    if [ -d "$SCRIPT_DIR/agents/$dept" ]; then
        mkdir -p "$CLAUDE_DIR/agents/$dept"
        for file in "$SCRIPT_DIR/agents/$dept/"*.md; do
            [ -f "$file" ] || continue
            dest="$CLAUDE_DIR/agents/$dept/$(basename "$file")"
            if [ ! -f "$dest" ]; then
                cp "$file" "$dest"
                echo "  + $dept/$(basename "$file")"
            else
                echo "  ~ $dept/$(basename "$file") (existiert bereits)"
            fi
        done
    fi
done
if [ -f "$SCRIPT_DIR/agents/README.md" ]; then
    if [ ! -f "$CLAUDE_DIR/agents/README.md" ]; then
        cp "$SCRIPT_DIR/agents/README.md" "$CLAUDE_DIR/agents/"
        echo "  + agents/README.md"
    fi
fi
echo "  Agents kopiert."

# Step 5: Merge settings
echo "[5/5] Pruefe Settings..."
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
    cp "$SCRIPT_DIR/settings-template.json" "$CLAUDE_DIR/settings.json"
    echo "  settings.json erstellt."
else
    echo "  settings.json existiert bereits (nicht ueberschrieben)."
    echo "  Vergleiche manuell mit settings-template.json."
fi

echo ""
echo "=== Setup abgeschlossen ==="
echo ""
echo "Naechste Schritte:"
echo "  1. Kopiere CLAUDE.md.template in dein Projekt-Root und passe es an"
echo "  2. Lies plugins.md fuer weitere Plugin-Empfehlungen"
echo "  3. Lies mcps.md fuer MCP-Server Empfehlungen"
echo "  4. Starte Claude Code in deinem Projekt: claude"
echo ""
echo "Tipp: Nicht zu viele Plugins/MCPs gleichzeitig aktivieren!"
echo "      Max 5-6 Plugins + 5 MCPs (Context Window!)"
