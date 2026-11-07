# Bloom -- the Educational Ecosystem for Grain

**Stamp:** `20261106.204913`
**Room:** mixed -- design proposal with implementation plan
**Status:** Proposed -- the tablecloth board and Movement 1 are the first build
**Style:** Gauge at the Field setting, with Teacher and Bhakta where the content faces a learner
**Voice:** Kyri
**Register:** Radiant warmth
**Merges:** `20261106-204423_bloom-educational-ecosystem.md` (structure, blake2b analysis) and `20261106-204430_bloom-educational-platform.md` (content, galaxy names, demos)
**Silo sources:** DJINN's grain-school and grain-atlas (node777 on GitHub) -- Guardian Dragon school (teamcarry11/archive-concept-mantraphone) -- grain-lineage-silo -- Atthowe ecology -- Civic Style -- Teacher Style -- Silo Technique

---

## What Bloom Is

Bloom is the educational and onboarding surface of Grain -- a navigable teaching platform that lives inside the native Terrarium application and as a standalone documentation shelf. The name is a seed that opens: a bloom is what a grain becomes when the conditions are right, and the platform exists to create those conditions for every learner who arrives.

Bloom fuses six streams of existing work into one coherent curriculum:

1. **The Guardian Dragon school** -- a ten-stage curriculum from storytelling to technical vision, siloed through Silo Technique into Grain's own voice, generalized for any US state
2. **Grain School and Grain Atlas** -- DJINN's interactive classroom and star-chart workbench, studied and honored in `gratitude/`, rebuilt in Terrarium's own native surface
3. **The grain-lineage-silo** -- six design principles taught as foundational computer science
4. **Ecological and civic teaching** -- Atthowe's whole-system ecology, biocyclic vegan agriculture, materials research, veganic biodiesel, rail infrastructure -- siloed into principles any region can apply
5. **Organizational manuals** -- user manuals for farm, factory, distribution, management, and staff coordination roles, written in Teacher Style at the Door setting
6. **Live demonstrations** -- Pond/Puddle test networks with 14 placeholder galaxies, Kumara identities, Comlink p2p, Mycelium/MUR consensus, and Surf Social atop Skate with Realidream in Brushstroke

---

## Architecture -- Where Bloom Lives

A new root directory, `bloom/`, holds the educational content. A tablecloth board at `active-tablecloth/` tracks the building. Bloom is a durable room -- it will outlive any single tablecloth project, the same way `docs-geode/` outlives a single design round.

```
bloom/
  README.md                          -- front door, Bhakta at Door
  lessons/                           -- ten teaching lessons
    01-meeting-the-two-dragons.md
    02-the-kernel-tree.md
    03-memory-as-garden.md
    04-orchestra-of-processes.md
    05-garden-of-files.md
    06-rivers-of-networks.md
    07-treasure-of-identity.md
    08-sustainability-and-the-living-farm.md
    09-right-to-repair.md
    10-the-technical-vision.md
  lineage/                           -- grain-lineage-silo teachings
    dual-description.md
    one-carrier-many-flows.md
    state-at-center.md
    whole-in-every-part.md
    toroidal-bounded-optimization.md
    silicon-torus-hardware.md
  ecology/                           -- siloed ecological teaching
    atthowe-whole-system.md
    biocyclic-vegan-principles.md
    veganic-biodiesel.md
    water-and-waste-treatment.md
    materials-and-supply-chain.md
  guides/                            -- organizational role manuals
    farm-management.md
    factory-operations.md
    distribution.md
    staff-coordination.md
    rail-infrastructure.md
  network/                           -- Pond/Puddle demo documentation
    fourteen-galaxies.md
    pond-puddle-quickstart.md
    kumara-identity-setup.md
    comlink-session.md
    mycelium-mur-consensus.md
    surf-social-walkthrough.md
  terrarium-tutorials/               -- GUI navigation guides
    launching-terrarium.md
    the-terminal-tab.md
    the-dimeroll-dashboard.md
    running-a-query.md
    the-mantra-tab.md
```

