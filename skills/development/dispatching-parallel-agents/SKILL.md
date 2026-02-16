---
name: dispatching-parallel-agents
description: Formalized patterns for dispatching 3+ parallel sub-agents with scope boundaries, result aggregation, error handling, and conflict prevention. Complements the orchestrate skill with explicit dispatch recipes.
---

# Dispatching Parallel Agents

Formalized patterns for running 3+ sub-agents in parallel with guardrails.

## When to Use

- Task has 3+ independent sub-tasks
- Sub-tasks touch different files/modules (no overlap)
- Parallel execution would save significant time
- User says "dispatch agents", "run parallel", "fan out"

## Prerequisites

- Tasks MUST be independent (no shared file writes)
- Each agent gets a NARROW, specific scope
- Exploration agents: "report findings, do NOT fix"
- Implementation agents: "only modify files in your scope"

## Dispatch Patterns

### Pattern 1: Fan-Out / Fan-In (Research)

All agents research in parallel, results aggregated by leader.

```
         ┌─── Agent A: Research X ───┐
         │                           │
Leader ──┼─── Agent B: Research Y ───┼── Leader aggregates
         │                           │
         └─── Agent C: Research Z ───┘
```

**Use for:** Code analysis, audit, exploration

```
Task(subagent_type="Explore", prompt="Find all files using pattern X. Report findings only, do NOT edit.")
Task(subagent_type="Explore", prompt="Find all files using pattern Y. Report findings only, do NOT edit.")
Task(subagent_type="Explore", prompt="Find all files using pattern Z. Report findings only, do NOT edit.")
```

### Pattern 2: Parallel Implementation

Each agent implements in a separate scope.

```
         ┌─── Agent A: Backend (app/**) ────────┐
         │                                       │
Leader ──┼─── Agent B: Frontend (src/**) ────────┼── Leader validates
         │                                       │
         └─── Agent C: Tests (tests/**) ─────────┘
```

**Use for:** Full-stack features, multi-module changes

```
Task(subagent_type="general-purpose", prompt="Implement {backend spec}. ONLY modify files in backend/app/. Do NOT touch frontend/.")
Task(subagent_type="general-purpose", prompt="Implement {frontend spec}. ONLY modify files in frontend/src/. Do NOT touch backend/.")
Task(subagent_type="general-purpose", prompt="Write tests for {spec}. ONLY create/modify files in tests/ and *.test.* files.")
```

### Pattern 3: Multi-Perspective Review

Same codebase, different review lenses.

```
         ┌─── Agent A: Bug review ──────────────┐
         │                                       │
Leader ──┼─── Agent B: Security review ──────────┼── Leader merges reports
         │                                       │
         └─── Agent C: Performance review ───────┘
```

**Use for:** Code review, audit, pre-deployment checks

```
Task(subagent_type="feature-dev:code-reviewer", prompt="Review {files} for bugs and logic errors only.")
Task(subagent_type="security-reviewer", prompt="Review {files} for security vulnerabilities only.")
Task(subagent_type="general-purpose", prompt="Review {files} for performance issues only.")
```

### Pattern 4: Hypothesis Testing (Debugging)

Test multiple hypotheses simultaneously.

```
         ┌─── Agent A: Test hypothesis 1 ───────┐
         │                                       │
Leader ──┼─── Agent B: Test hypothesis 2 ────────┼── Leader evaluates
         │                                       │
         └─── Agent C: Test hypothesis 3 ────────┘
```

**Use for:** Debugging, root cause analysis

## Dispatch Checklist

Before dispatching:

- [ ] **Scope defined:** Each agent has clear file boundaries
- [ ] **No overlap:** No two agents modify the same file
- [ ] **Specific prompt:** Each agent knows exactly what to do
- [ ] **Output format:** Each agent knows what to return
- [ ] **Read-only flag:** Research agents instructed NOT to edit

## Error Handling

### Agent Fails

```
IF agent returns error:
  1. Log the error
  2. Do NOT retry automatically more than once
  3. Report to user with context
  4. Continue with other agents' results
```

### Scope Violation

```
IF agent modified files outside scope:
  1. Revert out-of-scope changes (git checkout -- {files})
  2. Re-dispatch with stricter instructions
  3. If repeated, escalate to user
```

### Conflicting Results

```
IF agents produce conflicting recommendations:
  1. Present both perspectives to user
  2. Do NOT auto-resolve conflicts
  3. Let user decide which approach to follow
```

## Result Aggregation

After all agents complete:

1. **Collect results** from each agent
2. **Deduplicate** overlapping findings
3. **Prioritize** by severity (CRITICAL > HIGH > MEDIUM > LOW)
4. **Format** into unified report
5. **Present** to user for review

```markdown
## Parallel Agent Results

### Agent A: {role}
- Status: Completed
- Findings: {n} items
- Key insight: {summary}

### Agent B: {role}
- Status: Completed
- Findings: {n} items
- Key insight: {summary}

### Agent C: {role}
- Status: Completed
- Findings: {n} items
- Key insight: {summary}

### Aggregated Actions
1. {highest priority item}
2. {next priority item}
3. ...
```

## Anti-Patterns

| Anti-Pattern | Problem | Correct Approach |
|-------------|---------|-----------------|
| Same file in multiple scopes | Merge conflicts | One agent per file |
| Vague prompts | Agents go off-scope | Specific deliverables |
| Auto-fixing without review | Unexpected changes | Report first, fix after approval |
| Too many agents (>5) | Diminishing returns | Max 4-5 parallel agents |
| Sequential when parallel possible | Wasted time | Check independence first |
