# Claude Code Agent System - PowerShell Aliases
# Installation: Copy contents into $PROFILE (notepad $PROFILE)

# Full Stack Frontend
function ccf { claude --agents engineering/frontend-developer,design/ui-designer,design/ux-polisher $args }

# Full Stack Backend
function ccb { claude --agents engineering/backend-architect,engineering/db-architect,testing/security-reviewer $args }

# Dashboard Building
function ccd { claude --agents design/dashboard-crafter,design/ui-designer $args }

# Design Review
function ccds { claude --agents design/ui-designer,design/brand-guardian,design/ux-polisher $args }

# Pre-Release Review
function ccr { claude --agents testing/brutal-critic,testing/security-reviewer,testing/qa-engineer $args }

# Security Focused
function ccs { claude --agents testing/security-reviewer,testing/api-tester,engineering/backend-architect $args }

# Debugging
function ccdebug { claude --agents testing/debugger,engineering/db-architect $args }
