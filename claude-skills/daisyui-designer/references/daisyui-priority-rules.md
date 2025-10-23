# DaisyUI Priority Rules - CRITICAL GUIDELINES

## THE GOLDEN RULE

**ALWAYS check if DaisyUI has a component FIRST before using vanilla Tailwind CSS.**

DaisyUI v5 provides 63 components across 7 categories. These components are:
- **More accessible** (built-in ARIA attributes)
- **More consistent** (theme-aware)
- **More maintainable** (centralized styling)
- **Smaller bundle** (only 34 KB compressed)

## Priority Hierarchy

### 1. DaisyUI Components (FIRST PRIORITY)
Use DaisyUI classes for:
- Buttons: `btn`, `btn-primary`, `btn-outline`
- Forms: `input`, `select`, `checkbox`, `toggle`
- Cards: `card`, `card-body`, `card-title`
- Navigation: `navbar`, `menu`, `breadcrumbs`, `tabs`
- Feedback: `alert`, `toast`, `loading`, `progress`
- Data display: `table`, `stat`, `badge`, `avatar`

### 2. Tailwind Layout Utilities (SECOND PRIORITY)
Use Tailwind ONLY for layout that DaisyUI doesn't handle:
- Flexbox: `flex`, `flex-col`, `flex-row`, `items-center`, `justify-between`
- Grid: `grid`, `grid-cols-3`, `gap-4`
- Spacing: `p-4`, `m-2`, `space-y-4`
- Sizing: `w-full`, `h-screen`, `max-w-md`

### 3. Tailwind Utilities (FALLBACK)
Use Tailwind for styling details:
- Colors (beyond theme): Custom colors only when theme colors don't fit
- Typography: `text-sm`, `font-bold`, `leading-tight`
- Responsive: `md:grid-cols-2`, `lg:flex-row`
- States: `hover:opacity-80`, `focus:ring-2`

## Common Mistakes to Avoid

### ❌ WRONG: Vanilla Tailwind Button
```html
<button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
  Click me
</button>
```

### ✅ CORRECT: DaisyUI Button
```html
<button class="btn btn-primary">
  Click me
</button>
```

---

### ❌ WRONG: Manual Card
```html
<div class="border rounded-lg p-4 shadow bg-white">
  <h2 class="font-bold text-xl mb-2">Title</h2>
  <p>Content</p>
</div>
```

### ✅ CORRECT: DaisyUI Card
```html
<div class="card bg-base-100 shadow-xl">
  <div class="card-body">
    <h2 class="card-title">Title</h2>
    <p>Content</p>
  </div>
</div>
```

---

### ❌ WRONG: Custom Form Input
```html
<input type="text"
       class="border border-gray-300 rounded-md p-2 focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
```

### ✅ CORRECT: DaisyUI Input
```html
<input type="text" class="input input-bordered">
```

---

### ❌ WRONG: Mixing DaisyUI + Redundant Tailwind
```html
<!-- DON'T add bg-blue-500 when using btn-primary -->
<button class="btn btn-primary bg-blue-500 py-4">
  Conflicting styles
</button>
```

### ✅ CORRECT: DaisyUI with Layout Utilities Only
```html
<button class="btn btn-primary w-full">
  Full width button
</button>
```

## When to Use Each Approach

### Use DaisyUI When:
- Building interactive elements (buttons, inputs, modals)
- Creating data displays (cards, tables, stats)
- Implementing navigation (navbar, menu, tabs)
- Showing feedback (alerts, toasts, progress bars)
- Any component that exists in the DaisyUI library

### Use Tailwind When:
- Arranging components in layouts (flex, grid)
- Adjusting spacing between elements (gap, padding, margin)
- Making components responsive (responsive prefixes)
- Adding custom animations or transitions
- Styling text beyond what DaisyUI themes provide

### NEVER:
- Recreate a DaisyUI component with vanilla Tailwind
- Add conflicting Tailwind classes to DaisyUI components
- Use inline styles instead of either approach
- Ignore DaisyUI's theming system

## DaisyUI v5 Component Categories

**Actions (6):**
button, dropdown, fab, modal, swap, theme-controller

**Data Display (16):**
accordion, avatar, badge, card, carousel, chat, collapse, countdown, diff, hover-gallery, kbd, list, stat, status, table, timeline

**Navigation (8):**
breadcrumbs, dock, link, menu, navbar, pagination, steps, tabs

**Feedback (7):**
alert, loading, progress, radial-progress, skeleton, toast, tooltip

**Data Input (14):**
calendar, checkbox, fieldset, file-input, filter, label, radio, range, rating, select, input, textarea, toggle, validator

**Layout (8):**
divider, drawer, footer, hero, indicator, join, mask, stack

**Mockup (4):**
browser, code, phone, window

## Conversion Checklist

When seeing vanilla Tailwind examples, mentally convert:

1. **Identify the intent**: What is this element trying to be?
2. **Find the DaisyUI component**: Does DaisyUI have this?
3. **Use DaisyUI base**: Start with the DaisyUI component class
4. **Add modifiers**: Use DaisyUI modifiers (btn-primary, input-bordered)
5. **Layer layout**: Add Tailwind layout utilities if needed
6. **Apply responsive**: Use responsive prefixes on both

## Theme Integration

DaisyUI components automatically use theme variables:
- `primary`, `secondary`, `accent` for semantics
- `base-100`, `base-200`, `base-300` for surfaces
- `neutral`, `info`, `success`, `warning`, `error` for states

**Never hardcode colors when theme colors work:**
```html
❌ <div class="bg-blue-500 text-white">
✅ <div class="bg-primary text-primary-content">
```

## Summary

**Think DaisyUI first, Tailwind second.**

Every time you're about to use vanilla Tailwind for a component, ask:
"Does DaisyUI v5 have this in its 63 components?"

If yes → Use DaisyUI
If no → Use Tailwind utilities

This keeps your code clean, accessible, consistent, and maintainable.
