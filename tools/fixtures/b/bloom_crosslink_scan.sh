#!/bin/sh
# bloom_crosslink_scan -- verify curriculum-to-demo cross-links resolve
# M58 integration witness for Quest 6

ROOT="${1:-.}"
CURRICULUM="$ROOT/bloom/curriculum"

tmpfile="/tmp/bloom_crosslink_$$"
: > "$tmpfile"

for f in "$CURRICULUM"/*.md; do
  [ -f "$f" ] || continue
  dir=$(dirname "$f")
  grep -oE '\]\([^)]+\.md\)' "$f" 2>/dev/null | sed 's/^](//; s/)$//' | while read -r link; do
    case "$link" in
      http*) continue ;;
    esac
    target="$dir/$link"
    if [ ! -f "$target" ]; then
      echo "broken: $f -> $link" >> "$tmpfile"
    fi
  done
done

total=$(grep -roE '\]\([^)]+\.md\)' "$CURRICULUM"/*.md 2>/dev/null | wc -l | tr -d ' ')
broken=$(wc -l < "$tmpfile" | tr -d ' ')

[ "$broken" -gt 0 ] && cat "$tmpfile"
rm -f "$tmpfile"

echo "checked=$total broken=$broken"
if [ "$broken" -gt 0 ]; then
  echo "verdict=RED"
  exit 1
else
  echo "verdict=GREEN"
fi
