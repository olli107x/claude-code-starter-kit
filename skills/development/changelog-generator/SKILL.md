---
name: changelog-generator
description: Generates CHANGELOG.md from git history with smart categorization (feat/fix/refactor), date ranges, version tags, and conventional commit parsing. Transforms technical commits into user-friendly release notes.
---

# Changelog Generator

Generates structured changelogs from git history using conventional commit parsing.

## When to Use

- Preparing release notes for a new version
- Creating weekly/monthly product update summaries
- Before tagging a new release
- When user says "changelog", "release notes", "what changed"

## Process

### Step 1: Determine Range

```bash
# Since last tag
git describe --tags --abbrev=0 2>/dev/null
# → v1.2.0

# Commits since last tag
git log v1.2.0..HEAD --oneline

# Or by date range
git log --after="2024-03-01" --before="2024-03-15" --oneline

# Or last N commits
git log -20 --oneline
```

### Step 2: Parse Commits

Extract conventional commit data:

```bash
# Get structured commit data
git log v1.2.0..HEAD --pretty=format:"%H|%s|%an|%aI" --no-merges
```

Categorize by prefix:

| Prefix | Category | Display |
|--------|----------|---------|
| `feat` | Features | New Features |
| `fix` | Bug Fixes | Bug Fixes |
| `perf` | Performance | Performance |
| `refactor` | Refactoring | Internal Changes |
| `docs` | Documentation | Documentation |
| `test` | Testing | (exclude from user-facing) |
| `chore` | Maintenance | (exclude from user-facing) |
| `style` | Formatting | (exclude from user-facing) |
| `BREAKING CHANGE` | Breaking | Breaking Changes |

### Step 3: Generate Changelog

**User-facing format** (default):

```markdown
# Changelog

## [1.3.0] - 2024-03-15

### Breaking Changes
- **auth:** JWT token format changed - clients must update (#123)

### New Features
- **deals:** Add pipeline stage filtering with drag-and-drop (#118)
- **contacts:** Bulk import from CSV with deduplication (#115)
- **dashboard:** Real-time KPI cards with sparkline charts (#112)

### Bug Fixes
- **auth:** Fix session timeout not redirecting to login (#120)
- **deals:** Fix currency formatting for EUR values (#117)

### Performance
- **api:** Reduce deal list query time by 60% with index optimization (#119)
```

**Developer-facing format** (with `--dev` flag):

```markdown
# Changelog

## [1.3.0] - 2024-03-15

### Features
- feat(deals): add pipeline stage filtering (#118) - @oliver
- feat(contacts): bulk CSV import with dedup (#115) - @oliver

### Fixes
- fix(auth): session timeout redirect (#120) - @oliver
- fix(deals): EUR currency formatting (#117) - @oliver

### Refactoring
- refactor(hooks): extract common fetch logic (#116) - @oliver

### Tests
- test(deals): add pipeline filter tests (#121) - @oliver

### Chores
- chore(deps): update React to 18.3 (#114) - @oliver
```

### Step 4: Smart Grouping

Group related commits:

1. Parse scope from `type(scope):` format
2. Group by scope (deals, auth, contacts, etc.)
3. Within each scope, order: breaking > feat > fix > perf
4. Exclude internal commits (test, chore, style) from user-facing notes

### Step 5: Output

Options:
- Print to stdout (default)
- Prepend to existing CHANGELOG.md
- Create new CHANGELOG.md
- Save to specific file

```bash
# Check if CHANGELOG.md exists
ls CHANGELOG.md 2>/dev/null
```

If prepending, insert new version section after the `# Changelog` header, before previous entries.

## Version Detection

```bash
# From package.json
node -e "console.log(require('./package.json').version)" 2>/dev/null

# From pyproject.toml
grep "^version" pyproject.toml 2>/dev/null

# From git tags
git describe --tags --abbrev=0 2>/dev/null

# Suggest next version based on commits
# BREAKING CHANGE → major bump
# feat → minor bump
# fix → patch bump
```

## Non-Conventional Commits

If commits don't follow conventional format, use AI categorization:

1. Read commit messages
2. Categorize by content analysis:
   - "add", "implement", "create" → Feature
   - "fix", "resolve", "correct" → Bug Fix
   - "update", "improve", "optimize" → Improvement
   - "remove", "delete", "clean" → Maintenance
   - "refactor", "restructure" → Internal

## Tips

- Run from git repository root
- Use `--dev` for developer-facing notes (includes tests, chores)
- Use date ranges for periodic reports
- Review before publishing - AI categorization isn't perfect
- Co-authored commits get primary author attribution
