---
name: responsive-design
description: Mobile-First Responsive Design - Breakpoints, Container Queries, Fluid Typography, Touch-Optimierung.
allowed-tools: Bash,Read,Write,Edit,Glob,Grep
---

# Responsive Design Skill

Mobile-First Responsive Design systematisch umsetzen. Breakpoint-Strategie, Container Queries, Fluid Typography, responsive Bilder und Touch-Optimierung.

## Mobile-First Methodologie

Immer mit dem kleinsten Viewport starten. Desktop-Styles erweitern, nicht Mobile einschraenken.

```css
/* RICHTIG: Mobile-First (min-width) */
.card {
  padding: var(--spacing-4);          /* Mobile: Default */
  display: grid;
  grid-template-columns: 1fr;
}

@media (min-width: 768px) {
  .card {
    padding: var(--spacing-6);        /* Tablet: Mehr Platz */
    grid-template-columns: 1fr 1fr;
  }
}

@media (min-width: 1024px) {
  .card {
    padding: var(--spacing-8);        /* Desktop: Noch mehr */
    grid-template-columns: 1fr 1fr 1fr;
  }
}

/* FALSCH: Desktop-First (max-width) - fuehrt zu Override-Chaos */
.card {
  padding: var(--spacing-8);
  grid-template-columns: 1fr 1fr 1fr;
}
@media (max-width: 1023px) { ... }   /* Override */
@media (max-width: 767px) { ... }    /* Override Override */
```

## Breakpoint-Strategie

### Standard Breakpoints

```typescript
// Tailwind-kompatibel
const breakpoints = {
  sm: '640px',     // Grosses Smartphone (Landscape)
  md: '768px',     // Tablet
  lg: '1024px',    // Desktop
  xl: '1280px',    // Grosser Desktop
  '2xl': '1536px', // Ultrawide
} as const;
```

### Breakpoints als CSS Custom Properties

```css
:root {
  --bp-sm: 640px;
  --bp-md: 768px;
  --bp-lg: 1024px;
  --bp-xl: 1280px;
}
```

### Breakpoint-Entscheidungen

| Breakpoint | Typische Aenderungen |
|------------|---------------------|
| < 640px | Single Column, Stack Navigation, Full-Width Buttons |
| 640-767px | 2-Column moeglich, Navigation weiterhin mobil |
| 768-1023px | Sidebar moeglich, Tablet Navigation |
| 1024-1279px | Full Desktop Layout, Fixed Sidebar |
| >= 1280px | Max-Width Container, groessere Abstände |

### Wann KEINE Breakpoints verwenden

In vielen Faellen sind Breakpoints der falsche Ansatz. Fluid Layouts mit `minmax()`, `clamp()` und Container Queries sind oft besser.

## Container Queries

Container Queries reagieren auf die Groesse des Parent-Elements statt des Viewports. Ideal fuer wiederverwendbare Components.

```css
/* Container definieren */
.card-container {
  container-type: inline-size;
  container-name: card;
}

/* Component reagiert auf Container-Groesse */
.card-content {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--spacing-2);
}

@container card (min-width: 400px) {
  .card-content {
    grid-template-columns: auto 1fr;
    gap: var(--spacing-4);
  }
}

@container card (min-width: 600px) {
  .card-content {
    grid-template-columns: auto 1fr auto;
  }
}
```

### Wann Container Queries vs Media Queries

| Situation | Empfehlung |
|-----------|------------|
| Page Layout (Header, Sidebar) | Media Query |
| Wiederverwendbare Component | Container Query |
| Component in verschiedenen Layouts | Container Query |
| Globale Navigation | Media Query |
| Card in Grid + Sidebar + Modal | Container Query |

## Fluid Typography

Font-Groessen, die sich stufenlos zwischen Viewport-Grenzen interpolieren.

```css
/* clamp(minimum, preferred, maximum) */
:root {
  --font-size-base: clamp(1rem, 0.925rem + 0.375vw, 1.125rem);
  --font-size-lg: clamp(1.125rem, 1rem + 0.5vw, 1.375rem);
  --font-size-xl: clamp(1.25rem, 1rem + 1vw, 1.75rem);
  --font-size-2xl: clamp(1.5rem, 1rem + 2vw, 2.5rem);
  --font-size-3xl: clamp(1.875rem, 1rem + 3vw, 3.5rem);
}

/* Anwendung */
h1 { font-size: var(--font-size-3xl); }
h2 { font-size: var(--font-size-2xl); }
h3 { font-size: var(--font-size-xl); }
body { font-size: var(--font-size-base); }
```

### Fluid Spacing

```css
:root {
  /* Spacing skaliert auch mit dem Viewport */
  --spacing-fluid-sm: clamp(0.5rem, 0.4rem + 0.5vw, 1rem);
  --spacing-fluid-md: clamp(1rem, 0.75rem + 1vw, 2rem);
  --spacing-fluid-lg: clamp(1.5rem, 1rem + 2vw, 3rem);
  --spacing-fluid-xl: clamp(2rem, 1rem + 4vw, 5rem);
}

/* Section Spacing */
section {
  padding-block: var(--spacing-fluid-xl);
}
```

