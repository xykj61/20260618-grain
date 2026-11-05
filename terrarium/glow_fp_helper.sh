#!/bin/sh
# terrarium/glow_fp_helper.sh -- helper for glow_fp_witness
#
# Builds the Glow FP module for RV64FD and runs an F/D extension
# instruction census via llvm-objdump.
#
# Usage: sh terrarium/glow_fp_helper.sh <stage>
#   build   -- build glow_fp.rye for RV64IMAFD
#   census  -- F/D extension instruction census
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"
BUILDDIR="$ROOT/terrarium/.build"
ELF="$BUILDDIR/glow_fp.elf"
FLAGS="-target riscv64-freestanding-none -fno-entry -T $ROOT/terrarium/layout64.ld -OReleaseSmall -mcmodel=medany -mcpu=generic_rv64+m+f+d"

case "$1" in
  build)
    mkdir -p "$BUILDDIR"
    if env RYE_ZIG="$ROOT/vendor/zig-toolchain/zig" "$ROOT/rye/bin/rye" build \
      "$ROOT/terrarium/src/glow_fp.rye" \
      $FLAGS \
      -femit-bin="$ELF" 2>&1; then
      echo "build_ok=yes"
    else
      echo "build_ok=no"
      exit 1
    fi
    sz=$(wc -c < "$ELF" | tr -d ' ')
    echo "elf_bytes=$sz"
    ;;

  census)
    if [ ! -f "$ELF" ]; then
      echo "error: $ELF not found -- run build first"
      exit 1
    fi
    disasm=$("$OBJDUMP" -d --mattr=+m,+f,+d "$ELF" 2>/dev/null)

    # F/D arithmetic
    fadd=$(echo "$disasm" | grep -cw 'fadd\.d' || true)
    fsub=$(echo "$disasm" | grep -cw 'fsub\.d' || true)
    fmul=$(echo "$disasm" | grep -cw 'fmul\.d' || true)
    fdiv=$(echo "$disasm" | grep -cw 'fdiv\.d' || true)

    # F/D load and store
    fld=$(echo "$disasm" | grep -cw 'fld' || true)
    fsd=$(echo "$disasm" | grep -cw 'fsd' || true)

    # float-int conversions (fcvt family)
    fcvt=$(echo "$disasm" | grep -c 'fcvt\.' || true)

    # float-int moves (fmv family)
    fmv=$(echo "$disasm" | grep -c 'fmv\.' || true)

    # float comparisons
    flt=$(echo "$disasm" | grep -cw 'flt\.d' || true)
    feq=$(echo "$disasm" | grep -cw 'feq\.d' || true)
    fle=$(echo "$disasm" | grep -cw 'fle\.d' || true)

    # float negation and sign
    fneg=$(echo "$disasm" | grep -c 'fneg\.d' || true)
    fsgn=$(echo "$disasm" | grep -c 'fsgn' || true)

    arith=$((fadd + fsub + fmul + fdiv))
    loadstore=$((fld + fsd))
    compare=$((flt + feq + fle))
    fd_total=$((arith + loadstore + fcvt + fmv + compare + fneg + fsgn))

    echo "census_fadd=$fadd"
    echo "census_fsub=$fsub"
    echo "census_fmul=$fmul"
    echo "census_fdiv=$fdiv"
    echo "census_fld=$fld"
    echo "census_fsd=$fsd"
    echo "census_fcvt=$fcvt"
    echo "census_fmv=$fmv"
    echo "census_flt=$flt"
    echo "census_feq=$feq"
    echo "census_fle=$fle"
    echo "census_fneg=$fneg"
    echo "census_fsgn=$fsgn"
    echo "census_arith=$arith"
    echo "census_loadstore=$loadstore"
    echo "census_compare=$compare"
    echo "census_fd_total=$fd_total"
    ;;

  *)
    echo "usage: $0 build|census"
    exit 1
    ;;
esac
