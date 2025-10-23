# daisyUI Theme System

## Core Functionality
daisyUI includes "35 built-in themes that instantly transform your website's entire look." The system allows developers to manage themes through configuration in CSS files and apply them via HTML attributes.

## Built-in Themes (35 Total)

**Light themes:** light, cupcake, bumblebee, emerald, corporate, fantasy, wireframe, cmyk, autumn, acid, lemonade, winter, lofi, pastel, caramellatte

**Dark themes:** dark, synthwave, retro, cyberpunk, valentine, halloween, garden, forest, aqua, luxury, dracula, business, night, coffee, dim, nord, sunset, abyss, silk, black

## Theme Implementation

### Configuration Syntax

```css
@plugin "daisyui" {
  themes: light --default, dark --prefersdark;
}
```

The system supports three flags:
- `--default`: Sets a theme as the primary option
- `--prefersdark`: Makes a theme default for dark mode preferences
- `all`: Enables all 35 built-in themes

**Enable all themes:**
```css
@plugin "daisyui" {
  themes: all;
}
```

**Enable specific themes:**
```css
@plugin "daisyui" {
  themes: light, dark, cupcake, cyberpunk;
}
```

### HTML Application

Add `data-theme="THEME_NAME"` to any element to apply that theme to its contents. Themes can be nested without limitations.

**Apply to entire page:**
```html
<html data-theme="dark">
  <!-- All content uses dark theme -->
</html>
```

**Apply to specific sections:**
```html
<div data-theme="light">
  <!-- Light theme section -->
</div>
<div data-theme="dark">
  <!-- Dark theme section -->
</div>
```

**Nested themes:**
```html
<div data-theme="light">
  <p>Light theme content</p>
  <div data-theme="dark">
    <p>Dark theme content inside light section</p>
  </div>
</div>
```

## Customization Options

### Creating Custom Themes

Use `@plugin "daisyui/theme"` with CSS variables for colors, border radius, sizing, and visual effects:

```css
@plugin "daisyui/theme" {
  themes: {
    mytheme: {
      primary: "#570df8",
      secondary: "#f000b8",
      accent: "#37cdbe",
      neutral: "#3d4451",
      "base-100": "#ffffff",
      info: "#3abff8",
      success: "#36d399",
      warning: "#fbbd23",
      error: "#f87272",
    }
  }
}
```

### Customizing Existing Themes

Reference a theme name while overriding specific variables—unmodified values inherit from the original theme:

```css
@plugin "daisyui/theme" {
  themes: {
    mylight: {
      ...light,
      primary: "#ff0000",
      secondary: "#00ff00",
    }
  }
}
```

### Theme-Specific Styling

Target elements using bracket selectors:

```css
[data-theme="light"] .my-component {
  background: white;
}

[data-theme="dark"] .my-component {
  background: black;
}
```

## Theme Colors Reference

All DaisyUI components use these theme variables:

**Color Semantics:**
- `primary` - Main brand color
- `secondary` - Secondary brand color
- `accent` - Accent color for highlights
- `neutral` - Neutral color for text and backgrounds
- `base-100`, `base-200`, `base-300` - Base background colors
- `info` - Informational messages
- `success` - Success states
- `warning` - Warning states
- `error` - Error states

**Content Colors:**
Each color has a corresponding `-content` variant for text:
- `primary-content` - Text on primary background
- `secondary-content` - Text on secondary background
- `accent-content` - Text on accent background
- etc.

## Dynamic Theme Switching

### JavaScript Theme Switcher

```html
<select data-choose-theme>
  <option value="">Default</option>
  <option value="light">Light</option>
  <option value="dark">Dark</option>
  <option value="cupcake">Cupcake</option>
</select>

<script>
  const themeSelect = document.querySelector('[data-choose-theme]');
  themeSelect.addEventListener('change', function() {
    document.documentElement.setAttribute('data-theme', this.value);
    localStorage.setItem('theme', this.value);
  });

  // Load saved theme
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme) {
    document.documentElement.setAttribute('data-theme', savedTheme);
    themeSelect.value = savedTheme;
  }
</script>
```

### Respect System Preferences

```javascript
// Check if user prefers dark mode
const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
if (prefersDark && !localStorage.getItem('theme')) {
  document.documentElement.setAttribute('data-theme', 'dark');
}

// Listen for system theme changes
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
  if (!localStorage.getItem('theme')) {
    document.documentElement.setAttribute('data-theme', e.matches ? 'dark' : 'light');
  }
});
```

## Best Practices

1. **Enable only needed themes** to reduce CSS bundle size
2. **Set defaults** using `--default` and `--prefersdark` flags
3. **Store user preference** in localStorage for persistence
4. **Respect system preferences** as default behavior
5. **Use theme variables** instead of hardcoded colors in custom CSS
6. **Test components** in both light and dark themes
7. **Provide theme switcher** for better UX
