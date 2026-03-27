# AutoUX

**Autonomous UI Design Optimization for Claude Code.**

AutoUX applies [Karpathy's autoresearch](https://github.com/karpathy/autoresearch) ratchet loop to visual UI/UX improvement. It modifies your frontend code, renders screenshots via Playwright, evaluates them with a multi-dimensional LLM-as-Judge panel, keeps improvements, discards regressions, and repeats — autonomously.

No external APIs. No extra dependencies. Just Claude Code + Playwright MCP.

```
/autoux:auto
```

That's it. AutoUX detects your framework, starts your dev server, discovers your pages, and starts improving them to enterprise-grade quality.

---

## How It Works

```
┌─────────────────────────────────────────────────────┐
│                  The AutoUX Loop                     │
│                                                      │
│   ┌──────────┐    ┌──────────┐    ┌──────────────┐  │
│   │  Modify   │───▶│  Render   │───▶│    Judge     │  │
│   │  (code)   │    │(Playwright│    │(LLM-as-Judge │  │
│   │           │    │screenshot)│    │  4 personas) │  │
│   └──────────┘    └──────────┘    └──────┬───────┘  │
│        ▲                                  │          │
│        │         ┌──────────┐             │          │
│        │         │  Decide   │◀────────────┘          │
│        └─────────│keep/discard│                       │
│                  └──────────┘                        │
└─────────────────────────────────────────────────────┘
```

1. **Modify** — Agent makes ONE focused visual change (spacing, typography, colors, layout)
2. **Render** — Playwright MCP screenshots the page at desktop, tablet, and mobile viewports
3. **Judge** — 4 specialized judge personas evaluate the screenshots:
   - **Accessibility Judge** (hard gate) — WCAG 2.1 AA compliance, contrast, touch targets
   - **UX Friction Judge** (1-10) — cognitive load, information hierarchy, task flow
   - **Visual Polish Judge** (1-10) — spacing, alignment, typography, color harmony
   - **Brand Alignment Judge** (1-10) — adherence to your design system / style guide
4. **Decide** — Hard gate failure = instant discard. Otherwise: keep if improved, discard if not
5. **Repeat** — Critiques from judges guide the next iteration (the "gradient")

Every experiment is git-committed. Failures are reverted with `git revert` (preserving history as memory). The agent reads its own git log and previous judge critiques to learn what works.

---

## Installation

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (CLI, desktop app, or IDE extension)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp) installed in Claude Code

### Install Playwright MCP

```bash
claude mcp add playwright -- npx @anthropic-ai/mcp-playwright
```

### Install AutoUX

**Option A: Plugin install** (recommended)

In Claude Code, run:

```
/plugin marketplace add foolxl/autoux
/plugin install autoux@autoux
```

**Option B: Manual install** (for customization)

```bash
# Project-local (current project only)
git clone https://github.com/foolxl/autoux /tmp/autoux
cp -r /tmp/autoux/claude-plugin/skills/autoux .claude/skills/autoux
cp -r /tmp/autoux/claude-plugin/commands/autoux .claude/commands/autoux
cp /tmp/autoux/claude-plugin/commands/autoux.md .claude/commands/autoux.md
cp -r /tmp/autoux/context ./context  # optional — template design refs

# Or global (available in all projects)
cp -r /tmp/autoux/claude-plugin/skills/autoux ~/.claude/skills/autoux
cp -r /tmp/autoux/claude-plugin/commands/autoux ~/.claude/commands/autoux
cp /tmp/autoux/claude-plugin/commands/autoux.md ~/.claude/commands/autoux.md
```

### Updating

```
/plugin update autoux
```

Then start a new Claude Code session to activate changes.

---

## Quick Start

### Zero-Config (Simplest)

Just run this in any frontend project:

```
/autoux:auto
```

AutoUX will:
1. Detect your framework (React, Vue, Next.js, Svelte, etc.)
2. Find or start your dev server
3. Discover all pages via Playwright
4. Score each page, start with the worst
5. Autonomously improve until enterprise-grade (8.0+ composite)

### With Configuration

```
/autoux
Goal: Make the checkout flow feel more premium
Scope: src/components/checkout/**/*.tsx, src/styles/checkout.css
Page: http://localhost:3000/checkout
Iterations: 15
```

### One-Shot Review (No Changes)

```
/autoux:review
Page: http://localhost:3000
```

Gets you a structured report with scores, critiques, and prioritized suggestions — without modifying any code.

---

## Commands

| Command | Description |
|---------|-------------|
| `/autoux` | Run the autonomous optimization loop with custom config |
| `/autoux:auto` | Zero-config mode — auto-detect everything, improve to enterprise-grade |
| `/autoux:svg` | Generate and refine SVGs from a one-line description (logos, icons, plots) |
| `/autoux:plan` | Interactive wizard to build a configuration |
| `/autoux:review` | One-shot design review (read-only, no code changes) |
| `/autoux:compare` | A/B comparison between branches or commits |

---

## The Judge System

