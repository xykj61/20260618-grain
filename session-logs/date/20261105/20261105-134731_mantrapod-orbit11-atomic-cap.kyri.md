format session-log-v1
stamp 20261105.134731
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 11 -- A extension atomic capability table
prompt kg -- continue Mantrapod RV64G journey, Orbit 11 A extension atomic cap table
think Orbit 11 opens Quest 1.3 (Atomic Supervision). The module needs atomic grant via cmpxchgWeak (lr.w/sc.w), revoke via atomicRmw .Xchg (amoswap.w), and census via atomicRmw .Add (amoadd.w). Build target is -mcpu=generic_rv64+m+a for explicit RV64IMA.
think Wrote atomic_cap.rye with 8 CapSlot shared table, state machine FREE->GRANTED->REVOKED, two domains alpha(1) and beta(2), 7 proofs covering init, grants, revoke, contested grant, atomic census, and state consistency.
think Three build iterations to get the Zig 0.17 atomic builtins right: (1) array repeat operator whitespace issue -- replaced with explicit 8-element initialization, (2) Zig 0.17 requires explicit u32 type parameter as first argument to all atomic builtins, (3) AtomicRmwOp enum uses PascalCase (.Xchg, .Add) while AtomicOrder uses snake_case (.seq_cst). Confirmed by reading rye/lib/std/lang.zig.
think Helper script with build and census stages, witness with 4 stages: CPU features, build, QEMU run, and A-extension instruction census via llvm-objdump.
obs Zig 0.17 atomic builtin signatures: @cmpxchgWeak(u32, ptr, expected, desired, .seq_cst, .seq_cst) = 6 args; @atomicRmw(u32, ptr, .Xchg/.Add, value, .seq_cst) = 5 args; @atomicLoad(u32, ptr, .seq_cst) = 3 args; @atomicStore(u32, ptr, value, .seq_cst) = 4 args. The type parameter was NOT removed in Zig 0.12+ as previously believed -- 0.17 still requires it.
obs A-extension instruction census: 19 total -- 1 amoadd.w, 2 amoswap.w, 8 lr.w, 8 sc.w. The lr/sc count of 8 each reflects cmpxchgWeak retry loops the compiler generates. ELF 9120 bytes.
obs Contested grant proves first-writer-wins: alpha grants slot 6 (ok), beta contests same slot (REFUSED because state is already GRANTED). This is the core concurrency guarantee.
loom witness=atomic_cap_witness stages=4 proofs=7 a_ext_instructions=19 amoadd=1 amoswap=2 lr=8 sc=8 elf_bytes=9120
orbit round 11 Aquarius -- the carry
[terrarium/src/atomic_cap.rye](../../terrarium/src/atomic_cap.rye) atomic capability table with 3 A-extension operations, 7 proofs, 8 CapSlot shared table, two-domain concurrent access
[terrarium/atomic_cap_helper.sh](../../terrarium/atomic_cap_helper.sh) shell helper with build and census stages for RV64IMA
[terrarium/atomic_cap_witness.rish](../../terrarium/atomic_cap_witness.rish) 4-stage Rishi witness: CPU features, build, QEMU run, A-ext instruction census
[active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 11 marked complete
[active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md) Orbit 11 entry added
[construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.093 -> 60.094
recommend kg -- Orbit 12: A extension atomic domain registry, two-domain concurrent boot with registry consistency
