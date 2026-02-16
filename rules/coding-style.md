# Coding Style Rules

> **ALWAYS FOLLOW**: Immutability, small files, clean code.

---

## Immutability (CRITICAL)

**ALWAYS create new objects, NEVER mutate:**

### WRONG:
```typescript
user.name = "New Name";  // MUTATION!
return user;
```

### CORRECT:
```typescript
return { ...user, name: "New Name" };  // NEW OBJECT
```

### Python:
```python
# WRONG
data["key"] = value  # Mutating dict

# CORRECT
return {**data, "key": value}  # New dict
```

---

## File Organization

**MANY SMALL FILES > FEW LARGE FILES**

| Metric | Target | Max |
|--------|--------|-----|
| File size | 200-400 lines | 800 lines |
| Function size | 20-30 lines | 50 lines |
| Nesting depth | 2-3 levels | 4 levels |

### Organization by Feature, NOT by Type

```
# GOOD
/features/
  /users/
    UserCard.tsx
    UserForm.tsx
    useUser.ts
    users.api.ts

# BAD
/components/UserCard.tsx
/hooks/useUser.ts
/api/users.ts
```

---

## Naming Conventions

### TypeScript/React
```typescript
// Components: PascalCase
function UserCard() {}

// Hooks: camelCase with "use" prefix
function useUserData() {}

// Utils: camelCase
function formatCurrency() {}

// Constants: UPPER_SNAKE_CASE
const MAX_RETRIES = 3;

// Types: PascalCase
interface UserResponse {}
type UserStatus = 'active' | 'inactive';
```

### Python
```python
# Classes: PascalCase
class UserService:

# Functions: snake_case
def get_user_by_id():

# Constants: UPPER_SNAKE_CASE
MAX_RETRIES = 3

# Variables: snake_case
user_count = 0
```

---

## Quality Checklist

Before completing any task:

- [ ] Readable code with descriptive names
- [ ] Functions under 50 lines
- [ ] Files under 800 lines
- [ ] Max nesting depth of 4
- [ ] Comprehensive error handling
- [ ] No debug statements (console.log, print)
- [ ] No hardcoded values (use constants/env)
- [ ] Immutable patterns followed

---

## Useful Patterns

### Money: Always `Decimal`
```python
from decimal import Decimal
price = Decimal("99.99")  # NOT float!
```

### API Params: No undefined
```typescript
// GOOD
if (value) params.key = value;

// BAD
params.key = value;  // Could be undefined
```

### React Query: Always placeholderData
```typescript
const { data } = useQuery({
  queryKey: ['items'],
  queryFn: fetchItems,
  placeholderData: [],  // REQUIRED
});
```
