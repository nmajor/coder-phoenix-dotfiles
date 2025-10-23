---
name: daisyui-designer
description: UI component design with DaisyUI v5 and Tailwind CSS. Use for building user interfaces, styling components, design systems, Tailwind utility classes, modern UI/UX, component libraries, and frontend design.
---

# DaisyUI Designer Skill

Comprehensive assistance with DaisyUI v5 component-based design, integrating Tailwind CSS utilities and modern UI/UX principles.

## When to Use This Skill

This skill should be triggered when:
- Building interfaces with DaisyUI v5 components
- Converting vanilla Tailwind designs to DaisyUI-first implementations
- Implementing buttons, cards, forms, navigation, modals, and other UI components
- Creating responsive, accessible web applications
- Designing dashboards and enterprise interfaces
- Working with DaisyUI's 35 built-in themes
- Applying modern UI/UX best practices (2025)
- Building complex interfaces with proper component composition
- Questions about when to use DaisyUI vs vanilla Tailwind
- Debugging DaisyUI component implementations

## 🎯 THE GOLDEN RULE

**ALWAYS check if DaisyUI has a component FIRST before using vanilla Tailwind CSS.**

DaisyUI v5 provides 63 components across 7 categories that are more accessible, consistent, and maintainable than vanilla Tailwind implementations.

## Key Concepts

### DaisyUI Priority Hierarchy

1. **DaisyUI Components (FIRST PRIORITY)**
   - Use DaisyUI classes for buttons, forms, cards, navigation, feedback, etc.
   - 63 components: button, card, input, navbar, menu, modal, dropdown, table, alert, loading, drawer, collapse, badge, and more
   - Only 34 KB compressed CSS, no dependencies

2. **Tailwind Layout Utilities (SECOND PRIORITY)**
   - Use ONLY for layout that DaisyUI doesn't handle
   - Flexbox: `flex`, `flex-col`, `items-center`, `justify-between`
   - Grid: `grid`, `grid-cols-3`, `gap-4`
   - Spacing: `p-4`, `m-2`, `space-y-4`
   - Sizing: `w-full`, `h-screen`, `max-w-md`

3. **Tailwind Utilities (FALLBACK)**
   - Colors (beyond theme), typography, responsive modifiers, states
   - Use Tailwind for styling details only when DaisyUI doesn't provide it

### Component Categories

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

### Theme System

- **35 built-in themes** that instantly transform your entire site
- Apply via `data-theme="THEME_NAME"` on any element
- Themes can be nested without limitations
- Customizable color system using semantic variables
- Responsive to system dark/light mode preferences

## Quick Reference

### Example 1: Buttons

```html
<!-- ❌ WRONG: Vanilla Tailwind -->
<button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
  Click me
</button>

<!-- ✅ CORRECT: DaisyUI -->
<button class="btn btn-primary">
  Click me
</button>
```

**Sizes:** `btn-xs`, `btn-sm`, `btn-md`, `btn-lg`, `btn-xl`

**Colors:** `btn-neutral`, `btn-primary`, `btn-secondary`, `btn-accent`, `btn-info`, `btn-success`, `btn-warning`, `btn-error`

**Styles:** `btn-soft`, `btn-outline`, `btn-dash`, `btn-ghost`, `btn-link`

### Example 2: Cards

```html
<!-- ❌ WRONG: Manual card -->
<div class="border rounded-lg p-4 shadow bg-white">
  <h2 class="font-bold text-xl mb-2">Title</h2>
  <p>Content</p>
</div>

<!-- ✅ CORRECT: DaisyUI Card -->
<div class="card bg-base-100 shadow-xl">
  <div class="card-body">
    <h2 class="card-title">Title</h2>
    <p>Content</p>
    <div class="card-actions justify-end">
      <button class="btn btn-primary">Action</button>
    </div>
  </div>
</div>
```

**Modifiers:** `card-xs`, `card-sm`, `card-md`, `card-lg`, `card-xl`, `card-border`, `card-dash`, `card-side`, `image-full`

