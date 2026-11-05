# Terrarium Boot Journey -- Master Checklist

**Journey: From a Cold Hart to a Living World Under Glass**
**Stamp:** `20261104.161857`
**Captain:** Incense
**Target ISA:** RV32I (minimal 32-bit integer-only RISC-V)
**Planning:** Calfive -- 5 quests of 5 orbits each, 25 orbits total
**Grows from:** Aurora's six proven stages (seed through sealed datagram on `qemu-system-riscv64`),
Caravan's supervision modules, Tally's bounded allocation, Mantra's event log, the Mantrapod
composition, DJINN's grain-www proof (studied with gratitude), the single-stranded foundation,
and Urbit's pill-to-Arvo boot inspiration reapplied to a real hardware ISA.

---

## Quest 1.1 -- The Clearing (DX, restructuring, and build readiness)

*Before the first line of assembly, the tree earns its own clearing. Gall's Law says the
simple system that works comes first, and that system starts with a tree a developer can
navigate. These orbits propose molt-breaches for the living `20260618` tree, each bounded
and each reversible.*

- [x] **Orbit 1 -- Root directory consolidation survey** (landed `20261104.164623`)
  Walk the 89 root directories. For each, name: what it holds, how many tracked files,
  inbound reference count, whether it belongs at root or under a parent room. Produce a
  consolidation proposal -- which directories merge, which stay, which new parent rooms
  open -- following single-stranded (each room about one thing) and the Comlink tendency
  (the clearest name). The survey is the deliverable; no files move yet.
  **Molt-breach proposals** (each circled separately on Keaton's word):
  - Merge the three astrology rooms (`classical-vedic-astrology/`, `cubist-bhakti-astrology/`,
    `shastra/`) under one `jyotish/` parent
  - Merge study rooms (`study/`, `programming/`, `rye-learning-process/`) under `learning/`
  - Merge documentation rooms (`docs/`, `docs-geode/`, `manual/`, `nixos-guide/`) under `docs/`
    with subdirectories
  - Move `bat/`, `edu/`, `press/`, `saga/`, `spellbook/` under a `projects/` or topical parent
  **SLC gate:** a survey document in `active-development/` naming every root directory with
  its verdict (keep / merge / move), inbound reference counts, and the proposed tree shape.

- [x] **Orbit 2 -- Nock pipeline archive and Glow backend pivot**
  Archive `glow/nock/` (9 files -- the Nock compilation pipeline) to `gratitude/` as a
  historical artifact with attribution. Update `glow/README.md` to name the new direction:
  Glow -> RV32I assembly, with Nock as an optional interop target only. Remove any living
  references that point at `glow/nock/` as the active compilation path.
  **SLC gate:** `glow/nock/` moved to `gratitude/glow-nock-archive/` with a README naming
  the reason; `glow/README.md` names the RV32I backend direction; zero living references
  point at the old path as the active pipeline.

- [x] **Orbit 3 -- RV32I cross-compilation toolchain**
  Establish a working RV32I build path: a cross-compiler (GCC or LLVM targeting
  `riscv32-unknown-elf`), a linker, QEMU `qemu-system-riscv32`, and a minimal linker
  script. Prove the toolchain by building and running a bare-metal "hello UART" in C or
  assembly. Document the toolchain in `docs-geode/` (Bhakta at Door) so a newcomer can
  set it up cold.
  **SLC gate:** a bare-metal RV32I program builds, runs on `qemu-system-riscv32`, prints
  to the UART, and exits cleanly; a `docs-geode/` page walks through the setup.

- [x] **Orbit 4 -- Module readiness survey for freestanding RV32I**
  Survey each module room that the boot sequence touches (Aurora, Tally, Mantra, Caravan,
  Glow, Rye, Rishi) and name: hosted dependencies, `std` usage, allocation patterns,
  syscall assumptions, and what a freestanding RV32I port requires. Produce a gap analysis
  per module with line counts and estimated orbit cost.
  **SLC gate:** a survey document in `active-development/` with a table per module naming
  every gap, its severity, and its proposed orbit.

- [x] **Orbit 5 -- Developer workflow and DX foundations** (landed `20261104.200217`)
  Land the DX improvements the surveys proposed. At minimum: a `Makefile` or `build.rish`
  that builds, runs, and tests an RV32I target from the tree root; a `.lap/` convention
  document; a `MAP.md` update reflecting any root consolidation landed in Orbit 1. Prove
  the workflow by having a fresh clone build and run the Orbit 3 hello program.
  **SLC gate:** `git clone` + one documented command builds and runs the RV32I hello on
  QEMU; `MAP.md` reflects the current tree shape.

## Quest 1.2 -- The Glass and the Seed (Terrarium shell + RV32I Aurora port)

*The glass before the world inside it. A macOS native application wraps QEMU RISC-V
emulation, and Aurora's proven stages port to the smaller ISA.*

- [x] **Orbit 6 -- Terrarium macOS application shell** (landed `20261104.194849`)
  A native macOS window (AppKit or SwiftUI) that launches `qemu-system-riscv32` as a
  dependent process and captures its framebuffer or serial output. The glass you look
  through. Prove the window opens, QEMU starts, and the Orbit 3 hello program speaks
  through the glass.
  **SLC gate:** Terrarium launches on macOS, QEMU starts inside it, and the hello
  program's console output appears in the window.

- [x] **Orbit 7 -- RV32I Aurora seed port** -- landed `20261104.195858`
  Port Aurora's existing seed (`aurora/src/seed.rye`) from RV64 to RV32I. One hart
  wakes on `qemu-system-riscv32 -machine virt`, gives itself a stack, speaks over the
  console, and rests. The same seed, the smaller ISA.
  **SLC gate:** `aurora/run.sh seed` builds and runs on RV32I; the seed speaks and
  exits cleanly in Terrarium.

- [x] **Orbit 8 -- RV32I relay and named stages** -- landed `20261104.200223`
  Port the relay and named stages to RV32I. The relay passes a named value between
  stages; the named stage hashes a message with SHA3-512 on the bare hart. Prove the
  crypto runs on the 32-bit ISA.
  **SLC gate:** `aurora/run.sh relay` and `aurora/run.sh named` both GREEN on RV32I;
  content-name matches the hosted test byte for byte.

- [x] **Orbit 9 -- Terrarium display integration**
  Terrarium captures Aurora's framebuffer output (via QEMU's `-display` or shared memory)
  and renders it in the native macOS window. The boot is no longer serial-only -- the
  glass shows what Aurora draws.
  **SLC gate:** Aurora draws a rectangle or status line on the RV32I framebuffer and
  Terrarium's macOS window shows it.

