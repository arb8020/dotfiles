# UI as State Machines

Representing UI as a state machine makes it easier to manually and automatically test, eliminates impossible states, and makes the component's behavior exhaustively enumerable.

> Source: [Aiden Bai](react_frontend_aidenybai.md), [Jakub Krehel on testability](https://github.com/jakubkrehel/make-interfaces-feel-better)

## Why

Multiple `useState` calls create an implicit state machine with an exponential number of combinations, most of which are invalid. A form with `isLoading`, `isError`, `isSuccess` as three booleans has 8 combinations — only 4 are meaningful. The other 4 are bugs waiting to happen.

A state machine makes the valid states explicit and the transitions between them enumerable.

## The Pattern

```tsx
type FormState =
  | { status: "idle" }
  | { status: "submitting" }
  | { status: "success"; data: Response }
  | { status: "error"; error: Error };

function useForm() {
  const [state, setState] = useState<FormState>({ status: "idle" });

  // Every transition is explicit
  const submit = async (data: FormData) => {
    setState({ status: "submitting" });
    try {
      const response = await api.submit(data);
      setState({ status: "success", data: response });
    } catch (error) {
      setState({ status: "error", error });
    }
  };

  return { state, submit };
}
```

Compare the bad version:

```tsx
// Bad — implicit state machine, impossible states possible
const [isLoading, setIsLoading] = useState(false);
const [error, setError] = useState<Error | null>(null);
const [data, setData] = useState<Response | null>(null);
// What does isLoading=true + error=something mean?
```

## When to Use

| Situation | Approach |
| --- | --- |
| Component has 2+ boolean states that interact | State machine |
| Component has clear phases (idle → loading → done) | State machine |
| Independent toggle (dark mode, sidebar open) | Single `useState` is fine |
| Derived from props/other state | Compute it, don't store it |

## Testing Benefits

State machines are exhaustively testable:

1. **Enumerate states**: each variant of the discriminated union is a test case
2. **Enumerate transitions**: each action from each state is a test case
3. **Impossible states are compile errors**: TypeScript catches them before tests run
4. **Snapshot the machine**: the entire component state is one object, easy to assert on

```tsx
// Every valid state is a test
test.each([
  [{ status: "idle" }, { showForm: true, showSpinner: false }],
  [{ status: "submitting" }, { showForm: false, showSpinner: true }],
  [{ status: "error", error: new Error("fail") }, { showForm: true, showError: true }],
])("renders correctly for %j", (state, expected) => {
  // ...
});
```

## useReducer for Complex Machines

When transitions have preconditions (can only go from `submitting` → `success`, not `idle` → `success`):

```tsx
type Action =
  | { type: "submit" }
  | { type: "succeed"; data: Response }
  | { type: "fail"; error: Error }
  | { type: "reset" };

function reducer(state: FormState, action: Action): FormState {
  switch (state.status) {
    case "idle":
      if (action.type === "submit") return { status: "submitting" };
      return state;
    case "submitting":
      if (action.type === "succeed") return { status: "success", data: action.data };
      if (action.type === "fail") return { status: "error", error: action.error };
      return state;
    case "error":
      if (action.type === "reset") return { status: "idle" };
      if (action.type === "submit") return { status: "submitting" };
      return state;
    case "success":
      if (action.type === "reset") return { status: "idle" };
      return state;
  }
}
```

Invalid transitions return the current state — the machine can't enter an impossible state.

## Relationship to Animations

State machines pair naturally with animations: each state transition maps to an animation. Enter `submitting` → show spinner with stagger. Enter `error` → shake + red. Enter `success` → checkmark scale-in. The animation decision framework (see [animations.md](animations.md)) applies to each transition independently.
