# Terrarium -- Module Readiness Survey for Freestanding RV32I

**Status:** Checkable -- every claim names its source
**Room:** active-development (scopes a round; would not outlive the code)
**Stamp:** `20261104.192809`
**Journey:** Terrarium boot journey, Orbit 4
**Board:** `active-tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md`

This survey names every gap between the current hosted codebase and a
freestanding RV32I target (`riscv32-freestanding-none`). Each module
that the boot sequence touches is measured against four questions:
hosted dependencies, allocation patterns, syscall assumptions, and
width assumptions. The gap table at the end names severity, proposed
orbit, and estimated line cost.

## Method

Each module room was surveyed by reading its source files, grepping
for `std.*` imports beyond `std.debug` and `std.mem`, counting `usize`
sites, and identifying allocation and I/O patterns. Line counts come
from `find <room>/src -name '*.rye' | xargs wc -l` (or the flat room
equivalent). The target is `riscv32-freestanding-none` -- no OS, no
filesystem, no process model, no network. UART at `0x10000000` and a
static RAM region at `0x80000000` are the only I/O.

---

## Aurora (11 files, ~600 lines)

**Verdict: READY -- zero heap, zero syscalls, zero file I/O.**

Aurora is already freestanding RV64. The Terrarium hello program
(Orbit 3) proved the RV32I adaptation path.

| Gap | Files affected | Severity | Notes |
|---|---|---|---|
| `std.crypto` (SHA3, X25519, ChaCha20, Ed25519) | named, sealed, posted, kumara | Low | Pure Zig crypto, no OS deps; needs compile test on rv32 |
| `usize` for CSR values | relay, deciding | None | `usize` maps to XLEN; correct on both rv32 and rv64 |
| `std.debug.print` in selftest paths | kumara | None | Selftest only; library core is pure |

**Port cost: 0 orbits.** Library core works as-is. Crypto compile
test rides along with any orbit that imports these modules.

---

## Tally (18 files, 1,748 lines)

**Verdict: READY -- pure computation over caller-provided buffers.**

Tally's library functions (copy, region, gardens, stack, bud, kumara,
receipt bounds, parse_int, maybe, str_repeat, no_padding) operate on
caller-provided `[]u8` buffers with no OS interaction.

| Gap | Files affected | Severity | Notes |
|---|---|---|---|
| `std.process.Init` entry points | 9 witness harnesses | None | Witnesses only; library API is importable directly |
| `std.Io` for stdout | selftest harnesses, seed | None | Harness only; not in library core |
| `std.crypto` (Ed25519, SHA3) | bud | Low | Pure Zig crypto; needs compile test |
| `init.arena` as allocator source | gardens consumers | Low | Replace with static buffer on freestanding |

**Port cost: 0 orbits.** Library functions are already freestanding.
Consumers pass a static `[N]u8` buffer to `gardens` instead of
`init.arena`.

---

## Mantra (32 files, 10,810 lines)

**Verdict: PARTIALLY READY -- weave/diff logic is pure; persistence
layer is hosted.**

Mantra's computation core (diff, weave, merge) operates on slices
with arena allocation. The persistence layer (`store.rye`) uses
`std.Io.Dir` for file I/O, which is the critical blocker.

| Gap | Files affected | Severity | Notes |
|---|---|---|---|
| `std.Io` / `std.Io.Dir` file I/O | store, main, weave_tablecloth | **Critical** | Entire persistence layer reads/writes files |
| `std.crypto.hash.sha3.Sha3_256` | store, main, weave_tablecloth | High | Content-addressed blob naming; ~3 call sites |
| `std.fmt.bufPrint` / `allocPrint` | store, main, weave_tablecloth | Medium | Serialization; ~10 call sites; replaceable |
| `std.ArrayListUnmanaged` | diff, main, weave | None | Takes allocator param; works with any allocator |
| `usize` at seam boundaries | throughout | None | Seam-only per TAME; internal widths are u32 |

**Port cost: 2-3 orbits.**
- Orbit A: abstract persistence layer behind a trait (in-memory or
  block-device backing replaces `std.Io.Dir`). ~200 lines affected.
- Orbit B: replace or vendor SHA3 (~3 sites) and `std.fmt` (~10
  sites).
- Orbit C: integration test on rv32 freestanding.

---

## Caravan (114 files, 300,762 lines)

**Verdict: NOT READY -- almost entirely hosted. Caravan IS the process
supervisor; its core function assumes an OS.**

Caravan spawns, monitors, and coordinates dependent processes through
filesystem notes. On freestanding RV32I there are no processes, no
filesystem, and no sleep syscall. The data structures (systems,
cohorts, ladder checks) can port; the I/O and process model cannot.

