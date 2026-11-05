# Mantrapod RV64G Journey -- Master Checklist

**Journey: From a Working Hart to a Living Server**
**Stamp:** `20261105.085747`
**Captain:** Incense
**Target ISA:** RV64GC (64-bit general-purpose RISC-V -- I + M + A + F + D)
**Planning:** Calfive -- 10 quests of 5 orbits each, 50 orbits total across 3 acts
**Grows from:** Terrarium boot journey (25 orbits, all GREEN on freestanding RV32I),
the RV64G horizon scoping document (`active-development/date/20261105/20261105-014745_rv64g-horizon-scoping.md`),
Glow calculator application (10 expressions, 10/10 correct under Caravan supervision),
Dimeroll's existing modules, and the Mantrapod composition.

---

## Act I -- The Wider Hart (RV64G port)

*Gall's Law: carry the working system whole. Each orbit changes the target from
`riscv32-freestanding-none` to `riscv64-freestanding-none` and addresses the gaps
that surface. No new features in Act I -- the working system moves.*

### Quest 1.1 -- The Wider Seed (RV64I base port)

*The hart wakes on 64 bits. Every stage that spoke on RV32I speaks again on RV64I,
unchanged in what it does, wider in how it addresses.*

- [x] **Orbit 1 -- RV64I linker script and hello on UART** (`20261105.093245`)
  The hart wakes on 64 bits. `terrarium/src/hello64.rye` builds to a 64-bit
  RISC-V ELF with `-mcmodel=medany` (the medlow code model cannot reach
  0x80000000 on RV64) and speaks one line to the UART on `qemu-system-riscv64`.
  **Witness:** `terrarium/hello64_witness.rish` -- build, wake, ELF identity.
  **GREEN on metal.**

- [x] **Orbit 2 -- Pill identity on RV64I** (`20261105.094456`)
  The self-compile stage builds on `riscv64-freestanding-none` and its djb2 hash
  matches the sealed constant `0x079080D9` -- identical to RV32I, because the hash
  operates over string constants in explicit `u32` arithmetic. Zero source changes.
  **Witness:** `terrarium/pill64_witness.rish` -- build, hash match, ELF identity.
  **GREEN on metal.**

- [x] **Orbit 3 -- Tally arena on RV64I** (`20261105.095422`)
  Tally's garden arena allocates and refuses on the 64-bit hart. `u32` budgets
  and indices stay `u32`. All four named errors (OutOfBounds, DuplicateName,
  NameEmpty, Full) proven on `qemu-system-riscv64`. Zero source changes.
  **Witness:** `terrarium/tally64_witness.rish` -- build, ceiling refusal, ELF.
  **GREEN on metal.**

- [x] **Orbit 4 -- Aurora and Mantra on RV64I** (`20261105.102031`)
  Aurora console, Mantra event log, and Mantra wire persistence all proven on
  `qemu-system-riscv64` with zero source changes to any `.rye` file. State hash
  `0xbc186e04` matches RV32I identically. Swift host launches `qemu-system-riscv64`
  and MVERIFY confirms. The explicit-`u32` discipline carries display, persistence,
  and wire layers across the register-width boundary unchanged.
  **Witness:** `terrarium/aurora_mantra64_witness.rish` -- three stages, ELF identity.
  **GREEN on metal.**

- [ ] **Orbit 5 -- Caravan and Steward on RV64I**
  Caravan capabilities, process supervision, and Steward domain boot on the 64-bit
  hart. The Glow calculator runs in userspace. Full nine-stage boot on RV64I.
  **SLC gate:** `terrarium/boot_witness_rv64.rish` proves all nine stages GREEN.

### Quest 1.2 -- Hardware Arithmetic (M extension)

*The hart learns to multiply. Every site that computed in software gains native speed.*

- [ ] **Orbit 6 -- M extension: Mantra's djb2 hash at native speed**
  Enable the M extension in the Zig target. Mantra's djb2 hash uses hardware
  `mul`. Measure the speedup against the software multiply.
  **SLC gate:** Mantra log with hardware-multiplied hash matches the RV32I hash
  byte for byte; wall time measured and recorded.

- [ ] **Orbit 7 -- M extension: Glow multiply and division**
  Glow's `mul` and `div` operations use hardware instructions. The calculator
  evaluates division expressions that were impossible on bare RV32I.
  **SLC gate:** Glow evaluates `144 / 12` and `7 * 8` correctly on RV64M.

- [ ] **Orbit 8 -- M extension: Amphora seal performance**
  Amphora's content-addressing hash uses hardware multiply. Seal and verify a
  vessel; measure the throughput.
  **SLC gate:** Amphora seals a 4 KiB vessel, verifies it, reports wall time.

