# Test Audit Guidelines

> **TRIGGER:** Teil des Full Audits oder manuell via `/audit-test`

---

## Agents & Skills

| Tool | Zweck |
|------|-------|
| `qa-engineer` Agent | Test Coverage Analysis |
| `api-tester` Agent | API Endpoint Tests |
| `/test-fixing` Skill | Failing Test Resolution |
| `/verification-before-completion` Skill | Test-Verifikation |

---

## Pruefpunkte Checkliste

### Test Existence

- [ ] Alle neuen Funktionen haben Tests
- [ ] Alle geaenderten Funktionen haben Tests
- [ ] Test-Dateien folgen Namenskonvention (`*.test.ts`, `test_*.py`)

### Test Coverage

- [ ] Happy Path getestet
- [ ] Error Cases getestet
- [ ] Edge Cases getestet:
  - [ ] Empty input
  - [ ] Max length/size
  - [ ] Unicode/Special characters
  - [ ] Null/undefined
  - [ ] Boundary values

### Test Quality

- [ ] Tests sind unabhaengig (keine shared state)
- [ ] Tests sind deterministisch (keine flaky tests)
- [ ] Mocks sind akkurat
- [ ] Assertions sind aussagekraeftig
- [ ] Keine skipped Tests ohne dokumentierten Grund

### Test Execution

- [ ] `npm test` passed (Frontend)
- [ ] `pytest` passed (Backend)
- [ ] Keine Test Warnings
- [ ] Reasonable execution time

---

## Coverage Requirements

| Bereich | Minimum | Target |
|---------|---------|--------|
| Neue Funktionen | 80% | 90% |
| Geaenderte Dateien | 70% | 80% |
| Critical Paths | 90% | 100% |
| Overall Project | 70% | 80% |

### Coverage Commands

```bash
# Backend - pytest mit Coverage
pytest --cov=src --cov-report=term-missing --cov-report=html

# Frontend - Vitest mit Coverage
npm test -- --coverage

# Specific file
npx vitest run src/hooks/useItems.test.ts
pytest tests/api/test_items.py -v
```

---

## Test Structure

### Backend (pytest)

```
backend/tests/
├── api/              # API endpoint tests
│   ├── test_items.py
│   ├── test_users.py
│   └── test_auth.py
├── services/         # Service layer tests
│   ├── test_item_service.py
│   └── test_user_service.py
├── models/           # Model tests
│   └── test_item_model.py
├── integration/      # Integration tests
│   └── test_full_flow.py
└── conftest.py       # Shared fixtures
```

### Frontend (Vitest)

```
frontend/src/
├── components/
│   ├── items/
│   │   ├── ItemCard.tsx
│   │   └── ItemCard.test.tsx    # Co-located
│   └── ...
├── hooks/
│   ├── useItems.ts
│   └── useItems.test.ts
└── lib/
    ├── utils.ts
    └── utils.test.ts
```

---

## Test Patterns

### Happy Path Test

```typescript
// Frontend
describe('ItemCard', () => {
  it('renders item information correctly', () => {
    const item = mockItem({ title: 'Test Item', price: 1000 });
    render(<ItemCard item={item} />);

    expect(screen.getByText('Test Item')).toBeInTheDocument();
    expect(screen.getByText('$1,000.00')).toBeInTheDocument();
  });
});
```

```python
# Backend
def test_create_item_success(client, auth_headers):
    """Test successful item creation."""
    response = client.post(
        "/api/items",
        json={"title": "New Item", "price": 5000},
        headers=auth_headers
    )

    assert response.status_code == 201
    assert response.json()["title"] == "New Item"
```

### Error Case Test

```typescript
// Frontend
it('shows error state when fetch fails', async () => {
  server.use(
    rest.get('/api/items', (req, res, ctx) => {
      return res(ctx.status(500));
    })
  );

  render(<ItemsPage />);

  await waitFor(() => {
    expect(screen.getByText(/error/i)).toBeInTheDocument();
  });
});
```

```python
# Backend
def test_create_item_missing_title(client, auth_headers):
    """Test item creation fails without title."""
    response = client.post(
        "/api/items",
        json={"price": 5000},  # Missing title
        headers=auth_headers
    )

    assert response.status_code == 422
    assert "title" in response.json()["detail"][0]["loc"]
```

### Edge Case Test

```typescript
// Empty input
it('handles empty items array', () => {
  render(<ItemsList items={[]} />);
  expect(screen.getByText('No items found')).toBeInTheDocument();
});

// Max length
it('truncates very long titles', () => {
  const item = mockItem({ title: 'A'.repeat(200) });
  render(<ItemCard item={item} />);
  expect(screen.getByText(/\.\.\.$/)).toBeInTheDocument();
});

// Special characters
it('handles unicode in item title', () => {
  const item = mockItem({ title: 'Item with special chars: <>&"' });
  render(<ItemCard item={item} />);
  expect(screen.getByText(/Item with special chars/)).toBeInTheDocument();
});
```

---

## Test Anti-Patterns

| Anti-Pattern | Problem | Correct Approach |
|--------------|---------|------------------|
| Testing implementation | Brittle tests | Test behavior/output |
| Shared mutable state | Flaky tests | Fresh state per test |
| Excessive mocking | False confidence | Integration tests |
| No error cases | Incomplete coverage | Test unhappy paths |
| Hardcoded test data | Magic numbers | Use factories/fixtures |
| `test.skip` everywhere | Hidden failures | Fix or remove tests |
| Async without await | Silent failures | Proper async handling |

---

## Severity Mapping

| Finding | Severity | Action |
|---------|----------|--------|
| New function without tests | HIGH | Add tests before merge |
| Failing tests | HIGH | Must fix |
| Flaky test | MEDIUM | Investigate and fix |
| Coverage < 70% | MEDIUM | Add more tests |
| Missing edge case tests | MEDIUM | Add tests |
| Skipped test without reason | LOW | Add comment or enable |
| Slow tests (>5s) | LOW | Optimize if possible |

---

## Automated Checks

```bash
# Quick validation
npm test -- --run          # Frontend (no watch)
pytest -x                   # Backend (stop on first fail)

# Full with coverage
npm test -- --coverage
pytest --cov=src --cov-fail-under=70

# Specific pattern
npx vitest run --filter="ItemCard"
pytest -k "test_item"
```

---

## Report Format

```markdown
## Test Audit Results

### Status: NEEDS ATTENTION

### Test Execution
- Frontend: 45/45 tests passing
- Backend: 23/25 tests passing (2 failures)

### Failures
1. `test_item_update_permissions` - AssertionError
2. `test_user_merge` - Timeout

### Coverage
| Area | Coverage | Target | Status |
|------|----------|--------|--------|
| New code | 65% | 80% | FAIL |
| Changed files | 72% | 70% | PASS |
| Overall | 74% | 70% | PASS |

### Missing Tests (HIGH)
1. `ItemFormModal.tsx` - No tests for new validation logic
2. `user_service.py:batch_update()` - No unit test

### Edge Cases Missing (MEDIUM)
1. `useItems.ts` - No test for empty response
2. `ItemCard.tsx` - No test for very long titles

### Recommendations
- Add tests for ItemFormModal validation
- Fix failing test_item_update_permissions
- Increase new code coverage to 80%
```

---

## Integration with Other Audits

- **Bug Audit:** Fehlende Tests = potentielle Bugs
- **Security Audit:** Security-Tests verifizieren Auth/Validation
- **Plan Verification:** Alle Plan-Items muessen getestet sein

---

## Related Rules

- `testing.md` - General Testing Rules
- `audit-workflow.md` - Audit Orchestration
