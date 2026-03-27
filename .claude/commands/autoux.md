---
name: autoux
description: Autonomous UI Design Optimization. Modify frontend code, render via Playwright, evaluate screenshots with LLM-as-Judge panel, keep/discard, repeat.
argument-hint: "[Goal: <text>] [Scope: <glob>] [Page: <url>] [Viewports: desktop,tablet,mobile] [Iterations: N]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST, before reading any files)

Extract these from $ARGUMENTS:

- `Goal:` — text after "Goal:" keyword
- `Scope:` — file globs after "Scope:" keyword
- `Page:` — URL after "Page:" keyword
- `Viewports:` — comma-separated list (default: desktop,tablet,mobile)
- `Design-Refs:` — file paths (default: auto-detect)
- `Rubric-Weights:` — custom weights (default: ux_friction=0.4, visual_polish=0.35, brand_alignment=0.25)
- `Iterations:` or `--iterations` — integer N for bounded mode

## Execution

1. If Goal, Scope, and Page are all extracted — proceed to step 3
2. If any critical field is missing — use `AskUserQuestion` with batched questions as defined in SKILL.md "Interactive Setup" section
3. Read design reference files if they exist: `context/design-principles.md`, `context/style-guide.md`
4. Read `.claude/skills/autoux/references/autonomous-loop-protocol.md` for the loop phases
5. Execute: Modify → Render (Playwright screenshot) → Judge (4 personas) → Keep/Discard → Repeat
6. Read `.claude/skills/autoux/references/judge-system.md` ONLY when running the first judge evaluation
7. If bounded: after each iteration, check `current_iteration < max_iterations`. If not, STOP and print summary.

KEY: Do NOT read all reference files upfront. Read them on-demand as each phase begins. The SKILL.md already provides the overview.

IMPORTANT: Start executing immediately. Never stop early unless all scores reach 9+ or max_iterations reached.