### Example 3: Form Inputs

```html
<!-- ❌ WRONG: Custom input -->
<input type="text" class="border border-gray-300 rounded-md p-2 focus:border-blue-500">

<!-- ✅ CORRECT: DaisyUI Input -->
<input type="text" class="input input-bordered" placeholder="Type here" />

<!-- With icon wrapper -->
<label class="input input-bordered flex items-center gap-2">
  <svg class="h-4 w-4 opacity-70"><!-- icon --></svg>
  <input type="text" class="grow" placeholder="Search" />
</label>
```

**Sizes:** `input-xs`, `input-sm`, `input-md`, `input-lg`, `input-xl`

**Colors:** `input-primary`, `input-secondary`, `input-accent`, `input-success`, `input-error`

### Example 4: Modal (Dialog Method - Recommended)

```html
<!-- Button to open modal -->
<button class="btn" onclick="my_modal.showModal()">Open Modal</button>

<!-- Modal -->
<dialog id="my_modal" class="modal">
  <div class="modal-box">
    <h3 class="text-lg font-bold">Hello!</h3>
    <p class="py-4">Press ESC key or click the button below to close</p>
    <div class="modal-action">
      <form method="dialog">
        <button class="btn">Close</button>
      </form>
    </div>
  </div>
  <form method="dialog" class="modal-backdrop">
    <button>close</button>
  </form>
</dialog>
```

**Positioning:** `modal-top`, `modal-middle`, `modal-bottom`, `modal-start`, `modal-end`

### Example 5: Navbar with Responsive Menu

```html
<div class="navbar bg-base-100">
  <div class="navbar-start">
    <div class="dropdown lg:hidden">
      <button class="btn btn-ghost">☰</button>
      <ul class="dropdown-content menu bg-base-200 rounded-box z-[1] w-52 p-2 shadow">
        <li><a>Item 1</a></li>
        <li><a>Item 2</a></li>
      </ul>
    </div>
    <a class="btn btn-ghost text-xl">Logo</a>
  </div>
  <div class="navbar-center hidden lg:flex">
    <ul class="menu menu-horizontal">
      <li><a>Item 1</a></li>
      <li><a>Item 2</a></li>
    </ul>
  </div>
  <div class="navbar-end">
    <button class="btn">Login</button>
  </div>
</div>
```

### Example 6: Alerts with Color Variants

```html
<!-- Info Alert -->
<div role="alert" class="alert alert-info">
  <svg class="h-6 w-6"><!-- icon --></svg>
  <span>New software update available.</span>
</div>

<!-- Success Alert -->
<div role="alert" class="alert alert-success">
  <span>Your purchase has been confirmed!</span>
</div>

<!-- Warning Alert -->
<div role="alert" class="alert alert-warning">
  <span>Warning: Invalid email address!</span>
</div>

<!-- Error Alert -->
<div role="alert" class="alert alert-error">
  <span>Error! Task failed successfully.</span>
</div>
```

**Styles:** `alert-soft`, `alert-outline`, `alert-dash`

**Layout:** `alert-vertical`, `alert-horizontal`, `sm:alert-horizontal`

### Example 7: Drawer (Sidebar)

```html
<div class="drawer">
  <input id="my-drawer" type="checkbox" class="drawer-toggle" />
  <div class="drawer-content">
    <!-- Page content -->
    <label for="my-drawer" class="btn btn-primary drawer-button">Open drawer</label>
  </div>
  <div class="drawer-side">
    <label for="my-drawer" class="drawer-overlay"></label>
    <ul class="menu bg-base-200 min-h-full w-80 p-4">
      <li><a>Sidebar Item 1</a></li>
      <li><a>Sidebar Item 2</a></li>
    </ul>
  </div>
</div>
```

**Modifiers:** `drawer-end` (right side), `lg:drawer-open` (always visible on large screens)

### Example 8: Loading Indicators

