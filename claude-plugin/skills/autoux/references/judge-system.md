# LLM-as-Judge System — Multi-Persona Evaluation Panel

The judge system is the core innovation of AutoUX, replacing autoresearch's single numerical metric with a structured multi-dimensional evaluation using Claude's multimodal capabilities.

## Architecture

Instead of running a shell command and parsing a number, the agent **evaluates its own screenshots** by adopting specialized judge personas sequentially. Each persona focuses on a different aspect of design quality.

```
Agent modifies code
  → Playwright renders page + captures screenshots
    → Agent adopts Accessibility Judge persona → evaluates → JSON
    → Agent adopts UX Friction Judge persona → evaluates → JSON
    → Agent adopts Visual Polish Judge persona → evaluates → JSON
    → Agent adopts Brand Alignment Judge persona → evaluates → JSON
      → Meta-Judge synthesizes all judgments → final verdict
```

## Judge Personas

### 1. Accessibility Judge (Hard Gate)

**Persona prompt:**
> You are a WCAG 2.1 AA accessibility auditor. You evaluate screenshots and DOM snapshots for accessibility compliance. You are strict and binary — either the design passes or it fails. You do not care about aesthetics or brand.

**Evaluates:**
- Color contrast ratios (4.5:1 normal text, 3:1 large text)
- Text size minimums (12px)
- Touch target sizes (44x44px on mobile)
- Element visibility and distinguishability
- Semantic HTML structure (from DOM snapshot)
- Keyboard navigability indicators (focus states visible)

**Output type:** Hard gate — `pass` or `fail`

**Output format:**
```json
{
  "persona": "accessibility",
  "gate": "pass",
  "issues": [],
  "critique": "All contrast ratios meet WCAG AA. Touch targets are adequate on mobile.",
  "evidence": "Verified across desktop, tablet, and mobile viewports"
}
```

On failure:
```json
{
  "persona": "accessibility",
  "gate": "fail",
  "issues": [
    "CTA button text contrast ratio ~3.2:1 (requires 4.5:1)",
    "Footer link text at 11px (minimum 12px)"
  ],
  "critique": "Two critical accessibility failures: insufficient contrast on primary CTA and undersized footer text.",
  "suggestion": "Darken CTA background to #1a1a2e or lighten text to #ffffff. Increase footer font-size to 12px.",
  "evidence": "Desktop viewport, bottom section"
}
```

### 2. UX Friction Judge (Soft Score)

**Persona prompt:**
> You are a UX researcher specializing in cognitive load analysis and information architecture. You evaluate screenshots for how easily a user can accomplish their goal. You think in terms of eye-tracking patterns, decision complexity, and task flow clarity. Reference designs: Stripe's checkout, Linear's task management, Airbnb's search.

**Evaluates:**
- Information hierarchy (is the most important element most prominent?)
- CTA visibility and prominence
- Visual flow (F-pattern or Z-pattern adherence)
- Cognitive load (number of decisions, competing elements)
- Grouping and proximity (related items together)
- Whitespace usage for visual separation
- Navigation clarity
- Feedback visibility (states, indicators)

**Output format:**
```json
{
  "persona": "ux_friction",
  "score": 7,
  "confidence": 0.85,
  "critique": "Primary CTA is clearly visible. Information hierarchy is logical with good visual grouping. However, the secondary navigation competes with the main content for attention.",
  "suggestion": "Reduce secondary navigation visual weight — try smaller text or lower contrast to de-emphasize relative to main content.",
  "evidence": "Desktop viewport — secondary nav at same visual weight as primary content area"
}
```

### 3. Visual Polish Judge (Soft Score)

**Persona prompt:**
> You are a visual design critic with exacting standards for craft and polish. You evaluate screenshots for spacing consistency, typography hierarchy, alignment precision, color harmony, and overall visual rhythm. Your benchmark is world-class SaaS design: Stripe, Linear, Vercel, Notion. You notice the details that separate amateur from professional.

**Evaluates:**
- Spacing consistency (4px/8px grid adherence)
- Element alignment (consistent left/center/right alignment)
- Typography scale (clear heading > subheading > body > caption hierarchy)
- Color harmony (complementary palette, consistent application)
- Whitespace rhythm (consistent breathing room between sections)
- Border, shadow, and radius consistency
- Image quality and sizing
- Visual rhythm and repetition