AutoUX replaces the single numerical metric (like autoresearch's `val_bpb`) with a **multi-dimensional LLM-as-Judge** evaluation. Claude evaluates its own screenshots — no external API calls needed.

### Hard Gates (Pass/Fail Veto)

| Gate | What It Checks |
|------|---------------|
| **Accessibility** | WCAG AA contrast (4.5:1), text size (12px+), touch targets (44px+), semantic HTML |
| **Layout Integrity** | No horizontal scroll, no overflow, no element overlap |
| **Console Errors** | Zero JavaScript errors |

If any gate fails, the change is **immediately discarded** regardless of soft scores.

### Soft Scores (1-10)

| Dimension | Weight | What It Evaluates |
|-----------|--------|------------------|
| **UX Friction** | 0.40 | Cognitive load, CTA prominence, visual flow, information hierarchy |
| **Visual Polish** | 0.35 | Spacing consistency, typography hierarchy, alignment, color harmony |
| **Brand Alignment** | 0.25 | Adherence to your design-principles.md and style-guide.md |

### Critique as Gradient

Each judge provides a **critique** (what's wrong) and a **suggestion** (what to try). This text serves as the "gradient" guiding the next iteration — replacing the numerical delta that autoresearch uses.

```
Judge says: "CTA contrast ratio is 3.8:1, below 4.5:1 minimum"
  → Agent modifies CTA background color
    → Next render + judge cycle evaluates the fix
```

---

## Customizing for Your Project

### Design References

Create these files in your project to guide the Brand Alignment judge:

- **`context/design-principles.md`** — Your design philosophy (visual hierarchy, spacing system, typography rules)
- **`context/style-guide.md`** — Your specific tokens (colors, fonts, spacing values, component patterns)

Template files are included — customize them for your project.

### Rubric Weights

Override weights inline:

```
/autoux
Goal: Improve mobile accessibility
Rubric-Weights: ux_friction=0.5, visual_polish=0.2, brand_alignment=0.3
```

Or via `/autoux:plan` for interactive configuration.

---

## Architecture

```
.claude/
  skills/autoux/
    SKILL.md                         # Main skill definition
    references/
      autonomous-loop-protocol.md    # 8-phase ratchet loop
      judge-system.md                # Multi-persona judge panel
      rubric.md                      # Evaluation rubric
      core-principles.md             # 7 adapted principles
      results-logging.md             # TSV + JSON logging format
      auto-workflow.md               # Zero-config auto-detection
      plan-workflow.md               # Interactive setup wizard
      review-workflow.md             # One-shot review protocol
      compare-workflow.md            # A/B comparison protocol
  commands/
    autoux.md                        # /autoux command
    autoux/
      auto.md                        # /autoux:auto command
      plan.md                        # /autoux:plan command
      review.md                      # /autoux:review command
      compare.md                     # /autoux:compare command
context/
  design-principles.md               # Template (user customizes)
  style-guide.md                     # Template (user customizes)
```

### Runtime Artifacts

```
autoux-results.tsv                   # Experiment log (gitignored)
autoux/{run}/
  screenshots/iter-{N}-{viewport}.png
  judgments/iter-{N}-judgment.json
  summary.md
```

---

## How It Compares

| | Karpathy's autoresearch | Claude Autoresearch | AutoUX |
|---|---|---|---|
| **Domain** | ML training | Any measurable task | Visual UI/UX |
| **Metric** | val_bpb (single number) | Any shell command output | LLM-as-Judge (multi-dimensional) |
| **Evaluation** | Run training script | Run verification command | Playwright screenshot + judge panel |
| **Scope** | train.py | Any file glob | Frontend code (CSS/components) |
| **Feedback** | Numerical delta | Numerical delta | Critique text ("gradient") |
| **External deps** | GPU + PyTorch | None | Playwright MCP only |

---

## Examples

### Starting Scores → After 10 Iterations

```
=== AutoUX Complete (10/10 iterations) ===
Baseline: 4.90 → Final: 7.75 (+2.85)

  UX Friction:     5 → 8  (+3)
  Visual Polish:   4 → 8  (+4)
  Brand Alignment: 6 → 7  (+1)

Keeps: 6 | Discards: 3 | Crashes: 1
Best iteration: #7 — fixed mobile overflow, improved CTA sizing
```

### Auto Mode Multi-Page

```
=== AutoUX Auto Mode Complete ===

| Page       | Before | After | Delta |
|------------|--------|-------|-------|
| /          | 5.2    | 8.4   | +3.2  |
| /pricing   | 5.8    | 8.2   | +2.4  |
| /about     | 6.1    | 8.1   | +2.0  |
| /dashboard | 6.5    | 8.0   | +1.5  |

Total: 32 iterations (21 keeps, 10 discards, 1 crash)
```

---

## Inspired By

- [Karpathy's autoresearch](https://github.com/karpathy/autoresearch) — The original autonomous ML research loop
- [Claude Autoresearch](https://github.com/uditgoenka/autoresearch) — Generalized autoresearch as a Claude Code skill
- [Claude Code Workflows](https://github.com/patrickjohnellis/claude-code-workflows) — Design review agents with Playwright MCP
- [Playwright MCP](https://github.com/microsoft/playwright-mcp) — Browser automation for Claude Code

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

[MIT](LICENSE)
