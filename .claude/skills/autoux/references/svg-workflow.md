# SVG Workflow — Autonomous SVG Generation & Refinement

Generate and iteratively refine SVG images (logos, icons, plots, illustrations, diagrams) from a one-line text description. Uses the same ratchet loop but with SVG-specific rendering and judge personas.

## Overview

```
User: "minimalist mountain logo, earth tones"
  → Agent generates SVG code
    → Playwright renders SVG in browser, screenshots it
      → SVG judge panel evaluates the image
        → Keep if improved, discard if not
          → Repeat with critique guidance
```

## Interactive Setup

### Required Context

| Field | Required? | Default |
|-------|-----------|---------|
| Describe | YES | None — the text description of what to generate |
| Output | No | `output.svg` |
| Size | No | `400x400` |
| Background | No | `white` |
| Iterations | No | Unlimited |

### If Describe is missing

Use `AskUserQuestion`:

| # | Header | Question | Options |
|---|--------|----------|---------|
| 1 | `Describe` | "What SVG do you want to generate? (one line)" | "Logo", "Icon", "Plot/Chart", "Illustration", Custom |
| 2 | `Output` | "Output filename?" | "logo.svg", "icon.svg", "output.svg", Custom |

## Execution Protocol

### Step 1: Initialize

```
1. Parse description from $ARGUMENTS
2. Create output SVG file (or read existing one if file already exists)
3. Create rendering HTML wrapper:

   autoux-svg-preview.html (temporary, gitignored):
   <!DOCTYPE html>
   <html>
   <head><style>
     body { margin: 0; display: flex; align-items: center; justify-content: center;
            width: 100vw; height: 100vh; background: {background}; }
     img { max-width: 90vw; max-height: 90vh; }
   </style></head>
   <body>
     <img src="{output_file}" />
   </body>
   </html>

4. Open the HTML file via Playwright (file:// protocol)
5. Create output directory: autoux/{YYMMDD}-{HHMM}-svg-{slug}/
```

### Step 2: Initial Generation (Iteration 0)

```
1. Read the description
2. Read style-guide.md if it exists (for color/style guidance)
3. Generate initial SVG code based on the description
4. Write to output file
5. Render via Playwright:
   a. Navigate to autoux-svg-preview.html
   b. Wait for SVG to load
   c. Screenshot at configured size
6. Run SVG judge panel (baseline)
7. Log as iteration 0
```

### Step 3: Optimization Loop

Same 8-phase loop as the main autoux protocol, with these adaptations:

**Phase 1: Review**
- Read current SVG file
- Read previous judgment critiques (the "gradient")
- Read git log for what SVG changes worked/failed
- Re-read the original description (never drift from user intent)

**Phase 2: Ideate**
Priority order:
1. Address judge critiques from previous iteration
2. Fix hard gate failures (unreadable, broken paths)
3. Improve lowest-scoring dimension
4. Refine details (path precision, symmetry, alignment)
5. Try style variations (different shapes, proportions, colors)
6. Simplify (fewer paths while maintaining quality)
7. Radical redesign (completely different approach to the concept)

**Phase 3: Modify**
- ONE focused SVG change per iteration
- Types: path adjustments, color changes, element add/remove, proportions, viewBox, gradients, transforms
- One-sentence test applies: "refine the mountain peak shape" is one change; "change colors AND add text" is two

**Phase 4: Commit**
- `git commit -m "experiment(svg): <description>"`

**Phase 5: Render**
```
1. Navigate to autoux-svg-preview.html (file:// or local server)
2. Wait for SVG image to load
3. Screenshot at multiple sizes:
   a. Full size (configured, default 400x400)
   b. Small size (64x64) — for readability/icon check
   c. Large size (800x800) — for detail check
4. All three screenshots available for judge evaluation
```

**Phase 5.5: Judge**
- Run SVG-specific judge panel (see below)
- Compare against baseline (last kept state)
- Produce structured JSON verdict

**Phase 6-8: Decide, Log, Repeat**
- Same as main autoux protocol

## SVG Judge Panel

Four specialized personas adapted for SVG evaluation.

### 1. Clarity Judge (Hard Gate)

**Persona prompt:**
> You are evaluating an SVG image for visual clarity and readability. Check if the image is recognizable at small sizes (64x64), has no broken/overlapping paths, and clearly communicates its intended subject. You are strict — if the image is unrecognizable or broken, it fails.

**Evaluates:**
- Is the image recognizable at 64x64? (check small-size screenshot)
- Are paths clean with no unintended overlaps or gaps?
- Does it clearly represent the described subject?
- No clipping, overflow, or rendering artifacts?

**Output:** Hard gate — `pass` or `fail`

```json
{
  "persona": "clarity",
  "gate": "pass",
  "critique": "Image is clearly recognizable as a mountain at all sizes.",
  "evidence": "Verified at 64x64, 400x400, and 800x800"
}
```

### 2. Craft Judge (Soft Score, Weight: 0.35)

**Persona prompt:**
> You are a vector graphics expert evaluating SVG craft quality. You assess path precision, geometric consistency, symmetry, visual balance, and efficient use of SVG features. Your benchmark is professional icon sets like Lucide, Heroicons, and SF Symbols.

