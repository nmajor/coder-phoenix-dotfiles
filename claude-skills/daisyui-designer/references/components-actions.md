# daisyUI Action Components

## Modal Component

### Three Implementation Methods

The documentation outlines three approaches to create modals:

1. **HTML `<dialog>` Element (Recommended)**: Uses native dialog with `showModal()` and `close()` methods, supporting ESC key closure and better accessibility.

2. **Checkbox (Legacy)**: A hidden `<input type="checkbox">` controls modal state, with labels toggling visibility.

3. **Anchor Links (Legacy)**: URL parameters display modals, though this approach may conflict with SPA frameworks.

### Key Structure Components

- **`modal`**: Main container component
- **`modal-box`**: Content wrapper with padding and styling
- **`modal-action`**: Container for buttons/actions, typically placed at bottom
- **`modal-backdrop`**: "Label that covers the page when modal is open so we can close the modal by clicking outside"

### Basic Modal (Dialog Method)

```html
<!-- Button to open modal -->
<button class="btn" onclick="my_modal_1.showModal()">open modal</button>

<!-- Modal -->
<dialog id="my_modal_1" class="modal">
  <div class="modal-box">
    <h3 class="text-lg font-bold">Hello!</h3>
    <p class="py-4">Press ESC key or click the button below to close</p>
    <div class="modal-action">
      <form method="dialog">
        <button class="btn">Close</button>
      </form>
    </div>
  </div>
</dialog>
```

### Positioning Classes

Available placement modifiers include:
- `modal-top`, `modal-middle` (default), `modal-bottom`
- `modal-start`, `modal-end` (horizontal positioning)

### Responsive Example

Modals can adapt across breakpoints: `modal-bottom sm:modal-middle` positions the component at the bottom on small screens, transitioning to center on medium+ screens.

### Closing Mechanisms

Dialog modals close via:
- ESC key press
- Close button within a `<form method="dialog">`
- Clicking outside via `modal-backdrop` form element

```html
<dialog id="my_modal" class="modal">
  <div class="modal-box">
    <h3>Modal Title</h3>
    <p>Modal content</p>
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

### Layout Shift Prevention

Opening a modal automatically applies `scrollbar-gutter` on compatible browsers to prevent layout shifting when scrollbars appear or disappear.

---

## Dropdown Component

### Core Structure

The dropdown component uses three implementation methods:

1. **Details/Summary elements** - Native HTML for open/close functionality
2. **Popover API with anchor positioning** - Modern standard (limited browser support)
3. **CSS focus** - Uses `tabindex="0"` divs with role="button"

### Key Classes

- `dropdown` - Container wrapper
- `dropdown-content` - Content area
- `dropdown-hover` - Opens on hover
- `dropdown-open` - Force open state

### Positioning Classes

**Horizontal alignment:**
- `dropdown-start` (default) - Aligns left
- `dropdown-center` - Centers content
- `dropdown-end` - Aligns right

**Vertical placement:**
- `dropdown-top` - Opens upward
- `dropdown-bottom` (default) - Opens downward
- `dropdown-left` - Opens leftward
- `dropdown-right` - Opens rightward

### Example Pattern (CSS Focus Method)

```html
<div class="dropdown">
  <div tabindex="0" role="button" class="btn">Click</div>
  <ul tabindex="-1" class="dropdown-content menu bg-base-200 rounded-box z-[1] w-52 p-2 shadow">
    <li><a>Item 1</a></li>
    <li><a>Item 2</a></li>
  </ul>
</div>
```

### Details/Summary Method

```html
<details class="dropdown">
  <summary class="btn">Click</summary>
  <ul class="menu dropdown-content bg-base-200 rounded-box z-[1] w-52 p-2 shadow">
    <li><a>Item 1</a></li>
    <li><a>Item 2</a></li>
  </ul>
</details>
```

### Notable Features

The documentation notes that "dropdowns close when focus is lost" and recommends avoiding elements like `<dialog>` inside that would remove focus. You can programmatically close dropdowns using `onclick="document.activeElement.blur()"`

### Hover Dropdown

```html
<div class="dropdown dropdown-hover">
  <div tabindex="0" role="button" class="btn">Hover</div>
  <ul tabindex="-1" class="dropdown-content menu">
    <li><a>Item 1</a></li>
  </ul>
</div>
```

---

## Button Component

### Overview
"Buttons allow the user to take actions or make choices." The `.btn` class serves as the base component for all button variations.

### Core Button Class
```html
<button class="btn">Default</button>
```

### Size Variants
Available sizes: `btn-xs`, `btn-sm`, `btn-md` (default), `btn-lg`, `btn-xl`

```html
<button class="btn btn-xs">Xsmall</button>
<button class="btn btn-sm">Small</button>
<button class="btn">Medium</button>
<button class="btn btn-lg">Large</button>
<button class="btn btn-xl">Xlarge</button>
```

**Responsive Example:**
```html
<button class="btn btn-xs sm:btn-sm md:btn-md lg:btn-lg xl:btn-xl">
  Responsive
</button>
```

### Color Options
Available colors: `btn-neutral`, `btn-primary`, `btn-secondary`, `btn-accent`, `btn-info`, `btn-success`, `btn-warning`, `btn-error`

```html
<button class="btn btn-primary">Primary</button>
<button class="btn btn-secondary">Secondary</button>
<button class="btn btn-accent">Accent</button>
```

### Style Variants

**Soft Style:**
```html
<button class="btn btn-soft btn-primary">Soft Primary</button>
```

**Outline Style:**
```html
<button class="btn btn-outline btn-primary">Outline Primary</button>
```

**Dash Style:**
```html
<button class="btn btn-dash btn-primary">Dash Primary</button>
```

**Ghost Style:**
```html
<button class="btn btn-ghost">Ghost</button>
```

**Link Style:**
```html
<button class="btn btn-link">Link</button>
```

### State Modifiers

**Active State:**
```html
<button class="btn btn-active btn-primary">Active</button>
```

**Disabled (Attribute Method):**
```html
<button class="btn" disabled>Disabled</button>
```

**Disabled (Class Method):**
```html
<button class="btn btn-disabled" tabindex="-1" role="button" aria-disabled="true">
  Disabled
</button>
```

### Special Shapes

**Square Button:**
```html
<button class="btn btn-square">
  <svg><!-- icon --></svg>
</button>
```

**Circle Button:**
```html
<button class="btn btn-circle">
  <svg><!-- icon --></svg>
</button>
```

### Layout Modifiers

**Wide (Extra Horizontal Padding):**
```html
<button class="btn btn-wide">Wide</button>
```

**Block (Full Width):**
```html
<button class="btn btn-block">Block</button>
```

### Button with Icon
```html
<button class="btn">
  <svg class="size-[1.2em]"><!-- icon --></svg>
  Like
</button>
```

### Loading State
```html
<button class="btn btn-square">
  <span class="loading loading-spinner"></span>
</button>
<button class="btn">
  <span class="loading loading-spinner"></span>
  loading
</button>
```

### HTML Element Flexibility
Buttons work with various HTML tags:
```html
<a role="button" class="btn">Link</a>
<button type="submit" class="btn">Button</button>
<input type="button" value="Input" class="btn" />
<input type="checkbox" aria-label="Checkbox" class="btn" />
```

### Key Takeaways
- Combine base `.btn` with color, size, and style classes
- Support multiple semantic HTML elements
- Accessibility maintained through proper ARIA attributes for disabled states
- Responsive sizing available via Tailwind breakpoint prefixes
