format session-log-v1
stamp 20261105.140418
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 12 -- A extension atomic domain registry
prompt kg -- continue Mantrapod RV64G journey, Orbit 12 A extension atomic domain registry
think Orbit 12 extends A-extension atomics from per-slot capability grants (Orbit 11) to a domain-level registry with a full DomainSlot state machine: EMPTY(0) -> CLAIMING(1) -> ACTIVE(2) -> SHUTDOWN(3). Slot claiming uses cmpxchgWeak (lr.w/sc.w), state finalization uses atomicRmw .Xchg (amoswap.w), domain counting uses atomicRmw .Add/.Sub (amoadd.w), and census uses atomicLoad for a walk across all 8 slots.
think Wrote atomic_registry.rye with 8 DomainSlot shared table, two stewards (alpha=1, beta=2) registering 5 domains across slots 0-4, contesting slot 4 (first writer wins), shutting down 2, and verifying census matches the atomic counter at 3. djb2_hash for name integrity, 8 proofs total.
think Three build iterations: (1) helper initially used wrong zig path (vendor/zig-toolchain/zig/zig vs vendor/zig-toolchain/zig), (2) zig build-exe does not recognize .rye extension -- must use rye/bin/rye build wrapper with RYE_ZIG env var, (3) CPU features probe must use hello64.rye with -femit-bin=/dev/null, not the actual module. All three patterns were proven in Orbit 11 and applied directly.
obs DomainSlot state machine is richer than Orbit 11's CapSlot: 4 states vs 3, with CLAIMING as a transient state only the claiming steward holds, finalized by amoswap to ACTIVE. This models a two-phase commit -- lr/sc to claim, amoswap to finalize -- that maps directly to real-world domain registration where a name must be reserved before it is populated.
obs A-extension instruction census: 13 total -- 4 amoadd.w, 1 amoswap.w, 0 amosub.w, 4 lr.w, 4 sc.w. The amosub.w count of 0 is because Zig lowers @atomicRmw(.Sub) to amoadd.w with a negated operand rather than generating a dedicated amosub instruction.
obs Contested registration proves first-writer-wins: alpha claims slot 4 with cmpxchgWeak (EMPTY -> CLAIMING succeeds), beta's cmpxchgWeak on the same slot sees CLAIMING (non-EMPTY) and returns failure. The loser reports REFUSED, the winner finalizes to ACTIVE. This is the core registry integrity guarantee.
loom witness=atomic_registry_witness stages=4 proofs=8 a_ext_instructions=13 amoadd=4 amoswap=1 amosub=0 lr=4 sc=4 elf_bytes=10040
orbit round 12 Pisces -- the dissolve
[terrarium/src/atomic_registry.rye](../../terrarium/src/atomic_registry.rye) atomic domain registry with DomainSlot state machine, two-steward concurrent registration, 8 proofs
[terrarium/atomic_registry_helper.sh](../../terrarium/atomic_registry_helper.sh) shell helper with build and census stages for RV64IMA
[terrarium/atomic_registry_witness.rish](../../terrarium/atomic_registry_witness.rish) 4-stage Rishi witness: CPU features, build, QEMU 8-proof run, A-ext instruction census
[active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 12 marked complete
[active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md) Orbit 12 entry added
[construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.094 -> 60.095
recommend kg -- Orbit 13: multi-hart boot on QEMU with -smp 2, two harts coordinating via atomic spinlock
