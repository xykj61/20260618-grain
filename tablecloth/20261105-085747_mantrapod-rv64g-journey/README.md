# Mantrapod RV64G Journey -- From a Working Hart to a Living Server

**Stamp:** `20261105.085747`
**Voice:** Kyri
**Style:** Gauge at Field
**Status:** Living
**Room:** Checkable
**Captain:** Incense
**Coauthor:** Keaton Dunsford

---

## 1. Introduction

The Terrarium boot journey proved every layer of Grain's stack on freestanding RV32I --
pill identity, bounded allocation, visible display, replayable event log, capability
supervision, root domain management, and a Glow calculator running in userspace. Twenty-five
orbits, all GREEN on QEMU, all witnessed.

This journey carries that working system into the wider world it was always meant to
reach: **RV64G on real silicon, running real applications, inside the Mantrapod** --
Grain's personal server hardware. A RAM-only, USB-C-only, in-memory appliance built on
a consumer RISC-V single-board computer, where every application runs bounded, observed,
recorded, and supervised, and where the person who plugs it in owns every byte.

The journey has three acts. First, carry the proven RV32I boot to RV64G per Gall's Law --
the simple system that works becomes the wider system that serves. Second, land a
**Dimeroll field ledger** as the first real application -- a transaction log for a small
farm or ecology project, where every entry is a signed Mantra fact: what was planted,
what was harvested, what was sold. Third, bring the system to a real RISC-V board and
prove that Terrarium's glass becomes Mantrapod's window.

The bridge from calculator to field ledger is three steps wide. The calculator already
evaluates Glow expressions under Caravan supervision, logs every result as a Mantra
fact, and bounds every allocation through Tally. The field ledger extends that same
pipeline to evaluate TRANSACTIONS instead of arithmetic -- each transaction a verb
(`plant`, `harvest`, `sell`, `compost`), a subject (`tomatoes`, `basil`, `compost`),
a quantity, and optionally a unit price. The Glow evaluator grows from numbers to
records, and the Mantra log grows from a calculation trace to a book of account.

The target hardware is a consumer RV64GC single-board computer: the StarFive VisionFive 2,
Milk-V Mars, SpacemiT K1, or their successors -- boards running $30-80 today, with 2-8 GB
of RAM, a USB-C port, and an Ethernet jack. The economies of scale in the RISC-V ecosystem
are heading toward RV64GC for consumer applications, with RV32I staying in the embedded
space (ESP32-C3 at ~$1.50, CH32V003 at ~$0.10). The Mantrapod lives where those two
curves cross: powerful enough for a household's applications, small enough for a shelf
beside the router.

See `CHECKLIST.md` for the full orbit-by-orbit plan.

## 2. Problem

The Terrarium boot journey proved that Grain's stack can boot and run on bare RISC-V
hardware. Three gaps stand between that proof and a personal server a person plugs in:

1. **32-bit address space.** RV32I constrains total memory to 4 GiB. A personal server
   handling a household's records, a farm's ledger, and a mesh of ecology sensors needs
   the headroom RV64G provides -- not because any single allocation is large, but because
   Tally's arena ceiling and Caravan's domain registry deserve room to breathe.

2. **No real application.** The Glow calculator proves the pipeline; it does not serve a
   person's daily work. A field ledger -- tracking what was planted, harvested, sold, and
   composted -- is the smallest application that earns a place on someone's shelf. It is
   also the application closest to Grain's own ecology: biocyclic vegan agriculture,
   where a grower's records are their own.

3. **No real hardware.** QEMU proves the ISA; a board proves the device. The Mantrapod
   is not a concept until it runs on silicon someone can hold, with a USB-C cable and an
   Ethernet connection, drawing power from a wall socket.

## 3. Solution

Three acts, each building on what the previous one proved:

### Act I -- The Wider Hart (RV64G port, 5 quests of 5 orbits)

Carry the working RV32I system to `riscv64-freestanding-none`. Each existing stage
builds and runs on the wider hart. No new features in Act I -- the working system
moves whole, per Gall's Law. The M extension gives Mantra's hash and Glow's multiply
native speed. The A extension gives Caravan's capability table atomic operations for
multi-hart safety. The F/D extensions give Glow floating-point and open the door to
Lotus audio on the hart.

### Act II -- The Field Ledger (Dimeroll application, 3 quests of 5 orbits)

Extend the Glow evaluator from arithmetic expressions to transactions. Each
transaction is a Mantra fact with a verb, a subject, a quantity, and an optional
price. The Dimeroll field ledger is the application layer:

- **Running balances** per subject (inventory) and per account (cash flow)
- **Sealed daily summaries** as Amphora vessels, content-addressed and hash-identified
- **Query by verb, subject, date range, or account** -- the five questions a grower asks
- **Export to plain text** through the wire, readable on any device

The ledger runs inside Terrarium first (QEMU RV64G), then on real hardware in Act III.

### Act III -- The Living Server (real board, 2 quests of 5 orbits)

Bring the full stack -- RV64G boot, Dimeroll ledger, wire protocol -- to a real
RISC-V single-board computer. Prove: the system boots from power-on, the ledger
persists through the wire to a host, and a person interacts with it from a browser
or a terminal over USB-C or Ethernet.

The Mantrapod is a personal server. It is not a cloud instance. It is not a phone app.
It is a device on a shelf, plugged in, holding a household's facts in bounded,
supervised, signed memory -- and the person who owns it owns every byte it holds.

## 4. Rationale

### Why RV64G rather than staying RV32I

