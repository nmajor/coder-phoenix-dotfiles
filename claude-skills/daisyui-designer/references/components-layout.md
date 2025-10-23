# daisyUI Layout Components

## Drawer Component

### Core Structure
The drawer component uses a grid layout with a hidden checkbox to toggle sidebar visibility. The basic structure includes:
- `.drawer` (root container)
- `.drawer-toggle` (hidden checkbox)
- `.drawer-content` (page content)
- `.drawer-side` (sidebar wrapper with overlay)

### Basic Drawer Sidebar

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

### Responsive: Desktop Menu + Mobile Drawer

Uses `lg:hidden` to show a hamburger icon on mobile, displaying a navbar menu on large screens while keeping the drawer available for smaller viewports.

```html
<div class="drawer">
  <input id="my-drawer-3" type="checkbox" class="drawer-toggle" />
  <div class="drawer-content flex flex-col">
    <!-- Navbar -->
    <div class="navbar bg-base-300">
      <div class="flex-none lg:hidden">
        <label for="my-drawer-3" class="btn btn-square btn-ghost">☰</label>
      </div>
      <div class="flex-1 px-2 mx-2">Navbar Title</div>
      <div class="hidden lg:block">
        <ul class="menu menu-horizontal">
          <li><a>Navbar Item 1</a></li>
          <li><a>Navbar Item 2</a></li>
        </ul>
      </div>
    </div>
    <!-- Page content -->
    Content
  </div>
  <div class="drawer-side">
    <label for="my-drawer-3" class="drawer-overlay"></label>
    <ul class="menu bg-base-200 min-h-full w-80 p-4">
      <li><a>Sidebar Item 1</a></li>
      <li><a>Sidebar Item 2</a></li>
    </ul>
  </div>
</div>
```

### Always-Visible on Large Screens

The `lg:drawer-open` class keeps the sidebar visible on larger screens while maintaining toggle functionality on mobile devices.

```html
<div class="drawer lg:drawer-open">
  <!-- Same structure as above -->
</div>
```

### Icon-Only Collapsed State

Advanced pattern using `is-drawer-close` and `is-drawer-open` variants to:
- Show only icons when closed (`is-drawer-close:w-14`)
- Expand to full width when open (`is-drawer-open:w-64`)
- Display tooltips on collapsed icons
- Rotate toggle button based on drawer state

### Right-Side Drawer

The `drawer-end` class positions the sidebar on the right side of the page instead of the left.

```html
<div class="drawer drawer-end">
  <!-- Same structure as above -->
</div>
```

### Functional Features
- Hidden by default; use responsive prefixes (sm, md, lg, xl) for auto-visibility
- Adds `scrollbar-gutter` to prevent layout shifts when opening
- Label elements associated with the checkbox enable toggle functionality

---

## Collapse Component

### Core Classes

**Main Component:** `collapse` - Container for show/hide functionality

**Sub-components:**
- `collapse-title` - "Title part"
- `collapse-content` - "Content part"

**Modifiers:**
- `collapse-arrow` - "Adds arrow icon"
- `collapse-plus` - "Adds plus/minus icon"
- `collapse-open` - "Force open"
- `collapse-close` - "Force close"

### Implementation Patterns

**Focus-based collapse:** Uses `tabindex="0"` on a div. "This collapse works with focus. When div loses focus, it gets closed"

```html
<div tabindex="0" class="collapse collapse-arrow bg-base-200">
  <div class="collapse-title text-xl font-medium">Focus me to see content</div>
  <div class="collapse-content">
    <p>Content</p>
  </div>
</div>
```

**Checkbox-based collapse:** Uses `<input type="checkbox" />` inside the collapse container. Requires clicking again to close.

```html
<div class="collapse collapse-arrow bg-base-200">
  <input type="checkbox" />
  <div class="collapse-title text-xl font-medium">Click me to show/hide</div>
  <div class="collapse-content">
    <p>Content</p>
  </div>
</div>
```

**HTML5 Details/Summary:** Uses semantic `<details>` and `<summary>` tags. Note: "collapse-open and collapse-close doesn't work with this method"

```html
<details class="collapse collapse-arrow bg-base-200">
  <summary class="collapse-title text-xl font-medium">Click me</summary>
  <div class="collapse-content">
    <p>Content</p>
  </div>
</details>
```

### Styling Options

- Basic with border/background: `bg-base-100 border-base-300 border`
- Minimal: No border or background classes
- Icon positioning: Movable via utility classes like `after:start-5 after:end-auto`
- Custom colors: Use `focus:` states for focus-based or `peer-checked:` for checkbox-based variants

### Accordion Pattern

Create multiple collapsible sections that work together:

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
