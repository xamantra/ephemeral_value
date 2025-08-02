#!/usr/bin/env bash
# filepath: d:\projects\ephemeral_value\version.sh

# =============================================================================
# Version Management Script
# =============================================================================
# 
# This script automates the version release process for the ephemeral_value
# Dart package. It performs the following operations:
#
# 1. Updates the version number in pubspec.yaml
# 2. Adds a new changelog entry to CHANGELOG.md
# 3. Commits the changes with a descriptive message
# 4. Creates a git tag for the new version
#
# Usage: ./version.sh <version> <description>
# Example: ./version.sh 1.2.3 "Add new feature for value tracking"
#
# The script expects two arguments:
# - version: The new version number (e.g., 1.2.3)
# - description: A brief description of the changes in this version
#
# The script will:
# - Replace the version line in pubspec.yaml or add it if missing
# - Insert a new changelog entry at the top of CHANGELOG.md
# - Commit changes with message: "chore: release v<version> – <description>"
# - Create/update a git tag: v<version>
# =============================================================================

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