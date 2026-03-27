# Auto Workflow — Zero-Config Enterprise-Grade UI Optimization

Zero-config mode that auto-detects everything and improves a frontend project to enterprise-grade quality. The user just runs `/autoux:auto` in a project with frontend code — nothing else required.

## Philosophy

Most developers don't want to configure rubrics, define scopes, or pick viewports. They want to say "make this look professional" and come back to a better UI. Auto mode is that experience.

**Target quality benchmark:** Stripe, Linear, Vercel, Notion — the SaaS products known for world-class UI craft.

## Auto-Detection Pipeline

### Step 1: Framework Detection

Scan project root for framework signals:

```
1. Read package.json → detect framework from dependencies:
   - "next" → Next.js
   - "react", "react-dom" → React (CRA or custom)
   - "vue" → Vue
   - "svelte", "@sveltejs/kit" → Svelte/SvelteKit
   - "nuxt" → Nuxt
   - "astro" → Astro
   - "@angular/core" → Angular
   - "solid-js" → SolidJS
   - "remix" → Remix

2. Detect styling approach:
   - "tailwindcss" in dependencies → Tailwind CSS
   - *.module.css files → CSS Modules
   - "styled-components" → Styled Components
   - "sass", "scss" → Sass/SCSS
   - "@emotion" → Emotion
   - Plain .css files → Vanilla CSS

3. Detect UI libraries:
   - "shadcn" → shadcn/ui (note: avoid generic shadcn look)
   - "@radix-ui" → Radix primitives
   - "@mui/material" → Material UI
   - "@chakra-ui" → Chakra UI
   - "@mantine" → Mantine
   - "antd" → Ant Design
```

**Output:** Framework name, styling approach, UI library (if any).

### Step 2: Dev Server Detection & Startup

```
1. Check if a dev server is already running:
   - Probe common ports: 3000, 3001, 5173, 5174, 4321, 8080, 8000, 4200
   - For each port: attempt HEAD request to http://localhost:{port}
   - If response received → dev server found, note the port

2. If no server running, auto-start:
   a. Read package.json "scripts" for dev server command:
      - "dev" → npm run dev (most common)
      - "start" → npm run start
      - "serve" → npm run serve
   b. Run the command in background
   c. Wait for server to be ready (poll port every 1 second, timeout 30 seconds)
   d. If timeout → inform user, ask them to start manually

3. Record: dev_server_url = http://localhost:{port}
```

### Step 3: Scope Detection

Auto-detect all modifiable frontend files:

```
Framework-specific scope patterns:

Next.js / React:
  src/components/**/*.{tsx,jsx}
  src/app/**/*.{tsx,jsx}
  src/pages/**/*.{tsx,jsx}
  src/styles/**/*.{css,scss}
  app/**/*.{tsx,jsx}
  components/**/*.{tsx,jsx}
  styles/**/*.{css,scss}

Vue / Nuxt:
  src/components/**/*.vue
  src/views/**/*.vue
  src/pages/**/*.vue
  src/assets/**/*.{css,scss}

Svelte / SvelteKit:
  src/routes/**/*.svelte
  src/lib/components/**/*.svelte
  src/app.css

Astro:
  src/components/**/*.astro
  src/pages/**/*.astro
  src/styles/**/*.css

Angular:
  src/app/**/*.{ts,html,css,scss}

Fallback (unknown framework):
  src/**/*.{tsx,jsx,vue,svelte,astro}
  src/**/*.{css,scss,less}
  **/*.{css,scss} (excluding node_modules)
```

**Validate:** Glob each pattern, count matching files. Only include patterns with >0 matches.

**Output:** List of scope globs, total file count.

### Step 4: Page Discovery

Use Playwright to discover accessible pages:

```
1. Navigate to dev_server_url (root "/")
2. Take DOM snapshot
3. Extract all internal links:
   - <a href="/..."> links
   - <Link to="/..."> (React Router)
   - <NuxtLink to="/..."> (Nuxt)
   - Any href starting with "/" that isn't an asset
4. Deduplicate and filter:
   - Remove asset links (.js, .css, .png, .svg, etc.)
   - Remove API routes (/api/*)
   - Remove auth routes (/login, /signup, /logout) unless they're the only pages
   - Remove duplicate parameterized routes (keep /products, skip /products/123)
5. Navigate to each discovered page, verify it loads (non-error response)
```

**Output:** List of valid page URLs (typically 3-15 pages).

### Step 5: Baseline Scoring

For each discovered page, run a quick judge evaluation (desktop viewport only for speed):

```
FOR each page IN discovered_pages:
  1. Navigate to page
  2. Screenshot at 1440x900
  3. Quick judge: run UX Friction + Visual Polish only (skip Brand if no style guide)
  4. Compute quick composite
  5. Record: page_url, composite_score
```

**Sort pages by composite score ascending** — worst-scoring pages first.

### Step 6: Confirmation

Present auto-detected configuration to user with a SINGLE confirmation question:

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
Scope: src/components/**/*.tsx, src/app/**/*.tsx, src/styles/**/*.css (34 files)
Goal: Enterprise-grade UI polish (Stripe/Linear quality)
Design refs: context/design-principles.md (found), context/style-guide.md (found)

