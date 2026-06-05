# Component Patterns

Modern React component architecture for the application emphasizing type safety, lazy loading, and Suspense boundaries.

---

## Lazy Loading Pattern

### When to Lazy Load

Lazy load components that are:
- Heavy (DataGrid, charts, rich text editors)
- Route-level components
- Modal/dialog content (not shown initially)
- Below-the-fold content

### How to Lazy Load

```typescript
import React from 'react';

// Lazy load heavy component
const PostDataGrid = React.lazy(() =>
    import('./grids/PostDataGrid')
);

// For named exports
const MyComponent = React.lazy(() =>
    import('./MyComponent').then(module => ({
        default: module.MyComponent
    }))
);
```
---

## Suspense Boundaries

### SuspenseLoader Component

**Import:**
```typescript
import { SuspenseLoader } from '@/components/SuspenseLoader';
// Or
import { SuspenseLoader } from '@/components/SuspenseLoader';
```

**Usage:**
```typescript
<SuspenseLoader>
    <LazyLoadedComponent />
</SuspenseLoader>
```

**What it does:**
- Shows loading indicator while lazy component loads
- Smooth fade-in animation
- Consistent loading experience
- Prevents layout shift

### Where to Place Suspense Boundaries

**Route Level:**
```typescript
// routes/my-route/index.tsx
const MyPage = lazy(() => import('@/app/my-feature/MyPage'));

function Route() {
    return (
        <SuspenseLoader>
            <MyPage />
        </SuspenseLoader>
    );
}
```

**Component Level:**
```typescript
function ParentComponent() {
    return (
        <div>
            <Header />
            <SuspenseLoader>
                <HeavyDataGrid />
            </SuspenseLoader>
        </div>
    );
}
```

**Multiple Boundaries:**
```typescript
function Page() {
    return (
        <div>
            <SuspenseLoader>
                <HeaderSection />
            </SuspenseLoader>

            <SuspenseLoader>
                <MainContent />
            </SuspenseLoader>

            <SuspenseLoader>
                <Sidebar />
            </SuspenseLoader>
        </div>
    );
}
```

Each section loads independently, better UX.

---

## Component Structure Template

### Recommended Order

```typescript
/**
 * Component description
 * What it does, when to use it
 */
import React, { useState, useCallback, useMemo, useEffect } from 'react';
import { Box, Paper, Button } from '@/components/ui/glass';
import { useSuspenseQuery } from '@tanstack/react-query';

// Feature imports
import { myFeatureApi } from '@/api/myFeatureApi';
import type { MyData } from '@/types/myData';

// Component imports
import { SuspenseLoader } from '@/components/SuspenseLoader';

// Hooks
import { useAuth } from '@/hooks/use-auth';
import { useToast, toast } from '@/hooks/use-toast';

// 1. PROPS INTERFACE (with JSDoc)
interface MyComponentProps {
    /** The ID of the entity to display */
    entityId: number;
    /** Optional callback when action completes */
    onComplete?: () => void;
    /** Display mode */
    mode?: 'view' | 'edit';
}

// 2. STYLES (if inline and <150 lines)
const componentStyles: Record<string, Props<Theme>> = {
    container: {
        p: 2,
        display: 'flex',
        flexDirection: 'column',
    },
    header: {
        mb: 2,
        display: 'flex',
        justifyContent: 'space-between',
    },
};

// 3. COMPONENT DEFINITION
export const MyComponent = {
    entityId,
    onComplete,
    mode = 'view',
    }: React.ReactElement | null => 
{

// 4. EVENT HANDLERS (with useCallback)
const handleItemSelect = useCallback((itemId: string) => {setSelectedItem(itemId);}, []);

const handleSave = useCallback(async () => {
    try {
        await myFeatureApi.updateEntity(entityId, { /* data */ });
        showSuccess('Entity updated successfully');
        onComplete?.();
    } catch (error) {
        showError('Failed to update entity');
    }
}, [entityId, onComplete, showSuccess, showError]);

// 5. RENDER
return (
    <div sx={componentStyles.container}>
        <div sx={componentStyles.header}>
            <h2>My Component</h2>
            <Button onClick={handleSave}>Save</Button>
        </div>

        <Card classname='p-4 glass'>
            {filteredData.map(item => (
                <div key={item.id}>{item.name}</div>
            ))}
        </Card>
    </div>
);
};

// 7. EXPORT (default export at bottom)
export default MyComponent;
```

