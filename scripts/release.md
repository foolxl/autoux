# Release Process

## Version Locations

Version must be updated in **4 places** (the release script handles this automatically):

1. `.claude-plugin/marketplace.json` — root `version` + `plugins[0].version`
2. `claude-plugin/.claude-plugin/plugin.json` — `version`
3. `.claude/skills/autoux/SKILL.md` — frontmatter `version`
4. `claude-plugin/skills/autoux/SKILL.md` — frontmatter `version` (synced from .claude/)

## How to Release

```bash
# 1. Make sure you're on main with clean working tree
git checkout main
git pull

# 2. Run the release script
./scripts/release.sh 1.1.0

# 3. Push
git push && git push --tags

# 4. Create GitHub release
gh release create v1.1.0 --title "v1.1.0" --generate-notes
```

## What the Release Script Does

1. Validates semver format
2. Bumps version in all 4 locations
3. Syncs `.claude/` → `claude-plugin/` (distribution)
4. Verifies all versions match
5. Commits with release message
6. Creates git tag

## Development Workflow

1. Edit files in `.claude/` (development source)
2. Test by running commands in a frontend project
3. When ready to release, run the release script
4. The script syncs to `claude-plugin/` automatically

Never edit `claude-plugin/` directly — it's a distribution copy.
