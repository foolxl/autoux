# /autoux:plan — Interactive Setup Wizard

Helps you configure an AutoUX run by scanning your project, suggesting smart defaults, and taking baseline screenshots.

## Usage

```
/autoux:plan
Goal: Make the checkout flow feel more premium

/autoux:plan Improve mobile responsiveness
```

## What It Does

1. **Captures your goal** — What you want to improve visually
2. **Scans your project** — Detects framework, style files, dev server
3. **Suggests configuration** — File scope, page URL, viewports
4. **Configures rubric** — Adjusts weights based on your goal
5. **Takes baseline screenshots** — Shows your starting scores
6. **Generates command** — Ready-to-paste `/autoux` invocation

## When to Use

- First time using AutoUX on a project
- Want to see baseline scores before committing to a loop
- Need help configuring scope and rubric weights
- Want a guided setup instead of writing config inline

## Example Flow

```
> /autoux:plan
> Goal: Improve visual polish of the dashboard

=== Project Analysis ===
Framework: Next.js (React) + Tailwind CSS
Style files: 12 CSS/module files
Components: 34 TSX files in src/components/

=== Configuration ===
Scope: src/components/dashboard/**/*.tsx, src/styles/dashboard.css
Page: http://localhost:3000/dashboard
Viewports: desktop (1440), tablet (768), mobile (375)
Rubric: UX 0.25, Polish 0.50, Brand 0.25 (polish-focused for your goal)

=== Baseline Scores ===
  UX Friction:     6/10
  Visual Polish:   4/10
  Brand Alignment: 7/10
  Composite:       5.45

Ready to run:
/autoux
Goal: Improve visual polish of the dashboard
Scope: src/components/dashboard/**/*.tsx, src/styles/dashboard.css
Page: http://localhost:3000/dashboard
Iterations: 15
```
