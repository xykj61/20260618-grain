#!/bin/sh
# terrarium/a_extension_helper.sh -- helper for a_extension_witness
#
# Builds all 4 A-extension modules and runs a combined instruction
# census across all of them.
#
# Usage: sh terrarium/a_extension_helper.sh <stage>
#   build   -- build all 4 modules for RV64IMA
#   census  -- A-extension + trap instruction census across all 4 ELFs
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"
BUILDDIR="$ROOT/terrarium/.build"
FLAGS="-target riscv64-freestanding-none -fno-entry -T $ROOT/terrarium/layout64.ld -OReleaseSmall -mcmodel=medany -mcpu=generic_rv64+m+a"

MODULES="atomic_cap atomic_registry multi_hart preempt"
ELFS="atomic_cap.elf atomic_registry.elf multi_hart64.elf preempt64.elf"

case "$1" in
  build)
    mkdir -p "$BUILDDIR"
    ok=0
    fail=0
    for mod in $MODULES; do
      case "$mod" in
        multi_hart) elf="multi_hart64.elf" ;;
        preempt)    elf="preempt64.elf" ;;
        *)          elf="${mod}.elf" ;;
      esac
      if env RYE_ZIG="$ROOT/vendor/zig-toolchain/zig" "$ROOT/rye/bin/rye" build \
        "$ROOT/terrarium/src/${mod}.rye" \
        $FLAGS \
        -femit-bin="$BUILDDIR/$elf" 2>&1; then
        ok=$((ok + 1))
      else
        fail=$((fail + 1))
        echo "FAIL: $mod"
      fi
    done
    echo "builds_ok=$ok"
    echo "builds_fail=$fail"
    total=0
    for elf in $ELFS; do
      if [ -f "$BUILDDIR/$elf" ]; then
        sz=$(wc -c < "$BUILDDIR/$elf" | tr -d ' ')
        echo "elf_bytes_${elf}=$sz"
        total=$((total + sz))
      fi
    done
    echo "elf_bytes_total=$total"
    ;;

  census)
    # combined A-extension and trap instruction census across all 4 ELFs
    lr_total=0; sc_total=0; amoadd_total=0; amoswap_total=0; fence_total=0
    mret_total=0; csrrw_total=0; csrr_total=0; csrw_total=0
    csrci_total=0; csrsi_total=0; csrs_total=0; csrc_total=0
    sd_total=0; ld_total=0
    modules_ok=0

    for elf in $ELFS; do
      path="$BUILDDIR/$elf"
      if [ ! -f "$path" ]; then
        echo "error: $path not found"
        exit 1
      fi
      disasm=$("$OBJDUMP" -d --mattr=+m,+a "$path" 2>/dev/null)
      modules_ok=$((modules_ok + 1))

      lr=$(echo "$disasm" | grep -cw 'lr\.w' || true)
      sc=$(echo "$disasm" | grep -cw 'sc\.w' || true)
      amoadd=$(echo "$disasm" | grep -cw 'amoadd\.w' || true)
      amoswap=$(echo "$disasm" | grep -cw 'amoswap\.w' || true)
      fence=$(echo "$disasm" | grep -cw 'fence' || true)
      mret=$(echo "$disasm" | grep -cw 'mret' || true)
      csrrw=$(echo "$disasm" | grep -cw 'csrrw' || true)
      csrr=$(echo "$disasm" | grep -cw 'csrr' || true)
      csrw=$(echo "$disasm" | grep -cw 'csrw' || true)
      csrci=$(echo "$disasm" | grep -cw 'csrci' || true)
      csrsi=$(echo "$disasm" | grep -cw 'csrsi' || true)
      csrs=$(echo "$disasm" | grep -cw 'csrs' || true)
      csrc=$(echo "$disasm" | grep -cw 'csrc' || true)
      sd=$(echo "$disasm" | grep -cw 'sd' || true)
      ld=$(echo "$disasm" | grep -cw 'ld' || true)

      a_ext=$((lr + sc + amoadd + amoswap))
      trap_ext=$((mret + csrrw + csrr + csrw + csrci + csrsi + csrs + csrc))
      echo "  $elf: a_ext=$a_ext trap=$trap_ext fence=$fence sd=$sd ld=$ld"

      lr_total=$((lr_total + lr))
      sc_total=$((sc_total + sc))
      amoadd_total=$((amoadd_total + amoadd))
      amoswap_total=$((amoswap_total + amoswap))
      fence_total=$((fence_total + fence))
      mret_total=$((mret_total + mret))
      csrrw_total=$((csrrw_total + csrrw))
      csrr_total=$((csrr_total + csrr))
      csrw_total=$((csrw_total + csrw))
      csrci_total=$((csrci_total + csrci))
      csrsi_total=$((csrsi_total + csrsi))
      csrs_total=$((csrs_total + csrs))
      csrc_total=$((csrc_total + csrc))
      sd_total=$((sd_total + sd))
      ld_total=$((ld_total + ld))
    done

    a_total=$((lr_total + sc_total + amoadd_total + amoswap_total))
    csr_total=$((mret_total + csrrw_total + csrr_total + csrw_total + csrci_total + csrsi_total + csrs_total + csrc_total))

    echo "census_modules=$modules_ok"
    echo "census_lr=$lr_total"
    echo "census_sc=$sc_total"
    echo "census_amoadd=$amoadd_total"
    echo "census_amoswap=$amoswap_total"
    echo "census_a_total=$a_total"
    echo "census_fence=$fence_total"
    echo "census_mret=$mret_total"
    echo "census_csrrw=$csrrw_total"
    echo "census_csr_total=$csr_total"
    echo "census_sd=$sd_total"
    echo "census_ld=$ld_total"
    ;;

  *)
    echo "usage: $0 build|census"
    exit 1
    ;;
esac
