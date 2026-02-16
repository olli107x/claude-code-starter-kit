# Systematic Debugging Methodology

> "Debugging is the process of observing a system, forming hypotheses, and testing them until you understand what is actually happening."
> -- Alan Knox

---

## Table of Contents

1. [Core Philosophy](#core-philosophy)
2. [The 5-Step Debug Protocol](#the-5-step-debug-protocol)
3. [Hypothesis-Driven Debugging](#hypothesis-driven-debugging)
4. [Data Flow Analysis](#data-flow-analysis)
5. [Common Bug Patterns](#common-bug-patterns)
6. [Tools & Techniques](#tools--techniques)
7. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
8. [Debugging Checklist](#debugging-checklist)

---

## Core Philosophy

### What Debugging IS

- **Systematic investigation** - methodical examination of system behavior
- **Hypothesis testing** - forming theories and validating them with evidence
- **Root cause analysis** - finding the actual source, not just symptoms
- **Understanding** - knowing WHY something happens, not just WHAT

### What Debugging is NOT

- **Guessing** - randomly changing code hoping it fixes the issue
- **Trial and error** - making changes without understanding their impact
- **Symptom fixing** - hiding problems with quick patches
- **Blame shifting** - assuming the problem is elsewhere without evidence

### The Golden Rule

> **"Never propose a fix until you can explain WHY the bug exists."**

---

## The 5-Step Debug Protocol

### Step 1: REPRODUCE

**Goal:** Create reliable conditions where the bug occurs consistently.

**Actions:**
- Document exact steps to trigger the bug
- Identify inputs, state, and environment conditions
- Create a minimal reproduction case
- Note: If you can't reproduce it, you can't fix it with confidence

**Questions to ask:**
- When does this happen? (always, sometimes, specific conditions?)
- What are the exact inputs?
- What is the expected output vs actual output?
- Has this ever worked correctly?

### Step 2: ISOLATE

**Goal:** Narrow down where the bug lives.

**Actions:**
- Trace the data flow from input to output
- Identify which component produces wrong results
- Disable non-essential parts to simplify
- Use binary search: check halfway points

**Techniques:**
```
Full System: A -> B -> C -> D -> E
                    |
Check C: Is output correct here?
   Yes -> Bug is in D or E
   No  -> Bug is in A, B, or C
```

### Step 3: INSPECT

**Goal:** Examine the actual state at the point of failure.

**Actions:**
- Log or print values at critical points
- Check database contents directly
- Inspect API request/response payloads
- Verify assumptions about data format

**What to inspect:**
- Input values (are they what you expect?)
- Intermediate calculations (where do they go wrong?)
- Data types (string vs number, null vs undefined)
- Edge cases (empty arrays, zero values, null)

### Step 4: HYPOTHESIZE

**Goal:** Form specific, testable theories about the cause.

**Actions:**
- Based on inspection, formulate hypotheses
- Each hypothesis should be falsifiable
- Prioritize by likelihood and ease of testing
- Write down your hypotheses explicitly

**Hypothesis format:**
```
H1: [Specific statement about what's wrong]
    Test: [How to verify this]
    Expected if true: [What you'd observe]
```

### Step 5: VERIFY

**Goal:** Confirm the root cause before implementing a fix.

**Actions:**
- Test your hypothesis with minimal changes
- If wrong, return to Step 3 with new information
- Once confirmed, implement the fix
- Verify the fix actually resolves the issue
- Check for regressions

---

## Hypothesis-Driven Debugging

### The Hypothesis Table

| # | Hypothesis | How to Test | Result |
|---|------------|-------------|--------|
| H1 | [Theory 1] | [Test method] | pass/fail |
| H2 | [Theory 2] | [Test method] | pass/fail |
| H3 | [Theory 3] | [Test method] | pass/fail |

### Common Hypothesis Categories

1. **Data Format Issues**
   - Wrong data type (string vs number)
   - Unexpected null/undefined values
   - Different decimal format (0.0369 vs 3.69%)

2. **Aggregation Errors**
   - Double counting
   - Missing data
   - Wrong grouping

3. **Timing Issues**
   - Race conditions
   - Stale cache
   - Async operations completing in wrong order

4. **Integration Mismatches**
   - API contract changes
   - Different assumptions between systems
   - Version mismatches

---

## Data Flow Analysis

### Mapping the Pipeline

For any bug, map the complete data flow:

```
+-------------+    +-------------+    +-------------+    +-------------+
|   Source     | -> |  Transform  | -> |   Store     | -> |  Display    |
|  (API/User)  |    |  (Backend)  |    |    (DB)     |    | (Frontend)  |
+-------------+    +-------------+    +-------------+    +-------------+
       |                  |                  |                  |
   Check here         Check here         Check here         Check here
```

### At Each Stage, Ask:

1. **What data enters?** (format, values)
2. **What transformation happens?** (calculation, mapping)
3. **What data exits?** (format, values)
4. **Does output match expectation?**

### Example: Percentage Calculation Bug

```
External API          Backend Service       Database            Frontend
------------          ---------------       --------            --------
rate: 0.0250    ->    Stored as-is     ->   rate: 0.0250    ->  Display: ???
rate: 0.0144                                rate: 0.0144

Expected: 3.94% (sum of rates)
Actual: ???

Question: Where does the calculation go wrong?
```

---

## Common Bug Patterns

### Pattern 1: Double Counting

**Symptom:** Values are ~2x larger or ~0.5x smaller than expected

**Example:**
```sql
-- WRONG: shared value counted per row
SELECT SUM(total_views) FROM item_details
-- If 2 rows share same views (36725), returns 73450

-- CORRECT: Use MAX or distinct
SELECT MAX(total_views) FROM item_details
```

### Pattern 2: Unit Mismatch

**Symptom:** Values off by factor of 100 or 1000

**Example:**
```javascript
// API returns decimal (0.0369 = 3.69%)
// Frontend displays without conversion
value={`${rate.toFixed(2)}%`}  // Shows 0.04%

// CORRECT:
value={`${(rate * 100).toFixed(2)}%`}  // Shows 3.69%
```

### Pattern 3: Wrong Aggregation Level

**Symptom:** Totals don't match sum of parts

**Example:**
```python
# WRONG: Average of averages
avg_rate = sum(daily_rates) / len(days)  # Not weighted

# CORRECT: Weighted average
avg_rate = total_clicks / total_impressions
```

### Pattern 4: Null/Undefined Handling

**Symptom:** NaN, undefined, or unexpected zeros

**Example:**
```javascript
// WRONG: Doesn't handle null
const result = data.value.toFixed(2);  // Crashes if null

// CORRECT: With null check
const result = (data.value ?? 0).toFixed(2);
```

### Pattern 5: Async Race Condition

**Symptom:** Works sometimes, fails other times

**Example:**
```javascript
// WRONG: No guarantee of order
fetchData();
displayData();  // May run before fetch completes

// CORRECT: Wait for async
await fetchData();
displayData();
```

---

## Tools & Techniques

### Backend Debugging

1. **SQL Query Testing**
   ```sql
   -- Test your query directly in DB
   SELECT date, SUM(clicks), SUM(opens)
   FROM [your_table]
   WHERE date = '2026-01-06'
   GROUP BY date;
   ```

2. **Structured Logging**
   ```python
   logger.info("calculation_step",
       input_value=x,
       output_value=y,
       expected=z)
   ```

3. **API Response Inspection**
   - Use browser DevTools Network tab
   - Check exact JSON returned

### Frontend Debugging

1. **Console Logging**
   ```javascript
   console.log('Before transform:', rawData);
   console.log('After transform:', processedData);
   ```

2. **React DevTools**
   - Inspect component props and state
   - Track re-renders

3. **Network Tab**
   - Verify API responses
   - Check request payloads

### Database Debugging

1. **Direct Queries**
   - Verify data exists as expected
   - Check for duplicates
   - Validate constraints

2. **Data Comparison**
   ```sql
   -- Compare expected vs actual
   SELECT
       calculated_value,
       expected_value,
       calculated_value - expected_value as difference
   FROM ...
   ```

---

## Anti-Patterns to Avoid

### 1. "Shotgun Debugging"
Making multiple random changes hoping one fixes it.

**Why it's bad:** You won't know what actually fixed it, may introduce new bugs.

### 2. "Works on My Machine"
Dismissing bugs because you can't reproduce locally.

**Why it's bad:** Environment differences are real; investigate them.

### 3. "Quick Fix" Mentality
Patching symptoms without understanding root cause.

**Why it's bad:** Bug will return or cause related issues.

### 4. "Blame the Framework"
Assuming the bug is in external code without evidence.

**Why it's bad:** Wastes time; your code is statistically more likely to be wrong.

### 5. "It's Too Complex to Debug"
Giving up because the system is complicated.

**Why it's bad:** Every bug can be isolated with systematic approach.

---

## Debugging Checklist

### Before Starting

- [ ] Can I reliably reproduce the bug?
- [ ] Do I understand expected vs actual behavior?
- [ ] Have I documented the exact steps?

### During Investigation

- [ ] Have I traced the complete data flow?
- [ ] Have I inspected actual values at each stage?
- [ ] Have I formed specific, testable hypotheses?
- [ ] Am I testing ONE thing at a time?

### Before Fixing

- [ ] Do I understand WHY the bug exists?
- [ ] Can I explain the root cause to someone else?
- [ ] Is my fix addressing the root cause, not symptoms?

### After Fixing

- [ ] Does the original bug scenario now work?
- [ ] Have I tested related functionality for regressions?
- [ ] Have I documented what was wrong and why?

---

## Real-World Example: Percentage Calculation Bug

### The Bug
A calculated rate showed 3.25% instead of expected 3.94%

### Step 1: REPRODUCE
- Date: 2026-01-06
- Two data rows with rates 2.5% and 1.44%
- Expected sum: 3.94%
- Actual display: 3.25%

### Step 2: ISOLATE
Data flow: `DB -> Backend Service -> API -> Frontend`

Check at each point:
- DB: Stores 0.025 and 0.0144 correctly
- Backend: ? Need to check aggregation
- API: ? Need to check response
- Frontend: ? Need to check display

### Step 3: INSPECT
Backend SQL query:
```sql
SELECT
    SUM(clicks) as clicks,      -- 1447 (correct)
    SUM(total_views) as views,   -- 73450 (should be 36725!)
FROM detail_data
WHERE date = '2026-01-06'
```

**Finding:** Views are doubled because each row stores the same shared value.

### Step 4: HYPOTHESIZE

| # | Hypothesis | Test | Result |
|---|------------|------|--------|
| H1 | Views double-counted | Check SUM vs MAX | CONFIRMED |
| H2 | Rate calculation wrong | Check formula | Related to H1 |

### Step 5: VERIFY

**Root Cause:** `SUM(total_views)` counts same views multiple times.

**Fix:** Use `SUM(rate) * 100` instead of `clicks/views * 100`

**Result:**
- Before: 1447/73450 * 100 = 1.97%
- After: (0.025 + 0.0144) * 100 = 3.94%

---

## Summary

1. **Never guess** - always investigate systematically
2. **Reproduce first** - if you can't reproduce, you can't fix with confidence
3. **Trace data flow** - bugs hide at boundaries between systems
4. **Form hypotheses** - make your theories explicit and testable
5. **Verify root cause** - understand WHY before implementing fix
6. **One change at a time** - multiple changes obscure what actually worked

---

*Based on "Debugging Engineering for Vibe Coders" by Alan Knox*
*Template for Claude Code Starter Kit*
