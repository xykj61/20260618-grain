# Tasks — living pin

**Language:** EN
**Last updated:** `20260809.024320` · voice Riyo
**Living pin bound:** `living_pin_max_bytes = 24576`
**Operator card:** [`REMEMBER.md`](REMEMBER.md)
**Ledger:** [`THREADS.md`](THREADS.md)

---

## Now — The Compass Chapter · compass-identity j1 (`20260809.154500`)

**Finishing edge:** compass-identity j1 — the Kumara identity template. compass-language's language spine complete; now at Identity & Network. `kumara/tilak.rye` seats the **point** and **bind** tilaks (Ed25519, signed both ways, Azimuth-tiered, Bron-emitted, witnessed).
**Prove:** `rishi/bin/rishi run tools/kumara_tilak_witness.rish`

| Lap | Equinox | Status |
|-----|---------|--------|
| **Kumara identity template** — all five tilaks (point · bind · turn · cap×3 · sponsor), each signed by its authorizing party, Bron instance, witnessed | compass-identity | **LANDED** — the whole tilak shape |
| Kumara settlement ledger (Sui or Grain-native) · final scarcity tiering · human-name custody | compass-identity | word-gated — Keaton's call |
| **Comlink turn-route** — routing reads the turn tilak (verify · freshest-wins · replay/forgery refused), hands the wire the networking key | compass-identity | **LANDED** (`comlink/turn_route.rye`) |
| **Comlink live handshake** — introduction gate admits + rotation gate keys the wire, independently | compass-identity | **LANDED** (`comlink/handshake_turn.rye`) |
| **Descriptor carries the turn on the wire** — `handshake_wire` recovers it from 112 descriptor bytes (`turn_to_bytes`), loop closed | compass-identity | **LANDED** |
| **d12·d60 fractal topology** — the address space (12·5·12, d60=60, 792/universe), sponsor chain, routing by number | compass-identity | **LANDED** (`comlink/topology.rye`) |
| Reconcile the Point's tier (elder Azimuth 2⁸/2¹⁶/2³²) with the topology's d12·d60 scarcity | compass-identity | Keaton's word |
| Settlement — the constellation on Sui | compass-identity | next journey · word-gated |
| Rishi rune heads — `^-` · `?!` · `?&` · `?|` landed | compass-language | **LANDED** (four heads) |
| Rishi **`matches`** + **`find`** pattern primitives — bounded NFA, `{n,m}` · `\b`, linear-time, 600+ cases vs Python re | compass-language | **LANDED** — boolean-test and extract seams both unlocked |
| Rishi `sort` · `unique` · `upper` · list `+` · lookbehind | compass-language | **LANDED** |
| **Fold `claim_preserve` to native Rishi** — extractor + modality, gate GREEN + python-free | compass-language | **LANDED** — first complete seam fold (40/41 byte-identical) |
| Rishi **`?:` conditional rune** (wutcol) — value-returning if; with `fold` folds census seams natively (proven on H1 count) | compass-language | **LANDED** — accumulation solved (`fold` already threaded state) |
| Rishi **user functions** (`fn name p: body`, recursion, calls in folds) | compass-language | **LANDED** |
| Fold census seams — `census_control` H1 folded native; `dated_classify` census proven native (3.9s) yet keeps bulk-`rg` (20×); `shed` mention scan bulk by measure | compass-language | **census_control DONE** · dated_classify perf-kept |
| Molt Python → Rishi — `dated_classify` fully ported (census·classify·health·shed, all byte-identical) · `census_control` de-Pythoned · runpy scans (`shed_census`·`fascia_health`) + divergence GREEN · `remember_pin` shredded · `lower` builtin | compass-language | **dated subsystem Python-free** · ~10 more `.sh` embed python3 (next laps) |
| `mold → shape` debride (82 files / 753) | compass-language | proposed · own pass |
| TAME core/shelf compression | compass-language | proposed |
| Brix + Brix-infuse | compass-language j2 | proposed |
| Two-grain seed publish to grain-os | compass-language/compass-world | awaiting Keaton's read of `seed/` |
| Identity · Surface · World doors | compass-identity/compass-surface/compass-world | word-gated |

---

*May the first rune be the ground of the next.*
