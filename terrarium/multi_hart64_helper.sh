#!/bin/sh
# terrarium/multi_hart64_helper.sh -- helper for multi_hart64 witness
set -e

ELF="terrarium/.build/multi_hart64.elf"
OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"

case "$1" in
  census)
    if [ ! -f "$ELF" ]; then
      echo "error: $ELF not found"
      exit 1
    fi
    lr=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'lr\.w' || true)
    sc=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'sc\.w' || true)
    amoadd=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'amoadd\.w' || true)
    fence=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'fence' || true)
    total=$((lr + sc + amoadd + fence))
    echo "census_lr=$lr"
    echo "census_sc=$sc"
    echo "census_amoadd=$amoadd"
    echo "census_fence=$fence"
    echo "census_total=$total"
    ;;
  *)
    echo "usage: $0 census"
    exit 1
    ;;
esac
