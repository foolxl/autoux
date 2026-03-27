# Results Logging — Persistent History & Iteration Archives

AutoUX maintains a **persistent plain-text history** that survives across sessions, plus per-iteration **file snapshots** and **judgment archives**.

## Where Files Live

All history and archive files are created in the **user's project directory** (the project being optimized), NOT in the autoux plugin repo.

```
user-project/                     ← the project being optimized
  autoux-history.md               ← persistent history (recommend: commit to project repo)
  autoux-results.tsv              ← machine-readable log (recommend: commit to project repo)
  autoux/iterations/              ← file snapshots per iteration (recommend: commit to project repo)
  autoux-svg-preview.html         ← temporary render wrapper (gitignore this)
```

The user should decide whether to commit these to their project's repo. We recommend committing `autoux-history.md` and `autoux/iterations/` for full traceability.

## Persistent History File

**File:** `autoux-history.md` (user's project root)

This is the single source of truth across all sessions and runs. When you exit and continue later, the agent reads this file to resume where it left off.

### Format

```markdown
# AutoUX History

## Run: 2026-03-27 14:30 — hero-polish
- **Goal:** Improve hero section visual polish
- **Scope:** src/components/hero/**/*.tsx, src/styles/hero.css
- **Page:** http://localhost:3000
- **Baseline:** composite 4.90 (UX:5 Polish:4 Brand:6)

| # | Commit | Gates | UX | Polish | Brand | Comp | Verdict | What Changed | Why |
|---|--------|-------|-----|--------|-------|------|---------|-------------|-----|
| 0 | a1b2c3d | PPP | 5 | 4 | 6 | 4.90 | baseline | — | initial state |
| 1 | b2c3d4e | PPP | 6 | 6 | 6 | 6.00 | keep | increased section spacing to 64px | spacing was inconsistent |
| 2 | — | FPP | — | — | — | — | discard | darkened CTA background | a11y gate: contrast 3.2:1 |
| 3 | c3d4e5f | PPP | 7 | 7 | 7 | 7.00 | keep | fixed CTA contrast to 5.2:1 | previous contrast too low |

**Status:** completed (7/10 iterations) | Final: 7.75 | Best: #7

---

## Run: 2026-03-28 09:15 — checkout-mobile (continued from previous)
- **Goal:** Fix mobile checkout issues
- **Scope:** src/components/checkout/**/*.tsx
- **Page:** http://localhost:3000/checkout
- **Baseline:** composite 6.20 (UX:6 Polish:6 Brand:7)
- **Resumed from:** iteration 7 of hero-polish run

| # | Commit | Gates | UX | Polish | Brand | Comp | Verdict | What Changed | Why |
|---|--------|-------|-----|--------|-------|------|---------|-------------|-----|
| 0 | d4e5f6g | PPP | 6 | 6 | 7 | 6.20 | baseline | — | initial state |
...

**Status:** in-progress (iteration 5)
```

### Key Properties

1. **Plain text Markdown** — readable in any editor, renders nicely on GitHub
2. **Appended, never overwritten** — each run adds a new section at the bottom
3. **NOT gitignored** — committed to the repo so history persists across clones/machines
4. **Human-editable** — user can add notes, mark favorites, delete bad runs
5. **Gates column** — P=pass, F=fail, condensed (e.g., "PPP" = all pass, "FPP" = a11y fail)
6. **Two description columns** — "What Changed" (the code change) AND "Why" (the judge critique)

### Resume Protocol

When starting a new run, the agent MUST:

1. **Check if `autoux-history.md` exists**
2. If yes — read the last run section:
   - Check `**Status:**` line — if `in-progress`, offer to resume
   - Read the last few rows to get current baseline scores
   - Read the last iteration number to continue numbering
3. If no — create a new `autoux-history.md` with header

### Resume vs New Run

```
IF autoux-history.md exists AND last run status == "in-progress":
    Ask user: "Found in-progress run '{slug}' at iteration {N}. Resume or start fresh?"
    - Resume → continue numbering, same baseline, append to same section
    - Fresh → add new "---" separator and new run section

IF autoux-history.md exists AND last run status == "completed":
    Start new run section (append after "---" separator)

IF autoux-history.md does not exist:
    Create new file with header
```

## Iteration File Archives

**Directory:** `autoux/iterations/` (project root, **NOT gitignored**)

Every iteration saves a snapshot of the modified files, enabling full rollback and comparison.

### Archive Structure

```
autoux/iterations/
  iter-000-baseline/
    snapshot/                    # Copy of in-scope files at baseline
    judgment.json                # Full judge verdict
  iter-001-keep/
    snapshot/                    # Copy of modified files after this iteration
    judgment.json
    diff.patch                   # git diff of this iteration's change
  iter-002-discard/
    snapshot/                    # Copy of modified files (before revert)
    judgment.json
    diff.patch
  iter-003-keep/
    ...
```

### What Gets Archived Per Iteration

```
1. snapshot/ — Copy of ALL in-scope files at this iteration's state
   - For UI: cp src/components/hero/*.tsx autoux/iterations/iter-{N}-{verdict}/snapshot/
   - For SVG: cp output.svg autoux/iterations/iter-{N}-{verdict}/snapshot/

2. judgment.json — The full verdict JSON from the @ux-judge or @svg-judge subagent

3. diff.patch — The git diff for this iteration's change:
   git diff HEAD~1 > autoux/iterations/iter-{N}-{verdict}/diff.patch
   (Only for iterations that had a commit, not for no-op/crash)
```

### Why Archive Files (Not Just Git)?

- **Git revert destroys the discarded code** — but the archive preserves it
- **Easy comparison** — diff any two iterations directly without git checkout
- **Survives branch changes** — archives stay even if git history is rebased
- **Human browsable** — open any snapshot folder to see exactly what the code looked like

## TSV Log (Machine-Readable Companion)

**File:** `autoux-results.tsv` (project root, appended across sessions)

Same format as before, but now **persistent** (not gitignored):

```tsv
run	iteration	commit	a11y_gate	layout_gate	console_gate	ux_friction	visual_polish	brand_align	composite	verdict	change	critique
hero-polish	0	a1b2c3d	pass	pass	pass	5	4	6	4.90	baseline	—	initial state
hero-polish	1	b2c3d4e	pass	pass	pass	6	6	6	6.00	keep	increased spacing to 64px	spacing was inconsistent
hero-polish	2	-	fail	pass	pass	-	-	-	-	discard	darkened CTA background	a11y gate: contrast 3.2:1
```

Changes from previous version:
- Added `run` column (slug) — groups iterations by run
- Added `change` column — what code was modified (separate from critique)
- **NOT gitignored** — persists across sessions
- **Appended** across runs — one file for all history

## Writing Protocol

After EVERY iteration's decide phase, the agent MUST:

```
1. Append row to autoux-results.tsv
2. Append row to autoux-history.md (in the current run's table)
3. Create iteration archive directory:
   mkdir -p autoux/iterations/iter-{NNN}-{verdict}/snapshot
4. Copy in-scope files to snapshot/:
   cp {each in-scope file} autoux/iterations/iter-{NNN}-{verdict}/snapshot/
5. Save judgment JSON:
   Write verdict JSON to autoux/iterations/iter-{NNN}-{verdict}/judgment.json
6. Save diff patch (if commit exists):
   git diff HEAD~1 > autoux/iterations/iter-{NNN}-{verdict}/diff.patch
7. Update Status line in autoux-history.md:
   **Status:** in-progress (iteration {N})
```

**CRITICAL: Steps 1-6 happen EVERY iteration, including discards. Never skip archiving.**

## Reading Protocol (Phase 1: Review)

At the start of every iteration:

```
1. Read autoux-history.md — get current run context, last 10 entries
2. Read autoux-results.tsv — scan for patterns (consecutive discards, trending scores)
3. Read autoux/iterations/iter-{last}-*/judgment.json — get detailed critique
4. These three sources together provide:
   - What was tried (history table)
   - What worked/failed (TSV patterns)
   - Why it worked/failed (judgment critique)
   - What to try next (next_suggestion)
```

## Final Summary

When a run completes (bounded iterations reached, or user interrupts):

1. Update `**Status:**` line in autoux-history.md:
   ```
   **Status:** completed (10/10 iterations) | Final: 7.75 | Best: #7
   ```

2. Print summary to console (same as before)

3. The history file and iteration archives remain for future reference
