# Autonomous Loop Protocol — UI Design Ratchet

Detailed protocol for the AutoUX iteration loop. SKILL.md has the summary; this file has the full rules.

Adapted from autoresearch's autonomous loop protocol with UI-specific **Render** and **Judge** phases replacing the mechanical Verify phase.

## Loop Modes

- **Unbounded (default):** Loop forever until manually interrupted (`Ctrl+C`)
- **Bounded:** Loop exactly N times when `Iterations: N` is set

When bounded, track `current_iteration` against `max_iterations`. After the final iteration, print a summary and stop.

## Phase 0: Precondition Checks (before loop starts)

**MUST complete ALL checks before entering the loop. Fail fast if any check fails.**

```bash
# 1. Verify git repo exists
git rev-parse --git-dir 2>/dev/null || echo "FAIL: not a git repo"

# 2. Check for dirty working tree
git status --porcelain
# → If dirty: warn user and ask to stash or commit first

# 3. Check for detached HEAD
git symbolic-ref HEAD 2>/dev/null || echo "WARN: detached HEAD"

# 4. Verify Playwright MCP is available
# → Test by calling mcp__playwright__browser_navigate to the Page URL
# → If navigation fails: inform user, suggest checking dev server

# 5. Verify dev server is running
# → Navigate to Page URL, check for non-error response
# → If server down: inform user, suggest starting dev server

# 6. Check for design reference files
# → Look for context/design-principles.md and context/style-guide.md
# → If missing: warn but proceed (Brand Alignment judge will evaluate internal consistency)

# 7. Create output directory
# → mkdir -p autoux/{YYMMDD}-{HHMM}-{slug}/screenshots
# → mkdir -p autoux/{YYMMDD}-{HHMM}-{slug}/judgments
```

**If any FAIL:** Stop and inform user. Do not enter the loop with broken preconditions.
**If any WARN:** Log the warning, proceed with caution, inform user.

## Phase 1: Review (Build Context)

Before each iteration, build situational awareness. **You MUST complete ALL steps.**

```
1. Read current state of in-scope files (full context)
2. Read last 10-20 entries from autoux-results.tsv
3. MUST run: git log --oneline -20 to see recent experiment history
4. MUST run: git diff HEAD~1 (if last iteration was "keep") to review what worked
5. MUST read: previous iteration's judgment JSON — specifically:
   - critique and suggestion from each judge persona
   - the next_suggestion field (this is your "gradient")
   - any conflict flags between judges
6. Read design-principles.md and style-guide.md for reference context
7. If bounded: check current_iteration vs max_iterations
```

**Why read judgment critiques every time?** The critique IS the gradient. It tells you exactly what each judge persona found lacking and what they suggest trying next. Without reading it, you're iterating blind — randomly trying changes instead of systematically addressing identified weaknesses.

**Git history usage pattern:**
- `git log --oneline -20` → see which visual experiments were kept vs reverted
- `git diff HEAD~1` → inspect the last kept CSS/component change to understand WHY it improved scores
- Use commit messages (e.g., "experiment(ui): increase CTA contrast") to avoid repeating failed approaches

## Phase 2: Ideate (Visual Strategy)

Pick the NEXT visual change. **MUST consult previous judgment critiques AND git history before deciding.**

**Priority order:**

1. **Address judge critiques** — the previous `next_suggestion` is the primary guide. If the accessibility judge said contrast is too low, fix contrast. If the polish judge said spacing is inconsistent, fix spacing.
2. **Fix hard gate failures** — if the previous iteration failed a gate, address that specific gate failure first
3. **Improve lowest-scoring dimension** — target the weakest soft score for maximum composite improvement
4. **Exploit successes** — if spacing improvements worked (kept commits), try related spacing changes in other areas
5. **Try different visual approaches** — vary colors, typography, layout structure
6. **Simplify** — remove visual clutter, reduce CSS rules while maintaining scores
7. **Radical experiments** — completely different layout, color scheme, or component structure

**Anti-patterns:**
- Don't repeat exact same change that was already discarded — CHECK git log first
- Don't make multiple unrelated visual changes at once (can't attribute score change)
- Don't chase marginal composite gains with ugly CSS hacks
- Don't ignore judge critiques — they are the primary learning signal

**Bounded mode consideration:** If remaining iterations are limited (<3 left), prioritize exploiting successes over exploration.

## Phase 3: Modify (One Visual Change)

Make ONE focused visual change to in-scope files.

