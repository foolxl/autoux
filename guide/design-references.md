# Design References

AutoUX's Brand Alignment judge evaluates your UI against two reference files. Without them, it evaluates internal consistency. With them, it checks adherence to your specific design system.

## Files

| File | Purpose |
|------|---------|
| `context/design-principles.md` | Your design philosophy — visual hierarchy, spacing rules, typography principles |
| `context/style-guide.md` | Your specific tokens — colors, fonts, spacing values, component patterns |

Template files are included with AutoUX. Customize them for your project.

## Writing Effective Design Principles

Focus on **rules the agent can evaluate visually**:

**Good** (observable in screenshots):
- "Use an 8px spacing grid"
- "Primary CTA must be the most prominent element"
- "Minimum contrast ratio 4.5:1 for all text"

**Less useful** (not visible in screenshots):
- "Code should be maintainable"
- "Components should be reusable"
- "Performance should be optimized"

## Writing an Effective Style Guide

Include **specific values** the judge can compare against:

```markdown
## Colors
| Token | Value | Usage |
|-------|-------|-------|
| --color-primary | #2563eb | Primary buttons, links |

## Typography
| Token | Value |
|-------|-------|
| --font-family | 'Inter', system-ui, sans-serif |
| --font-size-base | 16px |

## Spacing
Based on 8px grid: 8, 16, 24, 32, 48, 64, 96
```

The more specific your tokens, the more precisely the Brand Alignment judge can evaluate.

## Using Existing Design Systems

If you already have a Tailwind config or CSS custom properties, you don't need to duplicate them. Point AutoUX to your existing files:

```
/autoux
Design-Refs: tailwind.config.ts, src/styles/tokens.css
```

Or extract your tokens into the template files for a cleaner reference.

## Without Design References

AutoUX works without any reference files. In this case, the Brand Alignment judge evaluates **internal consistency** — does the design use colors, fonts, and spacing consistently within itself?
