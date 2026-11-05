#!/bin/sh
# terrarium/lotus_audio_helper.sh -- build and census
# Orbit 19: Lotus audio sample type on the bare hart
set -e

OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"
ELF="terrarium/.build/lotus_audio.elf"
STAGE="${1:-build}"

case "$STAGE" in
  build)
    mkdir -p terrarium/.build
    env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye build \
      terrarium/src/lotus_audio.rye \
      -target riscv64-freestanding-none -fno-entry \
      -T terrarium/layout64.ld -OReleaseSmall -mcmodel=medany \
      -mcpu=generic_rv64+m+f+d \
      -femit-bin="$ELF"
    size=$(wc -c < "$ELF" | tr -d ' ')
    echo "elf_bytes=$size"
    echo "build ok"
    ;;

  census)
    if [ ! -f "$ELF" ]; then
      echo "error: ELF not found -- run build first"
      exit 1
    fi
    DISASM=$("$OBJDUMP" -d --mattr=+m,+f,+d "$ELF")

    fmul_d=$(echo "$DISASM" | grep -c 'fmul\.d' || true)
    fadd_d=$(echo "$DISASM" | grep -c 'fadd\.d' || true)
    fsub_d=$(echo "$DISASM" | grep -c 'fsub\.d' || true)
    fdiv_d=$(echo "$DISASM" | grep -c 'fdiv\.d' || true)
    fsd=$(echo "$DISASM" | grep -cw 'fsd' || true)
    fld=$(echo "$DISASM" | grep -cw 'fld' || true)
    fcvt=$(echo "$DISASM" | grep -cE 'fcvt\.' || true)
    fmv=$(echo "$DISASM" | grep -cE 'fmv\.' || true)
    flt_d=$(echo "$DISASM" | grep -c 'flt\.d' || true)
    fp_total=$((fmul_d + fadd_d + fsub_d + fdiv_d + fsd + fld + fcvt + fmv + flt_d))

    mul=$(echo "$DISASM" | grep -cE '	mul	|	mulw	' || true)
    div=$(echo "$DISASM" | grep -cE '	div[uw]*	|	rem[uw]*	' || true)

    size=$(wc -c < "$ELF" | tr -d ' ')
    echo "fmul_d=$fmul_d fadd_d=$fadd_d fsub_d=$fsub_d fdiv_d=$fdiv_d fsd=$fsd fld=$fld fcvt=$fcvt fmv=$fmv flt_d=$flt_d fp_total=$fp_total"
    echo "mul=$mul div=$div"
    echo "elf_bytes=$size"
    echo "census ok"
    ;;

  *)
    echo "usage: $0 {build|census}"
    exit 1
    ;;
esac
