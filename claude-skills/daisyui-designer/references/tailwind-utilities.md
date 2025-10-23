# Tailwind CSS Utility-First Fundamentals

## Core Concept

Tailwind's philosophy centers on **composing styles directly in markup** using single-purpose utility classes rather than writing custom CSS. As the documentation explains: "you style things with Tailwind by combining many single-purpose presentational classes directly in your markup."

## Essential Layout Utilities for DaisyUI Integration

### Flexbox Foundation
- `flex` - establishes flex container
- `flex-col` / `flex-row` - controls direction
- `gap-*` - manages spacing between items
- `items-center`, `justify-center` - alignment controls

### Grid System
- `grid` - creates grid layout
- `grid-cols-*` - defines column count
- `gap-*` - uniform spacing

### Spacing Primitives
- `p-*` (padding), `m-*` (margin) - consistent spacing scale
- `mx-auto` - horizontal centering
- `space-*` - inter-element gaps

## Key Principles

**Constraints Over Magic Numbers**: Utilities enforce a predefined design system, preventing arbitrary values that fragment visual consistency.

**State Variants Without Inline Styles**: Unlike inline styles, utilities support hover, focus, responsive prefixes (`sm:`, `lg:`), and dark mode (`dark:`) modifiers—critical for interactive components.

**Composition Over Conflicts**: Multiple utilities combine via CSS variables (e.g., `blur-sm grayscale` both modify the `filter` property without collision).

## Practical Integration Pattern

DaisyUI components handle semantics and interactivity; Tailwind utilities provide layout scaffolding:
- Use `flex gap-4` for component spacing
- Apply `md:grid-cols-2` for responsive component grids
- Leverage `dark:` prefix for theme consistency

This separation keeps component markup clean while maintaining layout flexibility.
