#!/bin/bash

# Default to the latest commit if no hash is provided
COMMIT_HASH_INPUT=${1:-HEAD}

# --- Helper Functions ---

# Function to get the current version from pubspec.yaml
get_current_version() {
  if [ ! -f pubspec.yaml ]; then
    echo "Error: pubspec.yaml not found in the current directory!" >&2
    exit 1
  fi
  grep '^version:' pubspec.yaml | sed 's/version:[[:space:]]*//'
}

# Function to update the version in pubspec.yaml
update_pubspec_version() {
  local new_full_version="$1" # e.g., "1.2.3" or "1.2.3+4"
  if [ ! -f pubspec.yaml ]; then
    echo "Error: pubspec.yaml not found!" >&2
    exit 1
  fi
  # This sed command robustly replaces the version line.
  # It matches "version:" at the beginning of a line, followed by optional spaces, and any characters,
  # and replaces it with "version: " followed by the new version string.
  sed -i.bak "s/^version:[[:space:]]*.*/version: $new_full_version/" pubspec.yaml
  if [ $? -eq 0 ]; then
    rm pubspec.yaml.bak # Remove backup file on success
    echo "✅ Version updated to $new_full_version in pubspec.yaml"
  else
    echo "❌ Error: Failed to update version in pubspec.yaml. A backup 'pubspec.yaml.bak' may have been created." >&2
  fi
}

# --- Main Script ---

# Check if we are in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "❌ Error: Not a git repository. Please run this script from the root of a git repository." >&2
  exit 1
fi

# Resolve HEAD to its actual commit hash if passed
if [[ "$COMMIT_HASH_INPUT" == "HEAD" ]]; then
  COMMIT_HASH=$(git rev-parse HEAD)
  if [ $? -ne 0 ]; then
    echo "❌ Error: Could not resolve HEAD to a commit hash." >&2
    exit 1
  fi
else
  COMMIT_HASH=$COMMIT_HASH_INPUT
fi

echo "🔍 Analyzing commit: $COMMIT_HASH"

# Verify commit hash exists
if ! git cat-file -e "$COMMIT_HASH" 2>/dev/null; then
    echo "❌ Error: Commit hash '$COMMIT_HASH' not found or is not a valid commit object." >&2
    exit 1
fi

# Get list of .dart files in the repository at the specified commit's tree
DART_FILES_IN_COMMIT_TREE_LIST=$(git ls-tree "$COMMIT_HASH" -r --name-only | grep "\.dart$")

TOTAL_PROJ_LINES=0
if [ -z "$DART_FILES_IN_COMMIT_TREE_LIST" ]; then
  echo "ℹ️ 'git ls-tree' found no '*.dart' files in the tree of commit $COMMIT_HASH."
  TOTAL_PROJ_LINES=0
else
  # Calculate total lines for these files by showing their content at that commit
  # Using a loop for clarity and to handle potential issues with xargs and many files, though xargs is often more performant.
  CURRENT_IFS="$IFS"
  IFS=$'\n' # Handle filenames with spaces correctly if any were to appear (ls-tree --name-only usually doesn't create them)
  for filepath in $DART_FILES_IN_COMMIT_TREE_LIST; do
    # git show $COMMIT_HASH:<path> gets the content of the file at that commit
    lines_in_file=$(git show "$COMMIT_HASH":"$filepath" 2>/dev/null | wc -l | awk '{print $1}')
    TOTAL_PROJ_LINES=$((TOTAL_PROJ_LINES + lines_in_file))
  done
  IFS="$CURRENT_IFS"
fi

EFFECTIVE_TOTAL_LINES_FOR_CALCULATION=$TOTAL_PROJ_LINES
if [ "$TOTAL_PROJ_LINES" -eq 0 ]; then
  echo "⚠️ Total lines in all '.dart' files in the tree of commit $COMMIT_HASH is 0."
  echo "   This means either no '*.dart' files were found by 'git ls-tree' for this commit, or all such files were empty."
  echo "   Debug: Output of 'git ls-tree -r --name-only \"$COMMIT_HASH\" -- \"*.dart\"':"
  if [ -z "$DART_FILES_IN_COMMIT_TREE_LIST" ]; then
    echo "     (No files listed)"
  else
    echo "$DART_FILES_IN_COMMIT_TREE_LIST" | sed 's/^/     /' # Indent output for readability
  fi
  EFFECTIVE_TOTAL_LINES_FOR_CALCULATION=1 # Avoid division by zero. If LINES_CHANGED > 0, this will result in a large percentage.
fi
echo "📊 Total .dart lines in project tree at $COMMIT_HASH: $TOTAL_PROJ_LINES"


