# /autoux:auto — Zero-Config Mode

The simplest way to use AutoUX. Auto-detects everything and improves your entire frontend to enterprise-grade quality.

## Usage

```
/autoux:auto
```

That's it. No goal, no scope, no config.

## What Happens

1. **Framework detection** — Scans `package.json` for React, Vue, Next.js, Svelte, etc.
2. **Dev server** — Finds your running dev server or starts it automatically
3. **Page discovery** — Crawls your app via Playwright to find all routes
4. **Baseline scoring** — Quick-judges every page, ranks worst-to-best
5. **Confirmation** — Shows what it found, asks for a single yes/no
6. **Optimization** — Starts with the worst page, iterates until it reaches 8.0+ composite
7. **Progression** — Moves to the next page when the current one is good enough

## Options

```
# Optimize a specific page only
/autoux:auto --page http://localhost:3000/pricing

# Skip the confirmation prompt
/autoux:auto --skip-confirm

# Set a total iteration budget
/autoux:auto
Iterations: 50

# Set a higher quality threshold
/autoux:auto --threshold 9.0

# Include all pages (default is top 10 worst)
/autoux:auto --all
```

## What "Enterprise-Grade" Means

Auto mode targets these standards:

1. Fix any accessibility violations
2. Establish consistent 8px spacing rhythm
3. Refine typography hierarchy
4. Improve color consistency and contrast
5. Polish interactive states (hover, focus, active)
6. Optimize whitespace usage
7. Ensure responsive adaptation across viewports
8. Refine shadows, borders, radius for consistency

Benchmark: Stripe, Linear, Vercel quality.

## Key Behavior

**Elevate, don't replace.** Auto mode respects your existing design language. It improves spacing, polish, and consistency — it doesn't impose a completely different aesthetic.

If you use Tailwind with a custom theme, it works within your theme tokens. If you use shadcn/ui, it avoids the generic purple look and customizes toward your identity.

## Example Output

```
=== AutoUX Auto Mode ===
Framework: Next.js (React) + Tailwind CSS
Dev server: npm run dev → http://localhost:3000
Pages found: 5
  /           → 5.2 (lowest)
  /pricing    → 5.8
  /about      → 6.1
  /dashboard  → 6.5
  /settings   → 7.0

Will start with "/" (score: 5.2).
Proceed? [Yes]

...

=== AutoUX Auto Mode Complete ===

| Page       | Before | After | Delta |
|------------|--------|-------|-------|
| /          | 5.2    | 8.4   | +3.2  |
| /pricing   | 5.8    | 8.2   | +2.4  |
| /about     | 6.1    | 8.1   | +2.0  |
| /dashboard | 6.5    | 8.0   | +1.5  |

Total: 32 iterations (21 keeps, 10 discards, 1 crash)
```

## When to Use Auto vs Manual

| Scenario | Use |
|----------|-----|
| "Just make it look better" | `/autoux:auto` |
| Specific page or component | `/autoux` with Goal + Scope |
| Want to see scores first | `/autoux:review` |
| Comparing two approaches | `/autoux:compare` |
