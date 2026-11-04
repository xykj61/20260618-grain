# Terrarium Boot Journey

**Stamp:** `20261104.161857`
**Voice:** Kyri
**Style:** Gauge at Field
**Status:** Living
**Room:** Checkable
**Captain:** Incense (reassigned from receipt contract work on Keaton's word `20261104`)

---

## What this board tracks

The complete boot sequence from a cold RISC-V hart to a living Grain userspace, running
inside Terrarium -- the macOS native HOST application wrapping QEMU RISC-V emulation.
The journey takes Aurora's six proven stages (seed through sealed datagram) and grows
them into a self-compiling, self-bootstrapping operating system kernel.

**Grows from:** Aurora's six freestanding stages (`aurora/src/`), Caravan's supervision
modules (`caravan/`), Tally's bounded allocation (`tally/`), Mantra's event log
(`mantra/`), the Mantrapod composition (`composition/20261102-211750_the-mantrapod-and-the-terrarium.md`),
DJINN's grain-www proof that RISC-V compiles to WASM, and Urbit's pill-to-Arvo boot
inspiration reapplied to a real hardware ISA.

## The argument

Urbit proved that a system can boot from a single binary (a pill) containing its own
compilers, self-compile, and then bootstrap an entire operating system layer by layer.
Urbit did this on Nock, a virtual machine invented before RISC-V existed. RISC-V is
a real, open hardware ISA -- the same single-binary-to-full-system discipline applied
to real silicon, where the emulator today becomes the hardware tomorrow.

The boot sequence follows TAME's priority order: safety first (Tally bounds every
allocation before anything else can run), performance second (Aurora makes the boot
visible and debuggable), joy third (Mantra makes every fact replayable, Caravan
supervises everything with named capabilities).

## Target ISA

**RV32I** -- the minimal 32-bit integer-only RISC-V base. Smaller, bounded, auditable.
Push it with SLC demos first; a future mission will have RV32I "live inside" RV64G
per Gall's Law and Conway's Law.

## Terrarium as HOST

Terrarium is the macOS native application -- the glass you look through. It wraps QEMU
RISC-V emulation, providing the window into the living world. The same code runs on
eventual Mantrapod hardware. Native macOS is the priority over WASM/browser per TAME
guidance; DJINN's grain-www proof that WASM compilation works stands as a validated
future path.

## Design links

- **Mantrapod and Terrarium:** `composition/20261102-211750_the-mantrapod-and-the-terrarium.md`
- **Aurora boot RISC-V:** `external-research/yonder/20260617-195812_aurora-boot-riscv.md`
- **Aurora decided design:** `external-research/yonder/20260618-190312_decided-design-aurora-mantra.md`
- **DJINN public repositories read:** `external-research/date/20260825/20260825-235138_djinn-public-repositories-read-against-grain.md`
- **Terrarium and the stack that breathes:** `active-development/20261031-232638_terrarium-and-the-stack-that-breathes.md`
- **Proven seat (seL4 lineage):** `external-research/date/20260712/20260712-054342_proven-seat-guest-genode-sel4.md`
- **seL4 userlevel license read:** `external-research/date/20260821/20260821-041056_the-microkernel-license-read.md`
- **Fascia health model:** `context/specs/20261103-201746_fascia-health-model.md`
- **ITINERARY:** `construction/ITINERARY.md`

## The boot sequence

The pill concept, applied to RISC-V: start with a single binary containing the Glow,
Rye, and Rishi compilers as raw RISC-V assembly. That binary self-compiles, proving the
compilers are real. Then each subsystem arrives in the order TAME demands:

| Stage | What boots | Why this order |
|---|---|---|
| **0 -- The Pill** | RISC-V binary with Glow, Rye, Rishi compilers as raw assembly | The seed everything grows from -- nothing beneath it |
| **1 -- Self-compile** | Compilers compile their own source code | Proves the compilers are real; the system can rebuild itself |
| **2 -- Tally** | Bounded allocation: arena, ceiling, named budget | Safety first -- every later allocation is bounded from this moment |
| **3 -- Aurora** | Display: framebuffer, console, visible boot | Makes the boot observable and debuggable; performance second |
| **4 -- Mantra** | Event log: append-only, signed, replayable facts | Deterministic replay; every state change from here is recorded |
| **5 -- Caravan** | Supervisor: capabilities, domains, named leases | The microkernel; everything runs under supervision from here |

After Stage 5, Steward (the root supervisor process) loads the Brix manifest and
brings up Grain userspace -- the point where Terrarium shows a living world under glass
and the Mantrapod shows a living world on paper.

## Incense captain assignment

Incense is reassigned from receipt contract work (item 1 in its ITINERARY stanza was
already landed as of the Zig 0.17.0 molt-breach `20261103.020226`). The remaining
receipt items (items 2-3) move to the ungated claim-as-override queue for any ship.
Incense takes the terrarium-boot-journey as its new exclusive priority.