# Get lines changed in .dart files IN the specified commit (compared to its parent)
# For the very first commit, $COMMIT_HASH^! will cause an error.
# We use $COMMIT_HASH for the first commit (show against empty tree) or $COMMIT_HASH^! for subsequent commits.
PARENT_COMMIT_EXISTS=$(git rev-parse --verify "$COMMIT_HASH^" 2>/dev/null)
DIFF_TARGET="$COMMIT_HASH" # For first commit
if [ -n "$PARENT_COMMIT_EXISTS" ]; then
    DIFF_TARGET="$COMMIT_HASH^!" # For subsequent commits, compare to parent(s)
fi

LINES_CHANGED_OUTPUT=$(git diff-tree --no-commit-id --numstat -r "$DIFF_TARGET" -- "*.dart")
LINES_CHANGED=0
if [ $? -ne 0 ] && [ -z "$PARENT_COMMIT_EXISTS" ]; then # diff-tree failed AND it's the first commit
    echo "🌱 First commit. Considering all .dart lines in this commit as changed."
    LINES_CHANGED=$TOTAL_PROJ_LINES # All lines in the project (at this commit) are new
elif [ -n "$LINES_CHANGED_OUTPUT" ]; then
    LINES_CHANGED=$(echo "$LINES_CHANGED_OUTPUT" | awk '{s+=$1; s+=$2} END {print s}')
else
    # No .dart files in the diff output, or diff-tree had an issue not related to first commit
    LINES_CHANGED=0
fi

echo "🔄 Lines changed (added+deleted) in .dart files by commit $COMMIT_HASH: $LINES_CHANGED"

# Calculate percentage changed
if [ "$EFFECTIVE_TOTAL_LINES_FOR_CALCULATION" -eq 0 ]; then # Should actually be 1 due to protection above
  PERCENT_CHANGED=0
elif [ "$LINES_CHANGED" -eq 0 ]; then
    PERCENT_CHANGED=0
else
  PERCENT_CHANGED=$(echo "scale=4; ($LINES_CHANGED / $EFFECTIVE_TOTAL_LINES_FOR_CALCULATION) * 100" | bc)
fi
echo "📈 Percentage of .dart lines changed: $PERCENT_CHANGED%"

# Get current version (e.g., 1.2.3 or 1.2.3+4)
CURRENT_VERSION_FULL=$(get_current_version)
if [ -z "$CURRENT_VERSION_FULL" ]; then
    echo "❌ Error: Could not retrieve current version from pubspec.yaml."
    exit 1
fi

# Extract only the MAJOR.MINOR.PATCH part
CURRENT_VERSION_SEMANTIC=$(echo "$CURRENT_VERSION_FULL" | sed 's/+.*//')
# Extract the build number part (e.g., +4) if it exists
BUILD_NUMBER_PART=$(echo "$CURRENT_VERSION_FULL" | grep -o '+[0-9]*' || echo "")


IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION_SEMANTIC"

if ! [[ "$MAJOR" =~ ^[0-9]+$ && "$MINOR" =~ ^[0-9]+$ && "$PATCH" =~ ^[0-9]+$ ]]; then
    echo "❌ Error: Could not parse current semantic version '$CURRENT_VERSION_SEMANTIC' into MAJOR.MINOR.PATCH numbers."
    echo "   Please ensure pubspec.yaml version is formatted correctly (e.g., 1.2.3 or 1.2.3+4)."
    exit 1
fi


echo "Current version: $MAJOR.$MINOR.$PATCH$BUILD_NUMBER_PART"

# Determine version bump type
BUMP_TYPE=""
NEW_MAJOR=$MAJOR
NEW_MINOR=$MINOR
NEW_PATCH=$PATCH

# bc needs integers for comparison with floating point results if not using -l for relational ops
# So we compare int(PERCENT_CHANGED) with thresholds, or use bc -l for float comparison
COMPARE_MAJOR=$(echo "$PERCENT_CHANGED >= 25" | bc -l)
COMPARE_MINOR=$(echo "$PERCENT_CHANGED >= 10" | bc -l)

if [ "$COMPARE_MAJOR" -eq 1 ]; then
  BUMP_TYPE="MAJOR"
  NEW_MAJOR=$((MAJOR + 1))
  NEW_MINOR=0
  NEW_PATCH=0
elif [ "$COMPARE_MINOR" -eq 1 ]; then
  BUMP_TYPE="MINOR"
  NEW_MINOR=$((MINOR + 1))
  NEW_PATCH=0
else
  BUMP_TYPE="PATCH"
  NEW_PATCH=$((PATCH + 1))
fi

NEW_VERSION_SEMANTIC="$NEW_MAJOR.$NEW_MINOR.$NEW_PATCH"
NEW_VERSION_FULL="$NEW_VERSION_SEMANTIC$BUILD_NUMBER_PART" # Keep original build number if present

echo "💡 Suggested bump type: $BUMP_TYPE"
echo "Proposed new version: $NEW_VERSION_FULL"

# Update pubspec.yaml with the new version
update_pubspec_version "$NEW_VERSION_FULL"