---

## Component Separation

### When to Split Components

**Split into multiple components when:**
- Component exceeds 600 lines
- Multiple distinct responsibilities
- Reusable sections
- Complex nested JSX

**Example:**

```typescript
// ❌ AVOID - Monolithic
function MassiveComponent() {
    // 500+ lines
    // Search logic
    // Filter logic
    // Grid logic
    // Action panel logic
}

// ✅ PREFERRED - Modular
function ParentContainer() {
    return (
        <div>
            <SearchAndFilter onFilter={handleFilter} />
            <DataGrid data={filteredData} />
            <ActionPanel onAction={handleAction} />
        </div>
    );
}
```

### When to Keep Together

**Keep in same file when:**
- Component < 300 lines
- Tightly coupled logic
- Not reusable elsewhere
- Simple presentation component

---

## Export Patterns

### Named Const + Default Export (PREFERRED)

```typescript
export const MyComponent = { ... }: React.ReactElement | null =>
 {
    // Component logic
};

export default MyComponent;
```

**Why:**
- Named export for testing/refactoring
- Default export for lazy loading convenience
- Both options available to consumers

### Lazy Loading Named Exports

```typescript
const MyComponent = React.lazy(() =>
    import('./MyComponent').then(module => ({
        default: module.MyComponent
    }))
);
```

---

## Component Communication

### Props Down, Events Up

```typescript
// Parent
function Parent() {
    const [selectedId, setSelectedId] = useState<string | null>(null);

    return (
        <Child
            data={data}                    // Props down
            onSelect={setSelectedId}       // Events up
        />
    );
}

// Child
interface ChildProps {
    data: Data[];
    onSelect: (id: string) => void;
}

export const Child = { data, onSelect }: React.ReactElement | null =>
 {
    return (
        <div onClick={() => onSelect(data[0].id)}>
            {/* Content */}
        </div>
    );
};
```

### Avoid Prop Drilling

**Use context for deep nesting:**
```typescript
// ❌ AVOID - Prop drilling 5+ levels
<A prop={x}>
  <B prop={x}>
    <C prop={x}>
      <D prop={x}>
        <E prop={x} />  // Finally uses it here
      </D>
    </C>
  </B>
</A>

// ✅ PREFERRED - Context or TanStack Query
const MyContext = createContext<MyData | null>(null);

function Provider({ children }) {
    const { data } = useSuspenseQuery({ ... });
    return <MyContext.Provider value={data}>{children}</MyContext.Provider>;
}

function DeepChild() {
    const data = useContext(MyContext);
    // Use data directly
}
```

---

## Advanced Patterns

### Compound Components

```typescript
// Card.tsx
export const Card: React.ReactElement<CardProps> & {
    Header: typeof CardHeader;
    Body: typeof CardBody;
    Footer: typeof CardFooter;
} = ({ children }) => {
    return <Card>{children}</Card>;
};

Card.Header = CardHeader;
Card.Body = CardBody;
Card.Footer = CardFooter;

// Usage
<Card>
    <Card.Header>Title</Card.Header>
    <Card.Body>Content</Card.Body>
    <Card.Footer>Actions</Card.Footer>
</Card>
```

### Render Props (Rare, but useful)

```typescript
interface DataProviderProps {
    children: (data: Data) => React.ReactNode;
}

export const DataProvider = { children }: React.ReactElement | null =>
 {
    const { data } = useSuspenseQuery({ ... });
    return <>{children(data)}</>;
};

// Usage
<DataProvider>
    {(data) => <Display data={data} />}
</DataProvider>
```

---

## Summary

**Modern Component Recipe:**
1. Lazy load if heavy: `React.lazy(() => import())`
2. Wrap in `<SuspenseLoader>` for loading
3. Use `useSuspenseQuery` for data
4. Import aliases (@/, @/types, @/components)
5. Event handlers with `useCallback`
6. Default export at bottom
7. No early returns for loading states

**See Also:**
- [data-fetching.md](data-fetching.md) - useSuspenseQuery details
- [loading-and-error-states.md](loading-and-error-states.md) - Suspense best practices
