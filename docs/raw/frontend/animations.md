# Animations

The animation decision framework, synthesized from Emil Kowalski ([animations.dev](https://animations.dev/), [skill](https://github.com/emilkowalski/skill)) and Jakub Krehel ([make-interfaces-feel-better](https://github.com/jakubkrehel/make-interfaces-feel-better)).

For the full skill files with review checklists and exact values, see `skills/emil-design-eng/` and `skills/review-animations/`.

---

## Decision Framework

Before writing any animation, answer these in order:

### 1. Should it animate at all?

| Frequency | Decision |
| --- | --- |
| 100+/day (keyboard shortcuts, cmd palette) | **No animation. Ever.** |
| Tens/day (hover, list nav) | Remove or drastically reduce |
| Occasional (modals, drawers, toasts) | Standard animation |
| Rare/first-time (onboarding, celebrations) | Can add delight |

**Never animate keyboard-initiated actions.** Raycast has no open/close animation — correct for something used hundreds of times a day.

### 2. What easing?

| Context | Easing |
| --- | --- |
| Entering / exiting viewport | `ease-out` |
| Moving / morphing on screen | `ease-in-out` |
| Hover / color change | `ease` |
| Constant motion (marquee, progress) | `linear` |

**Never use `ease-in` on UI.** It delays the moment the user watches most.

**Use strong custom curves** — built-in CSS easings are too weak:

```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);  /* iOS-like */
```

Resources: [easing.dev](https://easing.dev/), [easings.co](https://easings.co/)

### 3. How fast?

| Element | Duration |
| --- | --- |
| Button press | 100–160ms |
| Tooltips, small popovers | 125–200ms |
| Dropdowns, selects | 150–250ms |
| Modals, drawers | 200–500ms |

**UI animations stay under 300ms.** Exits should be ~20% faster than entrances.

### 4. What properties?

**Only animate `transform` and `opacity`.** They skip layout/paint and run on the GPU.

Never animate: `width`, `height`, `margin`, `padding`, `top`, `left`.

---

## Core Patterns

### Interruptible animations

CSS **transitions** retarget mid-animation. **Keyframes** restart from zero. For anything triggered rapidly (toasts, toggles), use transitions.

```css
/* Good — interruptible */
.drawer { transform: translateX(-100%); transition: transform 200ms ease-out; }
.drawer.open { transform: translateX(0); }

/* Bad — not interruptible */
.drawer.open { animation: slideIn 200ms ease-out forwards; }
```

### Never animate from scale(0)

Nothing in the real world appears from nothing. Start from `scale(0.95)` + `opacity: 0`.

### Origin-aware popovers

Popovers scale from their trigger, not center. **Modals are exempt** — keep centered.

```css
.popover { transform-origin: var(--radix-popover-content-transform-origin); }
```

### Scale on press

`scale(0.96)` on `:active`. Never below `0.95`. Use CSS transitions for interruptibility.

```css
.button { transition: transform 150ms ease-out; }
.button:active { scale: 0.96; }
```

Add a `static` prop to disable when motion would be distracting.

### Stagger enter animations

Split content into semantic chunks, stagger ~100ms (30–80ms between items). Combine `opacity`, `blur(4px)`, and `translateY(12px)`.

```css
.stagger-item { opacity: 0; transform: translateY(12px); filter: blur(4px);
  animation: fadeInUp 400ms ease-out forwards; }
.stagger-item:nth-child(2) { animation-delay: 100ms; }
.stagger-item:nth-child(3) { animation-delay: 200ms; }
@keyframes fadeInUp { to { opacity: 1; transform: translateY(0); filter: blur(0); } }
```

Never block interaction while stagger plays.

### Subtle exits

Exits should be softer than enters. Small fixed `translateY(-12px)` instead of full height. 150ms vs 300ms enter.

```css
.item-exit { opacity: 0; transform: translateY(-12px);
  transition: opacity 150ms ease-in, transform 150ms ease-in; }
```

### Asymmetric timing

Slow where the user is deciding, fast where the system responds:

```css
.overlay { transition: clip-path 200ms ease-out; }              /* release: fast */
.button:active .overlay { transition: clip-path 2s linear; }    /* press: slow */
```

### Contextual icon animations

Animate with `opacity`, `scale(0.25→1)`, `blur(4px→0)`. Bounce must be `0`.

If project has `motion`/`framer-motion`: use `{ type: "spring", duration: 0.3, bounce: 0 }`.
If not: keep both icons in DOM, cross-fade with CSS transitions using `cubic-bezier(0.2, 0, 0, 1)`.

### Skip animation on page load

`initial={false}` on `AnimatePresence` prevents enter animations on first render. Don't use when the component relies on `initial` for a first-time entrance.

---

## Springs

Natural because they simulate physics. No fixed duration — they settle on parameters.

Use for: drag with momentum, "alive" elements, interruptible gestures, decorative mouse-tracking.

```js
// Apple-style (recommended)
{ type: "spring", duration: 0.5, bounce: 0.2 }

// Traditional physics
{ type: "spring", mass: 1, stiffness: 100, damping: 10 }
```

Keep bounce subtle (0.1–0.3). Avoid in most UI — reserve for drag-to-dismiss and playful interactions.

For mouse-tracking: use `useSpring` to interpolate, not direct binding (direct = artificial, no momentum). Only for decorative motion.

---

## Gestures & Drag

- **Momentum dismissal**: velocity = `|distance| / elapsedMs`. If `> ~0.11`, dismiss regardless of distance.
- **Damping at boundaries**: increasing resistance as you drag past the edge (real things slow before stopping)
- **Pointer capture** once dragging starts
- **Multi-touch protection**: `if (isDragging) return` — prevents jump on finger switch
- **Friction over hard stops**: allow over-drag with rising resistance

---

## Performance

- **Never `transition: all`** — specify exact properties
- **Don't drive transforms via CSS variables on parents** — recalcs all children. Set `transform` directly.
- **Framer Motion `x`/`y`/`scale` are NOT hardware-accelerated** — they use rAF. Use full transform string:
  ```jsx
  <motion.div animate={{ transform: "translateX(100px)" }} />  // GPU
  <motion.div animate={{ x: 100 }} />                          // drops frames
  ```
- **CSS animations beat JS under load** — they run off main thread
- **WAAPI** for programmatic CSS performance: `element.animate([...], { duration, easing })`
- **`will-change`**: only for `transform`, `opacity`, `filter`. Never `all`. Only when you see first-frame stutter.

---

## clip-path

`clip-path: inset(top right bottom left)` — each value eats in from that side.

Uses: reveal-on-scroll, hold-to-delete overlays, seamless tab color transitions (duplicate + clip), comparison sliders.

---

## Accessibility

```css
@media (prefers-reduced-motion: reduce) {
  .element { animation: fade 0.2s ease; }  /* keep opacity, drop movement */
}
@media (hover: hover) and (pointer: fine) {
  .element:hover { transform: scale(1.05); }  /* gate hover — touch fires false hovers */
}
```

Reduced motion = fewer and gentler, not zero.

---

## Debugging

- **Slow motion**: bump duration 2–5× or DevTools animation inspector
- **Frame-by-frame**: Chrome Animations panel
- **Real devices** for gestures — connect phone, hit dev server by IP
- **Fresh eyes next day** — imperfections surface later

---

## Tooltips

Delay before first appearance. Once one tooltip is open, subsequent tooltips open instantly with no animation:

```css
.tooltip[data-instant] { transition-duration: 0ms; }
```

---

## Blur to mask crossfades

When a crossfade shows two overlapping states, add `filter: blur(2px)` during the transition. Keep under 20px (expensive in Safari).

---

## Perceived Performance

- Faster spinner → loading feels faster (same actual time)
- 180ms select feels more responsive than 400ms
- `ease-out` at 200ms *feels* faster than `ease-in` at 200ms
