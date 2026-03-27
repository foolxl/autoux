---
name: autoux:review
description: One-shot design review. Captures screenshots at multiple viewports, runs the full LLM-as-Judge panel, and outputs a structured report with scores, critiques, and prioritized suggestions. Does NOT modify code.
argument-hint: "[Page: <url>] [Viewports: desktop,tablet,mobile]"
---

EXECUTE IMMEDIATELY — do not deliberate.

## Argument Parsing

- `Page:` — URL to review
- `Viewports:` — comma-separated viewport list (default: desktop,tablet,mobile)

## Execution

1. If Page is provided — proceed to step 3
2. If Page is missing — use `AskUserQuestion` to ask what URL to review
3. Read design reference files if they exist: `context/design-principles.md`, `context/style-guide.md`
4. Navigate to page via Playwright, capture screenshots at each viewport
5. Capture console messages and DOM snapshot
6. Read `.claude/skills/autoux/references/judge-system.md` for judge personas
7. Run the full judge panel evaluation
8. Output structured report: scores, critiques, findings by priority, suggestions
9. Suggest a `/autoux` command for automated improvement if issues found

IMPORTANT: This is READ-ONLY. Do NOT modify any code.
