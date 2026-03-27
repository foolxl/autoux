---
name: autoux:auto
description: "Zero-config UI optimization. Auto-detects framework, dev server, pages, and scope. Improves the entire frontend to enterprise-grade quality (Stripe/Linear/Vercel level). Just run it."
argument-hint: "[--page <url>] [--threshold <N>] [--skip-confirm] [Iterations: N]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing

Extract from $ARGUMENTS (all optional — the whole point is zero-config):

- `--page <url>` — optimize a specific page only (skip page discovery)
- `--all` — include all discovered pages, not just top 10
- `--threshold <N>` — page completion score threshold (default: 8.0)
- `--skip-confirm` — skip the confirmation prompt
- `--no-start-server` — don't attempt to auto-start dev server
- `Iterations:` or `--iterations` — total iteration budget across all pages

## Execution

1. Read the auto workflow protocol: `.claude/skills/autoux/references/auto-workflow.md`
2. Read the autonomous loop protocol: `.claude/skills/autoux/references/autonomous-loop-protocol.md`
3. Read the judge system protocol: `.claude/skills/autoux/references/judge-system.md`
4. Read the evaluation rubric: `.claude/skills/autoux/references/rubric.md`
5. Read the results logging format: `.claude/skills/autoux/references/results-logging.md`
6. Run the auto-detection pipeline:
   a. Detect framework and styling approach from package.json
   b. Detect or start dev server
   c. Detect scope (frontend files matching framework patterns)
   d. Discover pages via Playwright link crawling
   e. Baseline score each discovered page (quick judge)
   f. Sort pages by score (lowest first)
7. Read design reference files if they exist: `context/design-principles.md`, `context/style-guide.md`
8. If `--skip-confirm` NOT set: present auto-detected config, ask for single confirmation
9. Execute the multi-page optimization loop:
   - Start with lowest-scoring page
   - Run standard autoux loop (Modify → Render → Judge → Keep/Discard)
   - Progress to next page when current reaches threshold or stalls
   - Continue until all pages reach threshold, iterations exhausted, or interrupted
10. Print final multi-page summary

IMPORTANT: Start detection immediately. The goal is SPEED — get from `/autoux:auto` to first iteration as fast as possible. Minimize questions, maximize auto-detection.

## Hardcoded Goal

The goal for auto mode is always:

> Transform this UI to enterprise-grade quality matching Stripe, Linear, and Vercel standards. Fix accessibility violations, establish consistent spacing, refine typography hierarchy, improve color consistency, polish interactive states, optimize whitespace, ensure responsive adaptation, and elevate overall feel to premium/professional.

Do NOT ask the user to define a goal. That's the point of auto mode.

## Key Behavior

- **Elevate, don't replace.** Respect the existing design language. Improve spacing, polish, and consistency — don't impose a completely different aesthetic.
- **Scan for existing design tokens** (CSS custom properties, Tailwind theme) and work within them.
- **If shadcn/ui detected:** Note this explicitly. Avoid the generic purple shadcn look — customize toward the project's own identity.
- **Progress through pages** from worst to best scoring. Move on when a page hits the threshold or stalls (5 consecutive discards).
