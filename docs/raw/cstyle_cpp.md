# C-Style C++

C with enough C++ to avoid preprocessor pain. No OOP, no STL on the hot path,
no exceptions, no inheritance. The language is a delivery mechanism for structs,
functions, and explicit control flow.

Reference implementation: silares-ai/network.
Reference style: Tiger Style, Casey Muratori, CODE_RULINGS_DRAFT.

---

## The subset

### Use

- `struct` (never `class`)
- Free functions. Methods only on trivial inline helpers (`buf_init`, `store_close`).
- `enum name : u8` (explicitly sized, always)
- Fixed-width types: `u8 u16 u32 u64 s8 s16 s32 s64` (typedef from `<cstdint>`)
- `static inline` for small helpers in headers
- `constexpr` for compile-time constants that need arithmetic
- `static_assert` for compile-time invariant checks
- `nullptr` (not `NULL`)
- `#pragma once` (not include guards)
- `<cstdlib>` `<cstring>` `<cstdio>` (C headers, C++ spelling)
- Templates: only for `min_t`/`max_t`/`clamp_t` one-liners. If it doesn't fit on
  one line, it's not a template -- it's a code generator you haven't admitted to.
- `#define` for array-size macros and platform cardinality budgets only.

### Don't use

- `class`, `private`, `protected`, `virtual`, `override`
- Inheritance (no base classes, no polymorphism through vtables the compiler owns)
- Exceptions (`throw`, `try`, `catch`) -- return codes, always
- RAII (no destructors doing cleanup; explicit `_free`/`_close` calls)
- STL containers (`std::vector`, `std::map`, `std::string`) -- fixed arrays, `struct buf`, manual pools
- `<algorithm>`, `<functional>`, `<memory>`, `<iostream>`
- `auto` (name the type; the reader shouldn't have to infer it)
- Range-based for loops (write the index; you almost always need it)
- Operator overloading
- `new`/`delete` (malloc/free, or better: static allocation)
- Smart pointers (`unique_ptr`, `shared_ptr`) -- ownership is structural, not ref-counted
- Namespaces (use file-level `static` for internal linkage, prefixes for public names)
- `const_cast`, `reinterpret_cast`, `dynamic_cast` (C-style casts for the rare cast)
- Lambdas (name the function)

---

## Patterns (from the network codebase)

### Manual vtable

Polymorphism through function-pointer structs, not virtual methods.
The caller builds the table; the framework calls through it.

```cpp
struct svc_ops {
    const char      *name;
    struct svc_req *(*alloc)(struct edge *e);
    void            (*free)(struct edge *e, struct svc_req *r);
    int             (*route)(struct svc_req *r, const char *path, u32 plen,
                             const char **code, const char **msg);
    int             (*parse)(struct svc_req *r, const char *body, u32 len,
                             const char **code, const char **msg);
    /* ... */
};
```

Why over virtual: the vtable is data you can inspect, assert, and validate at boot
(`edge_validate_ops` checks every function pointer is non-null before serving traffic).
A virtual method that's pure-virtual crashes at call time; a NULL function pointer
checked at init crashes at startup. Startup is better.

### Container-of

A framework holds a generic struct. The service embeds it as the FIRST member of
its own struct. The service reaches its state via `container_of`.

```cpp
struct conn {
    struct svc_req  req;    /* MUST be first */
    /* service-specific fields follow */
    char            model[64];
    s64             tokens_used;
};

/* in a hook: */
struct conn *c = (struct conn *)r;  /* r points to req, which is first */
```

Why: the framework (lib/edge) never names the service type. It holds `struct svc_req *`.
The service knows its own type. No templates, no type erasure, no generics.

### Fixed pools, no hot-path malloc

```cpp
#define POOL_SIZE 512u

static struct conn pool[POOL_SIZE];
static u32 free_head;

struct svc_req *my_alloc(struct edge *e) {
    /* scan for an unused slot */
    for (u32 i = 0; i < POOL_SIZE; i++) {
        if (!pool[i].req.used) {
            pool[i].req.used = true;
            pool[i].req.ix = i;
            return &pool[i].req;
        }
    }
    return nullptr;  /* pool exhausted -- edge sheds load */
}
```

All memory decided at startup. The pool is a static array. `alloc` picks a slot;
`free` clears it. No malloc, no free, no fragmentation, no surprises.

### Bounded growable buffer (cold path only)

```cpp
struct buf {
    char    *p;
    u32     len;
    u32     cap;
    u32     max;    /* hard cap; append fails past it */
    bool    oom;    /* sticky: any failed grow */
};
```

When you genuinely need a variable-size buffer (request body assembly, JSON building),
`struct buf` with an explicit `max` cap. The `oom` flag is sticky -- once it fires,
every subsequent append is a no-op, so you check once at the end rather than after
every write. This is the ONLY dynamic allocation, and it's bounded.

### Error returns, not exceptions

```cpp
/* 0 = success, <0 = error, >0 = HTTP status to reject with */
int (*parse)(struct svc_req *r, const char *body, u32 len,
             const char **code, const char **msg);
```

Three error channels:
- `assert` -- programmer error (invariant violated, impossible state). Crash.
- Return code -- operational error (bad input, resource unavailable). Caller decides.
- `(status, code, msg)` triple -- error to render to the client. Hook fills it;
  framework renders it via `svc_ops.error`.

A hook never writes a file descriptor. It appends to a `struct buf *out`.
The framework owns I/O. Hooks are pure transforms with side-channel error reporting.

### Explicit state machines

```cpp
enum edge_state : u8 {
    ES_READ_REQ,
    ES_UP_CONNECT,
    ES_UP_SEND,
    ES_UP_HEAD,
    ES_DONE,
};
```

State is an enum stored in the struct. Transitions are explicit assignments.
The event loop dispatches on `c->state`. No implicit state, no hidden transitions,
no callback chains that create invisible sequencing.

### One definition, one location

```cpp
/* types.h -- the ONLY definition of svc_class */
enum svc_class : u8 {
    CL_INTERACTIVE,
    CL_LONG_STREAM,
    CL_SANDBOX,
    CL_JOB,
    CL__COUNT,
};
```

Wire values, route discriminants, and human-readable names all live next to each other.
The comment explains why: "it had four separate renderers (two switches and two ternaries)
before this." Duplication across translation units is how wire values drift.

### Platform limits as constants

```cpp
/* limits.h */
#define SIL_ORG_BUDGET          4096u
#define SIL_ORG_ADMITTED        SIL_ORG_BUDGET

static_assert(SIL_ORG_ADMITTED <= SIL_ORG_BUDGET,
              "the scheduler cannot admit orgs authd cannot hold");
```

Cardinality budgets defined ONCE, with `static_assert` enforcing the relationships.
Derived quantities (hash table sizes) are computed from the primaries, never independently
chosen. The comment explains why the assert exists and when it can change.

---

## Rules

These are CODE_RULINGS applied to C++. The rulings are language-agnostic; this is
how they compile.

### Assert density

SQLite benchmark: 1 assert per 23 lines across 155K SLOC.
Split compound assertions. Assert positive AND negative space.
Pair assertions across serialization gaps (before write, after read).

In C++: `assert()` from `<cassert>`. Stripped by `NDEBUG` in release --
this is the C/C++ equivalent of "assertions for programmer errors only."
For production checks at boundaries, return an error code.

### 70-line functions

Same rule. If the function doesn't fit, extract a helper.
Parent has control flow. Helpers are pure computation.

### Single assignment

```cpp
/* good */
const char *raw = read_header(r, "x-model");
const char *parsed = validate_model(raw);
u32 model_id = lookup_model(parsed);

/* bad */
const char *val = read_header(r, "x-model");
val = validate_model(val);  /* which val is this? */
```

Use `const` aggressively. If a variable isn't modified after initialization, say so.

### Parse at boundaries

Data from the network is `const char *` and a length. Parse it into a typed struct
immediately. After parsing, internal code trusts its types.

```cpp
/* boundary: parse the org_tag header into exactly 8 lowercase hex or reject */
if (!parse_org_tag(r->org_tag, sizeof(r->org_tag), header_val)) {
    *code = "invalid_org_tag";
    *msg = "org tag must be 8 lowercase hex";
    return 400;
}
/* past here: r->org_tag is 8 lowercase hex or empty. No re-checking. */
```

### Limits on everything

Every buffer has a `max`. Every pool has a size. Every loop has a bound.
Every timeout has a value. Document the derivation.

```cpp
#define EDGE_REQ_MAX            (33u << 20)  /* max buffered request */
#define EDGE_IDLE_TIMEOUT_MS    120000u      /* reap a conn with no progress */
#define EDGE_DRAIN_DEADLINE_MS  300000u      /* 1st-SIGTERM drain cap */
```

### No semantic fallbacks

A `switch` on an enum has a `default` that crashes or returns an error, never
a silent substitute. If `svc_class` grows a fifth variant and you forget to
handle it, the assert in the default fires.

```cpp
static inline const char *svc_class_name(u32 c) {
    switch (c) {
    case CL_INTERACTIVE:    return "interactive";
    case CL_LONG_STREAM:    return "long_stream";
    case CL_SANDBOX:        return "sandbox";
    case CL_JOB:            return "job";
    default:                return "?";   /* observable, not silent */
    }
}
```

### Comments earn themselves

Comments explain WHY, not WHAT. The network codebase comments explain design
decisions, threat models, what changed and why, what went wrong before.
They read like memos, not line-by-line narration.

```cpp
/* A 2xx THAT WAS NOT 200 AND BECAME ONE. The harness relays only non-2xx
 * upstream statuses, so a backend's 201 or 202 reaches the client as
 * 200 -- and with it go the `location` and `retry-after` an async
 * submission answers with. Counted so the exclusion is observable rather
 * than folklore. */
u64 status_flattened;
```

---

## File structure

```
lib/core/types.h        /* u8/u16/u32/u64, ARRAY_SIZE, wire enums */
lib/core/limits.h       /* platform cardinality budgets + static_asserts */
lib/core/buf.h           /* struct buf -- the one growable buffer */
lib/core/ev.h            /* event loop (epoll wrapper) */
lib/core/http.h          /* HTTP head parser */

lib/edge.h + edge.cpp   /* the reusable harness */
lib/store.h + store.cpp /* SQLite discipline */
lib/meter.h + meter.cpp /* durable usage transport */
lib/slog.h + slog.cpp   /* structured log / decision log */
lib/emit.h + emit.cpp   /* span sink */

<service>/main.cpp       /* the service: pool, svc_ops, config, main() */
```

One `.h` and one `.cpp` per module. Headers declare structs and function prototypes.
Implementations are in `.cpp`. `static inline` for trivial helpers in headers.
No `.hpp`. No header-only libraries.

---

## Build

Plain Makefile. No CMake, no Meson, no autotools. The dependency graph is small
enough to write by hand. Compiler flags:

```makefile
CXXFLAGS = -std=c++17 -Wall -Wextra -Werror -O2
# debug: add -g -fsanitize=address,undefined -DDEBUG
```

`-Werror` because warnings are bugs you haven't acknowledged yet.
`-fsanitize=address,undefined` in debug because this is how you catch the
use-after-free and the signed overflow that C-style code is susceptible to.

---

## When to break these rules

- **CUDA kernels**: nvcc has its own constraints. Templates for kernel launch
  parameters are fine. `__device__` functions follow GPU conventions.
- **Third-party headers**: if a library hands you a `std::string`, convert at
  the boundary. Don't let it leak into your code.
- **One-off tooling** (test drivers, offline analysis): relax where it doesn't
  matter. The rules exist for code that runs in production under load.

---

## The test

1. Could someone reading this function tell you what it does in 30 seconds?
2. Could you debug this at 3am with only fprintf and a core dump?
3. If this struct grew a new field, what else would need to change?
4. Is every limit derived from a domain constraint, not a guess?
5. Does the error path leave the system in a state you can reason about?
