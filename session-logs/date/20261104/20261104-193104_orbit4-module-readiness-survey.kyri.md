format session-log-v1
stamp 20261104.193104
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 4 -- module readiness survey for freestanding RV32I
prompt kg (continue Terrarium boot journey -- Orbit 4 module readiness survey)
think Seven modules touch the boot sequence: Aurora, Tally, Mantra, Caravan, Glow, Rye, Rishi. Survey each for hosted dependencies, std usage, allocation patterns, syscall assumptions, and what a freestanding RV32I port requires.
think Forked five parallel agents to survey Aurora+Tally, Mantra, Caravan, Glow, and Rye+Rishi concurrently. Each agent read the module's source files, grepped for std imports beyond std.debug and std.mem, counted usize sites, and identified I/O and allocation patterns.
think Three patterns repeat across every module that needs work: (1) entry point -- std.process.Init becomes _start naked, (2) allocator -- init.arena becomes static buffer garden, (3) I/O -- std.Io.File.stdout becomes UART write at 0x10000000. Each is solved once in a shared terrarium/src/ platform module.
obs Aurora and Tally are already freestanding-ready: zero heap allocation in library core, zero syscalls, zero file I/O. Crypto (std.crypto) needs only a compile test on rv32.
obs Mantra is partially ready: weave/diff logic is pure computation over arenas, but the persistence layer (store.rye) uses std.Io.Dir for file I/O. Port cost 2-3 orbits to abstract persistence behind a trait.
obs Glow is partially ready: lowerers run on the host and need no port, but the emitted code assumes a hosted target (std.process.Init entry, init.arena allocator, std.Io.File.stdout). Port cost 2-3 orbits for a freestanding codegen backend.
obs Caravan is not ready: it IS the process supervisor, with ~100 files using std.process and 97 std.Io call sites. Port cost 8-12 orbits to replace process supervision with hart/thread supervision and filesystem notes with in-memory or MMIO-mapped state.
obs Total estimated port cost: 12-18 orbits beyond the current journey. Critical path: Aurora -> Tally -> Glow freestanding backend -> Mantra persistence abstraction -> Caravan re-architecture.
orbit round 14 Pisces -- survey the depth before building further
file [active-development/date/20261104/20261104-192809_terrarium-rv32i-module-readiness-survey.md](../../active-development/date/20261104/20261104-192809_terrarium-rv32i-module-readiness-survey.md) gap analysis with per-module tables naming every gap, severity, and proposed orbit
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) marked Orbit 4 done
recommend keep-going -- Orbit 4 SLC gate met; Orbit 5 (developer workflow and DX foundations) is next
