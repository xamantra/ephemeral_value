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
  sed -i'' -e "s/^version: .*/version: $VERSION/" pubspec.yaml
else
  echo "version: $VERSION" >> pubspec.yaml
fi

# Update CHANGELOG.md
# Prepare the changelog entry
CHANGELOG_FILE="CHANGELOG.md"
entry="## $VERSION

- $DESCRIPTION
"

# Insert the new entry after the first line (if CHANGELOG starts with a comment) or at the top
if grep -q '^<!--' "$CHANGELOG_FILE"; then
  # Insert after the comment block
  awk -v entry="$entry" 'NR==2{print entry}1' "$CHANGELOG_FILE" > "$CHANGELOG_FILE.tmp" && mv "$CHANGELOG_FILE.tmp" "$CHANGELOG_FILE"
else
  # Prepend to the file
  printf "%s\n%s" "$entry" "$(cat "$CHANGELOG_FILE")" > "$CHANGELOG_FILE"
fi

echo "CHANGELOG.md updated with version $VERSION."

# Commit changes if there are any
if ! git diff --cached --quiet || ! git diff --quiet; then
  git add pubspec.yaml CHANGELOG.md
  git commit -m "chore: release v$VERSION – $DESCRIPTION"
fi

# Create git tag (force if exists)
git tag -f "v$VERSION"

echo "Updated to version $VERSION with description: $DESCRIPTION"