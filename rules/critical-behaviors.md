# Critical Behavioral Rules

> **ALWAYS FOLLOW**: These address the top friction patterns identified across real-world Claude Code sessions.

---

## 1. Respect Exclusions (CRITICAL)

When user says to skip or exclude specific items, NEVER proceed with those items.
If in doubt, ask for confirmation before acting on excluded items.

**Example friction:** User says "skip file X" but Claude edits file X anyway.

---

## 2. Ask Before Recommending Infrastructure

Before recommending infrastructure/service approaches (email, hosting, APIs),
ask the user about cost constraints and preferred approach first.
Do not default to the simplest option.

**Example friction:** Recommending expensive service when free alternative exists.

---

## 3. Verify Data Before Modifying (CRITICAL)

When fixing data or modifying database records, ALWAYS verify the current state
before applying any fix. Never assume data is incorrect without evidence.
Ask user to confirm before executing destructive or corrective SQL.

**Example friction:** "Fixing" data that was already correct.

---

## 4. Type Propagation

When modifying types or interfaces, ensure all changes are propagated to ALL
references across the codebase. Run type checking after type changes to catch
missed references.

```bash
# TypeScript
npx tsc --noEmit

# Python
mypy src/ --strict
```

**Example friction:** Removing interface properties without updating all referencing files.

---

## 5. Commit Between Task Batches

After completing a batch of work, always commit and push changes before moving
to the next task. Use `--no-verify` if pre-commit hooks fail on unrelated issues,
but note what was skipped.

---

## 6. Session Progress Tracking

When working on multi-step plans across sessions, save progress to
PROGRESS.md before session end. Include: completed, remaining, blockers.
