# HTML & CSS Fundamentals

From [bendc/frontend-guidelines](https://github.com/bendc/frontend-guidelines).

---

## HTML

### Semantics
Use semantic elements (`<main>`, `<article>`, `<header>`, `<time>`) over generic divs. It's worse to use a semantic element wrongly than to stay neutral with a div.

### Brevity
Use HTML5's concise syntax:
```html
<meta charset=utf-8>              <!-- not Content-Type -->
<link rel=stylesheet href=style.css>  <!-- no type= -->
<script src=main.js></script>         <!-- no type= -->
<input type=email required>           <!-- no required=required -->
```

### Accessibility
- Meaningful `alt` text (not "Logo" — use the company name)
- Semantic `<a>` and `<button>`, not `<div class=button>`
- Don't rely on color alone for information
- Label form controls explicitly

### Language & charset
Always declare:
```html
<!doctype html>
<html lang=en>
  <meta charset=utf-8>
```

### Performance
Scripts at end of `<body>` unless there's a valid reason to block rendering.

---

## CSS

### Flow
Keep elements in the natural document flow. Prefer `margin-left: auto` over `position: absolute; right: 0`. Use flexbox/grid over removing from flow.

### Selectors
Minimize coupling to DOM structure.
```css
/* Bad */  div:first-of-type :last-child > p ~ *
/* Good */ div:first-of-type .info
```

### Specificity
Don't use `id` selectors or `!important`. Compose classes:
```css
.foo.bar { color: green; }
.foo { color: red; }
```

### Avoid overriding
```css
/* Bad */  li { visibility: hidden; } li:first-child { visibility: visible; }
/* Good */ li + li { visibility: hidden; }
```

### Inheritance
Don't duplicate declarations parents can inherit:
```css
/* Bad */  div h1, div p { text-shadow: 0 1px 0 #fff; }
/* Good */ div { text-shadow: 0 1px 0 #fff; }
```

### Units
- Unitless: `margin: 0`, `line-height: 1.5`
- `rem` for relative sizing
- Seconds over milliseconds: `transition: .5s`

### Colors
RGBA for transparency, hex otherwise. (We may adopt `oklch` — revisit.)

### Animations
Prefer transitions over animations. Only animate `opacity` and `transform`. See [animations.md](animations.md) for the full framework.

### Drawing
Simple shapes in CSS over HTTP requests:
```css
div::before { content: ""; display: block; width: 20px; height: 20px;
  border-radius: 50%; background: #fff; }
```

### No hacks
```css
/* Bad */  transform: translateZ(0);     /* GPU force hack */
/* Good */ will-change: transform;       /* explicit intent */
```

---

## JavaScript (general, not React-specific)

### Readability over performance
JS is rarely the bottleneck. Prefer `.filter().map()` over manual loops.

### Statelessness
Pure functions: no side effects, no outside data, return new objects.

### `const` > `let` > `var`

### Composition over nesting
```js
const pipeline = (...fns) => val => fns.reduce((a, f) => f(a), val);
```

### Minimize dependencies
Implement common utilities natively before reaching for a library.
