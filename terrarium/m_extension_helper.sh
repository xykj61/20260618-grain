#!/bin/sh
# terrarium/m_extension_helper.sh -- helper for m_extension_witness
# Called by the Rishi witness. Not meant to be run standalone.
# Usage: sh terrarium/m_extension_helper.sh <stage>

set -e

STAGE="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"

MODULES="self_compile tally_arena aurora_console mantra_log mantra_wire caravan_cap caravan_supervision steward glow_app glow_m_ext amphora_seal"

case "$STAGE" in
  build)
    mkdir -p "$ROOT/terrarium/.build"
    ok=0
    fail=0
    for mod in $MODULES; do
      # mantra_wire must produce mantra_wire64.elf for the Terrarium Swift app
      if [ "$mod" = "mantra_wire" ]; then
        outname="mantra_wire64"
      else
        outname="${mod}_m"
      fi
      if env RYE_ZIG="$ROOT/vendor/zig-toolchain/zig" "$ROOT/rye/bin/rye" build \
        "$ROOT/terrarium/src/${mod}.rye" \
        -target riscv64-freestanding-none -fno-entry \
        -T "$ROOT/terrarium/layout64.ld" \
        -OReleaseSmall -mcmodel=medany -mcpu=generic_rv64+m \
        -femit-bin="$ROOT/terrarium/.build/${outname}.elf" 2>&1; then
        ok=$((ok+1))
        echo "BUILD OK: ${mod} -> ${outname}.elf"
      else
        fail=$((fail+1))
        echo "BUILD FAIL: ${mod}"
      fi
    done
    echo "builds_ok=${ok} builds_fail=${fail} builds_total=11"
    ;;

  swift)
    swiftc -o "$ROOT/terrarium/.build/Terrarium" \
      "$ROOT/terrarium/app/main.swift" -framework AppKit 2>&1
    echo "swift_build=ok"
    ;;

  census)
    total=0
    modules_with=0
    for mod in $MODULES; do
      if [ "$mod" = "mantra_wire" ]; then
        outname="mantra_wire64"
      else
        outname="${mod}_m"
      fi
      elf="$ROOT/terrarium/.build/${outname}.elf"
      count=$("$OBJDUMP" -d --mattr=+m "$elf" 2>/dev/null \
        | grep -wcE 'mul|mulw|mulh|mulhu|mulhsu|div|divu|divw|divuw|rem|remu|remw|remuw' \
        || true)
      total=$((total+count))
      if [ "$count" -gt 0 ]; then
        modules_with=$((modules_with+1))
      fi
      echo "CENSUS: ${mod} ${count} M-ext instructions"
    done
    echo "census_total=${total} census_modules_with_m=${modules_with} census_modules_total=11"
    ;;

  *)
    echo "unknown stage: $STAGE"
    exit 1
    ;;
esac
