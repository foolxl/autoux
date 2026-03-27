# Plan Workflow — Goal → Configuration Wizard

Converts a plain-language design goal into a validated, ready-to-execute AutoUX configuration.

## Overview

The plan wizard helps users set up an AutoUX run by:
1. Understanding their design improvement goal
2. Scanning the project for relevant files and running dev server
3. Configuring scope, page, viewports, and rubric
4. Taking baseline screenshots and showing starting scores
5. Generating a ready-to-paste `/autoux` command

## Interactive Setup

### If Goal is provided inline

Extract from `$ARGUMENTS` and skip to Step 2.

### If Goal is missing

Use `AskUserQuestion` with a single question:

| # | Header | Question | Options |
|---|--------|----------|---------|
| 1 | `Goal` | "What do you want to improve visually?" | "Overall visual polish", "Mobile responsiveness", "Accessibility compliance", "Brand consistency", "Specific component (describe)", Custom |

## Wizard Steps

### Step 1: Capture Goal

Parse the user's goal into a clear, actionable design objective.

**Examples:**
- "Make the checkout feel premium" → Goal: Improve visual polish and brand alignment of checkout page
- "Fix mobile issues" → Goal: Improve mobile responsiveness and layout integrity
- "Match our brand better" → Goal: Improve brand alignment against style guide

### Step 2: Analyze Project Context

Scan the project to detect:

```
1. Framework detection
   - Look for: package.json (React, Vue, Next.js, Svelte, etc.)
   - Look for: tailwind.config.*, postcss.config.*
   - Look for: tsconfig.json, jsconfig.json

2. Component file discovery
   - Glob: src/components/**/*.{tsx,jsx,vue,svelte}
   - Glob: src/pages/**/*.{tsx,jsx,vue,svelte}
   - Glob: app/**/*.{tsx,jsx}

3. Style file discovery
   - Glob: src/styles/**/*.{css,scss,less}
   - Glob: src/**/*.module.{css,scss}
   - Glob: tailwind.config.*

4. Design reference detection
   - Look for: context/design-principles.md
   - Look for: context/style-guide.md
   - Look for: .claude/context/*.md

5. Dev server detection
   - Check package.json scripts for: dev, start, serve
   - Check if common ports are active: 3000, 5173, 8080, 4321
```

### Step 3: Configure — Batched Questions

Use `AskUserQuestion` with 4 questions:

| # | Header | Question | Options (from scan) |
|---|--------|----------|---------------------|
| 1 | `Scope` | "Which files should AutoUX be allowed to modify?" | Suggested globs from scan (e.g. `src/components/checkout/**/*.tsx, src/styles/checkout.css`). Include "All frontend files" and Custom options |
| 2 | `Page` | "What URL should I render and take screenshots of?" | Detected dev server URL. Include "I need to start my dev server first" option |
| 3 | `Viewports` | "Which viewport sizes to test?" | "All three (desktop 1440px, tablet 768px, mobile 375px)", "Desktop only (1440px)", "Desktop + Mobile", "Mobile only (375px)", Custom |
| 4 | `Design Refs` | "Do you have design principles or style guide files to evaluate against?" | Detected paths if found, "No — judge internal consistency only", "I'll create them", Custom path |

### Step 4: Configure Rubric (Optional)

If the user's goal suggests specific weighting:

| Goal Keywords | Suggested Weights |
|--------------|-------------------|
| "accessibility", "a11y", "WCAG" | UX: 0.30, Polish: 0.20, Brand: 0.50 |
| "mobile", "responsive" | UX: 0.50, Polish: 0.30, Brand: 0.20 |
| "brand", "consistency", "design system" | UX: 0.20, Polish: 0.30, Brand: 0.50 |
| "polish", "premium", "beautiful" | UX: 0.25, Polish: 0.50, Brand: 0.25 |
| Default (no strong signal) | UX: 0.40, Polish: 0.35, Brand: 0.25 |

Ask via `AskUserQuestion`:

| # | Header | Question | Options |
|---|--------|----------|---------|
| 1 | `Rubric` | "Based on your goal, I suggest these rubric weights. Adjust?" | Suggested weights, "Looks good", Custom |

### Step 5: Verify Dev Server

Navigate to the Page URL via Playwright MCP:

```
mcp__playwright__browser_navigate(url=Page)
```

- **If successful:** Continue to baseline capture
- **If fails:** Inform user, ask them to start their dev server, wait and retry

### Step 6: Baseline Capture

Take initial screenshots and run the judge panel to establish baseline scores:

```
1. Navigate to Page
2. Screenshot at each viewport
3. Run full judge panel
4. Display baseline scores to user:

   === AutoUX Baseline ===
   Page: http://localhost:3000/checkout

   Hard Gates:
     Accessibility: pass
     Layout Integrity: pass
     Console Errors: pass

   Soft Scores:
     UX Friction:     5/10
     Visual Polish:   4/10
     Brand Alignment: 6/10
     Composite:       4.90

   Key critiques:
   - UX: "Hero section lacks clear visual hierarchy, CTA competes with navigation"
   - Polish: "Inconsistent spacing — varies from 16px to 48px between sections"
   - Brand: "Color palette matches but typography uses system fonts instead of brand font"
```

### Step 7: Confirm & Launch

Present the complete configuration and offer to launch:

```
=== AutoUX Configuration ===
Goal: Improve visual polish of checkout page
Scope: src/components/checkout/**/*.tsx, src/styles/checkout.css
Page: http://localhost:3000/checkout
Viewports: desktop (1440), tablet (768), mobile (375)
Rubric: UX 0.40, Polish 0.35, Brand 0.25
Design Refs: context/design-principles.md, context/style-guide.md
Baseline Composite: 4.90
```

Use `AskUserQuestion`:

| # | Header | Question | Options |
|---|--------|----------|---------|
| 1 | `Launch` | "Configuration ready. How would you like to proceed?" | "Launch now (unlimited)", "Launch with iteration limit (specify N)", "Show me the command to run later", "Edit configuration", "Cancel" |

If "Show me the command":
```
/autoux
Goal: Improve visual polish of checkout page
Scope: src/components/checkout/**/*.tsx, src/styles/checkout.css
Page: http://localhost:3000/checkout
Viewports: desktop,tablet,mobile
```

If "Launch now" or with iteration limit: proceed directly to SKILL.md's loop execution.
