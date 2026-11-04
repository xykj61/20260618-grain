#!/bin/sh
# waymark_ascending_census_scan.sh -- full census of every WAYMARK[0-9]+ pattern in the tree.
#
# Orbit 1 of the Glow Language Journey (tablecloth/20261103-184811_glow-language-journey/).
# Produces a machine-readable ledger of every ascending-number pattern across three tiers:
#
#   Tier 1 -- commit messages (frozen in git history; only a deep debride can reach them)
#   Tier 2 -- dated testimony  (files whose basename carries a one-clock stamp)
#   Tier 3 -- living files     (everything else tracked by git)
#
# Output: tab-separated lines to stdout --
#   tier<TAB>waymark<TAB>number<TAB>file<TAB>line_number<TAB>full_match
#
# Summary counts go to stderr so a pipe captures the ledger alone.
# Exit 0 on success; exit 1 on internal error.
#
# Usage:
#   sh tools/fixtures/w/waymark_ascending_census_scan.sh              # full ledger + summary
#   sh tools/fixtures/w/waymark_ascending_census_scan.sh --summary    # summary only
#   sh tools/fixtures/w/waymark_ascending_census_scan.sh --verify     # verify against git grep
#
# CENSUS_ROOT is a control knob for planted tests.

set -eu

ROOT="${CENSUS_ROOT:-.}"

summary_only=false
verify=false
for arg in "$@"; do
  case "$arg" in
    --summary) summary_only=true ;;
    --verify)  verify=true ;;
  esac
done

marks='pixel-glass|glow-publishing|glass-keyboard|seva-broadcast|hearth-display|glow-language|usb-hearth|source-identity|djinn-exec|compass-language|compass-identity|compass-surface|compass-world|harvest-yield|harvest-trade|harvest-commons|harvest-rest|cion-molt|cion-survey|cion-living-molt|cion-debride|cion-seal|AHOY|front-door|dimeroll-expansion|open-image|mikrophone|constels-naming|lotus-audio|slh-dsa|SEVA|MAND|MONA'

