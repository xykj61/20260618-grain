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

- [x] **Orbit 5 -- Full boot witness on RV64I** (`20261105.103219`)
  All nine boot stages proven on `qemu-system-riscv64` with zero source changes to
  any `.rye` file: pill identity, Tally arena, Aurora console, Mantra log, Mantra
  wire (via Swift host with `mantra_wire64`), Caravan capabilities, Caravan
  supervision, Steward domain boot, and Glow calculator. The explicit-`u32`
  discipline carries the complete boot sequence across the register-width boundary.
  **Witness:** `terrarium/boot_witness_rv64.rish` -- nine stages, ELF identity.
  **GREEN on metal. Quest 1 complete.**

### Quest 1.2 -- Hardware Arithmetic (M extension)

*The hart learns to multiply. Every site that computed in software gains native speed.*

- [x] **Orbit 6 -- M extension: Mantra's djb2 hash at native speed** (`20261105.105231`)
  Explicit `-mcpu=generic_rv64+m` narrows the target from Quest 1's implicit
  RV64GC (`baseline_rv64`) to RV64IM only (+i,+m, no A/C/D/F). The djb2 hash
  matches the sealed constant `0x079080D9` -- identical on both targets, proving
  the `u32` discipline holds across ISA width. `mul` instruction confirmed via
  llvm-objdump. Build 437 ms, run 107 ms.
  **Critical finding:** Zig 0.17.0's `baseline_rv64` default includes +m (full
  RV64GC). Quest 1's "RV64I" builds were actually RV64GC the whole time.
  **Witness:** `terrarium/m_ext_pill_witness.rish` -- build, features, hash,
  disassembly, timing, baseline comparison. **GREEN on metal.**

- [x] **Orbit 7 -- M extension: Glow multiply and division** `20261105.110948`
  Glow's `mul` and `div` operations use hardware instructions. A focused
  M-extension calculator with 6 expressions: `(* 7 8) = 56`,
  `(/ 144 12) = 12`, `(* 6 7) = 42`, `(/ 100 3) = 33`,
  `(+ (* 3 4) (* 5 6)) = 42`, `(/ (* 12 12) 12) = 12`. All 6/6 correct.
  Disassembly confirms mul x4 and div x2 hardware instructions. ELF 6816
  bytes. Build 148 ms, run 118 ms.
  **Witness:** `terrarium/glow_m_ext_witness.rish` -- build, features, QEMU
  run, SLC gate, disassembly, timing. **GREEN on metal.**

- [x] **Orbit 8 -- M extension: Amphora seal performance** `20261105.112723`
  Amphora's content-addressing hash (djb2, `h *% 33`) compiles to hardware
  `mul` instruction on RV64IM. A 4 KiB vessel (128 header + 3968 cargo) is
  sealed, verified, and tamper-tested: seal hash `0x3f401b51`, verify PASS,
  tamper detected. Disassembly confirms 1 `mul` + 2 `divu`/`divuw` = 3
  M-extension instructions. ELF 6792 bytes. Build 156 ms, run 120 ms.
  **Witness:** `terrarium/amphora_seal_witness.rish` -- features, build,
  QEMU run, disassembly, timing. **GREEN on metal.**

