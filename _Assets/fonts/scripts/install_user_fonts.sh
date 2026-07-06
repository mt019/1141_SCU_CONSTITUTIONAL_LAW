#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FONT_DIR="$PACK_DIR/fonts"
CATEGORY_DIR="$PACK_DIR/categories"
DEST_DIR="$HOME/Library/Fonts"

if [[ ! -d "$FONT_DIR" ]]; then
  echo "Font directory not found: $FONT_DIR" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

installed=0
while IFS= read -r font; do
  base="$(basename "$font")"
  dest="$DEST_DIR/SCUQuoteCards-$base"
  cp -f "$font" "$dest"
  installed=$((installed + 1))
  printf 'installed %s\n' "$dest"
done < <(
  {
    find "$FONT_DIR" -maxdepth 1 -type f \( -name '*.ttf' -o -name '*.otf' -o -name '*.ttc' \)
    if [[ -d "$CATEGORY_DIR" ]]; then
      find "$CATEGORY_DIR" -type f \( -name '*.ttf' -o -name '*.otf' -o -name '*.ttc' \)
    fi
  } | sort -u
)

if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$DEST_DIR" >/dev/null 2>&1 || true
fi

printf '\nInstalled %d fonts into %s\n' "$installed" "$DEST_DIR"
printf 'If an app was already open, restart it before choosing these fonts.\n'