mkdir -p "$ROOT/.mind-state/tmp"
state_tmp=$(CDPATH= cd "$ROOT/.mind-state/tmp" && pwd)
tmp_dir=$(mktemp -d "$state_tmp/ascending-census.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

ledger="$tmp_dir/ledger.tsv"
living_files="$tmp_dir/living.txt"
dated_files="$tmp_dir/dated.txt"
commit_ledger="$tmp_dir/commits.tsv"

# -- Classify tracked files into living (tier 3) and dated testimony (tier 2) --
# The test: a file whose basename carries a one-clock stamp is testimony.
# Same rule as stamp-and-name.md and the drift scan.
all_files="$tmp_dir/all.txt"
( cd "$ROOT" && git ls-files 2>/dev/null ) > "$all_files" || : > "$all_files"

# Dated: basename matches YYYYMMDD-HHMMSS or sits under date/, archive/, yonder/
grep -E '(^|/)[0-9]{8}-[0-9]{6}[_.]' "$all_files" > "$dated_files" || : > "$dated_files"
grep -E '(^|/)(date|archive|yonder)/' "$all_files" >> "$dated_files" || true
sort -u "$dated_files" > "$tmp_dir/dated_sorted.txt"
mv "$tmp_dir/dated_sorted.txt" "$dated_files"

# Living: everything not dated, excluding vendor/gratitude/seed (third-party, held unmodified)
grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' "$all_files" \
  | grep -vE '(^|/)(date|archive|yonder)/' \
  | grep -vE '^(vendor|gratitude|seed)/' \
  > "$living_files" || : > "$living_files"

# -- Tier 3: scan living files --
: > "$ledger"
if [ -s "$living_files" ]; then
  ( cd "$ROOT" && tr '\n' '\0' < "$living_files" \
    | xargs -0 grep -nE "(^|[^A-Za-z])($marks)[0-9]+" 2>/dev/null ) \
    | while IFS=: read -r file line_no content; do
        echo "$content" | grep -oE "($marks)[0-9]+" | while read -r match; do
          waymark=$(echo "$match" | sed 's/[0-9]*$//')
          number=$(echo "$match" | sed 's/^[A-Z]*//')
          if [ "$summary_only" = false ]; then
            printf 'living\t%s\t%s\t%s\t%s\t%s\n' "$waymark" "$number" "$file" "$line_no" "$match"
          fi
          printf 'living\t%s\t%s\t%s\t%s\t%s\n' "$waymark" "$number" "$file" "$line_no" "$match" >> "$ledger"
        done
      done
fi

# -- Tier 2: scan dated testimony --
if [ -s "$dated_files" ]; then
  ( cd "$ROOT" && tr '\n' '\0' < "$dated_files" \
    | xargs -0 grep -nE "(^|[^A-Za-z])($marks)[0-9]+" 2>/dev/null ) \
    | while IFS=: read -r file line_no content; do
        echo "$content" | grep -oE "($marks)[0-9]+" | while read -r match; do
          waymark=$(echo "$match" | sed 's/[0-9]*$//')
          number=$(echo "$match" | sed 's/^[A-Z]*//')
          if [ "$summary_only" = false ]; then
            printf 'dated\t%s\t%s\t%s\t%s\t%s\n' "$waymark" "$number" "$file" "$line_no" "$match"
          fi
          printf 'dated\t%s\t%s\t%s\t%s\t%s\n' "$waymark" "$number" "$file" "$line_no" "$match" >> "$ledger"
        done
      done
fi

# -- Tier 1: scan commit messages --
# These are frozen in git history. Only a deep debride (filter-repo) can reach them.
( cd "$ROOT" && git log --all --format='%H %s%n%b' 2>/dev/null ) \
  | grep -nE "($marks)[0-9]+" \
  | while IFS=: read -r line_no content; do
      echo "$content" | grep -oE "($marks)[0-9]+" | while read -r match; do
        waymark=$(echo "$match" | sed 's/[0-9]*$//')
        number=$(echo "$match" | sed 's/^[A-Z]*//')
        if [ "$summary_only" = false ]; then
          printf 'commit\t%s\t%s\t-\t%s\t%s\n' "$waymark" "$number" "$line_no" "$match"
        fi
        printf 'commit\t%s\t%s\t-\t%s\t%s\n' "$waymark" "$number" "$line_no" "$match" >> "$ledger"
      done
    done

# -- Summary --
total=$(wc -l < "$ledger" | tr -d ' ')
living_count=$(grep -c '^living' "$ledger" || true)
dated_count=$(grep -c '^dated' "$ledger" || true)
commit_count=$(grep -c '^commit' "$ledger" || true)

living_files_hit=$(grep '^living' "$ledger" | awk -F '\t' '{print $4}' | sort -u | wc -l | tr -d ' ')
dated_files_hit=$(grep '^dated' "$ledger" | awk -F '\t' '{print $4}' | sort -u | wc -l | tr -d ' ')

# Distinct waymarks with any ascending-number pattern
waymarks_hit=$(awk -F '\t' '{print $2}' "$ledger" | sort -u | wc -l | tr -d ' ')

# Per-waymark summary
per_waymark="$tmp_dir/per_waymark.txt"
awk -F '\t' '{print $1 "\t" $2}' "$ledger" | sort | uniq -c | sort -rn > "$per_waymark"

>&2 echo "=== Waymark Ascending-Number Census ==="
>&2 echo "total_occurrences=$total"
>&2 echo "tier_living=$living_count  (tier 3 -- living files, sweepable)"
>&2 echo "tier_dated=$dated_count  (tier 2 -- dated testimony, keeps every word)"
>&2 echo "tier_commit=$commit_count  (tier 1 -- commit messages, only deep debride reaches)"
>&2 echo "living_files_touched=$living_files_hit"
>&2 echo "dated_files_touched=$dated_files_hit"
>&2 echo "waymarks_with_numbers=$waymarks_hit"
>&2 echo ""
>&2 echo "--- Per waymark (occurrences by tier) ---"

for w in lotus-audio glow-language pixel-glass glow-publishing glass-keyboard seva-broadcast hearth-display compass-surface usb-hearth source-identity djinn-exec compass-language compass-identity compass-world harvest-yield harvest-trade harvest-commons harvest-rest cion-molt cion-survey cion-living-molt cion-debride cion-seal AHOY front-door dimeroll-expansion open-image mikrophone constels-naming slh-dsa SEVA MAND MONA; do
  wl=$(grep "^living	$w	" "$ledger" | wc -l | tr -d ' ')
  wd=$(grep "^dated	$w	" "$ledger" | wc -l | tr -d ' ')
  wc_val=$(grep "^commit	$w	" "$ledger" | wc -l | tr -d ' ')
  wt=$((wl + wd + wc_val))
  [ "$wt" -gt 0 ] && >&2 printf '  %s  total=%-8d living=%-8d dated=%-8d commit=%d\n' "$w" "$wt" "$wl" "$wd" "$wc_val"
done

# -- Verify mode: cross-check tier 3 living count against git grep --
if [ "$verify" = true ]; then
  >&2 echo ""
  >&2 echo "--- Verification against git grep ---"
  verify_ok=true

  for w in lotus-audio glow-language pixel-glass glow-publishing glass-keyboard seva-broadcast hearth-display compass-surface usb-hearth source-identity djinn-exec compass-language compass-identity compass-world harvest-yield harvest-trade harvest-commons harvest-rest cion-molt cion-survey cion-living-molt cion-debride cion-seal AHOY front-door dimeroll-expansion open-image mikrophone constels-naming slh-dsa SEVA MAND MONA; do
    # Census count: living occurrences for this waymark
    census_living=$(grep "^living	$w	" "$ledger" | wc -l | tr -d ' ')

    # git grep count over living files only
    gg_count=0
    if [ -s "$living_files" ]; then
      gg_count=$( ( cd "$ROOT" && tr '\n' '\0' < "$living_files" \
        | xargs -0 grep -ohE "(^|[^A-Za-z])${w}[0-9]+" 2>/dev/null ) \
        | grep -c . || true )
    fi

    if [ "$census_living" -ne "$gg_count" ]; then
      >&2 printf '  MISMATCH  %s  census=%d  git_grep=%d\n' "$w" "$census_living" "$gg_count"
      verify_ok=false
    fi
  done

  if [ "$verify_ok" = true ]; then
    >&2 echo "  verify=ok  (census agrees with git grep on every waymark)"
    echo "verify=ok"
  else
    >&2 echo "  verify=MISMATCH"
    echo "verify=MISMATCH"
    exit 1
  fi
fi

echo "verdict=ok"
