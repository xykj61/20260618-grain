#!/bin/sh
# tools/fixtures/d/docs_geode_teacher_scan.sh -- every docs-geode page declares Teacher at Door.
#
#   sh tools/fixtures/d/docs_geode_teacher_scan.sh
#   sh tools/fixtures/d/docs_geode_teacher_scan.sh /path/to/a/pen
#
# A miss is a Markdown file whose first **Style:** line omits Teacher, omits Door,
# or names Gauge as the register. A file with no style line is a miss too.
set -eu

root=${1:-docs-geode}
[ -d "$root" ] || { echo "docs-geode-teacher: missing $root"; exit 2; }

pages=0
miss=0
find "$root" -type f -name '*.md' | sort | while IFS= read -r f; do
  style=$(awk 'index($0, "**Style:**") { print; exit }' "$f")
  reason=
  if [ -z "$style" ]; then
    reason=no_style_line
  elif printf '%s\n' "$style" | grep -q 'Gauge'; then
    reason=style_names_gauge
  elif ! printf '%s\n' "$style" | grep -q 'Teacher'; then
    reason=style_omits_teacher
  elif ! printf '%s\n' "$style" | grep -q 'Door'; then
    reason=style_omits_door
  fi
  if [ -n "$reason" ]; then
    printf 'miss %s %s\n' "$f" "$reason"
  fi
done > "${TMPDIR:-/tmp}/docs-geode-teacher.$$"
pages=$(find "$root" -type f -name '*.md' | wc -l | tr -d ' ')
miss=$(grep -c '^miss ' "${TMPDIR:-/tmp}/docs-geode-teacher.$$" || true)
cat "${TMPDIR:-/tmp}/docs-geode-teacher.$$"
rm -f "${TMPDIR:-/tmp}/docs-geode-teacher.$$"
echo "pages=$pages miss=$miss"
if [ "$miss" = 0 ] && [ "$pages" -gt 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=miss"
  exit 1
fi
