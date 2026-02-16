# Security Rules

> **MANDATORY**: Check these before EVERY commit.

---

## Pre-Commit Security Checklist

- [ ] **No hardcoded secrets** (API keys, passwords, tokens)
- [ ] **All user inputs validated**
- [ ] **SQL injection prevention** (parameterized queries only)
- [ ] **XSS prevention** (sanitized HTML output)
- [ ] **CSRF protection enabled**
- [ ] **Auth/authz verified** on all endpoints
- [ ] **Rate limiting** on public endpoints
- [ ] **Error messages don't leak** sensitive data

---

## Secret Management

### NEVER DO THIS:
```python
api_key = "sk-1234567890abcdef"  # HARDCODED SECRET!
```

### ALWAYS DO THIS:
```python
import os

api_key = os.getenv("API_KEY")
if not api_key:
    raise ValueError("API_KEY environment variable required")
```

---

## Incident Response

When security vulnerability found:

1. **STOP** current work immediately
2. **Escalate** to security-reviewer agent
3. **Prioritize** critical fixes
4. **Rotate** any exposed credentials
5. **Audit** codebase for similar issues

---

## Common Vulnerabilities (OWASP Top 10)

| Vulnerability | Prevention |
|--------------|------------|
| Injection | Parameterized queries |
| Broken Auth | Auth framework + session management |
| Sensitive Data | Env vars, encryption |
| XXE | Disable XML parsing |
| Broken Access | RLS + API validation |
| Misconfiguration | Security headers |
| XSS | React auto-escaping |
| Insecure Deserialize | Pydantic validation |
| Vulnerable Components | Regular updates |
| Insufficient Logging | Structured logging |
