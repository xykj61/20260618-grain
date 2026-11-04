# Terrarium Boot Journey -- Master Checklist

**Journey: From a Cold Hart to a Living World Under Glass**
**Stamp:** `20261104.161857`
**Captain:** Incense
**Target ISA:** RV32I (minimal 32-bit integer-only RISC-V)
**Grows from:** Aurora's six proven stages (seed through sealed datagram on `qemu-system-riscv64`),
Caravan's supervision modules, Tally's bounded allocation, Mantra's event log, the Mantrapod
composition, and Urbit's pill-to-Arvo boot inspiration reapplied to a real hardware ISA.

---

## Journey 1 -- The Pill (RV32I self-compiling seed)

The smallest binary that contains its own compilers and can rebuild itself on RV32I.
This is the Urbit pill concept applied to real silicon: a RISC-V binary that carries
the Glow, Rye, and Rishi compilers, proves it can compile its own source, and stands
as the seed everything else grows from.

### Quest 1.1 -- Terrarium HOST shell (macOS native + QEMU)

*The glass before the world inside it. A macOS native application that wraps QEMU
RISC-V emulation, providing the window into the boot.*

- [ ] **Orbit 1 -- Terrarium macOS application shell**
  A native macOS window (AppKit or SwiftUI) that launches `qemu-system-riscv32` as a
  dependent process and captures its framebuffer or serial output. The glass you look
  through. Prove the window opens, QEMU starts, and Aurora's seed stage speaks through
  the glass.
  **SLC gate:** Terrarium launches on macOS, QEMU starts inside it, and the seed's
  console output appears in the window.

- [ ] **Orbit 2 -- RV32I Aurora seed port**
  Port Aurora's existing seed (`aurora/src/seed.rye`) from RV64 to RV32I. One hart
  wakes on `qemu-system-riscv32 -machine virt`, gives itself a stack, speaks over the
  console, and rests. The same seed, the smaller ISA.
  **SLC gate:** `aurora/run.sh seed` builds and runs on RV32I; the seed speaks and
  exits cleanly in Terrarium.

- [ ] **Orbit 3 -- RV32I relay and named stages**
  Port the relay and named stages to RV32I. The relay passes a named value between
  stages; the named stage hashes a message with SHA3-512 on the bare hart. Prove the
  crypto runs on the 32-bit ISA.
  **SLC gate:** `aurora/run.sh relay` and `aurora/run.sh named` both GREEN on RV32I;
  content-name matches the hosted test byte for byte.

### Quest 1.2 -- Glow compiler as RISC-V

*The first language in the pill: Glow compiles to RISC-V assembly and that assembly
runs on the bare hart.*

- [ ] **Orbit 4 -- Minimal Glow-to-RV32I code generator**
  A Glow program compiles to RV32I assembly (not through Rye -- directly from Glow's
  own compiler pipeline). The generated code runs freestanding on QEMU. Start with the
  simplest possible program: a Glow expression that evaluates to a number, and the
  generated assembly writes that number to the UART.
  **SLC gate:** a Glow source file compiles to a `.S` file, assembles to an ELF, runs
  on `qemu-system-riscv32`, and prints the correct value.

- [ ] **Orbit 5 -- Glow stdlib operations in generated RV32I**
  Extend the code generator to handle the Glow stdlib operations proven in the
  glow-language journey: arithmetic (double, inc, dec), number ops (square, half,
  negate), conditionals (?:), and face bindings (=/). Each operation compiles and
  runs freestanding.
  **SLC gate:** at least 6 Glow programs from `glow/gen/` compile to RV32I and
  produce correct output on QEMU.

- [ ] **Orbit 6 -- Glow self-hosting survey**
  Survey what the Glow compiler needs to compile its own source. Produce a gap
  analysis: which Glow features the compiler uses that the RV32I code generator does
  not yet handle. This is the map for self-compilation.
  **SLC gate:** a written survey document in `active-development/` naming every gap,
  with line counts and a proposed orbit plan for closing each one.