## Responsive Bilder

### srcset und sizes

```html
<!-- Browser waehlt optimale Groesse basierend auf Viewport und DPR -->
<img
  src="/images/hero-800.jpg"
  srcset="
    /images/hero-400.jpg   400w,
    /images/hero-800.jpg   800w,
    /images/hero-1200.jpg 1200w,
    /images/hero-1600.jpg 1600w
  "
  sizes="
    (min-width: 1024px) 50vw,
    100vw
  "
  alt="Hero Image"
  width="1600"
  height="900"
  loading="lazy"
/>
```

### Next.js Image

```typescript
import Image from 'next/image';

// Responsive Hero
<Image
  src="/hero.jpg"
  alt="Hero"
  fill
  sizes="100vw"
  priority                    // Above the Fold = kein lazy loading
  className="object-cover"
/>

// Responsive in Grid
<Image
  src={product.image}
  alt={product.name}
  width={400}
  height={300}
  sizes="(min-width: 1024px) 25vw, (min-width: 768px) 50vw, 100vw"
/>
```

### Art Direction mit `<picture>`

```html
<!-- Verschiedene Bilder fuer verschiedene Viewports -->
<picture>
  <source media="(min-width: 1024px)" srcset="/hero-wide.avif" type="image/avif" />
  <source media="(min-width: 1024px)" srcset="/hero-wide.webp" type="image/webp" />
  <source media="(min-width: 640px)" srcset="/hero-medium.webp" type="image/webp" />
  <img src="/hero-mobile.jpg" alt="Hero" width="800" height="600" />
</picture>
```

## Touch Target Sizing

### Mindestgroessen

```css
/* WCAG 2.2: Mindestens 24x24px, Empfehlung 44x44px */
/* Material Design: 48x48px */
/* Apple HIG: 44x44pt */

/* Empfehlung: 44px Minimum, 48px ideal */
.touch-target {
  min-height: 44px;
  min-width: 44px;
  padding: var(--spacing-2);
}

/* Kleines visuelles Element mit grossem Touch Target */
.icon-button {
  position: relative;
  width: 24px;
  height: 24px;
}

.icon-button::before {
  content: '';
  position: absolute;
  inset: -12px;    /* 24px + 2*12px = 48px Touch Target */
}
```

### Abstaende zwischen Touch Targets

```css
/* Mindestens 8px Abstand zwischen klickbaren Elementen */
.action-bar {
  display: flex;
  gap: var(--spacing-2);  /* 8px */
}

/* Navigation Links */
.nav-list {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.nav-link {
  padding: var(--spacing-3) var(--spacing-4);  /* 12px 16px - ergibt 48px Hoehe */
}
```

## Layout Patterns

### Stack Pattern (vertikales Layout)

```css
.stack {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

/* Variante: Stack mit Auto-Spacing (letztes Element nach unten) */
.stack-spread > :last-child {
  margin-top: auto;
}
```

### Sidebar Pattern

```css
/* Sidebar bricht auf Mobile in Single Column um */
.sidebar-layout {
  display: flex;
  flex-wrap: wrap;
  gap: var(--spacing-6);
}

.sidebar-layout > :first-child {
  flex-basis: 300px;    /* Sidebar Breite */
  flex-grow: 1;
}

.sidebar-layout > :last-child {
  flex-basis: 0;
  flex-grow: 999;       /* Nimmt restlichen Platz */
  min-width: 50%;       /* Bricht um wenn < 50% */
}
```

### Responsive Grid (Auto-Fill)

```css
/* Grid passt sich automatisch an - keine Breakpoints noetig */
.auto-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(min(280px, 100%), 1fr));
  gap: var(--spacing-4);
}

/* Mit fester Spaltenzahl pro Breakpoint */
.fixed-grid {
  display: grid;
  gap: var(--spacing-4);
  grid-template-columns: 1fr;
}

@media (min-width: 640px) {
  .fixed-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (min-width: 1024px) {
  .fixed-grid { grid-template-columns: repeat(3, 1fr); }
}
```

### Holy Grail Layout

```css
.page-layout {
  display: grid;
  grid-template-areas:
    "header"
    "main"
    "footer";
  grid-template-rows: auto 1fr auto;
  min-height: 100dvh;                /* dvh statt vh fuer Mobile */
}

@media (min-width: 768px) {
  .page-layout {
    grid-template-areas:
      "header header"
      "nav    main"
      "footer footer";
    grid-template-columns: 250px 1fr;
  }
}

@media (min-width: 1024px) {
  .page-layout {
    grid-template-areas:
      "header header  header"
      "nav    main    aside"
      "footer footer  footer";
    grid-template-columns: 250px 1fr 300px;
  }
}
```

