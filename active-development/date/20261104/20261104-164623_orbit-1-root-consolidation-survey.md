# Orbit 1 -- Root Directory Consolidation Survey

**Stamp:** `20261104.164623`
**Voice:** Kyri
**Style:** Gauge at Field
**Status:** Living
**Room:** Checkable
**Journey:** Terrarium Boot Journey -- Quest 1.1, Orbit 1
**Captain:** Incense

---

## What this is

A survey of every root directory in this tree -- 89 of them, confirmed by `ls -d */` --
with a verdict per directory: **keep** at root, **merge** under a parent, or **move** to
a better home. The survey is the deliverable; no files move yet. Each proposed move is a
molt-breach circled separately on Keaton's word.

Measured `20261104.164623` by `git ls-files <dir> | wc -l` (tracked files) and
`git grep -l "<dir>/" -- '*.md' '*.rish' '*.rye' '*.kyri' '*.kyri.md' '*.sh'`
(inbound reference count). Both figures are free -- run the commands.

## Summary

| Category | Count | Root dirs |
|---|---|---|
| Module ring (the machines) | 33 | Keep: each is a Rye module with its own witnesses |
| Language and compiler | 3 | Keep: glow, rye, src |
| Workrooms | 13 | Keep: the bench and its instruments |
| Law and foundations | 3 | Keep: context, foundations, saga |
| Teaching | 4 | Propose merge under `docs/` |
| Reading room | 4 | Keep: external-research, gratitude, vendor, research-silo |
| Study silos | 5 | Propose merge under `study/` |
| Private rooms | 3 | Keep: keys, press, rye-learning-process |
| Infrastructure | 4 | Keep: nixos, open, fleet, recursion-prompts |
| Small/stub rooms | 10 | Propose merge or retire |
| Gitignored runtime | 2 | Keep: session-output, programming (0 tracked files) |
| New project boards | 1 | Keep: tablecloth |
| **Total** | **89** | **Proposed: 55 keep, 19 merge, 13 move, 2 retire** |

## Verdict table -- every root directory

### Keep at root (55 directories)

These directories belong at root. Each is either a load-bearing module room with its own
README and witnesses, a workroom the bench reads daily, or a law/context room cited
across the tree.

**Module ring (33):**

| Directory | Files | Refs | What it holds |
|---|---|---|---|
| `amphora/` | 13 | 498 | Sealed vessels -- content-addressed storage |
| `aurora/` | 14 | 282 | The boot -- six proven stages on QEMU RV64 |
| `basin/` | 1 | 13 | A single `basin.rye` module stub |
| `brushstroke/` | 87 | 508 | Drawing -- the rendering surface |
| `caravan/` | 136 | 922 | Supervision -- capabilities, leases, dependents |
| `cellar/` | 2 | 61 | Ring-1 manifest shape spec |
| `comlink/` | 118 | 680 | Wires -- the communication layer |
| `constel/` | 35 | 175 | Test-network naming modules |
| `crypto/` | 93 | 559 | Cryptographic primitives |
| `dimeroll/` | 7 | 88 | HR, accounting, Bit Design System |
| `ember/` | 5 | 131 | The inference forge |
| `encoding/` | 10 | 64 | Base32/58/64 encoding |
| `granary/` | 18 | 92 | The tamper-probed store |
| `image/` | 233 | 970 | Image decode -- a picture you own |
| `kumara/` | 6 | 79 | Identity and signing |
| `lantern/` | 36 | 111 | Discovery and search |
| `lattice/` | 4 | 88 | Distributed structure |
| `linengrow/` | 180 | 807 | The giving edge |
| `lotus/` | 249 | 1072 | The creative suite -- audio and media |
| `mand/` | 9 | 82 | Authority -- capability rings |
| `mandate/` | 16 | 99 | The network store |
| `mandi/` | 13 | 63 | Commerce -- marketplace modules |
| `mantra/` | 67 | 2310 | Event log -- versions and replay |
| `mikrophone/` | 17 | 94 | The firmware that forgets |
| `mycelium/` | 119 | 560 | Network substrate |
| `pond/` | 249 | 1070 | The enclosure -- domain isolation |
| `scribe/` | 4 | 63 | The voice's home -- log reader |
| `scribble/` | 9 | 60 | Handwriting and ink |
| `settlement/` | 7 | 82 | A point becomes an address |
| `skate/` | 16 | 220 | FrameGrid, EventRing -- the surface |
| `sundial/` | 2 | 33 | The health face |
| `tally/` | 19 | 1801 | Bounded allocation -- arena, ceiling, budget |
| `vault/` | 3 | 30 | Key storage -- kumara/shard modules |

**Language and compiler (3):**

