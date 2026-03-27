# Default AutoUX Evaluation Rubric

This rubric defines the evaluation criteria used by the LLM-as-Judge panel. It contains **hard gates** (binary pass/fail) and **soft scoring dimensions** (1-10 scale with anchors).

## Hard Gates (Binary Pass/Fail)

Hard gates are non-negotiable. If ANY gate fails, the entire iteration is **discarded** regardless of soft scores. This is the "veto" mechanism.

### Accessibility Gate

| Check | Criterion | How to Verify |
|-------|-----------|---------------|
| Color contrast | >= 4.5:1 for normal text, >= 3:1 for large text (18px+ or 14px+ bold) | Visual inspection of screenshot + DOM snapshot |
| Text size | No text smaller than 12px | DOM snapshot analysis |
| Touch targets | Interactive elements >= 44x44px on mobile viewport | Screenshot measurement at 375px |
| Element visibility | All interactive elements visible, not obscured | Screenshot analysis |
| Semantic structure | Proper heading hierarchy, ARIA landmarks present | DOM snapshot analysis |

**Gate result:** `pass` if ALL checks pass. `fail` if ANY check fails.

### Layout Integrity Gate

| Check | Criterion | How to Verify |
|-------|-----------|---------------|
| Horizontal scroll | No horizontal scrollbar at any viewport | Screenshot width matches viewport |
| Content overflow | No text or elements clipped or cut off | Visual inspection of screenshot edges |
| Element overlap | No unintended overlapping of text or interactive elements | Screenshot analysis |
| Content visibility | All primary content visible without scrolling beyond reasonable page length | Screenshot analysis |

**Gate result:** `pass` if ALL checks pass. `fail` if ANY check fails.

### Console Errors Gate

| Check | Criterion | How to Verify |
|-------|-----------|---------------|
| JavaScript errors | Zero JS errors in browser console | `browser_console_messages` output |
| Resource failures | No failed resource loads (images, fonts, scripts) that affect layout | Console + visual inspection |

**Gate result:** `pass` if zero errors. `fail` if any error present. Warnings are noted but do not trigger failure.

## Soft Scoring Dimensions (1-10 Scale)

Each dimension is scored by a specialized judge persona. Scores use anchored descriptions to ensure consistency across iterations.

### UX Friction (Weight: 0.40)

Evaluates cognitive load, information hierarchy, and task flow clarity.

| Score | Anchor Description |
|-------|--------------------|
| 1-2 | **Unusable** — User cannot identify primary action. Layout is confusing, navigation unclear. Multiple competing visual focal points. |
| 3-4 | **Frustrating** — Primary action exists but requires searching. Hierarchy is flat. Too many elements competing for attention. |
| 5-6 | **Functional** — Primary action is findable but not immediately obvious. Some cognitive load from unclear grouping or ordering. |
| 7-8 | **Clear** — Primary action is prominent. Visual hierarchy guides the eye naturally. Minimal cognitive load. Grouping and spacing support scanning. |
| 9-10 | **Effortless** — User intent is immediately clear. Zero ambiguity about what to do next. Information architecture is intuitive. Stripe/Linear level clarity. |

**Evaluate:** Information hierarchy, CTA prominence and visibility, visual flow (F-pattern or Z-pattern), cognitive load (number of decisions), grouping and proximity, whitespace usage for separation, feedback visibility (hover states, active states).

### Visual Polish (Weight: 0.35)

Evaluates spacing consistency, typography hierarchy, alignment, color harmony, and overall craft.

| Score | Anchor Description |
|-------|--------------------|
| 1-2 | **Amateur** — Inconsistent spacing, misaligned elements, clashing colors. Looks like a first draft. |
| 3-4 | **Rough** — Some consistency but notable spacing/alignment issues. Typography lacks hierarchy. Colors feel arbitrary. |
| 5-6 | **Acceptable** — Generally consistent but unrefined. Minor spacing inconsistencies. Typography is functional but not elegant. |
| 7-8 | **Professional** — Consistent spacing (grid-based), clear typography hierarchy, harmonious colors. Feels intentional and well-crafted. |
| 9-10 | **World-class** — Every pixel is intentional. Stripe/Linear/Airbnb level polish. Perfect spacing rhythm, elegant typography, sophisticated color palette. Micro-details like shadows, borders, and radius are perfectly calibrated. |

**Evaluate:** Spacing consistency (4px/8px grid adherence), element alignment (left/center/right consistency), typography scale (clear size hierarchy: heading > subheading > body > caption), color harmony (complementary palette, consistent usage), whitespace rhythm (consistent breathing room), border/shadow/radius consistency, image quality and sizing.

### Brand Alignment (Weight: 0.25)

Evaluates adherence to the project's design principles and style guide.

| Score | Anchor Description |
|-------|--------------------|
| 1-2 | **Off-brand** — Wrong colors, wrong fonts, wrong tone. Looks like a different product entirely. |
| 3-4 | **Partially aligned** — Some brand elements present but notable deviations. Mixed font families or inconsistent color usage. |
| 5-6 | **Recognizable** — Brand is identifiable but with clear deviations from the style guide. Close but not precise. |
| 7-8 | **On-brand** — Clearly follows the design system. Colors, fonts, and component styles match the guide with minor deviations. |
| 9-10 | **Perfect embodiment** — Indistinguishable from a design team's handcrafted output. Every element precisely matches the style guide. The "vibe" is exactly right. |

**Evaluate against:** `context/design-principles.md` and `context/style-guide.md` specifically. Color palette adherence, typography choices (font family, weight, size), component style consistency, iconography style, overall tone/mood match, spacing system adherence.

**Note:** If no design reference files exist, this dimension evaluates internal consistency — does the design feel cohesive and intentional within itself?

## Composite Score Calculation

```
composite = (0.40 * ux_friction + 0.35 * visual_polish + 0.25 * brand_alignment)
```

The composite is used for keep/discard decisions when individual dimensions give mixed signals. See `references/judge-system.md` for the full decision logic.

## Customizing the Rubric

Users can override weights via `/autoux:plan` or inline config:

```
/autoux
Goal: Improve mobile accessibility
Rubric-Weights: ux_friction=0.5, visual_polish=0.2, brand_alignment=0.3
```

Or add custom gate checks:

```
/autoux
Goal: Optimize for performance
Custom-Gate: Lighthouse performance score > 90
```

## Viewport-Specific Scoring

Each viewport is scored independently. The **worst score across viewports** is used for each dimension. This ensures mobile-responsive issues are never masked by good desktop scores.

```
ux_friction_final = min(ux_friction_desktop, ux_friction_tablet, ux_friction_mobile)
visual_polish_final = min(visual_polish_desktop, visual_polish_tablet, visual_polish_mobile)
brand_alignment_final = min(brand_alignment_desktop, brand_alignment_tablet, brand_alignment_mobile)
```
