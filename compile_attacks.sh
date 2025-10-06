
#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/charlesmorisset/known-cyber-attacks.git"
REPO_DIR="known-cyber-attacks"
OUTPUT="Compile.md"

if [ ! -d "$REPO_DIR" ]; then
  git clone "$REPO_URL"
else
  echo "$REPO_DIR already exists — pulling latest changes."
  (cd "$REPO_DIR" && git pull --ff-only) || true
fi

echo "# Compiled list of known cyber attacks" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "_Generated from $REPO_URL on $(date -u +"%Y-%m-%d %H:%M UTC")_" >> "$OUTPUT"
echo "" >> "$OUTPUT"

find "$REPO_DIR" -maxdepth 2 -type f -name "README.md" | while read -r file; do
  if [ "$(realpath "$file")" = "$(realpath "$REPO_DIR/README.md")" ]; then
    continue
  fi
  case "$file" in
    */Template/*|*/Template|*/template/*) continue ;;
  esac
  folder=$(basename "$(dirname "$file")")
  echo "## $folder" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  cat "$file" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  echo "---" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
done

echo "Done. Compiled file: $OUTPUT"

