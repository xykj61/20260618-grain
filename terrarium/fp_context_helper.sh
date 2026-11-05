#!/bin/sh
# terrarium/fp_context_helper.sh -- build and FP context census
# Orbit 17: Caravan FP context save/restore on RV64FD
set -e

OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"
ELF="terrarium/.build/fp_context.elf"
STAGE="${1:-build}"

case "$STAGE" in
  build)
    mkdir -p terrarium/.build
    env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye build \
      terrarium/src/fp_context.rye \
      -target riscv64-freestanding-none -fno-entry \
      -T terrarium/layout64.ld -OReleaseSmall -mcmodel=medany \
      -mcpu=generic_rv64+m+f+d \
      -femit-bin="$ELF"
    size=$(wc -c < "$ELF" | tr -d ' ')
    echo "elf_bytes=$size"
    echo "build=ok"
    ;;

  census)
    if [ ! -f "$ELF" ]; then
      echo "census=error elf_missing"
      exit 1
    fi
    DISASM=$("$OBJDUMP" -d --mattr=+m,+f,+d "$ELF")

    fsd_count=$(echo "$DISASM" | grep -cw 'fsd' || true)
    fld_count=$(echo "$DISASM" | grep -cw 'fld' || true)
    fadd_count=$(echo "$DISASM" | grep -c 'fadd\.d' || true)
    fmul_count=$(echo "$DISASM" | grep -c 'fmul\.d' || true)
    fcvt_count=$(echo "$DISASM" | grep -c 'fcvt\.' || true)
    fmv_count=$(echo "$DISASM" | grep -c 'fmv\.' || true)
    flt_count=$(echo "$DISASM" | grep -c 'flt\.d' || true)
    csrr_fcsr=$(echo "$DISASM" | grep -c 'fcsr' || true)

    fp_total=$((fsd_count + fld_count + fadd_count + fmul_count + fcvt_count + fmv_count + flt_count))

    echo "fsd=$fsd_count fld=$fld_count fadd_d=$fadd_count fmul_d=$fmul_count"
    echo "fcvt=$fcvt_count fmv=$fmv_count flt_d=$flt_count fcsr_access=$csrr_fcsr"
    echo "fp_total=$fp_total"
    echo "census=ok"
    ;;
esac
