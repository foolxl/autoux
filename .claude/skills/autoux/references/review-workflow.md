# Review Workflow — One-Shot Design Evaluation

A non-iterative, comprehensive design review using the AutoUX judge panel. Captures screenshots, runs all judge personas, and outputs a structured report.

## Overview

Unlike the main `/autoux` loop, `/autoux:review` does NOT modify code. It evaluates the current state of a page and produces a report with scores, critiques, and prioritized suggestions.

Think of it as a "design health check" — run it before starting an optimization loop, after completing one, or anytime you want structured feedback on a UI.

## Interactive Setup

### Required Context

| Field | Required? | Default |
|-------|-----------|---------|
| Page | YES | None — must be provided |
| Viewports | No | All three (desktop, tablet, mobile) |
| Design Refs | No | Auto-detect `context/design-principles.md`, `context/style-guide.md` |

### If Page is missing

Use `AskUserQuestion`:

| # | Header | Question | Options |
|---|--------|----------|---------|
| 1 | `Page` | "What URL should I review?" | Detected dev server URLs, Custom |
| 2 | `Viewports` | "Which viewport sizes?" | "All three", "Desktop only", "Mobile only", Custom |

## Execution Protocol

### Step 1: Navigate

```
mcp__playwright__browser_navigate(url=Page)
mcp__playwright__browser_wait_for(selector="body", timeout=10000)
```

If page fails to load, inform user and abort.

### Step 2: Capture Screenshots

```
FOR viewport IN configured_viewports:
  mcp__playwright__browser_resize(width, height)
  wait 500ms
  mcp__playwright__browser_take_screenshot()
```

### Step 3: Capture Context

```
mcp__playwright__browser_console_messages()    # JS errors
mcp__playwright__browser_snapshot()             # DOM structure
```

### Step 4: Read Design References

If `context/design-principles.md` and/or `context/style-guide.md` exist, read them for Brand Alignment evaluation.

### Step 5: Run Judge Panel

Execute the full evaluation protocol from `references/judge-system.md`:

1. Hard gates (Console, Layout, Accessibility)
2. Soft scores (UX Friction, Visual Polish, Brand Alignment)
3. Meta-Judge synthesis

### Step 6: Generate Report

Output a structured report following this format:

```markdown
## Design Review Report

**Page:** {url}
**Date:** {date}
**Viewports tested:** {list}

### Overall Score

| Dimension | Score | Rating |
|-----------|-------|--------|
| UX Friction | 7/10 | Clear |
| Visual Polish | 5/10 | Acceptable |
| Brand Alignment | 8/10 | On-brand |
| **Composite** | **6.55** | — |

### Hard Gates

| Gate | Status | Details |
|------|--------|---------|
| Accessibility | PASS | All contrast ratios meet WCAG AA |
| Layout Integrity | PASS | No overflow issues detected |
| Console Errors | FAIL | 2 JS errors in console |

### Findings

#### Blockers
- **Console Error:** `TypeError: Cannot read property 'map' of undefined` at line 42 of ProductList.tsx. This must be fixed before any design optimization.

#### High Priority
- **Visual Polish:** Section spacing is inconsistent — hero has 64px bottom margin, features section has 32px. Standardize to a consistent vertical rhythm.
- **UX Friction:** Primary CTA ("Add to Cart") is below the fold on mobile. Consider repositioning above product description.

#### Medium Priority
- **Brand Alignment:** Hero section uses a custom drop-shadow not defined in the design system. Replace with elevation-2 token.
- **Visual Polish:** Card border-radius varies between 8px and 12px across different components.

#### Nitpicks
- Nit: Footer link hover color (#666) is close to the default (#333) — could use more contrast for better feedback.
- Nit: Image aspect ratios are inconsistent in the product grid.

### Viewport-Specific Notes

**Desktop (1440px):** Strong layout with good use of whitespace. Typography hierarchy is clear.

**Tablet (768px):** Grid adapts well but sidebar navigation overlaps with main content at exactly 768px.

**Mobile (375px):** CTA is too far below the fold. Touch targets for secondary links are 36px (should be 44px).

### Suggested Next Steps

1. Fix console JS errors (blocker)
2. Standardize section spacing to consistent rhythm
3. Improve mobile CTA positioning
4. Replace custom shadows with design system tokens
5. Unify card border-radius

### AutoUX Optimization Command

To automatically improve this page, run:
```
/autoux
Goal: Improve visual polish and fix identified issues
Scope: {detected scope}
Page: {url}
Iterations: 10
```
```

## Key Differences from Loop Mode

| Aspect | /autoux (loop) | /autoux:review (one-shot) |
|--------|---------------|--------------------------|
| Modifies code? | Yes | No — read-only |
| Iterates? | Yes (N times or forever) | No — single pass |
| Output | Running log + judgment JSONs | Structured report |
| Git changes? | Yes (commits + reverts) | No |
| Purpose | Autonomous improvement | Diagnostic assessment |
| When to use | Active optimization | Before/after optimization, or quick health check |
