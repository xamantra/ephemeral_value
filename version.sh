#!/usr/bin/env bash
# filepath: d:\projects\ephemeral_value\version.sh

set -e

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <version> <description>"
  exit 1
fi

VERSION="$1"
DESCRIPTION="$2"

# Update pubspec.yaml version
if grep -q "^version:" pubspec.yaml; then
  # Use portable sed for in-place edit (works on GNU and BSD)
  sed -i'' -e "s/^version: .*/version: $VERSION/" pubspec.yaml
else
  echo "version: $VERSION" >> pubspec.yaml
fi

# Update CHANGELOG.md
DATE=$(date +"%Y-%m-%d")
CHANGELOG="CHANGELOG.md"
if [ ! -f "$CHANGELOG" ]; then
  echo "# Changelog" > "$CHANGELOG"
fi

# Insert new version at the top after the title
awk -v ver="$VERSION" -v desc="$DESCRIPTION" -v date="$DATE" '
  NR==1 { print; print ""; print "## " ver " - " date; print "- " desc; next }
  NR>1 { print }
' "$CHANGELOG" > "$CHANGELOG.tmp" && mv "$CHANGELOG.tmp" "$CHANGELOG"

# Commit changes if there are any
if ! git diff --cached --quiet || ! git diff --quiet; then
  git add pubspec.yaml CHANGELOG.md
  git commit -m "chore: release v$VERSION – $DESCRIPTION"
fi

# Create git tag (force if exists)
git tag -f "v$VERSION"

echo "Updated to version $VERSION with description: $DESCRIPTION"