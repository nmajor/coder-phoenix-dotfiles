# daisyUI Navigation Components

## Navbar Component

### Core Structure

The navbar component uses three main layout classes: `navbar` (container), `navbar-start`, `navbar-center`, and `navbar-end` for positioning content across the navigation bar.

### Basic Implementation

The simplest navbar contains a single title:
```html
<div class="navbar bg-base-100 shadow-sm">
  <a class="btn btn-ghost text-xl">daisyUI</a>
</div>
```

### Layout Variations

**Two-Section Layout**: Uses `flex-1` and `flex-none` to divide the navbar into expandable and fixed-width sections for asymmetrical designs.

```html
<div class="navbar bg-base-100">
  <div class="flex-1">
    <a class="btn btn-ghost text-xl">daisyUI</a>
  </div>
  <div class="flex-none">
    <button class="btn btn-square btn-ghost">
      <svg><!-- icon --></svg>
    </button>
  </div>
</div>
```

**Three-Section Layout**: Employs `navbar-start`, `navbar-center`, and `navbar-end` classes for symmetric left-center-right positioning.

```html
<div class="navbar bg-base-100">
  <div class="navbar-start">
    <a class="btn btn-ghost">Home</a>
  </div>
  <div class="navbar-center">
    <a class="btn btn-ghost text-xl">Logo</a>
  </div>
  <div class="navbar-end">
    <button class="btn">Login</button>
  </div>
</div>
```

**Responsive Design**: Combines `lg:hidden` (mobile dropdown) with `hidden lg:flex` (desktop menu) to switch layouts at breakpoints.

```html
<div class="navbar bg-base-100">
  <div class="navbar-start">
    <div class="dropdown lg:hidden">
      <button class="btn btn-ghost">☰</button>
      <ul class="dropdown-content menu">
        <li><a>Item 1</a></li>
        <li><a>Item 2</a></li>
      </ul>
    </div>
    <div class="hidden lg:flex">
      <ul class="menu menu-horizontal">
        <li><a>Item 1</a></li>
        <li><a>Item 2</a></li>
      </ul>
    </div>
  </div>
</div>
```

### Key Features

- **Dropdowns**: Integrates with daisyUI's dropdown component for nested menus using `<details>` or `.dropdown` classes
- **Indicators**: Badge-style notifications attach to icons via the `.indicator` wrapper
- **Avatar Integration**: Profile images use `.avatar` class with circular styling
- **Search Inputs**: Text inputs fit naturally within navbar space
- **Icon Buttons**: Square ghost buttons (`.btn-square .btn-ghost`) contain SVG icons

### Color Customization

Background and text colors apply via utility classes: `bg-neutral`, `bg-primary`, `text-primary-content` for themed variations.

```html
<div class="navbar bg-neutral text-neutral-content">
  <a class="btn btn-ghost text-xl">daisyUI</a>
</div>
```

---

## Menu Component

### Core Structure
The menu component uses a `<ul>` with the `menu` class. Items are wrapped in `<li>` tags containing `<a>` elements for links.

### Basic Menu
```html
<ul class="menu bg-base-200 rounded-box w-56">
  <li><a>Item 1</a></li>
  <li><a>Item 2</a></li>
  <li><a>Item 3</a></li>
</ul>
```

### Key Variants

**Directions:**
- `menu-vertical` (default) - Vertical menu
- `menu-horizontal` - Items display side-by-side

```html
<ul class="menu menu-horizontal bg-base-200 rounded-box">
  <li><a>Item 1</a></li>
  <li><a>Item 2</a></li>
  <li><a>Item 3</a></li>
</ul>
```

**Sizes:**
- `menu-xs`, `menu-sm`, `menu-md` (default), `menu-lg`, `menu-xl`

```html
<ul class="menu menu-lg bg-base-200 rounded-box w-56">
  <li><a>Large Item</a></li>
</ul>
```

**States:**
- `menu-active` - Applied to `<a>` elements to highlight current item
- `menu-disabled` - Applied to `<li>` to prevent interaction
- `menu-focus` - Visual focus indicator

```html
<ul class="menu bg-base-200 rounded-box w-56">
  <li><a class="menu-active">Active Item</a></li>
  <li class="menu-disabled"><a>Disabled Item</a></li>
  <li><a>Normal Item</a></li>
</ul>
```

### Common Patterns

**Nested Menus:** Parent items can contain `<ul>` children for submenus.

```html
<ul class="menu bg-base-200 rounded-box w-56">
  <li>
    <a>Parent Item</a>
    <ul>
      <li><a>Submenu 1</a></li>
      <li><a>Submenu 2</a></li>
    </ul>
  </li>
</ul>
```

**Collapsible Submenus:** Use `<details>` elements for collapsible sections.

```html
<ul class="menu bg-base-200 rounded-box w-56">
  <li>
    <details open>
      <summary>Parent</summary>
      <ul>
        <li><a>child 1</a></li>
        <li><a>child 2</a></li>
      </ul>
    </details>
  </li>
</ul>
```

**Icons:** Pair SVGs with text inside anchors

```html
<ul class="menu bg-base-200 rounded-box w-56">
  <li>
    <a>
      <svg class="h-5 w-5"><!-- icon --></svg>
      Item with Icon
    </a>
  </li>
</ul>
```

**Responsive:** Combine breakpoints like `lg:menu-horizontal` to switch from vertical mobile to horizontal desktop layouts.

```html
<ul class="menu lg:menu-horizontal bg-base-200 rounded-box">
  <li><a>Item 1</a></li>
  <li><a>Item 2</a></li>
</ul>
```

**Menu Titles:** Use `menu-title` class for section headers

```html
<ul class="menu bg-base-200 rounded-box w-56">
  <li class="menu-title">Section Title</li>
  <li><a>Item 1</a></li>
  <li><a>Item 2</a></li>
</ul>
```
