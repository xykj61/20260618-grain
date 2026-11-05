#!/bin/sh
# terrarium/atomic_cap_helper.sh -- helper for atomic_cap_witness
# Called by the Rishi witness. Not meant to be run standalone.
# Usage: sh terrarium/atomic_cap_helper.sh <stage>

set -e

STAGE="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"

case "$STAGE" in
  build)
    mkdir -p "$ROOT/terrarium/.build"
    if env RYE_ZIG="$ROOT/vendor/zig-toolchain/zig" "$ROOT/rye/bin/rye" build \
      "$ROOT/terrarium/src/atomic_cap.rye" \
      -target riscv64-freestanding-none -fno-entry \
      -T "$ROOT/terrarium/layout64.ld" \
      -OReleaseSmall -mcmodel=medany -mcpu=generic_rv64+m+a \
      -femit-bin="$ROOT/terrarium/.build/atomic_cap.elf" 2>&1; then
      echo "build=ok"
    else
      echo "build=fail"
      exit 1
    fi
    size=$(wc -c < "$ROOT/terrarium/.build/atomic_cap.elf" | tr -d ' ')
    echo "elf_bytes=${size}"
    ;;

  census)
    elf="$ROOT/terrarium/.build/atomic_cap.elf"
    # decode with both M and A extension attributes
    disasm=$("$OBJDUMP" -d --mattr=+m,+a "$elf" 2>/dev/null)

    # A-extension atomic instructions
    amoadd=$(echo "$disasm" | grep -wc 'amoadd\.w' || true)
    amoswap=$(echo "$disasm" | grep -wc 'amoswap\.w' || true)
    lr=$(echo "$disasm" | grep -c 'lr\.w' || true)
    sc=$(echo "$disasm" | grep -c 'sc\.w' || true)
    total=$((amoadd + amoswap + lr + sc))

    echo "CENSUS: amoadd.w=${amoadd} amoswap.w=${amoswap} lr.w=${lr} sc.w=${sc}"
    echo "census_total=${total}"
    echo "census_amoadd=${amoadd}"
    echo "census_amoswap=${amoswap}"
    echo "census_lr=${lr}"
    echo "census_sc=${sc}"
    ;;

  *)
    echo "unknown stage: $STAGE"
    exit 1
    ;;
esac