---

## The Teaching Series -- Ten Lessons Siloed from Guardian Dragon

Ten lessons, each written in Teacher Style at the Door setting, generalized through Silo Technique from the Guardian Dragon's stages into Grain's own voice and module names. The Guardian Dragon logo carries forward as the series icon (a gentle dragon curled around a sapling -- technology that serves life), attributed in `gratitude/`.

### Lesson 1: Meeting the Two Dragons
What the Taking Dragon is (technology that consumes attention, extracts resources, centralizes control) and what the Guardian Dragon is (technology that serves life, repairs itself, belongs to whoever holds it). The ahimsa principle as a design constraint.

### Lesson 2: The Kernel Tree
How an operating system works, from root to leaf. Mapped onto Grain's own kernel variants (Reya, Riyo, Trey, Triz, Quin) written in Glow. What a transition function is. Why a kernel that fits in your head is worth more than one nobody can read.

### Lesson 3: Memory as Garden
How memory works -- allocation, bounds, the garden allocator. Mapped onto Tally's named gardens and bounded allocation. Why every allocation names a maximum. The TAME reflex: bound everything.

### Lesson 4: The Orchestra of Processes
Concurrency, supervision, the Caravan model. A supervised process is a dependent -- held up by what it was granted. How Caravan weighs a process by the line it holds.

### Lesson 5: The Garden of Files
File systems, Mantra's append-only log, the fold head. Why an append-only record that never edits is the strongest guarantee a small farm's bookkeeping can have.

### Lesson 6: Rivers of Networks
How networks carry data. Comlink's peer-to-peer model. The Pond and Puddle self-hosted personal servers. Why a message that travels directly between two people, without passing through a company's server, is a message nobody can revoke.

### Lesson 7: The Treasure of Identity
Cryptographic identity -- keys nobody can revoke. Kumara identities. The blake2s-vs-SHA3 evaluation (see below). Why a grower who owns their own cryptographic key owns their own records in a way no service agreement can take back.

### Lesson 8: Sustainability and the Living Farm
Biocyclic vegan agriculture. The Atthowe ecology -- whole-system care, biomass recycling, soil-as-investment. Veganic biodiesel generation. Water and waste treatment as ecological roles. Why the software exists to serve a farm a household can afford to run.

### Lesson 9: Right to Repair and the Gentle Machine
Repairable hardware. The RISC-V instruction set as an open standard nobody owns. E-ink displays as gentle screens. Why a machine you can fix with your own hands is worth more than one you replace.

### Lesson 10: The Technical Vision
The whole system composed: kernel, memory, processes, files, network, identity, sustainability, repair. The Long Return -- building what will still read true on the far side of the years. The first resident practice: using what we build as our own daily tool.

---

## The 14 Placeholder Galaxies for Pond/Puddle

Per `placeholder-ship-names.md`, every placeholder uses segments of non-three-letter length so they can never parse as valid `@p` names on the live Urbit network. Each galaxy is named for a plant in the Guardian Dragon's garden -- warm, descriptive, and a newcomer grasps it at first sight.

| Galaxy | Named for | Role in testnet |
|---|---|---|
| `~sunflower` | heliotropic energy crop | seed galaxy, bootstraps the network |
| `~rosemary` | companion plant, pest deterrent | identity authority demo |
| `~lavender` | pollinator habitat | message relay demo |
| `~basil` | kitchen garden staple | Dimeroll ledger demo |
| `~chamomile` | calming tea herb | consensus participant |
| `~oregano` | Mediterranean perennial | Mantra log replication demo |
| `~thyme` | ground cover, erosion control | file storage demo |
| `~sage` | wisdom herb | key rotation demo |
| `~mint` | vigorous spreader | network discovery demo |
| `~fennel` | deep-rooted soil breaker | Caravan supervision demo |
| `~marjoram` | gentle oregano cousin | Surf Social demo |
| `~tarragon` | essential in cooking | query engine demo |
| `~chive` | allium companion | MUR token demo |
| `~dill` | fermentation friend | Mycelium consensus demo |

