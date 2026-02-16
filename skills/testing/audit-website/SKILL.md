---
name: audit-website
description: Comprehensive website audit for SEO, Performance, Security, and Accessibility using Claude Chrome MCP tools. Runs 140+ checks via live browser analysis instead of CLI tools. Use when auditing a website's quality.
---

# Website Audit

Comprehensive website audit using Claude Chrome (mcp__claude-in-chrome__*) for live browser analysis.

## When to Use

- Auditing a website before launch
- Checking SEO, performance, accessibility, security
- When user says "audit website", "check site", "website review"
- Pre-deployment quality gate

## Prerequisites

- Chrome browser open with Claude-in-Chrome extension active
- Target URL accessible

## Process

### Phase 0: Setup

1. Call `mcp__claude-in-chrome__tabs_context_mcp` to check browser state
2. Create a new tab: `mcp__claude-in-chrome__tabs_create_mcp`
3. Navigate to target URL: `mcp__claude-in-chrome__navigate`

### Phase 1: SEO Audit (35+ checks)

Use `mcp__claude-in-chrome__get_page_text` and `mcp__claude-in-chrome__javascript_tool` to check:

**Meta Tags:**
- [ ] Title tag exists, 50-60 chars, unique per page
- [ ] Meta description exists, 150-160 chars
- [ ] Canonical URL set
- [ ] Open Graph tags (og:title, og:description, og:image)
- [ ] Twitter Card meta tags
- [ ] Viewport meta tag

**Headings:**
- [ ] Single H1 per page
- [ ] Logical heading hierarchy (H1 > H2 > H3)
- [ ] H1 contains primary keyword

**Content:**
- [ ] Alt text on all images
- [ ] Internal links present
- [ ] No broken links (check href="#" or empty)
- [ ] Language attribute on html tag
- [ ] Structured data (JSON-LD)

```javascript
// Example: Extract meta tags via javascript_tool
(() => {
  const title = document.title;
  const desc = document.querySelector('meta[name="description"]')?.content;
  const canonical = document.querySelector('link[rel="canonical"]')?.href;
  const h1s = document.querySelectorAll('h1');
  const imgs = [...document.querySelectorAll('img')].filter(i => !i.alt);
  return JSON.stringify({
    title: { text: title, length: title.length },
    description: { text: desc?.substring(0, 50) + '...', length: desc?.length },
    canonical,
    h1Count: h1s.length,
    imagesWithoutAlt: imgs.length
  });
})()
```

### Phase 2: Performance Audit (30+ checks)

Use `mcp__claude-in-chrome__javascript_tool` and `mcp__claude-in-chrome__read_network_requests`:

**Loading:**
- [ ] Page load time < 3s
- [ ] First Contentful Paint < 1.8s
- [ ] Largest Contentful Paint < 2.5s
- [ ] No render-blocking resources

**Assets:**
- [ ] Images optimized (WebP/AVIF format)
- [ ] Images have width/height attributes (CLS prevention)
- [ ] CSS/JS minified
- [ ] Gzip/Brotli compression enabled
- [ ] Browser caching headers set

**Network:**
- [ ] Total page weight < 3MB
- [ ] HTTP/2 or HTTP/3 used
- [ ] No excessive redirects
- [ ] Resource count < 100

```javascript
// Example: Performance metrics via javascript_tool
(() => {
  const perf = performance.getEntriesByType('navigation')[0];
  const paint = performance.getEntriesByType('paint');
  return JSON.stringify({
    domComplete: Math.round(perf.domComplete),
    loadTime: Math.round(perf.loadEventEnd - perf.startTime),
    fcp: paint.find(p => p.name === 'first-contentful-paint')?.startTime,
    transferSize: Math.round(perf.transferSize / 1024) + 'KB',
    resourceCount: performance.getEntriesByType('resource').length
  });
})()
```

### Phase 3: Security Audit (25+ checks)

Use `mcp__claude-in-chrome__javascript_tool` and `mcp__claude-in-chrome__read_network_requests`:

**Headers:**
- [ ] HTTPS enforced
- [ ] Strict-Transport-Security (HSTS)
- [ ] Content-Security-Policy
- [ ] X-Content-Type-Options: nosniff
- [ ] X-Frame-Options or CSP frame-ancestors
- [ ] Referrer-Policy

**Content:**
- [ ] No mixed content (HTTP resources on HTTPS page)
- [ ] No inline scripts without nonce/hash (CSP)
- [ ] External scripts from trusted sources
- [ ] No exposed API keys in page source
- [ ] Forms use POST for sensitive data
- [ ] Cookies have Secure and HttpOnly flags

### Phase 4: Accessibility Audit (50+ checks)

Use `mcp__claude-in-chrome__javascript_tool`:

**Structure:**
- [ ] Skip navigation link
- [ ] Landmark roles (main, nav, header, footer)
- [ ] Page language attribute
- [ ] Logical tab order

**Forms:**
- [ ] All inputs have labels
- [ ] Required fields indicated
- [ ] Error messages associated with fields
- [ ] Focus visible on all interactive elements

**Visual:**
- [ ] Color contrast ratio >= 4.5:1 (text), >= 3:1 (large text)
- [ ] Text resizable to 200% without loss
- [ ] No content conveyed by color alone
- [ ] Focus indicators visible

**Media:**
- [ ] Images have alt text
- [ ] Decorative images have empty alt=""
- [ ] Videos have captions/transcripts
- [ ] No auto-playing media

```javascript
// Example: Accessibility quick check
(() => {
  const issues = [];
  // Check images without alt
  document.querySelectorAll('img:not([alt])').forEach(img => {
    issues.push({ type: 'img-no-alt', src: img.src?.substring(0, 50) });
  });
  // Check inputs without labels
  document.querySelectorAll('input:not([type="hidden"])').forEach(input => {
    const id = input.id;
    const label = id ? document.querySelector(`label[for="${id}"]`) : null;
    const ariaLabel = input.getAttribute('aria-label');
    if (!label && !ariaLabel) {
      issues.push({ type: 'input-no-label', name: input.name || input.type });
    }
  });
  // Check buttons without text
  document.querySelectorAll('button').forEach(btn => {
    if (!btn.textContent.trim() && !btn.getAttribute('aria-label')) {
      issues.push({ type: 'button-no-text' });
    }
  });
  return JSON.stringify({ issueCount: issues.length, issues: issues.slice(0, 20) });
})()
```

### Phase 5: Report

```markdown
## Website Audit Report: {URL}
**Date:** {date}

### Summary

| Category | Score | Issues |
|----------|-------|--------|
| SEO | 85/100 | 3 warnings |
| Performance | 72/100 | 2 critical |
| Security | 90/100 | 1 warning |
| Accessibility | 68/100 | 5 issues |
| **Overall** | **79/100** | |

### Critical Issues
1. [PERF] LCP > 4s - optimize hero image
2. [A11Y] 12 images missing alt text

### Warnings
1. [SEO] Meta description too short (89 chars)
2. [SEO] Missing Open Graph image
3. [SEC] Missing Content-Security-Policy header

### Passed
- HTTPS enforced
- H1 present and unique
- Viewport meta tag set
- ...

### Recommendations (Priority Order)
1. Optimize hero image (convert to WebP, add dimensions)
2. Add alt text to all images
3. Add Content-Security-Policy header
4. Extend meta description to 150+ chars
```

## Multi-Page Audit

For multi-page sites, audit at minimum:
1. Homepage
2. One content/product page
3. One form page (contact, login)
4. 404 page

Navigate between pages using `mcp__claude-in-chrome__navigate`.

## Notes

- This skill uses live browser analysis, not Lighthouse CLI
- Results may vary by network conditions
- Take screenshots with `mcp__claude-in-chrome__computer` for visual evidence
- Use `mcp__claude-in-chrome__read_console_messages` to check for JS errors
