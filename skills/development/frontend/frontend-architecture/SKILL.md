---
name: frontend-architecture
description: Component Architecture Patterns, State Management Strategien, Data Flow Design fuer React/Next.js/Vue Projekte.
allowed-tools: Bash,Read,Write,Edit,Glob,Grep
---

# Frontend Architecture Skill

Systematische Anleitung fuer skalierbare Frontend-Architekturen. Component Hierarchien, State Management Entscheidungen, Data Fetching Patterns und Performance-Optimierung.

## Component Hierarchy Patterns

### Container/Presentational Pattern

Trennung von Logik und Darstellung. Container kuemmern sich um Daten und State, Presentational Components sind rein visuell.

```typescript
// Container: Logik + Daten
function DealListContainer() {
  const { data, isLoading, error } = useDeals();
  const [filter, setFilter] = useState<DealFilter>({});

  if (isLoading) return <DealListSkeleton />;
  if (error) return <ErrorBanner message={error.message} />;

  return <DealList deals={data} filter={filter} onFilterChange={setFilter} />;
}

// Presentational: Nur Darstellung, vollstaendig ueber Props gesteuert
interface DealListProps {
  deals: Deal[];
  filter: DealFilter;
  onFilterChange: (filter: DealFilter) => void;
}

function DealList({ deals, filter, onFilterChange }: DealListProps) {
  return (
    <div>
      <FilterBar value={filter} onChange={onFilterChange} />
      {deals.map(deal => <DealCard key={deal.id} deal={deal} />)}
    </div>
  );
}
```

### Compound Components Pattern

Zusammengehoerige Components, die sich einen impliziten State teilen. Ideal fuer flexible APIs (Tabs, Accordions, Dropdowns).

```typescript
// API: <Select> <Select.Trigger /> <Select.Options> <Select.Option /> </Select.Options> </Select>
const SelectContext = createContext<SelectContextValue | null>(null);

function Select({ children, value, onChange }: SelectProps) {
  const [open, setOpen] = useState(false);
  return (
    <SelectContext.Provider value={{ open, setOpen, value, onChange }}>
      <div className="relative">{children}</div>
    </SelectContext.Provider>
  );
}

Select.Trigger = function SelectTrigger({ children }: { children: ReactNode }) {
  const ctx = useSelectContext();
  return <button onClick={() => ctx.setOpen(!ctx.open)}>{children}</button>;
};

Select.Option = function SelectOption({ value, children }: OptionProps) {
  const ctx = useSelectContext();
  return (
    <li
      role="option"
      aria-selected={ctx.value === value}
      onClick={() => { ctx.onChange(value); ctx.setOpen(false); }}
    >
      {children}
    </li>
  );
};
```

### Render Props / Headless Components

Logik ohne UI. Der Consumer entscheidet ueber die Darstellung.

```typescript
function useToggle(initial = false) {
  const [on, setOn] = useState(initial);
  const toggle = useCallback(() => setOn(prev => !prev), []);
  const setTrue = useCallback(() => setOn(true), []);
  const setFalse = useCallback(() => setOn(false), []);
  return { on, toggle, setTrue, setFalse } as const;
}

// Headless Disclosure
function Disclosure({ children }: { children: (state: DisclosureState) => ReactNode }) {
  const state = useToggle();
  return <>{children(state)}</>;
}
```

## State Management Decision Tree

```
Braucht nur 1 Component den State?
  -> YES: useState / useReducer (lokal)

Brauchen Parent + wenige Children den State?
  -> YES: Props Drilling (max 2-3 Ebenen)

Braucht ein Subtree den State?
  -> YES: React Context + useReducer

Braucht die ganze App den State?
  -> YES: Zustand / Jotai / Redux Toolkit

Kommt der State vom Server?
  -> YES: React Query / SWR / Server Components (KEIN globaler Store!)
```

### Regeln

| Regel | Erklaerung |
|-------|------------|
| Server State != Client State | API-Daten gehoeren in React Query, nicht in Zustand |
| Context ist kein State Manager | Context fuer seltene Updates (Theme, Auth, Locale) |
| Kein Global Store fuer Forms | Formular-State bleibt lokal (react-hook-form) |
| Derived State berechnen, nicht speichern | `useMemo` statt separatem State |

```typescript
// FALSCH: Server State im globalen Store
const useStore = create((set) => ({
  deals: [],
  fetchDeals: async () => {
    const deals = await api.getDeals();
    set({ deals }); // Manuelles Cache Management - fehleranfaellig
  },
}));

// RICHTIG: React Query fuer Server State
function useDeals(filter?: DealFilter) {
  return useQuery({
    queryKey: ['deals', filter],
    queryFn: () => api.getDeals(filter),
    placeholderData: [],
    staleTime: 30_000,
  });
}
```

## Data Fetching Patterns

### React Query / TanStack Query

```typescript
// Query mit abhaengigem Query
function useDealWithContacts(dealId: string) {
  const dealQuery = useQuery({
    queryKey: ['deals', dealId],
    queryFn: () => api.getDeal(dealId),
  });

  const contactsQuery = useQuery({
    queryKey: ['deals', dealId, 'contacts'],
    queryFn: () => api.getDealContacts(dealId),
    enabled: !!dealQuery.data, // Nur fetchen wenn Deal geladen
  });

  return { deal: dealQuery, contacts: contactsQuery };
}
```

### Optimistic Updates

