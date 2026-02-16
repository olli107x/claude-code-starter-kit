---
name: ui-audit
description: Systematisches UI Quality Review - Accessibility, Responsiveness, Performance, Konsistenz.
allowed-tools: Bash,Read,Write,Edit,Glob,Grep
---

# UI Audit Skill

Systematische Pruefung der UI-Qualitaet. Accessibility, Responsive Design, Performance und visuelle Konsistenz werden anhand konkreter Checklisten bewertet.

## Audit-Ablauf

```
1. Accessibility Audit       (WCAG 2.1 AA)
2. Responsive Design Audit   (Breakpoints, Touch)
3. Performance Audit          (Core Web Vitals)
4. Visual Consistency Audit   (Design System Compliance)
5. Browser Compatibility      (Target Browsers)
6. Report generieren
```

## 1. Accessibility Audit (WCAG 2.1 AA)

### Semantisches HTML

- [ ] Korrekte Heading-Hierarchie (`h1` > `h2` > `h3`, keine Ebene uebersprungen)
- [ ] Landmarks vorhanden (`<main>`, `<nav>`, `<aside>`, `<footer>`)
- [ ] Listen als `<ul>`/`<ol>`, nicht als `<div>`-Ketten
- [ ] Tabellen fuer tabulare Daten, nicht fuer Layout
- [ ] `<button>` fuer Aktionen, `<a>` fuer Navigation

```typescript
// FALSCH: Div als Button
<div onClick={handleClick} className="btn">Speichern</div>

// RICHTIG: Semantisches Element
<button type="button" onClick={handleClick} className="btn">Speichern</button>
```

### ARIA Attribute

- [ ] `aria-label` auf Icon-Buttons ohne sichtbaren Text
- [ ] `aria-expanded` auf Toggles (Accordions, Dropdowns)
- [ ] `aria-live="polite"` fuer dynamische Inhalte (Toasts, Statusmeldungen)
- [ ] `aria-hidden="true"` auf dekorativen Elementen
- [ ] `role` nur wenn kein semantisches HTML-Element passt
- [ ] ARIA IDs eindeutig im DOM

```typescript
// Icon-Button braucht Label
<button aria-label="Deal loeschen" onClick={onDelete}>
  <TrashIcon aria-hidden="true" />
</button>

// Dynamischer Status
<div aria-live="polite" aria-atomic="true">
  {status === 'saving' && <span>Wird gespeichert...</span>}
  {status === 'saved' && <span>Gespeichert</span>}
</div>
```

### Keyboard Navigation

- [ ] Alle interaktiven Elemente per Tab erreichbar
- [ ] Focus-Reihenfolge logisch (DOM-Reihenfolge = visuelle Reihenfolge)
- [ ] Sichtbarer Focus-Ring (`:focus-visible`)
- [ ] Escape schliesst Modals/Dropdowns
- [ ] Enter/Space aktiviert Buttons
- [ ] Pfeiltasten in Listen, Tabs, Menüs
- [ ] Focus Trap in Modals

```typescript
// Focus Trap Hook
function useFocusTrap(ref: RefObject<HTMLElement>, active: boolean) {
  useEffect(() => {
    if (!active || !ref.current) return;

    const focusable = ref.current.querySelectorAll<HTMLElement>(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
    const first = focusable[0];
    const last = focusable[focusable.length - 1];

    function handleTab(e: KeyboardEvent) {
      if (e.key !== 'Tab') return;
      if (e.shiftKey && document.activeElement === first) {
        e.preventDefault();
        last?.focus();
      } else if (!e.shiftKey && document.activeElement === last) {
        e.preventDefault();
        first?.focus();
      }
    }

    first?.focus();
    document.addEventListener('keydown', handleTab);
    return () => document.removeEventListener('keydown', handleTab);
  }, [ref, active]);
}
```

### Farbkontrast

- [ ] Text: Kontrastverhältnis >= 4.5:1 (normal), >= 3:1 (gross/bold)
- [ ] UI-Elemente (Borders, Icons): >= 3:1
- [ ] Informationen nicht nur ueber Farbe vermittelt (zusaetzlich Icon/Text)
- [ ] Dark Mode Kontraste separat pruefen