| Gap | Files affected | Severity | Notes |
|---|---|---|---|
| `std.process.Init` / `std.process.spawn` | ~100+ files | **Critical** | Core supervision model is process-based |
| `std.Io` (Dir, open, sleep, Duration) | 97 call sites | **Critical** | Pervasive file I/O and timer usage |
| `std.Io.Dir` for note coordination | entrust, refer, seat, read | **Critical** | Inter-process state via filesystem |
| `std.Io.sleep` with Duration | polling loops | High | No sleep syscall on freestanding |
| `usize` at seam boundaries | 20+ sites | None | Seam-only; safe for rv32 |

**Port cost: 8-12 orbits.**
- Replace process supervision with hart/thread supervision.
- Replace filesystem notes with in-memory or MMIO-mapped state.
- Replace sleep with timer interrupt or busy-wait.
- Data structures (ladder checks, cohorts) port with the allocator
  swap alone.

---

## Glow (140 files, 39,795 lines)

**Verdict: PARTIALLY READY -- lowerers run on the HOST; emitted code
needs a freestanding backend.**

Glow compiles in two stages: lowerers run on the host and emit Rye
source; Rye compiles the emitted source to native. The lowerers
themselves need no port. The emitted output currently assumes a hosted
target.

| Gap | Files affected | Severity | Notes |
|---|---|---|---|
| Emitted `std.process.Init` entry | all lowered programs | **Critical** | Generated `main()` needs `_start()` naked on freestanding |
| Emitted `init.arena.allocator()` | all lowered programs | **Critical** | Needs fixed-buffer allocator over known RAM |
| Emitted `std.Io.File.stdout()` | all lowered programs | High | Needs UART write on freestanding |
| `usize` in lowerers | 76 files (heavy in lower_shape) | Low | Seam casts; `usize` is 32 on rv32, moderate risk |

**Port cost: 2-3 orbits.** Add a freestanding code-generation backend
to the lowerers that emits `_start`, UART I/O, and a static buffer
allocator. The lowerer logic and the Glow language semantics are
unchanged.

---

## Rye compiler and runtime

**Verdict: NO GAP.** `rye/lib/` is the vendored Zig standard library
(v0.17.0). Zig supports `riscv32-freestanding-none` as a first-class
target, proven in Orbit 3. The freestanding subset of `std` (mem,
math, debug.assert, fmt) is available. No authored Rye runtime code
needs porting.

---

## Rishi

**Verdict: NO PORT NEEDED.** Rishi is the host-side orchestration
shell. It runs build scripts, witness passes, and fleet tooling on
the development machine. It never runs on the target.

---

## Summary gap table

| Module | Lines | Hosted deps | Severity | Port orbits | Critical blocker |
|---|---|---|---|---|---|
| **Aurora** | 600 | std.crypto (3 files) | Ready | 0 | none |
| **Tally** | 1,748 | none in library core | Ready | 0 | none |
| **Mantra** | 10,810 | std.Io.Dir (persistence) | Partial | 2-3 | file I/O abstraction |
| **Glow** | 39,795 | emitted code (entry, I/O, alloc) | Partial | 2-3 | freestanding codegen backend |
| **Caravan** | 300,762 | std.process, std.Io (pervasive) | Not ready | 8-12 | process model re-architecture |
| **Rye** | vendored | n/a | Ready | 0 | none |
| **Rishi** | host-only | n/a | N/A | 0 | none |

**Total estimated port cost: 12-18 orbits** beyond the current
Terrarium journey's scope.

## The critical path

The boot sequence to Caravan on freestanding RV32I follows this
dependency order:

1. **Aurora** (ready) -- bare-metal boot, UART, crypto identity
2. **Tally** (ready) -- bounded allocation, copy, region management
3. **Glow freestanding backend** (2-3 orbits) -- programs that run on
   the target need the freestanding codegen
4. **Mantra persistence abstraction** (2-3 orbits) -- the weave must
   persist without a filesystem
5. **Caravan re-architecture** (8-12 orbits) -- the supervisor must
   manage harts instead of processes

Steps 1-2 can begin immediately. Steps 3-4 are independent and can
run in parallel. Step 5 depends on all prior steps.

## Three patterns that repeat

Three gaps appear in every module that needs work, and solving each
once gives every module the answer:

1. **Entry point.** `std.process.Init` / `pub fn main` becomes
   `_start` naked with a static stack. Terrarium's `hello.rye`
   already demonstrates this pattern.
2. **Allocator.** `init.arena.allocator()` becomes a `garden` over a
   static `[N]u8` in `.bss`. Tally's `region.rye` already implements
   the bounded-buffer allocator.
3. **I/O.** `std.Io.File.stdout()` becomes UART write at
   `0x10000000`. Terrarium's `hello.rye` already demonstrates this.

Each of these is solved once in a shared `terrarium/src/` platform
module and imported by every freestanding consumer.
