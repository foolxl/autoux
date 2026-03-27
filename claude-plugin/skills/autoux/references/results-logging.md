# Results Logging — Multi-Dimensional Score Tracking

AutoUX tracks every iteration in a TSV log file (`autoux-results.tsv`) and archives full judgment details in JSON files.

## TSV Log Format

**File:** `autoux-results.tsv` (project root, gitignored)

### Columns

```tsv
iteration	commit	a11y_gate	layout_gate	console_gate	ux_friction	visual_polish	brand_align	composite	verdict	critique_summary
```

| Column | Type | Description |
|--------|------|-------------|
| `iteration` | int | Iteration number (0 = baseline) |
| `commit` | string | Git commit hash (short), or `-` if discarded before commit |
| `a11y_gate` | pass/fail | Accessibility hard gate result |
| `layout_gate` | pass/fail | Layout integrity hard gate result |
| `console_gate` | pass/fail | Console errors hard gate result |
| `ux_friction` | int (1-10) | UX Friction soft score (worst across viewports) |
| `visual_polish` | int (1-10) | Visual Polish soft score (worst across viewports) |
| `brand_align` | int (1-10) | Brand Alignment soft score (worst across viewports) |
| `composite` | float | Weighted composite score, or `-` if gates failed |
| `verdict` | string | Decision: `baseline`, `keep`, `discard`, `crash`, `no-op` |
| `critique_summary` | string | One-line summary of WHY (the critique, not the change) |

### Example Log

```tsv
iteration	commit	a11y_gate	layout_gate	console_gate	ux_friction	visual_polish	brand_align	composite	verdict	critique_summary
0	a1b2c3d	pass	pass	pass	5	4	6	4.90	baseline	initial state — hero section lacks visual hierarchy
1	b2c3d4e	pass	pass	pass	6	6	6	6.00	keep	improved spacing consistency and CTA prominence
2	-	fail	pass	pass	-	-	-	-	discard	a11y gate: CTA contrast ratio 3.2:1 (requires 4.5:1)
3	c3d4e5f	pass	pass	pass	7	7	7	7.00	keep	fixed contrast, maintained spacing improvements
4	-	pass	pass	pass	7	6	7	6.65	discard	visual polish regressed: inconsistent card border-radius
5	d4e5f6g	pass	pass	pass	7	8	7	7.35	keep	unified border-radius to 8px across all cards
6	-	pass	fail	pass	-	-	-	-	discard	layout gate: horizontal scroll on mobile at 375px
7	e5f6g7h	pass	pass	pass	8	8	7	7.75	keep	fixed mobile overflow, improved mobile CTA sizing
```

### Key Differences from Autoresearch's results.tsv

| Autoresearch | AutoUX | Why |
|-------------|--------|-----|
| 1 metric column | 3 soft score + 3 gate columns | Multi-dimensional evaluation |
| 1 guard column | 3 separate gate columns | Different gate types have different veto semantics |
| Single `delta` | Computed from composite | Delta is implicit (compare to previous baseline) |
| `description` | `critique_summary` | Captures WHY (judge feedback), not just WHAT (code change) |

## Judgment JSON Archives

**Directory:** `autoux/{YYMMDD}-{HHMM}-{slug}/judgments/`

Each iteration produces a full judgment JSON file: `iter-{N}-judgment.json`

This contains the complete evaluation from all judge personas, including:
- Per-viewport scores for each dimension
- Full critique text and suggestions
- Confidence scores
- Hard gate details
- Conflict flags
- Meta-judge synthesis and `next_suggestion`

See `references/judge-system.md` for the full JSON schema.

### Why Both TSV and JSON?

- **TSV** is for quick scanning and pattern recognition — the agent reads it every iteration to see the trend
- **JSON** is for detailed feedback — the agent reads the last JSON to get the critique "gradient" for the next iteration
- **TSV** is human-readable in any text editor or spreadsheet
- **JSON** preserves the full structured judgment for potential downstream analysis

## Screenshot Archives

**Directory:** `autoux/{YYMMDD}-{HHMM}-{slug}/screenshots/`

Naming convention: `iter-{N}-{viewport}.png`