**The one-sentence test:** If you need "and" linking unrelated visual changes, split them into separate iterations.

| One Change (OK) | Two Changes (Split) |
|-----------------|---------------------|
| Increase CTA button contrast and size | Increase CTA contrast AND change header font |
| Standardize all card border-radius to 8px | Fix border-radius AND add new animation |
| Improve mobile padding across hero section | Fix mobile padding AND change desktop layout |
| Change color palette to warmer tones | Change colors AND restructure navigation |

**Types of visual changes:**
- CSS property modifications (color, spacing, typography, shadows, borders)
- Component structure changes (reordering elements, changing hierarchy)
- Layout changes (grid/flex adjustments, responsive breakpoints)
- Typography changes (font size, weight, line-height, letter-spacing)
- Spacing changes (padding, margin, gap adjustments)
- Color changes (palette, contrast, opacity)
- Animation/transition changes (duration, easing, effects)

**Write the description BEFORE making the change** (forces clarity):
```
Description: "Standardize section spacing to 64px vertical rhythm"
→ One sentence, no "and" → proceed with modification
```

## Phase 4: Commit (Before Rendering)

**You MUST commit before rendering.** This enables clean rollback if the judgment fails.

```bash
# Stage ONLY in-scope files
git add <file1> <file2> ...
# NEVER use git add -A

# Check if there's actually something to commit
git diff --cached --quiet
# → If no changes: skip commit, log as "no-op", go to next iteration

# Commit with descriptive experiment message
git commit -m "experiment(ui): <one-sentence description>"
```

**Commit message format:** `experiment(ui): <description>`
- Examples: `experiment(ui): increase CTA contrast to 5.2:1`
- Examples: `experiment(ui): standardize card border-radius to 8px`
- Examples: `experiment(ui): improve mobile hero section padding`

**Hook failure handling:**
1. Read hook error output
2. If fixable (lint, formatting): fix and retry — do NOT use `--no-verify`
3. If not fixable within 2 attempts: log as `no-op`, revert changes, move to next iteration

## Phase 5 + 5.5: Render & Judge (via Subagent)

**CRITICAL: Render and Judge happen in a SUBAGENT, not in the main loop context.**

Screenshots are large multimodal tokens that would overflow the main loop's context over many iterations. Instead, spawn the `@ux-judge` subagent for each evaluation. The subagent renders, screenshots, judges, and returns a compact JSON verdict. Its context (with the heavy images) is discarded after.

### How to invoke

Spawn the `@ux-judge` subagent with this information:

```
Page: {page_url}
Viewports: desktop (1440x900), tablet (768x1024), mobile (375x812)
Iteration: {N}
Change: {one-sentence description of what was modified}
Baseline scores: {composite: X.X, ux_friction: N, visual_polish: N, brand_alignment: N}
Design refs: context/design-principles.md, context/style-guide.md
```

The subagent will:
1. Navigate to the page via Playwright MCP
2. Screenshot at each viewport
3. Check hard gates (console errors, layout integrity, accessibility)
4. Score soft dimensions (UX friction, visual polish, brand alignment)
5. Compute composite and verdict
6. Return a JSON verdict

### What comes back

The subagent returns ONLY a compact JSON:

```json
{
  "iteration": 3,
  "hard_gates": {"accessibility": "pass", "layout_integrity": "pass", "console_errors": "pass"},
  "gate_issues": [],
  "soft_scores": {
    "ux_friction": {"score": 7, "critique": "...", "suggestion": "..."},
    "visual_polish": {"score": 6, "critique": "...", "suggestion": "..."},
    "brand_alignment": {"score": 7, "critique": "...", "suggestion": "..."}
  },
  "composite": 6.65,
  "composite_delta": 0.75,
  "verdict": "keep",
  "reason": "...",
  "next_suggestion": "..."
}
```

### What the main loop does with it

1. Parse the verdict JSON
2. Save it to `autoux/{run}/judgments/iter-{N}-judgment.json`
3. Use `verdict` for the keep/discard decision (Phase 6)
4. Use `next_suggestion` to guide ideation in the next iteration (Phase 2)
5. Update baseline scores if verdict is "keep"

**The main loop NEVER holds screenshots in its context.** Only the compact JSON verdict persists.

### Dev server crash handling

If the subagent returns `{"verdict": "crash", "reason": "..."}`:
1. Check if dev server is still running
2. If crashed: attempt restart (max 2 tries), wait for server ready, re-spawn subagent
3. If still failing: log as "crash", revert commit, move to next iteration

