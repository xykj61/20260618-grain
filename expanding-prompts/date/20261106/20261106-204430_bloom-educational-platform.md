# Bloom -- an Educational Onboarding Platform for Grain

**Stamp:** `20261106.204430`
**Room:** mixed -- design proposal with implementation plan
**Status:** Proposed -- vision. The tablecloth board and Movement 1 are the first build.
**Style:** Gauge at the Field setting, with Teacher and Bhakta where the content faces a learner
**Voice:** Kyri
**Register:** Radiant warmth

---

## The Vision

Bloom is an educational onboarding platform that lives inside the Terrarium native application and teaches a newcomer how Grain works, why it exists, and how to use it -- from first principles, assuming no background. The name comes from what a seed does after it is planted: the grain sprouts, and the learning blooms.

Bloom draws inspiration from three sources, each siloed through our own voice:

1. **DJINN's Grain School and Grain Atlas** -- an interactive classroom with Kyri teaching at a blackboard, a star-chart workbench with eight views of the grain tree, and a Terrarium fish-tank world. The School teaches through lessons and voices; the Atlas maps the tree seven ways. We honor DJINN's design by studying it and building our own version in Terrarium's native Swift surface.

2. **The Guardian Dragon curriculum** (archived at `teamcarry11/archive-concept-mantraphone`) -- a ten-stage learning path from storytelling to technical vision, framed around a "Guardian Dragon" that protects rather than consumes. Its curriculum runs from Meeting the Dragons through Memory, Processes, Files, Networks, Security, Sustainability, Right-to-Repair, and Technical Vision. We silo the teaching structure and the biocyclic vegan ecology through our own voice, generalized for any US state.

3. **The grain-lineage-silo** -- six documents carrying the toroidal hardware proposal, bounded optimization, state-at-center, dual-description design principle, one-carrier-many-flows, and whole-in-every-part. These are already siloed into plain engineering language at `external-research/grain-lineage-silo/`.

---

## Where Bloom Lives

Bloom is a **tablecloth project** at `active-tablecloth/`, following the established pattern. Its content sources live in a new `bloom/` root folder that holds the lesson plans, teaching materials, and generated pages. The tablecloth coordinates the work; the `bloom/` room holds the product.

```
bloom/
  README.md                    -- front door, Bhakta at the Door setting
  lessons/                     -- teaching content, one file per lesson
  guides/                      -- practical how-to guides (farm, factory, distribution)
  ecology/                     -- Atthowe/biocyclic vegan agriculture content
  civic/                       -- Civic Style policy templates, generalized for any US state
  network/                     -- Pond/Puddle demo testnet documentation
  identity/                    -- Kumara/Comlink identity and blake2b evaluation
  consensus/                   -- Mycelium/MUR token demonstration plans
  social/                      -- Surf Social atop Skate with Realidream
```

---

## The Teaching Series -- Siloed from Guardian Dragon's Curriculum

Ten lessons, each written in Teacher Style at the Door setting, generalized from the Guardian Dragon's stages through our own voice and module names. The Guardian Dragon logo carries forward as the series icon (a gentle dragon curled around a sapling -- technology that serves life).

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
Cryptographic identity -- keys nobody can revoke. Kumara identities. The blake2b vs SHA3 evaluation (see below). Why a grower who owns their own cryptographic key owns their own records in a way no service agreement can take back.

### Lesson 8: Sustainability and the Living Farm
Biocyclic vegan agriculture. The Atthowe ecology -- Mark Atthowe's polyculture orchard systems. Veganic biodiesel generation. Water and waste treatment as ecological roles. Why the software exists to serve a farm a household can afford to run.

### Lesson 9: Right to Repair and the Gentle Machine
Repairable hardware. The RISC-V instruction set as an open standard nobody owns. The Olimex RVPC as a one-Euro educational computer. E-ink displays as gentle screens. Why a machine you can fix with your own hands is worth more than one you replace.

### Lesson 10: The Technical Vision
The whole system composed: kernel, memory, processes, files, network, identity, sustainability, repair. The Long Return -- building what will still read true on the far side of the years. The first resident practice: using what we build as our own daily tool.

