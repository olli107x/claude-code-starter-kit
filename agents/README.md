---
name: readme
description: Agent system overview and usage guide. Use when understanding which agent to use, how to chain agents, or setting up bash aliases. Contains structure, format, and rules for the agent system.
---

# Claude Code Agents

> **Think in departments. Each folder = department. Each file = one job.**

## What Are Agents?

Agents are specialized instruction files for Claude Code. Each agent has a focused role, clear inputs/outputs, and a defined methodology. Instead of giving Claude Code general prompts, you invoke agents that know exactly how to handle specific types of work.

Think of agents as team members with job descriptions -- each one brings domain expertise to a task.

## Structure

```
agents/
├── engineering/       # Build the product
│   ├── frontend-developer.md   -> ship clean UI for this feature
│   ├── backend-architect.md    -> design API + DB schema
│   └── db-architect.md         -> optimize queries, migrations
│
├── design/            # Make it beautiful
│   ├── ui-designer.md          -> layout, components, hierarchy
│   ├── dashboard-crafter.md    -> KPIs, charts, data-dense UIs
│   ├── brand-guardian.md       -> brand colors, fonts, anti-patterns
│   └── ux-polisher.md          -> micro-interactions, states
│
├── testing/           # Ensure quality
│   ├── debugger.md             -> systematic bug investigation
│   ├── api-tester.md           -> endpoint coverage, edge cases
│   ├── security-reviewer.md    -> vulnerabilities, auth
│   ├── qa-engineer.md          -> test plans, coverage
│   └── brutal-critic.md        -> roast before ship
│
├── utility/           # Helper agents
│   ├── explorer.md             -> find files, understand codebase
│   ├── historian.md            -> session checkpoints, context
│   ├── research-documenter.md  -> API research, documentation
│   └── doc-updater.md          -> keep docs in sync with code
│
└── _setup/            # Installation scripts
    ├── aliases.sh
    ├── aliases-windows.ps1
    ├── install.sh
    └── hooks/
        ├── pre-commit
        └── pre-push
```

## How to Use

### Invoke a Single Agent

```
@ui-designer Build a KPI card component
```

### Chain Agents (Feature Flow)

```
backend-architect → design API
frontend-developer → build UI
api-tester → verify endpoints
brutal-critic → final review
```

### Bash Aliases

```bash
# Add to ~/.zshrc or ~/.bashrc (or run _setup/install.sh)

# Full Stack Frontend
alias ccf='claude --agents engineering/frontend-developer,design/ui-designer,design/ux-polisher'

# Full Stack Backend
alias ccb='claude --agents engineering/backend-architect,engineering/db-architect,testing/security-reviewer'

# Dashboard Building
alias ccd='claude --agents design/dashboard-crafter,design/ui-designer'

# Pre-Release Review
alias ccr='claude --agents testing/brutal-critic,testing/security-reviewer,testing/qa-engineer'

# Debugging (systematic investigation)
alias ccdebug='claude --agents testing/debugger,engineering/db-architect'
```

## Agent Format

Every agent follows this structure:

```markdown
# agent-name

> **Outcome:** One clear deliverable

## Inputs
- What the agent needs

## Steps
1. Step-by-step process
2. With code examples
3. And patterns

## Outputs
- What the agent produces

## Linked Skills
- Related skills to read

## Works With
- Other agents to chain
```

## Customizing for Your Project

These agents are templates. To adapt them for your project:

1. **Brand Guardian** -- Replace placeholder colors and fonts with your actual brand tokens
2. **Dashboard Crafter** -- Adjust number formatting for your locale (e.g., `$1,234.56` vs `1.234,56 EUR`)
3. **Security Reviewer** -- Update the CORS origins and protected endpoint patterns
4. **DB Architect** -- Swap in your ORM and database of choice
5. **Research Documenter** -- List your project's external API dependencies

## Departments

| Department | Purpose | When to Use |
|------------|---------|-------------|
| **Engineering** | Build features, design APIs, optimize databases | New features, API work, performance |
| **Design** | UI components, dashboards, brand compliance | UI work, data visualization, design review |
| **Testing** | Bug hunting, security audits, test coverage | QA, pre-release, debugging |
| **Utility** | Code navigation, checkpoints, documentation | Research, onboarding, maintenance |

## Rules

1. **One outcome per agent** -- Clear, measurable deliverable
2. **No "general helper" agents** -- Every agent has a specific job
3. **Turn repeats into playbooks** -- Asked 3x? Make it a skill file
4. **Route work like a real team** -- Chain agents for complex tasks
5. **If you hate doing it twice, assign it to an agent**

---

*Agent System Starter Kit | Adapted from production agent configurations*
