format session-log-v1
stamp 20261105.172652
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 17 -- Caravan FP context save/restore on RV64FD
prompt kg from Orbit 16; land Orbit 17 -- Caravan saves and restores f0-f31 and fcsr on context switch, two FP domains produce correct checksums under preemptive scheduling
think the extended context needs 65 slots: 30 GP regs (x1-x4, x6-x31, skipping x0 and x5/t0 scratch) + mepc + 32 FP regs (f0-f31) + fcsr = 520 bytes
think fsd/fld instructions for FP register save/restore, frcsr/fscsr for FP control status register
think domain A computes sum of 0.75*i for i=1..5 (checksum 1875 as integer), domain B computes sum of 7.50*i for i=1..5 (checksum 15750 as integer)
think @atomicLoad(u32, ptr, .seq_cst) on riscv64-freestanding-none compiles to a call to __atomic_load_4 -- since no libatomic exists, the linker creates a self-referential stub that calls itself, overflowing the scheduler stack into the data section and corrupting context arrays
think the compiler placed ctx_b before ctx_a in memory, so ctx_b[31] (mepc at offset 248) was the first slot the overflow reached, explaining the illegal instruction exception at a non-instruction-boundary address 0x80000e6a
think fix: replace @atomicLoad/@atomicStore with volatile pointer casts -- @as(*volatile u32, ptr).* for loads, @as(*volatile u32, ptr).* = val for stores -- these generate inline lw/sw instructions
obs @atomicLoad infinite recursion on freestanding is a fundamental Zig/LLVM limitation -- riscv64-freestanding-none has no libatomic, and the compiler emits a call to a function the linker can only stub as self-recursive; single-hart preemptive scheduling only needs volatile access, not full seq_cst atomics
obs extended context layout: slots 0-30 GP regs, slot 31 mepc (offset 0xF8=248), slots 32-63 f0-f31 (offsets 0x100-0x1F8=256-504), slot 64 fcsr (offset 0x200=512)
obs FP census: 105 instructions (40 fsd, 33 fld, 5 fadd.d, 5 fmul.d, 5 fcvt, 15 fmv, 2 flt.d), 8912-byte ELF
obs all 6 in-program proofs pass: timer armed (12 switches >= 2), domain A checksum 1875, domain B checksum 15750, preemption verified (12 > 5), FP register integrity, context size 65 slots = 520 bytes
obs witness all 4 stages GREEN: CPU features (+m+f+d), build 8912-byte ELF, QEMU 10-proof run, FP context instruction census 105 FP instructions
file [terrarium/src/fp_context.rye](../../terrarium/src/fp_context.rye) Orbit 17 main module -- 65-slot extended context with FP save/restore, volatile pointer casts replacing @atomicLoad/@atomicStore
file [terrarium/fp_context_helper.sh](../../terrarium/fp_context_helper.sh) build and FP instruction census helper for Orbit 17
file [terrarium/fp_context_witness.rish](../../terrarium/fp_context_witness.rish) 4-stage witness with 10 proof assertions, GREEN on metal
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 17 checked off with landing details
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.099 -> 60.100, Orbit 17 description added
recommend keep-going -- Orbit 18 (Dimeroll price arithmetic on RV64FD) is next in Quest 1.4