**Evaluates:**
- Path precision and smoothness (no jagged curves)
- Geometric consistency (parallel lines stay parallel, circles are circular)
- Symmetry where appropriate
- Visual balance and weight distribution
- Efficient SVG structure (not overly complex paths)
- Proper use of viewBox and proportions
- Clean strokes and fills (no artifacts)

**Score anchors:**
| Score | Description |
|-------|-------------|
| 1-3 | Crude shapes, jagged paths, broken geometry |
| 4-6 | Recognizable but rough, inconsistent line weights, poor balance |
| 7-8 | Professional quality, clean paths, good symmetry and balance |
| 9-10 | Pixel-perfect craft, Lucide/Heroicons quality, elegant geometry |

### 3. Style Judge (Soft Score, Weight: 0.35)

**Persona prompt:**
> You are a graphic designer evaluating the aesthetic quality of an SVG image. You assess color harmony, visual appeal, modern design sensibility, and overall polish. If a style guide exists, evaluate against it. Otherwise, judge standalone aesthetic merit.

**Evaluates:**
- Color harmony and palette cohesion
- Visual appeal and modern feel
- Appropriate use of gradients, shadows, or flat design
- Whitespace and negative space usage
- Overall "would you put this on a website?" test
- Style consistency (all elements feel like they belong together)

**Score anchors:**
| Score | Description |
|-------|-------------|
| 1-3 | Clashing colors, dated appearance, visually unappealing |
| 4-6 | Acceptable but generic, could be improved with better colors/proportions |
| 7-8 | Attractive, modern feel, cohesive color palette |
| 9-10 | Beautiful, distinctive, Dribbble-worthy quality |

### 4. Intent Judge (Soft Score, Weight: 0.30)

**Persona prompt:**
> You are evaluating whether an SVG image matches a text description. The description is the user's intent — does the image faithfully represent what they asked for? Score based on how well the visual matches the words. Be literal: if they said "mountain" there should be a mountain, not a triangle.

**Evaluates against the original `Describe` text:**
- Does it depict the right subject? (mountain = mountain shape, not abstract triangle)
- Does it match the requested style? ("minimalist" = simple, "detailed" = complex)
- Does it use the right colors? ("earth tones" = browns/greens, "blue" = blue)
- Does it match the requested use case? ("logo" = clean/iconic, "illustration" = detailed)
- Would someone looking at this image guess the description?

**Score anchors:**
| Score | Description |
|-------|-------------|
| 1-3 | Doesn't match description at all, wrong subject or completely wrong style |
| 4-6 | Partially matches — right subject but wrong style, or right style but wrong subject |
| 7-8 | Good match — clearly depicts the described subject in the requested style |
| 9-10 | Perfect match — someone could guess the exact description from the image |

## Decision Logic

```
IF clarity gate == "fail":
    verdict = "discard"      # Can't see what it is → useless

ELIF all soft_score deltas >= 0 AND at least one > 0:
    verdict = "keep"         # Pareto improvement

ELIF composite_delta > +0.8 AND no soft_score delta < -2:
    verdict = "keep"         # Net improvement large enough

ELIF composite_delta <= 0:
    verdict = "discard"      # No improvement

ELSE:
    verdict = "discard"      # Mixed/unclear
```

**Composite:** `0.35 * craft + 0.35 * style + 0.30 * intent`

## SVG Generation Guidelines

When generating or modifying SVG code, the agent should:

1. **Use a clean viewBox** — typically `0 0 400 400` or `0 0 100 100`
2. **Prefer simple geometry** — `<circle>`, `<rect>`, `<polygon>`, `<path>` with clean curves
3. **Use named colors or hex** — not `rgb()` for readability
4. **Keep it minimal** — fewer paths = better (simpler SVGs look more professional)
5. **Center the design** — use viewBox and transforms to center the image
6. **Consider scalability** — SVG should look good from 16x16 to 800x800
7. **No embedded raster** — pure vector only, no `<image>` tags with base64
8. **No external dependencies** — no linked fonts or external stylesheets

## Render Sizes

| Size | Purpose | Used By |
|------|---------|---------|
| 64x64 | Readability check (favicon/icon size) | Clarity Judge |
| 400x400 | Primary evaluation (default) | All judges |
| 800x800 | Detail check (large format) | Craft Judge |

## Results Logging

Same TSV format as main autoux, adapted columns:

```tsv
iteration	commit	clarity_gate	craft	style	intent	composite	verdict	critique_summary
0	a1b2c3d	pass	4	5	6	4.95	baseline	initial generation — basic mountain shape
1	b2c3d4e	pass	5	6	7	5.95	keep	refined peak shape, added earth tone palette
2	-	fail	-	-	-	-	discard	clarity gate: unrecognizable at 64x64 after adding too much detail
3	c3d4e5f	pass	6	7	7	6.65	keep	simplified while maintaining color improvements
```

## Cleanup

After the loop completes:
- The output SVG file is the final result
- `autoux-svg-preview.html` can be deleted (temporary rendering wrapper)
- Screenshots archived in `autoux/{run}/screenshots/`
- Add `autoux-svg-preview.html` to .gitignore
