# Design Engineering Philosophy

From [Vercel's design engineer principles](https://vercel.com/design/engineer), [Emil Kowalski](https://emilkowal.ski/ui/agents-with-taste), and [Ryan Lu on designing in layers](ryolu_design_frontend.md).

---

## Vercel's Principles

**Obsess over usefulness.** Solve real problems. Focus on making valuable solutions feel intuitive.

**Own the whole experience.** Shape the product, design the interface, ship the code. Attend to all details: states, edge cases, language, interactions.

**Understand the constraints.** Know the user, product, code, business, and tradeoffs. Identify the actual limitation before settling on an approach.

**Build for everyone.** Design across skill levels, abilities, and contexts. Keep advanced features accessible without requiring them.

**Make it excellent.** Scope small enough to do it well. Defend against compromises in clarity, quality, speed, or reliability.

**Make the team better.** Share progress frequently. Convert recurring feedback into improved defaults, tools, and processes.

---

## Taste (Emil Kowalski)

### Taste is trained, not innate

Good taste is trained instinct — the ability to see beyond the obvious. Develop it by studying great work, thinking about *why* it feels good, and practicing relentlessly.

### Unseen details compound

Most details users never consciously notice. That's the point. When a feature works exactly as someone assumes it should, they proceed without a second thought. That's the goal.

> "All those unseen details combine to produce something that's just stunning, like a thousand barely audible voices all singing in tune." — Paul Graham

### Beauty is leverage

People select tools based on overall experience, not just functionality. Good defaults and good animations are real differentiators.

### Every "taste" decision has logic

Almost every taste decision has a logical reason if you look close enough. The job is articulating that logic into explicit rules — then those rules can be taught to agents and teammates.

---

## Designing in Layers (Ryan Lu)

The best software grows with you through layers that reveal themselves when you need them.

- **Layer 1**: Defaults, high-traffic UI. Optimize for the 80%. Show one primary path, but give others a way out.
- **Layer 2**: Alternative paths and presets for the other 20%. Customizable, but not hard to understand.
- **Layer 3**: Full power for users who "get it." Every low-level concept and tool accessible.

The real challenge isn't designing each layer — it's designing the transitions between them. Outgrowing the defaults should feel like discovering a secret door, not hitting a wall.

> Alan Kay: users should be able to "open up the hood" of their word processor and tinker with it.

---

## The Sonner Principles (Building Loved Components)

From Emil's experience building Sonner (13M+ weekly npm downloads):

1. **DX is key.** No hooks, no context, no setup. Insert `<Toaster />` once, call `toast()` from anywhere. Less friction → more adoption.
2. **Good defaults > options.** Ship beautiful out of the box. Most users never customize.
3. **Naming creates identity.** "Sonner" (French for "to ring") > "react-toast". Sacrifice discoverability for memorability when appropriate.
4. **Handle edge cases invisibly.** Pause timers when tab is hidden. Fill gaps between stacked toasts. Capture pointer events during drag. Users never notice — that's exactly right.
5. **Cohesion.** Motion, design, naming — everything in harmony. Sonner is slightly slower than typical UI animations, uses `ease` rather than `ease-out`, to feel elegant. Match motion to mood.
6. **Great docs.** Let people touch the product before they use it. Interactive examples with copy-paste code.

---

## StyleX (CSS-in-JS consideration)

[StyleX](https://stylexjs.com/) — Meta's type-safe, composable, predictable styling system. Worth evaluating when:
- You need type-safe styles with compile-time checking
- CSS specificity wars are a problem
- You want composable styles without runtime cost
- Theming needs to be first-class

Not yet adopted — noting as a tool to evaluate against Tailwind for our use case.
