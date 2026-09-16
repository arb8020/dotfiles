# Contract

A coding agent usually optimizes for what fits in its context:

* copy the nearest working pattern;
* edit the file already open;
* choose the shortest path that compiles;
* avoid deleting code whose callers are not visible;
* follow the requested implementation even when it conflicts with a system invariant.

These behaviors are predictable inputs to the framework design. Dune follows five rules:

1. The conventional path requires fewer decisions than a shortcut.
2. Forbidden dependencies fail mechanically.
3. Every durable value has one obvious writer.
4. New product work adds isolated files rather than branches in shared roots.
5. Exceptions are narrow, explicit, and reviewed as architecture changes.

The five public nouns carry those rules. A **Feature** creates an owned folder. Its **Entrypoints** and **Transcript** cards are discovered [cropped] reserved files rather than registered in shared inventories. The **Client** gives durable laptop state one writer behind named hooks [cropped] commands. **Host** behavior stays in the box behind one typed contract. The package boundary repeats the same lesson at the top [cropped]. Dune lives at `sand/dune`, the application lives under `sand/src`, and Dune never imports application code.