- [ ] **Orbit 9 -- M extension: software division removal survey**
  Survey every site in the freestanding tree that uses software division or
  multiplication. Name each one, confirm it now uses hardware instructions.
  **SLC gate:** survey document with zero remaining software multiply/divide sites.

- [ ] **Orbit 10 -- M extension integration witness**
  A single witness proves all M-extension work: hash, calculator, seal, and
  the full boot sequence with hardware arithmetic throughout.
  **SLC gate:** `terrarium/m_extension_witness.rish` runs GREEN on RV64M.

### Quest 1.3 -- Atomic Supervision (A extension)

*The hart becomes safe under concurrency. Caravan's tables gain atomic operations,
and the system prepares for multi-hart boot.*

- [ ] **Orbit 11 -- A extension: atomic capability table**
  Caravan's capability table uses `amoadd`, `amoswap`, and `lr`/`sc` for
  concurrent access. Prove: two domains accessing the same table see consistent state.
  **SLC gate:** concurrent capability grant and revoke produce correct state on RV64A.

- [ ] **Orbit 12 -- A extension: atomic domain registry**
  Caravan's domain registry uses atomic operations. Steward boots two domains
  concurrently; neither corrupts the registry.
  **SLC gate:** two-domain concurrent boot, both registered, registry consistent.

- [ ] **Orbit 13 -- Multi-hart boot on QEMU (2 harts)**
  Boot QEMU with `-smp 2`. The primary hart runs the boot sequence; the secondary
  hart waits at a barrier and joins after Caravan is ready.
  **SLC gate:** both harts report through Aurora; Caravan supervises domains on both.

- [ ] **Orbit 14 -- Preemptive scheduling foundation**
  Caravan gains a round-robin scheduler across 2 harts. Timer interrupt (CLINT)
  triggers context switch. Each domain's register state is saved and restored.
  **SLC gate:** two domains time-slice on one hart; both produce correct output.

- [ ] **Orbit 15 -- A extension integration witness**
  Full boot with atomics, multi-hart, and preemptive scheduling. The capability
  model, domain registry, and scheduler all proven under concurrency.
  **SLC gate:** `terrarium/a_extension_witness.rish` runs GREEN on 2-hart RV64MA.

### Quest 1.4 -- Numeric Precision (F/D extensions)

*The hart learns floating point. Glow gains real numbers, and the door to Lotus
audio opens on the bare hart.*

- [ ] **Orbit 16 -- F/D extensions: Glow floating-point expressions**
  The Glow evaluator handles `3.14`, `2.718`, and arithmetic on them. IEEE 754
  double precision. Results display with two decimal places on Aurora.
  **SLC gate:** Glow evaluates `3.14 * 2.0` correctly on RV64FD.

- [ ] **Orbit 17 -- F/D extensions: Caravan FP context save/restore**
  Caravan saves and restores `f0`-`f31`, `fcsr`, `fflags`, and `frm` on context
  switch. Two domains using floating point produce correct results under scheduling.
  **SLC gate:** preempted FP domain resumes with correct FP state.

- [ ] **Orbit 18 -- F/D extensions: Dimeroll price arithmetic**
  Dimeroll's price calculations use hardware floating point. `sell tomatoes 30 kg 2.50`
  computes `75.00` on the hart rather than in fixed-point software.
  **SLC gate:** transaction with price computes correct total on RV64FD.

- [ ] **Orbit 19 -- Lotus audio sample type on the bare hart**
  A single Lotus audio operation (a gain or fade) runs on the bare hart using
  hardware FP. The sample buffer is Tally-bounded. Proof of concept for Lotus
  on the Mantrapod.
  **SLC gate:** 256-sample gain operation produces correct output on RV64FD.

- [ ] **Orbit 20 -- F/D extension integration witness**
  Full boot with all G extensions: I + M + A + F + D. The complete RV64G stack
  from pill through Glow application, all proven.
  **SLC gate:** `terrarium/rv64g_witness.rish` proves all stages GREEN on RV64G.

### Quest 1.5 -- The Wider World (full RV64G boot and WASM horizon)

*The full stack runs on the wider hart. The browser horizon opens.*

- [ ] **Orbit 21 -- Full RV64G boot witness**
  A single witness proves the complete boot on RV64G: pill, Tally, Aurora, Mantra,
  wire, Caravan caps, Caravan supervision, Steward, Glow app -- all nine stages
  plus M, A, and F/D integration.
  **SLC gate:** `terrarium/boot_witness_rv64g.rish` runs GREEN, all stages proven.

