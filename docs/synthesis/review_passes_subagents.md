# Review passes (subagent edition)

Fan out one subagent per pass. Each pass is purely diagnostic — no fixes, just findings.
Finish each pass with a report following ~/research/docs/code_style/other/reports/links.txt format.

## Passes

### 1. overall (thermonuclear)
Skill: cursor thermonuclear doc (`~/research/docs/code_style`)
- correctness bugs, race conditions, resource leaks
- anything that would break under load or in prod

### 2. macro (program/system design)
Docs:
- cursor thermonuclear doc
- casey semantic compression / api docs
- sean goedecke system design

What to look for:
- spaghetti code, what's hard to reason about
- duplicated codepaths that can be compressed
- layering, abstraction economy
- PR scope (is this doing too much?)

### 3. micro (program design)
Docs:
- casey api design docs
- tiger style doc
- style reference

What to look for:
- match case / function signatures / scopes
- pushing ifs up and fors down
- asking for permission instead of forgiveness where possible
- centralizing micro sources of state / cleaning out state

### 4. errors/correctness
Docs:
- how to test
- grugbrain testing
- tiger style
- style reference

What to look for:
- programmer vs operating errors
- tests that should be external to the code vs asserted vs both
- "how can we trust the code"
- reproducibility

### 5. observability
Skill: logging_sucks
- wide events, silent failures, unhappy path visibility

## Usage

```
subagent passes:
    overall:       thermonuclear skill (cursor)
    macro:         API design (casey granularity/worst API, sean goedecke system design) — layering, abstraction economy, PR scope
    micro:         tiger style + style reference — assertions, exhaustive matching, error contracts, control flow
    errors:        how to test + grugbrain + tiger style — programmer vs operating errors, trust, reproducibility
    observability: logging_sucks — wide events, silent failures, unhappy path visibility

importantly, subagents should not suggest fixes! purely diagnostic
```

## Reference docs

All in `~/research/docs/code_style/`:
- cursor thermonuclear doc
- casey semantic compression / api design / granularity / worst API
- sean goedecke system design
- tiger style
- style reference
- how to test
- grugbrain testing
- logging_sucks
- report format: `other/reports/links.txt`
