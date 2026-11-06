**Status:** Landed -- checkable
**Room:** checkable
**Style:** Gauge at the Meter setting

# RV64G Performance Baseline on QEMU

**Stamp:** `20261105.203102` -- Mantrapod RV64G Orbit 24, Quest 1.5
**Source:** 19 freestanding RV64G ELF modules, each timed 3 runs with median reported
**Host:** arm64 macOS 26.6 (Apple Silicon)
**QEMU:** 11.1.3 (`qemu-system-riscv64 -machine virt -bios none`)
**Method:** `python3 -c 'import time; print(int(time.time()*1000))'` wall-clock ms, 3 runs per module, median

## QEMU Startup Overhead

Measured by timing the fastest module (`lotus_audio`, 6496 bytes) across 5 consecutive runs:

| Run | Wall ms |
|---|---|
| 1 (cold) | 116 |
| 2 | 46 |
| 3 | 45 |
| 4 | 47 |
| 5 | 47 |

**Warm overhead: ~46 ms.** This is process launch + machine init + minimal guest compute. Guest compute for any module is approximately `wall_clock - 46`.

## Wall-Clock Timing -- All 19 Modules

| Module | Median ms | Run 1 | Run 2 | Run 3 | ELF bytes |
|---|---|---|---|---|---|
| self_compile | 52 | 64 | 49 | 52 | 8,024 |
| tally_arena | 52 | 52 | 55 | 52 | 8,472 |
| aurora_console | 51 | 51 | 51 | 49 | 8,584 |
| mantra_log | 51 | 51 | 49 | 54 | 8,952 |
| caravan_cap | 52 | 51 | 58 | 52 | 11,704 |
| caravan_supervision | 55 | 56 | 50 | 55 | 12,184 |
| steward | 51 | 50 | 56 | 51 | 11,672 |
| glow_app | 52 | 52 | 52 | 51 | 12,104 |
| glow_m_ext | 52 | 54 | 49 | 52 | 6,816 |
| amphora_seal | 50 | 50 | 51 | 50 | 6,792 |
| atomic_cap | 52 | 51 | 57 | 52 | 9,120 |
| atomic_registry | 50 | 52 | 50 | 50 | 10,040 |
| glow_fp | 50 | 50 | 51 | 49 | 7,808 |
| fp_context | 139 | 139 | 139 | 138 | 8,912 |
| dimeroll_price | 49 | 52 | 49 | 47 | 6,512 |
| lotus_audio | 48 | 48 | 49 | 48 | 6,496 |
| multi_hart | 52 | 53 | 50 | 52 | 7,128 |
| preempt | 137 | 137 | 140 | 136 | 7,544 |
| mantra_wire | 3,030 | -- | -- | -- | 7,648 |

**mantra_wire** needs a host-side UART partner (the Terrarium Swift app) and was measured with a 3-second timeout; its wall-clock reflects the timeout rather than guest compute. Excluded from derived metrics.

**fp_context** (139 ms) and **preempt** (137 ms) are timer-driven preemptive schedulers with many context switches -- their ~90 ms of extra guest compute is load-bearing work rather than overhead.

## The Four Metrics

### 1. Boot Time

**18 modules in 1,095 ms total wall-clock** (mantra_wire excluded).

- QEMU overhead: 18 invocations x 46 ms = 828 ms
- Estimated guest compute: 1,095 - 828 = **267 ms** for 18 independent modules
- 9-stage core boot (pill through glow_app): 416 ms wall-clock, ~2 ms guest per stage
- Two preemptive schedulers add ~180 ms of real timer-driven compute

**Unit:** milliseconds wall-clock and estimated guest compute
**Date:** `20261105.202700`
**Source:** `measure_rv64g.sh` script, 3 runs per module
**What holds it still:** QEMU 11.1.3 on arm64 macOS; changes with QEMU version and host

### 2. Mantra Log Throughput

The `mantra_log` module appends 5 Kumara-signed boot facts with keyed djb2 hash, replays all 32 facts proving identical state hash `0xbc186e04`, tests LogFull ceiling at 32, and tests tamper refusal.

- Wall-clock: **51 ms** (median of 3 runs)
- Estimated guest compute: 51 - 46 = **5 ms**
- Work: 32 facts appended + full replay + 2 refusal tests
- Throughput: **~6,400 facts/sec** guest compute, **~630 facts/sec** wall-clock

**Unit:** facts per second
**Date:** `20261105.202700`
**Source:** `mantra_log_g.elf` output: "32 facts, replay identical, ceiling REFUSED, tamper REFUSED"
**What holds it still:** the 46 ms overhead estimate; guest throughput is approximate

### 3. Glow Evaluation Speed

The `glow_app` module boots Steward from a Brix manifest, creates a calculator domain under Caravan supervision with capabilities, then evaluates 10 Glow expressions including compound forms like `(+ (double 15) (half 24))`.

- Wall-clock: **52 ms** (median of 3 runs)
- Estimated guest compute: 52 - 46 = **6 ms** for the entire module
- Work: Steward boot + domain creation + 10 expression evaluations + 16 Mantra facts
- Throughput: **~1,700 expressions/sec** guest compute (upper bound -- includes full-stack boot)

The evaluation is embedded in a full Grain boot, so the per-expression rate is an upper bound. A bare evaluator loop would measure higher.

**Unit:** expressions per second
**Date:** `20261105.202700`
**Source:** `glow_app_g.elf` output: "correct: 10 of 10", "all expressions correct"
**What holds it still:** the full-stack boot includes Steward, Caravan, and Mantra overhead

### 4. Tally Allocation Rate

The `tally_arena` module creates a 4,096-byte Region, allocates 3 Gardens (capacity 3,584 bytes), performs blob allocations filling to ceiling, tests OutOfBounds refusal, clears, and tests DuplicateName/NameEmpty/Full refusals -- approximately 30 allocation operations.

- Wall-clock: **52 ms** (median of 3 runs)
- Estimated guest compute: 52 - 46 = **6 ms**
- Work: ~30 allocation operations (1 region + 3 gardens + ~20 blob fills + clear + 4 error tests)
- Throughput: **~5,000 ops/sec** guest compute, **~580 ops/sec** wall-clock

**Unit:** allocation operations per second
**Date:** `20261105.202700`
**Source:** `tally_arena_g.elf` output: "all invariants held"
**What holds it still:** the 46 ms overhead estimate; operation count is approximate

## Summary Table

| Metric | Wall-clock | Guest compute | Unit | Source module |
|---|---|---|---|---|
| Boot time (18 modules) | 1,095 ms | ~267 ms | ms | all 18 |
| Mantra log throughput | 51 ms / 32 facts | ~6,400 facts/sec | facts/sec | mantra_log |
| Glow evaluation speed | 52 ms / 10 exprs | ~1,700 exprs/sec | exprs/sec | glow_app |
| Tally allocation rate | 52 ms / ~30 ops | ~5,000 ops/sec | ops/sec | tally_arena |

## What This Baseline Means for the Browser

A browser-hosted WASM emulator (Path D, grain-emu at 120-140 MIPS in Chromium) will run these same ELFs. The guest compute times above are what the emulator replaces -- QEMU's overhead disappears, replaced by the WASM runtime's own. The 267 ms of guest compute across 18 modules is the work a browser emulator must perform, and at 120 MIPS that work fits comfortably in interactive latency.

## Total ELF Footprint

19 modules, **166,512 bytes** (162 KiB). Range: 6,496 bytes (lotus_audio) to 12,184 bytes (caravan_supervision). A browser emulator loads these into WASM memory -- the entire Grain OS fits in a fraction of a typical web page's JavaScript bundle.
