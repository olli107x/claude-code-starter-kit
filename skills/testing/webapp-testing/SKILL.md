---
name: webapp-testing
description: Toolkit for interacting with and testing web applications using Claude Chrome (mcp__claude-in-chrome__*). Supports verifying frontend functionality, debugging UI behavior, capturing screenshots, and reading browser logs. Reconnaissance-then-action pattern.
---

# Web Application Testing

Test web applications using Claude Chrome browser automation (mcp__claude-in-chrome__*).

## When to Use

- Testing local or deployed web applications
- Verifying frontend functionality
- Debugging UI behavior
- Capturing visual evidence of bugs or features
- Reading browser console logs and network requests

## Decision Tree

```
User task --> Is the app running?
    |
    +-- No --> Ask user to start it, or check if URL is accessible
    |
    +-- Yes --> Get browser context first
        |
        1. tabs_context_mcp (check current tabs)
        2. tabs_create_mcp (create new tab)
        3. navigate to app URL
        4. Reconnaissance-then-action (below)
```

## Setup

1. **Check browser state:**
   ```
   mcp__claude-in-chrome__tabs_context_mcp
   ```

2. **Create a new tab** (never reuse tabs from previous sessions):
   ```
   mcp__claude-in-chrome__tabs_create_mcp
   ```

3. **Navigate to the app:**
   ```
   mcp__claude-in-chrome__navigate → URL
   ```

## Reconnaissance-Then-Action Pattern

**ALWAYS inspect before acting.** Never click blindly.

### Step 1: Inspect the Page

```
mcp__claude-in-chrome__read_page
```

Or get full text content:
```
mcp__claude-in-chrome__get_page_text
```

Or take a screenshot for visual inspection:
```
mcp__claude-in-chrome__computer → screenshot
```

### Step 2: Identify Targets

From the page content, identify:
- Buttons, links, inputs by their text, role, or CSS selector
- Form fields and their current values
- Error messages or status indicators
- Loading states

### Step 3: Execute Actions

**Click elements:**
```
mcp__claude-in-chrome__computer → click at coordinates
```

**Fill forms:**
```
mcp__claude-in-chrome__form_input → selector + value
```

**Run JavaScript for complex checks:**
```
mcp__claude-in-chrome__javascript_tool → custom JS
```

### Step 4: Verify Results

After each action:
1. Take a screenshot or read the page
2. Check console for errors: `mcp__claude-in-chrome__read_console_messages`
3. Check network requests: `mcp__claude-in-chrome__read_network_requests`
4. Verify expected state change

## Common Testing Patterns

### Form Submission Test

```
1. navigate → form page
2. read_page → identify form fields
3. form_input → fill each field
4. computer → click submit button
5. read_page → verify success message or redirect
6. read_console_messages → check for errors
```

### Navigation Test

```
1. navigate → start page
2. read_page → find navigation links
3. computer → click link
4. read_page → verify correct page loaded
5. Repeat for key navigation paths
```

### Error State Test

```
1. navigate → form page
2. computer → click submit without filling required fields
3. read_page → verify error messages appear
4. read_console_messages → check for unhandled errors
```

### API Integration Test

```
1. navigate → page that makes API calls
2. read_network_requests → verify API calls made correctly
3. read_page → verify data rendered from API
4. read_console_messages → check for fetch errors
```

### Responsive Test

```
1. resize_window → mobile dimensions (375x667)
2. read_page or screenshot → check mobile layout
3. resize_window → tablet (768x1024)
4. read_page or screenshot → check tablet layout
5. resize_window → desktop (1440x900)
```

## Recording Multi-Step Flows

Use `mcp__claude-in-chrome__gif_creator` to record multi-step interactions:
- Capture frames before AND after each action
- Name the file meaningfully (e.g., "login_flow_test.gif")

## Debugging Tips

- **Console errors:** `read_console_messages` with pattern filter for specific logs
- **Network failures:** `read_network_requests` to see failed API calls
- **Visual bugs:** `computer → screenshot` for visual evidence
- **DOM state:** `javascript_tool` to query specific DOM state
- **React state:** `javascript_tool` to access React DevTools data

## Anti-Patterns

- **Don't** click elements without first inspecting the page
- **Don't** reuse tab IDs from previous sessions
- **Don't** trigger JavaScript alerts/confirms/prompts (they block the extension)
- **Don't** keep retrying the same failing action more than 2-3 times
- **Do** ask the user for guidance when stuck

## Comparison: Claude Chrome vs. Playwright

| Aspect | Claude Chrome | Playwright (old) |
|--------|--------------|-----------------|
| Setup | Chrome extension (already running) | Python + pip install |
| Speed | Instant (uses existing browser) | Slow (launches headless) |
| Visibility | See actions in real browser | Headless (invisible) |
| Auth | Uses existing browser sessions | Must handle auth in code |
| DevTools | Console + Network access | Limited |
| Recording | GIF creator built-in | Screenshot scripts needed |
| Limitation | No parallel tabs | Parallel execution |
