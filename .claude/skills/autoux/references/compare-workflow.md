# Compare Workflow — A/B Design Comparison

Compare two design states side-by-side using the full AutoUX judge panel. Useful for evaluating different branches, reviewing before/after states, or choosing between design approaches.

## Overview

`/autoux:compare` renders and evaluates two different states of a page, producing a structured comparison report with per-dimension score deltas and a recommendation.

## Interactive Setup

### Required Context

| Field | Required? | Description |
|-------|-----------|-------------|
| Page | YES | URL to render |
| State A | YES | Branch name, commit hash, or "current" |
| State B | YES | Branch name, commit hash, or "current" |
| Viewports | No | Default: all three |

### If context is missing

Use `AskUserQuestion` with batched questions:

| # | Header | Question | Options |
|---|--------|----------|---------|
| 1 | `Page` | "What URL should I compare?" | Detected dev server URL, Custom |
| 2 | `State A` | "What is the first design state (baseline)?" | "Current working tree", Branch name, Commit hash |
| 3 | `State B` | "What is the second design state (variant)?" | Recent branches, Commit hash |
| 4 | `Viewports` | "Which viewports to compare?" | "All three", "Desktop only", Custom |

## Execution Protocol

### Step 1: Capture State A

```
1. If State A is a branch:
   git stash (if dirty)
   git checkout {branch-a}
   Wait for dev server hot-reload (2-3 seconds)

2. If State A is a commit:
   git stash (if dirty)
   git checkout {commit-a}
   Wait for dev server hot-reload

3. If State A is "current":
   Use current working tree as-is

4. Navigate to Page
   mcp__playwright__browser_navigate(url=Page)
   mcp__playwright__browser_wait_for(selector="body", timeout=10000)

5. Capture screenshots at all viewports
   FOR viewport IN viewports:
     mcp__playwright__browser_resize(width, height)
     mcp__playwright__browser_take_screenshot()
     → Save as state-a-{viewport}.png

6. Capture console + DOM
   mcp__playwright__browser_console_messages()
   mcp__playwright__browser_snapshot()

7. Run judge panel on State A
   → Produce judgment JSON for State A
```

### Step 2: Capture State B

```
1. Switch to State B (branch or commit)
   git checkout {branch-b or commit-b}
   Wait for dev server hot-reload (2-3 seconds)

2. Repeat steps 4-7 from State A capture
   → Produce judgment JSON for State B
```

### Step 3: Restore Original State

```
git checkout {original-branch}
git stash pop (if stashed)
```

### Step 4: Generate Comparison Report

```markdown
## A/B Design Comparison

**Page:** {url}
**Date:** {date}
**State A:** {branch-a / commit-a} — "{description}"
**State B:** {branch-b / commit-b} — "{description}"

### Score Comparison

| Dimension | State A | State B | Delta | Winner |
|-----------|---------|---------|-------|--------|
| UX Friction | 5 | 7 | +2 | B |
| Visual Polish | 6 | 8 | +2 | B |
| Brand Alignment | 7 | 6 | -1 | A |
| **Composite** | **5.85** | **7.05** | **+1.20** | **B** |

### Hard Gates

| Gate | State A | State B |
|------|---------|---------|
| Accessibility | PASS | PASS |
| Layout Integrity | PASS | PASS |
| Console Errors | FAIL (1 error) | PASS |

### Key Differences

**State B improves:**
- UX Friction (+2): CTA is more prominent, information hierarchy is clearer
- Visual Polish (+2): Spacing is consistent, typography hierarchy refined
- Console: Fixed JS error present in State A

**State A is better at:**
- Brand Alignment (-1): State A uses the exact brand font; State B introduced a substitute

### Viewport Breakdown

**Desktop (1440px):**
- State A: Spacious layout but competing visual elements
- State B: Cleaner hierarchy, better whitespace usage

**Mobile (375px):**
- State A: CTA below fold, touch targets too small
- State B: CTA above fold, touch targets adequate (48px)

### Recommendation

**State B is the stronger design** with a +1.20 composite improvement. The brand alignment regression (-1) is minor and addressable by switching back to the brand font.

**Suggested next step:** Merge State B, then run `/autoux` to fix the brand alignment regression:
```
/autoux
Goal: Fix brand font alignment while maintaining visual polish improvements
Scope: {scope}
Page: {url}
Iterations: 5
```
```

## Using Git Worktrees for Parallel Capture

If git worktrees are available, both states can be captured simultaneously:

```
1. Create worktree for State A (if not current):
   git worktree add /tmp/autoux-compare-a {branch-a}

2. Start separate dev server in worktree (different port)

3. Capture both states in parallel

4. Clean up worktree:
   git worktree remove /tmp/autoux-compare-a
```

This is faster but requires the dev server to support running on a different port. Fall back to sequential checkout if worktrees are not practical.

## Comparing More Than Two States

For comparing 3+ design states (e.g., choosing between multiple approaches):

```
/autoux:compare
Page: http://localhost:3000
States: main, feature/approach-a, feature/approach-b
```

The report will include a comparison matrix with all states ranked by composite score.
