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

1. Read `.claude/skills/autoux/references/auto-workflow.md` for the detection pipeline
2. Run the auto-detection pipeline:
   a. Detect framework and styling approach from package.json
   b. Detect or start dev server
   c. Detect scope (frontend files matching framework patterns)
   d. Discover pages via Playwright link crawling
   e. Baseline score each discovered page (quick judge — desktop only)
   f. Sort pages by score (lowest first)
3. Read design reference files if they exist: `context/design-principles.md`, `context/style-guide.md`
4. If `--skip-confirm` NOT set: present auto-detected config, ask for single confirmation
5. Execute the multi-page optimization loop (read loop protocol and judge system on-demand as needed)
6. Print final multi-page summary

KEY: Do NOT read all reference files upfront. Read auto-workflow.md first, then read judge-system.md and loop-protocol.md on-demand when each phase begins.

## Hardcoded Goal

> Transform this UI to enterprise-grade quality matching Stripe, Linear, and Vercel standards. Fix accessibility violations, establish consistent spacing, refine typography hierarchy, improve color consistency, polish interactive states, optimize whitespace, ensure responsive adaptation, and elevate overall feel to premium/professional.

Do NOT ask the user to define a goal. That's the point of auto mode.

## Key Behavior

- **Elevate, don't replace.** Respect the existing design language.
- **Scan for existing design tokens** (CSS custom properties, Tailwind theme) and work within them.
- **If shadcn/ui detected:** Avoid the generic purple look — customize toward project identity.
- **Progress through pages** worst-first. Move on when a page hits the threshold or stalls (5 consecutive discards).
