# Code Standards & Patterns

> Coding guidelines for Python + TypeScript projects

**Verwandte Docs:**
- `definition-of-done.md` - Checkliste vor Feature-Abschluss
- `debugging-methodology.md` - Systematisches Debugging

---

## Python Standards

```python
# ALWAYS use type hints
def get_item(id: UUID) -> Item: ...

# ALWAYS use Pydantic for request/response
class ItemCreate(BaseModel):
    name: str
    category_id: UUID
    items: list[SubItem]

# ALWAYS use Decimal for money
from decimal import Decimal
total = Decimal(str(value))  # Never float()!

# ALWAYS use structured logging
import logging
logger = logging.getLogger(__name__)
logger.info("operation", extra={"user_id": user.id, "action": "create"})
```

---

## TypeScript Standards

```typescript
// ALWAYS use interfaces for data shapes
interface Item {
  id: string;
  name: string;
  category: Category | null;
}

// ALWAYS use React Query with placeholderData
const { data } = useQuery({
  queryKey: ['items', filters],
  queryFn: () => fetchItems(filters),
  placeholderData: keepPreviousData,
  staleTime: 60_000,
});

// ALWAYS handle mutation errors
const mutation = useMutation({
  mutationFn: updateItem,
  onError: () => toast.error("Action failed"),
  onSettled: () => queryClient.invalidateQueries(['items']),
});
```

### API Params (Critical!)

```typescript
// WRONG - undefined becomes "undefined" string
const params = { category_id: filters.categoryId };

// CORRECT - only defined values
const params: Record<string, string> = {};
if (filters.categoryId) params.category_id = filters.categoryId;
```

---

## Anti-Patterns (DON'T)

| Pattern | Why Bad | Fix |
|---------|---------|-----|
| `any` in TypeScript | Loses type safety | Use proper interfaces |
| `float()` for money | Precision errors | `Decimal(str(value))` |
| `print()` for logging | Unstructured | `logger.info(...)` |
| `console.log` in prod | Debug noise | Remove or `if (isDev)` |
| ORDER BY after OFFSET | Inconsistent pagination | ORDER BY before OFFSET |
| useQuery without placeholderData | Data flickers | `placeholderData: keepPreviousData` |
| Button without disabled | Double-clicks | `disabled={isPending}` |
| Mutation without onError | Silent failures | `onError: () => toast.error(...)` |
| GET endpoint with db.commit() | Modifies data on read | No commits in GET handlers |
| Index for uniqueness | Allows duplicates | Use `UniqueConstraint` |
| Error details in toast | Exposes internals | Generic error messages |
| Hardcoded API keys | Security risk | Environment variables |
| Magic numbers in code | Hard to maintain | Import from constants module |
| Manual dict for responses | Inconsistent format | Use Pydantic `model_validate()` |
| Average with total rows | Divides by inactive (0-value) rows | Separate counter for filled values only |
| Bare `except:` | Catches everything silently | `except SpecificError as e:` |

---

## Centralized Constants

```python
# ALWAYS import from a constants module instead of hardcoding
from app.core.constants import (
    DEFAULT_PAGE_SIZE,
    MAX_PAGE_SIZE,
)

# Pagination
limit = min(limit, MAX_PAGE_SIZE)
```

```typescript
// Same in TypeScript
import { DEFAULT_PAGE_SIZE, MAX_PAGE_SIZE } from '@/lib/constants';

const limit = Math.min(requestedLimit, MAX_PAGE_SIZE);
```

---

## Database Helpers

```python
# Create reusable helpers for common patterns

# Example: get_or_404() instead of manual 404 handling
async def get_or_404(db: AsyncSession, model: type, id: UUID, **kwargs):
    result = await db.get(model, id, **kwargs)
    if not result:
        raise HTTPException(404, f"{model.__name__} not found")
    return result

# Usage
item = await get_or_404(db, Item, item_id)
```

---

## API Response Schemas

```python
# ALWAYS use Pydantic schemas for responses

# WRONG - manual dict building (inconsistent, error-prone)
return {
    "id": str(item.id),
    "name": item.name,
    ...
}

# CORRECT - schema validation (consistent, typed)
return ItemResponse.model_validate(item)
```

---

## Common Bug Patterns

| Pattern | Symptom | Quick Fix |
|---------|---------|-----------|
| Undefined in params | Filter shows "undefined" | `if (value) params[key] = value` |
| Schema mismatch | Field not saved | Compare Frontend - Backend schema |
| Missing cache invalidation | Stale data displayed | `queryClient.invalidateQueries(['key'])` |
| JSONB scalar vs array | `cannot get array length` | `jsonb_typeof(col) = 'array'` check |
| Missing DB columns | `column X does not exist` | Sync ORM model with DB |
| XSS via error toast | Backend errors exposed | Generic error messages |
| QueryKey object reference | Refetch issues | Flatten: `["key", p1, p2]` |
| Search race condition | API spam | `useDebounce(search, 300)` |
| Dialog overflow | Footer cut off | `max-h-[400px] overflow-y-auto` |
| Division by zero | NaN in calculations | `Number.isFinite()` check |

