---
name: design-system
description: Design Tokens, Component Library aufbauen, Theming-Strategie. Von CSS Variables bis Figma Sync.
allowed-tools: Bash,Read,Write,Edit,Glob,Grep
---

# Design System Skill

Aufbau und Pflege eines Design Systems. Design Tokens, Component Library Architektur, Theming (Dark Mode, Multi-Brand) und Dokumentation mit Storybook.

## Design Tokens

Design Tokens sind die atomaren Werte des Design Systems. Farben, Spacing, Typographie, Schatten, Breakpoints -- alles zentral definiert, ueberall konsistent.

### Token-Hierarchie

```
Global Tokens (primitiv)     -> blue-500: #3B82F6
  Alias Tokens (semantisch)  -> color-primary: {blue-500}
    Component Tokens          -> button-bg: {color-primary}
```

### Naming Convention

```
{category}-{property}-{variant}-{state}

Beispiele:
  color-text-primary
  color-text-secondary
  color-bg-surface
  color-bg-surface-hover
  color-border-default
  color-border-error
  spacing-xs          (4px)
  spacing-sm          (8px)
  spacing-md          (16px)
  spacing-lg          (24px)
  spacing-xl          (32px)
  radius-sm           (4px)
  radius-md           (8px)
  radius-full         (9999px)
  shadow-sm
  shadow-md
  shadow-lg
  font-size-sm
  font-size-base
  font-size-lg
  font-weight-normal
  font-weight-semibold
  font-weight-bold
```

### CSS Custom Properties

```css
/* tokens/colors.css */
:root {
  /* Primitive Tokens */
  --blue-50: #EFF6FF;
  --blue-500: #3B82F6;
  --blue-600: #2563EB;
  --blue-700: #1D4ED8;
  --gray-50: #F9FAFB;
  --gray-100: #F3F4F6;
  --gray-700: #374151;
  --gray-900: #111827;

  /* Semantic Tokens (Light Theme) */
  --color-primary: var(--blue-600);
  --color-primary-hover: var(--blue-700);
  --color-text-primary: var(--gray-900);
  --color-text-secondary: var(--gray-700);
  --color-bg-page: var(--gray-50);
  --color-bg-surface: #FFFFFF;
  --color-bg-surface-hover: var(--gray-100);
  --color-border-default: var(--gray-200);
  --color-border-focus: var(--blue-500);
}

/* tokens/spacing.css */
:root {
  --spacing-0: 0;
  --spacing-1: 0.25rem;   /* 4px */
  --spacing-2: 0.5rem;    /* 8px */
  --spacing-3: 0.75rem;   /* 12px */
  --spacing-4: 1rem;      /* 16px */
  --spacing-6: 1.5rem;    /* 24px */
  --spacing-8: 2rem;      /* 32px */
  --spacing-12: 3rem;     /* 48px */
  --spacing-16: 4rem;     /* 64px */
}

/* tokens/typography.css */
:root {
  --font-family-sans: 'Inter', system-ui, -apple-system, sans-serif;
  --font-family-mono: 'JetBrains Mono', ui-monospace, monospace;
  --font-size-xs: 0.75rem;    /* 12px */
  --font-size-sm: 0.875rem;   /* 14px */
  --font-size-base: 1rem;     /* 16px */
  --font-size-lg: 1.125rem;   /* 18px */
  --font-size-xl: 1.25rem;    /* 20px */
  --font-size-2xl: 1.5rem;    /* 24px */
  --font-size-3xl: 1.875rem;  /* 30px */
  --line-height-tight: 1.25;
  --line-height-normal: 1.5;
  --line-height-relaxed: 1.75;
}
```

### Tailwind Config als Token-Quelle

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss';

export default {
  theme: {
    colors: {
      primary: {
        DEFAULT: 'var(--color-primary)',
        hover: 'var(--color-primary-hover)',
      },
      text: {
        primary: 'var(--color-text-primary)',
        secondary: 'var(--color-text-secondary)',
      },
      bg: {
        page: 'var(--color-bg-page)',
        surface: 'var(--color-bg-surface)',
      },
      border: {
        DEFAULT: 'var(--color-border-default)',
        focus: 'var(--color-border-focus)',
      },
    },
    spacing: {
      0: 'var(--spacing-0)',
      1: 'var(--spacing-1)',
      2: 'var(--spacing-2)',
      3: 'var(--spacing-3)',
      4: 'var(--spacing-4)',
      6: 'var(--spacing-6)',
      8: 'var(--spacing-8)',
      12: 'var(--spacing-12)',
      16: 'var(--spacing-16)',
    },
    borderRadius: {
      sm: 'var(--radius-sm)',
      md: 'var(--radius-md)',
      full: 'var(--radius-full)',
    },
  },
} satisfies Config;
```

## Component Library Architektur

### 3-Ebenen-Modell

```
Primitives (Atoms)
  -> Button, Input, Badge, Avatar, Icon
  -> Keine Business-Logik, rein visuell
  -> Alle Varianten ueber Props