| Directory | Files | Refs | What it holds |
|---|---|---|---|
| `glow/` | 534 | 1650 | The Glow language and its compiler pipeline |
| `rye/` | 138 | 2230 | The Rye language and its standard library |
| `src/` | 108 | 1972 | Glow userland -- code written in Glow |

**Workrooms (13):**

| Directory | Files | Refs | What it holds |
|---|---|---|---|
| `active-designing/` | 1465 | 4150 | Design essays -- the hot bench |
| `active-development/` | 78 | 162 | Round scoping and survey documents |
| `active-reviving/` | 5 | 47 | Re-growing elders beside them |
| `composition/` | 12 | 24 | Design essays on room structure and planning |
| `construction/` | 1574 | 7631 | Living instruments -- ITINERARY, REDS, registries |
| `counsel/` | 852 | 1355 | The advice ledger (closed, kept) |
| `expanding-prompts/` | 672 | 1019 | Runnable plans |
| `kyri-resins/` | 18 | 97 | Log compressions |
| `session-logs/` | 13766 | 7306 | The diary -- reasoning traces |
| `tablecloth/` | 10 | 41 | Project boards (new) |
| `tools/` | 4389 | 14321 | Witnesses, scanners, controls |
| `upstream/` | 2 | 12 | Reports filed outward |
| `waymarks/` | 284 | 353 | The claim shelf |

**Law and foundations (3):**

| Directory | Files | Refs | What it holds |
|---|---|---|---|
| `context/` | 160 | 3780 | Style, identity, specs, disciplines |
| `foundations/` | 102 | 1536 | The custody-first principle, visions |
| `saga/` | 4 | 79 | Season-close narratives |

**Infrastructure and runtime (6):**

| Directory | Files | Refs | What it holds |
|---|---|---|---|
| `nixos/` | 7 | 96 | Host NixOS configuration (declared-host-config rule) |
| `open/` | 10 | 97 | Open-weight companion harness rationale |
| `fleet/` | 4 | 29 | Fleet setup guides and engine docs |
| `recursion-prompts/` | 90 | 3731 | Autonomous loop seed prompts |
| `session-output/` | 0 | 532 | Gitignored: per-seat transcript window |
| `programming/` | 0 | 7 | Gitignored: empty (zero tracked files) |

**Private rooms (3):**

| Directory | Files | Refs | What it holds |
|---|---|---|---|
| `keys/` | 2 | 108 | Cryptographic keys |
| `press/` | 8 | 113 | Press materials |
| `rye-learning-process/` | 3 | 215 | Personal learning almanac |

### Propose merge -- teaching rooms under `docs/` (4 directories -> 1)

The four teaching rooms serve one reader -- a person learning the product. Each is already
named in MAP.md Room 5 as a single family.

| Directory | Files | Refs | Proposed new home |
|---|---|---|---|
| `docs/` | 17 | 803 | Stays as `docs/` (the parent) |
| `docs-geode/` | 77 | 1048 | `docs/geode/` |
| `manual/` | 32 | 257 | `docs/manual/` |
| `nixos-guide/` | 12 | 68 | `docs/nixos-guide/` |

**Cost:** `docs-geode/` carries 1,048 inbound references. `manual/` carries 257.
`nixos-guide/` carries 68. A repoint sweep covers all three rooms.

**Benefit:** one root directory instead of four, and a newcomer looking for teaching finds
one door.

### Propose merge -- study silos under `study/` (5 directories -> 1)

Five self-contained study rooms share one nature: each would still be worth reading if
the code around it vanished. MAP.md already names them as "siloed study rooms."

| Directory | Files | Refs | Proposed new home |
|---|---|---|---|
| `study/` | 5 | 88 | Stays as `study/` (the parent) |
| `classical-vedic-astrology/` | 104 | 178 | `study/jyotish/` |
| `cubist-bhakti-astrology/` | 51 | 21 | `study/jyotish-cubist/` |
| `shastra/` | 12 | 52 | `study/shastra/` |
| `risala/` | 3 | 19 | `study/risala/` |
| `biochemistry/` | 1 | 23 | `study/biochemistry/` |
| `research-silo/` | 2 | 10 | `study/research-silo/` |

**Cost:** `classical-vedic-astrology/` carries 178 inbound references.
`cubist-bhakti-astrology/` carries 21. `shastra/` carries 52. `risala/` carries 19.
A repoint sweep covers all six rooms.

**Note:** `risala/` is the tree's first `unicode-second` room and keeps that status
under any parent. The `jyotish/` name follows the Comlink tendency -- the Sanskrit for
the discipline, clear to anyone who studies it.

### Propose merge -- small stubs under their natural parent (10 directories)

These are single-file rooms, README stubs, or small collections that belong inside an
existing parent rather than at root.