---

## Validation Patterns

### Pydantic (Backend)

```python
from pydantic import Field, field_validator

class ItemCreate(BaseModel):
    quantity: int = Field(ge=1, le=1000)
    discount: Decimal = Field(ge=0, le=100)

    @field_validator('email')
    @classmethod
    def validate_email(cls, v):
        if not re.match(r'^[\w\.-]+@[\w\.-]+\.\w+$', v):
            raise ValueError('Invalid email')
        return v.lower()
```

### Frontend Input Sanitization

```typescript
// Input sanitization
const sanitizedSearch = search.trim().slice(0, 200);
const sanitizedLimit = Math.min(limit, 300);

// Safe query keys (flattened, no object references)
queryKey: ['items', page, limit, search, categoryId]
```

---

## API Response Patterns

### Pagination

```python
class PaginatedResponse(BaseModel):
    items: list[T]
    total: int
    page: int
    limit: int
    has_more: bool
```

### Error Handling

```python
# Backend - log details, return generic message
try:
    result = process()
except Exception as e:
    logger.error("operation_failed", exc_info=True, extra={"error": str(e)})
    raise HTTPException(500, "Operation failed")
```

```typescript
// Frontend - user-friendly messages
try {
  await mutation.mutateAsync(data);
  toast.success("Saved successfully");
} catch (error) {
  toast.error("Something went wrong. Please try again.");
  // Log details for debugging, not for user
  console.error("Save failed:", error);
}
```

---

## Testing Patterns (pytest)

### MagicMock Gotchas

```python
# WRONG - MagicMock(name="X") names the mock, doesn't set .name attribute!
mock_item = MagicMock(name="Test Item")
mock_item.name  # Returns a new MagicMock, NOT "Test Item"

# CORRECT - set attributes after creation
mock_item = MagicMock()
mock_item.name = "Test Item"
mock_item.id = uuid4()
```

### Optional Fields & Pydantic

```python
# WRONG - optional fields return MagicMock, Pydantic rejects them
mock_obj = MagicMock()
# mock_obj.optional_field is MagicMock, not None

# CORRECT - explicitly set optional fields to None
mock_obj = MagicMock()
mock_obj.optional_field = None
mock_obj.optional_price = None
```

### Patch Location (Critical!)

```python
# WRONG - patching where defined
@patch("app.models.item.Item")

# CORRECT - patching where imported (in the module under test)
@patch("app.api.routes.items.Item")
```

### AsyncMock for Class Methods

```python
# WRONG - return_value doesn't work for class methods
MockService = MagicMock()
MockService.return_value.fetch.return_value = data

# CORRECT - set method directly as AsyncMock
MockService = MagicMock()
MockService.fetch = AsyncMock(return_value=data)
```

### Properties Need Explicit Values

```python
# WRONG - MagicMock property returns MagicMock (truthy!)
mock_settings = MagicMock()
mock_settings.is_production  # Returns MagicMock, evaluates to True

# CORRECT - explicitly set property value
mock_settings = MagicMock()
mock_settings.is_production = False
```

### Global State Reset

```python
# If module has global state, reset between tests
import app.api.routes.my_module as module

@pytest.fixture(autouse=True)
def reset_state():
    module._initialized = False
    yield
```

---

## File Location Guide

### Wo gehoert mein Code hin?

| Ich will... | Backend Pfad | Frontend Pfad |
|-------------|--------------|---------------|
| Neuen API Endpoint | `/api/routes/{feature}.py` | - |
| Business Logic | `/services/{feature}_service.py` | - |
| DB Model | `/models/{entity}.py` | - |
| Request/Response Schema | `/schemas/{entity}.py` | - |
| Neue Page | - | `/pages/{Feature}Page.tsx` |
| UI Component | - | `/components/{feature}/` |
| React Hook | - | `/hooks/use{Feature}.ts` |
| TypeScript Interface | - | `/types/{feature}.ts` |
| API Client Function | - | `/lib/api.ts` |
| Globale Konstante | `/core/constants.py` | `/lib/constants.ts` |

### WICHTIG: Business Logic NIEMALS in Routes!

```python
# WRONG - Logic in Route
@router.post("/items")
async def create_item(data, db):
    # 50 Zeilen Business Logic hier...
    item.calculated_value = item.amount * item.factor / 100
    # etc.

# CORRECT - Logic in Service
@router.post("/items")
async def create_item(data, db):
    return await item_service.create(db, data)

# In item_service.py:
async def create(db, data):
    # Business Logic hier
```

---

## Immutability

**ALWAYS create new objects, NEVER mutate:**

```typescript
// WRONG
user.name = "New Name";
return user;

// CORRECT
return { ...user, name: "New Name" };
```

```python
# WRONG
data["key"] = value

# CORRECT
return {**data, "key": value}
```

---

*Template for Claude Code Starter Kit*
