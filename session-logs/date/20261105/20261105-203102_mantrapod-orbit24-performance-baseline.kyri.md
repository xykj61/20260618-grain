format session-log-v1
stamp 20261105.203102
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 24 -- performance baseline on QEMU
prompt kg -- Orbit 24: measure boot time, Mantra log throughput, Glow evaluation speed, and Tally allocation rate on RV64G QEMU
think Each of the 19 RV64G ELFs was timed 3 runs with median reported using python3 ms timestamps. QEMU 11.1.3 on arm64 macOS, warm startup overhead ~46 ms per invocation (measured via 5 consecutive runs of fastest module lotus_audio). Guest compute is wall_clock minus overhead. Two modules are outliers: fp_context at 139 ms and preempt at 137 ms, both doing timer-driven preemptive scheduling with many context switches -- load-bearing work rather than overhead.
think Four derived metrics: boot time (18 modules in 1095 ms wall / ~267 ms guest), Mantra log throughput (~6400 facts/sec guest from 32 facts in 5 ms), Glow evaluation speed (~1700 exprs/sec guest from 10 expressions in 6 ms, upper bound since it includes full-stack boot), Tally allocation rate (~5000 ops/sec guest from ~30 operations in 6 ms).
obs QEMU startup overhead dominates -- 828 ms of the 1095 ms total is process launch and machine init, leaving only 267 ms of actual guest compute across 18 modules. This means a browser emulator at 120-140 MIPS (grain-emu's measured throughput) handles the guest work comfortably. The 162 KiB total ELF footprint is a fraction of a typical web page's JavaScript.
orbit round 11 Scorpio -- Eliminate
file [active-development/date/20261105/20261105-203102_rv64g-performance-baseline.md](../../active-development/date/20261105/20261105-203102_rv64g-performance-baseline.md) performance baseline document with all four metrics, unit, date, source, what holds it still
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 24 marked PROVEN
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.106 -> 60.107, Orbit 24 description appended
recommend keep-going -- Orbit 25 next: Act I completion witness and Act II scoping
