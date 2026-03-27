# /autoux:svg — SVG Generation & Refinement

Generate and iteratively refine SVG images from a one-line text description. Logos, icons, plots, illustrations, diagrams.

## Usage

```
/autoux:svg minimalist mountain logo, earth tones
```

That's it. Describe what you want, get a polished SVG.

## More Examples

```
# Logo
/autoux:svg blue tech company logo with circuit board patterns

# Icon
/autoux:svg a cute cat icon for a pet app

# Chart
/autoux:svg bar chart showing Q1-Q4 revenue growth

# Illustration
/autoux:svg simple line art of a coffee cup, black and white

# With options
/autoux:svg Describe: geometric wolf head logo Output: wolf-logo.svg Iterations: 20
```

## How It Works

1. Agent generates initial SVG from your description
2. Wraps SVG in an HTML page, renders via Playwright
3. Screenshots at 3 sizes (64px, 400px, 800px)
4. 4 SVG-specific judges evaluate:
   - **Clarity** (hard gate) — readable at small sizes? No broken paths?
   - **Craft** (1-10) — path precision, symmetry, geometric quality
   - **Style** (1-10) — color harmony, visual appeal, modern feel
   - **Intent** (1-10) — does it match your description?
5. Keep if improved, discard if not
6. Repeat with critique guidance

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `Output:` | `output.svg` | Filename for the SVG |
| `Size:` | `400x400` | Primary render size |
| `Background:` | `white` | Preview background color |
| `Iterations:` | Unlimited | Stop after N iterations |

## Tips

- **Be specific** — "minimalist mountain, earth tones, rounded peaks" gets better results than "mountain"
- **Mention style** — "flat design", "line art", "geometric", "hand-drawn feel"
- **Mention colors** — "blue and white", "monochrome", "warm sunset gradients"
- **Mention use case** — "app icon" triggers icon-appropriate sizing, "logo" triggers clean/scalable design
