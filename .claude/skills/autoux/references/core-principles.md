# Core Principles — Adapted from Karpathy's Autoresearch for Visual UI Optimization

7 universal principles extracted from autoresearch, adapted for autonomous UI design improvement using LLM-as-Judge evaluation.

## 1. Constraint = Enabler

Autonomy succeeds through intentional constraint, not despite it.

| Autoresearch | AutoUX |
|--------------|--------|
| 630-line codebase | Bounded file scope (CSS/components only) |
| 5-minute time budget | Fast render + judge cycle (~30 seconds) |
| One metric (val_bpb) | Structured rubric with hard gates + soft scores |

**Why:** Constraints enable agent confidence (full context understood), verification simplicity (rubric provides clear pass/fail), iteration velocity (fast screenshot cycles = more experiments).

**Apply:** Before starting, define: what files are in-scope? What page to render? What viewports to test? What rubric weights to use?

## 2. Separate Strategy from Tactics

Humans set visual direction. Agents execute design iterations.

| Strategic (Human) | Tactical (Agent) |
|-------------------|------------------|
| "Make checkout feel premium" | "Increase whitespace, refine typography, soften shadows" |
| "Improve mobile usability" | "Enlarge touch targets, simplify navigation, stack layout" |
| "Match our brand identity" | "Apply brand colors, use specified fonts, follow spacing system" |

**Why:** Humans understand the subjective WHY — the brand feeling, the user emotion, the business goal. Agents handle the HOW — systematically trying CSS and component variations.

**Apply:** Get clear visual direction from user (Goal field). Reference design-principles.md and style-guide.md. Then iterate autonomously on implementation.

## 3. Critique as Gradient

Judge feedback text guides the next iteration — replacing mechanical metric deltas.

In autoresearch, the agent learns from `val_bpb` going up or down. In AutoUX, there IS no single number. Instead:

- Each judge persona provides a **critique** (what's wrong) and a **suggestion** (what to try next)
- The `next_suggestion` field is the agent's "gradient" — it tells the agent WHERE to focus
- The agent MUST read previous critiques before ideating the next change

**Example gradient:**
```
Previous judgment → next_suggestion: "The CTA button contrast ratio is 3.8:1,
below the 4.5:1 minimum. Try a darker background or lighter text."

Agent reads this → modifies the CTA background color → renders → judges again
```

**Anti-pattern:** Ignoring critiques and randomly trying changes. This wastes iterations.

**Apply:** Every iteration starts by reading the previous judgment. The critique IS the direction.

## 4. Rendering Must Be Fast

If rendering takes longer than the design change itself, iteration velocity drops.

| Fast (enables iteration) | Slow (kills iteration) |
|-------------------------|----------------------|
| Hot-reload dev server (~1s) | Full production build (~minutes) |
| Single page screenshot (~2s) | Full site crawl (~minutes) |
| Targeted viewport test (3 sizes) | Every possible device (~dozens) |

**Apply:** Use the FASTEST rendering path. Hot-reload dev servers, single-page focus, limited viewport set. Save comprehensive testing for after the loop.

## 5. Iteration Cost Shapes Behavior

- Cheap iteration → bold visual exploration, many experiments
- Expensive iteration → conservative, few experiments

AutoUX: ~30-second cycle (render + judge) → ~120 experiments/hour.
With 3 viewports: ~45-second cycle → ~80 experiments/hour.

**Apply:** Minimize render + judge time. Use fast dev servers, limit viewport count during exploration (add more viewports for final validation), keep scope focused.

## 6. Git as Memory and Visual Audit Trail

Every visual experiment is committed. This enables:
- **Causality tracking** — which CSS change improved visual polish?
- **Stacking wins** — each commit builds on prior visual improvements
- **Pattern learning** — agent sees what visual approaches worked in THIS project
- **Human review** — designer can inspect the visual evolution via git history
- **Visual history** — screenshots archived alongside judgments for each iteration

**Apply:** Commit before rendering. Revert on failure (using `git revert` to preserve history). Agent reads its own git history AND previous judgment critiques to inform next experiment.

**Key commands the agent runs every iteration:**
```bash
git log --oneline -20           # see experiment sequence (kept vs reverted)
git diff HEAD~1                 # inspect last kept change to understand WHY it worked
```

**Without Git Memory:**
```
Iteration 1: Try larger padding → discard (brand alignment dropped)
Iteration 5: Try larger padding → REPEATED! Same failure
```

**With Git Memory:**
```
Iteration 1: Try larger padding → discard (brand alignment dropped)
Iteration 2: git log shows padding was tried and failed
             → Agent reads critique: "padding exceeded 8px grid"
             → Tries padding within 8px grid → keep!
```

## 7. Honest Limitations

State what the system can and cannot do. Don't oversell.

AutoUX CANNOT:
- Replace human aesthetic judgment for subjective brand decisions
- Guarantee designs will convert better (no real user data)
- Evaluate complex user flows spanning multiple pages (single-page focus)
- Judge animation timing or motion design from static screenshots
- Access Figma designs directly (needs exported images or manual reference)

AutoUX CAN:
- Systematically explore CSS/component variations faster than manual iteration
- Catch accessibility issues, layout breaks, and console errors automatically
- Maintain brand consistency against a defined style guide
- Improve visual polish through structured, critique-guided iteration
- Archive all experiments with screenshots for human review

**Apply:** At setup, explicitly state what's in scope and what's not. If the agent hits a wall (needs user input on subjective brand direction, can't reproduce a layout issue), say so clearly.

## The Meta-Principle

> Autonomy scales when you constrain scope, structure evaluation, provide visual feedback (screenshots), and let agents optimize visual tactics while humans optimize visual strategy.

This isn't "removing designers." It's augmenting design iteration speed. Humans define the vision and evaluate the Pareto frontier. Agents systematically explore the design space.