**Output format:**
```json
{
  "persona": "visual_polish",
  "score": 6,
  "confidence": 0.80,
  "critique": "Typography hierarchy is clear but spacing between sections is inconsistent — hero section has 64px bottom margin while features section has 48px. Card border-radius varies between 8px and 12px.",
  "suggestion": "Standardize section spacing to 64px. Unify card border-radius to 8px (matching the smaller, more refined look).",
  "evidence": "Desktop viewport — visible spacing inconsistency between sections 2 and 3"
}
```

### 4. Brand Alignment Judge (Soft Score)

**Persona prompt:**
> You are a brand identity specialist. You evaluate screenshots against the project's design principles and style guide documents. You check for adherence to the defined color palette, typography choices, component styles, and overall brand "vibe." If no style guide exists, you evaluate internal consistency — does the design feel cohesive within itself?

**Evaluates (against `context/design-principles.md` and `context/style-guide.md`):**
- Color palette adherence
- Typography choices (font family, weight, size against spec)
- Component style consistency (buttons, cards, inputs match guide)
- Iconography style consistency
- Overall tone/mood match
- Spacing system adherence
- Voice and messaging tone (if applicable)

**Output format:**
```json
{
  "persona": "brand_alignment",
  "score": 8,
  "confidence": 0.90,
  "critique": "Color palette matches the style guide precisely. Typography uses the specified Inter font family. However, the hero section uses a shadow style not defined in the design system.",
  "suggestion": "Replace the hero drop-shadow with the 'elevation-2' shadow token from the style guide: 0 4px 6px -1px rgba(0,0,0,0.1).",
  "evidence": "Desktop viewport — hero section shadow differs from design system tokens"
}
```

## Evaluation Protocol

### Step-by-Step Execution

For each iteration, after Playwright captures screenshots:

```
1. HARD GATES (stop early if any fail)

   a. Console Gate
      - Read browser_console_messages output
      - Any JavaScript errors → gate = "fail", log issues
      - Only warnings → gate = "pass", note warnings

   b. Layout Gate
      - Examine each viewport screenshot for:
        - Horizontal scrollbar presence
        - Content overflow or clipping
        - Element overlap
      - Any issue → gate = "fail", log which viewport and what broke

   c. Accessibility Gate
      - Adopt Accessibility Judge persona
      - Analyze screenshots + DOM snapshot
      - Check contrast, text size, touch targets, semantic structure
      - Any WCAG AA violation → gate = "fail", log specific violations

   → If ANY gate fails: skip soft scoring, verdict = "discard", log gate failure

2. SOFT SCORING (only if all gates pass)

   FOR each viewport IN [desktop, tablet, mobile]:
     FOR each judge IN [ux_friction, visual_polish, brand_alignment]:
       a. Adopt judge persona (read persona prompt above)
       b. Compare: baseline screenshot vs current screenshot for this viewport
       c. Reference: design-principles.md, style-guide.md (if available)
       d. Produce: structured JSON with score, confidence, critique, suggestion

   e. Aggregate: worst score across viewports for each dimension
      ux_friction_final = min(ux_friction across viewports)
      visual_polish_final = min(visual_polish across viewports)
      brand_alignment_final = min(brand_alignment across viewports)

3. META-JUDGE SYNTHESIS

   a. Compute composite:
      composite = 0.40 * ux_friction_final + 0.35 * visual_polish_final + 0.25 * brand_alignment_final

   b. Compute deltas from baseline:
      composite_delta = composite - baseline_composite
      Per-dimension deltas computed similarly

   c. Apply decision logic (see below)

   d. Generate next_suggestion:
      - If verdict = "keep": suggest improving the lowest-scoring dimension
      - If verdict = "discard": explain what went wrong and suggest alternative approach

   e. Save full judgment JSON to autoux/{run}/judgments/iter-{N}-judgment.json
```

### Baseline Management

- **Baseline screenshots** are captured at iteration 0 (setup phase)
- Baseline is **updated** every time a change is "kept"
- The judge always compares **current vs baseline** (last kept state)
- NOT current vs previous attempt (which may have been discarded)
- Baseline scores are stored in the results TSV as iteration 0

## Decision Logic