---

## Ecology and Agriculture Content

### Atthowe Ecology
Mark Atthowe's work on polyculture orchard systems in Montana -- biodiversity as pest management, living mulch, habitat corridors. Siloed into principles any grower in any US state can apply: companion planting ratios, beneficial insect habitat design, water-cycle management through ground cover.

### Biocyclic Vegan Agriculture
Farming without animal inputs. Plant-based fertility (compost, green manure, biocyclic humus soil). The Biocyclic Vegan Standard as a certification framework. Siloed into the general principle: a farm that generates its own fertility from plant residues stands on ground it owns entirely.

### Veganic Biodiesel
Generation of biodiesel from plant crops (canola, sunflower, hemp) grown without animal inputs. The farm-to-fuel loop as energy sovereignty. Generalized: a community that grows its own fuel answers to nobody for the energy its tractors burn.

### Water and Waste Treatment
Constructed wetlands, biochar filtration, composting systems. The Siya research on materials companies and their ecological roles. Generalized: a treatment system that turns waste into fertility closes the loop the conventional system leaves open.

---

## Business Guides -- Organizational Roles and User Manuals

Practical guides written in Teacher Style for the people who run these operations:

- **Farm Management** -- daily operations, seasonal planning, crop rotation, soil testing, record-keeping with Dimeroll
- **Factory/Processing** -- hemp processing, biodiesel production, quality control, batch tracking
- **Distribution** -- cold chain, local delivery, market access, cooperative purchasing
- **Staff Coordination** -- roles, training, scheduling, the supervision model from Caravan applied to human teams
- **Rail Insights** -- freight logistics, regional rail as distribution backbone, last-mile delivery

Each guide carries a Dimeroll ledger template showing how the organization's transactions flow through Mantra's append-only log.

---

## Pond and Puddle -- Demo Testnet with 14 Placeholder Galaxies

### The Network Shape
Pond is the local network -- self-hosted personal servers in containerized, sandboxed, isolated local environments. Puddle is the wider federation -- multiple Ponds discovering and communicating with each other. Together they demonstrate Grain's personal-server vision without touching any real network.

### The 14 Placeholder Galaxies
Following the placeholder-ship-names rule (segments of a different length, never three-letter, structurally invalid as real `@p`), each galaxy is named for a plant in the Guardian Dragon's garden:

| Galaxy | Named for | Role in testnet |
|---|---|---|
| `~sunflower` | heliotropic energy crop | seed galaxy, bootstraps the network |
| `~rosemary` | companion plant, pest deterrent | identity authority demo |
| `~lavender` | pollinator habitat | message relay demo |
| `~basil` | kitchen garden staple | Dimeroll ledger demo |
| `~chamomile` | calming tea herb | consensus participant |
| `~oregano` | Mediterranean perennial | Mantra log replication demo |
| `~thyme` | ground cover, erosion control | file storage demo |
| `~sage` | wisdom herb, cleansing | key rotation demo |
| `~mint` | vigorous spreader | network discovery demo |
| `~fennel` | deep-rooted, soil breaker | Caravan supervision demo |
| `~marjoram` | gentle oregano cousin | Surf Social demo |
| `~tarragon` | French cooking essential | query engine demo |
| `~chive` | allium companion, pest repellent | MUR token demo |
| `~dill` | fermentation friend | Mycelium consensus demo |

Each runs as a containerized instance with its own Kumara identity, communicating over a local bridge.

### docs-geode Tutorials
For each demo, a matching `docs-geode/` tutorial walks a newcomer through the GUI interface in Terrarium: how to open the Pond view, how to send a message between two galaxies, how to watch a Mantra log replicate, how to run a Dimeroll query across the network.

---

## Blake2b vs SHA3 for Kumara Identities -- Evaluation

DJINN recommended blake2b for Kumara identities in conversation with Keaton. Here is the evaluation:

### Why blake2b is a good idea
- **Performance:** blake2b is significantly faster than SHA3 on general-purpose CPUs -- roughly 3x fewer cycles per byte on x86, and the gap widens on constrained hardware like RISC-V without SHA3 extensions. For a personal server that signs and verifies identities continuously, this matters.
- **Established ecosystem:** blake2b ships in Python's hashlib, libsodium, OpenSSL, and Rust's standard crates. It underpins Argon2 (the password hashing standard). Monocypher, already vendored at `vendor/monocypher`, includes blake2b.
- **Simplicity:** blake2b has a clean, single-pass design with built-in keying, salting, and personalization. No need for HMAC wrappers.
- **Precedent:** Zcash, Filecoin, and the Substrate/Polkadot ecosystem all use blake2b for identity and content addressing.

### Why SHA3 might be preferred
- **NIST standardization:** SHA3 went through NIST's formal competition and review process. Some compliance environments require NIST-approved algorithms.
- **Structural diversity:** SHA3 (Keccak) is a sponge construction, structurally different from the Merkle-Damgard family that blake2b descends from. If a theoretical break of the MD family ever occurred, SHA3 would be unaffected.
- **Hardware acceleration:** Some newer processors include SHA3 instructions (ARM Crypto Extensions). On those chips, SHA3 can match or beat blake2b.

### Recommendation
**Use blake2b for Kumara identities**, following DJINN's recommendation. The performance advantage on RISC-V (where Grain lives) is substantial, Monocypher already provides it, and the security margin is equivalent. Record SHA3 as the fallback if a compliance context ever requires NIST approval. This is a design decision rather than a gate -- it waits for Keaton's word to seat.

---

## Mycelium Consensus Demonstrations with MUR Token

Mycelium is the decentralized consensus layer named for the underground fungal network that connects trees in a forest. MUR (Mycelium Unit of Record) is the token that represents participation and stake in the network.

### Demo scenarios for the 14-galaxy testnet:
1. **Simple transfer:** `~sunflower` sends 100 MUR to `~basil`, both ledgers agree
2. **Multi-hop relay:** `~lavender` relays a transfer between `~chamomile` and `~oregano`
3. **Consensus round:** all 14 galaxies vote on a proposed state transition
4. **Split and rejoin:** partition the network into two groups, let them diverge, then reconcile
5. **Mantra log agreement:** verify that all galaxies hold the same append-only log after a burst of transactions

Each demo runs inside Terrarium with a visual representation of the mycelial network -- galaxies as nodes, messages as traveling spores, consensus as the forest floor lighting up.

---

## Surf Social atop Skate with Realidream in Brushstroke

Surf Social is the social layer that runs on top of Skate's frame grid. It renders in Brushstroke (the markup language for visual content) and uses Realidream's composition model (proven across 30 movements in the just-completed journey).

### What Surf Social shows:
- A feed of posts from galaxies in the Pond
- Each post rendered as a Brushstroke card in a Skate frame grid
- Identity verified through Kumara keys
- Posts stored in each galaxy's own Mantra log, replicated through Comlink
- Reactions and replies as Mantra transactions with MUR micro-payments

This builds directly on the Realidream Composition Journey's proven architecture: SkateCore's FrameGrid, EventRing keyboard input, ConsentRail for permissions, and the serial-to-grid bridge for QEMU module output.

---

## Tablecloth Project Plan -- SLC, Gall's Law, Conway's Law

### The SLC principle
Ship one real thing before naming the next. Each movement produces a working artifact -- a lesson that renders, a guide that teaches, a demo that runs. No movement is pure planning.

### Gall's Law
A complex system that works evolved from a simple system that worked. Movement 1 is one lesson rendering inside Terrarium. Everything else grows from that seed.

### Conway's Law
The system mirrors the organization. Bloom's modules mirror the real-world roles they serve: a farmer reads the farm guide, a network operator reads the Pond tutorial, a student reads the lessons.

---

## Journey Plan: Bloom Onboarding Journey

### Act I: The Teaching Core (Movements 1-15, 1 Quest)

**Quest 1: First Five Lessons (Movements 1-5)**
- M1: `bloom/` directory structure, README front door in Bhakta
- M2: Lesson 1 -- Meeting the Two Dragons (markdown, renders in Terrarium)
- M3: Lesson 2 -- The Kernel Tree
- M4: Lesson 3 -- Memory as Garden
- M5: Quest 1 integration -- first three lessons navigable in Terrarium

