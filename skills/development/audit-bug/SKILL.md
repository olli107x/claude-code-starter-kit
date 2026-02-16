---
name: audit-bug
description: Bug audit checklist. Scans for exception handling issues, null safety, async problems, logic errors, resource leaks, and missing UI states. Uses debugger and brutal-critic agents.
allowed-tools: Bash,Read,Glob,Grep,Task
---

# Bug Audit Guidelines

> **TRIGGER:** Teil des Full Audits oder manuell via `/audit-bug`

---

## Agents & Skills

| Tool | Zweck |
|------|-------|
| `debugger` Agent | Systematische Bug-Suche mit Hypothesen |
| `brutal-critic` Agent | Code-Roast fuer versteckte Bugs |
| `/systematic-debugging` Skill | Hypothesen-basierte Analyse |

---

## Pruefpunkte Checkliste

### Exception Handling

- [ ] Keine unbehandelten Exceptions
- [ ] Spezifische Exception-Typen (nicht bare `except:`)
- [ ] Sinnvolle Error Messages
- [ ] Error Propagation korrekt

### Null/Undefined Safety

- [ ] Keine Null/Undefined Zugriffe
- [ ] Optional Chaining wo noetig (`?.`)
- [ ] Default Values gesetzt
- [ ] Nullable Types korrekt annotiert

### Async/Concurrency

- [ ] Keine Race Conditions
- [ ] Alle async-Funktionen mit await
- [ ] Promise Chains mit .catch()
- [ ] Keine deadlock-anfaelligen Patterns

### Logic & Calculations

- [ ] Keine falschen Berechnungen
- [ ] Division mit Zero-Check
- [ ] Off-by-one Errors geprueft
- [ ] Boundary Conditions korrekt

### Resource Management

- [ ] Keine Memory Leaks
- [ ] Keine Endlosschleifen moeglich
- [ ] Resources werden freigegeben
- [ ] Event Listeners werden entfernt

### UI States

- [ ] Error States implementiert
- [ ] Loading States implementiert
- [ ] Empty States implementiert
- [ ] Success Feedback vorhanden

### Edge Cases

- [ ] Empty Input getestet
- [ ] Max Length/Size getestet
- [ ] Special Characters getestet
- [ ] Unicode/i18n getestet

---

## Bug Pattern Suche

### Python Anti-Patterns

```python
# CRITICAL: Bare except
try:
    risky_operation()
except:  # WRONG - catches everything
    pass

# CORRECT: Specific exception
try:
    risky_operation()
except ValueError as e:
    logger.error(f"Value error: {e}")

# ---

# HIGH: .get() ohne default
value = dict.get("key")  # Returns None silently

# CORRECT: Explicit default
value = dict.get("key", "default_value")

# ---

# HIGH: async ohne await
async def fetch_data():
    some_async_function()  # WRONG - not awaited

# CORRECT
async def fetch_data():
    await some_async_function()

# ---

# MEDIUM: Division ohne Zero-Check
result = a / b  # Could crash

# CORRECT
result = a / b if b != 0 else 0
```

### TypeScript/React Anti-Patterns

```typescript
// CRITICAL: Unhandled Promise rejection
fetchData().then(setData);  // No error handling

// CORRECT
fetchData()
  .then(setData)
  .catch(error => setError(error.message));

// ---

// HIGH: Array access ohne bounds check
const item = items[index];  // Could be undefined

// CORRECT
const item = items[index] ?? defaultItem;

// ---

// HIGH: Object property ohne null check
const name = user.profile.name;  // Crashes if null

// CORRECT
const name = user?.profile?.name ?? "Unknown";

// ---

// MEDIUM: useEffect ohne cleanup
useEffect(() => {
  const interval = setInterval(tick, 1000);
  // No cleanup - memory leak
}, []);

// CORRECT
useEffect(() => {
  const interval = setInterval(tick, 1000);
  return () => clearInterval(interval);
}, []);
```

---

## Severity Mapping

| Finding | Severity | Beschreibung |
|---------|----------|--------------|
| Unhandled Exception in critical path | CRITICAL | App kann crashen |
| Race Condition | CRITICAL | Data corruption moeglich |
| Memory Leak | HIGH | Performance degradation |
| Missing null check | HIGH | Runtime errors |
| Missing error state | MEDIUM | Bad UX |
| Off-by-one error | MEDIUM | Subtle data issues |
| Console.log vergessen | LOW | Debug noise |
| Suboptimale Performance | LOW | Minor improvement |

---

## Automated Checks

### Python (via pytest)

```bash
# Run with coverage und verbose output
pytest -v --tb=short

# Check fuer common issues
pylint src/ --errors-only
mypy src/ --strict
```

### TypeScript (via ESLint/Vitest)

```bash
# Type checking
npx tsc --noEmit

# Lint fuer bugs
npm run lint

# Tests
npm test
```

---

## Report Format

```markdown
## Bug Audit Results

### CRITICAL (0)
{none found}

### HIGH (2)
1. **Missing error handling in `useItems.ts:45`**
   - Pattern: Promise without .catch()
   - Fix: Add error handling to fetchItems call

2. **Potential null access in `ItemCard.tsx:23`**
   - Pattern: `item.owner.name` without null check
   - Fix: Use optional chaining `item?.owner?.name`

### MEDIUM (1)
1. **Missing loading state in `ItemsPage.tsx`**
   - Impact: Users see empty screen during load
   - Fix: Add loading spinner

### LOW (0)
{none found}
```

---

## Integration with Other Audits

- **Security Audit:** Bugs koennen Security-Implications haben
- **Test Audit:** Fehlende Tests = potentielle Bugs
- **Plan Verification:** Bug-freie Implementation = Plan erfuellt
