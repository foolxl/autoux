---
name: autoux:compare
description: A/B design comparison. Renders and evaluates two design states (branches or commits) using the full judge panel, producing a side-by-side comparison report with score deltas and recommendation.
argument-hint: "[Page: <url>] [Branch-A: <name>] [Branch-B: <name>] [Commit-A: <hash>] [Commit-B: <hash>]"
---

EXECUTE IMMEDIATELY — do not deliberate.

## Argument Parsing

- `Page:` — URL to compare
- `Branch-A:` or `Commit-A:` — first design state (baseline)
- `Branch-B:` or `Commit-B:` — second design state (variant)
- `Viewports:` — comma-separated viewport list (default: desktop,tablet,mobile)

## Execution

1. If Page AND both states are provided — proceed to step 3
2. If any required field is missing — use `AskUserQuestion` with batched questions
3. Read design reference files if they exist
4. Capture State A: checkout branch/commit → navigate → screenshot → judge
5. Capture State B: checkout branch/commit → navigate → screenshot → judge
6. Read `.claude/skills/autoux/references/judge-system.md` for judge personas (if not already read)
7. Generate side-by-side comparison report with score deltas and recommendation
8. Restore original git state (checkout original branch, pop stash)

IMPORTANT: This switches git branches temporarily. Warn if uncommitted changes need stashing.
