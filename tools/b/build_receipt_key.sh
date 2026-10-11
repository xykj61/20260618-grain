#!/bin/sh
# tools/b/build_receipt_key.sh -- the content key for one build's declared inputs.
#
# WHY THIS EXISTS. The shared build cache may reuse a compiled binary only when every declared
# input is identical. Zig reads file content and ignores the mode bit, so a chmod alone would
# leave the binary identical and reuse it silently. This writer folds the file mode into the key
# itself, so an executable-bit change forces a miss at the receipt layer, where Zig cannot see it.
#
# WHAT IS KEYED: the source bytes (sha256), the mode bits read from the file, the flags string,
# the overlay bytes (sha256, or none), and the compiler identity the caller declares. The path is
# NOT keyed, so identical bytes at another checkout path share one key.
#
# USAGE: sh tools/b/build_receipt_key.sh <source> <flags> <overlay-or-dash> <compiler-id>
# PRINTS: the canonical record, one field per line, then key=<sha256 of that record>.
set -eu

# invariant: exactly four arguments; a short call is a named error, never a guessed key.
if [ "$#" -ne 4 ]; then
  echo "error=usage expected=4_args got=$#" >&2
  exit 2
fi
src=$1
flags=$2
overlay=$3
compiler=$4

# invariant: the source is a readable regular file; a missing source has no key to give.
if [ ! -f "$src" ]; then
  echo "error=source_missing path=$src" >&2
  exit 2
fi

src_sha=$(sha256sum "$src" | cut -d' ' -f1)
# why ls -l: the permission string is read from the file itself, so no caller can declare it
# wrongly. ls -l prints the same ten-column form on GNU and BSD, where stat -c does not travel.
mode=$(ls -ld "$src" | cut -c1-10)

if [ "$overlay" = "-" ]; then
  ovl_sha=none
else
  # invariant: a named overlay must exist; an overlay that vanished would key as none and reuse.
  if [ ! -f "$overlay" ]; then
    echo "error=overlay_missing path=$overlay" >&2
    exit 2
  fi
  ovl_sha=$(sha256sum "$overlay" | cut -d' ' -f1)
fi

record="src=$src_sha
mode=$mode
flags=$flags
overlay=$ovl_sha
compiler=$compiler"

printf '%s\n' "$record"
key=$(printf '%s\n' "$record" | sha256sum | cut -d' ' -f1)
echo "key=$key"
