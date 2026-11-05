format session-log-v1
stamp 20261105.151301
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 14 -- preemptive scheduling foundation
prompt kg after Orbit 13: land preemptive scheduling with CLINT timer, context save/restore, round-robin between two domains on a single hart
think Orbit 14 SLC gate: two domains time-slice on one hart, both produce correct output. Need M-mode timer interrupt via CLINT, full 31-register context save/restore through mscratch swap, round-robin scheduler switching between domain A and domain B.
think CLINT on QEMU virt: mtime at 0x200BFF8 (10 MHz), mtimecmp[0] at 0x2004000. Arm timer by writing mtime + timeslice to mtimecmp. Timer fires when mtime >= mtimecmp. Enable via mie bit 7 (MTIE) and mstatus bit 3 (MIE).
think Context save: on trap entry csrrw sp,mscratch,sp swaps stack pointer with context base. Save 31 GP regs (x1, x3-x31 via sd, x2/sp retrieved from mscratch) plus mepc into 32-slot array. Load scheduler stack, call handle_timer which rearms timer and returns pointer to next domain's context.
think Context restore: write new context to mscratch, restore mepc then all 31 regs in reverse. Final csrrw sp,mscratch,sp restores domain's sp. mret jumps to mepc with interrupts re-enabled via MPIE.
think Domain completion: each domain sets domain_done[i]=1 via atomicStore and spins. Scheduler checks both done on each timer tick -- when both done, disables MTIE and redirects mepc to print_verdict.
think Interrupt protection for UART: csrci mstatus,8 / csrsi mstatus,8 around print calls -- bit 3 is within the 5-bit CSR immediate range.
think Array init in Zig 0.17: the ** repeat operator has whitespace sensitivity. Used @import("std").mem.zeroes() for zero-initialized context arrays.
obs QEMU output shows genuine round-robin interleaving: domain A and B alternate perfectly (A:1, B:101, A:2, B:102, ...) with 12 context switches total for 10 items. Both checksums verified correct through all switches.
obs ELF is 7544 bytes -- compact for a full preemptive scheduler with 31-register context save/restore.
obs Census: 20 CSR instructions (2 mret, 2 csrrw, 3 csrr, 6 csrw, 2 csrci, 2 csrsi, 2 csrs, 1 csrc), 58 sd and 36 ld for context save/restore, 16 fence from atomic operations.
loom witness=preempt_witness stages=4 proofs=5 switches=12 elf_bytes=7544 csr_total=20 mret=2 sd=58 ld=36 fence=16
rota none -- pure implementation, no rota this lap
orbit round 14 Virgo -- the earth sign that stops, examines, and verifies
[terrarium/src/preempt.rye](../../terrarium/src/preempt.rye) preemptive round-robin scheduler with CLINT timer and full context save/restore
[terrarium/preempt_witness.rish](../../terrarium/preempt_witness.rish) 4-stage witness: features probe, build, QEMU 5-proof run, trap census
[terrarium/preempt_helper.sh](../../terrarium/preempt_helper.sh) census helper for mret, csr*, sd, ld instruction counts
recommend keep-going -- Orbit 15 (A extension integration witness) is the final orbit of Quest 1.3
