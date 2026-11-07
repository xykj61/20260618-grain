#!/bin/sh
# bloom_demo_links_scan -- verify relative Markdown links in demo shelf resolve
# M57 integration witness for Quest 6

ROOT="${1:-.}"
DEMOS="$ROOT/bloom/demos"

tmpfile="/tmp/bloom_link_check_$$"
: > "$tmpfile"

for f in "$DEMOS"/*.md; do
  [ -f "$f" ] || continue
  dir=$(dirname "$f")
  # extract link targets: ](path.md) -> path.md
  grep -oE '\]\([^)]+\.md\)' "$f" 2>/dev/null | sed 's/^](//; s/)$//' | while read -r link; do
    # skip URLs
    case "$link" in
      http*) continue ;;
    esac
    target="$dir/$link"
    if [ ! -f "$target" ]; then
      echo "broken: $f -> $link" >> "$tmpfile"
    fi
  done
done

total=$(grep -roE '\]\([^)]+\.md\)' "$DEMOS"/*.md 2>/dev/null | wc -l | tr -d ' ')
broken=$(wc -l < "$tmpfile" | tr -d ' ')

if [ "$broken" -gt 0 ]; then
  cat "$tmpfile"
fi
rm -f "$tmpfile"

echo "checked=$total broken=$broken"
if [ "$broken" -gt 0 ]; then
  echo "verdict=RED"
  exit 1
else
  echo "verdict=GREEN"
fi
