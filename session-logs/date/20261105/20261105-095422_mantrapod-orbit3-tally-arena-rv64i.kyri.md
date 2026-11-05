format session-log-v1
stamp 20261105.095422
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 3 -- Tally arena on RV64I
prompt kg -- land Orbit 3 of the Mantrapod RV64G journey: Tally's garden arena allocates and refuses on the 64-bit hart
think tally_arena.rye uses explicit u32 for all budgets, indices, and counts. the only pointer-width types are Zig's own [*]u8 and *volatile, which the compiler handles for the target. expecting zero source changes
think built with riscv64-freestanding-none -OReleaseSmall -mcmodel=medany -- compiled cleanly on the first attempt
think ran on qemu-system-riscv64: all four named errors (OutOfBounds, DuplicateName, NameEmpty, Full) proven, all invariants held, Orbit 16 complete
obs the explicit-width discipline continues to pay off -- three consecutive orbits have ported to RV64I with zero source changes because u32 budgets, u32 indices, and u32 hash arithmetic never touch the register width
obs Zig's pointer types ([*]u8, *volatile u8, *volatile u32) widen automatically to 64-bit addresses on the riscv64 target, so the MMIO addresses (UART 0x1000_0000, test finisher 0x0010_0000) remain correct
rota none -- pure implementation, no rota this lap
orbit round 11 Aquarius -- the water-bearer pours
[file](../../terrarium/tally64_witness.rish) Orbit 3 witness -- build, ceiling refusal, four named errors, ELF identity, GREEN on metal
[file](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 3 marked GREEN with stamp and witness
[file](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md) Orbit 3 entry prepended
[file](../../construction/ITINERARY.md) fascia 60.085 -> 60.086 with Mantrapod RV64G Orbit 3
[file](../../README.md) fascia badge 60.085 -> 60.086
scope this session, this hand
status written before send
recommend kg -- Orbit 4 is Aurora and Mantra on RV64I, the display and persistence layers