## CSS Grid vs Flexbox

| Kriterium | Flexbox | Grid |
|-----------|---------|------|
| Dimension | 1D (Zeile ODER Spalte) | 2D (Zeilen UND Spalten) |
| Content vs Layout | Content bestimmt Groesse | Layout bestimmt Groesse |
| Use Case | Navigation, Toolbars, Inline-Elemente | Page Layouts, Card Grids, Dashboards |
| Alignment | Gut fuer Centering, Distribution | Gut fuer praezise Platzierung |
| Wrapping | `flex-wrap` (Items bestimmen Umbruch) | `auto-fill`/`auto-fit` (Grid bestimmt) |

```css
/* Flexbox: Toolbar mit verteilten Items */
.toolbar {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
}
.toolbar > :last-child {
  margin-left: auto;
}

/* Grid: Dashboard mit benannten Areas */
.dashboard {
  display: grid;
  grid-template-areas:
    "kpi    kpi    kpi"
    "chart  chart  table"
    "chart  chart  table";
  grid-template-columns: 1fr 1fr 1fr;
  gap: var(--spacing-4);
}
```

## Responsive Design testen

### DevTools

```
Chrome DevTools:
  - Device Toolbar (Ctrl+Shift+M)
  - Responsive Mode mit freiem Resize
  - Throttling fuer langsame Verbindungen
  - DPR-Simulation

Firefox:
  - Responsive Design Mode (Ctrl+Shift+M)
  - Touch Simulation
```

### Automatisiert

```typescript
// Playwright Visual Regression
const viewports = [
  { width: 320, height: 568, name: 'mobile-small' },
  { width: 375, height: 812, name: 'mobile' },
  { width: 768, height: 1024, name: 'tablet' },
  { width: 1024, height: 768, name: 'desktop' },
  { width: 1440, height: 900, name: 'desktop-large' },
];

for (const vp of viewports) {
  test(`homepage renders at ${vp.name}`, async ({ page }) => {
    await page.setViewportSize({ width: vp.width, height: vp.height });
    await page.goto('/');
    await expect(page).toHaveScreenshot(`homepage-${vp.name}.png`);
  });
}
```

### Physische Geraete

Immer auf echten Geraeten testen. Emulatoren ersetzen nicht das echte Verhalten:
- iOS Safari hat eigene Scrolling-Mechanik
- Android Chrome behandelt `100vh` anders
- Touch-Gesten sind auf echten Screens anders

## Anti-Patterns

| Anti-Pattern | Problem | Loesung |
|--------------|---------|---------|
| Desktop-First | Override-Kaskade, vergessene Mobile-Styles | Mobile-First (min-width) |
| Pixel-basierte Schriftgroessen | Ignoriert User-Zoom | `rem`/`clamp()` verwenden |
| `100vh` auf Mobile | Adressleiste wird nicht beruecksichtigt | `100dvh` oder `100svh` |
| Hidden Content auf Mobile | Inhalte versteckt statt angepasst | Responsive Layouts nutzen |
| Hover-only Interaktionen | Nicht auf Touch verfuegbar | `:hover` nur als Enhancement |
| Feste Breiten (`width: 500px`) | Bricht auf kleinen Screens | `max-width` + `width: 100%` |
| Fehlende Viewport Meta | Seite wird gezoomt dargestellt | `<meta name="viewport">` |
| `user-scalable=no` | Accessibility-Verstoss | Entfernen, Zoom erlauben |
| Bilder ohne Dimensionen | CLS (Layout Shift) | `width`/`height` oder `aspect-ratio` |

```css
/* FALSCH: Hover-only */
.tooltip { display: none; }
.trigger:hover .tooltip { display: block; }

/* RICHTIG: Hover als Enhancement, Focus als Alternative */
.tooltip { display: none; }
.trigger:hover .tooltip,
.trigger:focus-within .tooltip {
  display: block;
}
/* Oder: Tap-to-Toggle auf Touch */
```

## Checkliste

- [ ] Mobile-First: Basis-Styles = Mobile, erweitern mit `min-width`
- [ ] Viewport Meta Tag korrekt gesetzt (kein `user-scalable=no`)
- [ ] Kein horizontaler Scroll bei 320px Breite
- [ ] Touch Targets >= 44px, Abstand >= 8px
- [ ] Fluid Typography mit `clamp()`
- [ ] Bilder responsive (`srcset`/`sizes` oder `next/image`)
- [ ] Bilder haben explizite Dimensionen (kein CLS)
- [ ] `100dvh` statt `100vh` auf Mobile
- [ ] Container Queries fuer wiederverwendbare Components
- [ ] Layout mit CSS Grid/Flexbox, keine festen Breiten
- [ ] Getestet auf echten Geraeten (min. 1x iOS, 1x Android)
- [ ] Keine Hover-only Interaktionen
