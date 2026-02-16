# Definition of Done (DoD)

> **Zweck:** Jedes Feature muss diese Checkliste erfuellen, bevor es als "fertig" gilt.
> Diese Checkliste bekaempft das 90%-Syndrom - Features werden erst abgeschlossen, dann zum naechsten gewechselt.

---

## Feature ist DONE wenn:

### Code

- [ ] Feature funktioniert wie spezifiziert
- [ ] Keine `console.log` / `print()` im Code
- [ ] Error States implementiert
- [ ] Loading States implementiert
- [ ] Keine hardcoded Test-Werte
- [ ] Keine `any` in TypeScript (wenn zutreffend)

### Tests

- [ ] Happy Path Test geschrieben
- [ ] Error Case Test geschrieben
- [ ] Edge Cases getestet (empty input, max values, null)
- [ ] `npm test` laeuft ohne Fehler (Frontend)
- [ ] `pytest` laeuft ohne Fehler (Backend)
- [ ] Coverage >= 80% fuer neuen Code

### Dokumentation

- [ ] Code-Kommentare wo noetig (nicht ueberall!)
- [ ] API-Aenderungen dokumentiert
- [ ] README/CHANGELOG aktualisiert (bei groesseren Features)
- [ ] TypeScript Types vollstaendig

### Quality

- [ ] `npm run build` funktioniert (Frontend)
- [ ] Feature manuell getestet
- [ ] Code self-reviewed (diese Checkliste durchgegangen)
- [ ] Keine Security Issues (hardcoded secrets, SQL injection, XSS)

### Deployment

- [ ] Git committed mit aussagekraeftiger Message
- [ ] Branch up-to-date mit main

### [YOUR_PROJECT_SPECIFIC_CHECKS]

- [ ] [Add project-specific checks here, e.g.:]
- [ ] [Specific documentation files updated]
- [ ] [Integration tests with external services pass]
- [ ] [Feature flag configured]
- [ ] [Monitoring/alerting set up]

---

## Wann ist ein Feature "gross"?

**Erweiterter Log + Dokumentation bei:**
- Neue API Endpoints
- Neue Pages/Dashboards
- Neue externe Integrationen
- Business-kritische Features

**Kein erweiterter Log bei:**
- Bug Fixes
- Kleine UI-Anpassungen
- Refactoring
- Typo-Fixes

---

## Quick-Check vor Commit

```bash
# Alle Tests laufen?
npm test && pytest

# Build funktioniert?
npm run build

# Keine Debug-Statements?
grep -r "console.log" src/ --include="*.ts" --include="*.tsx" | grep -v node_modules
grep -r "print(" app/ --include="*.py"

# TypeScript Errors?
npx tsc --noEmit

# Linting?
npm run lint
```

---

## Claude's Rolle

Claude fragt aktiv nach DoD-Erfuellung:

1. **Bei Feature-Abschluss:** "Ist das Feature getestet? Soll ich die DoD-Checkliste durchgehen?"
2. **Bei Themenwechsel:** "Stop - ist [Feature X] wirklich fertig? DoD erfuellt?"
3. **Bei grossen Features:** "Soll ich die Dokumentation aktualisieren?"

---

## Severity bei Nicht-Erfuellung

| Fehlend | Severity | Action |
|---------|----------|--------|
| Tests fehlen komplett | HIGH | MUSS gefixt werden vor Merge |
| Build broken | HIGH | MUSS gefixt werden sofort |
| Debug Statements im Code | MEDIUM | Vor Commit entfernen |
| Dokumentation fehlt | MEDIUM | Sollte nachgeholt werden |
| Edge Cases nicht getestet | LOW | Kann im Follow-up kommen |

---

## Anpassung

Passe diese Checkliste an dein Projekt an:

1. Kopiere diese Datei in dein Projekt unter `docs/DEFINITION-OF-DONE.md`
2. Ersetze `[YOUR_PROJECT_SPECIFIC_CHECKS]` mit projektspezifischen Pruefungen
3. Passe die Quick-Check Befehle an deine Projektstruktur an
4. Ergaenze Deployment-spezifische Schritte (CI/CD Pipeline, Staging, etc.)

---

*DoD Template | Claude Code Starter Kit*