Composites (Molecules)
  -> FormField (Label + Input + Error), Card, Dialog, Dropdown
  -> Kombinieren Primitives
  -> Generische Interaktionslogik

Patterns (Organisms)
  -> DataTable, FilterBar, SearchCommand, NavigationMenu
  -> Komplexe UI-Patterns
  -> Wiederverwendbar ueber Features
```

### Ordnerstruktur

```
src/
  design-system/
    tokens/
      colors.css
      spacing.css
      typography.css
      shadows.css
      index.css           # @import aller Token-Dateien
    primitives/
      Button/
        Button.tsx
        Button.test.tsx
        Button.stories.tsx
        button.variants.ts  # cva() Varianten
        index.ts
      Input/
        ...
      Badge/
        ...
    composites/
      FormField/
        ...
      Dialog/
        ...
      Card/
        ...
    patterns/
      DataTable/
        ...
      SearchCommand/
        ...
    index.ts              # Public API
```

### Component API Design

```typescript
// Varianten mit class-variance-authority (cva)
import { cva, type VariantProps } from 'class-variance-authority';

const buttonVariants = cva(
  // Base classes
  'inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50',
  {
    variants: {
      variant: {
        primary: 'bg-primary text-white hover:bg-primary-hover',
        secondary: 'bg-bg-surface border border-border hover:bg-bg-surface-hover',
        ghost: 'hover:bg-bg-surface-hover',
        destructive: 'bg-red-600 text-white hover:bg-red-700',
      },
      size: {
        sm: 'h-8 px-3 text-sm',
        md: 'h-10 px-4 text-sm',
        lg: 'h-12 px-6 text-base',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md',
    },
  }
);

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  loading?: boolean;
}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, loading, disabled, children, ...props }, ref) => (
    <button
      ref={ref}
      className={cn(buttonVariants({ variant, size }), className)}
      disabled={disabled || loading}
      {...props}
    >
      {loading && <Spinner className="mr-2 h-4 w-4" />}
      {children}
    </button>
  )
);
Button.displayName = 'Button';
```

### Composable API (Compound Components)

```typescript
// Dialog mit Compound Components
<Dialog open={open} onOpenChange={setOpen}>
  <Dialog.Trigger asChild>
    <Button>Oeffnen</Button>
  </Dialog.Trigger>
  <Dialog.Content>
    <Dialog.Header>
      <Dialog.Title>Titel</Dialog.Title>
      <Dialog.Description>Beschreibung</Dialog.Description>
    </Dialog.Header>
    <div>Inhalt</div>
    <Dialog.Footer>
      <Dialog.Close asChild>
        <Button variant="secondary">Abbrechen</Button>
      </Dialog.Close>
      <Button onClick={handleConfirm}>Bestaetigen</Button>
    </Dialog.Footer>
  </Dialog.Content>
</Dialog>
```

## Theming

### Dark Mode mit CSS Custom Properties

```css
/* Tokens schalten, Layout bleibt gleich */
[data-theme='dark'] {
  --color-primary: var(--blue-500);
  --color-primary-hover: var(--blue-600);
  --color-text-primary: var(--gray-50);
  --color-text-secondary: var(--gray-300);
  --color-bg-page: var(--gray-950);
  --color-bg-surface: var(--gray-900);
  --color-bg-surface-hover: var(--gray-800);
  --color-border-default: var(--gray-700);
  --color-border-focus: var(--blue-400);
}
```

### Theme Provider

```typescript
type Theme = 'light' | 'dark' | 'system';

const ThemeContext = createContext<{
  theme: Theme;
  setTheme: (theme: Theme) => void;
} | null>(null);