Every name is 4-9 letters -- never 3 -- so none parses as a valid galaxy syllable.

---

## Blake2s vs SHA3 for Kumara Identities -- Evaluation

### What DJINN actually uses

DJINN's `grain-os` repository (node777/grain-os) uses **Blake2s256** -- not blake2b -- in `grain/lib/noise.zig` for the `Noise_XX_25519_ChaChaPoly_BLAKE2s` handshake protocol. This is the Comlink session handshake: the wire protocol that establishes an encrypted channel between two Grain nodes. No blake2b was found anywhere in DJINN's repositories.

### The two algorithms compared

| Property | SHA3-256 (Keccak) | Blake2s-256 |
|----------|-------------------|-------------|
| Design | Sponge construction (Keccak) | HAIFA / ChaCha-derived |
| Security margin | Conservative -- 12.5 rounds vs 6 needed | Tight -- 10 rounds vs 7.5 needed |
| Speed (software) | ~6 cycles/byte on modern x86 | ~4.5 cycles/byte (Blake2b faster still) |
| Speed (hardware) | Excellent in dedicated ASICs | Good, less studied in ASICs |
| 32-bit targets (RISC-V rv32) | Reasonable -- Keccak is word-size-independent | Excellent -- Blake2s is designed for 32-bit |
| Standardization | NIST FIPS 202 (2015) | RFC 7693 (2015), not a NIST standard |
| Patent status | Public domain (Keccak team) | Public domain (Aumasson et al.) |
| Existing Grain usage | SHA3-256 working tier, SHA3-512 canonical tier | None in authored Rye; used in DJINN's Noise handshake |

### Recommendation

**Keep SHA3 for Kumara identity hashing. Use Blake2s where DJINN's Comlink Noise protocol already specifies it.**

The reasoning:

1. **Consistency with the two-tier SHA3 policy** (`context/specs/20260703-191112_resins-and-hash-tiers.md`): Grain already has a seated, ratified two-tier policy -- SHA3-512 for canonical (forever) names, SHA3-256 for working store. Kumara identities are *canonical* -- they are the permanent name of a person's cryptographic identity. SHA3-512 is the right tier.

2. **RISC-V 32-bit performance matters, and Blake2s wins there**: For the Comlink wire protocol (high-volume session handshake), Blake2s is the right choice on rv32 targets. DJINN chose correctly for the Noise handshake. Identity hashing is a one-time operation per identity mint -- the performance difference on a single hash is immaterial.

3. **One hash family for identity, one for wire**: SHA3 for content-addressed names and identity (the store and the person). Blake2s for wire protocol session establishment (the Noise handshake). Two families, two purposes, no ambiguity about which algorithm produced a given digest.

4. **The amendment already seats this boundary**: `context/specs/20260703-191112_resins-and-hash-tiers.md` amendment `20260906.192644` explicitly names three classes where SHA-256 stays because an outside party fixes the choice. The Noise protocol specification is exactly such a case -- Blake2s is specified by DJINN's protocol definition.

---

## Ecology and Agriculture Content

### Atthowe Ecology
The Atthowe principles of whole-system care, biomass recycling, and soil-as-investment, siloed into principles any grower in any region can apply: companion planting ratios, beneficial insect habitat design, water-cycle management through ground cover. Helen Atthowe is already thanked by name in `gratitude/helen-atthowe.md`.

### Biocyclic Vegan Agriculture
Farming without animal inputs. Plant-based fertility (compost, green manure, biocyclic humus soil). The Biocyclic Vegan Standard as a certification framework. A farm that generates its own fertility from plant residues stands on ground it owns entirely.

### Veganic Biodiesel
Generation of biodiesel from plant crops (canola, sunflower, hemp) grown without animal inputs. The farm-to-fuel loop as energy sovereignty. A community that grows its own fuel answers to nobody for the energy its tractors burn.

