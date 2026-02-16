# Documentation Templates

> Reusable documentation templates for Claude Code projects.

---

## How to Use

1. Copy these files into your project's `docs/` folder
2. Replace all `[YOUR_...]` placeholders with project-specific values
3. Adjust examples to match your tech stack
4. Remove sections that don't apply to your project

---

## Template Files

| File | Purpose | When to Read |
|------|---------|--------------|
| `debugging-methodology.md` | Systematic, hypothesis-driven debugging guide | When investigating bugs |
| `debugging-cheatsheet.md` | Quick reference card for debugging | During active debugging |
| `definition-of-done.md` | Feature completion checklist | Before marking any feature as complete |
| `code-standards.md` | Coding standards for Python + TypeScript | While writing code |

---

## What Each Template Covers

### debugging-methodology.md

The full debugging methodology based on "Debugging Engineering for Vibe Coders" by Alan Knox. Covers:
- The 5-Step Debug Protocol (Reproduce, Isolate, Inspect, Hypothesize, Verify)
- Hypothesis-driven debugging with tables
- Data flow analysis across system boundaries
- Common bug patterns (double counting, unit mismatch, null handling, race conditions)
- Anti-patterns to avoid

### debugging-cheatsheet.md

A condensed quick-reference version of the debugging methodology. Covers:
- The 5 steps at a glance
- Common bug patterns with code examples
- Inspection commands for database, backend, and frontend
- Hypothesis table template
- Debug report template
- Environment debugging commands

### definition-of-done.md

A checklist to ensure features are truly complete before moving on. Covers:
- Code quality checks (no debug statements, error/loading states)
- Test requirements (happy path, error cases, edge cases)
- Documentation requirements
- Build verification
- Placeholder section for project-specific checks

### code-standards.md

Coding standards and anti-patterns for Python + TypeScript projects. Covers:
- Python standards (type hints, Pydantic, Decimal for money, structured logging)
- TypeScript standards (interfaces, React Query patterns, API params)
- Comprehensive anti-patterns table
- Validation patterns (backend + frontend)
- Testing patterns and common MagicMock gotchas
- File organization guide
- Immutability rules

---

## Customization Checklist

When adopting these templates for your project:

- [ ] Replace `[YOUR_PROJECT_SPECIFIC_CHECKS]` in `definition-of-done.md`
- [ ] Adjust file paths in `code-standards.md` to match your project structure
- [ ] Add project-specific anti-patterns to `code-standards.md`
- [ ] Update the Quick-Check commands in `definition-of-done.md` for your build tools
- [ ] Add hosting-platform-specific commands to `debugging-cheatsheet.md`
- [ ] Add your project's common bug patterns to the cheatsheet

---

## Integration with Claude Code

These docs work best when referenced in your `CLAUDE.md`:

```markdown
## Dokumentation

| Doc | Wann lesen | Inhalt |
|-----|------------|--------|
| `docs/code-standards.md` | Code schreiben | Coding Guidelines + Anti-Patterns |
| `docs/definition-of-done.md` | Feature abschliessen | Abschluss Checkliste |
| `docs/debugging-methodology.md` | Bug untersuchen | Systematisches Debugging |
| `docs/debugging-cheatsheet.md` | Schnelle Referenz | Debug Quick Reference |
```

---

*Claude Code Starter Kit*
