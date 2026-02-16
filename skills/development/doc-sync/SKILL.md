---
name: doc-sync
description: Self-healing documentation sync. Auto-updates all docs (PROGRESS.md, README, HANDOFF.md, docs/) to match current code state. Use after significant changes or before releases.
allowed-tools: Bash,Read,Write,Edit,Glob,Grep
---

# Self-Healing Documentation Sync

Automatically update all documentation to reflect the current code state.

## When to Use

- After completing a feature or significant changes
- Before a release or deployment
- When docs feel stale or out of sync
- When user says "sync docs", "update docs", "doc-sync"

## Process

### Phase 1: Identify Changes

```bash
# What changed since last doc update
git diff main --stat
git log --oneline main..HEAD
```

List all changed files grouped by area (backend, frontend, config, docs).

### Phase 2: Scan Existing Docs

Read all documentation files that might need updates:

```bash
# Find all docs
ls PROGRESS.md README.md HANDOFF.md SOUL.md 2>/dev/null
ls docs/ 2>/dev/null
```

For each doc, note what sections reference changed code.

### Phase 3: Update Documents

For each document that needs updating:

**PROGRESS.md:**
- Update completed items
- Add/remove remaining items
- Update blockers section

**README.md:**
- Update setup instructions if dependencies changed
- Update API docs if endpoints changed
- Update feature list if features added/removed

**HANDOFF.md:**
- Regenerate with current state (overwrite)

**docs/ files:**
- Update any docs that reference changed files
- Update architecture docs if structure changed
- Update API docs if schemas changed

### Phase 4: Detect Inconsistencies

Check for:
- TODOs in code that aren't tracked in PROGRESS.md
- Features mentioned in docs that don't exist in code
- Removed features still documented
- Changed API signatures not reflected in docs

Report any inconsistencies found.

### Phase 5: Commit

```bash
git add -A docs/ PROGRESS.md README.md HANDOFF.md
git commit -m "docs: sync documentation with current code state"
```

### Phase 6: Summary

```markdown
## Doc Sync Results

### Updated
- PROGRESS.md: {changes}
- README.md: {changes}
- HANDOFF.md: regenerated

### Inconsistencies Found
- {list of any mismatches between code and docs}

### No Changes Needed
- {docs that were already up to date}
```

## Notes

- This skill only updates documentation, never source code
- When unsure about a doc change, mark it with `<!-- REVIEW: ... -->` for user
- Preserve existing doc structure and formatting
- Don't remove sections, only update content within them
