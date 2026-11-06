# Act II Scoping -- Dimeroll Field Ledger on RV64G

**Status:** Living -- scoping document
**Room:** development
**Style:** Gauge at the Field setting
**Stamp:** `20261105.204535`
**Journey:** `active-tablecloth/20261105-085747_mantrapod-rv64g-journey/`

Act II covers 15 orbits (26-40) across 3 quests. The field ledger records what a
small farm grows, harvests, sells, composts, and notes -- five verbs, each a Mantra
fact, with running balances derived from the log and queries answered by a simple
engine. Every module runs on freestanding RV64G through the Terrarium app, proven
by the same witness discipline Act I established.

## The five transaction verbs

Each verb is a Mantra fact with a fixed record shape. The grammar is intentionally
small -- five verbs cover a working farm's daily book.

| Verb | Meaning | Fields |
|---|---|---|
| **plant** | Put something in the ground or start a batch | subject, quantity, unit, date |
| **harvest** | Take something out of the ground or finish a batch | subject, quantity, unit, date |
| **sell** | Exchange product for money | subject, quantity, unit, price_cents, date |
| **compost** | Return something to the soil or write off a loss | subject, quantity, unit, date |
| **note** | A free-text observation attached to a subject and date | subject, text, date |

**Subject** is a plain string -- `tomatoes`, `basil`, `eggs`. **Quantity** is a u32
count. **Unit** is a short string -- `kg`, `bunch`, `dozen`, `each`. **Price_cents**
is a u32 in integer cents (Dimeroll's existing discipline from Orbit 18). **Date** is
a u32 day number (days since epoch, fitting comfortably in 32 bits for millennia).
**Text** is a bounded string, 128 bytes max.

### Record encoding

Each transaction is one Mantra fact. The fact's key encodes the verb and subject;
the fact's value encodes the remaining fields. This reuses Mantra's existing
append-only log, replay, and state-hash infrastructure without any new storage
format.

```
key:   "plant:tomatoes"
value: "qty=50,unit=kg,day=20547"
```

The colon-separated key lets the query engine filter by verb or subject with a
prefix match. The comma-separated value is parsed by the balance engine. Both are
plain ASCII strings bounded by Mantra's existing fact-size limit.

### Glow surface

A Glow expression evaluates to a transaction:

```
(plant tomatoes 50 kg)
(sell tomatoes 12 kg 350)
(note tomatoes "first frost damage on north row")
```

The Glow parser extension recognizes the five verb keywords and produces the
corresponding Mantra fact. This is a thin layer -- Glow already parses
s-expressions with atoms and strings, and the verb is simply the first atom.

## Running balance model

**Balances are derived from the Mantra log, never stored separately.** This is the
core design decision: replay the log, accumulate the balances, and the current
state is always a pure function of the history. Mantra already proves this with
its state-hash replay mechanism (Orbit 4, hash `0xbc186e04`).

### Inventory balance

For each subject, scan the log and accumulate:

```
inventory[subject] += quantity   when verb is plant or harvest
inventory[subject] -= quantity   when verb is sell or compost
```

Plant adds to the field. Harvest adds to the barn (ready to sell). Sell and
compost remove from the barn. The sign convention: plant and harvest are inputs,
sell and compost are outputs.

A more precise model tracks two stages -- field (planted, not yet harvested) and
barn (harvested, ready for sale) -- which the five verbs naturally separate:

| Stage | Increased by | Decreased by |
|---|---|---|
| **field** | plant | harvest (moves to barn), compost |
| **barn** | harvest | sell, compost |

The two-stage model is the build target. A single-stage summary (total on hand) is
derived by summing both.

### Cash flow balance

For each subject and in total, scan the log and accumulate:

```
revenue[subject] += price_cents   when verb is sell
```

Only `sell` carries a price. Revenue is the only cash-flow entry in this first
version -- expenses (seed purchase, equipment) are a future verb family, not in
scope for Act II.

### Daily seal

At the end of each logical day, the balance state is sealed with Amphora (Orbit 8,
hash `0x3f401b51`). The seal covers:

- The Mantra state hash after all facts for that day
- The inventory balances (field + barn per subject)
- The revenue total

This gives a daily checkpoint that can be verified independently, using the same
seal-and-verify discipline Amphora already provides.

## Query engine

The query engine answers four questions, each returning a list of matching
transactions. All queries scan the Mantra log -- there is no index. The log is
small enough (a working farm's daily book) that a linear scan is the right first
answer, and Mantra's fact iterator already exists.

### Query 1: by verb

Return all transactions of a given verb. Implementation: prefix-match the fact key
up to the colon.

```
query verb=sell
  -> sell:tomatoes qty=12 unit=kg price=350 day=20547
  -> sell:basil qty=5 unit=bunch price=200 day=20548
```

### Query 2: by subject

Return all transactions for a given subject, across all verbs. Implementation:
suffix-match the fact key after the colon.

```
query subject=tomatoes
  -> plant:tomatoes qty=50 unit=kg day=20540
  -> harvest:tomatoes qty=30 unit=kg day=20545
  -> sell:tomatoes qty=12 unit=kg price=350 day=20547
```

### Query 3: by date range

Return all transactions within a day range. Implementation: parse the day field
from each fact's value and filter.

```
query days=20545-20548
  -> harvest:tomatoes qty=30 unit=kg day=20545
  -> sell:tomatoes qty=12 unit=kg price=350 day=20547
  -> sell:basil qty=5 unit=bunch price=200 day=20548
```

### Query 4: by account (subject + verb)

Return all transactions for a specific subject and verb combination, plus the
running balance at each step. This is the ledger page for one crop's one activity.

```
query account=sell:tomatoes
  -> sell:tomatoes qty=12 unit=kg price=350 day=20547 running_revenue=350
  -> sell:tomatoes qty=8 unit=kg price=280 day=20550 running_revenue=630
```

### Plain-text export

Every query result can be exported as plain text -- one line per transaction, with
a summary line at the end. The export format is what Aurora will display, and what
a farmer could paste into a message or print. No binary format, no database file --
the Mantra log is the database, and the export is a view.

## Aurora ledger page

Aurora (Orbit 3, the console display) gains a ledger page that shows:

1. **Transaction list** -- the most recent N transactions, newest first
2. **Inventory summary** -- field and barn quantities per subject
3. **Daily cash flow** -- revenue by day for the current period
4. **Seal status** -- the most recent Amphora daily seal hash

The page is a single Aurora render call producing a bounded text block, the same
pattern Aurora already uses for the console display. No scrolling, no interaction --
a snapshot of the current state, rendered fresh on each call.

## Module architecture

Act II grows existing modules rather than creating many new ones. The existing
19-module stack provides the infrastructure; Act II adds the application.

### Existing modules that grow

| Module | What it gains |
|---|---|
| **Glow** (`glow_app.rye`) | 5 verb keywords in the parser, transaction evaluation |
| **Mantra** (`mantra_log.rye`) | Transaction fact encoding/decoding helpers |
| **Dimeroll** (`dimeroll_price.rye`) | Balance accumulation, inventory model |
| **Amphora** (`amphora_seal.rye`) | Daily seal over balance state |
| **Aurora** (`aurora_console.rye`) | Ledger page renderer |

### New modules

| Module | Purpose |
|---|---|
| **dimeroll_ledger.rye** | Query engine -- the four query types, plain-text export |
| **dimeroll_balance.rye** | Balance model -- field/barn inventory, cash flow derivation |

Two new modules. Both are pure computation over Mantra facts, with no new storage
format, no new I/O, and no new kernel interface.

### Data flow

```
Glow expression
  -> Glow parser (verb recognition)
  -> Mantra fact (append to log)
  -> Dimeroll balance (derive from log replay)
  -> Amphora seal (daily checkpoint)
  -> Aurora page (render current state)
  -> Query engine (filter and export)
```

Each arrow is a function call. No callbacks, no event system, no async. The
transaction enters as a Glow expression and exits as a sealed, queryable ledger
entry. The whole path runs in a single freestanding binary on RV64G.

## Quest breakdown

### Quest 2.1: Transaction language (Orbits 26-30)

Five orbits, one per verb plus integration.

- **Orbit 26:** `plant` verb -- Glow keyword, Mantra fact encoding, single-verb witness
- **Orbit 27:** `harvest` verb -- field-to-barn transfer, two-stage inventory
- **Orbit 28:** `sell` verb -- price_cents, revenue accumulation
- **Orbit 29:** `compost` and `note` verbs -- write-off and free-text observation
- **Orbit 30:** Transaction integration witness -- all 5 verbs, balance derivation,
  daily seal, SLC gate

### Quest 2.2: Ledger page (Orbits 31-35)

Five orbits building the Aurora display and the balance model.

- **Orbit 31:** Transaction list display -- most recent N, formatted
- **Orbit 32:** Inventory summary -- field and barn per subject
- **Orbit 33:** Daily cash flow -- revenue by day
- **Orbit 34:** Amphora daily seal -- seal over balance state
- **Orbit 35:** Ledger page integration witness -- full page render with seal, SLC gate

### Quest 2.3: Query engine (Orbits 36-40)

Five orbits, one per query type plus integration.

- **Orbit 36:** Query by verb -- prefix match, result list
- **Orbit 37:** Query by subject -- suffix match, cross-verb results
- **Orbit 38:** Query by date range -- day field parsing, range filter
- **Orbit 39:** Query by account -- subject + verb, running balance
- **Orbit 40:** Query integration witness -- all 4 queries, plain-text export, SLC gate

## Design decisions

**Balances derived, never stored.** The Mantra log is the single source of truth.
A balance is a view computed by replaying the log. This means no sync between a
balance table and a fact log, no corruption from a partial write, and no migration
when the balance model changes. The cost is a full scan on every query -- acceptable
for a farm's daily volume, and the performance baseline (Orbit 24) shows Mantra
processes ~6,400 facts/sec on QEMU.

**Integer cents throughout.** Dimeroll's existing discipline (Orbit 18) uses u32
integer cents for all monetary values. No floating point in the ledger. This is
already proven on RV64G with the F/D extension available but deliberately unused
for money.

**Five verbs, not a general grammar.** A small farm's book needs five words. A
general-purpose accounting grammar would need dozens, and the complexity would land
in the parser rather than in the domain. The five verbs are the domain.

**Plain text over structured format.** The export is lines of text, not JSON or CSV.
A farmer reads text. A program that needs structure parses the Mantra log directly.

**Two new modules, not five.** The balance model and the query engine are the only
new computation. Everything else grows an existing module that already has its own
witness, its own build path, and its own place in the RV64G stack.

## What this scoping does not cover

**Expenses.** Seed purchase, equipment, labor -- a future verb family. Revenue-only
cash flow is the honest first version.

**Multi-user.** One ledger, one farmer. Network sync and shared books are Act III
or beyond.

**Persistence across sessions.** The Mantra wire (Orbit 19) already sends facts to
the host. A full persistence layer -- save to disk, reload on boot -- is the wire's
natural extension and belongs in Act III's real-hardware quests.

**Currency and locale.** Integer cents in one currency. Conversion and formatting
are display concerns that belong in Aurora's render path, not in the balance model.
