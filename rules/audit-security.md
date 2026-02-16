# Security Audit Guidelines

> **TRIGGER:** Teil des Full Audits oder manuell via `/audit-security`

---

## Agents & Skills

| Tool | Zweck |
|------|-------|
| `security-reviewer` Agent | OWASP Top 10 Scan |
| `/review` Command | Pre-Commit Security Check |

---

## OWASP Top 10 Checkliste

### 1. Injection (A01:2021)

- [ ] **SQL Injection:** Nur parameterisierte Queries (SQLAlchemy, Prisma, etc.)
- [ ] **Command Injection:** Kein `os.system()` oder `subprocess.run(shell=True)`
- [ ] **LDAP/NoSQL Injection:** Input validiert

```python
# CRITICAL - SQL Injection
query = f"SELECT * FROM users WHERE id = {user_id}"

# CORRECT - Parameterized
db.query(User).filter(User.id == user_id)
```

### 2. Broken Authentication (A02:2021)

- [ ] **JWT Validation:** Token wird verifiziert
- [ ] **Session Handling:** Sichere Session-Cookies
- [ ] **Password Policy:** Stark genug (wenn relevant)
- [ ] **MFA:** Wo moeglich implementiert

### 3. Sensitive Data Exposure (A03:2021)

- [ ] **Keine Secrets im Code:** Keine API Keys, Passwoerter hardcoded
- [ ] **Environment Variables:** Alle Secrets in .env
- [ ] **HTTPS:** Alle externen Calls ueber HTTPS
- [ ] **Logging:** Keine sensiblen Daten in Logs

```python
# CRITICAL - Hardcoded Secret
API_KEY = "sk-1234567890abcdef"

# CORRECT - Environment Variable
API_KEY = os.getenv("API_KEY")
if not API_KEY:
    raise ValueError("API_KEY required")
```

### 4. XML External Entities (A04:2021)

- [ ] **XXE:** Kein unsicheres XML Parsing
- [ ] **DTD:** Disabled wo moeglich

### 5. Broken Access Control (A05:2021)

- [ ] **Access Policies:** Datenbank-Level Zugriffskontrolle aktiv
- [ ] **Auth Checks:** Alle Protected Endpoints pruefen Auth
- [ ] **Authorization:** User kann nur eigene Daten sehen/aendern
- [ ] **IDOR:** Keine direkten Object References ohne Check

```python
# HIGH - Missing Auth Check
@app.get("/api/user/{user_id}")
async def get_user(user_id: int):
    return db.query(User).get(user_id)

# CORRECT - With Auth
@app.get("/api/user/{user_id}")
async def get_user(user_id: int, current_user: User = Depends(get_current_user)):
    if current_user.id != user_id and not current_user.is_admin:
        raise HTTPException(403, "Not authorized")
    return db.query(User).get(user_id)
```

### 6. Security Misconfiguration (A06:2021)

- [ ] **CORS:** Nicht `allow_origins=["*"]` in Production
- [ ] **Headers:** Security Headers gesetzt (HSTS, CSP, etc.)
- [ ] **Debug Mode:** Aus in Production
- [ ] **Default Credentials:** Keine Standard-Passwoerter

```python
# MEDIUM - Too permissive CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # DANGEROUS
)

# CORRECT - Specific origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://yourdomain.com"],
)
```

### 7. Cross-Site Scripting XSS (A07:2021)

- [ ] **React Auto-Escaping:** Nutzen (default)
- [ ] **dangerouslySetInnerHTML:** NIEMALS mit User Input
- [ ] **Sanitization:** Alle User-Inputs sanitized
- [ ] **CSP:** Content Security Policy Header

```typescript
// HIGH - XSS Vulnerability
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// CORRECT - Use text content
<div>{userInput}</div>

// Oder sanitize:
import DOMPurify from 'dompurify';
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userInput) }} />
```

### 8. Insecure Deserialization (A08:2021)

- [ ] **Pydantic Validation:** Alle API Inputs validiert
- [ ] **Pickle:** Kein `pickle.loads()` von User Input
- [ ] **JSON Schema:** Strikt definiert

### 9. Vulnerable Components (A09:2021)

- [ ] **Dependencies:** Regelmaessig aktualisiert
- [ ] **Known Vulnerabilities:** Keine bekannten CVEs
- [ ] **Audit:** `npm audit` und `pip-audit` regelmaessig

```bash
# Check fuer Vulnerabilities
npm audit
pip-audit
```

### 10. Insufficient Logging (A10:2021)

- [ ] **Structured Logging:** Vorhanden
- [ ] **Security Events:** Auth failures geloggt
- [ ] **No Sensitive Data:** Keine Passwoerter/Tokens in Logs
- [ ] **Audit Trail:** Wichtige Aktionen getrackt

---

## Severity Mapping

| Finding | Severity | Action |
|---------|----------|--------|
| Hardcoded Secret | CRITICAL | Immediate fix, rotate secret |
| SQL Injection moeglich | CRITICAL | Immediate fix |
| Missing Auth Check | HIGH | Must fix before deploy |
| XSS moeglich | HIGH | Must fix before deploy |
| CORS allow_origins=["*"] | MEDIUM | Fix in production config |
| Missing Rate Limiting | MEDIUM | Should add |
| Console.log mit sensiblen Daten | LOW | Remove before deploy |
| Missing Security Headers | LOW | Add when possible |

---

## Automated Checks

```bash
# Python - Security Linting
bandit -r src/

# JavaScript - Security Audit
npm audit

# Dependency Check
pip-audit
```

---

## Report Format

```markdown
## Security Audit Results

### CRITICAL (1)
1. **Hardcoded API Key in `services/external.py:12`**
   - Finding: `API_KEY = "sk-abc123..."`
   - Risk: Key exposure in version control
   - Fix: Move to environment variable
   - Action: Rotate key immediately

### HIGH (1)
1. **Missing auth check on `/api/admin/users`**
   - Finding: Endpoint accessible without authentication
   - Risk: Unauthorized data access
   - Fix: Add `Depends(get_current_admin)` dependency

### MEDIUM (0)
{none found}

### LOW (0)
{none found}
```

---

## Incident Response

Wenn CRITICAL gefunden:

1. **STOP** - Keine weiteren Aenderungen
2. **NOTIFY** - Team informieren
3. **ROTATE** - Betroffene Credentials rotieren
4. **FIX** - Vulnerability beheben
5. **AUDIT** - Pruefen ob bereits ausgenutzt
6. **DOCUMENT** - Incident dokumentieren

---

## Related Rules

- `security.md` - General Security Rules
- `audit-workflow.md` - Audit Orchestration
- `audit-bug.md` - Security-relevante Bugs