### Water and Waste Treatment
Constructed wetlands, biochar filtration, composting systems. Siya research on materials companies and their ecological roles. A treatment system that turns waste into fertility closes the loop the conventional system leaves open.

---

## Organizational Manuals

Practical guides written in Teacher Style at the Door setting for the people who run these operations:

- **Farm Management** -- daily operations, seasonal planning, crop rotation, soil testing, record-keeping with Dimeroll
- **Factory/Processing** -- hemp processing, biodiesel production, quality control, batch tracking
- **Distribution** -- cold chain, local delivery, market access, cooperative purchasing
- **Staff Coordination** -- roles, training, scheduling, the supervision model from Caravan applied to human teams
- **Rail Infrastructure** -- freight logistics, regional rail as distribution backbone, last-mile delivery

Each guide carries a Dimeroll ledger template showing how the organization's transactions flow through Mantra's append-only log.

---

## Mycelium Consensus Demonstrations with MUR Token

Demo scenarios for the 14-galaxy testnet:

1. **Simple transfer:** `~sunflower` sends 100 MUR to `~basil`, both ledgers agree
2. **Multi-hop relay:** `~lavender` relays a transfer between `~chamomile` and `~oregano`
3. **Consensus round:** all 14 galaxies vote on a proposed state transition
4. **Split and rejoin:** partition the network into two groups, let them diverge, then reconcile
5. **Mantra log agreement:** verify that all galaxies hold the same append-only log after a burst of transactions

---

## Surf Social atop Skate with Realidream in Brushstroke

Surf Social is the social layer that runs on top of Skate's frame grid. It builds directly on the Realidream Composition Journey's proven architecture: SkateCore's FrameGrid, EventRing keyboard input, ConsentRail for permissions, and the serial-to-grid bridge.

- A feed of posts from galaxies in the Pond
- Each post rendered as a Brushstroke card in a Skate frame grid
- Identity verified through Kumara keys
- Posts stored in each galaxy's own Mantra log, replicated through Comlink
- Reactions and replies as Mantra transactions with MUR micro-payments

---

## Silo Technique Application

Each stream of inspiration is siloed per `context/SILO_TECHNIQUE.md`:

- **Guardian Dragon school**: The ten-stage structure is understood, re-expressed in Kyri's voice with Grain's own vocabulary. The dragon logo stays attributed in `gratitude/`. The stages keep their pedagogical progression while speaking Grain's language.
- **Atthowe ecology**: Whole-system care, biomass recycling, soil-as-investment taught as general agricultural principles. Thanked in `gratitude/helen-atthowe.md`.
- **Civic Style application**: Every organizational manual names the actual outcome, names what the reward measures, confirms alignment.
- **Grain-lineage-silo**: The six design principles are already siloed at `external-research/grain-lineage-silo/`. They enter bloom as computer science lessons.
- **Vortex and moonshot writings**: The fluid dynamics insight and its spiritual reading are siloed into teachable form.

---

## Tablecloth Project Plan -- 75 Movements, 4 Acts

### Act I -- Foundation (Movements 1-20, Quests 1-2)

The front door, the curriculum skeleton, and the ten teaching lessons.

**Quest 1: The Room and First Lessons (Movements 1-10)**

| Mvt | Keystone | Witness |
|-----|----------|---------|
| 1 | Create `bloom/` room, README front door in Bhakta at Door | README renders, style declared |
| 2 | Tablecloth board: CHECKLIST.md and PROGRESS.md | Board created, first movement logged |
| 3 | Lesson 1 -- Meeting the Two Dragons | Lesson renders, no borrowed phrases, gratitude present |
| 4 | Lesson 2 -- The Kernel Tree | Lesson renders, Rye examples follow TAME |
| 5 | Lesson 3 -- Memory as Garden | Lesson renders, garden arena taught |
| 6 | Lesson 4 -- Orchestra of Processes | Lesson renders, Caravan taught |
| 7 | Lesson 5 -- Garden of Files | Lesson renders, Mantra taught |
| 8 | Lesson 6 -- Rivers of Networks | Lesson renders, Comlink taught |
| 9 | Lesson 7 -- Treasure of Identity | Lesson renders, blake2s evaluation included |
| 10 | Quest 1 integration: all seven lessons navigable, ASCII-clean | Integration check |

