#!/bin/sh
# terrarium/rv64g_helper.sh -- helper for rv64g_witness
# Builds and censuses all 19 Mantrapod modules on full RV64G (IMAFD).
# Usage: sh terrarium/rv64g_helper.sh <stage>

set -e

STAGE="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OBJDUMP="/opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump"
CPU="generic_rv64+m+a+f+d"

# All 19 modules and their output ELF names
build_module() {
  mod="$1"
  outname="$2"
  env RYE_ZIG="$ROOT/vendor/zig-toolchain/zig" "$ROOT/rye/bin/rye" build \
    "$ROOT/terrarium/src/${mod}.rye" \
    -target riscv64-freestanding-none -fno-entry \
    -T "$ROOT/terrarium/layout64.ld" \
    -OReleaseSmall -mcmodel=medany -mcpu=$CPU \
    -femit-bin="$ROOT/terrarium/.build/${outname}.elf" 2>&1
}

case "$STAGE" in
  build)
    mkdir -p "$ROOT/terrarium/.build"
    ok=0
    fail=0

    # Quest 1.1-1.2 (M-ext, 11 modules)
    for mod in self_compile tally_arena aurora_console mantra_log mantra_wire \
               caravan_cap caravan_supervision steward glow_app glow_m_ext amphora_seal; do
      if [ "$mod" = "mantra_wire" ]; then
        outname="mantra_wire64_g"
      else
        outname="${mod}_g"
      fi
      if build_module "$mod" "$outname"; then
        ok=$((ok+1))
        echo "BUILD OK: ${mod} -> ${outname}.elf"
      else
        fail=$((fail+1))
        echo "BUILD FAIL: ${mod}"
      fi
    done

    # Quest 1.3 (A-ext, 4 modules)
    for mod in atomic_cap atomic_registry multi_hart preempt; do
      outname="${mod}_g"
      if build_module "$mod" "$outname"; then
        ok=$((ok+1))
        echo "BUILD OK: ${mod} -> ${outname}.elf"
      else
        fail=$((fail+1))
        echo "BUILD FAIL: ${mod}"
      fi
    done

    # Quest 1.4 (F/D, 4 modules)
    for mod in glow_fp fp_context dimeroll_price lotus_audio; do
      outname="${mod}_g"
      if build_module "$mod" "$outname"; then
        ok=$((ok+1))
        echo "BUILD OK: ${mod} -> ${outname}.elf"
      else
        fail=$((fail+1))
        echo "BUILD FAIL: ${mod}"
      fi
    done

    bytes_total=0
    for f in "$ROOT"/terrarium/.build/*_g.elf; do
      if [ -f "$f" ]; then
        sz=$(wc -c < "$f" | tr -d ' ')
        bytes_total=$((bytes_total+sz))
      fi
    done

    echo "builds_ok=${ok} builds_fail=${fail} builds_total=19"
    echo "elf_bytes_total=${bytes_total}"
    echo "build ok"
    ;;

  swift)
    swiftc -o "$ROOT/terrarium/.build/Terrarium_g" \
      "$ROOT/terrarium/app/main.swift" -framework AppKit 2>&1
    echo "swift_build=ok"
    ;;

  census)
    m_total=0
    a_total=0
    f_total=0
    csr_total=0
    modules=0

    seen=""
    for f in "$ROOT"/terrarium/.build/*_g.elf; do
      if [ ! -f "$f" ]; then continue; fi
      modules=$((modules+1))
      base=$(basename "$f" .elf)
      dis=$("$OBJDUMP" -d --mattr=+m,+a,+f,+d "$f" 2>/dev/null || true)

      m=$(echo "$dis" | grep -wcE 'mul[hw]?|mulhu|mulhsu|div[uw]?|divu|rem[uw]?|remu' || true)
      a=$(echo "$dis" | grep -wcE 'lr\.[wd]|sc\.[wd]|amoswap\.[wd]|amoadd\.[wd]|amoand\.[wd]|amoor\.[wd]|amoxor\.[wd]|amomax[u]?\.[wd]|amomin[u]?\.[wd]|fence' || true)
      fp=$(echo "$dis" | grep -wcE 'fmul\.[sd]|fadd\.[sd]|fsub\.[sd]|fdiv\.[sd]|fsqrt\.[sd]|fsd|fld|fsw|flw|fcvt\.|fmv\.|flt\.[sd]|fle\.[sd]|feq\.[sd]|fclass\.[sd]|fmadd\.[sd]|fmsub\.[sd]|fnmadd\.[sd]|fnmsub\.[sd]|fmin\.[sd]|fmax\.[sd]|fsgnj[nx]?\.[sd]' || true)
      csr=$(echo "$dis" | grep -wcE 'csrr[wsc]i?|mret|sret|ecall|ebreak|wfi' || true)

      m_total=$((m_total+m))
      a_total=$((a_total+a))
      f_total=$((f_total+fp))
      csr_total=$((csr_total+csr))

      echo "CENSUS: ${base} m=${m} a=${a} fp=${fp} csr=${csr}"
    done

    echo "census_modules=${modules}"
    echo "census_m_total=${m_total}"
    echo "census_a_total=${a_total}"
    echo "census_fp_total=${f_total}"
    echo "census_csr_total=${csr_total}"
    echo "census ok"
    ;;

  *)
    echo "unknown stage: $STAGE"
    exit 1
    ;;
esac