RV32I proved the stack. RV64G is where the consumer RISC-V ecosystem is heading --
StarFive, Milk-V, SpacemiT, and SiFive are all shipping RV64GC boards with real RAM
and real I/O. The ESP32-C3 and CH32V003 stay RV32I because they are microcontrollers
serving a different niche: sensors, actuators, and embedded control at $0.10-$1.50 per
unit. A personal server needs the wider address space, the hardware multiply, and the
atomics. RV32I stays in the tree as the embedded leaf -- an ecology sensor, a soil
moisture probe, a greenhouse controller -- and those leaves talk to the Mantrapod
through Mycelium, the mesh sync protocol.

### Why a field ledger as the first real application

The field ledger is the smallest application that earns a place in someone's life.
It answers the five questions a grower asks every day: what did I plant, what is
ready, what did I harvest, what did I sell, and what went back to the soil. Those
five questions are five verbs in Glow (`plant`, `harvest`, `sell`, `compost`,
`note`), five kinds of Mantra fact, five columns in a running balance.

The bridge from the calculator is three steps wide:

1. **The evaluator grows from numbers to records.** A calculator expression like
   `3 + 4` becomes a transaction like `plant tomatoes 200 seeds`. The Glow parser
   already handles identifiers and literals; it learns verbs and units.

2. **The Mantra log grows from a trace to a book.** A calculation logs its result
   as a signed fact. A transaction logs its verb, subject, quantity, and price as a
   signed fact. Same pipeline, richer payload.

3. **The display grows from a result line to a ledger page.** Aurora already draws
   text on the framebuffer. The ledger page is a table of transactions with running
   totals -- the same display, more rows.

### Why real hardware in the same journey

A personal server that runs only in an emulator is a demo, and a demo does not earn
a shelf. The Mantrapod earns its place by running on a board someone can hold, with a
cable someone can plug in, drawing power from a socket someone already has. Act III
is short -- two quests, ten orbits -- because Acts I and II have already proven the
stack on the ISA the board speaks.

### Why the Mantrapod is not a phone app or a cloud instance

A phone app runs in someone else's sandbox. A cloud instance runs on someone else's
machine. The Mantrapod runs on your shelf, holding your facts, signed by your key,
bounded by your budget, supervised by your Caravan. The person who plugs it in is the
first and only administrator. That is the promise Grain makes, and the Mantrapod is
the device that keeps it.

## 5. Architecture

```
Mantrapod (RV64GC single-board computer)
  |
  +-- Grain boot (the Terrarium stack on real silicon)
  |     |
  |     +-- Pill (self-compiling Glow + Rye + Rishi)
  |     +-- Tally (bounded arena -- every allocation named)
  |     +-- Aurora (display -- framebuffer or serial console)
  |     +-- Mantra (event log -- every fact signed and replayable)
  |     +-- Caravan (supervisor -- capabilities, domains, leases)
  |     +-- Steward (root supervisor -- reads Brix manifest)
  |
  +-- Dimeroll (the field ledger application)
  |     |
  |     +-- Glow evaluator (transactions: verb + subject + quantity + price)
  |     +-- Mantra ledger (each transaction a signed fact)
  |     +-- Running balances (inventory and cash flow per subject/account)
  |     +-- Amphora seals (daily summaries, content-addressed)
  |     +-- Query engine (by verb, subject, date, account)
  |
  +-- Wire (USB-C serial or Ethernet -- Mantra facts travel through)
  |
  +-- Mycelium horizon (RV32I sensor leaves syncing to the Mantrapod)
```

### The single-stranded principle holds

Each module stays about one thing. Tally bounds. Aurora draws. Mantra records. Caravan
supervises. Dimeroll keeps the ledger. Mycelium syncs the mesh. They compose through
one value model. Their composition on the Mantrapod is the same composition the hosted
witnesses prove, carried to a smaller stage and then to real silicon.

## 6. Risks and open questions

- **RV64G port scope.** The scoping document names six known gaps (target/linker,
  explicit widths, atomics, QEMU machine model, floating-point context, self-compile).
  Each is bounded and none requires a new module. The risk is in the sum.
- **Real-board variance.** StarFive VisionFive 2 and Milk-V Mars use different SoCs
  (JH7110 vs JH7100). Device tree, UART base, and memory map may differ. The first
  board is chosen for documentation quality and community support.
- **Dimeroll's transaction grammar.** The Glow evaluator grows from arithmetic to a
  five-verb transaction language. The grammar is small; the risk is in the interaction
  between running balances and Mantra's append-only log.
- **Persistence across power cycles.** A RAM-only device loses state on power loss.
  The wire protocol syncs Mantra facts to the host; the seal discipline means a
  replay from the last sync recovers every committed fact. The risk is in the window
  between the last sync and a power failure.

## 7. Design links

- [Terrarium boot journey](../20261104-161857_terrarium-boot-journey/README.md) -- the foundation this grows from
- [RV64G horizon scoping](../../active-development/date/20261105/20261105-014745_rv64g-horizon-scoping.md) -- the six known gaps
- [The Mantrapod and the Terrarium](../../composition/20261102-211750_the-mantrapod-and-the-terrarium.md)
- [The Grain and the Crossing](../../foundations/20260826-024942_the-grain-and-the-crossing.md)
- [Single-stranded foundation](../../foundations/20260823-204456_single-stranded.md)
- [Fascia health model](../../context/specs/20261103-201746_fascia-health-model.md)
- [ITINERARY](../../construction/ITINERARY.md)
- [Lila and the Long Return](../../foundations/20261002-111449_lila-and-the-long-return.md)

May the working hart carry the field ledger home, and may the first grower who plugs
in the Mantrapod find their records whole, their balances honest, and their shelf glad
to hold it.
