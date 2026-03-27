# Getting Started with AutoUX

## Prerequisites

1. **Claude Code** — CLI, desktop app, or IDE extension
2. **Playwright MCP** — Browser automation for screenshots

### Install Playwright MCP

```bash
claude mcp add playwright -- npx @anthropic-ai/mcp-playwright
```

### Install AutoUX

**Plugin install (recommended):**

```
/plugin marketplace add foolxl/autoux
/plugin install autoux@autoux
```

> **Note:** Start a new Claude Code session after installing. Reference files aren't resolvable in the same session where installation happened — this is a Claude Code platform limitation.

**Manual install:** See [README.md](../README.md) for alternative methods.

### Verify Installation

Type `/autoux` in Claude Code — you should see the command in autocomplete.

## Core Concepts

### The Ratchet Loop

AutoUX works like Karpathy's autoresearch but for visual design:

1. Agent modifies your CSS/component code (one change at a time)
2. Playwright renders the page and takes screenshots
3. LLM-as-Judge panel evaluates the screenshots
4. If improved → keep. If not → revert. Repeat.

Improvements stack. Failures are reverted. The design ratchets upward.

### LLM-as-Judge (No External APIs)

Claude evaluates its own screenshots — no external model calls needed. It adopts 4 specialized judge personas:

- **Accessibility Judge** — WCAG compliance (hard pass/fail gate)
- **UX Friction Judge** — Cognitive load, hierarchy, task flow (1-10)
- **Visual Polish Judge** — Spacing, typography, alignment (1-10)
- **Brand Alignment Judge** — Adherence to your style guide (1-10)

### Critique as Gradient

Each judge provides a critique and suggestion. This text guides the next iteration — it's the "gradient" that tells the agent WHERE to focus. This replaces the single numerical metric that autoresearch uses.

### Git as Memory

Every experiment is committed before evaluation. Failures are reverted with `git revert` (preserving history). The agent reads its own git log to learn what works and avoid repeating failures.

## Your First Run

### Option 1: Zero-Config (Easiest)

Open Claude Code in any frontend project and run:

```
/autoux:auto
```

AutoUX will auto-detect your framework, start your dev server, discover pages, and start improving.

### Option 2: One-Shot Review (No Changes)

Want to see what AutoUX thinks before letting it modify code?

```
/autoux:review
Page: http://localhost:3000
```

This gives you a structured report without changing anything.

### Option 3: Targeted Optimization

```
/autoux
Goal: Make the hero section more visually polished
Scope: src/components/hero/**/*.tsx, src/styles/hero.css
Page: http://localhost:3000
Iterations: 10
```

## Adding Design References

For best results, create these files in your project:

- **`context/design-principles.md`** — Your design philosophy
- **`context/style-guide.md`** — Your specific tokens (colors, fonts, spacing)

Template files are included with the plugin. Customize them for your brand.

Without these files, AutoUX still works — it evaluates internal consistency instead of brand adherence.

## FAQ

**Q: Does it work with any frontend framework?**
A: Yes — React, Vue, Next.js, Svelte, Angular, Astro, and plain HTML/CSS. Auto mode detects your framework.

**Q: Will it break my code?**
A: Every change is committed before evaluation. If the judge says it's worse, the change is immediately reverted via `git revert`. Your code is always in a working state.

**Q: How long should I let it run?**
A: Start with `Iterations: 10` to see the pattern. For overnight runs, use unlimited mode. Most pages see significant improvement within 10-20 iterations.

**Q: Can I customize what it evaluates?**
A: Yes — adjust rubric weights, add custom gates, and provide design reference files. See [Customizing the Rubric](customizing-rubric.md).
