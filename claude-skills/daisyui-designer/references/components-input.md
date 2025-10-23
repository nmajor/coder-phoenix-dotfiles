# daisyUI Data Input Components

## Text Input Component

### Basic Input
The foundational component uses the `input` class on `<input type="text">` elements.

```html
<input type="text" class="input input-bordered" placeholder="Type here" />
```

### Style Variants
- **Ghost Style**: `input-ghost` - A minimal style variant
- **Neutral**: `input-neutral` - Neutral color option
- **Bordered**: `input-bordered` - With border (recommended for most cases)

### Color Options
Semantic color classes: `input-primary`, `input-secondary`, `input-accent`, `input-info`, `input-success`, `input-warning`, and `input-error`.

```html
<input type="text" class="input input-bordered input-primary" />
<input type="text" class="input input-bordered input-success" />
<input type="text" class="input input-bordered input-error" />
```

### Size Classes
Five responsive sizes are available: `input-xs`, `input-sm`, `input-md` (default), `input-lg`, and `input-xl`.

```html
<input type="text" class="input input-bordered input-xs" />
<input type="text" class="input input-bordered input-sm" />
<input type="text" class="input input-bordered input-md" />
<input type="text" class="input input-bordered input-lg" />
<input type="text" class="input input-bordered input-xl" />
```

### State Handling
Inputs support the `disabled` attribute for disabled states.

```html
<input type="text" class="input input-bordered" disabled />
```

### Form Integration Patterns

**Label Wrapping**: "We can use input class for the parent and put anything inside it" - this enables composite inputs with icons, text labels, badges, and keyboard shortcuts grouped together.

```html
<label class="input input-bordered flex items-center gap-2">
  <svg><!-- icon --></svg>
  <input type="text" class="grow" placeholder="Search" />
</label>
```

**Fieldset Integration**: Examples use `fieldset`, `fieldset-legend`, and `label` classes alongside inputs for semantic form structures.

```html
<fieldset class="fieldset">
  <legend class="fieldset-legend">Enter your details</legend>
  <label class="label">
    <span class="label-text">Name</span>
  </label>
  <input type="text" class="input input-bordered" />
</fieldset>
```

**Join Component**: Inputs combine with buttons using the `join` class for grouped actions (e.g., email input + subscribe button).

```html
<div class="join">
  <input type="text" class="input input-bordered join-item" placeholder="Email" />
  <button class="btn join-item btn-primary">Subscribe</button>
</div>
```

### Supported Input Types
Beyond text, the input class works with: password, email, number, date, datetime-local, week, month, tel, url, search, and time.

```html
<input type="email" class="input input-bordered" placeholder="Email" />
<input type="password" class="input input-bordered" placeholder="Password" />
<input type="number" class="input input-bordered" placeholder="Number" />
<input type="date" class="input input-bordered" />
```

## Other Form Components

### Checkbox
```html
<input type="checkbox" class="checkbox" />
<input type="checkbox" class="checkbox checkbox-primary" />
<input type="checkbox" class="checkbox checkbox-sm" />
```

### Toggle
```html
<input type="checkbox" class="toggle" />
<input type="checkbox" class="toggle toggle-primary" />
<input type="checkbox" class="toggle toggle-lg" />
```

### Radio
```html
<input type="radio" name="radio" class="radio" />
<input type="radio" name="radio" class="radio radio-primary" />
```

### Select
```html
<select class="select select-bordered">
  <option>Option 1</option>
  <option>Option 2</option>
</select>
```

### Textarea
```html
<textarea class="textarea textarea-bordered" placeholder="Enter text"></textarea>
```

### Range Slider
```html
<input type="range" class="range" />
<input type="range" class="range range-primary" />
```
