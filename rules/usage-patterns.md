# Usage Patterns (from Insights Analysis)

> **ALWAYS FOLLOW**: Proven patterns from 158 sessions, 197 commits.

---

## 1. Upfront Constraints for Complex Tasks

Before starting infrastructure, data, or API tasks:
- State constraints explicitly (cost, scope, approach)
- Say what NOT to do
- Ask user to confirm approach before implementing anything
  that touches production data or external services

**Why:** "wrong_approach" was the #1 friction pattern (23 occurrences).

---

## 2. Strategic Parallel Agents

When spawning parallel Task agents:
- Give each agent a NARROW, specific scope
- For exploration: "report findings, do NOT fix"
- Each agent works on SEPARATE files (no overlaps)
- Review all findings before any edits
- Successful pattern: well-scoped tasks > autonomous agents

**Why:** Overly autonomous agents caused scope violations and conflicting edits.

---

## 3. Session Continuity Protocol

For multi-session projects:
- Start sessions by reading HANDOFF.md / PROGRESS.md if they exist
- End sessions with /wrapup or /handoff skill
- Never assume context carries over between sessions

**Why:** Context loss between sessions caused repeated work and missed decisions.
