---
name: autoux:svg
description: "Generate and iteratively refine SVG images from a text description. Logos, icons, plots, illustrations — describe it in one line, get a polished SVG."
argument-hint: "Describe: <one-line description> [Output: <filename.svg>] [Size: 400x400] [Iterations: N]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS — the user's description may be the entire argument with no prefix:

- `Describe:` prefixed — text after "Describe:" keyword
- No prefix — treat entire argument as the description
- `Output:` — SVG filename (default: `output.svg`)
- `Size:` — render size in WxH (default: `400x400`)
- `Background:` — background color for preview (default: `white`)
- `Iterations:` or `--iterations` — bounded mode

## Execution

1. If description is present — proceed to step 3
2. If description is missing — use `AskUserQuestion`: "What SVG do you want? (one line)"
3. Read `context/style-guide.md` if it exists (for color guidance)
4. Read `.claude/skills/autoux/references/svg-workflow.md` for judge personas and rendering setup
5. Create HTML preview wrapper, generate initial SVG from description
6. Run the SVG optimization loop: Modify SVG → Render via Playwright → Judge → Keep/Discard → Repeat

KEY: Do NOT read all reference files upfront. The svg-workflow.md contains everything needed.

## Key Rules

- ONE SVG change per iteration (path, color, proportion — not multiple)
- Pure vector only — no embedded raster images or base64
- Keep it minimal — simpler SVGs look more professional
- Test at 64x64 — if it's not readable small, the Clarity Judge will fail it
- Re-read the description every iteration — never drift from user intent