- [x] **Orbit 10 -- Terrarium wire protocol (host-guest channel)**
  Establish the Comlink wire between Terrarium (HOST) and the RV32I guest -- virtio,
  shared memory, or a serial protocol. Prove bidirectional communication: the guest
  sends a fact, the host acknowledges. This wire carries Mantra facts in Quest 1.4.
  **SLC gate:** a message sent from the RV32I guest arrives at the Terrarium host and
  a response travels back; the round-trip is logged on both sides.

## Quest 1.3 -- The Pill (Glow -> RV32I compilation and self-hosting)

*The first language in the pill: Glow compiles to RISC-V assembly, and that assembly
runs on the bare hart. By the end, the pill compiles itself.*

- [x] **Orbit 11 -- Minimal Glow-to-RV32I code generator** (`327fd6939`, `20261104`)
  A Glow program compiles to RV32I assembly (directly from Glow's compiler pipeline --
  not through Rye or Zig). The generated code runs freestanding on QEMU. Start with the
  simplest possible program: a Glow expression that evaluates to a number, and the
  generated assembly writes that number to the UART.
  **SLC gate:** a Glow source file compiles to a `.S` file, assembles to an ELF, runs
  on `qemu-system-riscv32`, and prints the correct value.

- [x] **Orbit 12 -- Glow stdlib operations in generated RV32I** (`20261104`)
  Extend the code generator to handle Glow stdlib operations proven in the glow-language
  journey: arithmetic (double, inc, dec), number ops (square, half, negate), conditionals
  (?:), and face bindings (=/). Each operation compiles and runs freestanding.
  **SLC gate:** at least 6 Glow programs from `glow/gen/` compile to RV32I and produce
  correct output on QEMU.