function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<Theme>(() => {
    if (typeof window === 'undefined') return 'system';
    return (localStorage.getItem('theme') as Theme) ?? 'system';
  });

  useEffect(() => {
    const root = document.documentElement;
    const systemDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const resolved = theme === 'system' ? (systemDark ? 'dark' : 'light') : theme;

    root.setAttribute('data-theme', resolved);
    localStorage.setItem('theme', theme);
  }, [theme]);

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}
```

### Multi-Brand Theming

```css
/* Brand A */
[data-brand='alpha'] {
  --color-primary: #6366F1;      /* Indigo */
  --color-primary-hover: #4F46E5;
  --font-family-sans: 'Outfit', sans-serif;
  --radius-md: 12px;             /* Rounded Look */
}

/* Brand B */
[data-brand='beta'] {
  --color-primary: #059669;      /* Emerald */
  --color-primary-hover: #047857;
  --font-family-sans: 'IBM Plex Sans', sans-serif;
  --radius-md: 4px;              /* Sharp Look */
}
```

## Dokumentation mit Storybook

### Story Struktur

```typescript
// Button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  title: 'Primitives/Button',
  component: Button,
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'ghost', 'destructive'],
    },
    size: { control: 'select', options: ['sm', 'md', 'lg'] },
    loading: { control: 'boolean' },
    disabled: { control: 'boolean' },
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: { children: 'Button', variant: 'primary' },
};

export const AllVariants: Story = {
  render: () => (
    <div className="flex gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="ghost">Ghost</Button>
      <Button variant="destructive">Destructive</Button>
    </div>
  ),
};

export const Loading: Story = {
  args: { children: 'Speichern', loading: true },
};
```

### Dokumentations-Ebenen

| Ebene | Inhalt | Tooling |
|-------|--------|---------|
| Token Reference | Alle Tokens mit Vorschau | Storybook Token Addon |
| Component Docs | Props, Varianten, Usage | Storybook autodocs |
| Pattern Docs | Wann welches Pattern nutzen | MDX Stories |
| Changelog | Aenderungen pro Version | Storybook Release Notes |

## Migration bestehender Projekte

### Schrittweise Migration

```
Phase 1: Tokens definieren
  - Farben, Spacing, Typographie als CSS Variables
  - Tailwind Config auf Tokens umstellen
  - Magic Values durch Tokens ersetzen

Phase 2: Primitives extrahieren
  - Button, Input, Badge etc. aus bestehendem Code
  - Tests und Stories schreiben
  - Bestehende Stellen migrieren

Phase 3: Composites aufbauen
  - FormField, Card, Dialog etc.
  - Duplikate identifizieren und konsolidieren

Phase 4: Patterns dokumentieren
  - Haeufige UI-Patterns als Komponenten
  - Usage Guidelines in Storybook

Phase 5: Theming
  - Dark Mode
  - Multi-Brand (wenn noetig)
```

### Token-Audit fuer bestehenden Code

```bash
# Alle Hex-Farben finden (sollten Tokens sein)
grep -rn '#[0-9a-fA-F]\{3,8\}' src/ --include="*.tsx" --include="*.css"

# Alle Magic Spacing Values finden
grep -rn 'margin:\|padding:\|gap:' src/ --include="*.css" | grep -v 'var('

# Alle hardcoded Font Sizes
grep -rn 'font-size:' src/ --include="*.css" | grep -v 'var('
```

## Anti-Patterns

| Anti-Pattern | Problem | Loesung |
|--------------|---------|---------|
| Hex-Werte direkt im Code | Inkonsistenz, Dark Mode bricht | Design Tokens verwenden |
| Zu viele Varianten | Component wird unwartbar | Max 3-4 Varianten pro Prop |
| Props-Explosion (15+ Props) | Unverstaendliche API | Compound Components nutzen |
| `!important` ueberall | Spezifitaets-Krieg | Tokens + cva() Varianten |
| Copy-Paste Components | Drift zwischen Kopien | Shared Component Library |
| Token ohne semantische Ebene | `blue-500` sagt nichts ueber Verwendung | Alias Tokens (color-primary) |
| Storybook veraltet | Doku stimmt nicht mit Code | Stories in CI pruefen |

## Checkliste

- [ ] Alle Farben, Spacing, Typographie als Tokens definiert
- [ ] Semantische Token-Ebene vorhanden (nicht nur Primitives)
- [ ] Naming Convention dokumentiert und konsistent
- [ ] Primitives haben Tests und Stories
- [ ] Composites nutzen ausschliesslich Primitives
- [ ] Dark Mode funktioniert durch Token-Switch
- [ ] Kein Hex/RGB direkt in Components
- [ ] Storybook aktuell und in CI geprueft
- [ ] Migration-Plan fuer bestehenden Code vorhanden
