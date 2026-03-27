---
name: autoux:plan
description: Interactive wizard to configure an AutoUX optimization run. Scans project, suggests scope/page/viewports, takes baseline screenshots, and generates ready-to-run command.
argument-hint: "[Goal: <text>]"
---

EXECUTE IMMEDIATELY — do not deliberate.

## Argument Parsing

Extract from $ARGUMENTS:

- `Goal:` — text describing what to improve visually. If no "Goal:" prefix, treat the entire argument as the goal.

## Execution

1. Read the plan workflow protocol: `.claude/skills/autoux/references/plan-workflow.md`
2. Read the evaluation rubric: `.claude/skills/autoux/references/rubric.md`
3. If Goal is provided — proceed to project analysis (Step 2 of plan-workflow.md)
4. If Goal is missing — use `AskUserQuestion` to ask what the user wants to improve visually
5. Follow all steps in plan-workflow.md: Analyze → Configure → Verify → Baseline → Confirm
6. Present the ready-to-run `/autoux` command to the user
7. If user chooses "Launch now" — immediately execute the main autoux loop

IMPORTANT: Always take baseline screenshots and show starting scores before offering to launch. The user should see where they're starting from.
