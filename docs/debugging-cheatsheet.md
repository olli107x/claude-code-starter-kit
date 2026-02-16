# Debugging Cheatsheet

> Quick reference for systematic debugging

---

## The 5 Steps

```
1. REPRODUCE  -> Can I trigger this bug reliably?
2. ISOLATE    -> Where in the data flow does it break?
3. INSPECT    -> What are the actual values at that point?
4. HYPOTHESIZE -> What specific theory explains this?
5. VERIFY     -> Does my theory hold? Does my fix work?
```

---

## Questions to Ask

| Step | Questions |
|------|-----------|
| REPRODUCE | What are exact inputs? When does it happen? |
| ISOLATE | Where does data flow? Where does it go wrong? |
| INSPECT | What's the actual value? What type is it? |
| HYPOTHESIZE | What could cause this? How do I test it? |
| VERIFY | Does fix work? Any regressions? |

---

## Common Bug Patterns

### 1. Double Counting
```sql
-- WRONG: Counts shared value multiple times
SELECT SUM(shared_metric) FROM detail_table

-- FIX: Use MAX for shared values
SELECT MAX(shared_metric) FROM detail_table
```

### 2. Unit Mismatch
```javascript
// WRONG: API returns decimal (0.0369)
value={`${rate.toFixed(2)}%`}  // Shows 0.04%

// FIX: Convert to percentage
value={`${(rate * 100).toFixed(2)}%`}  // Shows 3.69%
```

### 3. Null/Undefined
```javascript
// WRONG: Crashes on null
data.value.toFixed(2)

// FIX: Null coalescing
(data.value ?? 0).toFixed(2)
```

### 4. Wrong Aggregation
```python
# WRONG: Average of averages
avg = sum(daily_avgs) / len(days)

# FIX: Weighted average
avg = total_clicks / total_impressions
```

### 5. Division by Zero
```python
# WRONG: Can crash
result = a / b

# FIX: Guard clause
result = a / b if b != 0 else 0
```

### 6. Race Condition
```javascript
// WRONG: No guarantee of order
fetchData();
displayData();  // May run before fetch completes

// FIX: Await async operations
await fetchData();
displayData();
```

---

## Inspection Commands

### Database
```sql
-- Check raw data
SELECT * FROM [your_table] WHERE date = '2026-01-06';

-- Check aggregation
SELECT
    date,
    SUM(clicks),
    MAX(views),  -- Not SUM for shared values!
    SUM(rate) * 100 as rate_percent
FROM [your_table]
GROUP BY date;

-- Check for duplicates
SELECT column, COUNT(*) as cnt
FROM [your_table]
GROUP BY column
HAVING COUNT(*) > 1;
```

### Backend (Python)
```python
logger.info("debug_checkpoint",
    input=x,
    output=y,
    expected=z,
    diff=y-z)
```

### Frontend (JS/TS)
```javascript
console.log('Before:', rawData);
console.log('After:', processedData);
console.log('Expected:', expectedValue);
```

### API Testing
```bash
# Quick endpoint test
curl -s http://localhost:8000/api/[your-endpoint] | jq .

# With auth header
curl -s -H "Authorization: Bearer $TOKEN" \
  http://localhost:8000/api/[your-endpoint] | jq .
```

### Logs
```bash
# Tail application logs
tail -f logs/app.log

# Search for errors
grep -i "error\|exception\|traceback" logs/app.log

# [YOUR_HOSTING_PLATFORM] logs
# e.g.: railway logs, heroku logs --tail, etc.
```

---

## Hypothesis Table Template

| # | Hypothesis | Test | Expected | Result |
|---|------------|------|----------|--------|
| H1 | Values double-counted | Check SUM vs MAX | Halved value | pass/fail |
| H2 | Unit mismatch | Check raw vs displayed | Off by 100x | pass/fail |
| H3 | Data missing | Check DB directly | Fewer rows | pass/fail |
| H4 | Race condition | Add logging with timestamps | Out-of-order | pass/fail |
| H5 | Null not handled | Check for null inputs | Crash/NaN | pass/fail |

---

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Random changes | One change at a time |
| Fix symptoms | Fix root cause |
| Assume framework bug | Verify your code first |
| Give up on complex | Isolate until simple |
| Multiple fixes at once | Single fix, verify, repeat |
| Ignore error messages | Read them carefully |

---

## Debug Report Template

```markdown
## Bug: [Short description]

### Expected vs Actual
- Expected: [value]
- Actual: [value]

### Root Cause
[WHY this happens]

### Evidence
[SQL/logs proving the cause]

### Fix
[Code change + explanation]

### Verification
[How we confirmed it works]

### Regression Check
[Related functionality tested]
```

---

## Environment Debugging

### Check environment variables
```bash
# Verify required env vars are set
echo $DATABASE_URL    # Should not be empty
echo $API_KEY         # Should not be empty

# Check for typos in env var names
env | grep -i "[your_prefix]"
```

### Check connectivity
```bash
# Database
pg_isready -h [host] -p [port]

# External API
curl -s -o /dev/null -w "%{http_code}" https://[api-url]/health

# Redis (if applicable)
redis-cli ping
```

### Check resource usage
```bash
# Disk space
df -h

# Memory
free -m

# Running processes
ps aux | grep [your_app]
```

---

*"Never propose a fix until you can explain WHY the bug exists."*

*Template for Claude Code Starter Kit*