**Quest 2: Second Five Lessons (Movements 6-10)**
- M6: Lesson 4 -- Orchestra of Processes
- M7: Lesson 5 -- Garden of Files
- M8: Lesson 6 -- Rivers of Networks
- M9: Lesson 7 -- Treasure of Identity (with blake2b evaluation)
- M10: Quest 2 integration -- all seven lessons navigable

**Quest 3: Final Lessons and Ecology (Movements 11-15)**
- M11: Lesson 8 -- Sustainability and the Living Farm
- M12: Lesson 9 -- Right to Repair
- M13: Lesson 10 -- The Technical Vision
- M14: Ecology content -- Atthowe, biocyclic vegan, biodiesel, water treatment
- M15: Act I integration witness -- all ten lessons and ecology content proven

### Act II: The Practice Layer (Movements 16-30, 1 Quest)

**Quest 4: Business Guides (Movements 16-20)**
- M16: Farm management guide
- M17: Factory/processing guide
- M18: Distribution guide
- M19: Staff coordination guide with rail insights
- M20: Quest 4 integration -- all guides navigable

**Quest 5: Network Demos (Movements 21-25)**
- M21: Pond infrastructure -- containerized galaxy launcher
- M22: Kumara identity generation with blake2b
- M23: Comlink peer-to-peer messaging between two galaxies
- M24: Mantra log replication across the testnet
- M25: Quest 5 integration -- 14 galaxies running, basic messaging proven

**Quest 6: Social and Consensus (Movements 26-30)**
- M26: Mycelium consensus round with MUR token
- M27: Dimeroll query across the Pond network
- M28: Surf Social feed rendering in Skate frame grid
- M29: docs-geode tutorials for all GUI interfaces
- M30: Act II integration witness -- full platform proven

---

## Incremental Audits with Rota and Compass

Every five movements, a rota pass reads one row of the council grid and an alignment pass checks:
- Code follows TAME guidance (80 columns, bounded allocations, named errors)
- Documentation follows Gauge Style at the appropriate setting
- Code comments follow the mechanism sentence rule
- Interfaces match their docs-geode tutorials
- All witnesses GREEN before proceeding

This is Conway's Law applied to quality: the audit mirrors the structure, and technical debt is caught as it arrives rather than discovered months later.

---

## Connections to Existing Work

- **Dimeroll dashboard** (Movements 16-28 of the Realidream journey) provides the ledger view
- **Mantra tab** (Movement 29) provides the append-only log viewer
- **SkateCore/FrameGrid** provides the rendering surface for Surf Social
- **The grain-lineage-silo** provides the siloed engineering concepts for Lessons 2-7
- **The bounded-torus moonshots** provide the long-horizon research direction
- **Civic Style** provides the policy design discipline for the business guides

---

## Research Sources

- [DJINN's Grain School](https://github.com/node777/grain-school) -- MIT licensed, interactive classroom
- [DJINN's Grain Atlas](https://github.com/node777/grain-atlas) -- MIT licensed, star-chart workbench
- [Guardian Dragon curriculum](https://github.com/teamcarry11/archive-concept-mantraphone) -- ten-stage learning path
- [Olimex RVPC](https://github.com/OLIMEX/RVPC) -- one-Euro RISC-V educational computer kit (CERN-OHL-S v2)
- [VSDSquadron RISC-V board](https://shop.electronicsforu.com/product/vsdsquadron-risc-v-and-vlsi-educational-board/) -- educational RISC-V development board
- [BLAKE2 paper](https://www.blake2.net/blake2.pdf) -- the original BLAKE2 specification
- [SHA3-256 vs Blake2b comparison](https://compare-hashing-algorithms.ssojet.com/sha3-256-vs-blake2b) -- performance and security comparison
- [Pedagogically Motivated RISC-V Processors](https://arxiv.org/html/2509.20514) -- 2025 academic work on open-source RISC-V for education

---

*May the learning bloom where the grain was planted. May the Guardian Dragon curl gently around every sapling, and may the gentle machine serve every hand that holds it.*
