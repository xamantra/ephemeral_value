#!/bin/bash

PUBSPEC_FILE="pubspec.yaml"
CHANGELOG_FILE="CHANGELOG.md"

# Parse optional commit hash argument
commit_hash="${1:-}"

# Get the current version from pubspec.yaml
version=$(grep '^version:' "$PUBSPEC_FILE" | awk '{print $2}')

# Get the commit message for the specified commit or latest
if [ -n "$commit_hash" ]; then
  commit_msg=$(git log -1 --pretty=%B "$commit_hash" | sed ':a;N;$!ba;s/\n/ /g')
else
  commit_msg=$(git log -1 --pretty=%B | sed ':a;N;$!ba;s/\n/ /g')
fi

# Check if this version already exists in the changelog
if grep -q "## $version" "$CHANGELOG_FILE"; then
  echo "Version $version already exists in $CHANGELOG_FILE. No update made."
  exit 0
fi

# Prepare the changelog entry
entry="## $version

- $commit_msg
"

# Insert the new entry after the first line (if CHANGELOG starts with a comment) or at the top
if grep -q '^<!--' "$CHANGELOG_FILE"; then
  # Insert after the comment block
  awk -v entry="$entry" 'NR==2{print entry}1' "$CHANGELOG_FILE" > "$CHANGELOG_FILE.tmp" && mv "$CHANGELOG_FILE.tmp" "$CHANGELOG_FILE"
else
  # Prepend to the file
  printf "%s\n%s" "$entry" "$(cat "$CHANGELOG_FILE")" > "$CHANGELOG_FILE"
fi

echo "CHANGELOG.md updated with version $version."