- [ ] **Orbit 22 -- Terrarium macOS app on RV64G**
  The Terrarium macOS app launches `qemu-system-riscv64` instead of `riscv32`.
  The glass shows the wider world.
  **SLC gate:** Terrarium opens on macOS, full RV64G boot visible in the window.

- [ ] **Orbit 23 -- WASM emulation horizon scoping**
  Scope the path from `qemu-system-riscv64` to `grain-emu.wasm` -- a browser-hosted
  RISC-V emulator serving the same Grain stack. Survey existing RISC-V-to-WASM
  projects, name the build path, estimate the orbit cost.
  **SLC gate:** scoping document in `active-development/` with build path and gaps.

- [ ] **Orbit 24 -- Performance baseline on RV64G**
  Measure boot time, Mantra log throughput, Glow evaluation speed, and Tally
  allocation rate on RV64G QEMU. Establish the baseline for real hardware.
  **SLC gate:** performance document with all four metrics, each with unit and source.

- [ ] **Orbit 25 -- Act I completion witness and Act II scoping**
  A single witness proves all of Act I. Scope Act II in detail: the Dimeroll
  transaction grammar, the running balance model, and the query engine.
  **SLC gate:** Act I witness GREEN; Act II scoping document in `active-development/`.

---

## Act II -- The Field Ledger (Dimeroll application)

*The wider hart runs a real application. A grower's daily work -- what was planted,
harvested, sold, and composted -- enters a signed, bounded, supervised ledger.*

### Quest 2.1 -- The Transaction Language

*Glow learns verbs. The evaluator grows from `3 + 4` to `plant tomatoes 200 seeds`.*

- [ ] **Orbit 26 -- Transaction grammar in Glow**
  Extend the Glow parser to recognize transactions: `verb subject quantity [unit]
  [price]`. Five verbs: `plant`, `harvest`, `sell`, `compost`, `note`. Each
  parses to a transaction record rather than a numeric value.
  **SLC gate:** Glow parses 5 transaction forms and prints their fields on Aurora.

- [ ] **Orbit 27 -- Transaction evaluation and Mantra logging**
  Each parsed transaction evaluates to a signed Mantra fact. The fact carries
  verb, subject, quantity, unit, price, and timestamp. The Mantra log grows
  from calculation traces to a book of account.
  **SLC gate:** 5 transactions log as 5 signed Mantra facts, replay identity proven.

- [ ] **Orbit 28 -- Running balances: inventory**
  Maintain a running balance per subject. `plant tomatoes 200` adds 200; `harvest
  tomatoes 45` subtracts 45; the balance reads 155. Balances are derived from the
  Mantra log, never stored separately.
  **SLC gate:** 3 transactions on one subject produce correct running balance.

- [ ] **Orbit 29 -- Running balances: cash flow**
  `sell tomatoes 30 kg 2.50` adds 75.00 to the revenue account. The cash flow
  balance tracks income by subject. Inventory and cash flow are two views of
  the same Mantra log.
  **SLC gate:** sell transaction updates both inventory and cash flow correctly.

- [ ] **Orbit 30 -- Transaction language integration witness**
  All five verbs, both balance types, Mantra replay identity, and Aurora display.
  **SLC gate:** `terrarium/dimeroll_tx_witness.rish` runs GREEN on RV64G.

### Quest 2.2 -- The Ledger Page

*The grower sees their day. Aurora draws a ledger page with transactions, balances,
and a daily summary.*

- [ ] **Orbit 31 -- Ledger page: transaction list**
  Aurora draws a table of the day's transactions -- timestamp, verb, subject,
  quantity, price, total. Scrollable on the framebuffer console.
  **SLC gate:** 5 transactions display as a readable table on Aurora.

- [ ] **Orbit 32 -- Ledger page: inventory summary**
  Below the transaction list, Aurora draws current inventory -- subject, quantity
  on hand. Derived from the Mantra log in real time.
  **SLC gate:** inventory summary matches running balances after 5 transactions.

- [ ] **Orbit 33 -- Ledger page: daily cash flow**
  Revenue and expenses for the day, with a net. The five questions answered
  at a glance.
  **SLC gate:** cash flow summary shows correct totals for the day.

- [ ] **Orbit 34 -- Amphora daily seal**
  At end of day (or on command), the day's transactions seal as an Amphora
  vessel -- content-addressed, hash-identified, immutable. The seal travels
  through the wire to the host.
  **SLC gate:** daily seal created, hash verified, transmitted through wire.

- [ ] **Orbit 35 -- Ledger page integration witness**
  Full ledger page: transactions, inventory, cash flow, daily seal.
  **SLC gate:** `terrarium/dimeroll_ledger_witness.rish` runs GREEN on RV64G.

