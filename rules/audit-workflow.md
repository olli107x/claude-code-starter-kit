# Audit Workflow Orchestration

> **TRIGGER:** Automatisch nach Plan-Umsetzung, vor wichtigen Commits, oder manuell via `/audit`

---

## Trigger-Regeln

| Trigger | Aktion |
|---------|--------|
| Plan-Umsetzung abgeschlossen | Automatisch alle 4 Audits |
| Vor wichtigem Commit | Bug + Security Audit |
| `/audit` | Alle 4 Audits |
| `/audit-bug` | Nur Bug Audit |
| `/audit-security` | Nur Security Audit |
| `/audit-test` | Nur Test Audit |
| `/audit-verify` | Nur Plan Verification |

---

## Audit Execution Flow

```
+-----------------------------------------------------+
|  PARALLEL AUDIT EXECUTION                           |
+-----------------------------------------------------+
|  +----------+  +----------+  +----------+           |
|  |Bug Audit |  |Security  |  |Test Audit|           |
|  |          |  |Audit     |  |          |           |
|  +----+-----+  +----+-----+  +----+-----+           |
|       |             |             |                  |
|       +-------------+-------------+                  |
|                     |                                |
|              WAIT FOR ALL                            |
|                     |                                |
|       +-------------+-------------+                  |
|       |    Plan Verification      |                  |
|       |    (Sequential - Last)    |                  |
|       +-------------+-------------+                  |
|                     |                                |
|              FINAL REPORT                            |
+-----------------------------------------------------+
```

**WICHTIG:** Plan Verification MUSS nach den anderen Audits laufen, da es deren Ergebnisse benoetigt.

---

## Scope Definition

### Changed Files Detection

```bash
# Via git diff (bevorzugt)
git diff --name-only HEAD~1

# Oder via Plan-Dateiliste
# Alle in Plan genannten Dateien + Dependencies
```

### Scope Erweiterung

| Typ | Beschreibung |
|-----|--------------|
| **Direct** | Direkt geaenderte Dateien |
| **Dependencies** | Dateien die geaenderte Dateien importieren |
| **Reverse Deps** | Dateien die von geaenderten importiert werden |

### Scope Berechnung

```python
scope = {
    "direct": get_changed_files(),
    "dependencies": get_importers(direct),
    "reverse_deps": get_imports(direct)
}
```

---

## Blocking Rules

| Severity | Icon | Action | Beispiele |
|----------|------|--------|-----------|
| **CRITICAL** | CRIT | Hard Block - MUSS gefixt werden | Hardcoded Secrets, SQL Injection |
| **HIGH** | HIGH | Hard Block - MUSS gefixt werden | Missing Auth, XSS, Unhandled Exceptions |
| **MEDIUM** | MED | Warning - Sollte gefixt werden | Missing Tests, CORS Issues |
| **LOW** | LOW | Info - Optional | Code Style, Minor Improvements |

### Blocking Logik

```
IF any CRITICAL or HIGH issues:
    BLOCK commit/merge
    REQUIRE fixes before proceeding
ELSE IF any MEDIUM issues:
    WARN but allow proceed with acknowledgment
ELSE:
    PASS - all clear
```

---

## Agent & Skill Zuordnung

### Parallel Agents (Phase 1)

| Audit | Agent | Skill |
|-------|-------|-------|
| Bug | `debugger`, `brutal-critic` | `/systematic-debugging` |
| Security | `security-reviewer` | `/review` |
| Test | `qa-engineer`, `api-tester` | `/test-fixing`, `/verification-before-completion` |

### Sequential Agent (Phase 2)

| Audit | Agent | Skill |
|-------|-------|-------|
| Plan Verify | `explorer` | `/verification-before-completion` |

---

## Output

### Report Location

```
docs/audits/audit-YYYY-MM-DD-HHMMSS.md
```

### Report Template

```markdown
# Audit Report: {Feature/Plan Name}

**Datum:** {timestamp}
**Plan:** {link to original plan}
**Scope:** {n} Dateien + {m} Dependencies

---

## Summary

| Audit | Status | CRITICAL | HIGH | MEDIUM | LOW |
|-------|--------|----------|------|--------|-----|
| Bug | pass/fail | 0 | 0 | 0 | 0 |
| Security | pass/fail | 0 | 0 | 0 | 0 |
| Test | pass/fail | 0 | 0 | 0 | 0 |
| Plan Verify | pass/fail | - | - | - | - |

**Overall:** PASSED / BLOCKED

---

## Bug Audit Results
{details}

## Security Audit Results
{details}

## Test Audit Results
{details}

## Plan Verification Results
{details}

---

## Required Actions
{list of items that must be fixed before proceeding}

## Recommendations
{optional improvements}
```

### PROGRESS.md Update

Nach jedem Audit automatisch hinzufuegen:

```markdown
## Last Audit

**Date:** {timestamp}
**Feature:** {name}
**Result:** PASSED / BLOCKED ({n} issues)
**Report:** [docs/audits/audit-{timestamp}.md](link)
```

---

## Quick Commands

```bash
/audit              # Full audit (all 4)
/audit-bug          # Bug audit only
/audit-security     # Security audit only
/audit-test         # Test audit only
/audit-verify       # Plan verification only
```

---

## Related Rules

- `audit-bug.md` - Bug Audit Details
- `audit-security.md` - Security Audit Details
- `audit-test.md` - Test Audit Details
- `audit-plan-verification.md` - Plan Verification Details
