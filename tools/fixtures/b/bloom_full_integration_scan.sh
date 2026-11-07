#!/bin/sh
# bloom_full_integration_scan.sh -- full integration witness for the
# Bloom educational ecosystem across all four acts.
#
# Checks: room existence, file counts, Bhakta declarations, ASCII
# cleanliness, relative link resolution, curriculum-to-demo cross-links,
# docs-geode cross-references, and terrarium lesson completeness.

set -e

ROOT="${ROOT:-$(git rev-parse --show-toplevel)}"
cd "$ROOT"

errors=0
err() { printf "  FAIL: %s\n" "$1"; errors=$((errors + 1)); }
ok()  { printf "  ok: %s\n" "$1"; }

echo "bloom_full_integration_scan"
echo "==========================="

# --- Act I: curriculum, ecology, lineage, guides, essays ---
echo ""
echo "Act I -- curriculum and ecology"

for room in curriculum ecology lineage guides essays; do
  dir="bloom/$room"
  if [ -d "$dir" ]; then
    count=$(find "$dir" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
    ok "$dir exists ($count files)"
  else
    err "$dir missing"
  fi
done

# curriculum must have 10 stages
stages=$(find bloom/curriculum -maxdepth 1 -name 'stage-*.md' | wc -l | tr -d ' ')
if [ "$stages" -eq 10 ]; then
  ok "curriculum has 10 stages"
else
  err "curriculum has $stages stages, expected 10"
fi

# --- Act II: terrarium lessons and demos ---
echo ""
echo "Act II -- terrarium lessons and demos"

tut_count=$(find bloom/terrarium-lessons -maxdepth 1 -name '*.md' ! -name 'README.md' | wc -l | tr -d ' ')
if [ "$tut_count" -ge 5 ]; then
  ok "terrarium-lessons has $tut_count tutorials"
else
  err "terrarium-lessons has $tut_count tutorials, expected >= 5"
fi

demo_count=$(find bloom/demos -maxdepth 1 -name '*.md' ! -name 'README.md' | wc -l | tr -d ' ')
if [ "$demo_count" -ge 9 ]; then
  ok "demos has $demo_count walkthroughs"
else
  err "demos has $demo_count walkthroughs, expected >= 9"
fi

# --- Bhakta style declarations ---
echo ""
echo "Style declarations"

bhakta_total=0
bhakta_declared=0
for f in $(find bloom -name '*.md' ! -path '*/assets/*'); do
  bhakta_total=$((bhakta_total + 1))
  if grep -qi 'Bhakta' "$f" 2>/dev/null; then
    bhakta_declared=$((bhakta_declared + 1))
  fi
done

if [ "$bhakta_declared" -eq "$bhakta_total" ]; then
  ok "all $bhakta_total Bloom pages declare Bhakta"
else
  err "$bhakta_declared of $bhakta_total Bloom pages declare Bhakta"
fi

# --- ASCII cleanliness ---
echo ""
echo "ASCII cleanliness"

non_ascii=0
for f in $(find bloom -name '*.md' ! -path '*/assets/*'); do
  chars=$(LC_ALL=C grep -cP '[\x80-\xFF]' "$f" 2>/dev/null || true)
  if [ "${chars:-0}" -gt 0 ]; then
    non_ascii=$((non_ascii + chars))
    err "$f has $chars non-ASCII characters"
  fi
done
if [ "$non_ascii" -eq 0 ]; then
  ok "all Bloom pages are ASCII-clean"
fi

# --- Relative link resolution ---
echo ""
echo "Link resolution"

broken_links=0
total_links=0
for f in $(find bloom -name '*.md' ! -path '*/assets/*'); do
  dir_of=$(dirname "$f")
  targets=$(grep -oE '\]\([^)]+\.md\)' "$f" 2>/dev/null | sed 's/\](//' | sed 's/)//' || true)
  for t in $targets; do
    total_links=$((total_links + 1))
    resolved="$dir_of/$t"
    if [ ! -f "$resolved" ]; then
      broken_links=$((broken_links + 1))
      err "broken link in $f -> $t"
    fi
  done
done

if [ "$broken_links" -eq 0 ]; then
  ok "$total_links links checked, 0 broken"
else
  err "$broken_links of $total_links links broken"
fi

# --- Act IV: docs-geode cross-references ---
echo ""
echo "Act IV -- docs-geode cross-references"

if grep -q 'Related Bloom' docs-geode/lessons/README.md 2>/dev/null; then
  ok "docs-geode lessons README has Related Bloom section"
else
  err "docs-geode lessons README missing Related Bloom section"
fi

# check that bloom links in docs-geode resolve
dg_broken=0
dg_total=0
targets=$(grep -oE '\]\([^)]*bloom[^)]*\.md\)' docs-geode/lessons/README.md 2>/dev/null | sed 's/\](//' | sed 's/)//' || true)
for t in $targets; do
  dg_total=$((dg_total + 1))
  resolved="docs-geode/lessons/$t"
  if [ ! -f "$resolved" ]; then
    dg_broken=$((dg_broken + 1))
    err "broken bloom link in docs-geode -> $t"
  fi
done
if [ "$dg_broken" -eq 0 ]; then
  ok "$dg_total docs-geode bloom links checked, 0 broken"
fi

# --- Summary ---
echo ""
echo "==========================="
if [ "$errors" -eq 0 ]; then
  echo "verdict=ok  errors=0"
else
  echo "verdict=fail  errors=$errors"
fi