### Quest 1.3 -- Rye and Rishi in the pill

*The other two languages join the seed: Rye compiles freestanding RV32I modules, and
Rishi scripts orchestrate the build from inside the pill.*

- [ ] **Orbit 7 -- Rye freestanding RV32I module**
  A Rye source file compiles to a freestanding RV32I ELF (extending Aurora's existing
  freestanding build). Prove a small Rye module -- a bounded array with assertions --
  runs on the bare 32-bit hart.
  **SLC gate:** a Rye `.rye` file builds freestanding for RV32I, runs on QEMU, and
  the assertions pass.

- [ ] **Orbit 8 -- Rishi bootstrap interpreter**
  A minimal Rishi interpreter that runs inside the pill -- enough to orchestrate `run`
  commands, check `ok`, and sequence the boot. Freestanding on RV32I.
  **SLC gate:** a Rishi script inside the pill calls three stages in order and each
  stage's output appears on the console.

- [ ] **Orbit 9 -- Self-compile proof (Stage 1)**
  The pill carries the Glow, Rye, and Rishi compilers. On boot, the Rishi interpreter
  orchestrates: each compiler compiles its own source code. The output binaries are
  compared (hash or byte-for-byte) against the compilers in the pill. Identity proves
  the compilers are real.
  **SLC gate:** the self-compile runs on QEMU RV32I and the hash of each compiled
  output matches the hash of the compiler that compiled it.

## Journey 2 -- The TAME Boot Sequence (safety, then visibility, then replay)

The pill can rebuild itself. Now each subsystem arrives in the order TAME demands:
Tally first (safety), Aurora second (visibility), Mantra third (replay).

### Quest 2.1 -- Stage 2: Tally (bounded allocation)

*Safety first. From this moment, every allocation in the system is bounded.*

- [ ] **Orbit 10 -- Tally arena on freestanding RV32I**
  Port Tally's garden arena allocator to freestanding RV32I. A bounded arena with a
  named budget, ceiling enforcement, and named error on overflow. No heap; the arena
  owns all memory the system will ever use.
  **SLC gate:** a freestanding RV32I program allocates from a Tally arena, hits the
  ceiling, receives a named error, and the console reports the budget and the refusal.

- [ ] **Orbit 11 -- Tally integration with self-compiled pill**
  After the self-compile (Stage 1), Tally initializes. Every subsequent allocation --
  by Aurora, Mantra, Caravan, and userspace -- passes through Tally's bounded arena.
  **SLC gate:** the boot sequence reaches Tally initialization, and a subsequent
  allocation attempt past the budget refuses with a named error visible on the console.

### Quest 2.2 -- Stage 3: Aurora display (visible boot)

*Performance second. The boot becomes observable.*

- [ ] **Orbit 12 -- Aurora framebuffer on RV32I**
  Aurora draws to a framebuffer on the bare RV32I hart. A rectangle, a glyph, a boot
  status line -- the first visible pixel. The framebuffer memory is bounded by Tally.
  **SLC gate:** Terrarium's window shows a visible boot status drawn by Aurora on
  RV32I; the framebuffer allocation is bounded by Tally's arena.

- [ ] **Orbit 13 -- Aurora console and boot log**
  Aurora provides a text console over the framebuffer. Every boot stage from here
  forward speaks through Aurora's console rather than directly to the UART. The boot
  becomes self-documenting.
  **SLC gate:** the boot sequence from pill through Tally speaks through Aurora's
  console, visible in Terrarium's window.

### Quest 2.3 -- Stage 4: Mantra (deterministic replay)

*Joy third -- the joy of knowing every fact is replayable.*

- [ ] **Orbit 14 -- Mantra event log on freestanding RV32I**
  Mantra's append-only signed event log runs on the bare hart. Facts are appended,
  and a replay of the log produces identical state. Allocation is bounded by Tally;
  display goes through Aurora.
  **SLC gate:** a sequence of Mantra facts appended during boot replays to identical
  state, proven by hash comparison, visible on Aurora's console.

