# Plan Verification Audit Guidelines

> **TRIGGER:** Letzter Schritt im Full Audit, nach Bug/Security/Test Audits

---

## Agents & Skills

| Tool | Zweck |
|------|-------|
| `explorer` Agent | Code-Existenz pruefen |
| `/verification-before-completion` Skill | Finale Verifikation |

---

## Ablauf

```
1. Original Plan laden
2. Jedes Plan-Item pruefen:
   - Code existiert?
   - Tests existieren?
   - Docs aktualisiert?
3. Definition of Done Checkliste
4. Ergebnisse der anderen Audits einbeziehen
5. Final Verdict
```

**WICHTIG:** Plan Verification laeuft NACH Bug/Security/Test Audits, da deren Ergebnisse relevant sind.

---

## Pruefpunkte Checkliste

### 1. Implementation Check

Fuer jeden Punkt im Plan:

- [ ] Entsprechender Code wurde geschrieben
- [ ] Alle genannten Dateien wurden erstellt/geaendert
- [ ] Keine `// TODO: Plan Item X` Kommentare uebrig
- [ ] Feature funktioniert wie im Plan beschrieben
- [ ] Keine Placeholder oder Mock-Implementierungen

```typescript
// NOT DONE - Placeholder
export function calculateDiscount(amount: number) {
  // TODO: Implement discount logic from Plan Step 3
  return 0;
}

// DONE - Actual implementation
export function calculateDiscount(amount: number, discountPercent: number) {
  return amount * (discountPercent / 100);
}
```

### 2. Test Check

- [ ] Tests fuer jeden Plan-Punkt existieren
- [ ] Alle Tests sind gruen (aus Test Audit)
- [ ] Edge Cases aus Plan sind getestet
- [ ] Coverage Requirements erfuellt (aus Test Audit)

### 3. Documentation Check

- [ ] API-Aenderungen in docs/ dokumentiert
- [ ] TypeScript Types sind vollstaendig
- [ ] PROGRESS.md aktualisiert
- [ ] Relevante docs/ Files aktualisiert
- [ ] README/CLAUDE.md bei Bedarf aktualisiert
- [ ] Inline-Kommentare wo noetig

### 4. Definition of Done (Full)

#### Code Quality
- [ ] Code reviewed (oder self-review durchgefuehrt)
- [ ] Keine console.log / print() im Code
- [ ] Keine hardcoded Test-Werte
- [ ] Error States implementiert
- [ ] Loading States implementiert
- [ ] TypeScript Types vollstaendig

#### Testing
- [ ] Tests geschrieben (min. Happy Path + Error Case)
- [ ] `npm test` passed
- [ ] `pytest` passed
- [ ] Coverage >= 80% fuer neue Features

#### Security (aus Security Audit)
- [ ] Keine hardcoded Secrets
- [ ] Input Validation vorhanden
- [ ] Auth-Checks auf neuen Endpoints

#### UX
- [ ] Feature manuell getestet
- [ ] Mobile-Responsive (wenn UI)
- [ ] Accessibility basics (wenn UI)

---

## Verification Matrix

Erstelle fuer jeden Plan-Punkt:

```markdown
| Plan Item | Code | Tests | Docs | Status |
|-----------|------|-------|------|--------|
| Add item filtering | DONE | DONE | DONE | DONE |
| Update API endpoint | DONE | FAIL | DONE | PARTIAL |
| Add validation | DONE | DONE | FAIL | PARTIAL |
| Implement webhooks | FAIL | FAIL | FAIL | NOT DONE |
```

---

## Cross-Reference mit anderen Audits

### Bug Audit Ergebnisse

- CRITICAL/HIGH Bugs = Plan nicht erfuellt
- Bugs in Plan-relevanten Dateien pruefen

### Security Audit Ergebnisse

- Security Issues in neuen Endpoints = Plan nicht erfuellt
- Auth-Checks muessen vorhanden sein

### Test Audit Ergebnisse

- Failing Tests = Plan nicht erfuellt
- Missing Tests fuer Plan-Items = Nacharbeiten

---

## Final Verdict Logik

```
IF alle Plan-Items = DONE
   AND Bug Audit = PASSED (keine CRITICAL/HIGH)
   AND Security Audit = PASSED (keine CRITICAL/HIGH)
   AND Test Audit = PASSED (alle Tests gruen, Coverage ok)
THEN:
   Plan Verification = PASSED
ELSE:
   Plan Verification = FAILED
   List remaining items
```

---

## Severity Mapping

| Finding | Severity | Action |
|---------|----------|--------|
| Plan item not implemented | CRITICAL | Must implement |
| Plan item partially done | HIGH | Must complete |
| Missing tests for plan item | HIGH | Must add tests |
| Missing documentation | MEDIUM | Should add |
| Minor deviation from plan | LOW | Acceptable if justified |

---

## Report Format

```markdown
## Plan Verification Results

### Plan: {Plan Name/Link}
### Status: INCOMPLETE

---

### Plan Items Verification

| # | Plan Item | Code | Tests | Docs | Status |
|---|-----------|------|-------|------|--------|
| 1 | Add item filtering | DONE | DONE | DONE | DONE |
| 2 | Create filter dropdown UI | DONE | DONE | - | DONE |
| 3 | Add keyboard shortcuts | FAIL | FAIL | FAIL | NOT DONE |
| 4 | Update API documentation | - | - | FAIL | PARTIAL |

### Summary
- **Completed:** 2/4 items (50%)
- **Partial:** 1/4 items
- **Not Done:** 1/4 items

---

### Integration with Other Audits

| Audit | Relevant Findings | Impact |
|-------|-------------------|--------|
| Bug | No critical bugs in plan scope | PASS |
| Security | Missing auth on new endpoint | BLOCKS |
| Test | 2 missing tests for plan items | BLOCKS |

---

### Required Actions Before Completion

1. **CRITICAL:** Implement keyboard shortcuts (Plan Item 3)
2. **HIGH:** Add auth check to `/api/items/filter` endpoint
3. **HIGH:** Write tests for `FilterDropdown` component
4. **MEDIUM:** Update API documentation

---

### Definition of Done Status

- [x] Code Quality checks passed
- [ ] All tests passing (2 missing)
- [ ] Security checks passed (1 issue)
- [x] Manual testing done
- [ ] Documentation complete
```

---

## Manual Testing Checklist

Vor Final Verdict, manuell pruefen:

```markdown
### Manual Testing Results

**Feature:** {Feature Name}
**Tested By:** {Name}
**Date:** {Date}

#### Test Scenarios

| Scenario | Expected | Actual | Status |
|----------|----------|--------|--------|
| Create new item | Form opens, saves | As expected | PASS |
| Filter by category | Only matching shown | As expected | PASS |
| Empty filter result | "No items" message | Shows blank | FAIL |
| Mobile responsive | Usable on phone | Layout breaks | FAIL |

#### Issues Found
1. Empty state not showing message
2. Mobile layout needs work

#### Screenshots
[Attach if relevant]
```

---

## Incomplete Plan Handling

Wenn Plan NICHT vollstaendig:

1. **Dokumentieren** was fehlt
2. **Priorisieren** verbleibende Items
3. **Entscheiden:**
   - Jetzt fertigstellen?
   - Follow-up Ticket erstellen?
   - Plan anpassen (wenn Scope Change)?
4. **PROGRESS.md** aktualisieren mit Status

---

## Related Rules

- `audit-workflow.md` - Audit Orchestration
