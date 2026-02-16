# Testing Rules

> **MANDATORY**: 80% coverage minimum. TDD workflow required.

---

## Coverage Requirements

| Test Type | Requirement | Tools |
|-----------|-------------|-------|
| **Unit Tests** | Functions, components | Vitest, pytest |
| **Integration Tests** | API, database | pytest, supertest |
| **E2E Tests** | Critical user flows | Playwright |

**Minimum: 80% coverage across all test types**

---

## TDD Workflow (Red-Green-Refactor)

```
1. Write test first (RED)
   -> Test should FAIL

2. Write minimal implementation (GREEN)
   -> Test should PASS

3. Refactor (IMPROVE)
   -> Tests still PASS

4. Verify coverage (80%+)
   -> Coverage meets threshold
```

### When to Use TDD

| Scenario | Action |
|----------|--------|
| New feature | `/tdd` - Start with tests |
| Bug fix | Write failing test first |
| Refactoring | Ensure tests exist first |

---

## Test Failure Resolution

When tests fail:

1. **Consult** tdd-guide skill (`/tdd`)
2. **Confirm** tests run independently
3. **Validate** mock accuracy
4. **Fix implementation** first, NOT tests
5. **Only adjust tests** if they contain errors

**NEVER skip failing tests!**

---

## Recommended Test Structure

### Backend (pytest)
```
backend/tests/
├── api/           # API endpoint tests
├── services/      # Service layer tests
├── models/        # Model tests
├── integration/   # Integration tests
└── conftest.py    # Shared fixtures
```

### Frontend (Vitest)
```
frontend/src/
├── components/
│   └── MyComponent.test.tsx    # Co-located with component
├── hooks/
│   └── useMyHook.test.ts
└── lib/
    └── utils.test.ts
```

---

## Quick Commands

```bash
# Frontend tests
npm test                    # All tests
npm test -- --coverage      # With coverage
npx vitest run <file>       # Single file

# Backend tests
pytest                      # All tests
pytest --cov               # With coverage
pytest tests/api/          # Specific folder
```

---

## Test Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Testing implementation | Brittle | Test behavior |
| Shared mutable state | Flaky | Fresh state per test |
| Excessive mocking | False confidence | Integration tests |
| No error cases | Incomplete | Test unhappy paths |
| Hardcoded test data | Magic numbers | Fixtures/factories |
