# Customizing the Rubric

The default rubric weights are UX Friction (0.40), Visual Polish (0.35), Brand Alignment (0.25). You can adjust these to match your priorities.

## Inline Weight Override

```
/autoux
Goal: Improve brand consistency
Rubric-Weights: ux_friction=0.2, visual_polish=0.3, brand_alignment=0.5
```

## Suggested Weights by Goal

| Goal | UX | Polish | Brand |
|------|-----|--------|-------|
| General improvement (default) | 0.40 | 0.35 | 0.25 |
| Mobile/accessibility focus | 0.50 | 0.30 | 0.20 |
| Visual polish / premium feel | 0.25 | 0.50 | 0.25 |
| Brand/design system adherence | 0.20 | 0.30 | 0.50 |
| E-commerce conversion | 0.50 | 0.25 | 0.25 |

## Hard Gates

Hard gates are always active and cannot be weighted — they are binary pass/fail:

- **Accessibility Gate** — WCAG AA contrast, text size, touch targets
- **Layout Integrity Gate** — No overflow, no overlap, no horizontal scroll
- **Console Errors Gate** — Zero JavaScript errors

A hard gate failure = immediate discard, regardless of soft scores.

## Score Anchors

Each soft dimension uses anchored 1-10 descriptions to ensure consistent scoring:

| Score | Meaning |
|-------|---------|
| 1-2 | Unusable / Amateur |
| 3-4 | Frustrating / Rough |
| 5-6 | Functional / Acceptable |
| 7-8 | Clear / Professional |
| 9-10 | Effortless / World-class |

See `references/rubric.md` for full anchor descriptions per dimension.
