---
name: handoff
description: Create a structured handoff document for session continuity. Lighter than /wrapup — just documentation, no commit/push. Use when you want to save context without committing.
allowed-tools: Read,Write,Edit,Glob,Grep
---

# Session Handoff Document

Create a structured handoff document capturing current session state for future continuity.

## When to Use

- Mid-session when context is getting complex
- When user wants to save progress notes without committing
- Before handing off to another person or session
- When user says "handoff", "save context", "document progress"

## Process

### Step 1: Gather Context

Read recent git history, current changes, and any existing docs:

```bash
git log --oneline -10
git status
git diff --stat
```

Also check for existing PROGRESS.md, HANDOFF.md, TODO files.

### Step 2: Create HANDOFF.md

Write HANDOFF.md in the project root with these sections:

```markdown
# Session Handoff — {date}

## Completed
{what was accomplished — be specific with file paths and line numbers}

## In Progress
{partially done work — describe current state and what remains}

## Next Steps
1. {highest priority — include file paths}
2. {second priority}
3. {third priority}

## Blockers
{anything stuck, needing decisions, or waiting on external input}

## Key Decisions
{choices made during session and rationale}
- Decision: {what} — Reason: {why}
```

### Step 3: Confirm

Print summary to user:

```
Handoff document created at HANDOFF.md
- Completed: {count} items
- Next steps: {count} items
- Blockers: {count} items
```

## Notes

- This skill does NOT commit, push, or run tests — use /wrapup for that
- If HANDOFF.md already exists, overwrite it (it's a living document)
- Be specific: include file paths, line numbers, and function names
- Prioritize next steps by importance and dependencies
