format session-log-v1
stamp 20261105.143315
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 13 -- multi-hart boot with atomic spinlock
prompt Keaton said kg -- Orbit 13 multi-hart boot, two harts coordinating via atomic spinlock on RV64IMA
think Two harts enter _start simultaneously on QEMU -smp 2. Each reads mhartid CSR via inline assembly to determine its role. Hart 0 (primary) gets stack at 0x80100000, hart 1 (secondary) at 0x80200000. Hart 0 initializes, then releases hart 1 by writing to an atomic gate variable via @atomicStore. Hart 1 spins on @atomicLoad until the gate opens.
think Hart 1 computes 7 * 6 = 42 as verifiable work, stores it via @atomicStore, then signals completion via @atomicRmw(.Add) on a shared done_count. Hart 0 spin-waits on done_count, reads back the work result, asserts it equals 42, then itself increments done_count to 2. Both harts confirmed.
think UART access is serialized by a ticket lock built from @cmpxchgWeak (lr.w/sc.w for ticket acquisition) and @atomicRmw(.Add) for ticket serving. This proves all four A-extension atomic operation families in one coordinating protocol. The interleaved output between proof 2 and 3 headers is genuine concurrent behavior -- two harts racing to the UART between lock regions.
obs 4 stages GREEN: CPU features probe, build (7128-byte ELF), QEMU -smp 2 with 5 proofs, A-extension census (29 instructions: 1 lr.w, 1 sc.w, 3 amoadd.w, 24 fence). This is the first multi-hart module in the Terrarium -- all prior orbits ran a single hart. The ticket lock pattern is directly usable for Caravan's future multi-hart supervisor.
obs The ticket lock serialized 11 UART accesses across two harts with zero deadlock. The gate pattern (atomicStore to release, atomicLoad to spin) is the simplest inter-hart synchronization primitive and maps directly to what a real microkernel's secondary hart wakeup would do.
[terrarium/src/multi_hart.rye](../../terrarium/src/multi_hart.rye) two-hart boot module: _start reads mhartid, per-hart stacks, atomic gate + ticket lock + done signaling
[terrarium/multi_hart64_witness.rish](../../terrarium/multi_hart64_witness.rish) 4-stage witness: features, build, QEMU -smp 2, A-ext census
[terrarium/multi_hart64_helper.sh](../../terrarium/multi_hart64_helper.sh) objdump census helper for lr.w, sc.w, amoadd.w, fence counts
loom witness=multi_hart64 proofs=5 a_ext_instructions=29 lr_w=1 sc_w=1 amoadd_w=3 fence=24 elf_bytes=7128 harts=2 ticket_accesses=11
orbit round 13 Capricorn -- the law that stops
recommend kg -- Orbit 14 next, or check in for Quest 1.3 direction