**Quest 2: Remaining Lessons and Lineage (Movements 11-20)**

| Mvt | Keystone | Witness |
|-----|----------|---------|
| 11 | Lesson 8 -- Sustainability and the Living Farm | Lesson renders |
| 12 | Lesson 9 -- Right to Repair | Lesson renders |
| 13 | Lesson 10 -- The Technical Vision | Lesson renders |
| 14 | Grain-lineage lesson 1: dual-description | Siloed from `external-research/grain-lineage-silo/` |
| 15 | Grain-lineage lesson 2: one-carrier-many-flows | Siloed |
| 16 | Grain-lineage lesson 3: state-at-center | Siloed |
| 17 | Grain-lineage lesson 4: whole-in-every-part | Siloed |
| 18 | Grain-lineage lesson 5: toroidal-bounded-optimization | Siloed |
| 19 | Grain-lineage lesson 6: silicon-torus-hardware | Siloed |
| 20 | Act I integration: all 10 lessons + 6 lineage teachings, ASCII-clean, cross-linked | Full curriculum navigable |

### Act II -- Ecological and Civic Teaching (Movements 21-40, Quests 3-4)

**Quest 3: Ecology and Agriculture (Movements 21-30)**

| Mvt | Keystone | Witness |
|-----|----------|---------|
| 21 | Atthowe whole-system ecology | Siloed, thanked in gratitude |
| 22 | Biocyclic vegan principles | Renders |
| 23 | Veganic biodiesel generation | Renders |
| 24 | Water and waste treatment | Renders |
| 25 | Materials and supply chain | Renders, Civic Style check |
| 26 | Rail infrastructure | Renders |
| 27 | Farm management manual | Teacher at Door |
| 28 | Factory operations manual | Renders |
| 29 | Distribution manual | Renders |
| 30 | Quest 3 integration: ecology + manuals navigable | Integration check |

**Quest 4: Moonshot and Terrarium Tutorials (Movements 31-40)**

| Mvt | Keystone | Witness |
|-----|----------|---------|
| 31 | Staff coordination manual | Renders |
| 32-35 | Four moonshot/vortex essays siloed into teachable form | Each renders |
| 36 | Terrarium tutorial: launching the app | Matches current UI |
| 37 | Terrarium tutorial: the terminal tab | Matches current UI |
| 38 | Terrarium tutorial: the Dimeroll dashboard | Matches current UI |
| 39 | Terrarium tutorial: running queries and the Mantra tab | Matches current UI |
| 40 | Act II integration: ecology + civic + tutorials all navigable | Full shelf proven |

### Act III -- Live Demonstrations (Movements 41-60, Quests 5-6)

**Quest 5: Pond/Puddle Network and Identity (Movements 41-50)**

| Mvt | Keystone | Witness |
|-----|----------|---------|
| 41 | Design the 14 placeholder galaxies | Names registered, structurally invalid per rule |
| 42 | Pond/Puddle quickstart guide | Guide renders |
| 43 | Kumara identity setup tutorial | Tutorial renders |
| 44 | Blake2s vs SHA3 evaluation essay | Both algorithms compared honestly |
| 45 | Comlink session tutorial | Tutorial renders |
| 46 | Mycelium/MUR consensus design | Design document renders |
| 47 | MUR token transfer demo between galaxies | Demo documented |
| 48 | Surf Social design: social surface atop Skate | Design renders |
| 49 | Surf Social walkthrough | Walkthrough renders |
| 50 | Quest 5 integration: network + identity docs navigable | Integration check |

