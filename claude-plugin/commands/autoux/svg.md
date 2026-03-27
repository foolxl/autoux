---
name: autoux:svg
description: "Generate and iteratively refine SVG images from a text description. Logos, icons, plots, illustrations — describe it in one line, get a polished SVG."
argument-hint: "Describe: <one-line description> [Output: <filename.svg>] [Size: 400x400] [Iterations: N]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS — the user's description may be the entire argument with no prefix. Handle both:

- `Describe:` prefixed — text after "Describe:" keyword
- No prefix — treat entire argument as the description
- `Output:` — SVG filename (default: `output.svg`)
- `Size:` — render size in WxH (default: `400x400`)
- `Background:` — background color for preview (default: `white`)
- `Iterations:` or `--iterations` — bounded mode

Examples of valid invocations:
```
/autoux:svg minimalist mountain logo, earth tones
/autoux:svg Describe: blue tech company logo with circuit patterns Output: logo.svg
/autoux:svg a cute cat icon for a pet app Iterations: 15
```

## Execution

1. Read the SVG workflow protocol: `.claude/skills/autoux/references/svg-workflow.md`
2. Read the results logging format: `.claude/skills/autoux/references/results-logging.md`
3. If description is present — proceed directly
4. If description is missing — use `AskUserQuestion`:
   - "What SVG do you want to generate? (describe in one line)"
   - "Output filename?" (default: output.svg)
5. Read `context/style-guide.md` if it exists (for color/style guidance)
6. Create the HTML preview wrapper for Playwright rendering
7. Generate initial SVG from the description
8. Run the SVG judge panel for baseline
9. Execute the optimization loop: Modify SVG → Render → Judge → Keep/Discard → Repeat
10. Clean up preview HTML when done

IMPORTANT: The description is the spec. Re-read it every iteration. Never drift from what the user asked for — the Intent Judge will catch it.

## Key Rules

- ONE SVG change per iteration (path, color, proportion — not multiple)
- Pure vector only — no embedded raster images or base64
- Keep it minimal — simpler SVGs look more professional
- Test at 64x64 — if it's not readable small, the Clarity Judge will fail it
- Respect the description literally — "mountain" means a mountain shape, not an abstract triangle