Will start with "/" (score: 5.2) and progress to higher-scoring pages.
```

Use `AskUserQuestion`:

| # | Header | Question | Options |
|---|--------|----------|---------|
| 1 | `Confirm` | "Auto-detected configuration above. How to proceed?" | "Start optimizing (unlimited)", "Start with iteration limit", "Start with specific page", "Edit configuration", "Cancel" |

If "Start with iteration limit": ask for N.
If "Start with specific page": show page list, let user pick.
If "Edit configuration": fall back to `/autoux:plan` with pre-filled values.

## Execution: Multi-Page Optimization Loop

Auto mode differs from standard `/autoux` in that it **progresses through pages** rather than focusing on one.

### Page Progression Strategy

```
1. Start with the LOWEST-scoring page
2. Run the standard autoux loop on that page
3. Progression trigger — move to next page when:
   a. Current page composite reaches 8.0+ (enterprise threshold), OR
   b. 5 consecutive discards on current page (diminishing returns), OR
   c. All soft scores >= 7 on current page
4. When moving to next page:
   a. Print page completion summary
   b. Re-score remaining pages (quick judge) — order may have changed
   c. Start loop on next lowest-scoring page
5. Done when:
   a. All pages reach 8.0+ composite, OR
   b. Bounded iterations exhausted, OR
   c. User interrupts
```

### Enterprise-Grade Goal Definition

The hardcoded goal for auto mode:

```
Goal: Transform this UI to enterprise-grade quality matching Stripe, Linear, and Vercel standards.

Focus areas (in priority order):
1. Fix any accessibility violations (hard gate failures)
2. Fix any layout/overflow issues (hard gate failures)
3. Establish consistent spacing rhythm (8px grid)
4. Refine typography hierarchy (clear heading > body > caption scale)
5. Improve color consistency and contrast
6. Polish interactive states (hover, focus, active)
7. Optimize whitespace usage (generous, intentional)
8. Ensure responsive adaptation (no mobile breakage)
9. Refine micro-details (shadows, borders, radius consistency)
10. Elevate overall "feel" to premium/professional
```

### Auto-Generated Design Refs

If `context/design-principles.md` and `context/style-guide.md` don't exist, auto mode uses the **built-in defaults** from the `context/` templates. The agent also scans the project for existing design tokens:

```
1. Scan for existing CSS custom properties (--color-*, --font-*, --spacing-*)
2. Scan tailwind.config.* for theme customizations
3. Scan for existing component patterns (button styles, card styles)
4. Use discovered tokens to build an implicit style guide
   → Agent respects existing design decisions rather than imposing new ones
```

This is critical — auto mode should **elevate the existing design**, not replace it with a generic one.

## Communication During Auto Mode

### Per-Iteration Output

Same as standard mode — one-line status:
```
Iteration 3 [/pricing]: KEEP — improved CTA contrast to 5.2:1 (composite: 6.8)
```

### Page Transition Output

```
=== Page Complete: /pricing ===
Started: 5.8 → Final: 8.2 (+2.4)
Iterations: 8 (5 keeps, 3 discards)
Moving to: /about (score: 6.1)
```

### Final Summary

```
=== AutoUX Auto Mode Complete ===
Pages optimized: 4/5

| Page | Before | After | Delta |
|------|--------|-------|-------|
| / | 5.2 | 8.4 | +3.2 |
| /pricing | 5.8 | 8.2 | +2.4 |
| /about | 6.1 | 8.1 | +2.0 |
| /dashboard | 6.5 | 8.0 | +1.5 |
| /settings | 7.0 | — | skipped (already near threshold) |

Total iterations: 32 (21 keeps, 10 discards, 1 crash)
Top remaining suggestion: "Settings page could benefit from consistent card styling"
```

## Edge Cases

### No package.json Found

```
Not a Node.js project. Looking for other frontend indicators...
- Check for index.html (static site)
- Check for *.html files (multi-page static)
- Check for Python/Ruby/PHP framework with templates

If static HTML found:
  Scope: **/*.html, **/*.css, **/*.js
  Dev server: python -m http.server 8000 (or npx serve .)
```

### No Pages Found (SPA)

```
Single-page app detected — only "/" available.
Will optimize the single page across all viewports.
```

### Too Many Pages (>20)

```
Found 47 pages. Limiting to top 10 lowest-scoring pages.
Run /autoux:auto --all to include all pages (not recommended — very long run).
```

### Existing High Scores

```
All pages already score 7.5+. Running in "polish mode" —
targeting 9.0+ on all dimensions for world-class quality.
```

## Flags

| Flag | Purpose |
|------|---------|
| `--page <url>` | Override page selection — optimize specific page only |
| `--all` | Include all discovered pages (not just top 10) |
| `--threshold <N>` | Page completion threshold (default: 8.0) |
| `--skip-confirm` | Skip confirmation prompt — start immediately |
| `--no-start-server` | Don't auto-start dev server |
| `Iterations: N` | Bounded total iterations across all pages |