- [ ] **Orbit 13 -- Rye freestanding RV32I module**
  A Rye source file compiles to a freestanding RV32I ELF (extending Aurora's existing
  freestanding build). Prove a small Rye module -- a bounded array with assertions --
  runs on the bare 32-bit hart.
  **SLC gate:** a Rye `.rye` file builds freestanding for RV32I, runs on QEMU, and
  the assertions pass.

- [ ] **Orbit 14 -- Rishi bootstrap interpreter and self-compile survey**
  A minimal Rishi interpreter runs inside the pill -- enough to orchestrate `run`
  commands, check `ok`, and sequence the boot. Freestanding on RV32I. In the same
  orbit, survey the gap between the current code generator and self-compilation:
  which Glow features the compiler uses that the RV32I backend does not yet handle.
  **SLC gate:** a Rishi script inside the pill calls three stages in order on QEMU;
  a gap analysis document names every missing feature with line counts.

- [ ] **Orbit 15 -- Self-compile proof (Stage 1: the keystone)**
  The pill carries the Glow, Rye, and Rishi compilers as Amphora-sealed vessels --
  content-addressed, hash-identified. On boot, the Rishi interpreter orchestrates:
  each compiler compiles its own source code. The output is sealed and its hash
  compared against the vessel that compiled it. Identity proves the compilers are real.
  This is the journey's keystone orbit.
  **SLC gate:** the self-compile runs on QEMU RV32I and each compiled output's
  Amphora hash matches the sealed vessel that compiled it.

## Quest 1.4 -- The TAME Boot (safety, then visibility, then replay)

*The pill can rebuild itself. Now each subsystem arrives in the order TAME demands:
Tally first (safety), Aurora second (visibility), Mantra third (replay). Every stage
from here is bounded, observable, and recorded.*

- [ ] **Orbit 16 -- Tally arena on freestanding RV32I (Stage 2)**
  Port Tally's garden arena allocator to freestanding RV32I. A bounded arena with a
  named budget, ceiling enforcement, and named error on overflow. No heap; the arena
  owns all memory the system will ever use.
  **SLC gate:** a freestanding RV32I program allocates from a Tally arena, hits the
  ceiling, receives a named error, and the console reports the budget and the refusal.

- [ ] **Orbit 17 -- Aurora framebuffer and console on RV32I (Stage 3)**
  Aurora draws to a framebuffer on the bare RV32I hart -- a rectangle, a glyph, a boot
  status line. The framebuffer memory is bounded by Tally. Aurora provides a text console
  over the framebuffer; every boot stage from here speaks through it.
  **SLC gate:** the boot sequence from pill through Tally speaks through Aurora's console,
  visible in Terrarium's window; framebuffer allocation is bounded by Tally's arena.

- [ ] **Orbit 18 -- Mantra event log on freestanding RV32I (Stage 4)**
  Mantra's append-only event log runs on the bare hart, each fact signed by Kumara
  (the identity and signing layer). Facts are appended, and a replay of the log
  produces identical state. Allocation is bounded by Tally; display goes through Aurora.
  **SLC gate:** a sequence of Kumara-signed Mantra facts appended during boot replays
  to identical state, proven by hash comparison, visible on Aurora's console.

