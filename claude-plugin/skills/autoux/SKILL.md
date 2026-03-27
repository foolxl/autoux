---
name: autoux
description: Autonomous UI Design Optimization. Iteratively improve visual design using LLM-as-Judge evaluation with Playwright MCP. Modify code, render screenshots, evaluate against multi-dimensional rubric, keep/discard, repeat.
version: 1.2.0
---

# AutoUX — Autonomous UI Design Optimization

Inspired by [Karpathy's autoresearch](https://github.com/karpathy/autoresearch) and adapted for visual UI/UX improvement. Replaces single numerical metrics with a multi-dimensional LLM-as-Judge evaluation system.

**Core idea:** You are an autonomous agent. Modify → Render → Judge → Keep/Discard → Repeat.

## MANDATORY: Interactive Setup Gate

**CRITICAL — READ THIS FIRST BEFORE ANY ACTION:**

For ALL commands (`/autoux`, `/autoux:auto`, `/autoux:svg`, `/autoux:plan`, `/autoux:review`, `/autoux:compare`):

1. **Check if the user provided ALL required context inline** (Goal, Scope, Page, etc.)
2. **If ANY required context is missing → you MUST use `AskUserQuestion` to collect it BEFORE proceeding to any execution phase.** DO NOT skip this step. DO NOT proceed without user input.
3. Each subcommand's reference file has an "Interactive Setup" section — follow it exactly when context is missing.

| Command | Required Context | If Missing → Ask |
|---------|-----------------|-----------------|
| `/autoux` | Goal, Scope, Page | Batch 1 (4 questions) + Batch 2 (3 questions) from Setup Phase below |
| `/autoux:auto` | None — zero config | Single confirmation only (auto-detects everything) |
| `/autoux:plan` | Goal | Ask via `AskUserQuestion` per `references/plan-workflow.md` |
| `/autoux:review` | Page | Ask via `AskUserQuestion` per `references/review-workflow.md` |
| `/autoux:svg` | Describe (text description) | Ask via `AskUserQuestion` per `references/svg-workflow.md` |
| `/autoux:compare` | Page, Branch-A/B or Commit-A/B | Ask via `AskUserQuestion` per `references/compare-workflow.md` |

**YOU MUST NOT start any loop, phase, or execution without completing interactive setup when context is missing. This is a BLOCKING prerequisite.**

## Subcommands

| Subcommand | Purpose |
|------------|---------|
| `/autoux` | Run the autonomous UI optimization loop (default) |
| `/autoux:auto` | **Zero-config mode.** Auto-detects everything, improves entire frontend to enterprise-grade quality |
| `/autoux:plan` | Interactive wizard to configure Page, Scope, Viewports, Rubric from a Goal |
| `/autoux:review` | One-shot design review: capture screenshots, run judge panel, output structured report |
| `/autoux:svg` | **SVG generator.** Generate and refine logos, icons, plots from a one-line description |
| `/autoux:compare` | A/B comparison of two design states (branches or commits) using the judge panel |

### /autoux:svg — SVG Generation & Refinement

Generate and iteratively refine SVG images from a one-line text description. Supports logos, icons, plots, illustrations, diagrams.

Load: `references/svg-workflow.md` for full protocol.

**What it does:**

1. **Generate** — create initial SVG from your text description
2. **Render** — wrap SVG in HTML, screenshot via Playwright at multiple sizes (64px, 400px, 800px)
3. **Judge** — 4 SVG-specific personas evaluate: Clarity (hard gate), Craft (1-10), Style (1-10), Intent (1-10)
4. **Iterate** — refine based on judge critiques, keep/discard, repeat

**Usage:**
```
# Just describe what you want
/autoux:svg minimalist mountain logo, earth tones

# With options
/autoux:svg Describe: blue tech company logo with circuit patterns Output: logo.svg Iterations: 20

# Icons
/autoux:svg a cute cat icon for a pet app

# Charts/plots
/autoux:svg bar chart showing Q1-Q4 revenue growth
```

**Judge panel (SVG-specific):**
- **Clarity Judge** (hard gate) — readable at 64x64? No broken paths?
- **Craft Judge** (0.35) — path precision, symmetry, geometric consistency
- **Style Judge** (0.35) — color harmony, visual appeal, modern feel
- **Intent Judge** (0.30) — does it match your description?

### /autoux:auto — Zero-Config Enterprise-Grade Optimization

The simplest way to use AutoUX. Auto-detects framework, dev server, pages, and scope. Improves the entire frontend to Stripe/Linear/Vercel quality with zero configuration.

Load: `references/auto-workflow.md` for full protocol.

**What it does:**

1. **Detect** — scan package.json for framework, find/start dev server, glob frontend files
2. **Discover** — crawl running app via Playwright to find all pages
3. **Baseline** — quick-judge every page, rank from worst to best
4. **Confirm** — show one-screen summary, single yes/no confirmation
5. **Optimize** — run the standard autoux loop, starting with the lowest-scoring page
6. **Progress** — move to next page when current reaches 8.0+ or stalls (5 consecutive discards)
7. **Report** — multi-page summary with before/after scores

**Usage:**
```
# Just run it — that's the whole point
/autoux:auto

# Optimize a specific page only
/autoux:auto --page http://localhost:3000/pricing

# Skip confirmation prompt
/autoux:auto --skip-confirm

# Set a total iteration budget
/autoux:auto
Iterations: 50

# Set a higher quality threshold per page
/autoux:auto --threshold 9.0
```

**Key behavior:**
- Elevates the EXISTING design — doesn't replace it with something generic
- Scans for existing CSS tokens / Tailwind theme and works within them
- If shadcn/ui detected: avoids the generic purple look, customizes toward project identity
- Progresses through pages worst-first for maximum impact

### /autoux:review — One-Shot Design Review

Runs a comprehensive design evaluation without iterating. Captures screenshots at all viewports, runs the full judge panel, and outputs a structured report.

Load: `references/review-workflow.md` for full protocol.

**What it does:**

1. **Navigate** — open the target page via Playwright MCP
2. **Capture** — screenshot at desktop (1440px), tablet (768px), mobile (375px)
3. **Analyze** — DOM snapshot + console messages for hard gate checks
4. **Judge** — run all 4 judge personas (Accessibility, UX Friction, Visual Polish, Brand Alignment)
5. **Report** — structured findings with scores, critiques, and prioritized suggestions

**Usage:**
```
/autoux:review
Page: http://localhost:3000/checkout

/autoux:review Page: http://localhost:3000 Viewports: desktop,mobile
```

### /autoux:compare — A/B Design Comparison

Compare two design states using the full judge panel. Supports branch or commit comparison.

Load: `references/compare-workflow.md` for full protocol.

**What it does:**

1. **Capture A** — checkout state A, render and screenshot
2. **Capture B** — checkout state B, render and screenshot
3. **Judge Both** — run judge panel on each state
4. **Compare** — side-by-side report with score deltas per dimension
5. **Recommend** — identify which state is better and why

**Usage:**
```
/autoux:compare
Page: http://localhost:3000
Branch-A: main
Branch-B: feature/new-checkout

/autoux:compare Page: http://localhost:3000 Commit-A: abc1234 Commit-B: def5678
```

### /autoux:plan — Goal → Configuration Wizard

Converts a plain-language design goal into a validated, ready-to-execute autoux configuration.

Load: `references/plan-workflow.md` for full protocol.

**Quick summary:**

1. **Capture Goal** — ask what the user wants to improve visually
2. **Analyze Context** — scan project for frameworks, components, style files
3. **Define Scope** — suggest file globs for CSS/component files
4. **Define Page** — identify target URL, verify dev server is running
5. **Configure Viewports** — select viewport sizes to test
6. **Configure Rubric** — adjust judge weights and gate thresholds
7. **Baseline Capture** — take initial screenshots, run initial judgment, show starting scores
8. **Confirm & Launch** — present complete config, offer to launch immediately

**Usage:**
```
/autoux:plan
Goal: Make the checkout flow feel more premium

/autoux:plan Improve mobile responsiveness of the dashboard
```

## When to Activate

- User invokes `/autoux` → run the optimization loop
- User invokes `/autoux:auto` → run zero-config auto mode
- User invokes `/autoux:plan` → run the planning wizard
- User invokes `/autoux:review` → run one-shot design review
- User invokes `/autoux:svg` → run SVG generation
- User invokes `/autoux:compare` → run A/B comparison
- User says "improve the design", "make this look better", "optimize the UI" → run the loop
- User says "make a logo", "generate an icon", "create an SVG", "draw a" → run SVG generation
- User says "just make it look good", "make this professional", "enterprise grade" → run auto mode
- User says "review the design", "how does this look", "design feedback" → run one-shot review
- User says "compare designs", "which looks better", "A/B test" → run comparison
- User says "plan UI improvements", "help me set up autoux" → run planning wizard

## Bounded Iterations

By default, autoux loops **forever** until manually interrupted. To run exactly N iterations, add `Iterations: N` to your inline config.

**Unlimited (default):**
```
/autoux
Goal: Improve the hero section visual polish
```

**Bounded (N iterations):**
```
/autoux
Goal: Improve the hero section visual polish
Iterations: 10
```

After N iterations, print a final summary with baseline → current best scores, keeps/discards, and the top suggestion for further improvement.

## Setup Phase (Do Once)

**If the user provides Goal, Scope, and Page inline** → extract them and proceed to step 5.

**CRITICAL: If ANY critical field is missing (Goal, Scope, or Page), you MUST use `AskUserQuestion` to collect them interactively. DO NOT proceed to The Loop or any execution phase without completing this setup. This is a BLOCKING prerequisite.**

### Interactive Setup (when invoked without full config)

Scan the project first for smart defaults (look for CSS files, component directories, package.json for framework detection, running dev servers), then ask ALL questions in batched `AskUserQuestion` calls.

**Batch 1 — Core config (4 questions in one call):**

| # | Header | Question | Options (smart defaults from project scan) |
|---|--------|----------|----------------------------------------------|
| 1 | `Goal` | "What do you want to improve visually?" | "Overall visual polish", "Mobile responsiveness", "Accessibility compliance", "Brand consistency", Custom |
| 2 | `Scope` | "Which files can AutoUX modify?" | Suggested globs from project (e.g. `src/components/**/*.tsx`, `src/styles/**/*.css`) |
| 3 | `Page` | "What URL should I render and screenshot?" | Detected dev server URL (e.g. `http://localhost:3000`) |
| 4 | `Viewports` | "Which viewport sizes should I test?" | "All three (desktop + tablet + mobile)", "Desktop only", "Mobile only", Custom |

**Batch 2 — Rubric + Refs + Launch (3 questions in one call):**

| # | Header | Question | Options |
|---|--------|----------|---------|
| 5 | `Design Refs` | "Do you have design principles or style guide files?" | Detected paths, "No — use defaults", Custom path |
| 6 | `Rubric Weights` | "Any custom rubric weight adjustments?" | "Default (UX 0.4, Polish 0.35, Brand 0.25)", "Prioritize accessibility", "Prioritize visual polish", Custom |
| 7 | `Launch` | "Ready to go?" | "Launch (unlimited)", "Launch with iteration limit", "Edit config", "Cancel" |

### Setup Steps (after config is complete)

1. **Read all in-scope files** for full context before any modification
2. **Read design reference files** — `context/design-principles.md` and `context/style-guide.md` if they exist
3. **Verify Playwright MCP** — test navigate to Page URL, confirm non-error response
4. **Create output directory** — `autoux/{YYMMDD}-{HHMM}-{slug}/` for screenshots and judgments
5. **Establish baseline** — Render screenshots at all viewports, run full judge panel, record as iteration #0
6. **Create results log** — Initialize `autoux-results.tsv` with baseline entry
7. **Show baseline scores** — Display starting scores to user, confirm and BEGIN THE LOOP

## The Loop

Read `references/autonomous-loop-protocol.md` for full protocol details.

```
LOOP (FOREVER or N times):
  1. Review: Read current state + git history + results log + previous judgment critiques
  2. Ideate: Pick next visual change guided by judge critiques ("gradient")
  3. Modify: Make ONE focused visual change to in-scope files
  4. Commit: Git commit the change (before rendering)
  5. Render: Navigate to page via Playwright, capture screenshots at all viewports
  6. Judge: Run LLM-as-Judge panel — 4 specialized personas evaluate screenshots
  7. Decide:
     - ALL hard gates pass AND composite improved → Keep commit, update baseline
     - ANY hard gate fails → Discard (veto — no override)
     - Composite unchanged or worse → Discard
     - Pareto improvement (no dimension worse, at least one better) → Keep
  8. Log: Record all scores + verdict + critique summary to results TSV + judgment JSON
  9. Repeat: Go to step 1.
     - If unbounded: NEVER STOP. NEVER ASK "should I continue?"
     - If bounded (N): Stop after N iterations, print final summary
```

## Critical Rules

1. **Loop until done** — Unbounded: loop until interrupted. Bounded: loop N times then summarize.
2. **Read before write** — Always understand full context before modifying
3. **One change per iteration** — Atomic visual changes. If it breaks, you know exactly why
4. **LLM Judge evaluation only** — Every judgment must produce structured JSON with scores, gates, and critique. No unstructured "looks good"
5. **Automatic rollback** — Failed changes revert instantly via `git revert`. No debates
6. **Simplicity wins** — Equal scores + less CSS/code = KEEP. Tiny improvement + ugly complexity = DISCARD
7. **Git is memory** — Every experiment committed with `experiment(ui):` prefix. Use `git revert` (not `git reset --hard`) for rollbacks so failed experiments remain visible in history. Agent MUST read `git log` and previous judgment critiques before each iteration
8. **Critique is gradient** — The `next_suggestion` from each judge persona guides the next iteration. Always read the previous judgment's critiques before ideating. This replaces mechanical metric deltas as the learning signal

## Principles Reference

See `references/core-principles.md` for the 7 adapted principles for visual optimization.

## Judge System Reference

See `references/judge-system.md` for the multi-persona judge panel protocol, evaluation rubric, and decision logic.

## Adapting to Different UI Contexts

| Context | Scope | Page | Viewports | Rubric Focus |
|---------|-------|------|-----------|--------------|
| Landing page | `src/components/landing/**` | `/` | All three | Visual Polish high |
| Dashboard | `src/components/dashboard/**` | `/dashboard` | Desktop + tablet | UX Friction high |
| Mobile app | `src/components/**` | `/` | Mobile only | Brand Alignment high |
| E-commerce | `src/components/checkout/**` | `/checkout` | All three | UX Friction high |
| Design system | `src/styles/**` | `/storybook` | All three | Brand Alignment high |

Adapt the loop to your UI context. The PRINCIPLES are universal; the RUBRIC WEIGHTS are context-specific.
