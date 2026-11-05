#!/bin/sh
# terrarium/preempt_helper.sh -- helper for preempt witness
set -e

ELF="terrarium/.build/preempt64.elf"
OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"

case "$1" in
  census)
    if [ ! -f "$ELF" ]; then
      echo "error: $ELF not found"
      exit 1
    fi
    mret=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'mret' || true)
    csrrw=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'csrrw' || true)
    csrr=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'csrr' || true)
    csrw=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'csrw' || true)
    csrci=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'csrci' || true)
    csrsi=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'csrsi' || true)
    csrs=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'csrs' || true)
    csrc=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'csrc' || true)
    sd=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'sd' || true)
    ld=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'ld' || true)
    fence=$("$OBJDUMP" -d --mattr=+m,+a "$ELF" 2>/dev/null | grep -cw 'fence' || true)
    total=$((mret + csrrw + csrr + csrw + csrci + csrsi + csrs + csrc))
    echo "census_mret=$mret"
    echo "census_csrrw=$csrrw"
    echo "census_csrr=$csrr"
    echo "census_csrw=$csrw"
    echo "census_csrci=$csrci"
    echo "census_csrsi=$csrsi"
    echo "census_csrs=$csrs"
    echo "census_csrc=$csrc"
    echo "census_sd=$sd"
    echo "census_ld=$ld"
    echo "census_fence=$fence"
    echo "census_csr_total=$total"
    ;;
  *)
    echo "usage: $0 census"
    exit 1
    ;;
esac
