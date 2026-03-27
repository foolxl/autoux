#!/usr/bin/env bash
set -euo pipefail

# AutoUX Release Script
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh 1.1.0

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
  echo "Usage: ./scripts/release.sh <version>"
  echo "Example: ./scripts/release.sh 1.1.0"
  exit 1
fi

# Validate semver format
if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "Error: Version must be semver format (e.g., 1.2.3)"
  exit 1
fi

# Get current version from marketplace.json
CURRENT=$(grep -m1 '"version"' .claude-plugin/marketplace.json | grep -oP '\d+\.\d+\.\d+')
echo "Current version: $CURRENT"
echo "New version:     $VERSION"
echo ""

# Confirm
read -p "Proceed with release v$VERSION? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "=== Step 1: Bump versions ==="

# 1. marketplace.json (has version in 2 places: root + plugins array)
sed -i "s/\"version\": \"$CURRENT\"/\"version\": \"$VERSION\"/g" .claude-plugin/marketplace.json
echo "  Updated .claude-plugin/marketplace.json"

# 2. plugin.json
sed -i "s/\"version\": \"$CURRENT\"/\"version\": \"$VERSION\"/g" claude-plugin/.claude-plugin/plugin.json
echo "  Updated claude-plugin/.claude-plugin/plugin.json"

# 3. SKILL.md (development)
sed -i "s/^version: $CURRENT/version: $VERSION/" .claude/skills/autoux/SKILL.md
echo "  Updated .claude/skills/autoux/SKILL.md"

echo ""
echo "=== Step 2: Sync .claude/ → claude-plugin/ ==="

# Sync commands
cp .claude/commands/autoux.md claude-plugin/commands/autoux.md
cp .claude/commands/autoux/*.md claude-plugin/commands/autoux/
echo "  Synced commands/"

# Sync skills
cp .claude/skills/autoux/SKILL.md claude-plugin/skills/autoux/SKILL.md
cp .claude/skills/autoux/references/*.md claude-plugin/skills/autoux/references/
echo "  Synced skills/"

echo ""
echo "=== Step 3: Verify ==="

# Check all versions match
V1=$(grep -m1 '"version"' .claude-plugin/marketplace.json | grep -oP '\d+\.\d+\.\d+')
V2=$(grep -m1 '"version"' claude-plugin/.claude-plugin/plugin.json | grep -oP '\d+\.\d+\.\d+')
V3=$(grep -m1 'version:' .claude/skills/autoux/SKILL.md | grep -oP '\d+\.\d+\.\d+')
V4=$(grep -m1 'version:' claude-plugin/skills/autoux/SKILL.md | grep -oP '\d+\.\d+\.\d+')

if [ "$V1" = "$VERSION" ] && [ "$V2" = "$VERSION" ] && [ "$V3" = "$VERSION" ] && [ "$V4" = "$VERSION" ]; then
  echo "  All 4 version locations match: $VERSION"
else
  echo "  ERROR: Version mismatch!"
  echo "    marketplace.json:          $V1"
  echo "    plugin.json:               $V2"
  echo "    .claude SKILL.md:          $V3"
  echo "    claude-plugin SKILL.md:    $V4"
  exit 1
fi

echo ""
echo "=== Step 4: Git ==="

git add -A
git commit -m "$(cat <<EOF
release: v$VERSION

Bumped version $CURRENT → $VERSION across all locations.
Synced .claude/ → claude-plugin/ distribution.

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
EOF
)"
echo "  Committed"

git tag "v$VERSION"
echo "  Tagged v$VERSION"

echo ""
echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  git push && git push --tags"
echo "  gh release create v$VERSION --title \"v$VERSION\" --generate-notes"
echo ""