```html
<!-- Spinner -->
<span class="loading loading-spinner loading-md"></span>

<!-- Dots -->
<span class="loading loading-dots loading-lg"></span>

<!-- In button -->
<button class="btn">
  <span class="loading loading-spinner"></span>
  Loading...
</button>

<!-- With colors -->
<span class="loading loading-spinner text-primary"></span>
<span class="loading loading-spinner text-success"></span>
```

**Animations:** `loading-spinner`, `loading-dots`, `loading-ring`, `loading-ball`, `loading-bars`, `loading-infinity`

**Sizes:** `loading-xs`, `loading-sm`, `loading-md`, `loading-lg`, `loading-xl`

### Example 9: Tables with Zebra Striping

```html
<div class="overflow-x-auto">
  <table class="table table-zebra">
    <thead>
      <tr>
        <th>Name</th>
        <th>Job</th>
        <th>Company</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Cy Ganderton</td>
        <td>Quality Control Specialist</td>
        <td>Littel, Schaden and Vandervort</td>
      </tr>
      <tr>
        <td>Hart Hagerty</td>
        <td>Desktop Support Technician</td>
        <td>Zemlak, Daniel and Leannon</td>
      </tr>
    </tbody>
  </table>
</div>
```

**Modifiers:** `table-zebra`, `table-pin-rows`, `table-pin-cols`

**Sizes:** `table-xs`, `table-sm`, `table-md`, `table-lg`, `table-xl`

### Example 10: Theme Application

```html
<!-- Apply to entire page -->
<html data-theme="dark">
  <body>
    <!-- All content uses dark theme -->
  </body>
</html>

<!-- Apply to specific sections -->
<div data-theme="light">
  <button class="btn btn-primary">Light theme button</button>
</div>

<div data-theme="dark">
  <button class="btn btn-primary">Dark theme button</button>
</div>

<!-- Nested themes -->
<div data-theme="cupcake">
  <p>Cupcake theme content</p>
  <div data-theme="dracula">
    <p>Dracula theme inside cupcake</p>
  </div>
</div>
```

**Theme configuration in CSS:**
```css
@plugin "daisyui" {
  themes: light --default, dark --prefersdark;
}
```

## Reference Files

This skill includes comprehensive documentation in the `references/` directory:

### Component Documentation

- **`components-actions.md`**: Button, Modal, Dropdown components with all variants, sizes, states, and implementation patterns
- **`components-display.md`**: Card, Table, Badge components with layouts, responsive patterns, and integration examples
- **`components-feedback.md`**: Alert and Loading components with color variants, styles, and usage patterns
- **`components-input.md`**: Text inputs, Checkbox, Toggle, Radio, Select, Textarea, Range components with all form patterns
- **`components-layout.md`**: Drawer and Collapse components for complex layouts and progressive disclosure
- **`components-navigation.md`**: Navbar and Menu components with responsive patterns and nested structures

### Design Guidance

- **`daisyui-priority-rules.md`**: Critical guidelines on when to use DaisyUI vs Tailwind, common mistakes, conversion checklist
- **`ui-ux-principles.md`**: Modern UI/UX best practices for 2025, covering clarity, accessibility, visual hierarchy, and user-centered design
- **`dashboard-patterns.md`**: Enterprise interface patterns, data visualization, layout strategies, and composition patterns
- **`tailwind-utilities.md`**: Essential Tailwind utilities for layout (flexbox, grid, spacing) that complement DaisyUI

### Configuration

- **`themes-config.md`**: Complete theme system documentation including 35 built-in themes, customization, dynamic switching
- **`configuration.md`**: DaisyUI setup and configuration options
- **`getting_started.md`**: Installation and basic usage
- **`other.md`**: Additional resources and component references

## Working with This Skill

### For Beginners

1. **Start with the Golden Rule**: Always check if DaisyUI has a component before using vanilla Tailwind
2. **Use the Quick Reference**: Copy examples directly and modify them for your needs
3. **Focus on common components**: Button, Card, Input, Modal are the most frequently used
4. **Learn the pattern**: `component-name component-modifier component-size component-color`

