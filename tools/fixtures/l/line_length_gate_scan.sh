#!/bin/sh
# tools/fixtures/l/line_length_gate_scan.sh -- gate Glow at 80 columns,
# ratchet all others
#
#   sh tools/fixtures/l/line_length_gate_scan.sh [--list]
#
# WHAT THIS GATES. The 80-column line-length standard seated `20261104`
# on Keaton's word. Glow is gated at zero lines over 80 from that
# stamp (the cheapest family at 618 lines). Every other TAME family --
# Rye, Rishi, Brix, Kyri -- ratchets under a ceiling that only falls.
#
# WHY THE SPLIT. Glow carries 618 lines over 80, all but 16 of them
# comments. Rye carries ~131,000, Rishi ~120,000 -- sweeping those is
# a multi-round effort. The gate holds the door on Glow while the
# ratchet tracks progress on the rest.
#
# ROOMS READ PAST, each for its own reason:
#   vendor/ gratitude/   third-party text, held unmodified
#   seed/                the public projection
#   session-logs/        testimony
#   */fixtures/*         a plant may carry a long line on purpose
#   *-fact-line-lits.glow  hex-encoded sample data (128+ char hex strings
#                          that physically cannot wrap without changing
#                          content-addressed identity)
#
# Purely local -- no key, no network, no funds, no device.
set -eu
LC_ALL=C
export LC_ALL

MAXCOL=80
FLOOR=3500
MAX_FILES=20000
list=no

while [ $# -gt 0 ]; do
  case "$1" in
    --list) list=yes ;;
    *) echo "$0: unknown argument $1" >&2; exit 2 ;;
  esac
  shift
done

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

# corpus
git ls-files '*.rye' '*.rish' '*.brix' '*.kyri' '*.glow' \
  > "$pen/all.txt"

: > "$pen/glow.txt"
: > "$pen/other.txt"

while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    vendor/*|gratitude/*|seed/*|session-logs/*) continue ;;
    */fixtures/*|fixtures/*) continue ;;
    *-fact-line-lits.glow) continue ;;
  esac
  [ -f "$f" ] || continue
  case "$f" in
    *[!-a-zA-Z0-9_./]*) echo "path_space=$f" >&2
      echo "verdict=path_unsafe"; exit 1 ;;
  esac
  case "$f" in
    *.glow) printf '%s\n' "$f" >> "$pen/glow.txt" ;;
    *)      printf '%s\n' "$f" >> "$pen/other.txt" ;;
  esac
done < "$pen/all.txt"

glow_files=$(wc -l < "$pen/glow.txt" | tr -d ' ')
other_files=$(wc -l < "$pen/other.txt" | tr -d ' ')
total_files=$((glow_files + other_files))

if [ "$total_files" -gt "$MAX_FILES" ]; then
  echo "files_listed=$total_files max_files=$MAX_FILES"
  echo "verdict=corpus_over_bound"
  exit 1
fi

if [ "$total_files" -eq 0 ]; then
  echo "files_listed=0 verdict=reach_empty"
  exit 1
fi

# count overlong lines per family
glow_over=0
if [ "$glow_files" -gt 0 ]; then
  glow_over=$(awk -v maxcol="$MAXCOL" '
    length($0) > maxcol { n++ }
    END { print n + 0 }
  ' $(cat "$pen/glow.txt"))
fi

other_over=0
if [ "$other_files" -gt 0 ]; then
  other_over=$(awk -v maxcol="$MAXCOL" '
    length($0) > maxcol { n++ }
    END { print n + 0 }
  ' $(cat "$pen/other.txt"))
fi

# reach check
if [ "$total_files" -lt "$FLOOR" ]; then
  echo "files_listed=$total_files reach_floor=$FLOOR"
  echo "verdict=reach_short"
  exit 1
fi

# the gate: Glow at zero
glow_verdict=ok
if [ "$glow_over" -gt 0 ]; then
  glow_verdict=over
fi

# the ratchet: others under a ceiling that only falls
# the ceiling is set here; lower it when a sweep lands
OTHER_CEILING=${LINE_LENGTH_OTHER_CEILING:-297000}
other_verdict=ok
if [ "$other_over" -gt "$OTHER_CEILING" ]; then
  other_verdict=over
fi

echo "maxcol=$MAXCOL"
echo "glow_files=$glow_files"
echo "glow_over=$glow_over"
echo "glow_verdict=$glow_verdict"
echo "other_files=$other_files"
echo "other_over=$other_over"
echo "other_ceiling=$OTHER_CEILING"
echo "other_verdict=$other_verdict"
echo "total_files=$total_files"
echo "reach_floor=$FLOOR"

if [ "$list" = yes ] && [ "$glow_over" -gt 0 ]; then
  echo "glow_overlong_files:"
  awk -v maxcol="$MAXCOL" '
    length($0) > maxcol { per[FILENAME]++ }
    END { for (f in per) printf "  over=%d %s\n", per[f], f }
  ' $(cat "$pen/glow.txt") | sort -rn
fi

if [ "$glow_verdict" = ok ] && [ "$other_verdict" = ok ]; then
  echo "verdict=ok"
  exit 0
else
  echo "verdict=gate_or_ratchet"
  exit 1
fi