### Screen Reader

- [ ] Bilder haben `alt`-Text (oder `alt=""` wenn dekorativ)
- [ ] Formulare haben verknuepfte Labels (`htmlFor` / `aria-labelledby`)
- [ ] Fehlermeldungen per `aria-describedby` mit Input verknuepft
- [ ] Tabellen haben `<caption>` oder `aria-label`

## 2. Responsive Design Audit

### Breakpoints

- [ ] Layout funktioniert bei 320px (kleinstes Smartphone)
- [ ] Kein horizontaler Scroll unter 375px
- [ ] Tablet-Layout (768px) sinnvoll genutzt
- [ ] Desktop-Layout (1024px+) nutzt verfuegbaren Platz
- [ ] Grosse Bildschirme (1440px+): Content nicht zu breit (max-width)

### Touch Targets

- [ ] Mindestgroesse 44x44px (WCAG) / 48x48px (Material Design)
- [ ] Abstand zwischen Touch Targets >= 8px
- [ ] Keine Hover-only Interaktionen auf Touch-Geraeten

### Viewport

- [ ] `<meta name="viewport" content="width=device-width, initial-scale=1">`
- [ ] Kein `user-scalable=no` (Accessibility-Verstoss)
- [ ] Text skaliert bei Browser-Zoom (keine festen px fuer Font-Size)

### Responsive Bilder

- [ ] `srcset` und `sizes` fuer responsive Bilder
- [ ] `loading="lazy"` fuer Below-the-Fold Bilder
- [ ] Bilder haben explizite `width` und `height` (CLS-Prevention)

## 3. Performance Audit

### Core Web Vitals

| Metrik | Gut | Verbesserungswuerdig | Schlecht |
|--------|-----|---------------------|---------|
| LCP (Largest Contentful Paint) | < 2.5s | 2.5s - 4s | > 4s |
| INP (Interaction to Next Paint) | < 200ms | 200ms - 500ms | > 500ms |
| CLS (Cumulative Layout Shift) | < 0.1 | 0.1 - 0.25 | > 0.25 |

### Bundle Size

- [ ] Initiales JS Bundle < 200KB (gzipped)
- [ ] Route-basiertes Code Splitting aktiv
- [ ] Keine ungenutzten Dependencies im Bundle
- [ ] Tree Shaking funktioniert (keine Barrel-Import-Probleme)

```bash
# Bundle analysieren
npx vite-bundle-visualizer    # Vite
npx @next/bundle-analyzer     # Next.js
npx webpack-bundle-analyzer   # Webpack
```

### Bilder

- [ ] Moderne Formate (WebP/AVIF) wo moeglich
- [ ] Bilder passend skaliert (nicht 2000px fuer 200px Container)
- [ ] `next/image` oder `<picture>` mit Fallbacks

### Lazy Loading

- [ ] Routes lazy loaded (`React.lazy` / dynamic imports)
- [ ] Schwere Components (Charts, Editoren) lazy loaded
- [ ] Bilder below the fold lazy loaded
- [ ] Kein Lazy Loading fuer Above-the-Fold Content

### Rendering Performance

- [ ] Keine unnötigen Re-Renders (React DevTools Profiler)
- [ ] Listen > 50 Items virtualisiert
- [ ] Teure Berechnungen in `useMemo`
- [ ] Event Handler in `useCallback` wo noetig (Child Prop Stability)

## 4. Visual Consistency Audit

### Spacing

- [ ] Konsistentes Spacing-System (4px/8px Grid)
- [ ] Keine Magic Numbers (`margin: 13px`)
- [ ] Spacing-Tokens aus Design System verwendet

### Typographie

- [ ] Konsistente Font-Groessen aus Type Scale
- [ ] Max 2-3 Font-Gewichte pro Seite
- [ ] Zeilenhoehe passend (1.4-1.6 fuer Body, 1.1-1.3 fuer Headings)
- [ ] Maximale Zeilenlaenge 65-75 Zeichen fuer Fliesstext

### Farben

