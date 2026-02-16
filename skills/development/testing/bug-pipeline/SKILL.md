---
name: bug-pipeline
description: Autonomous bug-fix pipeline. Hand Claude a list of failing tests or bugs, and it iterates through each one systematically with parallel agents, reverting on failure. One commit per fix.
allowed-tools: Bash,Read,Write,Edit,Glob,Grep,Task
---

# Autonomous Bug-Fix Pipeline

Systematically fix a batch of bugs or failing tests with guardrails.

## When to Use

- Multiple failing tests need fixing
- User provides a list of bugs to resolve
- After a refactoring that broke multiple things
- When user says "fix these bugs", "fix failing tests", "bug pipeline"

## Input

User provides one or more of:
- List of failing test names/paths
- Bug descriptions with file references
- Output of a failed test run

## Process

### Phase 1: Triage

1. Run the full test suite to establish baseline:
   ```bash
   npm test -- --run 2>&1 || pytest -x --tb=short 2>&1
   ```
2. Parse failing tests into a list
3. Classify each bug as independent or dependent
4. Present triage to user for confirmation

### Phase 2: Fix (per bug)

For each independent bug, use parallel Task agents when possible:

**Per-bug workflow:**
1. **Read** the failing test + source code under test
2. **Identify** root cause (use systematic-debugging approach)
3. **Implement** minimal fix (smallest change that fixes the test)
4. **Verify** by running the specific test:
   ```bash
   npx vitest run {test_file} 2>&1 || pytest {test_file} -v 2>&1
   ```
5. **If test passes:** Stage and commit with message `fix: {description}`
6. **If test fails:** Revert changes, try different approach (max 3 attempts)
7. **If 3 attempts fail:** Skip, document in summary, move to next bug

**Rules:**
- Each agent works on SEPARATE files only
- One commit per bug fix
- Never change the test unless the test itself is wrong
- If fixing one bug breaks another, revert and flag as dependent

### Phase 3: Verify

1. Run the full test suite again
2. Compare before/after

### Phase 4: Summary

Print results table:

```markdown
| Bug | Root Cause | Files Changed | Tests Before | Tests After | Status |
|-----|-----------|---------------|-------------|------------|--------|
| #1  | Missing null check | api.ts:45 | FAIL | PASS | Fixed |
| #2  | Wrong query param | service.py:23 | FAIL | PASS | Fixed |
| #3  | Race condition | hook.ts:12 | FAIL | FAIL | Skipped (3 attempts) |
```

```
Summary: {fixed}/{total} bugs resolved
Commits: {count} new commits
Remaining: {list of unfixed bugs with notes}
```

## Guardrails

- Max 3 fix attempts per bug before skipping
- Revert on any regression (other tests breaking)
- Never modify more than what's needed for the fix
- Ask user before touching shared utilities or configs
