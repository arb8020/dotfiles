# Review patterns — recurring preferences from sessions

Extracted from 2 months of Claude Code sessions across skipper, remora, and obol.
These are preferences specific to this codebase and this reviewer, not generic
best practices. The style docs (tiger_style, style_reference, logging_sucks, etc.)
cover the general principles — this covers the application of those principles.

## What gets pushed back on

### Wrong structural home
Find where something *should* live before fixing how it works. A standalone
module that duplicates an existing authority is worse than a method on the
right class. Import direction errors (config importing from runtime) get
caught early. The question is always "who owns this concern?"

### Collapsed outcomes
Distinct failure modes should be representable separately. Empty vs error,
timeout vs connection refused, "engine pending" vs "engine circuit-open."
Don't flatten into a generic error string or a bare None.

### Functions that return None when they could be useful
If a function does work and the caller might care what happened, return
something — a bool, a tuple, a result type. `record_failure() -> bool`
(did the circuit trip?) is better than `record_failure() -> None` even
if no caller uses the return value today.

### Generic names
`runtime=` when it's actually `conductor=`, `model` when it's `model_id`,
inline string literals that should be named constants or env vars. Hardcoded
API keys or node IPs are an instant catch. Prefer precise domain names.

### Tests that restate implementation
"What is each test really testing?" Prefer live/e2e verification and
correctness contracts over unit tests that exercise local helpers. Move
invariants into code (assertions, types) when tests are only restating
implementation details.

### Verbose docstrings without semantic weight
Compress when the code is already clear. But log aggressively on unhappy
paths with real operational context — file paths, config names, backend
identity, not just "operation failed."

## Dispatch and control flow

- match/case over isinstance chains — makes exhaustiveness visible
- try/except wraps external calls only, translates immediately to domain types
- Push ifs up, keep leaf functions pure
- State machines should read as tables (one match arm per state)

## Branch workflow

Large branches get superseded, not rebased — the original stays as a ref
while replacement topic branches get cut fresh. Structural changes (boundaries,
types, invariants) land first in the PR sequence; mechanical cleanup comes in
later commits. The gap between first commit and merge reflects real design
feedback, not just lint.

## Verification

Prefer evidence-backed verification: exact command, run directory, artifact,
and what proved success. "Tests pass" is not verification — a URL, a command
output, a screenshot, a run directory is.
