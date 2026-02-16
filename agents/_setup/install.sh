#!/bin/bash
# Claude Code Agent System Installer
# Usage: bash install.sh

echo "Installing Claude Code Agent System..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ================================================
# 1. INSTALL BASH ALIASES
# ================================================
echo "Installing bash aliases..."

if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    echo "  No .zshrc or .bashrc found. Please add aliases manually."
    SHELL_RC=""
fi

if [ -n "$SHELL_RC" ]; then
    if grep -q "CLAUDE CODE AGENT ALIASES" "$SHELL_RC"; then
        echo "  Aliases already installed in $SHELL_RC"
    else
        echo "" >> "$SHELL_RC"
        cat "$SCRIPT_DIR/aliases.sh" >> "$SHELL_RC"
        echo "  Aliases added to $SHELL_RC"
        echo "  Run: source $SHELL_RC"
    fi
fi

# ================================================
# 2. INSTALL GIT HOOKS
# ================================================
echo ""
echo "Installing git hooks..."

# Find git root
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$GIT_ROOT" ]; then
    echo "  Not in a git repository. Skipping hooks installation."
else
    HOOKS_DIR="$GIT_ROOT/.git/hooks"

    # Pre-commit
    if [ -f "$SCRIPT_DIR/hooks/pre-commit" ]; then
        cp "$SCRIPT_DIR/hooks/pre-commit" "$HOOKS_DIR/pre-commit"
        chmod +x "$HOOKS_DIR/pre-commit"
        echo "  pre-commit hook installed"
    fi

    # Pre-push
    if [ -f "$SCRIPT_DIR/hooks/pre-push" ]; then
        cp "$SCRIPT_DIR/hooks/pre-push" "$HOOKS_DIR/pre-push"
        chmod +x "$HOOKS_DIR/pre-push"
        echo "  pre-push hook installed"
    fi
fi

# ================================================
# 3. SUMMARY
# ================================================
echo ""
echo "================================================"
echo "Installation complete!"
echo "================================================"
echo ""
echo "Available aliases:"
echo "  ccf    - Frontend (frontend-developer + ui-designer + ux-polisher)"
echo "  ccb    - Backend (backend-architect + db-architect + security-reviewer)"
echo "  ccd    - Dashboard (dashboard-crafter + ui-designer)"
echo "  ccds   - Design (ui-designer + brand-guardian + ux-polisher)"
echo "  ccr    - Pre-Release (brutal-critic + security-reviewer + qa-engineer)"
echo "  ccs    - Security (security-reviewer + api-tester + backend-architect)"
echo "  ccdebug - Debug (debugger + db-architect)"
echo ""
echo "Git hooks installed:"
echo "  pre-commit - Bug pattern checks"
echo "  pre-push   - Agent recommendation"
echo ""

if [ -n "$SHELL_RC" ]; then
    echo "To activate aliases now, run:"
    echo "   source $SHELL_RC"
fi
