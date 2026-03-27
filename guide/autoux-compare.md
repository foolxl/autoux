# /autoux:compare — A/B Design Comparison

Compare two design states side-by-side using the full judge panel. Useful for evaluating branches, before/after states, or choosing between approaches.

## Usage

```
/autoux:compare
Page: http://localhost:3000
Branch-A: main
Branch-B: feature/new-checkout

/autoux:compare Page: http://localhost:3000 Commit-A: abc1234 Commit-B: def5678
```

## What It Does

1. Captures screenshots of State A (branch or commit)
2. Captures screenshots of State B
3. Runs the judge panel on both states
4. Produces side-by-side comparison with score deltas
5. Recommends which state is better and why
6. Restores your original git state

## When to Use

- **Choosing between design approaches** — Which branch looks better?
- **Before/after validation** — Did the optimization actually improve things?
- **PR review** — Compare feature branch against main
- **Rollback decision** — Is the new version actually better?

## Output

```
| Dimension        | State A | State B | Delta | Winner |
|------------------|---------|---------|-------|--------|
| UX Friction      | 5       | 7       | +2    | B      |
| Visual Polish    | 6       | 8       | +2    | B      |
| Brand Alignment  | 7       | 6       | -1    | A      |
| **Composite**    | **5.85**| **7.05**| **+1.20** | **B** |
```

Includes per-viewport breakdown and specific critiques for each state.

## Comparing Current Work

Use `"current"` as a state to compare your working tree:

```
/autoux:compare
Page: http://localhost:3000
Branch-A: main
Branch-B: current
```