```
IF any hard_gate == "fail":
    verdict = "discard"
    reason = "Hard gate failure: {gate_name} — {critique}"
    # VETO — no override regardless of soft scores

ELIF all soft_score deltas >= 0 AND at least one delta > 0:
    verdict = "keep"
    reason = "Pareto improvement — no dimension worse, {improved_dims} improved"
    # Best case: everything got better or stayed the same

ELIF composite_delta > +1.0 AND no individual soft_score delta < -2:
    verdict = "keep"
    reason = "Net improvement (+{composite_delta}) outweighs minor regressions"
    # Allow minor tradeoffs if the overall improvement is substantial

ELIF composite_delta <= 0:
    verdict = "discard"
    reason = "No net improvement (delta: {composite_delta})"
    # Not worth keeping — didn't improve overall

ELIF any soft_score < 4 AND that score got worse:
    verdict = "discard"
    reason = "Critical dimension {dim} dropped below 4 ({score})"
    # A dimension that's already weak got weaker — don't allow this

ELSE:
    verdict = "discard"
    reason = "Mixed results with insufficient net improvement"
    # Conservative default — unclear improvement is not improvement
```

### Simplicity Override

If composite barely improved (+<0.5) but the code change adds significant complexity (>20 new CSS rules, new dependencies, deeply nested selectors):
- Override verdict to "discard"
- Reason: "Marginal improvement does not justify added complexity"

If composite unchanged but the code is simpler (fewer CSS rules, cleaner selectors):
- Override verdict to "keep"
- Reason: "Equal quality with simpler implementation"

## Conflict Resolution

When judges disagree strongly (score spread > 4 points between dimensions):

1. **Flag the conflict** in the judgment JSON:
   ```json
   "conflict": {
     "high": {"persona": "visual_polish", "score": 9},
     "low": {"persona": "ux_friction", "score": 4},
     "spread": 5
   }
   ```

2. **Log the conflict** with both critiques for future reference

3. **Next iteration MUST address the lower score's critique** — the conflict creates a directed "gradient" toward the weaker dimension

4. **Strong Pareto violation rule:** If any dimension scores 9+ but another is below 4, always discard — beautiful but unusable is not acceptable

## Full Judgment JSON Schema

```json
{
  "iteration": 7,
  "timestamp": "2026-03-27T14:30:00Z",
  "hard_gates": {
    "accessibility": {"gate": "pass", "issues": []},
    "layout_integrity": {"gate": "pass", "issues": []},
    "console_errors": {"gate": "pass", "issues": [], "warnings": ["Deprecation warning: ..."]  }
  },
  "soft_scores": {
    "ux_friction": {
      "scores_by_viewport": {"desktop": 7, "tablet": 7, "mobile": 6},
      "score": 6,
      "delta": 1,
      "confidence": 0.85,
      "critique": "Mobile CTA is less prominent due to stacking order.",
      "suggestion": "Move CTA above the fold on mobile viewport."
    },
    "visual_polish": {
      "scores_by_viewport": {"desktop": 8, "tablet": 8, "mobile": 7},
      "score": 7,
      "delta": 2,
      "confidence": 0.80,
      "critique": "Spacing consistency improved significantly. Minor mobile padding issue.",
      "suggestion": "Adjust mobile section padding to match desktop rhythm."
    },
    "brand_alignment": {
      "scores_by_viewport": {"desktop": 6, "tablet": 6, "mobile": 6},
      "score": 6,
      "delta": 0,
      "confidence": 0.90,
      "critique": "Brand colors correct but shadow tokens still custom.",
      "suggestion": "Replace custom shadows with design system elevation tokens."
    }
  },
  "composite_score": 6.35,
  "composite_delta": 1.0,
  "verdict": "keep",
  "reason": "Visual polish significantly improved (+2), UX friction improved (+1), brand alignment held steady. No gate failures.",
  "next_suggestion": "Focus on brand alignment — replace custom shadow values with design system tokens.",
  "conflict": null
}
```

## Performance Considerations

### Context Window Management

Evaluating screenshots uses multimodal tokens. To manage context:

1. **Evaluate one viewport at a time** — don't hold all 3 viewport screenshots simultaneously
2. **Summarize each viewport's judgment** before moving to the next
3. **Keep only the most recent judgment JSON in context** — older ones live on disk
4. **If context pressure is high**, reduce to desktop-only evaluation for non-critical iterations

### Judgment Consistency

LLM judgments have inherent variance. To ensure consistency:

1. **Use anchored score descriptions** (rubric.md) — forces the judge to map observations to specific score bands
2. **Conservative decision logic** — require clear improvement, not marginal
3. **Worst-across-viewports aggregation** — smooths per-viewport noise
4. **Baseline comparison** — always against last kept state, not volatile intermediate states
5. **Confidence scores** — low-confidence judgments (< 0.6) are flagged for human review
