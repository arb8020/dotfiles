# React Patterns

Synthesized from [Aiden Bai](react_frontend_aidenybai.md) and our own principles.

---

## State

### State machines over multiple useStates

See [state_machines.md](state_machines.md) for the full pattern. The core rule: if you have 2+ booleans that interact, you have an implicit state machine with impossible states. Make it explicit.

### Minimize local state

UIs are a thin wrapper over data. Avoid `useState` unless the state is truly reactive and independent of business logic. Ask: can this be a basic calculation instead?

```tsx
// Bad — derived state stored separately
const [items, setItems] = useState(data);
const [count, setCount] = useState(data.length);

// Good — derive it
const items = data;
const count = data.length;
```

### Flatten UI state into calculations

Even when state seems necessary, check if you can flatten it:

```tsx
// Bad
const [isOpen, setIsOpen] = useState(false);
const [selectedId, setSelectedId] = useState<string | null>(null);

// Good — one state, derive the other
const [selectedId, setSelectedId] = useState<string | null>(null);
const isOpen = selectedId !== null;
```

---

## Components

### New component = nested conditional logic

Create a new component abstraction when you're nesting conditional logic or have top-level if/else statements. Ternaries are for small, easily readable logic only.

```tsx
// Bad — nested conditionals in render
function Dashboard({ user }) {
  return (
    <div>
      {user.role === "admin" ? (
        user.verified ? <AdminPanel /> : <VerificationPrompt />
      ) : (
        user.onboarded ? <UserDashboard /> : <OnboardingFlow />
      )}
    </div>
  );
}

// Good — extract components
function Dashboard({ user }) {
  if (user.role === "admin") return <AdminView user={user} />;
  return <UserView user={user} />;
}
```

### Composition over configuration

Prefer composable children over prop-heavy components:

```tsx
// Bad
<Card title="..." subtitle="..." icon={<Star />} actions={[...]} />

// Good
<Card>
  <Card.Header>
    <Star />
    <Card.Title>...</Card.Title>
  </Card.Header>
  <Card.Actions>...</Card.Actions>
</Card>
```

---

## Effects

### useEffect is a red flag

Avoid putting dependent logic in `useEffect` — it causes misdirection.

```tsx
// Bad — On A, set B. When B changes, do C.
useEffect(() => { setB(computeB(a)); }, [a]);
useEffect(() => { doC(b); }, [b]);

// Good — On A, set B and do C.
const handleA = (a) => {
  const newB = computeB(a);
  setB(newB);
  doC(newB);
};
```

### Valid useEffect uses

- Synchronizing with external systems (DOM APIs, timers, subscriptions)
- Fetching data (but prefer a data fetching library)
- Setting up event listeners

### Invalid useEffect uses

- Deriving state from other state
- Responding to state changes (use event handlers)
- Transforming data for rendering (compute in render)

---

## Timing & Rendering

- **Event handlers** for user actions
- **useMemo/useCallback** only when you've measured a performance problem — not preemptively
- **Keys** must be stable and unique — never array indices for reorderable lists
- **Refs** for values that don't trigger re-renders (timers, DOM nodes, previous values)
