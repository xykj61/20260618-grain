# Waymark Ladders — Draw Before You Number

**Canon:** `context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md` · witness `tools/waymark_derive.rish` · Lexicon **Waymark**.

**Immutable registry (single source of truth, seated `20260817`):** [`../../crux/waymark-registry.bron`](../../crux/waymark-registry.bron) is the sealed, self-verifying canonical record of **every** waymark ever drawn -- living, retired, abandoned, transient, hand-seated -- each corpus row carrying its input, index, and status. Witness [`../../tools/waymark_registry_witness.rish`](../../tools/waymark_registry_witness.rish) proves it GREEN two ways: a **SHA3-512 seal** over the body (any edit breaks it) and a **re-derivation** of every corpus mark from its input on metal. This registry is the authority; the table below is its readable face. Because the canonical truth is sealed here, the elder marks in old logs and git history are redundant historical noise -- the naming truth no longer depends on them.

## When a ladder opens

Before the first rung is written as `X0` / `X1` / … in TASKS, ROADMAP, compressors, module titles, or session logs that speak as *now*:

1. Choose a **canonical hyphenated input name** for the ladder (stable, descriptive, lowercase).
2. Set `input_name` in `tools/waymark_derive.rish` and run `rishi/bin/rishi run tools/waymark_derive.rish`.
3. Seat the printed four-letter **waymark** in Lexicon + the script’s seated-draws comment + exclude list.
4. Name every rung `WAYMARK0`, `WAYMARK1`, … — never a bare capital letter alone (`B0`, `G0`) for a new ladder.

## Seated waymarks (do not redraw)

