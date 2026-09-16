# Frontend Style Guide

Our frontend style — synthesized from sources we trust, adapted for our stack (React, TypeScript).

## Working Set

- **[state_machines.md](state_machines.md)** — UI as state machines: why, how, testing benefits
- **[animations.md](animations.md)** — The animation decision framework, easing, duration, springs, gestures, performance
- **[polish.md](polish.md)** — Surfaces, typography, shadows, border radius, hit areas — the invisible details
- **[html_css.md](html_css.md)** — HTML semantics, CSS fundamentals, units, selectors, flow
- **[react_patterns.md](react_patterns.md)** — React state, components, effects, composition
- **[design_engineering.md](design_engineering.md)** — Philosophy: taste, ownership, design layers

## Skills (for Claude Code / Cursor)

Ready-to-use skill files in `skills/`:

- **[emil-design-eng](skills/emil-design-eng/SKILL.md)** — Emil Kowalski's design engineering philosophy (animations, craft, review)
- **[review-animations](skills/review-animations/SKILL.md)** — Animation code review with aggressive standards ([STANDARDS.md](skills/review-animations/STANDARDS.md))
- **[make-interfaces-feel-better](skills/make-interfaces-feel-better/SKILL.md)** — Jakub Krehel's UI polish patterns (concentric radius, optical alignment, stagger, shadows)

## Existing Material (from `other/frontend/`)

- [frontend_skill.md](frontend_skill.md) — General frontend skill (bold aesthetic direction, production-grade)
- [react_frontend_aidenybai.md](react_frontend_aidenybai.md) — Aiden Bai's React patterns (state machines, effects, timing)
- [ryolu_design_frontend.md](ryolu_design_frontend.md) — Ryan Lu's "designing in layers" philosophy
- [html-quality-template.html](html-quality-template.html) — Quality HTML template with CSS custom properties
- [simon_will_html_tools.md](simon_will_html_tools.md) — Simon Willison's patterns for single-file HTML tools

## Sources

| Source | What we took | Link |
| --- | --- | --- |
| Emil Kowalski | Animation framework, easing curves, craft philosophy | [animations.dev](https://animations.dev/), [agents with taste](https://emilkowal.ski/ui/agents-with-taste), [skill repo](https://github.com/emilkowalski/skill) |
| Jakub Krehel | Surface polish, typography, concentric radius | [make-interfaces-feel-better](https://github.com/jakubkrehel/make-interfaces-feel-better) |
| bendc | HTML/CSS/JS fundamentals | [frontend-guidelines](https://github.com/bendc/frontend-guidelines) |
| Vercel | Design engineering principles | [vercel.com/design/engineer](https://vercel.com/design/engineer) |
| Aiden Bai | React patterns, state machines over useState | [react_frontend_aidenybai.md](react_frontend_aidenybai.md) |
| Ryan Lu (Notion, Cursor) | Designing in layers | [ryolu_design_frontend.md](ryolu_design_frontend.md) |
| Simon Willison | Single-file HTML tools patterns | [simon_will_html_tools.md](simon_will_html_tools.md) |
| StyleX | Type-safe, composable CSS-in-JS | [stylexjs.com](https://stylexjs.com/) |
