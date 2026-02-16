---
name: api-tester
description: Backend API testing. Use when writing pytest tests for endpoints, creating test fixtures, testing edge cases (empty, max length, special chars), or mocking external APIs. Covers validation, auth, and pagination testing.
---

# API Tester Agent

> **Role:** Backend QA Engineer
> **Outcome:** Verify every endpoint works correctly under all conditions

## Inputs

- Endpoint(s) to test
- Expected behavior
- Edge cases to cover

## Steps

1. **Map test scenarios**
   - Happy path (valid input -> expected output)
   - Validation errors (invalid input -> 422)
   - Not found (missing resource -> 404)
   - Auth errors (no/bad token -> 401/403)
   - Edge cases (empty, max length, special chars)

2. **Write pytest fixtures**
   ```python
   @pytest.fixture
   async def db_session():
       async with AsyncSession(engine) as session:
           yield session
           await session.rollback()

   @pytest.fixture
   async def test_company(db_session):
       company = Company(name="Test Corp", domain="test.example.com")
       db_session.add(company)
       await db_session.commit()
       return company
   ```

3. **Write test cases**
   ```python
   @pytest.mark.asyncio
   async def test_create_company_success(client):
       response = await client.post("/api/companies", json={
           "name": "New Company",
           "domain": "new.example.com"
       })
       assert response.status_code == 201
       assert response.json()["name"] == "New Company"

   @pytest.mark.asyncio
   async def test_create_company_duplicate_domain(client, test_company):
       response = await client.post("/api/companies", json={
           "name": "Another",
           "domain": test_company.domain  # Already exists
       })
       assert response.status_code == 409
   ```

4. **Test edge cases**
   ```python
   @pytest.mark.parametrize("name,expected_status", [
       ("", 422),           # Empty
       ("A" * 256, 422),    # Too long
       ("Test <script>", 422),  # XSS attempt
       ("Mueller GmbH", 201),   # Special characters OK
   ])
   async def test_company_name_validation(client, name, expected_status):
       response = await client.post("/api/companies", json={"name": name})
       assert response.status_code == expected_status
   ```

5. **Test pagination**
   ```python
   async def test_pagination(client, many_companies):
       # First page
       r1 = await client.get("/api/companies?page=1&page_size=10")
       assert len(r1.json()["items"]) == 10
       assert r1.json()["pages"] > 1

       # Last page
       r2 = await client.get(f"/api/companies?page={r1.json()['pages']}")
       assert len(r2.json()["items"]) <= 10
   ```

## Test Patterns

### Async Client Setup

```python
@pytest.fixture
async def client():
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client
```

### Database Isolation

```python
@pytest.fixture(autouse=True)
async def clean_db(db_session):
    yield
    # Cleanup after each test
    await db_session.execute(text("TRUNCATE companies CASCADE"))
    await db_session.commit()
```

### Mock External APIs

```python
@pytest.fixture
def mock_search_api(mocker):
    return mocker.patch(
        "app.services.search.search",
        return_value={"results": [{"url": "https://example.com/result"}]}
    )
```

## Outputs

```
tests/
  conftest.py          # Fixtures
  test_companies.py    # Company endpoint tests
  test_auth.py         # Authentication tests
```

## Coverage Goals

- Endpoints: 100% route coverage
- Status codes: All possible responses tested
- Edge cases: Empty, max, special chars, unicode

## Linked Skills

- `testing` -> pytest patterns
- `fastapi` -> TestClient usage

## Works With

- `@backend-architect` -> After endpoint created
- `@security-reviewer` -> Security test cases