| Waymark | Input | Ladder |
|---|---|---|
| **pixel-glass** | `grapheneos-pixel-mobile-emulation` | Pixel / GrapheneOS SLC |
| **glow-publishing** | `glow-application-framework-and-publishing` | App framework / packaging |
| **glass-keyboard** | `glow-english-qwerty-glass-keyboard-3` | Glass English QWERTY keyboard |
| **seva-broadcast** | `sala-broadcast-live-session-fold` | Seva broadcast session fold (was bare B0–B3) |
| **hearth-display** | `glow-glass-hearth-display-and-wired-sync` | Hearth display presets · short home · Wired Glass |
| **glow-language** | `glow-language-rune-heads-nest-and-lowering-2` | Glow language SLC · rune heads · nest · composition |
| **usb-hearth** | *(hand-seated; not a corpus draw — absent from flw)* | USB hearth carry Glass↔Desk |
| **source-identity** | `source-pier-papers-identity-refresh` | SOURCE.md identity · remotes · apps · onboarding refresh |
| **djinn-exec** | `djinn-bozo-exec-keaton-murr-hats` | DJINN → Bozo exec · Keaton → Murr exec · Linn→Bozo Capricorn 10 |
| **compass-language** | `glow-language-runes-stdlib-and-pipeline` | Compass Chapter Equinox 1 — The Language (Glow runes · stdlib/PLEAC · Brix-infuse · pipeline) |
| **compass-identity** | `kumara-identity-comlink-and-fractal-network` | Compass Chapter Equinox 2 — Identity & Network (Kumara · d12/d60 topology · Comlink · settlement) |
| **compass-surface** | `realidream-surface-and-quin-inference-and-mcp-2` | Compass Chapter Equinox 3 — Surface & Intelligence (Realidream · Quin voices · MCP-in-Bron) |
| **compass-world** | `ship-pilot-publishing-grainphone-and-commerce` | Compass Chapter Equinox 4 — The World (Ship-Pilot · publishing · Grainphone · commerce) |
| **harvest-yield** | `harvest-season-equinox-1-yield` | Harvest Chapter Equinox 1 — Yield (prove built modules on real data) |
| **harvest-trade** | `harvest-season-equinox-2-trade` | Harvest Chapter Equinox 2 — Trade (fair-trade certification · cash-first) |
| **harvest-commons** | `harvest-season-equinox-3-commons` | Harvest Chapter Equinox 3 — Commons (Skate social layer · community) |
| **harvest-rest** | `harvest-season-equinox-4-rest` | Harvest Chapter Equinox 4 — Rest (consolidation · saga close · 3/4 reading) |
| **cion-molt** | `meta-season-chronological-labeling-molt` | cion-molt Meta-Chapter — molt·debride·sweep count-up IDs → chronological/semantic labels (after Compass) |
| **cion-survey** | `cion-meta-season-equinox-1-survey` | cion-molt Equinox 1 — Survey (name every living count-up ID: site · gap) |
| **cion-living-molt** | `cion-molt-living-mutants-and-fossils` | cion-molt Equinox 2 — Molt (relabel living now-lines chronological/semantic). **Renamed from cion-living-molt** (breach executed `20260817`, cairn `crux/CAIRNS.md 20260817.173615`, idx 2813); cion-living-molt kept in the derive exclude as historical, and dated session logs + the REDS ledger keep cion-living-molt as the label they recorded. |
| **cion-debride** | `cion-meta-season-equinox-3-debride` | cion-molt Equinox 3 — Debride (word-gated cuts of dead count-up tissue, cairns first) |
| **cion-seal** | `cion-meta-season-equinox-4-seal` | cion-molt Equinox 4 — Seal (witness the conversion · seat the labeling-law guard) |
| **AHOY** | `root-readme-lindy-foundation-weave-and-seed-legitimacy` | Front-door season — root README rewrite (Lindy-durable, favorite words) · Lindy foundation silo · fascia crosslink weave · seed legitimacy + final depersonalized push |
| **dimeroll-expansion** | `dimeroll-hr-and-accounting-entities` | Double-seated beside AHOY — DJINN's Bit Design System over the Skate·Realidream·Brushstroke surface (DVUI/Zig 0.16 in a Swift macOS Dock shell, Glow·Rishi·Rye·.brush impl) · Pond onboarding · Vultr SEA IaC · Dimeroll expansion for Siya Fund + Linengrow PBC HR & accounting. Name chain **dimeroll-expansion -> dimeroll-expansion -> dimeroll-expansion**: dimeroll-expansion renamed to dimeroll-expansion `20260817` (dimeroll-expansion drawn from the then-module name `...-dimeroll-entities`, idx 127); when Dimeroll renamed to **Dimeroll**, dimeroll-expansion was re-breached on Keaton's word to **dimeroll-expansion** (idx 5141) from the dimeroll-consistent preimage `dimeroll-hr-and-accounting-entities`. dimeroll-expansion and dimeroll-expansion both kept in the derive exclude as historical; dated session logs keep whichever label they recorded. |
| **open-image** | `season-a-open-image-decode-and-photos-surface` | Six-Chapter expansion Chapter A — Hardware & Right-to-Repair; opening journey the **open image module** (QOI decode → bounded RGBA grid, content-addressed in Tablecloth) beneath the parts marketplace and Photos app |
| **mikrophone** | `season-a-mikrophone-forgetful-capture` | Chapter A second journey -- the **Mikrophone firmware** (the Mantrapod's near-term surface): the *memory that forgets* session buffer, proven pure in Rye before metal -- a bounded capture held only while powered, persisted only on a deliberate commit, provably dissolved on power-down. **Renamed from mikrophone** (breach executed `20260817`, cairn `crux/CAIRNS.md 20260817.173615`, idx 1189, ~502 sites: the `mikrophone/` module rungs mikrophone..mikrophone and 17 `tools/drey_*` witnesses); mikrophone kept in the derive exclude as historical, and dated session logs + the REDS ledger keep mikrophone. |
| *breach round `20260817` -- five breaches executed* | *cairn `crux/CAIRNS.md 20260817.173615`* | Five **breaches** landed in the living tree, each proven on metal and seated as its own row above: **mikrophone -> mikrophone** (idx 1189, ~502 sites), **constels-naming -> constels-naming** (idx 1594, ~1027 sites), **cion-living-molt -> cion-living-molt** (idx 2813), **dimeroll-expansion -> dimeroll-expansion -> dimeroll-expansion** (dimeroll-expansion a transient dimeroll-era draw, re-breached to dimeroll-expansion when the module became Dimeroll), and the module **Dimeroll -> Dimeroll** (54 files). These are **breaches, not full debrides**: the living tree carries the new names, yet the elder marks still live in **git history** and the **dated session logs**. The full **debride** -- purging the elders from *all* history -- is a later **deep debride** (history rewrite + force-push, **custody gate #1**, Keaton's hand), not done here. The elders stay in the derive exclude as historical; the old-waymark logs are **molted** (prepped for shed) on `crux/SHRED_PREP.md` toward that eventual debride, the shred **RED** until circled. |
| **constels-naming** | `constel-local-test-constellations` | **Constel** test-network naming — self-invented, siloed names for sandbox/testnet/localhost Comlink p2p constellations (fake ships, fake piers) run from inside the jailed pier, elder Urbit fake-galaxy dev nets as ancestor; consonant-only, structurally never a live-valid `@p` (segment lengths never 3), under the placeholder-ship-names law. **Renamed from constels-naming** (breach executed `20260817`, cairn `crux/CAIRNS.md 20260817.173615`, idx 1594); constels-naming kept in the derive exclude as historical, and dated session logs keep constels-naming. |
| **lotus-audio** | `season-c-lotus-creative-suite-audio-wire-shape` | **Lotus** creative suite (Chapter C double-seat) — the basic audio **wire shape**: a self-describing, Sha256-sealed frame carrying an opaque PCM sample buffer tagged by cable kind (XLR · USB-C · guitar), deframed verify-before-trust. Software carrier only; electrical/pinout specifics and audio-interface hardware stay a paused hardware-research round |

**Hand-seated names on the exclude roster** (not waymark draws): **SEVA** (viewer; absent from flw), **MAND** (M vane; in flw), **MONA** (prior name of Mand — one season). **SALA** retired from exclude with the Sala→Seva alias close.

Corpus pin: `tools/fixtures/flw-four-letter.txt` · witness `tools/waymark_derive_witness.rish`.

## Accrete-never-break

Dated logs and research that already say `B0` / `B1` / `B2` stay readable. Living *Now* lines, new modules, new commits, and compressors use **seva-broadcast** (and other seated waymarks) from the draw forward.

## Collision

If the derive assert goes RED (word hits a seated module or waymark name), append `-2` to `input_name` and redraw — same method as the spec.
