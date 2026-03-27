# Style Guide

> Customize this file for your project. This guide defines the specific visual tokens the Brand Alignment judge uses when evaluating adherence. Replace the values below with your actual design system.

## Colors

### Primary Palette

| Token | Value | Usage |
|-------|-------|-------|
| `--color-primary` | `#2563eb` | Primary buttons, links, active states |
| `--color-primary-hover` | `#1d4ed8` | Primary button hover |
| `--color-primary-light` | `#dbeafe` | Primary backgrounds, badges |

### Neutral Palette

| Token | Value | Usage |
|-------|-------|-------|
| `--color-text` | `#111827` | Primary text |
| `--color-text-secondary` | `#6b7280` | Secondary text, labels |
| `--color-text-tertiary` | `#9ca3af` | Placeholder text, disabled |
| `--color-border` | `#e5e7eb` | Borders, dividers |
| `--color-background` | `#ffffff` | Page background |
| `--color-surface` | `#f9fafb` | Card backgrounds, elevated surfaces |

### Semantic Colors

| Token | Value | Usage |
|-------|-------|-------|
| `--color-success` | `#059669` | Success messages, positive indicators |
| `--color-warning` | `#d97706` | Warning messages, caution indicators |
| `--color-error` | `#dc2626` | Error messages, destructive actions |

## Typography

| Token | Value | Usage |
|-------|-------|-------|
| `--font-family` | `'Inter', system-ui, sans-serif` | All text |
| `--font-size-xs` | `12px` | Captions, labels |
| `--font-size-sm` | `14px` | Body text (compact) |
| `--font-size-base` | `16px` | Body text (default) |
| `--font-size-lg` | `18px` | Subheadings |
| `--font-size-xl` | `20px` | Section headings |
| `--font-size-2xl` | `24px` | Page headings |
| `--font-size-3xl` | `32px` | Hero headings |
| `--font-weight-normal` | `400` | Body text |
| `--font-weight-medium` | `500` | Labels, subheadings |
| `--font-weight-semibold` | `600` | Headings, buttons |
| `--font-weight-bold` | `700` | Hero text, emphasis |
| `--line-height-tight` | `1.25` | Headings |
| `--line-height-normal` | `1.5` | Body text |

## Spacing

Based on 8px grid:

| Token | Value | Usage |
|-------|-------|-------|
| `--space-1` | `4px` | Tight inline spacing |
| `--space-2` | `8px` | Icon gaps, compact padding |
| `--space-3` | `12px` | Input padding |
| `--space-4` | `16px` | Card padding, element gaps |
| `--space-6` | `24px` | Section padding |
| `--space-8` | `32px` | Section gaps |
| `--space-12` | `48px` | Large section spacing |
| `--space-16` | `64px` | Page section dividers |
| `--space-24` | `96px` | Hero spacing |

## Border & Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | `4px` | Badges, tags |
| `--radius-md` | `8px` | Cards, inputs, buttons |
| `--radius-lg` | `12px` | Modals, large cards |
| `--radius-full` | `9999px` | Avatars, pills |
| `--border-width` | `1px` | Standard borders |
| `--border-color` | `var(--color-border)` | Default border color |

## Shadows (Elevation)

| Token | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle elevation (cards) |
| `--shadow-md` | `0 4px 6px -1px rgba(0,0,0,0.1)` | Medium elevation (dropdowns) |
| `--shadow-lg` | `0 10px 15px -3px rgba(0,0,0,0.1)` | High elevation (modals) |

## Breakpoints

| Name | Width | Usage |
|------|-------|-------|
| Mobile | `< 640px` | Single column, stacked layout |
| Tablet | `640px - 1024px` | Adapted grid, collapsible nav |
| Desktop | `> 1024px` | Full layout, sidebar nav |

## Component Patterns

### Buttons

- **Primary:** Solid background (`--color-primary`), white text, `--radius-md`, `--space-3` vertical / `--space-4` horizontal padding
- **Secondary:** Border only (`--color-border`), `--color-text` text, same radius/padding
- **Ghost:** No border, no background, `--color-primary` text
- **All buttons:** `--font-weight-semibold`, `--font-size-sm`, min-height 40px (44px on mobile)

### Cards

- Background: `--color-background`
- Border: `--border-width` solid `--color-border`
- Radius: `--radius-md`
- Padding: `--space-4` to `--space-6`
- Shadow: `--shadow-sm` (optional)

### Inputs

- Height: 40px (44px on mobile)
- Border: `--border-width` solid `--color-border`
- Radius: `--radius-md`
- Padding: `--space-3`
- Focus: 2px ring in `--color-primary-light`
