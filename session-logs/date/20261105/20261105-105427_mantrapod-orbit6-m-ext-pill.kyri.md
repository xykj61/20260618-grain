format session-log-v1
stamp 20261105.105427
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 6 -- M extension pill identity at native speed
prompt kg -- land Orbit 6 of the Mantrapod RV64G journey: prove djb2 hash under explicit -mcpu=generic_rv64+m, opening Quest 2 (Hardware Arithmetic)
think scouting revealed that Zig 0.17.0's default baseline_rv64 includes +a,+c,+d,+f,+i,+m -- effectively RV64GC. Quest 1's "RV64I" builds were actually RV64GC the whole time, carrying hardware multiply silently
think three CPU configurations proven with --verbose-llvm-cpu-features: default (baseline_rv64 = RV64GC), -mcpu=generic_rv64 (true RV64I, no M), -mcpu=generic_rv64+m (RV64IM only, no A/C/D/F)
think Quest 2's transition is not "add M to RV64I" but "switch from implicit RV64GC to explicit RV64IM" -- a narrower, more precise target that drops compressed, atomics, and float
think wrote m_ext_pill_witness.rish -- builds self_compile.rye with -mcpu=generic_rv64+m, verifies CPU features include +m and +zmmul, runs on qemu-system-riscv64, checks hash 0x079080D9, confirms mul instruction via llvm-objdump, measures wall time, and compares against the Quest 1 baseline
think timing uses python3 millisecond clock since macOS date lacks %N
obs djb2 hash 0x079080D9 matches on both RV64IM and the default RV64GC baseline -- the u32 discipline is not merely portable across register widths but also across ISA extensions. the hash operates entirely in u32 arithmetic, so the presence or absence of the M extension changes only the instruction selection, never the value
obs ELF sizes: RV64IM 8024 bytes vs RV64GC 7776 bytes -- slightly larger without compressed instruction encoding (the C extension shrinks common instructions to 16-bit forms)
obs build 437 ms, run 107 ms on QEMU. the run time is dominated by QEMU startup rather than pill execution, so a meaningful speedup measurement requires a longer-running workload (deferred to Orbit 8 with Amphora)
obs mul instruction count = 1 in disassembly, confirmed via /opt/homebrew/Cellar/llvm@22/22.1.8/bin/llvm-objdump -d --mattr=+m. without --mattr=+m the disassembler shows mul as <unknown>
rota none -- pure implementation, no rota this lap
orbit round 14 Taurus -- the bull steadies
[file](../../terrarium/m_ext_pill_witness.rish) Orbit 6 witness -- M extension pill identity, all proofs GREEN on metal
[file](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 6 marked GREEN with stamp, finding, and witness
[file](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md) Orbit 6 entry prepended
[file](../../construction/ITINERARY.md) fascia 60.088 -> 60.089 with Mantrapod RV64G Orbit 6
[file](../../README.md) fascia badge 60.088 -> 60.089
scope this session, this hand
status written before send
recommend kg -- Orbit 7 is mechanical: build the Glow calculator with -mcpu=generic_rv64+m and prove 144 / 12 and 7 * 8 evaluate correctly. the build recipe is established, the witness pattern is proven, and the SLC gate is written on the checklist
