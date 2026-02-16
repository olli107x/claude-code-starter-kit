# Git Workflow Rules

> **ALWAYS FOLLOW**: Conventional commits, PR process, no force push.

---

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
Co-Authored-By: Claude <noreply@anthropic.com>
```

### Types

| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting (no code change) |
| `refactor` | Code change (no feature/fix) |
| `perf` | Performance improvement |
| `test` | Adding tests |
| `chore` | Build, deps, configs |

### Examples

```bash
feat(users): add profile page filtering
fix(auth): resolve session timeout issue
docs(api): update webhook documentation
refactor(hooks): extract common data fetching logic
```

---

## Pre-Commit Checklist

**MANDATORY before every commit:**

- [ ] `npm test` passes
- [ ] `pytest` passes
- [ ] `npm run build` succeeds
- [ ] Feature manually tested
- [ ] No console.log / print() in code
- [ ] No hardcoded test values
- [ ] Error states implemented
- [ ] Loading states implemented

**For new features ALSO:**

- [ ] Tests written (min. happy path + error)
- [ ] TypeScript types complete
- [ ] Documentation updated

---

## Branch Strategy

```
main           <- Production (protected)
  +-- feature/xxx <- Feature branches
  +-- fix/xxx     <- Bug fixes
  +-- chore/xxx   <- Maintenance
```

### Branch Naming

```
feature/add-user-profile
fix/auth-session-timeout
chore/update-dependencies
docs/api-webhook-guide
```

---

## PR Process

1. **Create branch** from main
2. **Implement** feature/fix
3. **Run tests** locally
4. **Push** to remote
5. **Create PR** with template
6. **Request review** if needed
7. **Merge** when approved

### PR Template

```markdown
## Summary
<1-3 bullet points>

## Test plan
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing done

## Screenshots (if UI changes)

---
Generated with [Claude Code](https://claude.com/claude-code)
```

---

## Forbidden Actions

| Action | Why | Alternative |
|--------|-----|-------------|
| `git push --force` to main | Destroys history | Create new commit |
| `git commit --amend` (after push) | Rewrites history | New commit |
| Skip pre-commit hooks | Quality risk | Fix issues first |
| Commit secrets | Security breach | Use .env |
| Large binary files | Bloats repo | Use Git LFS |

---

## Useful Commands

```bash
# Status & diff
git status
git diff --staged

# Commit with message
git commit -m "feat(scope): description"

# Push with upstream
git push -u origin feature/xxx

# Create PR (GitHub CLI)
gh pr create --title "..." --body "..."
```