- [x] **Orbit 9 -- M extension: software division removal survey**
  Surveyed all 59 arithmetic sites across 17 freestanding sources. Classified:
  runtime (38 -- all hardware M-ext), comptime (8), shift (7), assembly (1 --
  Glow pill's own repeated-subtraction loop), strings (5). Zero remaining
  software multiply/divide in authored Rye code.
  **Witness:** `terrarium/m_ext_division_survey_witness.rish` -- CPU features,
  17/17 builds, 13/13 arithmetic modules with hardware M-ext, 0 software
  division. **GREEN on metal.**

- [x] **Orbit 10 -- M extension integration witness**
  A single witness proves all M-extension work: hash, calculator, seal, and
  the full boot sequence with hardware arithmetic throughout.
  **SLC gate:** `terrarium/m_extension_witness.rish` runs GREEN on RV64M.

### Quest 1.3 -- Atomic Supervision (A extension)

*The hart becomes safe under concurrency. Caravan's tables gain atomic operations,
and the system prepares for multi-hart boot.*

- [x] **Orbit 11 -- A extension: atomic capability table**
  Caravan's capability table uses `amoadd`, `amoswap`, and `lr`/`sc` for
  concurrent access. Prove: two domains accessing the same table see consistent state.
  **SLC gate:** concurrent capability grant and revoke produce correct state on RV64A.

- [x] **Orbit 12 -- A extension: atomic domain registry** (`20261105.153500`)
  Caravan's domain registry uses atomic operations for slot claiming
  (`@cmpxchgWeak` -> lr.w/sc.w), state finalization (`@atomicRmw .Xchg` ->
  amoswap.w), domain counting (`@atomicRmw .Add/.Sub` -> amoadd.w), and
  shutdown (`@cmpxchgWeak` ACTIVE -> SHUTDOWN). Two stewards (alpha, beta)
  register 5 domains, shut down 2, contest slot 4 (first writer wins), census
  matches atomic counter at 3. 8 proofs, 13 A-extension instructions in binary.
  ELF 10040 bytes.
  **Witness:** `terrarium/atomic_registry_witness.rish` -- features, build,
  QEMU 8-proof run, A-ext census. **GREEN on metal.**

- [x] **Orbit 13 -- Multi-hart boot on QEMU (2 harts)**
  Boot QEMU with `-smp 2`. The primary hart runs the boot sequence; the secondary
  hart waits at a barrier and joins after Caravan is ready.
  **SLC gate:** both harts report through Aurora; Caravan supervises domains on both.
  **Landed `20261105.143315`.** 2-hart boot with atomic gate and ticket spinlock.
  5 proofs, 29 A-ext instructions (lr.w, sc.w, amoadd.w, fence), 7128-byte ELF.
  **Witness:** `terrarium/multi_hart64_witness.rish` -- features, build,
  QEMU `-smp 2` 5-proof run, A-ext census. **GREEN on metal.**

- [x] **Orbit 14 -- Preemptive scheduling foundation**
  Caravan gains a round-robin scheduler across 2 harts. Timer interrupt (CLINT)
  triggers context switch. Each domain's register state is saved and restored.
  **SLC gate:** two domains time-slice on one hart; both produce correct output.
  **Landed `20261105.151301`.** CLINT timer interrupt at 50,000-tick timeslice,
  full 31-register context save/restore via mscratch swap pattern, round-robin
  between domain A (count 1-5, checksum 15) and domain B (count 101-105,
  checksum 515). 12 context switches, genuine interleaving confirmed.
  5 proofs, 20 CSR instructions (2 mret, 2 csrrw, 6 csrw), 7544-byte ELF.
  **Witness:** `terrarium/preempt_witness.rish` -- features, build,
  QEMU 5-proof run, trap instruction census. **GREEN on metal.**

- [x] **Orbit 15 -- A extension integration witness** (`20261105.154640`)
  All four A-extension modules built and proven together on 2-hart RV64IMA.
  7 stages: CPU features, build all 4, atomic_cap (7 proofs), atomic_registry
  (8 proofs), multi_hart with -smp 2 (5 proofs), preempt (5 proofs), combined
  census -- 37 A-ext instructions (13 lr.w, 13 sc.w, 8 amoadd.w, 3 amoswap.w),
  21 CSR instructions, 80 fence, 142 sd, 90 ld across 33,832 bytes of ELF.
  **Witness:** `terrarium/a_extension_witness.rish` -- 7 stages, 25 proofs
  total, combined A-extension + trap instruction census. **GREEN on metal.**
  **Quest 1.3 complete.**

### Quest 1.4 -- Numeric Precision (F/D extensions)

*The hart learns floating point. Glow gains real numbers, and the door to Lotus
audio opens on the bare hart.*

- [x] **Orbit 16 -- F/D extensions: Glow floating-point expressions** (`20261105.160234`)
  The Glow evaluator handles `3.14`, `2.718`, and arithmetic on them. IEEE 754
  double precision. Results display with two decimal places on Aurora. FPU enabled
  via `mstatus.FS` in `_start`. 8 expressions: 2 literals, mul (`3.14 * 2.0` =
  6.28, SLC gate), add, sub, div (22/7 and 355/113), composite add+mul. All 8/8
  correct with epsilon comparison (0.005). F/D census: 44 instructions (8 arith:
  2 fadd.d, 3 fsub.d, 2 fmul.d, 1 fdiv.d; 21 load/store: 14 fld, 7 fsd;
  5 flt.d comparisons; 3 fcvt, 6 fmv, 1 fneg.d). 7808-byte ELF.
  **Witness:** `terrarium/glow_fp_witness.rish` -- features, build, QEMU
  8-expression run with 11 proofs, F/D instruction census. **GREEN on metal.**

- [x] **Orbit 17 -- F/D extensions: Caravan FP context save/restore** (`20261105.172652`)
  Caravan saves and restores `f0`-`f31` and `fcsr` on context switch. 65-slot
  extended context (520 bytes): 30 GP regs + mepc + 32 FP regs + fcsr. Two
  domains using IEEE 754 f64 arithmetic produce correct checksums (A: 1875,
  B: 15750) through 12 context switches with genuine preemption. Root cause
  of `@atomicLoad` infinite recursion on freestanding targets discovered and
  fixed with volatile pointer casts. FP census: 105 instructions (40 fsd,
  33 fld, 5 fadd.d, 5 fmul.d, 5 fcvt, 15 fmv, 2 flt.d). 8912-byte ELF.
  **SLC gate:** preempted FP domain resumes with correct FP state -- PROVEN.
  **Witness:** `terrarium/fp_context_witness.rish` -- features, build,
  QEMU 10-proof run, FP context instruction census. **GREEN on metal.**

- [x] **Orbit 18 -- F/D extensions: Dimeroll price arithmetic** (`20261105.180400`)
  Four Dimeroll field-ledger transactions on hardware FP: three sales (tomatoes
  30.00 x 2.50 = 75.00, peppers 12.00 x 3.75 = 45.00, basil 0.50 x 18.00 = 9.00)
  and one purchase (seeds 200.00 x 0.35 = 70.00). Revenue 129.00, expense 70.00,
  net 59.00, tax 5% = 6.45 -- all verified against integer-cent checksums. FP
  census: 50 instructions (8 fmul.d, 8 fadd.d, 1 fsub.d, 7 fsd, 3 fld, 6 fcvt,
  16 fmv, 1 flt.d). 6512-byte ELF.
  **SLC gate:** transaction with price computes correct total on RV64FD -- PROVEN.
  **Witness:** `terrarium/dimeroll_price_witness.rish` -- features, build,
  QEMU 8-proof run, FP instruction census. **GREEN on metal.**

- [x] **Orbit 19 -- Lotus audio sample type on the bare hart**
  A single Lotus audio operation (a gain or fade) runs on the bare hart using
  hardware FP. The sample buffer is Tally-bounded. Proof of concept for Lotus
  on the Mantrapod.
  **SLC gate:** 256-sample gain operation produces correct output on RV64FD -- PROVEN.
  **Landing:** 256-sample triangle wave (first 128 ramp 0.0 -> 1.0, next 128
  ramp 1.0 -> 0.0) with gain 0.5 applied via hardware fmul.d. Sum after gain
  = 64.00 (6400 cents), peak = 0.50 (50 cents), each half sum = 32.00 (3200
  cents), endpoints 0.00. All 6 integer-cent checksums verified. FP census: 64
  instructions (8 fmul.d, 10 fadd.d, 2 fdiv.d, 9 fsd, 5 fld, 9 fcvt, 19 fmv,
  2 flt.d). 6496-byte ELF.
  **Witness:** `terrarium/lotus_audio_witness.rish` -- features, build,
  QEMU 6-proof run, FP instruction census. **GREEN on metal.**

- [x] **Orbit 20 -- F/D extension integration witness** (`20261105.182500`)
  Full boot with all G extensions: I + M + A + F + D. 19 modules rebuilt with
  `-mcpu=generic_rv64+m+a+f+d`, each run on QEMU and all proofs verified. 10
  stages: CPU features (+m +a +f +d), build 19/19, pill 0x079080D9, Glow M-ext
  6/6, Amphora seal/verify/tamper, full boot 8/8 (Tally, Aurora, Mantra log,
  Mantra wire via Terrarium, Caravan cap, supervision, Steward, Glow app 10/10),
  A-ext 4/4 (atomic_cap, atomic_registry, multi_hart -smp 2, preempt),
  F/D 4/4 (glow_fp 8/8, fp_context 6 proofs, dimeroll_price 8/8, lotus_audio
  6/6), combined census: M=42, A=117, FP=184, CSR=23 across 19 modules.
  **SLC gate:** `terrarium/rv64g_witness.rish` proves all 10 stages GREEN on
  RV64G -- PROVEN.
  **Witness:** `terrarium/rv64g_witness.rish` + `terrarium/rv64g_helper.sh` --
  10 stages, 19 modules, all extensions proven. **GREEN on metal.**
  **Quest 1.4 complete.**

### Quest 1.5 -- The Wider World (full RV64G boot and WASM horizon)

*The full stack runs on the wider hart. The browser horizon opens.*

- [x] **Orbit 21 -- Full RV64G boot witness** (`20261105.190200`)
  A single witness proves the complete boot on RV64G: pill, Tally, Aurora, Mantra,
  wire, Caravan caps, Caravan supervision, Steward, Glow app -- all nine stages
  plus M, A, and F/D integration.
  **SLC gate:** `terrarium/boot_witness_rv64g.rish` runs GREEN, all 19 modules proven.

- [x] **Orbit 22 -- Terrarium macOS app on RV64G** (`20261105.184157`)
  Swift app updated: `is64Bit` recognizes `_g` suffix, `isMultiHart` passes `-smp 2`.
  Four stages proven through the glass: glow_app_g (10/10), steward_g (2 domains),
  amphora_seal_g (seal + tamper), multi_hart_g (atomic on 2 harts).
  **SLC gate:** `terrarium/terrarium_rv64g_witness.rish` runs GREEN, Terrarium launches riscv64 for `_g` stages.

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
