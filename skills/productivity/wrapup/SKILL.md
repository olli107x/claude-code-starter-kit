---
name: wrapup
description: End-of-session ritual that runs tests, commits, pushes, updates PROGRESS.md, and creates a handoff document. Use when ending a coding session or switching context.
allowed-tools: Bash,Read,Write,Edit,Glob,Grep
---

# Session Wrap-Up

End-of-session ritual to preserve all work and context for the next session.

## When to Use

- End of a coding session
- Before switching to a different project
- Before taking a break from a multi-session task
- When user says "wrap up", "done for now", "end session"

## Process

### Phase 1: Run Tests

Verify current state before committing:

```bash
# Run available test suites
if [ -f package.json ]; then npm test -- --run 2>&1 | tail -20; fi
if [ -f pytest.ini ] || [ -f pyproject.toml ] || [ -d tests ]; then pytest -x --tb=short 2>&1 | tail -20; fi
```

Report test results to user. If tests fail, ask whether to fix or commit anyway.

### Phase 2: Commit Changes

```bash
git status
git diff --stat
```

Stage and commit all changes with a descriptive conventional commit message.
If multiple logical changes exist, create separate commits per change.

### Phase 3: Push to Remote

```bash
git push
```

Push to the current branch. If no upstream is set, use `git push -u origin <branch>`.

### Phase 4: Update PROGRESS.md

Read existing PROGRESS.md (or create if absent). Update with:

```markdown
## Session Update — {date}

### Completed
- {list of completed items}

### Remaining
- {list of remaining items}

### Blockers
- {any blockers or decisions needed}
```

### Phase 5: Create HANDOFF.md

Create or overwrite HANDOFF.md in project root:

```markdown
# Session Handoff — {date}

## Completed
{what was accomplished this session}

## In Progress
{partially done work with current state}

## Next Steps
1. {prioritized next actions with file paths}
2. ...

## Blockers
{anything stuck or needing decisions}

## Key Decisions
{choices made and why}
```

### Phase 6: Final Summary

Print a concise summary to the user:

```
Session wrapped up:
- Tests: {pass/fail}
- Commits: {count} commits pushed to {branch}
- Docs: PROGRESS.md + HANDOFF.md updated
- Next: {top 1-2 priorities for next session}
```
