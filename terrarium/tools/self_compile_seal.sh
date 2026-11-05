#!/bin/sh
# self_compile_seal.sh -- compute djb2 hash of the expected assembly output
#
# Runs the shell code generator on the embedded Glow source, then computes
# the djb2 hash of the full assembly output. The hash is what the
# freestanding self-compile proof must reproduce.
#
# Usage: sh terrarium/tools/self_compile_seal.sh
#
# Prints the sealed hash as a Zig u32 hex constant.

set -e

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GLOW_SRC="$ROOT/terrarium/src/seal/glow_source.txt"
CODEGEN="$ROOT/terrarium/tools/glow_to_rv32i.sh"
TMPASM="/tmp/self_compile_seal_$$.S"

trap 'rm -f "$TMPASM"' EXIT

sh "$CODEGEN" "$GLOW_SRC" "$TMPASM"

HASH=$(python3 -c "
import sys
h = 5381
with open(sys.argv[1], 'rb') as f:
    for byte in f.read():
        h = ((h << 5) + h + byte) & 0xFFFFFFFF
print('0x{:08X}'.format(h))
" "$TMPASM")

echo "sealed_hash: $HASH"
echo ""
echo "For self_compile.rye, use:"
echo "    const sealed_hash: u32 = $HASH;"
