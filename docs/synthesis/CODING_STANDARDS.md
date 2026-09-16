# Code Rulings

Binding decisions for this codebase. Each ruling is a verdict, not an argument —
the source doc holds the full reasoning. Leading words recruit model priors;
the sentence pins down the specific ruling.

## Vocabulary

- **honest** — a type whose structure can't represent invalid states
- **earned** — an abstraction forced into existence by 2+ real instances
- **canonical form** — the one true internal representation after boundary parsing
- **judo** — restructuring that uses existing forces to delete complexity
- **operational** — "does this execute correctly at runtime"
- **denotational** — "does this code mean the right thing"

---

## Operational Semantics

"Can we trust this code at runtime?"

### Assertions

Assert preconditions, postconditions, and invariants. No per-function quota —
a quota generates ritual asserts, and ritual asserts train readers to skim asserts.
Calibrate density at the codebase level; SQLite's figure (below) is the benchmark.
Pure total leaves have nothing to assert; dispatch parents' branch conditions
are their assertions — the asserts live in the leaves they call.
Assert the positive space you expect AND the negative space you don't —
bugs live at the boundary between valid and invalid.
Assertions catch programmer errors — if it fires, the code is wrong, not the world.
Tests catch regressions — if it fails, the world changed. Both, always. Different tools.
Split compound assertions: `assert(a); assert(b)` not `assert(a and b)`.
Pair assertions across serialization gaps: assert invariants before write (your code
produced the data — programmer-error channel), parse after read (the world held the data —
boundary channel, see Boundaries and Fail-stop). Typed in-memory values need no re-check —
internal code trusts its types.
Why: assertions downgrade catastrophic correctness bugs into liveness bugs.
Without them, corruption propagates silently until it surfaces far from the cause.
(SQLite averages 1 assert per 23 lines across 155K SLOC — this density is practical, not academic.)
(Tiger Style, Matklad, SQLite)

### Fail-stop

Assertions for programmer bugs. `raise` for boundary violations. No silent recovery.
The only correct response to corrupt state is to crash with full context.
The gray zone: a file that "should" exist because upstream code created it — is that
assert or raise? The test: could this fail in production with correct code? If the world
could be the cause (filesystem, network, clock, concurrency) → raise. If only your code
could be the cause (violated an invariant impossible if code above is correct) → assert.
Why: recovery from corrupt state means operating on data you can't trust.
The crash *is* the safety mechanism — it stops the blast radius.
(Tiger Style)

### Boundaries — parse, don't validate