- [ ] **Orbit 15 -- Mantra persistence through the wire**
  Mantra facts sync through the one wire (Terrarium's QEMU virtio or a shared-memory
  channel). The green line between Terrarium and a pier. A sync appends facts; a
  replay on the other side produces the same state.
  **SLC gate:** facts written inside the emulated machine travel out through the wire
  and replay identically on the host side.

## Journey 3 -- Caravan Microkernel (the supervisor that holds everything)

The boot can rebuild itself (Stage 1), bound its memory (Stage 2), show its state
(Stage 3), and record its history (Stage 4). Now the microkernel arrives.

### Quest 3.1 -- Stage 5: Caravan supervisor

*Caravan is the microkernel. Everything from here runs under supervision.*

- [ ] **Orbit 16 -- Caravan capability model on RV32I**
  Port Caravan's capability and domain model to freestanding RV32I. A domain holds
  named capabilities with bounded leases; a capability can be conferred and revoked.
  Allocation bounded by Tally, displayed by Aurora, logged by Mantra.
  **SLC gate:** a domain creates a capability, confers it to a dependent, the
  dependent exercises it, and the capability expires -- all visible on Aurora's console
  and recorded in Mantra's log.

- [ ] **Orbit 17 -- Caravan process supervision**
  Caravan supervises dependent processes. A dependent that exceeds its lease or its
  allocation budget is stopped. The supervisor's own allocation is bounded separately
  from its dependents'.
  **SLC gate:** a supervised dependent exceeds its Tally budget, Caravan stops it,
  and the event is logged in Mantra and displayed on Aurora's console.

- [ ] **Orbit 18 -- Steward: the root supervisor**
  Steward is the first process Caravan supervises -- the root supervisor that reads
  the Brix manifest and brings up domains. Steward loads a minimal manifest (one
  domain, one capability) and reports success through Aurora.
  **SLC gate:** Caravan boots, starts Steward, Steward reads a Brix manifest, and
  the domain comes up -- visible in Terrarium's window.

### Quest 3.2 -- Grain userspace

*The living world under glass.*

- [ ] **Orbit 19 -- First Grain application**
  A simple Glow application (a calculator or REPL) runs in Grain userspace under
  Caravan's supervision. It receives input through Terrarium, computes, and displays
  output through Aurora. Every allocation bounded by Tally, every event logged by
  Mantra, every capability granted by Caravan.
  **SLC gate:** a user types an expression in Terrarium's window, the Glow calculator
  evaluates it inside the emulated RV32I machine, and the result appears on screen.

- [ ] **Orbit 20 -- Full boot witness**
  A single witness proves the complete boot sequence: pill -> self-compile -> Tally ->
  Aurora -> Mantra -> Caravan -> Steward -> userspace application. The witness runs
  on QEMU RV32I inside Terrarium and every stage is visible, bounded, and logged.
  **SLC gate:** `terrarium/boot_witness.rye` (or `.rish`) runs GREEN, proving every
  stage completed with its invariants intact.

## Journey 4 -- RV32I Inside RV64G (future mission, scoped here)

*The smaller system "living inside" the larger one, per Gall's Law and Conway's Law.*

This journey is **planned and scoped** by this checklist, with orbits to be detailed
when Journeys 1-3 are complete. The RV32I system proven above becomes a guest inside
an RV64G host, carrying its bounded discipline into the larger address space.

- [ ] **Orbit 21 -- RV64G host survey and gap analysis**
- [ ] **Orbit 22 -- RV32I guest model inside RV64G**
- [ ] **Orbit 23 -- Full boot on RV64G with RV32I guest**

---

**Fascia:** each proven orbit advances the fascia by `0.001` per the health model.
**Witness discipline:** every SLC gate names a witness that runs GREEN on metal (QEMU
counts as metal for an emulated ISA). A stage claimed without a witness is a stage
not landed.
