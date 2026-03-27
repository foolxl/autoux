---
name: autoux:plan
description: Interactive wizard to configure an AutoUX optimization run. Scans project, suggests scope/page/viewports, takes baseline screenshots, and generates ready-to-run command.
argument-hint: "[Goal: <text>]"
---

EXECUTE IMMEDIATELY — do not deliberate.

## Argument Parsing

- `Goal:` — text describing what to improve visually. If no prefix, treat entire argument as the goal.

## Execution

1. If Goal is provided — proceed to step 3
2. If Goal is missing — use `AskUserQuestion` to ask what to improve visually
3. Scan project: detect framework, style files, dev server, component directories
4. Read `.claude/skills/autoux/references/plan-workflow.md` for the wizard steps
5. Ask batched questions: scope, page URL, viewports, design refs
6. Verify dev server via Playwright
7. Take baseline screenshots, run quick judge, show starting scores
8. Present ready-to-run `/autoux` command
9. If user chooses "Launch now" — execute the main autoux loop

IMPORTANT: Always show baseline scores before offering to launch.
