# Claude Code Agent Aliases
# Installation: cat aliases.sh >> ~/.zshrc && source ~/.zshrc
# Structure: agents/{department}/{agent}.md

# ================================================
# CLAUDE CODE AGENT ALIASES (Department-Based)
# ================================================

# Full Stack Frontend
alias ccf='claude --agents engineering/frontend-developer,design/ui-designer,design/ux-polisher'

# Full Stack Backend
alias ccb='claude --agents engineering/backend-architect,engineering/db-architect,testing/security-reviewer'

# Dashboard Building
alias ccd='claude --agents design/dashboard-crafter,design/ui-designer'

# Design Review
alias ccds='claude --agents design/ui-designer,design/brand-guardian,design/ux-polisher'

# Pre-Release Review (brutal honest)
alias ccr='claude --agents testing/brutal-critic,testing/security-reviewer,testing/qa-engineer'

# Security Focused
alias ccs='claude --agents testing/security-reviewer,testing/api-tester,engineering/backend-architect'

# Debugging (systematic investigation)
alias ccdebug='claude --agents testing/debugger,engineering/db-architect'

# ================================================
# QUICK REFERENCE
# ================================================
# ccf    = Frontend (frontend-developer + ui-designer + ux-polisher)
# ccb    = Backend (backend-architect + db-architect + security-reviewer)
# ccd    = Dashboard (dashboard-crafter + ui-designer)
# ccds   = Design Only (ui-designer + brand-guardian + ux-polisher)
# ccr    = Pre-Release (brutal-critic + security-reviewer + qa-engineer)
# ccs    = Security (security-reviewer + api-tester + backend-architect)
# ccdebug = Debug (debugger + db-architect)

# ================================================
# DEPARTMENTS
# ================================================
# engineering/  -> Build the product
# design/       -> Make it beautiful
# testing/      -> Ensure quality
# utility/      -> Helper agents