### Quest 2.3 -- The Query Engine

*The grower asks questions. The ledger answers from the Mantra log.*

- [ ] **Orbit 36 -- Query by verb**
  "Show me all harvests" -- filter the Mantra log by verb. Display as a
  transaction table on Aurora.
  **SLC gate:** verb query returns correct subset of transactions.

- [ ] **Orbit 37 -- Query by subject**
  "Show me everything about tomatoes" -- filter by subject across all verbs.
  **SLC gate:** subject query returns correct subset.

- [ ] **Orbit 38 -- Query by date range**
  "Show me last week" -- filter by timestamp range.
  **SLC gate:** date range query returns correct subset.

- [ ] **Orbit 39 -- Query by account and plain-text export**
  "Show me cash flow for October" -- filter by account and date. Export the
  result as plain text through the wire, readable on any device.
  **SLC gate:** account query correct; export arrives at host as readable text.

- [ ] **Orbit 40 -- Query engine integration witness**
  All four query types, export through wire, correct display.
  **SLC gate:** `terrarium/dimeroll_query_witness.rish` runs GREEN on RV64G.

---

## Act III -- The Living Server (real hardware)

*The Mantrapod meets real silicon. The same stack, the same ledger, the same
wire -- running on a board someone can hold.*

### Quest 3.1 -- Board Bring-Up

*One board boots. The stack that worked on QEMU works on silicon.*

- [ ] **Orbit 41 -- Board selection and acquisition**
  Choose a board (StarFive VisionFive 2, Milk-V Mars, SpacemiT K1, or
  successor). Document: SoC, RAM, I/O, device tree, UART base, community
  support quality. Acquire the board.
  **SLC gate:** board acquired, spec document in `active-development/`.

- [ ] **Orbit 42 -- Hello on real UART**
  The seed speaks from real silicon. A freestanding RV64G program boots on
  the board and prints to the physical UART. The first real breath.
  **SLC gate:** hello on a terminal connected to the board's UART.

- [ ] **Orbit 43 -- Full boot on real hardware**
  The nine-stage boot runs on the board. Pill, Tally, Aurora, Mantra, Caravan,
  Steward, all proving on real silicon.
  **SLC gate:** boot witness equivalent runs GREEN on the board.

- [ ] **Orbit 44 -- Wire protocol over USB-C or Ethernet**
  Mantra facts travel from the board to a host over a physical connection.
  The same wire protocol, real copper instead of QEMU virtio.
  **SLC gate:** facts sync from board to host, MVERIFY confirmed.

- [ ] **Orbit 45 -- Board bring-up integration witness**
  Full stack on real hardware with wire sync to host.
  **SLC gate:** `terrarium/mantrapod_board_witness.rish` runs GREEN on silicon.

### Quest 3.2 -- The Mantrapod

*A personal server. A device on a shelf. A grower's own records in their own hands.*

- [ ] **Orbit 46 -- Dimeroll field ledger on real hardware**
  The full field ledger runs on the board. Transactions enter, balances
  compute, queries answer, seals ship through the wire.
  **SLC gate:** field ledger end-to-end on real hardware, wire export confirmed.

- [ ] **Orbit 47 -- Power-cycle resilience**
  Prove: the system syncs through the wire, powers off, powers on, replays
  from the last sync, and every committed fact survives.
  **SLC gate:** power cycle with replay, zero facts lost.

- [ ] **Orbit 48 -- Mantrapod enclosure and form factor**
  The board in a case. USB-C for power and data. Ethernet for network. A
  form factor a person puts on a shelf beside their router.
  **SLC gate:** enclosed Mantrapod boots from power, accessible over wire.

- [ ] **Orbit 49 -- First resident deployment**
  The Mantrapod runs for a day handling real transactions. Keaton enters
  real data -- what was planted, what was harvested, what was sold -- and
  the ledger holds it faithfully.
  **SLC gate:** 24-hour deployment with real data, zero data loss, wire export.

- [ ] **Orbit 50 -- Journey completion witness**
  A single witness proves the entire journey: RV64G port, Dimeroll field
  ledger, real hardware, wire persistence, power-cycle resilience. The
  Mantrapod is a living personal server.
  **SLC gate:** journey completion witness GREEN on real silicon.

---

**Fascia:** each proven orbit advances the fascia by `0.001` per the health model.
**Witness discipline:** every SLC gate names a witness that runs GREEN on metal.
A stage claimed without a witness is a stage not landed.
**Calfive:** Quest = 5 orbits. Act I = 5 quests (25 orbits). Act II = 3 quests
(15 orbits). Act III = 2 quests (10 orbits). Journey total: 50 orbits.
