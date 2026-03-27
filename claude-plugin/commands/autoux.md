---
name: autoux
description: Autonomous UI Design Optimization. Modify frontend code, render via Playwright, evaluate screenshots with LLM-as-Judge panel, keep/discard, repeat.
argument-hint: "[Goal: <text>] [Scope: <glob>] [Page: <url>] [Viewports: desktop,tablet,mobile] [Iterations: N]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST, before reading any files)

Extract these from $ARGUMENTS — the user may provide extensive context alongside config. Ignore prose and extract ONLY structured fields:

- `Goal:` — text after "Goal:" keyword
- `Scope:` or `--scope <glob>` — file globs after "Scope:" keyword
- `Page:` — URL after "Page:" keyword
- `Viewports:` — comma-separated list after "Viewports:" keyword (default: desktop,tablet,mobile)
- `Design-Refs:` — file paths after "Design-Refs:" keyword (default: auto-detect)
- `Rubric-Weights:` — custom weights after "Rubric-Weights:" keyword (default: ux_friction=0.4, visual_polish=0.35, brand_alignment=0.25)
- `Iterations:` or `--iterations` — integer N for bounded mode (CRITICAL: if set, you MUST run exactly N iterations then stop)

If `Iterations: N` or `--iterations N` is found, set `max_iterations = N`. Track `current_iteration` starting at 0. After iteration N, print final summary and STOP.

## Execution

1. Read the autonomous loop protocol: `.claude/skills/autoux/references/autonomous-loop-protocol.md`
2. Read the judge system protocol: `.claude/skills/autoux/references/judge-system.md`
3. Read the evaluation rubric: `.claude/skills/autoux/references/rubric.md`
4. Read the results logging format: `.claude/skills/autoux/references/results-logging.md`
5. If Goal, Scope, and Page are all extracted — proceed directly to loop setup
6. If any critical field is missing — use `AskUserQuestion` with batched questions as defined in SKILL.md "Interactive Setup" section
7. Read design reference files if they exist: `context/design-principles.md`, `context/style-guide.md`
8. Execute the autonomous loop: Modify → Render → Judge → Keep/Discard → Repeat
9. If bounded: after each iteration, check `current_iteration < max_iterations`. If not, STOP and print summary.

IMPORTANT: Start executing immediately. Stream all output live — never run in background. Never stop early unless all scores reach 9+ or max_iterations reached.
