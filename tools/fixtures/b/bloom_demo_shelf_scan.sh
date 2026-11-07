#!/bin/sh
# bloom_demo_shelf_scan -- verify the demo shelf is navigable and well-formed
# M56 integration witness for Quest 6

set -e

ROOT="${1:-.}"
DEMOS="$ROOT/bloom/demos"
TUTORIALS="$ROOT/docs-geode/tutorials"
CURRICULUM="$ROOT/bloom/curriculum"

errors=0
demos_count=0
tutorials_count=0
bhakta_ok=0
bhakta_miss=0
ascii_dirty=0

# -- Demo shelf --
for f in "$DEMOS"/*.md; do
  [ -f "$f" ] || continue
  demos_count=$((demos_count + 1))
  if grep -q 'Bhakta' "$f"; then
    bhakta_ok=$((bhakta_ok + 1))
  else
    bhakta_miss=$((bhakta_miss + 1))
    echo "miss bhakta: $f"
  fi
  if LC_ALL=C grep -cP '[\x80-\xff]' "$f" >/dev/null 2>&1; then
    dirty=$(LC_ALL=C grep -cP '[\x80-\xff]' "$f" 2>/dev/null || true)
    if [ "$dirty" -gt 0 ] 2>/dev/null; then
      ascii_dirty=$((ascii_dirty + 1))
      echo "ascii dirty: $f ($dirty bytes)"
    fi
  fi
done

# -- Bloom tutorials in docs-geode --
bloom_tutorials="bloom-curriculum-guide.md bloom-ecology-and-essays.md bloom-demos-in-terrarium.md reading-network-demos.md understanding-placeholder-galaxies.md"
for t in $bloom_tutorials; do
  if [ -f "$TUTORIALS/$t" ]; then
    tutorials_count=$((tutorials_count + 1))
    if ! grep -q 'Bhakta' "$TUTORIALS/$t"; then
      bhakta_miss=$((bhakta_miss + 1))
      echo "miss bhakta: $TUTORIALS/$t"
    fi
  else
    errors=$((errors + 1))
    echo "missing tutorial: $TUTORIALS/$t"
  fi
done

# -- Cross-links from curriculum to demos --
crosslinks=0
for stage in "$CURRICULUM"/stage-06-*.md "$CURRICULUM"/stage-07-*.md; do
  [ -f "$stage" ] || continue
  if grep -q 'demos/' "$stage"; then
    crosslinks=$((crosslinks + 1))
  else
    echo "no cross-link: $stage"
  fi
done

echo "demos_count=$demos_count tutorials_count=$tutorials_count bhakta_ok=$bhakta_ok bhakta_miss=$bhakta_miss ascii_dirty=$ascii_dirty crosslinks=$crosslinks errors=$errors"

if [ "$errors" -gt 0 ] || [ "$bhakta_miss" -gt 0 ]; then
  echo "verdict=RED"
  exit 1
else
  echo "verdict=GREEN"
fi
