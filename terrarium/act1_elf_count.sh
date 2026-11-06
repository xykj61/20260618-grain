#!/bin/sh
# Count and total the 19 RV64G ELF binaries
cd /Users/bhagavan851c05a/20260618-grain
count=0
total=0
for f in \
  terrarium/.build/self_compile_g.elf \
  terrarium/.build/tally_arena_g.elf \
  terrarium/.build/aurora_console_g.elf \
  terrarium/.build/mantra_log_g.elf \
  terrarium/.build/caravan_cap_g.elf \
  terrarium/.build/caravan_supervision_g.elf \
  terrarium/.build/steward_g.elf \
  terrarium/.build/glow_app_g.elf \
  terrarium/.build/glow_m_ext_g.elf \
  terrarium/.build/amphora_seal_g.elf \
  terrarium/.build/atomic_cap_g.elf \
  terrarium/.build/atomic_registry_g.elf \
  terrarium/.build/glow_fp_g.elf \
  terrarium/.build/fp_context_g.elf \
  terrarium/.build/dimeroll_price_g.elf \
  terrarium/.build/lotus_audio_g.elf \
  terrarium/.build/multi_hart_g.elf \
  terrarium/.build/preempt_g.elf \
  terrarium/.build/mantra_wire64_g.elf
do
  if test -f "$f"; then
    s=$(wc -c < "$f")
    total=$((total + s))
    count=$((count + 1))
  fi
done
echo "elf_count=$count total_bytes=$total"
