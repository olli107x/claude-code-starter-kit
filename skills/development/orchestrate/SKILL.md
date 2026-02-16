---
name: orchestrate
description: Multi-agent orchestration with guardrails. Dispatch scoped work to sub-agents with validation before accepting changes. Use for parallel feature implementation with strict scope boundaries.
allowed-tools: Bash,Read,Write,Edit,Glob,Grep,Task
---

# Multi-Agent Orchestration with Guardrails

Dispatch scoped work to sub-agents with strict boundaries and validation.

## When to Use

- Feature requires work across multiple independent areas (backend, frontend, tests)
- Multiple agents can work in parallel without file conflicts
- User wants coordinated parallel development with safety checks
- When user says "orchestrate", "parallel feature", "dispatch agents"

## Input

User provides:
- Feature description
- (Optional) Agent contracts: which agent edits which files

## Process

### Phase 1: Plan Scope

1. Analyze the feature and identify independent work streams
2. Define agent contracts:

```markdown
| Agent | Role | Allowed Files | Forbidden Files |
|-------|------|--------------|----------------|
| backend | API + Service | backend/app/** | frontend/** |
| frontend | UI + Hooks | frontend/src/** | backend/** |
| tests | Test Coverage | **/tests/**, **/*.test.* | Source files |
```

3. Present plan to user for approval before dispatching

### Phase 2: Dispatch

For each agent contract, spawn a Task agent with:
- Specific scope description
- Allowed file patterns
- Clear deliverables
- Instruction: "Do NOT modify files outside your scope"

Run independent agents in parallel.

### Phase 3: Validate

Before accepting each agent's work:

1. **Scope check:** Verify agent only modified allowed files
   ```bash
   git diff --name-only
   ```
2. **Test check:** Run relevant test suite
   ```bash
   npm test -- --run 2>&1
   pytest --tb=short 2>&1
   ```
3. **Type check:** (for TS projects)
   ```bash
   npx tsc --noEmit 2>&1
   ```

**If scope violation:** Reject, revert out-of-scope changes, re-dispatch
**If test failure:** Reject, provide error context, re-dispatch (max 2 retries)

### Phase 4: Consolidate

1. Verify all agents' work integrates cleanly
2. Run full test suite
3. Create one commit per agent's work with descriptive messages
4. Push all commits

### Phase 5: Audit Log

Print results:

```markdown
| Agent | Files Touched | Scope Violations | Tests | Status |
|-------|--------------|------------------|-------|--------|
| backend | 3 files | 0 | PASS | Accepted |
| frontend | 5 files | 0 | PASS | Accepted |
| tests | 4 files | 0 | PASS | Accepted |
```

## Guardrails

- NEVER skip the scope validation step
- Max 2 re-dispatches per agent before escalating to user
- If agents need to modify the same file, run them sequentially
- Always get user approval on the scope plan before dispatching
