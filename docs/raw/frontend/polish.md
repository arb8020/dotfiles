# UI Polish

The invisible details that compound into great interfaces. Synthesized from [Jakub Krehel](https://github.com/jakubkrehel/make-interfaces-feel-better) and [Emil Kowalski](https://emilkowal.ski/ui/agents-with-taste).

For the full skill file with exact values: `skills/make-interfaces-feel-better/SKILL.md`

---

## Concentric Border Radius

Outer radius = inner radius + padding. Mismatched radii on nested elements is the most common thing that makes interfaces feel off.

```css
/* Good */
.card { border-radius: 20px; padding: 8px; }   /* 12 + 8 */
.card-inner { border-radius: 12px; }

/* Bad — same radius on both */
.card { border-radius: 12px; padding: 8px; }
.card-inner { border-radius: 12px; }
```

If padding > 24px, treat layers as separate surfaces and choose independently.

## Optical Alignment

Geometric centering often looks wrong. Adjust optically.

- **Button with icon**: icon-side padding = text-side padding - 2px
- **Play triangles**: shift right ~2px to compensate for triangle shape
- **Asymmetric icons**: fix in SVG viewBox/path if possible; fallback to `margin-left: 1px`

## Shadows Over Borders

For cards, buttons, containers with depth — replace borders with layered transparent `box-shadow`. Shadows adapt to any background; borders don't.

```css
:root {
  --shadow-border:
    0 0 0 1px rgba(0, 0, 0, 0.06),
    0 1px 2px -1px rgba(0, 0, 0, 0.06),
    0 2px 4px 0 rgba(0, 0, 0, 0.04);
}
/* Dark mode: simplify to single white ring */
--shadow-border: 0 0 0 1px rgba(255, 255, 255, 0.08);
```

**Keep borders for**: dividers, table cells, form inputs (accessibility), hairline separators.

## Image Outlines

`1px` outline with low opacity. Pure black in light mode (`rgba(0,0,0,0.1)`), pure white in dark mode (`rgba(255,255,255,0.1)`). Never tinted neutrals — they read as dirt.

```css
img { outline: 1px solid rgba(0, 0, 0, 0.1); outline-offset: -1px; }
```

Use `outline` not `border` — no layout impact, inset with offset.

## Typography

### Text wrapping
- **Headings**: `text-wrap: balance` (≤6 lines in Chrome, ≤10 Firefox)
- **Body/captions**: `text-wrap: pretty` (prevents orphans, any length)
- **Long text (10+ lines)**: leave default

### Font smoothing
Apply once at root for macOS:
```css
html { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }
```

### Tabular numbers
For any dynamically updating numbers (counters, prices, timers):
```css
.counter { font-variant-numeric: tabular-nums; }
```

### Other typography rules
- ~65 chars/line max for body text
- Proper typographic characters (… not ...)
- Loosen letter-spacing on uppercase
- Underlines reserved for links only
- Weight for UI emphasis, italic for editorial

## Minimum Hit Area

Interactive elements: ≥40×40px (WCAG says 44×44). Extend with pseudo-element if visible element is smaller.

```css
.checkbox { position: relative; width: 20px; height: 20px; }
.checkbox::after {
  content: ""; position: absolute; top: 50%; left: 50%;
  transform: translate(-50%, -50%); width: 40px; height: 40px;
}
```

Never let hit areas of two elements overlap.

## Never `transition: all`

Always specify exact properties. Tailwind `transition-transform` covers `transform, translate, scale, rotate`.

```css
/* Good */ transition-property: scale, background-color;
/* Bad */  transition: all 150ms ease-out;
```

## `will-change` Sparingly

Only for GPU-compositable properties: `transform`, `opacity`, `filter`, `clip-path`.
Never `will-change: all`. Only add when you see first-frame stutter. Each layer costs memory.

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Same border-radius on parent and child | `outerRadius = innerRadius + padding` |
| Icons look off-center | Optical adjustment or fix SVG |
| Hard borders on cards | Layered `box-shadow` |
| Numbers cause layout shift | `tabular-nums` |
| Heavy text on macOS | `antialiased` on root |
| `transition: all` | Specify exact properties |
| Tiny hit areas | Pseudo-element to 40×40px |
| Tinted image outlines | Pure black/white only |
