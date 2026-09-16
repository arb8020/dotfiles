Most people assume that once the architecture is right, the model can just cook. You can go ahead and do this, but you might not like what you get back.
But what I see working well is that before anyone (human or agent) writes the implementation, we go a level down from architecture into the shape of code: the types, the method signatures, the program layout, and the call stacks.
The first version of our program design skill sucked. It was hard to read, it was exhausting. We tried mermaid, which has its place, but what we actually love are light visualizations in pseudocode:
Call-stack trees, for any orchestration or control-flow change. Use diff syntax when the interesting part is what's changing:
Dillon Mulroy talks about using call graphs as part of his planning process, and I think that's exactly right.
File-tree diffs - so you can stay in touch with the layout of your codebase and where stuff lives
Types and method signatures for the key new functions -- the stuff that's too internal for an architecture doc but that an agent might still get wrong
None of these take long to produce (the model drafts them, you argue with it), and every one of them is a decision you'd otherwise be making implicitly during code review -- at the most expensive possible time to change your mind.

---
examples

```text
entrypoint
  runCommand
+   handleCreateResource
+     ResourceClient.create(input)
+       POST /resources
+     renderResult
-   legacyCreateFlow
```

```text
src
└── resource
+   ├── resource-client.ts      # NEW - wraps API contract calls
+   ├── resource-client.test.ts # NEW - covers request/response mapping
~   └── resource-route.ts       # MODIFIED - wires create action into UI
```

```ts
interface Item {
  id: ItemId
  parentId: ItemId | null
  // ...
}

interface Cursor {
  position: ItemId
  direction: 'up' | 'down'
  // ...
}

resolveTarget(items: Item[], cursor: Cursor) -> ItemId | null
```

The style is basically: **show the minimum code-shaped structure needed to explain the idea**.

Use one of three forms depending on what matters:

* **Control flow:** indented call tree, with `+/-/~` for changed behavior.
* **Code structure:** tiny file tree, with one-line comments saying each file’s role/change.
* **Core abstraction:** only the relevant types/interfaces plus the key function signature.

A concise instruction for producing explanations like this would be:

> Explain it as a minimal code sketch: show only the relevant call graph, file tree, or types/function signatures; omit implementation details; annotate each line with its role or what changed.