- [ ] **Orbit 19 -- Mantra persistence through the wire**
  Mantra facts sync through the wire established in Orbit 10. The green line between
  Terrarium and a pier. A sync appends facts; a replay on the other side produces the
  same state.
  **SLC gate:** facts written inside the emulated machine travel out through the wire
  and replay identically on the host side.

- [ ] **Orbit 20 -- TAME boot integration witness**
  A single witness proves the TAME boot sequence: pill -> self-compile -> Tally ->
  Aurora -> Mantra, with every stage bounded, observable, and recorded. The witness
  runs the full boot on QEMU RV32I inside Terrarium.
  **SLC gate:** `terrarium/tame_boot_witness.rish` runs GREEN, proving every stage
  from pill through Mantra completed with its invariants intact.

## Quest 1.5 -- The Living World (Caravan, Steward, and the first Grain application)

*The boot is proven: self-compiling, bounded, visible, recorded. Now the microkernel
arrives, and a living world opens under glass.*

- [ ] **Orbit 21 -- Caravan capability model on RV32I (Stage 5)**
  Port Caravan's capability and domain model to freestanding RV32I. Each domain runs
  inside a Pond enclosure with named capabilities and bounded leases; a capability
  can be conferred and revoked. Allocation bounded by Tally, displayed by Aurora,
  logged by Mantra.
  **SLC gate:** a domain creates a capability, confers it to a dependent, the
  dependent exercises it, and the capability expires -- all visible on Aurora's console
  and recorded in Mantra's log.

- [ ] **Orbit 22 -- Caravan process supervision**
  Caravan supervises dependent processes. A dependent that exceeds its lease or its
  allocation budget is stopped. The supervisor's own allocation is bounded separately
  from its dependents'.
  **SLC gate:** a supervised dependent exceeds its Tally budget, Caravan stops it,
  and the event is logged in Mantra and displayed on Aurora's console.

- [ ] **Orbit 23 -- Steward: the root supervisor**
  Steward is the first process Caravan supervises -- the root supervisor that reads
  the Brix manifest and brings up domains. Steward loads a minimal manifest (one
  domain, one capability) and reports success through Aurora.
  **SLC gate:** Caravan boots, starts Steward, Steward reads a Brix manifest, and
  the domain comes up -- visible in Terrarium's window.

- [ ] **Orbit 24 -- First Grain application**
  A Glow application (a calculator or REPL) runs in Grain userspace under Caravan's
  supervision. It receives input through Terrarium, computes, and displays output
  through Aurora. Every allocation bounded by Tally, every event logged by Mantra,
  every capability granted by Caravan.
  **SLC gate:** a user types an expression in Terrarium's window, the Glow calculator
  evaluates it inside the emulated RV32I machine, and the result appears on screen.

- [ ] **Orbit 25 -- Full boot witness and RV64G horizon scoping**
  A single witness proves the complete boot sequence: pill -> self-compile -> Tally ->
  Aurora -> Mantra -> Caravan -> Steward -> userspace application. The witness runs
  on QEMU RV32I inside Terrarium and every stage is visible, bounded, and logged.
  In the same orbit, scope the next journey: RV32I living inside RV64G per Gall's
  Law, carrying its bounded discipline into the larger address space.
  **SLC gate:** `terrarium/boot_witness.rish` runs GREEN, proving every stage
  completed with its invariants intact; a scoping document for the RV64G journey
  lives in `active-development/`.

---

**Fascia:** each proven orbit advances the fascia by `0.001` per the health model.
**Witness discipline:** every SLC gate names a witness that runs GREEN on metal (QEMU
counts as metal for an emulated ISA). A stage claimed without a witness is a stage
not landed.
**Calfive:** Quest = 5 orbits. Journey = 5 quests (25 orbits). Round formula:
`(count - 1) % 15 + 1`. The journey's orbit count is `25`, which is one full quest
of the Calfive chapter calendar.