- [ ] Farben aus Design Tokens, keine Hex-Werte im Code
- [ ] Konsistente Verwendung (Primary, Secondary, Error, etc.)
- [ ] Hover/Active/Focus States konsistent

### Component Reuse

- [ ] Keine duplizierten UI Patterns (gleicher Button in 3 Varianten)
- [ ] Shared Components statt Copy-Paste
- [ ] Konsistente Icon-Groessen und Styles

## 5. Browser Compatibility

### Target Browsers (Beispiel)

```
Chrome >= 90
Firefox >= 90
Safari >= 15
Edge >= 90
iOS Safari >= 15
Samsung Internet >= 18
```

### Checks

- [ ] CSS Features mit Fallbacks oder `@supports`
- [ ] JS Features mit Polyfills oder Feature Detection
- [ ] Keine `-webkit-`-only Properties ohne Standard

## Automatisierte Checks

```bash
# Lighthouse CI
npx lighthouse http://localhost:3000 --output=json --output=html

# Accessibility (axe-core)
npx @axe-core/cli http://localhost:3000

# Bundle Size
npx bundlephobia <package-name>

# CSS Complexity
npx wallace-cli http://localhost:3000

# Unused CSS
npx purgecss --css style.css --content index.html
```

### In Tests

```typescript
// vitest + @testing-library
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

it('DealCard hat keine Accessibility-Violations', async () => {
  const { container } = render(<DealCard deal={mockDeal()} />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

## Severity Mapping

| Finding | Severity | Beispiel |
|---------|----------|----------|
| Nicht per Keyboard bedienbar | CRITICAL | Modal ohne Focus Trap |
| Kontrast < 3:1 | CRITICAL | Hellgrauer Text auf Weiss |
| Touch Target < 30px | HIGH | Winziger Close-Button |
| Kein alt-Text auf informativen Bildern | HIGH | Produktbild ohne Beschreibung |
| CLS > 0.25 | HIGH | Layout springt beim Laden |
| LCP > 4s | HIGH | Hero-Bild laedt 6 Sekunden |
| Fehlende Loading States | MEDIUM | Weisse Seite beim Laden |
| Inkonsistentes Spacing | MEDIUM | 12px hier, 16px dort |
| Fehlende Hover States | LOW | Button ohne Hover-Feedback |
| Suboptimales Bildformat | LOW | PNG statt WebP |

## Report Format

```markdown
## UI Audit Report

### Zusammenfassung

| Bereich | Status | Findings |
|---------|--------|----------|
| Accessibility | CRITICAL: 2, HIGH: 1 | Focus Trap fehlt, Kontrast |
| Responsive | HIGH: 1 | Touch Targets zu klein |
| Performance | OK | LCP 1.8s, CLS 0.04 |
| Konsistenz | MEDIUM: 3 | Spacing inkonsistent |
| Browser | OK | Alle Target Browsers geprueft |

### CRITICAL

1. **Modal ohne Focus Trap** - `ConfirmDialog.tsx`
   - Keyboard-User koennen hinter Modal tabben
   - Fix: `useFocusTrap` Hook implementieren

2. **Kontrast 2.1:1** - `StatusBadge.tsx`
   - Gelber Text auf weissem Hintergrund
   - Fix: Dunkleres Gelb (#92400E) oder Hintergrund aendern

### HIGH / MEDIUM / LOW
...

### Automatisierte Ergebnisse
- Lighthouse Score: Performance 92, Accessibility 78, Best Practices 95
- axe-core: 3 Violations, 2 Incomplete
- Bundle Size: 187KB gzipped (OK)
```

## Checkliste Quick-Scan

Fuer schnelle Pruefung ohne vollstaendigen Audit:

- [ ] Tab durch die gesamte Seite: Alles erreichbar? Focus sichtbar?
- [ ] Browser-Zoom auf 200%: Layout noch brauchbar?
- [ ] DevTools -> 320px Viewport: Kein horizontaler Scroll?
- [ ] Lighthouse Score > 90 in allen Kategorien?
- [ ] Farbkontrast-Check mit Browser DevTools
- [ ] Network Tab: Groesste Requests identifizieren
