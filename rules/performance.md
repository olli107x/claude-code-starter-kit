# Performance & Context Window Management

> **CRITICAL**: These rules prevent context window exhaustion and optimize model usage.

---

## Model Selection

| Model | Use Case | Cost |
|-------|----------|------|
| **Haiku** | Quick tasks, lightweight agents, pair programming | Cheapest |
| **Sonnet** | Primary coding, complex features, orchestration | Standard |
| **Opus** | Complex architecture, deep research, critical decisions | Premium |

**Default to Sonnet** unless task clearly fits Haiku (simple) or requires Opus (complex architecture).

---

## Context Window Strategy

**200k tokens can shrink to ~70k with too many tools enabled!**

### MCP/Plugin Limits

```
HARD LIMITS:
- Max 20-30 MCPs configured total
- Max 10 MCPs enabled per project
- Max 80 tools active at once
```

### Use `disabledMcpServers` in project config:

```json
{
  "disabledMcpServers": [
    "mcp-server-not-needed-for-this-project"
  ]
}
```

### Context Sensitivity by Task

**HIGH SENSITIVITY** (avoid last 20% of context):
- Large-scale refactoring
- Multi-file feature implementation
- Complex architectural changes

**LOW SENSITIVITY** (can use full context):
- Single-file modifications
- Utility creation
- Documentation updates
- Simple bug fixes

---

## Build Issue Resolution

When encountering build failures:

1. **Activate build-error-resolver** (use `/build-fix` command)
2. Examine error messages systematically
3. Fix ONE error at a time
4. Verify fix before next error
5. Document all fixes

---

## Advanced Reasoning

For sophisticated problems:
- Use **ultrathink** + **Plan Mode**
- Multiple critique rounds
- Leverage specialized sub-agents for varied perspectives

---

## Quick Checks

Before starting work:
- [ ] How many tools are active? (Check with tool count)
- [ ] Is this a high-sensitivity task?
- [ ] What model is appropriate?
