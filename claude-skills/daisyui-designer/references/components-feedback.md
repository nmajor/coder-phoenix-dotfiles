# daisyUI Feedback Components

## Alert Component

### Core Alert Structure
The alert component uses `role="alert"` with the `.alert` class as a container. Basic syntax:
```html
<div role="alert" class="alert">
  <svg><!-- icon --></svg>
  <span>Message text</span>
</div>
```

### Color Variants

**Info Alert:**
```html
<div role="alert" class="alert alert-info">
  <span>New software update available.</span>
</div>
```

**Success Alert:**
```html
<div role="alert" class="alert alert-success">
  <span>Your purchase has been confirmed!</span>
</div>
```

**Warning Alert:**
```html
<div role="alert" class="alert alert-warning">
  <span>Warning: Invalid email address!</span>
</div>
```

**Error Alert:**
```html
<div role="alert" class="alert alert-error">
  <span>Error! Task failed successfully.</span>
</div>
```

### Style Variants
- `.alert-soft` — Soft background styling
- `.alert-outline` — Border-only styling
- `.alert-dash` — Dashed border style

### Layout Options
- `.alert-vertical` — Stacked layout (mobile)
- `.alert-horizontal` — Side-by-side layout (desktop)
- Use `sm:alert-horizontal` for responsive behavior

### Advanced Example: Alert with Actions
```html
<div role="alert" class="alert alert-vertical sm:alert-horizontal">
  <svg><!-- icon --></svg>
  <span>we use cookies for no reason.</span>
  <div>
    <button class="btn btn-sm">Deny</button>
    <button class="btn btn-sm btn-primary">Accept</button>
  </div>
</div>
```

---

## Loading Component

### Component Overview
The loading component displays an animation to indicate content is loading. It's implemented using the `loading` base class combined with style and size modifiers.

### Animation Styles

**Available animation types:**
- `loading-spinner` – Rotating spinner animation
- `loading-dots` – Animated dots pattern
- `loading-ring` – Rotating ring animation
- `loading-ball` – Bouncing ball effect
- `loading-bars` – Animated bars
- `loading-infinity` – Infinity symbol animation

### Size Options

The component supports five size variants:
- `loading-xs` – Extra small
- `loading-sm` – Small
- `loading-md` – Medium (default)
- `loading-lg` – Large
- `loading-xl` – Extra large

### Basic Example

```html
<span class="loading loading-spinner loading-md"></span>
```

### Color Customization

Apply semantic color classes to customize the loading indicator:

```html
<span class="loading loading-spinner text-primary"></span>
<span class="loading loading-spinner text-success"></span>
<span class="loading loading-spinner text-error"></span>
```

Available color options include: primary, secondary, accent, neutral, info, success, warning, and error.

### Usage in Buttons

```html
<button class="btn">
  <span class="loading loading-spinner"></span>
  Loading...
</button>
```
