# /autoux — The Autonomous Optimization Loop

The main command for targeted UI optimization with full control over scope, goal, and rubric.

## Usage

```
/autoux
Goal: Make the checkout flow feel more premium
Scope: src/components/checkout/**/*.tsx, src/styles/checkout.css
Page: http://localhost:3000/checkout
Iterations: 15
```

## Configuration Fields

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `Goal` | Yes | What to improve visually | "Improve mobile responsiveness" |
| `Scope` | Yes | File globs the agent can modify | `src/components/**/*.tsx` |
| `Page` | Yes | URL to render and screenshot | `http://localhost:3000` |
| `Viewports` | No | Viewport sizes to test (default: all three) | `desktop,mobile` |
| `Design-Refs` | No | Paths to design reference files | `context/style-guide.md` |
| `Rubric-Weights` | No | Custom rubric weights | `ux_friction=0.5, visual_polish=0.3, brand_alignment=0.2` |
| `Iterations` | No | Bounded mode — stop after N iterations | `10` |

If any required field is missing, AutoUX will ask you interactively.

## The Loop

Each iteration follows 8 phases:

1. **Review** — Read code, git history, previous judge critiques
2. **Ideate** — Pick next change based on critiques ("gradient")
3. **Modify** — Make ONE focused visual change
4. **Commit** — Git commit before evaluation
5. **Render** — Playwright screenshots at each viewport
6. **Judge** — 4 judge personas evaluate (gates + scores)
7. **Decide** — Keep if improved, discard if not
8. **Log** — Record scores and critiques

## Bounded vs Unbounded

**Bounded** (`Iterations: N`) — Runs exactly N iterations, then prints a summary. Good for time-boxed sessions.

**Unbounded** (default) — Runs forever until you press `Ctrl+C`. Good for overnight runs.

## Examples

```
# Quick polish pass
/autoux
Goal: Polish the landing page
Scope: src/components/landing/**/*.tsx
Page: http://localhost:3000
Iterations: 10

# Mobile-focused improvement
/autoux
Goal: Fix mobile responsiveness issues
Scope: src/styles/**/*.css
Page: http://localhost:3000
Viewports: mobile
Iterations: 15

# Brand alignment
/autoux
Goal: Match our brand style guide precisely
Scope: src/components/**/*.tsx, src/styles/**/*.css
Page: http://localhost:3000
Design-Refs: context/style-guide.md
Rubric-Weights: brand_alignment=0.5, visual_polish=0.3, ux_friction=0.2
```
