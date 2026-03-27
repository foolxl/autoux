---
name: autoux:compare
description: A/B design comparison. Renders and evaluates two design states (branches or commits) using the full judge panel, producing a side-by-side comparison report with score deltas and recommendation.
argument-hint: "[Page: <url>] [Branch-A: <name>] [Branch-B: <name>] [Commit-A: <hash>] [Commit-B: <hash>]"
---

EXECUTE IMMEDIATELY — do not deliberate.

## Argument Parsing

Extract from $ARGUMENTS:

- `Page:` — URL to compare
- `Branch-A:` or `Commit-A:` — first design state (baseline)
- `Branch-B:` or `Commit-B:` — second design state (variant)
- `States:` — comma-separated list for multi-state comparison
- `Viewports:` — comma-separated viewport list (default: desktop,tablet,mobile)

## Execution

1. Read the compare workflow protocol: `.claude/skills/autoux/references/compare-workflow.md`
2. Read the judge system protocol: `.claude/skills/autoux/references/judge-system.md`
3. Read the evaluation rubric: `.claude/skills/autoux/references/rubric.md`
4. If Page AND both states are provided — proceed directly to comparison
5. If any required field is missing — use `AskUserQuestion` with batched questions:
   - Page URL
   - State A (branch/commit/"current")
   - State B (branch/commit)
6. Read design reference files if they exist
7. Execute the compare workflow: Capture A → Capture B → Judge Both → Compare → Report
8. Output the structured comparison report with recommendation
9. Restore the original git state (checkout original branch, pop stash if needed)

IMPORTANT: This operation switches git branches/commits temporarily. It will restore the original state after comparison. Warn the user if there are uncommitted changes that need to be stashed.