```typescript
function useUpdateDealStage() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ dealId, stage }: { dealId: string; stage: string }) =>
      api.updateDeal(dealId, { stage }),
    onMutate: async ({ dealId, stage }) => {
      await queryClient.cancelQueries({ queryKey: ['deals'] });
      const previous = queryClient.getQueryData<Deal[]>(['deals']);

      queryClient.setQueryData<Deal[]>(['deals'], old =>
        (old ?? []).map(d => d.id === dealId ? { ...d, stage } : d)
      );

      return { previous };
    },
    onError: (_err, _vars, context) => {
      if (context?.previous) {
        queryClient.setQueryData(['deals'], context.previous);
      }
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['deals'] });
    },
  });
}
```

### Server Components (Next.js App Router)

```typescript
// Server Component: Daten direkt laden, kein Client-Bundle
async function DealsPage({ searchParams }: { searchParams: Promise<{ stage?: string }> }) {
  const params = await searchParams;
  const deals = await getDeals({ stage: params.stage });

  return (
    <main>
      <Suspense fallback={<DealListSkeleton />}>
        <DealList deals={deals} />
      </Suspense>
      {/* Client Component fuer Interaktivitaet */}
      <DealFilterSidebar />
    </main>
  );
}
```

## File Organisation

### Feature-basiert (empfohlen)

```
src/
  features/
    deals/
      components/
        DealCard.tsx
        DealList.tsx
        DealForm/
          DealForm.tsx
          DealFormFields.tsx
          DealForm.test.tsx
      hooks/
        useDeals.ts
        useDealMutation.ts
      api/
        deals.api.ts
        deals.types.ts
      utils/
        deal-calculations.ts
      index.ts          # Public API des Features
    contacts/
      ...
  shared/
    components/         # App-weite UI Components (Button, Modal, ...)
    hooks/              # App-weite Hooks (useDebounce, useMediaQuery)
    lib/                # Utilities (formatCurrency, date helpers)
```

### Barrel Exports

```typescript
// features/deals/index.ts - Public API
export { DealCard } from './components/DealCard';
export { DealList } from './components/DealList';
export { useDeals } from './hooks/useDeals';
export type { Deal, DealFilter } from './api/deals.types';

// Alles andere ist "private" - nicht von aussen importieren
```

## Performance Patterns

### React.memo - Wann sinnvoll

```typescript
// SINNVOLL: Teure Render-Komponente in einer Liste
const DealCard = memo(function DealCard({ deal }: { deal: Deal }) {
  return <ExpensiveVisualization data={deal} />;
});

// NICHT SINNVOLL: Einfache Komponente, die sowieso immer neu rendert
// const Button = memo(({ onClick, children }) => ...); // Overhead > Nutzen
```

### Code Splitting

```typescript
// Route-basiertes Splitting
const DealsDashboard = lazy(() => import('./features/deals/pages/DealsDashboard'));
const AnalyticsPage = lazy(() => import('./features/analytics/pages/AnalyticsPage'));

// Component-basiertes Splitting fuer schwere Abhaengigkeiten
const HeavyChart = lazy(() => import('./components/HeavyChart'));

function Dashboard() {
  return (
    <Suspense fallback={<ChartSkeleton />}>
      <HeavyChart data={chartData} />
    </Suspense>
  );
}
```

### Virtualisierung fuer grosse Listen

```typescript
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualDealList({ deals }: { deals: Deal[] }) {
  const parentRef = useRef<HTMLDivElement>(null);

  const virtualizer = useVirtualizer({
    count: deals.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 72,
  });

  return (
    <div ref={parentRef} style={{ height: '600px', overflow: 'auto' }}>
      <div style={{ height: `${virtualizer.getTotalSize()}px`, position: 'relative' }}>
        {virtualizer.getVirtualItems().map(virtualRow => (
          <div
            key={virtualRow.key}
            style={{
              position: 'absolute',
              top: 0,
              transform: `translateY(${virtualRow.start}px)`,
              width: '100%',
            }}
          >
            <DealCard deal={deals[virtualRow.index]} />
          </div>
        ))}
      </div>
    </div>
  );
}
```

## Anti-Patterns

| Anti-Pattern | Problem | Loesung |
|--------------|---------|---------|
| Prop Drilling 5+ Ebenen | Unlesbar, fragil | Context oder Composition |
| God Component (500+ Zeilen) | Nicht testbar, nicht wartbar | Aufteilen in Sub-Components |
| useEffect fuer Derived State | Unnoetige Re-Renders | `useMemo` oder direkt berechnen |
| State Synchronisation | Race Conditions, Inkonsistenz | Single Source of Truth |
| Business Logic in Components | Nicht testbar | Custom Hooks / Service Layer |
| Conditional Hooks | React Rules Violation | Hooks immer aufrufen, Logik im Hook |
| Index als Key in dynamischen Listen | Falsche Re-Renders | Stabile ID verwenden |

```typescript
// FALSCH: useEffect fuer derived State
const [items, setItems] = useState<Item[]>([]);
const [total, setTotal] = useState(0);
useEffect(() => {
  setTotal(items.reduce((sum, i) => sum + i.price, 0));
}, [items]); // Doppelter Render!

// RICHTIG: Direkt berechnen
const [items, setItems] = useState<Item[]>([]);
const total = useMemo(() => items.reduce((sum, i) => sum + i.price, 0), [items]);
```

## Checkliste

- [ ] Component Hierarchie: Max 3-4 Ebenen Tiefe
- [ ] State: Server State in React Query, Client State lokal/Zustand
- [ ] Kein Prop Drilling ueber 3 Ebenen
- [ ] Feature-basierte Ordnerstruktur
- [ ] Barrel Exports fuer Public APIs
- [ ] Lazy Loading fuer Routes und schwere Components
- [ ] Listen > 100 Items virtualisiert
- [ ] Keine Business Logik in Components
- [ ] Error + Loading + Empty States ueberall