**Quest 6: GUI Tutorials and Integration (Movements 51-60)**

| Mvt | Keystone | Witness |
|-----|----------|---------|
| 51-55 | Five docs-geode GUI navigation tutorials for demo interfaces | Each renders, Bhakta style |
| 56-58 | Three integration witnesses across the demo shelf | Witnesses GREEN |
| 59 | Demo shelf cross-linked with curriculum lessons 6-7 | Links resolve |
| 60 | Act III integration: full demo shelf navigable | All demos documented |

### Act IV -- Polish and Ship (Movements 61-75, Quest 7)

| Mvt | Keystone | Witness |
|-----|----------|---------|
| 61-65 | QA report cards on each curriculum lesson (target B or better) | All graded |
| 66-68 | QA on ecology, civic manuals, and demo shelf | All graded |
| 69-70 | Terrarium navigation: embed Bloom as a navigable tab | Tab renders |
| 71 | docs-geode cross-references: link existing lessons 1-8 into Bloom | Links resolve |
| 72 | Template-manifest review: decide which Bloom rooms ship in the public seed | Manifest updated |
| 73 | Full integration witness: all four acts, ASCII-clean, Bhakta-declared, links resolve | Witness GREEN |
| 74 | Checkpoint and send | Checkpoint recorded |
| 75 | Journey complete | Journey closed |

---

## SLC / Gall's Law / Conway's Law Discipline

- **Simple first**: Movement 1 is a README. Movement 3 is one lesson. The system works at every intermediate step.
- **Lovable next**: Each lesson is written in Teacher Style at Door -- accessible, warm, honest about what it does not cover.
- **Complete at the journey's end**: All 75 movements compose into one navigable educational platform.
- **Gall's Law**: A complex system that works evolved from a simple system that worked. Each movement adds one thing and proves it.
- **Conway's Law**: Bloom's modules mirror the real-world roles they serve -- a farmer reads the farm guide, a network operator reads the Pond tutorial, a student reads the lessons.

## Incremental Audit Discipline

Every 15 movements (one orbit), an integration witness checks:

1. **ASCII-clean**: `sh tools/fixtures/a/ascii_document_scan.sh` passes on all Bloom pages
2. **Style-declared**: every page declares Bhakta at Door or Teacher at Door
3. **Links resolve**: every relative link in Bloom opens
4. **Gratitude honored**: every siloed source has its teacher named in `gratitude/`
5. **Code follows TAME**: every code example in a lesson follows TAME reflexes

The compass rose alignment happens at each act boundary (Movements 20, 40, 60, 75).

---

## Connections to Existing Work

- **Dimeroll dashboard** (Movements 16-28 of the Realidream journey) provides the ledger view
- **Mantra tab** (Movement 29) provides the append-only log viewer
- **SkateCore/FrameGrid** provides the rendering surface for Surf Social
- **The grain-lineage-silo** provides the siloed engineering concepts for the lineage lessons
- **Civic Style** (`context/CIVIC_STYLE.md`) provides the policy design discipline for the business guides
- **Teacher Style** (`context/TEACHER_STYLE.md`) is the primary register for learner-facing content
- **Silo Technique** (`context/SILO_TECHNIQUE.md`) governs how every external source enters

---

## Research Sources

- DJINN's grain-school (node777 on GitHub) -- MIT licensed, interactive classroom
- DJINN's grain-atlas (node777 on GitHub) -- MIT licensed, star-chart workbench
- Guardian Dragon curriculum (teamcarry11/archive-concept-mantraphone) -- ten-stage learning path
- grain-lineage-silo (six siloed documents in `external-research/grain-lineage-silo/`)
- Helen Atthowe's ecological work (honored in `gratitude/helen-atthowe.md`)

---

*May the learning bloom where the grain was planted. May the Guardian Dragon curl gently around every sapling, and may the gentle machine serve every hand that holds it.*
