# The Mantrapod, the Wider Hart, and the Field Ledger

**Stamp:** `20261105.085747`
**Voice:** Kyri
**Style:** Gauge at Field, with Radiant warmth
**Status:** Proposed -- vision
**Room:** Vision -- reasoning a reader can check today, standing ahead of any guard
**Coauthor:** Keaton Dunsford
**Grows from:** Terrarium boot journey (25 orbits, all GREEN on freestanding RV32I),
RV64G horizon scoping (`active-development/date/20261105/20261105-014745_rv64g-horizon-scoping.md`),
Glow calculator application, Dimeroll's existing modules, and the Mantrapod composition
(`composition/20261102-211750_the-mantrapod-and-the-terrarium.md`)

---

## The proposal in three sentences

Carry the proven RV32I Grain stack to RV64G per Gall's Law. Land a Dimeroll field
ledger as the first real application -- a transaction log for a small farm, where
every entry is a signed Mantra fact. Bring the full stack to a real RISC-V
single-board computer, and call it the Mantrapod: a personal server on a shelf,
holding a household's records in bounded, supervised, signed memory.

---

## I. What stands, and what it teaches

The Terrarium boot journey proved nine layers of Grain's stack on freestanding RV32I,
each witnessed on QEMU `qemu-system-riscv32 -machine virt`:

| Layer | What it proved | The discipline it carries |
|---|---|---|
| **Pill** | Self-compile identity (djb2 hash match) | A system that can rebuild itself is a system that can be trusted |
| **Tally** | Bounded arena with ceiling refusal | Safety first -- every allocation is named and bounded |
| **Aurora** | Framebuffer console with serial fallback | Visibility second -- the boot is observable from the first instruction |
| **Mantra** | Append-only event log with replay identity | Replay third -- every fact is signed and every state is recoverable |
| **Caravan** | Capability model with W xor X, process supervision | The microkernel -- everything runs under supervision |
| **Steward** | Root supervisor booting domains from Brix manifest | The operating system -- domains compose under one roof |
| **Glow app** | Calculator evaluating 10 expressions, 10/10 correct | The application -- real work runs on the bare hart |

That proof teaches three things, and each one points at the next journey:

1. **The stack composes.** Each module does one thing, they meet through one value
   model, and they compose on bare silicon the same way they compose in hosted
   witnesses. This means a wider target -- RV64G -- is a port rather than a rewrite.

2. **The application is the smallest part.** The calculator is 43 lines of Rye. The
   boot sequence beneath it is nine stages. The ratio is right: the infrastructure
   serves the application, and the application serves the person. The next application
   should be the one closest to a person's daily life.

3. **The wire carries facts out of the machine.** Mantra facts travel from the guest
   to the host through the serial wire, and an independent replay on the host confirms
   their identity. This is the Mantrapod's persistence story: a RAM-only device that
   syncs its facts to the world through a wire, and a power cycle replays from the
   last sync.

## II. The economics that choose the ISA

RISC-V is splitting into two curves, and the Mantrapod sits where they cross.

**The embedded curve stays RV32I.** The ESP32-C3 (Espressif, ~$1.50) and CH32V003
(WCH, ~$0.10) are RV32I microcontrollers. They drive sensors, actuators, and embedded
control -- a soil moisture probe, a greenhouse vent, a compost temperature logger.
Their price is heading toward zero, and their capability ceiling is heading toward
a few hundred kilobytes of RAM and a few MHz of clock. They are leaves in a network,
and they are beautiful leaves.

**The consumer curve is heading RV64GC.** The StarFive VisionFive 2 ($60-80, JH7110,
quad-core RV64GC, 2-8 GB RAM), Milk-V Mars ($30-50, same SoC), and SpacemiT K1
($40-60, 8-core RV64GC, 4-16 GB RAM) are the current generation. SiFive's P870
and ESWIN's EIC7700 are the next. Prices are falling, core counts are rising, and
the ecosystem -- Linux distributions, toolchains, board support -- is maturing fast.
Within two years, an RV64GC SBC with 8 GB of RAM and USB-C will cost what a Raspberry
Pi costs today.

