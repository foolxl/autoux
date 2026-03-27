# /autoux:review — One-Shot Design Review

A read-only design evaluation. Captures screenshots, runs the full judge panel, and outputs a structured report — without modifying any code.

## Usage

```
/autoux:review
Page: http://localhost:3000

/autoux:review Page: http://localhost:3000/checkout Viewports: desktop,mobile
```

## What It Does

1. Navigates to the page via Playwright
2. Screenshots at desktop (1440px), tablet (768px), mobile (375px)
3. Captures console logs and DOM structure
4. Runs all 4 judge personas
5. Outputs a structured report with scores, critiques, and prioritized suggestions

## When to Use

- **Before optimization** — See where you stand
- **After optimization** — Verify improvements
- **Quick health check** — Spot issues without running the full loop
- **PR review** — Evaluate UI changes before merging

## Output Format

The report includes:

- **Overall scores** — Composite + per-dimension
- **Hard gate results** — Accessibility, layout, console errors
- **Findings by priority** — Blockers, high, medium, nitpicks
- **Viewport-specific notes** — Per-viewport observations
- **Suggested next steps** — Prioritized action items
- **Ready-to-run command** — `/autoux` invocation if you want to fix issues automatically

## Key Difference from /autoux

| | /autoux:review | /autoux |
|---|---|---|
| Modifies code? | No | Yes |
| Iterates? | No (single pass) | Yes (N times or forever) |
| Output | Structured report | Running log + judgments |
| Git changes? | None | Commits + reverts |