### For Intermediate Users

1. **Combine components**: Use Card + Button + Badge together for rich interfaces
2. **Master responsive patterns**: Use `sm:`, `md:`, `lg:` prefixes on both DaisyUI and Tailwind classes
3. **Explore themes**: Apply different themes to different sections with `data-theme`
4. **Reference the component docs**: Each component file shows all available modifiers and patterns

### For Advanced Users

1. **Build complex layouts**: Combine Drawer + Navbar + Modal for application-level layouts
2. **Create custom themes**: Extend built-in themes with custom color schemes
3. **Optimize bundle size**: Enable only the themes you need in configuration
4. **Study dashboard patterns**: Apply enterprise UI patterns from `dashboard-patterns.md`
5. **Follow UI/UX principles**: Reference `ui-ux-principles.md` for design decisions

### Navigation Tips

- **Component lookup**: Check category lists above to find the right component
- **Pattern search**: Look in component files for specific patterns (e.g., "responsive card", "nested menu")
- **Theme customization**: See `themes-config.md` for complete theme system
- **Conversion help**: Use `daisyui-priority-rules.md` when converting from vanilla Tailwind

## Common Patterns

### Form Layout with Fieldset

```html
<fieldset class="fieldset">
  <legend class="fieldset-legend">Login Form</legend>
  <label class="label">
    <span class="label-text">Email</span>
  </label>
  <input type="email" class="input input-bordered w-full" />

  <label class="label">
    <span class="label-text">Password</span>
  </label>
  <input type="password" class="input input-bordered w-full" />

  <button class="btn btn-primary w-full mt-4">Login</button>
</fieldset>
```

### Responsive Grid with Cards

```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <div class="card bg-base-100 shadow-xl">
    <div class="card-body">
      <h2 class="card-title">Card 1</h2>
      <p>Content</p>
    </div>
  </div>
  <div class="card bg-base-100 shadow-xl">
    <div class="card-body">
      <h2 class="card-title">Card 2</h2>
      <p>Content</p>
    </div>
  </div>
  <div class="card bg-base-100 shadow-xl">
    <div class="card-body">
      <h2 class="card-title">Card 3</h2>
      <p>Content</p>
    </div>
  </div>
</div>
```

### Collapsible Accordion

```html
<div class="join join-vertical w-full">
  <div class="collapse collapse-arrow join-item border-base-300 border">
    <input type="radio" name="my-accordion" checked="checked" />
    <div class="collapse-title text-xl font-medium">Section 1</div>
    <div class="collapse-content"><p>Content 1</p></div>
  </div>
  <div class="collapse collapse-arrow join-item border-base-300 border">
    <input type="radio" name="my-accordion" />
    <div class="collapse-title text-xl font-medium">Section 2</div>
    <div class="collapse-content"><p>Content 2</p></div>
  </div>
</div>
```

## Best Practices

1. **Component First**: Always use DaisyUI components when available
2. **Layout with Tailwind**: Use Tailwind utilities for flex, grid, spacing, and sizing
3. **Theme Variables**: Use semantic color classes (`bg-primary`, `text-primary-content`) instead of hardcoded colors
4. **Responsive Design**: Apply responsive prefixes (`sm:`, `md:`, `lg:`) for mobile-first design
5. **Accessibility**: DaisyUI components include ARIA attributes by default - preserve them
6. **Bundle Optimization**: Enable only the themes you need in your configuration
7. **Consistent Spacing**: Use Tailwind spacing scale (`gap-4`, `p-4`, `m-2`) for consistency
8. **Test Themes**: Verify your designs work in both light and dark themes

## Summary

**Think DaisyUI first, Tailwind second.**

Every time you're about to use vanilla Tailwind for a component, ask: "Does DaisyUI v5 have this in its 63 components?"

- **If yes** → Use DaisyUI
- **If no** → Use Tailwind utilities

This keeps your code clean, accessible, consistent, and maintainable.
