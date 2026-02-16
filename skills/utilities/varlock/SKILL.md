---
name: varlock
description: Secret protection skill that prevents secrets from leaking into sessions, terminals, logs, or git commits. Validates .env files, masks sensitive values, and reduces context overhead from environment handling.
---

# Varlock - Secret Protection

Prevents secrets from leaking into sessions, terminals, logs, or git commits.

## When to Use

- Before committing code (pre-commit secret scan)
- When working with .env files
- When debugging environment variable issues
- When onboarding to a new project (validate .env setup)
- When user says "check secrets", "scan for leaks", "varlock"

## Process

### Phase 1: Discovery

Scan the project for secret-containing files:

```bash
# Find all potential secret files
find . -name ".env*" -o -name "*.pem" -o -name "*.key" -o -name "credentials*" 2>/dev/null | grep -v node_modules | grep -v .git
```

Check .gitignore coverage:

```bash
# Verify .env files are gitignored
git check-ignore .env .env.local .env.production 2>/dev/null
```

### Phase 2: Validate .env Schema

If a `.env.example` or `.env.schema` exists, validate against it:

1. Read `.env.example` to get expected keys
2. Read `.env` (or `.env.local`) to get actual keys
3. Report:
   - Missing keys (in example but not in .env)
   - Extra keys (in .env but not in example)
   - Empty values for required keys

**NEVER print actual secret values.** Always mask: `API_KEY=sk-****...cdef`

### Phase 3: Git History Scan

```bash
# Check staged files for secrets
git diff --cached --name-only | while read f; do
  grep -nEi '(api[_-]?key|secret|password|token|credential|private[_-]?key)\s*[:=]' "$f" 2>/dev/null
done

# Check recent commits for accidental secret commits
git log --all --diff-filter=A --name-only --pretty=format: -10 | sort -u | \
  grep -iE '\.env$|\.pem$|\.key$|credentials|secret'
```

### Phase 4: Code Scan

Search for hardcoded secrets in source:

```
Pattern: Strings matching secret patterns in source files
- API keys: sk-*, pk-*, rk_live_*, AKIA*
- Tokens: ghp_*, gho_*, github_pat_*
- Generic: password = "...", secret = "..."
- Base64 encoded secrets
- Connection strings with embedded passwords
```

Exclude:
- Test files with obvious mock values (`test_key`, `fake_token`)
- Documentation examples
- .env.example files

### Phase 5: Report

```markdown
## Varlock Secret Scan Results

### .env Validation
- Schema: .env.example found (15 keys)
- Missing: 0 keys
- Empty: 1 key (SENTRY_DSN - optional)
- Status: PASS

### Git Protection
- .gitignore: .env, .env.local, .env.production covered
- Staged secrets: None found
- History leaks: None found
- Status: PASS

### Code Scan
- Hardcoded secrets: 0 found
- Status: PASS

### Overall: PASS
```

## Severity Mapping

| Finding | Severity | Action |
|---------|----------|--------|
| Hardcoded secret in source | CRITICAL | Remove + rotate immediately |
| Secret in git history | CRITICAL | git-filter-repo + rotate |
| .env not in .gitignore | HIGH | Add to .gitignore now |
| Missing .env key | MEDIUM | Add key with value |
| Empty optional .env key | LOW | Inform, no action needed |

## Rules

- **NEVER** print, log, or display actual secret values
- **NEVER** include secrets in commit messages or PR descriptions
- **ALWAYS** mask values: show first 2 and last 4 chars max (`sk-**...cdef`)
- **ALWAYS** recommend rotating any secret that was exposed
- If a secret is found in git history, recommend `git-filter-repo` NOT `git filter-branch`

## Context Optimization

When .env files are large (20+ vars), don't read the entire file into context.
Instead, use targeted grep for specific keys the current task needs:

```bash
# Only read what you need
grep "^DATABASE_URL" .env
grep "^SUPABASE" .env
```