Parse at entry points into a type that makes the validated property hold by construction.
Don't validate a string and keep passing `str` — construct an `Email` so downstream code
*can't* receive an invalid one. Internal code trusts its types because the types earned trust.
"Move all code that deals with externals to the boundary of our program."
What counts as a boundary: wherever the trust model changes. Data that crossed a
serialization gap (network, filesystem, database, subprocess, JSON from disk) is untrusted —
parse it. Typed values in memory within your process are trusted. A public function of an
internal module is not a boundary. Database reads are boundaries — operationally external
even though you wrote the data.
Why: validation without parsing means every downstream function either re-checks
(wasted work) or trusts without proof (latent bug). A parsed type carries proof in its structure.
(Tiger Style, Lexi Lambda — Parse Don't Validate)

### Single assignment

Never reassign a variable outside loop iteration. Create new names for transformed values.
The rule is about not losing intermediate values, not about name purity. Building up a list
via `.append()` in a loop is fine — that's iteration. But `results = transform(items)` then
`results = filter(results)` should be `transformed = transform(items)`,
`filtered = filter(transformed)`. The awkward names are the point — they document each stage.
Why: in the debugger, every intermediate value is still visible.
With reassignment, you can't inspect what the variable was two steps ago.
"Having all the intermediate calculations still available is helpful in the debugger."
(Carmack)

### Control flow

Push ifs up, fors down. Parent functions own branching; leaf functions stay pure.
Split compound conditions into simple conditions — guard clauses or nested if/else.
State invariants positively.
Why: pure leaf functions are reusable, testable, and locally reasonable.
When branching is scattered, you can't understand a function without reading its callees.
(Tiger Style)

### Limits

Put a limit on everything. All loops, queues, buffers have fixed upper bounds.
Derive the limit from the domain — what's the maximum that makes operational sense?
When the limit hits: data limits (input sizes, field counts) raise — bad data is fail-stop.
Capacity limits (queues, buffers) backpressure — block or shed load; raising on a full
queue turns a load spike into an outage. Clamping is banned either way — it's a semantic
fallback that silently discards data.
Why: unbounded structures are where infinite loops and tail latency spikes hide.
A limit turns an unbounded failure into a bounded, detectable one.
"In reality, this is what we expect — everything has a limit."
(Tiger Style)

### Chunk limit

Six fields, parameters, or branches is the ceiling — human working memory is 4±1 chunks.
More than six means the type is probably two types fused, the function is doing too much,
or the dispatch should be restructured.
The ceiling binds for types you design — more than six variants means the type is
probably misfactored. Spec-defined closed sets (HTTP methods, JSON value kinds) are exempt:
you don't choose their arity, so there's nothing to factor. Match them exhaustively
at whatever arity the spec says.
Why: past six, readers stop holding the full picture in their head and start
re-scanning. The code works but can't be reasoned about locally.
(Cowan, working memory; Tiger Style, reduce variables in scope)

### Nesting depth

Maximum four levels of nesting. Each level is a context frame the reader holds —
past four, you're spending working memory tracking *where you are* instead of *what the code does*.
Extract into a named function, early-return, or restructure the branching.
Why: same as chunk limit — nesting burns working memory on bookkeeping, not semantics.
(CodeAesthetic, Tiger Style)

### 70-line functions

Restrict function bodies to 70 lines. Good shape is the inverse of an hourglass:
few parameters, simple return, meaty logic between.
Why: forces decomposition. If a dispatch function can't fit in 70 lines,
it's doing too much — not just dispatching but also executing.
(Tiger Style)

### Error channels

`assert` for programmer errors. `raise` at boundaries for invalid input.
Sum types for known failure modes — `Ok[T] | Err[E]`, matched exhaustively.
`try/except` wraps external calls only; translate immediately to domain types.
Why: each failure kind has a different audience. Programmer errors need a stack trace.
User errors need a message. Known failures need exhaustive handling. Mixing them
means one kind gets the wrong treatment.
(Style Reference)

### Guards before handlers

Check what you can check: predictable conditions (key present, value parseable, mode valid)
get flat guard clauses, not try/except. Reserve try/except for the irreducibly external —
the single I/O call whose failure only the world can announce — and keep it tight around
that call. A `KeyError` catch on a dict you're holding is EAFP cargo-cult.
Guards are advisory at boundaries (TOCTOU: the world can change between check and act),
so the tight try around the actual external op still exists — guards don't replace it.
Exception: when check-then-act is itself a race (atomic ops like `setdefault`,
`makedirs(exist_ok=True)`), EAFP wins deliberately.
Why: exception handlers smear one linear validation into control-flow trampolining.
A guard chain reads top-to-bottom; six try blocks zigzag through handlers for
conditions that were checkable for free.
(Error channels; Control flow, guard clauses)

### No dishonest fallbacks

Semantic fallbacks — never. Silently converting unknown storage_kind to "s3" changes
the meaning and hides the bug. Bad input that carries semantic weight must fail honestly.
Operational fallbacks — deliberate design decision per feature. Rate limiter down → fail
open and let the request through. Auth down → fail closed. These are not dishonest;
they are explicit failure-mode choices.
Why: a semantic fallback makes the system *appear* to work while doing the wrong thing.
You don't find out until the data is already corrupt or the customer is already angry.
(Style Reference, Sean Goedecke)

### Testing

Test features, not code. The neural network test: could you reuse the test suite
if the implementation were replaced by an opaque model?
Data-driven: one `check()` function, artisanally crafted error messages.
Integration tests are the sweet spot — high enough for correctness, low enough to debug.
Test at each layer boundary, not just end-to-end: `L1 ← Tests, L1 ← L2 ← Tests, ...`
When a test fails, it localizes to a layer. The layer boundaries are the natural "features."
Write regression tests for bugs before fixing them.
Test anomalies, not just inputs: what happens on OOM, disk full, network down, power loss?
"It is easy to build a system that behaves correctly on well-formed inputs.
It is more difficult to build one that responds sanely to invalid inputs."
Why: tests coupled to implementation break on every refactor, creating friction
that discourages both testing and refactoring. Feature tests survive implementation changes.
Anomaly tests catch the failures that only happen in production, under load, at 3am.
(Matklad, Grugbrain, SQLite testing)

### Structured concurrency and testability

Every concurrent operation must have an owner and an observable completion
signal. Callers must be able to await, cancel, and join work they initiate.
Background work must not outlive the scope that owns it.

Never use sleeps, timing guesses, or open-ended polling as proof that concurrent
work completed. Preserve the causality link explicitly: return the result,
expose an awaitable terminal state, or run the work inside a structured nursery
whose exit joins its children.

Why: once an API starts work without providing a way to wait for it, no layer
above can recover the lost causality. Tests become slow and flaky, shutdown can
leak work, and unrelated operations can interfere with one another.
(Matklad, Structured Concurrency)

### Prove your code works

Manual testing + automated testing. Document proof as terminal output or screenshots.
Why: without proof, review becomes guesswork. The reviewer is checking logic in their head
instead of reading evidence.
"Almost anyone can prompt an LLM to generate a thousand-line patch.
What's valuable is contributing code that is proven to work."
(Willison)

### Observability

One wide event per request per service — every field you'd need to debug this request
without a second query. Build the event throughout
the request lifecycle, emit once at the end.
Scope: wide events where failures are debugged post-hoc rather than reproduced —
services, unattended jobs, long training runs. If you can rerun the failure at will
(CLI, script), the rerun is your wide event; rich unhappy-path logging suffices.
Log aggressively on unhappy paths with real operational context —
file paths, config names, backend identity. Not "operation failed."
Watch p95/p99, not averages.
Why: scattered log lines can't be queried or correlated. When something breaks at 3am,
you need one event with full context, not 50 lines to grep across.
Your slowest requests are disproportionately from your biggest users.
(Logging Sucks, Sean Goedecke)

### Statelessness

Minimize stateful components. Stateless services restart and scale trivially.
One service owns each table — others request, not write directly.
Why: a stateful component that gets into a bad state can't be automatically repaired.
You have to manually go in and fix it. Stateless components just restart.
(Sean Goedecke)

### Fail-open / fail-closed

Rate limiting fails open. Auth fails closed. Decide per feature, explicitly.
Circuit breakers for retries — don't pile load on a struggling service.
Idempotency keys for write retries.
Why: blind retries turn a partial outage into a complete one.
The failure mode decision is a design choice, not an afterthought — if you don't
decide explicitly, the default is usually wrong.
(Sean Goedecke)

---

## Denotational Semantics

"Does this code mean the right thing?"

### Data-oriented design

Think of programs as data transformation pipelines: input → parsed → normalized → processed → output.
Separate data from behavior. Structs hold state; functions transform it. Each step takes data in,
returns new data out. Organize code around how data flows and transforms, not around noun-hierarchies.
Why: when you orient around objects, you scatter related data across class hierarchies and
hide transformations behind method dispatch. When you orient around data, the flow is visible,
the transformations are testable, and the hot path is obvious.
This is the worldview behind: functions before noun-classes, single assignment, canonical form,
pure leaf functions, and shared stack frames.
(Casey, implicitly throughout; Data-Oriented Design)

### Earned compression

Don't *introduce* an abstraction until 2+ real instances exist. Write specific, then compress.
But aggressively *delete* existing abstractions that aren't earning their keep (see Judo).
Earned compression governs creation; judo governs removal. Different scales.
When does the second instance "count"? The count is necessary but not sufficient.
The real test: would they change together for the same reason? Two call sites doing the
same operation with the same args = earned. Two call sites that coincidentally share args
but serve different purposes = premature coupling.
Why: premature abstraction couples things that aren't actually related, and you
don't discover the mistake until you need to change one without the other.
"Make your code usable before you try to make it reusable."
(Casey, Semantic Compression)

### Continuous granularity

Never delete lower-level functions when adding higher-level ones.
"Never supply a higher-level function that can't be trivially replaced
by a few lower-level functions that do the same thing."
No API holes — each granularity level works standalone.
This binds where callers are expected but not visible (published APIs, plugin surfaces) —
the goal is "we expect someone to call this, so don't make a hole here."
Where all callers are greppable and absent, the level is dead surface — delete it
(see negative space, judo).
Why: without lower-level access, callers hit a wall the moment the high-level API
doesn't fit their case. They either rewrite from scratch or hack around it.
(Casey, Granularity)

### Write usage code first

Before implementing, write how you want to call it. This reveals the right API.
Why: implementation constraints warp your sense of what's possible. Writing usage
code first gives you the clean perspective before the constraints arrive.
"This is the only way to get a nice, clean perspective on how the API
would work if it had no constraints on it whatsoever."
(Casey, Worst API)

### Honest types

Sum types for known variants: `S3Args | SftpArgs | WebDavArgs`.
No optional-parameter sludge. Protocols only when they've earned themselves —
when the implementation owns real resources or cleanup.
Why: optional-parameter sludge creates implicit coupling between unrelated variants.
An honest sum type makes invalid combinations unrepresentable.
(Style Reference)

### Canonical form

Normalize at boundaries. If several input sources mean the same thing internally,
erase the source distinction and keep only the domain distinction.
Why: without normalization, every downstream function carries implicit parsing logic
and can disagree about what the data means.
(Style Reference)

### Functions before noun-classes

Functions over classes when the code is primarily a verb operating over visible state.
Classes earn themselves only for real resource ownership: connections, processes, file handles,
things that need cleanup. Coordinated mutations can live on a frozen dataclass with a
free function — you don't need `self` methods, just one function that does the coordination.
An optimizer's state is a param bag, not a class, even if its updates need coordination.
Why: a class that doesn't own a resource is just a function with hidden `self` plumbing.
It adds indirection without buying anything.
"If it is basically a function, let it be a function."
(Style Reference)

### Structural home

Find where something should live before fixing how it works.
A standalone module that duplicates an existing authority is worse than
a method on the right class. Import direction errors get caught early.
Why: code in the wrong place duplicates authority. Two owners of the same concern
will diverge, and you won't know which one is right.
(Review Patterns)

### Collapsed outcomes

Distinct failure modes stay representable separately.
Empty vs error, timeout vs connection refused.
Don't flatten into a generic error string or bare None.
Why: flattened errors hide the real cause. The caller can't make the right decision
when timeout and connection-refused both arrive as "failed."
(Review Patterns)

### Judo

Look for restructurings that delete whole layers of complexity, not rearrange them.
"Prefer the solution that makes the code feel inevitable in hindsight."
Reframe the state model so conditionals disappear.
Why: rearranging complexity moves the mess; only deletion reduces it.
A refactor that leaves the same number of concepts in play didn't earn its churn.
(Thermonuclear)

### Abstraction = coupling

Every abstraction couples things together. A little duplication is cheaper
than over-coupling unrelated things.
Why: when two things change together because an abstraction binds them,
you pay for the coupling on every change — not just once.
"I consider coupling to be an equal and opposite reaction of abstraction."
(CodeAesthetic)

### Naming

Use precise domain names. `conductor` not `runtime`. `model_id` not `model`.
No invented terminology the codebase doesn't already use.
Hardcoded literals that should be named constants are an instant catch.
Why: generic names force the reader to look inside the function to understand what it does.
Precise names let you reason about the code from the call site.
(Review Patterns)

### Consolidate mutation

All mutations to a stateful object go through a small number of methods.
If forgetting one of several coordinated updates breaks things silently,
that coordination belongs behind a method.
Why: scattered coordinated updates are a silent-corruption vector.
One caller forgets step 3 of 4, and the state is inconsistent with no error.
(Style Reference)

### Negative space

A program's quality is not that it does what it's supposed — it's that it does
almost nothing else. Design by what you *leave out*: features not added, dependencies
not taken, states made unrepresentable. Document dead ends and rejected approaches —
knowing what doesn't work is at least as important as knowing what does.
Why: without documenting the negative space, teammates (and future you) will retry
the same failed approaches. The shape of the code comes from what's absent, not what's present.
(Fabian Giesen; Tiger Style, assert negative space)

### Locality of behaviour

The behaviour of a unit of code should be as obvious as possible by looking only
at that unit of code. Keep the effect near the cause. When behaviour is scattered
across files, understanding requires global knowledge instead of local reading.
Sometimes this tensions with DRY — prefer a little repetition over spooky action at a distance.
No tension with push-ifs-up: dispatch is not behavior. A caller choosing which function
to run doesn't reduce the callee's locality — the leaf's behavior stays unconditional
and fully local. LoB is violated by effects depending on distant state (ambient flags,
spooky config read deep inside), not by calls being chosen upstream.
Why: code that requires you to hold three other files in your head to understand
what happens here is code that will be misunderstood and broken.
(htmx LoB essay; Grugbrain, "separate of concern grug must often all over tarnation many file look")

### Shared stack frames

When multiple functions pass the same cluster of variables around, pull them into a struct.
The struct is a shared context that replaces argument threading — not a class, just data
that travels together because the operations need it together.
Why: without it, every new operation that needs the same context grows a longer parameter list,
and the parameters drift out of sync across call sites.
(Casey, Semantic Compression)

### Immediate mode preference

Prefer APIs where the caller passes data in and gets data out.
Don't force callers to maintain a shadow copy of your internal state and sync it on every change.
Applies beyond UI: ORM sessions, configuration builders, anything that accumulates
state the caller must mirror. If the caller has to diff your state against theirs, the API
is making them solve a harder problem than the original one.
Why: retained-mode APIs turn "do the thing" into "figure out what changed, announce it,
hope the internal state agrees." Immediate mode keeps the caller in control.
(Casey, Designing and Evaluating Reusable Components)

### No magic constants

Always give constants symbolic names. `ClientContext = 1` is unreadable, ungreppable,
and won't break at compile time when the meaning changes.
`ClientContext = USE_QPC_TIMESTAMPS` is all three.
Why: bare literals hide intent, defeat search, and survive API changes silently.
A named constant fails loudly when deprecated.
(Casey, Worst API)

### Explicit dependencies

Construct dependencies at the earliest honest boundary.
No ambient globals, no `os.environ` reads deep inside the program.
Required resources built up front so failure happens early.
Why: hidden dependencies make code untestable and failures mysterious.
When a function secretly reads from the environment, you can't control its behavior in tests
and you can't trace its failures in production.
(Style Reference)

---

## Planning / Intentional

"Are we building the right thing?"

### Product review

Pin down the problem in user terms. Mock it up — a rough HTML mockup settles
an argument that three paragraphs would only prolong.
Why: technical details drift into planning when the product surface isn't pinned down.
A mockup forces alignment on what the user actually sees.
(Dex Horthy)

### Program design

Before implementation, sketch the shape of code: types, method signatures,
call-stack trees, file-tree diffs. Use pseudocode visualizations, not prose.
Why: every design decision not made here gets made implicitly during code review —
the most expensive possible time to change your mind.
"None of these take long to produce, and every one of them is a decision
you'd otherwise be making implicitly during code review."
(Dex Horthy)

### Vertical slices

Work in narrow, complete paths through all layers that can be demonstrated.
Not horizontal stack-order (migrations, then services, then API, then frontend).
Start in the middle and work outward. Test and iterate at each step.
Why: horizontal plans produce 2000 lines of untouchable code.
You can't demo, test, or resteer until every layer is done.
(Dex Horthy)

### Review is the bottleneck

"30 minutes of planning saves hours of review."
Send 1-3 slices at a time. Review as you go — 100-200 lines of resteer
is cheaper than 2000 lines of archaeology.
Why: the cost of a bad decision grows with the amount of code built on top of it.
Early resteer is cheap; late resteer is rewrite.
(Dex Horthy)

### Progressive refactoring

Keep refactors small and sliced, same as features. A large refactor that touches
everything at once is more likely to fail than three small ones that each land independently.
Structural changes (boundaries, types, invariants) land first; mechanical cleanup comes later.
Why: the cost of a broken refactor grows with its size. A small refactor that breaks
is easy to revert; a large one is archaeology.
(Grugbrain, Review Patterns)

### Structural review

"The best code review is structural. It brings in context from parts of the
codebase that the diff didn't mention. Ideally, that context makes the diff
shorter and more elegant."
Don't be nitpicky. Be structural.
Why: nitpicky review catches cosmetic issues while missing architectural dead ends.
Structural review catches the decisions that will cost months downstream.
(Sean Goedecke)
