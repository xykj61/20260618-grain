# Terrarium Boot Journey -- From a Cold Hart to a Living World Under Glass

**Stamp:** `20261104.161857`
**Voice:** Kyri
**Style:** Gauge at Field
**Status:** Living
**Room:** Checkable
**Captain:** Incense (reassigned from receipt contract work on Keaton's word `20261104`)
**Coauthor:** Keaton Dunsford

---

## 1. Introduction

Terrarium is Grain's macOS native HOST application -- the glass you look through into a
living RISC-V world. This proposal describes the journey from a cold hart to a full
operating system boot, with the Urbit pill concept applied to real silicon: a single
binary containing its own compilers, self-compiling, then bootstrapping every subsystem
in the order TAME demands.

The journey also begins with the tree itself. Before the first line of RISC-V assembly,
this tree's own developer experience earns its first orbits -- root consolidation, Nock
pipeline archive, build toolchain, module survey. A complex system that works evolved
from a simple system that worked (Gall's Law), and the simple system starts with a tree
a newcomer can navigate.

Grain's own modules -- Aurora, Tally, Mantra, Caravan, Kumara, Amphora, Comlink,
Pond -- already hold proven Rye code for each stage of the boot. DJINN's grain-www (`gratitude/grain-www/`) proved that
RISC-V can compile to WASM and drive a full desktop surface. That proof stands as
validated inspiration, and our own Brix, our own capability model, and our own
supervision design grow from our tree's own foundations rather than copying any single
interpretation. The architecture is ours to discover.

The target is **RV32I** -- the minimal 32-bit integer-only RISC-V base. Smaller,
bounded, auditable. A future quest has RV32I "live inside" RV64G per Gall's Law and
Conway's Law, and the emulator today becomes the hardware tomorrow (the Mantrapod).

## 2. Problem

Grain has 89 root directories, proven modules across a dozen families, a Glow compiler
that targets Rye, six Aurora boot stages on RV64, and a single-stranded architecture
where each part stands free. What it lacks is the frame that turns these parts into a
system a person boots, watches come alive, and uses.

Three gaps stand between here and there:

1. **No compilation path from Glow to real hardware.** Glow currently compiles through
   Rye and Zig to native code. The `glow/nock/` pipeline targeted Nock, a virtual machine.
   Neither path produces a freestanding RISC-V binary. The new direction is direct
   Glow -> RV32I assembly, bypassing Nock entirely -- Nock stays as an optional interop
   target, and the compilation backbone targets real silicon.

2. **No host application.** Aurora's proven stages run on `qemu-system-riscv64` from a
   terminal. There is no native macOS window wrapping the emulator, no way to see the
   boot as a living surface on your screen. Terrarium is that window -- the glass over
   the world, the same code that runs on eventual Mantrapod hardware.

3. **Tree readiness.** 89 root directories, the Nock compilation pipeline still in place,
   no cross-compilation toolchain for RV32I, and no gap analysis of what each module room
   needs for a freestanding port. The tree itself deserves a clearing before the build.

## 3. Solution

Five quests of five orbits each -- 25 orbits total -- following the Calfive planning
template. The first quest clears the ground. The remaining four build the system in
TAME order: safety first, performance second, joy third.

See `CHECKLIST.md` for the full orbit-by-orbit plan.

### The boot sequence

| Stage | What boots | Why this order |
|---|---|---|
| **0 -- The Pill** | RISC-V binary with Glow, Rye, Rishi compilers as raw assembly | The seed everything grows from -- nothing beneath it |
| **1 -- Self-compile** | Compilers compile their own source code | Proves the compilers are real; the system can rebuild itself |
| **2 -- Tally** | Bounded allocation: arena, ceiling, named budget | Safety first -- every later allocation is bounded from this moment |
| **3 -- Aurora** | Display: framebuffer, console, visible boot | Makes the boot observable and debuggable; performance second |
| **4 -- Mantra** | Event log: append-only, Kumara-signed, replayable facts | Deterministic replay; every state change from here is recorded |
| **5 -- Caravan** | Supervisor: capabilities, domains, named leases | The microkernel; everything runs under supervision from here |

After Stage 5, Steward (the root supervisor) loads a Brix manifest and brings up Grain
userspace -- the point where Terrarium shows a living world under glass.

## 4. Rationale

### Why RV32I first

Gall's Law: a complex system that works evolved from a simple system that worked. RV32I
is the smallest RISC-V base -- 47 instructions, 32-bit integer only, no multiplication,
no floating point, no atomics. Every instruction is auditable. Every allocation fits in
a bounded 32-bit address space. The system that works on RV32I is the simple system that
grows into RV64G, carrying its bounded discipline with it.

### Why direct Glow -> RV32I, not through Nock

Nock is Urbit's virtual machine, and Grain thanked the ancestor and moved on. The new
compilation path is Glow -> RV32I assembly -> ELF binary -> bare metal (or QEMU). No
Nock anywhere in the compilation or boot path. Nock remains as an optional interop
target (`glow/nock/` archived to gratitude), because the bridge to the Nock world is
worth its small weight while the backbone targets real silicon.

### Why Terrarium is macOS native

The macos-native surface already proved the platform reachable from Rye and AppKit with
zero Swift linked. CoreAudio is the most capable audio API on any desktop. Skate holds
`FrameGrid`, `EventRing`, and `LotusMeterReading` in Swift. Starting native means the
HOST application draws with proven tools, and the GUEST draws with Aurora's framebuffer
on the bare hart. WASM/browser targeting is a validated future path (DJINN proved it),
and it is not the first delivery.

### Why DX orbits come first

A tree with 89 root directories, an orphaned Nock pipeline, and no RV32I toolchain asks
a newcomer to hold too many things in mind at once. Single-stranded says: parts that
stand free stay inside the budget a person can hold. Clearing the ground is the first
orbit, because the system that works starts with a tree a developer can navigate.

### Why our own design, not a copy

DJINN's grain-www is a thoughtful interpretation of the Grain operating system -- a
capability-based microkernel with domain isolation, Brix manifests, bounded leases, and
virtio drivers. We study it with gratitude and learn its patterns: capabilities, domains,
template inheritance, agent leasing, the Envoy protocol. Our own Brix, our own
supervision model, and our own capability wiring grow from our tree's own foundations,
informed by DJINN's proof that the architecture is sound. The design is ours to discover,
and what we discover may differ from any single interpretation.

## 5. Architecture

```
Terrarium (macOS native HOST -- AppKit/SwiftUI)
  |
  +-- QEMU RV32I (the emulated hart)
  |     |
  |     +-- Stage 0: The Pill (Glow + Rye + Rishi compilers as RV32I assembly)
  |     |     |
  |     |     +-- Stage 1: Self-compile (compilers rebuild themselves, identity proven)
  |     |
  |     +-- Stage 2: Tally (bounded arena -- every allocation from here is bounded)
  |     |
  |     +-- Stage 3: Aurora (framebuffer + console -- the boot becomes visible)
  |     |
  |     +-- Stage 4: Mantra (event log -- every fact is replayable)
  |     |
  |     +-- Stage 5: Caravan (supervisor + capabilities + domains)
  |           |
  |           +-- Steward (root supervisor, reads Brix manifest)
  |           |
  |           +-- Grain userspace (applications under supervision)
  |
  +-- Host-side display (Terrarium window showing Aurora's framebuffer)
  +-- Host-side Comlink wire (virtio or shared memory -- Mantra facts travel through)
  +-- Host-side console (serial output during early boot)
```

### The single-stranded principle holds

Each module stays about one thing. Tally bounds memory. Aurora draws. Mantra records.
Caravan supervises. They meet through one value model. Their composition on the bare
hart is the same composition the hosted witnesses already prove, carried to a smaller
stage.

## 6. Risks and open questions

- **Glow -> RV32I code generation is new.** The compiler pipeline exists for Glow -> Rye
  lowering. A direct backend to RV32I assembly is unbuilt. Orbit 11 (the first code
  generator orbit) is the proving ground.
- **Self-compilation is the hardest gate.** The pill must compile its own source and
  produce identical output. Any compiler red surfaces here. The self-compile orbit
  (Orbit 15) is the journey's keystone, and the gap analysis in Orbit 13 maps the road.
- **RV32I's 32-bit address space constrains total memory.** Tally's bounded arena is a
  natural fit, yet the system's total footprint must fit in 4 GiB or less. The module
  survey (Orbit 4) measures each room's contribution.
- **DJINN's interpretation and ours may diverge.** Our own Brix manifest format, our own
  capability model, and our own domain wiring grow from first principles informed by
  DJINN's proof. Divergence is expected and welcome.

## 7. Design links

- [Mantrapod and Terrarium](../../composition/20261102-211750_the-mantrapod-and-the-terrarium.md)
- [DJINN public repositories read](../../external-research/date/20260825/20260825-235138_djinn-public-repositories-read-against-grain.md)
- [Terrarium and the stack that breathes](../../active-development/20261031-232638_terrarium-and-the-stack-that-breathes.md)
- [seL4 userlevel license read](../../external-research/date/20260821/20260821-041056_the-microkernel-license-read.md)
- [Single-stranded foundation](../../foundations/20260823-204456_single-stranded.md)
- [Fascia health model](../../context/specs/20261103-201746_fascia-health-model.md)
- [ITINERARY](../../construction/ITINERARY.md)
- [Lotus DAW proposal (sister RFC)](../../active-designing/date/20261103/20261103-003744_lotus-daw-expansion-proposal.md)

## Incense captain assignment

Incense is reassigned from receipt contract work (item 1 in its ITINERARY stanza was
already landed as of the Zig 0.17.0 molt-breach `20261103.020226`). The remaining
receipt items (items 2-3) move to the ungated claim-as-override queue for any ship.
Incense takes the terrarium-boot-journey as its new exclusive priority.