### Baseline management

- Baseline scores start at iteration 0 (first subagent evaluation)
- Updated ONLY when verdict is "keep" — use the kept iteration's scores as new baseline
- Pass baseline scores to the subagent each time so it can compute deltas

## Phase 6: Decide (No Ambiguity)

```bash
# Rollback function
safe_revert() {
  echo "Reverting: $(git log --oneline -1)"

  # Attempt 1: git revert (preserves history — preferred)
  if git revert HEAD --no-edit 2>/dev/null; then
    echo "Reverted via git revert (experiment preserved in history)"
    return 0
  fi

  # Attempt 2: revert conflicted — fallback to reset
  git revert --abort 2>/dev/null
  git reset --hard HEAD~1
  echo "Reverted via reset (experiment removed from history)"
  return 0
}
```

**Decision execution:**

```
IF verdict == "keep":
    # Do nothing with git — commit stays
    # Update baseline screenshots to current screenshots
    # Log "keep" with all scores
    # Print: "Iteration {N}: KEEP — {reason} (composite: {score})"

ELIF verdict == "discard":
    safe_revert()
    # Log "discard" with scores and reason
    # Read critique for next iteration guidance
    # Print: "Iteration {N}: DISCARD — {reason}"

ELIF crashed:
    safe_revert()
    # Log "crash" with error details
    # Print: "Iteration {N}: CRASH — {error}"
```

**Why `git revert` instead of `git reset --hard`?**
- `git revert` preserves the failed experiment in history — the agent can read `git log` and see what visual approaches were tried and failed
- `git reset --hard` destroys the commit — the agent loses memory of what was attempted
- `git revert` is non-destructive and safer in Claude Code

## Phase 7: Log Results

Append to results log (TSV format from `references/results-logging.md`):

```tsv
{iteration}	{commit}	{a11y}	{layout}	{console}	{ux}	{polish}	{brand}	{composite}	{verdict}	{critique_summary}
```

Save full judgment JSON to `autoux/{run}/judgments/iter-{N}-judgment.json`.

**Valid statuses:** `baseline`, `keep`, `discard`, `crash`, `no-op`

## Phase 8: Repeat

### Unbounded Mode (default)

Go to Phase 1. **NEVER STOP. NEVER ASK IF YOU SHOULD CONTINUE.**

### Bounded Mode (with Iterations: N)

```
IF current_iteration < max_iterations:
    Go to Phase 1
ELIF all scores >= 9:
    Print: "Design optimization converged at iteration {N}! All scores at 9+."
    Print final summary
    STOP
ELSE:
    Print final summary
    STOP
```

**Final summary format:**
```
=== AutoUX Complete (N/N iterations) ===
Baseline: {baseline_composite} → Final: {current_composite} (+{delta})
UX Friction: {b}→{c} | Visual Polish: {b}→{c} | Brand Alignment: {b}→{c}
Keeps: X | Discards: Y | Crashes: Z
Best iteration: #{n} — {description} (composite: {score})
Top suggestion: "{next_suggestion from last judgment}"
```

### When Stuck (>5 consecutive discards)

Applies to both modes:

1. Re-read ALL in-scope files from scratch
2. Re-read the original Goal
3. Review entire results log for patterns — what has been tried and what worked
4. Re-read design-principles.md and style-guide.md
5. Try combining 2-3 previously successful visual approaches
6. Try the OPPOSITE of what hasn't been working
7. Try a radical visual change — different layout structure, color approach, or component organization

## Communication

- **DO NOT** ask "should I keep going?" — in unbounded mode, YES. ALWAYS. In bounded mode, continue until N is reached.
- **DO NOT** summarize after each iteration — just log and continue
- **DO** print a brief one-line status after each iteration: `"Iteration {N}: {KEEP/DISCARD} — {reason} (composite: {score})"`
- **DO** print a progress summary every 5 iterations (see results-logging.md)
- **DO** alert if you discover something surprising or game-changing
- **DO** print a final summary when bounded loop completes

## Crash Recovery

| Failure | Response |
|---------|----------|
| CSS syntax error | Fix immediately, don't count as separate iteration |
| Page won't render | Check dev server, attempt restart (max 2 tries), revert if still failing |
| Playwright MCP unavailable | Inform user, pause loop, wait for MCP to reconnect |
| Console JS error from code change | Revert, log as "crash", the console_gate will catch these |
| Dev server OOM/crash | Attempt restart, if persistent inform user and pause |