Examples:
```
iter-0-desktop.png     # baseline desktop
iter-0-tablet.png      # baseline tablet
iter-0-mobile.png      # baseline mobile
iter-1-desktop.png     # iteration 1 desktop
iter-1-tablet.png      # iteration 1 tablet
iter-1-mobile.png      # iteration 1 mobile
```

Screenshots are kept for ALL iterations (both kept and discarded) to enable human review of the design evolution.

## Reading the Log (Agent Protocol)

At the start of every iteration (Phase 1: Review), the agent MUST:

1. **Read the last 10-20 TSV entries** — scan for patterns:
   - Which dimensions are trending up?
   - Which gates keep failing?
   - How many consecutive discards? (>5 = try radical change)
   - What's the current composite vs baseline?

2. **Read the last judgment JSON** — get the detailed critique:
   - What did each judge persona suggest?
   - What was the `next_suggestion`?
   - Were there any conflicts between judges?

3. **Identify the weakest dimension** — the lowest soft score should be the focus of the next iteration (unless the previous critique suggests otherwise)

## Writing to the Log

After every iteration's decide phase:

```bash
# Append to TSV
echo -e "{iteration}\t{commit}\t{a11y}\t{layout}\t{console}\t{ux}\t{polish}\t{brand}\t{composite}\t{verdict}\t{critique}" >> autoux-results.tsv

# Save judgment JSON
# (written by the judge system, not manually)
```

### Status Values

| Status | Meaning | When Used |
|--------|---------|-----------|
| `baseline` | Initial state before any changes | Iteration 0 only |
| `keep` | Change improved design, commit stays | All gates pass + composite improved |
| `discard` | Change didn't improve or broke something | Gate failure, no improvement, or regression |
| `crash` | Code change broke the page entirely | Page won't render, JS fatal error |
| `no-op` | No actual code diff produced | Agent's modification produced identical code |

## Progress Summary

Every 5 iterations, print a brief progress summary:

```
=== AutoUX Progress (iteration 15) ===
Baseline: 4.90 → Current: 7.35 (+2.45)
UX Friction: 5→7 | Visual Polish: 4→8 | Brand Alignment: 6→7
Keeps: 6 | Discards: 8 | Crashes: 1
Last critique: "Mobile padding inconsistency between sections 2 and 3"
```

## Final Summary (Bounded Mode)

When bounded iterations complete:

```
=== AutoUX Complete (10/10 iterations) ===
Baseline: 4.90 → Final: 7.75 (+2.85)

Dimension Breakdown:
  UX Friction:     5 → 8  (+3)
  Visual Polish:   4 → 8  (+4)
  Brand Alignment: 6 → 7  (+1)

Results: 6 keeps | 3 discards | 1 crash
Best iteration: #7 — fixed mobile overflow, improved CTA sizing (composite: 7.75)
Top suggestion for further improvement: "Replace custom shadows with design system elevation tokens"

Screenshots archived: autoux/260327-1430-hero-polish/screenshots/
Judgments archived: autoux/260327-1430-hero-polish/judgments/
```

## Run Summary File

At the end of a run (or when interrupted), generate `autoux/{run}/summary.md`:

```markdown
# AutoUX Run Summary

**Goal:** Improve hero section visual polish
**Scope:** src/components/hero/**/*.tsx, src/styles/hero.css
**Page:** http://localhost:3000
**Viewports:** desktop (1440), tablet (768), mobile (375)
**Duration:** 10 iterations
**Date:** 2026-03-27

## Score Progression

| Iteration | Composite | UX | Polish | Brand | Verdict |
|-----------|-----------|----|----|-------|---------|
| 0 (baseline) | 4.90 | 5 | 4 | 6 | — |
| 1 | 6.00 | 6 | 6 | 6 | keep |
| 3 | 7.00 | 7 | 7 | 7 | keep |
| 5 | 7.35 | 7 | 8 | 7 | keep |
| 7 | 7.75 | 8 | 8 | 7 | keep |

## Key Improvements Made
1. Standardized section spacing to 64px rhythm
2. Unified card border-radius to 8px
3. Improved CTA contrast ratio to 5.2:1
4. Fixed mobile horizontal overflow
5. Enlarged mobile CTA touch target to 48x48px

## Remaining Suggestions
1. Replace custom shadows with design system elevation tokens
2. Consider reducing secondary navigation visual weight
3. Mobile section padding could better match desktop rhythm
```
