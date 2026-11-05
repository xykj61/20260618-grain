#!/bin/sh
# terrarium/m_ext_survey_helper.sh -- helper for m_ext_division_survey_witness
# Called by the Rishi witness. Not meant to be run standalone.
# Usage: sh terrarium/m_ext_survey_helper.sh <stage> [args...]

set -e

STAGE="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"

SOURCES="amphora_seal aurora_console bounded caravan_cap caravan_supervision framebuf glow_app glow_m_ext hello hello64 mantra_log mantra_wire rishi_boot self_compile steward tally_arena wire"

ARITH_SOURCES="amphora_seal aurora_console bounded caravan_cap caravan_supervision glow_app glow_m_ext mantra_log mantra_wire rishi_boot self_compile steward tally_arena"

case "$STAGE" in
  build)
    mkdir -p "$ROOT/terrarium/.build/survey"
    ok=0
    fail=0
    for src in $SOURCES; do
      if env RYE_ZIG="$ROOT/vendor/zig-toolchain/zig" "$ROOT/rye/bin/rye" build \
        "$ROOT/terrarium/src/${src}.rye" \
        -target riscv64-freestanding-none -fno-entry \
        -T "$ROOT/terrarium/layout64.ld" \
        -OReleaseSmall -mcmodel=medany -mcpu=generic_rv64+m \
        -femit-bin="$ROOT/terrarium/.build/survey/${src}.elf" 2>&1; then
        ok=$((ok+1))
        echo "BUILD OK: ${src}"
      else
        fail=$((fail+1))
        echo "BUILD FAIL: ${src}"
      fi
    done
    echo "builds_ok=${ok} builds_fail=${fail}"
    ;;

  arith)
    has_m=0
    no_m=0
    for src in $ARITH_SOURCES; do
      elf="$ROOT/terrarium/.build/survey/${src}.elf"
      count=$("$OBJDUMP" -d --mattr=+m "$elf" 2>/dev/null \
        | grep -cE '\b(mul|mulw|mulh|mulhu|mulhsu|div|divu|divw|divuw|rem|remu|remw|remuw)\b' \
        || true)
      if [ "$count" -gt 0 ]; then
        has_m=$((has_m+1))
        echo "M-EXT OK: ${src} (${count} instructions)"
      else
        no_m=$((no_m+1))
        echo "M-EXT MISSING: ${src}"
      fi
    done
    echo "has_m_ext=${has_m} missing_m_ext=${no_m}"
    ;;

  swdiv)
    sw_div=0
    for src in $SOURCES; do
      elf="$ROOT/terrarium/.build/survey/${src}.elf"
      hits=$("$OBJDUMP" -d --mattr=+m "$elf" 2>/dev/null \
        | grep -c 'Lsub_loop' || true)
      if [ "$hits" -gt 0 ]; then
        sw_div=$((sw_div+1))
        echo "SW-DIV FOUND: ${src} (${hits} patterns)"
      fi
    done
    echo "sw_div_modules=${sw_div}"
    ;;

  clean)
    clean=0
    for src in hello hello64 wire framebuf; do
      elf="$ROOT/terrarium/.build/survey/${src}.elf"
      count=$("$OBJDUMP" -d --mattr=+m "$elf" 2>/dev/null \
        | grep -cE '\b(mul|mulw|div|divu|divw|divuw|rem|remu)\b' || true)
      if [ "$count" -eq 0 ]; then
        clean=$((clean+1))
        echo "CLEAN: ${src} (0 M-ext instructions)"
      else
        echo "UNEXPECTED: ${src} (${count} M-ext instructions)"
      fi
    done
    echo "clean_modules=${clean}"
    ;;

  *)
    echo "unknown stage: $STAGE"
    exit 1
    ;;
esac
