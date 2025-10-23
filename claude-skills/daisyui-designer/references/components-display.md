# daisyUI Data Display Components

## Card Component

### Core Structure
Cards use three main parts: `card` (container), `card-body` (content wrapper), and `card-title` (heading). The `card-actions` class organizes buttons and interactive elements.

### Basic Card Layout
```html
<div class="card bg-base-100 w-96 shadow-sm">
  <figure>
    <img src="image.webp" alt="Description" />
  </figure>
  <div class="card-body">
    <h2 class="card-title">Title</h2>
    <p>Content text</p>
    <div class="card-actions justify-end">
      <button class="btn btn-primary">Action</button>
    </div>
  </div>
</div>
```

### Size Variants
Available sizes include `card-xs`, `card-sm`, `card-md` (default), `card-lg`, and `card-xl`.

### Style Modifiers
- **`card-border`**: Adds visible border
- **`card-dash`**: Dashed border style
- **`card-side`**: Positions image horizontally alongside content
- **`image-full`**: Makes image a full background overlay

### Common Layout Patterns

**Centered Content**: Add `items-center text-center` to `card-body`

```html
<div class="card bg-base-100 shadow-sm">
  <div class="card-body items-center text-center">
    <h2 class="card-title">Centered Card</h2>
    <p>All content is centered</p>
  </div>
</div>
```

**Image Overlay**: Combine `image-full` with card-body for text over images

```html
<div class="card image-full bg-base-100 shadow-sm">
  <figure><img src="background.webp" alt="Background" /></figure>
  <div class="card-body">
    <h2 class="card-title">Overlay Title</h2>
    <p>Text overlays the image</p>
  </div>
</div>
```

**Side Layout**: Use `card-side` to arrange image and content horizontally

```html
<div class="card card-side bg-base-100 shadow-sm">
  <figure><img src="image.webp" alt="Image" /></figure>
  <div class="card-body">
    <h2 class="card-title">Side Card</h2>
    <p>Image on the side</p>
  </div>
</div>
```

**Responsive**: Apply `lg:card-side` for mobile-to-desktop layout switching

```html
<div class="card lg:card-side bg-base-100 shadow-sm">
  <figure><img src="image.webp" alt="Image" /></figure>
  <div class="card-body">
    <h2 class="card-title">Responsive Card</h2>
    <p>Stacked on mobile, side-by-side on desktop</p>
  </div>
</div>
```

### Color Customization
Use background classes like `bg-primary` with `text-primary-content` for themed cards.

```html
<div class="card bg-primary text-primary-content">
  <div class="card-body">
    <h2 class="card-title">Primary Card</h2>
    <p>Uses theme colors</p>
  </div>
</div>
```

---

## Table Component

### Core Component Classes

The documentation outlines several key table styling options:

- **`table`**: Base component class for `<table>` tags
- **`table-zebra`**: "For `<table>` to show zebra stripe rows"
- **`table-pin-rows`**: "For `<table>` to make all the rows inside `<thead>` and `<tfoot>` sticky"
- **`table-pin-cols`**: "For `<table>` to make all the `<th>` columns sticky"

### Size Modifiers

Five size variants are available (table-md is default):
- `table-xs` (Extra small)
- `table-sm` (Small)
- `table-md` (Medium)
- `table-lg` (Large)
- `table-xl` (Extra large)

### Basic Table

```html
<div class="overflow-x-auto">
  <table class="table">
    <thead>
      <tr>
        <th></th>
        <th>Name</th>
        <th>Job</th>
        <th>Favorite Color</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th>1</th>
        <td>Cy Ganderton</td>
        <td>Quality Control Specialist</td>
        <td>Blue</td>
      </tr>
      <tr>
        <td>2</td>
        <td>Hart Hagerty</td>
        <td>Desktop Support Technician</td>
        <td>Purple</td>
      </tr>
    </tbody>
  </table>
</div>
```

### Styling Patterns

**Zebra Striping:**
```html
<table class="table table-zebra">
  <!-- table content -->
</table>
```

**Enhanced Styling:**
```html
<table class="table border border-base-content/5 bg-base-100 rounded-lg">
  <!-- table content -->
</table>
```

**Interactive States:**
```html
<tbody>
  <tr class="hover:bg-base-300">
    <td>Hover Row</td>
  </tr>
  <tr class="bg-base-200">
    <td>Active/Selected Row</td>
  </tr>
</tbody>
```

### Advanced Features

**Pinned Columns & Rows:**
```html
<table class="table table-pin-rows table-pin-cols">
  <thead>
    <tr>
      <th>Sticky Header</th>
      <th>Column 2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Sticky Column</th>
      <td>Regular cell</td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <th>Sticky Footer</th>
      <td>Footer cell</td>
    </tr>
  </tfoot>
</table>
```

**Visual Elements:** Complex table example incorporates avatars, badges, checkboxes, and action buttons within cells.

---

## Badge Component

### Basic Structure
The badge component uses the `.badge` class as its container element. It's a simple, versatile component for displaying status information.

```html
<div class="badge">neutral</div>
<div class="badge badge-primary">primary</div>
```

### Size Options
daisyUI offers five size variants:
- `.badge-xs` (extra small)
- `.badge-sm` (small)
- `.badge-md` (medium/default)
- `.badge-lg` (large)
- `.badge-xl` (extra large)

```html
<div class="badge badge-xs">xs</div>
<div class="badge badge-sm">sm</div>
<div class="badge badge-md">md</div>
<div class="badge badge-lg">lg</div>
<div class="badge badge-xl">xl</div>
```

### Color Variants
Eight semantic colors are available: primary, secondary, accent, neutral, info, success, warning, and error.

```html
<div class="badge badge-primary">primary</div>
<div class="badge badge-secondary">secondary</div>
<div class="badge badge-accent">accent</div>
<div class="badge badge-info">info</div>
<div class="badge badge-success">success</div>
<div class="badge badge-warning">warning</div>
<div class="badge badge-error">error</div>
```

### Style Variations

**Soft Style** (`.badge-soft`): Creates a lighter, less prominent appearance while maintaining color identity.

```html
<div class="badge badge-soft badge-primary">soft primary</div>
```

**Outline Style** (`.badge-outline`): Displays borders instead of filled backgrounds

```html
<div class="badge badge-outline badge-primary">outline</div>
```

**Dash Style** (`.badge-dash`): Offers a dashed border variant

```html
<div class="badge badge-dash badge-primary">dash</div>
```

**Ghost Style** (`.badge-ghost`): Minimal styling with subtle appearance

```html
<div class="badge badge-ghost">ghost</div>
```

### Integration Examples

**In text:**
```html
<h1 class="text-xl">
  Heading
  <div class="badge badge-xl">NEW</div>
</h1>
```

**In buttons:**
```html
<button class="btn">
  Inbox
  <div class="badge">+99</div>
</button>
```

**As indicators:**
```html
<div class="badge badge-xs"></div>
<div class="badge badge-sm"></div>
<div class="badge badge-md"></div>
```
