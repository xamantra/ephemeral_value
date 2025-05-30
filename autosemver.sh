#!/bin/bash

# --- Configuration ---
PUBSPEC_FILE="pubspec.yaml"
DART_FILES_PATTERN="*.dart"

# --- Helper Functions ---

# Function to get the current version from pubspec.yaml
get_current_version() {
  grep '^version:' "$PUBSPEC_FILE" | awk '{print $2}'
}

# Function to update the version in pubspec.yaml
update_pubspec_version() {
  local new_version="$1"
  # Use sed to update the version. Handles both macOS and Linux sed.
  if sed --version >/dev/null 2>&1; then # GNU sed
    sed -i "s/^version: .*/version: $new_version/" "$PUBSPEC_FILE"
  else # macOS sed
    sed -i '' "s/^version: .*/version: $new_version/" "$PUBSPEC_FILE"
  fi
  echo "✅ Version updated to $new_version in $PUBSPEC_FILE"
}

# Function to count total lines in specified files
count_total_lines() {
  local total_lines=0
  while IFS= read -r file; do
    if [ -f "$file" ]; then
        lines_in_file=$(wc -l < "$file")
        total_lines=$((total_lines + lines_in_file))
    fi
  done < <(find . -type f -name "$DART_FILES_PATTERN" ! -path "./.git/*" ! -path "./build/*")
  echo "$total_lines"
}

# Function to count changed lines in .dart files in the latest commit
count_changed_lines() {
  local changed_lines=0
  git diff --numstat HEAD~1 HEAD -- $DART_FILES_PATTERN | awk '{s+=$1+$2} END {print s}'
}

# --- Main Script ---

echo "🔍 Analyzing changes for version update..."

# 1. Get current version
current_version=$(get_current_version)
if [ -z "$current_version" ]; then
  echo "❌ Error: Could not find 'version:' in $PUBSPEC_FILE."
  exit 1
fi
echo "  Current version: $current_version"

# 2. Calculate TOTAL_PROJ_LINES
total_proj_lines=$(count_total_lines)
if [ "$total_proj_lines" -eq 0 ]; then
  echo "⚠️ Warning: No .dart files found or all .dart files are empty. Cannot calculate version change."
  exit 0
fi
echo "  Total lines in *.dart files (TOTAL_PROJ_LINES): $total_proj_lines"

# 3. Calculate LINES_CHANGED
lines_changed=$(count_changed_lines)
if [ -z "$lines_changed" ]; then
    lines_changed=0
fi
echo "  Lines changed in *.dart files in the latest commit (LINES_CHANGED): $lines_changed"

if [ "$lines_changed" -eq 0 ]; then
  echo "ℹ️ No *.dart file changes detected in the latest commit. No version update needed."
  exit 0
fi

# 4. Calculate the ratio and percentage
# bc is used for floating point arithmetic
# Calculate ratio with more precision for comparisons
ratio_decimal=$(echo "scale=6; $lines_changed / $total_proj_lines" | bc)
# Calculate percentage for display, rounded to 2 decimal places by bc itself
percentage=$(echo "scale=2; ($lines_changed * 100) / $total_proj_lines" | bc)

# Using printf for formatted output. Note: %% prints a literal %
printf "  Change ratio (LINES_CHANGED / TOTAL_PROJ_LINES): %.2f%%\n" "$percentage"

# For logical comparisons, we use the original decimal ratio
ratio_for_comparison="$ratio_decimal"

# 5. Determine version increment based on the ratio
IFS='.' read -r major minor patch <<< "$current_version"
new_major=$major
new_minor=$minor
new_patch=$patch

update_type=""

# Use bc for floating point comparisons with ratio_for_comparison
if (( $(echo "$ratio_for_comparison >= 0.25" | bc -l) )); then
  new_major=$((major + 1))
  new_minor=0
  new_patch=0
  update_type="MAJOR"
elif (( $(echo "$ratio_for_comparison >= 0.10" | bc -l) )); then
  new_minor=$((minor + 1))
  new_patch=0
  update_type="MINOR"
elif (( $(echo "$ratio_for_comparison > 0 && $ratio_for_comparison < 0.10" | bc -l) )); then
  new_patch=$((patch + 1))
  update_type="PATCH"
elif (( $(echo "$ratio_for_comparison == 0.10" | bc -l) )); then
  new_patch=$((patch + 1))
  update_type="PATCH"
else # ratio is 0 (already handled) or something unexpected below smallest threshold but > 0
    # This case might be redundant due to "lines_changed == 0" check,
    # but included for completeness if logic changes
  echo "ℹ️ Change ratio ($percentage%) does not meet criteria for PATCH, MINOR, or MAJOR update. No version change."
  exit 0
fi

new_version="$new_major.$new_minor.$new_patch"

if [ "$new_version" == "$current_version" ]; then
    echo "ℹ️ Calculated new version ($new_version) is the same as current. No update needed."
    exit 0
fi

echo "  📈 Version update type: $update_type"
echo "  New version will be: $new_version"

echo "NEW_VERSION=$new_version" >> "$GITHUB_ENV"

# 7. Update pubspec.yaml
read -p "Do you want to update $PUBSPEC_FILE to version $new_version? (y/N): " confirm
if [[ "$confirm" =~ ^[yY](es)?$ ]]; then
  update_pubspec_version "$new_version"
else
  echo "🚫 Version update aborted by user."
fi

exit 0