**The Mantrapod lives on the consumer curve.** A personal server needs the wider
address space (Tally's arena ceiling breathes), hardware multiply (Mantra's hash
runs at native speed), atomics (Caravan's tables become safe under preemption), and
floating point (Glow's numeric expressions, Dimeroll's price arithmetic, and the
door to Lotus audio on the bare hart). RV64G gives all four.

**RV32I stays as the embedded leaf.** An ecology sensor running on an ESP32-C3 -- a
soil moisture probe sending its reading as a signed Mantra fact to the Mantrapod over
Mycelium -- is a future quest that rides on the same stack, the same value model, and
the same signing discipline. The Mantrapod is the trunk; the sensors are the leaves.

## III. The bridge from calculator to field ledger

The Glow calculator already has the entire pipeline:

- A **Glow evaluator** that parses expressions and computes results
- A **Mantra log** that records every result as a signed fact
- A **Caravan supervisor** that bounds the evaluator's allocations
- An **Aurora display** that shows the result on the framebuffer
- A **wire protocol** that sends facts to the host for persistence

The field ledger extends that same pipeline in three steps:

### Step 1: the evaluator grows from numbers to records

A calculator expression: `3 + 4 = 7`

A field ledger transaction: `plant tomatoes 200 seeds`

The Glow parser already handles identifiers and literals. It learns five verbs
(`plant`, `harvest`, `sell`, `compost`, `note`), and a transaction evaluates to a
record rather than a number. The record carries verb, subject, quantity, unit, and
optionally a unit price.

### Step 2: the Mantra log grows from a trace to a book

A calculator logs: `3 + 4 = 7, hash 0xabc123`

A field ledger logs: `plant tomatoes 200 seeds, signed by K, hash 0xdef456`

Same append-only log, same signing discipline, richer payload. The Mantra log
becomes a book of account -- every transaction a signed fact, every day's work
replayable from its own log.

### Step 3: the display grows from a result to a ledger page

A calculator shows: `> 3 + 4` / `7`

A field ledger shows:

```
| Time  | Verb    | Subject  | Qty | Unit  | Price | Total  |
|-------|---------|----------|-----|-------|-------|--------|
| 07:12 | plant   | tomatoes | 200 | seeds |       |        |
| 11:30 | harvest | basil    |  2  | kg    |       |        |
| 14:45 | sell    | basil    |  1  | kg    | 8.00  |   8.00 |
|-------|---------|----------|-----|-------|-------|--------|
| Inventory: tomatoes 200 seeds, basil 1 kg                  |
| Revenue today: 8.00                                         |
```

Aurora already draws text on the framebuffer. The ledger page is a table of
transactions with running totals -- the same display, more rows, and two summary
lines at the bottom that answer the questions a grower carries all day.

## IV. What the Mantrapod is, and what it is not

**The Mantrapod is a personal server.** It sits on a shelf beside a router. It draws
power from a wall socket. It connects to the local network over Ethernet or to a
single device over USB-C. It holds one household's records -- a farm's field ledger,
a family's accounts, a cooperative's inventory -- in bounded, supervised, signed
memory. The person who plugs it in is the first and only administrator.

**It is not a cloud instance.** Nobody else's code runs on it. Nobody else reads its
Mantra log. Nobody else holds a key to its Caravan domains. The Mantrapod is a device
you own, running software you can audit, holding data you control.

**It is not a phone app.** A phone app runs in someone else's sandbox, on someone
else's operating system, subject to someone else's terms of service. The Mantrapod
runs Grain -- an operating system whose every allocation is bounded, whose every
event is signed, and whose every domain is supervised by a capability model the
owner controls.

**It is RAM-only.** There is no disk, no flash, no storage that outlives power. The
Mantrapod's persistence story is the wire: Mantra facts sync to the host (a laptop,
a desktop, a NAS, another Mantrapod) continuously, and a power cycle replays from
the last sync. This is a feature, not a limitation -- a device with no persistent
storage cannot leak data to a stolen disk, cannot accumulate cruft in a filesystem,
and cannot fail silently when a block goes bad.

**Its future has leaves.** An RV32I ecology sensor -- a soil moisture probe on an
ESP32-C3, a greenhouse temperature logger on a CH32V003 -- sends its readings as
signed Mantra facts to the Mantrapod over Mycelium, the mesh sync protocol. The
sensor is a leaf; the Mantrapod is the trunk; the wire to the host is the root.
The tree grows from the ground this journey clears.

## V. The journey shape

Three acts, 50 orbits, 10 quests:

| Act | What it proves | Quests | Orbits |
|---|---|---|---|
| **I -- The Wider Hart** | RV64G port: the working RV32I system on 64-bit silicon | 5 | 25 |
| **II -- The Field Ledger** | Dimeroll application: transactions, balances, queries, seals | 3 | 15 |
| **III -- The Living Server** | Real hardware: board bring-up, wire, power-cycle resilience | 2 | 10 |

Each act builds on what the previous one proved. Act I carries the working system
whole (Gall's Law). Act II extends it with a real application (the finishing edge).
Act III brings it to real silicon (the Long Return -- work that reads true on the far
side of the years).

The full checklist lives at `tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md`.

## VI. What does not move

- **TAME order stays.** Safety (Tally) first, visibility (Aurora) second, replay
  (Mantra) third. Every orbit in every act follows this order.
- **Explicit widths stay `u32` in-memory.** The wider address space is a platform
  fact, not a design choice. `usize` stays at the seam, per TAME Guidance.
- **Gall's Law stays.** Each act carries the working system forward. No act rewrites
  what the previous one proved.
- **The witness discipline stays.** Every SLC gate names a witness that runs GREEN.
  A stage claimed without a witness is a stage not landed.
- **The single-stranded principle stays.** Each module does one thing. They compose
  through one value model. Their composition on the Mantrapod is the same composition
  the hosted witnesses prove.

## VII. What this leaves open

- **Mycelium** -- the mesh sync protocol between RV32I sensor leaves and the Mantrapod
  trunk. Named here as a horizon, not scoped in this journey.
- **Linengrow** -- the line-by-line growth display. Named here as a companion
  application that could run beside Dimeroll on the Mantrapod.
- **WASM browser surface** -- Terrarium's glass in a browser tab. Scoped as Orbit 23
  in Act I, a looking pass rather than a build.
- **Lotus on the hart** -- audio processing on the bare Mantrapod. Orbit 19 proves
  one operation; the full DAW is a separate journey.
- **Multi-Mantrapod sync** -- two Mantrapods sharing Mantra facts through Mycelium.
  The persistence story for a household with more than one device.

---

May the wider hart carry the field ledger home, and may the first grower who plants
a row of tomatoes and enters `plant tomatoes 200 seeds` into their own Mantrapod
find their records whole when the season turns.
