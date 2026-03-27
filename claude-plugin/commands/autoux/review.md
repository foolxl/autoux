---
name: autoux:review
description: One-shot design review. Captures screenshots at multiple viewports, runs the full LLM-as-Judge panel, and outputs a structured report with scores, critiques, and prioritized suggestions. Does NOT modify code.
argument-hint: "[Page: <url>] [Viewports: desktop,tablet,mobile]"
---

EXECUTE IMMEDIATELY — do not deliberate.

## Argument Parsing

Extract from $ARGUMENTS:

- `Page:` — URL to review
- `Viewports:` — comma-separated viewport list (default: desktop,tablet,mobile)
- `Design-Refs:` — paths to design reference files (default: auto-detect)

## Execution

1. Read the review workflow protocol: `.claude/skills/autoux/references/review-workflow.md`
2. Read the judge system protocol: `.claude/skills/autoux/references/judge-system.md`
3. Read the evaluation rubric: `.claude/skills/autoux/references/rubric.md`
4. If Page is provided — proceed directly to review execution
5. If Page is missing — use `AskUserQuestion` to ask what URL to review
6. Read design reference files if they exist: `context/design-principles.md`, `context/style-guide.md`
7. Execute the review workflow: Navigate → Capture → Judge → Report
8. Output the structured design review report
9. Suggest a `/autoux` command for automated improvement if issues are found

IMPORTANT: This is a READ-ONLY operation. Do NOT modify any code. The purpose is diagnostic assessment only.