| Directory | Files | Refs | What it is | Proposed home |
|---|---|---|---|---|
| `basin/` | 1 | 13 | Single `basin.rye` -- a module | Keep in module ring (already there) |
| `brix/` | 2 | 69 | Composition language spec | Keep in module ring (already there) |
| `spellbook/` | 2 | 28 | Calfive reference tables | `context/spellbook/` |
| `contacts/` | 2 | 6 | Contact records (DJINN) | `construction/contacts/` |
| `assets/` | 2 | 17 | Static assets | `construction/assets/` |
| `journey/` | 2 | 51 | One dated quest doc | `active-designing/` (it is a design essay) |
| `arbor/` | 9 | 29 | ChatGPT/Arbor launcher scripts | `tools/ar/` (it is tooling) |
| `bat/` | 7 | 26 | Fleet ship manifest files | `fleet/bat/` |
| `frontier/` | 6 | 24 | NixOS CLI guide, Cursor fleet docs | `docs/frontier/` or `fleet/frontier/` |
| `surf/` | 4 | 21 | Kyri fixture files | `tools/fixtures/su/` (it is test data) |

### Propose retire (2 directories)

| Directory | Files | Refs | Why |
|---|---|---|---|
| `dexter/` | 1 | 10 | README stub only -- no code, no design, no plan |
| `mitra/` | 1 | 6 | README stub only -- no code, no design, no plan |
| `ember-voices/` | 1 | 6 | Single `KYRI.md` for Ember voice definitions -- belongs in `ember/` |

**Action:** move `ember-voices/KYRI.md` into `ember/` and retire the directory. For
`dexter/` and `mitra/`, confirm with Keaton whether these stubs carry a future intent
worth keeping at root, or whether they fold into their natural parent or retire.

### Special cases

| Directory | Files | Refs | Verdict |
|---|---|---|---|
| `rishi/` | 46 | 3944 | Keep -- the shell; 3,944 refs is the highest density (refs/file) in the tree |
| `vendor/` | 4 | 2938 | Keep -- gitlink submodules; never modified |
| `gratitude/` | 139 | 1073 | Keep -- the reading library; held unmodified |
| `external-research/` | 431 | 1114 | Keep -- world studies with attribution |
| `kyri/` | 1 | 100 | Keep -- the notation's own home (single file, high citation) |

## The proposed tree shape

After all merges, the root drops from **89 to roughly 68 directories** -- a 24% reduction.
The module ring stays as-is (single-stranded says each room about one thing). The largest
savings come from the teaching merge (4 -> 1) and the study merge (7 -> 1).

```
Root (68 dirs, down from 89)
  |-- Module ring (33): amphora, aurora, basin, brushstroke, caravan, ...
  |-- Language (3): glow, rye, src
  |-- Workrooms (13): active-designing, construction, session-logs, tools, ...
  |-- Law (3): context, foundations, saga
  |-- docs/ (was 4 dirs):
  |     |-- geode/     (was docs-geode/)
  |     |-- manual/    (was manual/)
  |     |-- nixos-guide/
  |-- study/ (was 7 dirs):
  |     |-- jyotish/   (was classical-vedic-astrology/)
  |     |-- jyotish-cubist/ (was cubist-bhakti-astrology/)
  |     |-- shastra/
  |     |-- risala/
  |     |-- biochemistry/
  |     |-- research-silo/
  |-- Infrastructure (6): nixos, open, fleet, recursion-prompts, ...
  |-- Private (3): keys, press, rye-learning-process
  |-- Retired/merged small stubs into their parents
```

## What this survey recommends

1. **The module ring stays flat at root.** Single-stranded says each room is about one
   thing. Nesting 33 modules under a `modules/` parent would add a directory to every
   import path and every witness invocation for zero clarity gain -- a newcomer who opens
   `tally/` already knows what it holds.

2. **Teaching rooms merge under `docs/`.** One door for everything that teaches.

3. **Study silos merge under `study/`.** One door for everything studied for its own sake.

4. **Small stubs move into their natural parent.** `arbor/` into `tools/`, `surf/` into
   `tools/fixtures/`, `bat/` into `fleet/`, etc.

5. **Empty/stub directories confirm their intent or retire.** `dexter/`, `mitra/`, and
   `ember-voices/` are single-file stubs. Keaton confirms whether they carry a future
   intent worth a root directory.

6. **Every move is a molt-breach circled separately.** No sweep -- each room earns its
   own word, its own reference repoint, and its own commit.

## Measurement

```
ls -d */ | wc -l                              # root directory count: 89
git ls-files <dir> | wc -l                    # tracked files per directory
git grep -l "<dir>/" -- '*.md' '*.rish' ...   # inbound reference count
```

All three figures are **free** -- run them rather than trusting this table.
