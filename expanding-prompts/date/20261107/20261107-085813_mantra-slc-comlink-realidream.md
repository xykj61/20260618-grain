# Mantra SLC -- Comlink Realidream Content Network

**Stamp:** `20261107.085813`
**Language:** EN
**Style:** Gauge at Field, with Radiant warmth
**Voice:** Kyri
**Status:** Proposed
**Room:** checkable
**Order:** [Lila and the Long Return](../../../.claude/rules/lila-and-the-long-return.md)
**Kin:** [`context/specs/20260707-011412_mantra-referential-namespace-reference.md`](../../../context/specs/20260707-011412_mantra-referential-namespace-reference.md) -- the formal Mantra spec
**Kin:** [`active-designing/date/20260706/20260706-023912_the-referential-namespace.md`](../../../active-designing/date/20260706/20260706-023912_the-referential-namespace.md) -- the design essay seating Mantra as Clay-inspired namespace
**Kin:** [`external-research/date/20260706/20260706-023912_clay-referential-namespace.md`](../../../external-research/date/20260706/20260706-023912_clay-referential-namespace.md) -- Clay study (silo technique)
**Kin:** [`external-research/date/20260706/20260706-022912_ames-vere-libuv-content-carriage.md`](../../../external-research/date/20260706/20260706-022912_ames-vere-libuv-content-carriage.md) -- Ames/vere/libuv wire study
**Kin:** [`active-designing/date/20260812/20260812-123509_buhr-journey4-realidream-editing-surface-exploration.md`](../../../active-designing/date/20260812/20260812-123509_buhr-journey4-realidream-editing-surface-exploration.md) -- Realidream editing surface

---

## What this proposal builds

Bloom's educational pages today are static Markdown files loaded from
a local directory. This proposal turns them into **Mantra paths** --
content addressed by Kumara identity, versioned by date stamp, and
served over a Comlink localhost wire -- so the same content that
teaches a person about Grain is itself a working example of Grain's
referentially transparent filesystem.

The network layer lowers through Glow/Rishi/Rye to Zig's stdlib UDP,
then redefines the permissively licensed networking primitives for
RISC-V Caravan with Tally compatibility. This is not elder Urbit's
Nock-to-C jet bridge. It is a clean Zig lowering to a microkernel
supervisor, inspired by Ames' seven siloed lessons and built from
this tree's own modules.

Testing runs on Pond/Puddle: content hosted across the fourteen
placeholder galaxies, with Comlink requests originating from a
fifteenth galaxy named Siya.

## What already stands

**Mantra namespace spec** (seated, canon): the path grammar is
`peer / bolt / revision / path`. Bounds: peer 16 bytes, bolt 32
bytes, revision u32 starting at 1 (strictly dense), path 64 bytes,
tilak 32 bytes. Recall answers `here`, `not_yet`, or `never`.
SHA3-256 digest as 64 lowercase hex. Max resin 512 bytes. Max 16
bindings per catalog.

**Landed laps through parity 176**: local recall, writing revisions,
sync logic, beaded recall, marks-on-read, two-way sync (in-process
and wire), catch-up (in-process and wire), outer subscribe poll
(in-process and wire), production scheduling under Caravan, and
Tablecloth query. The Mantra module has real code behind it.

**Clay study** (siloable): Urbit's typed, referentially transparent,
version-controlled filesystem. Path names four things: peer, desk,
version, path. Content-addressed sync. Key lesson: a filesystem
should postpone being a database.

**Ames/vere/libuv study** (siloable): seven lessons siloed -- wire as
swappable substrate, identity as address, reliable transactional
carriage, whole refusal at crypto boundary, bounded congestion,
mechanical sympathy, log as truth. Verdict: study, adopt neither.

**Bloom content**: 75 movements of educational material across
curriculum, ecology, guides, lineage, essays, terrarium-lessons, and
demos. Nine demo walkthroughs using the fourteen placeholder galaxies.

**Realidream design**: the append-only revision graph where reading
the web and writing the program happen on one canvas. Journey 4
exploration names the crux: an edit is an append to the Mantra
catalog, and the same render paints the grown graph.

## Siloable content for the network

Beyond the Bloom pages already written, the tree holds research ready
to become Mantra-addressed content:

- **Minisforum home server** (`external-research/date/20260710/20260710-133500`): MS-S1 Max (Strix Halo, 128GB) for Lattice/Lantern/Anvil inference. NixOS/SixOS host. Becomes a Mantra page about the home forge -- the machine that runs a galaxy's own inference.
- **Grainphone open hardware** (`external-research/date/20260715/20260715-182500`): two-body strategy -- firmware-free calm client (Rockchip/Qualcomm) plus AMD home forge, joined by Comlink. Becomes a Mantra page about the handheld surface -- the device that asks your galaxy for a page.
- **Biocyclic vegan ecology**: the garden that feeds the naming convention and the whole vision. Bloom's ecology room already holds seven pages; the network carries them to any galaxy that asks.

Each piece becomes a Mantra bolt on a teaching galaxy, addressable by
the same path grammar Bloom already describes in its demos.

## The movements

### Phase 1 -- Mantra content addressing (movements 1-5)

1. Define a `ContentBolt` that wraps a Markdown page as a Mantra resin, with Kumara identity in the peer field and a date-stamp revision. Prove recall returns the page bytes and the digest matches SHA3-256.
2. Convert Bloom's ten curriculum pages into ContentBolt resins on `~sunflower`, each at its one-clock stamp revision. Prove all ten recall correctly.
3. Convert the seven ecology pages and five guide pages onto `~rosemary` and `~oregano`. Prove cross-bolt recall from `~sunflower` resolves `not_yet` (the content lives on another peer).
4. Silo the Minisforum and Grainphone research into teaching pages on `~thyme` (file storage demo galaxy) and `~mint` (network discovery demo galaxy). ASCII-first, Bhakta at Door.
5. Integration witness: twenty-plus pages across four galaxies, every recall answering `here` from its home peer and `not_yet` from a stranger.

### Phase 2 -- Comlink localhost wire (movements 6-10)

6. Define the Comlink content request: a peer asks another peer for a `bolt / revision / path` over a localhost UDP socket. The request carries the asking peer's Kumara public key.
7. Survey Zig 0.17.0 stdlib for UDP socket primitives (`std.posix.socket`, `std.posix.sendto`, `std.posix.recvfrom` or their current shape). If the stdlib carries them, use them directly. If not, search for a permissively licensed Zig UDP library.
8. Implement the Comlink request-response on localhost: `~siya` (the fifteenth galaxy, Keaton's new name) sends a content request to `~sunflower`, receives the resin bytes, and proves the digest. Bounded at 512 bytes per resin, one request at a time.
9. Wire the Comlink response into Bloom's lesson loader: `loadBloomLessons()` in `terrarium/app/main.swift` resolves each page through a Comlink localhost request rather than a filesystem read. The Bloom tab shows the same content, served over the wire.
10. Integration witness: Siya requests pages from four galaxies, receives all of them, and the Bloom tab renders every page it rendered before. The wire is invisible to the reader.

### Phase 3 -- Caravan/Tally lowering for RISC-V (movements 11-15)

11. Define the Caravan-supervised UDP listener: a bounded process that accepts content requests, looks up the local Mantra catalog, and responds with the resin or a `never` refusal. Tally arena allocation, named error on oversize.
12. Define the Caravan-supervised UDP sender: a bounded process that sends content requests and waits for a response with a timeout. Named error on timeout, on digest mismatch, on oversize.
13. Prove both on QEMU RISC-V: the same request-response that ran on localhost in movement 10 runs inside the Terrarium emulator. The content reaches the screen.
14. Silo the remaining Bloom rooms (lineage, essays, terrarium-lessons, demos) onto the remaining galaxies. Each galaxy holds its teaching role from the registry.
15. Final witness: Siya galaxy inside QEMU requests Bloom content from all fourteen galaxies running as Caravan-supervised processes, receives every page, and the Bloom tab renders the full curriculum. The Realidream vision -- reading content addressed by identity, versioned by stamp, served over an owned wire -- is working.

## What this does not build

- **Public networking.** All traffic is localhost or QEMU-internal. A WAN wire is a later journey.
- **Encryption.** Comlink's Noise handshake is described in Bloom's demos. This SLC carries content in the clear on localhost, because the transport is trusted. Encryption rides on a later Kumara integration.
- **A database.** Clay's lesson holds: a filesystem should postpone being a database. Mantra serves pages; Tablecloth queries them. Both exist; this SLC joins them to a wire.
- **Elder Urbit jets.** No Nock, no C performance bridge, no Hoon compilation. The Zig lowering goes straight to Caravan/Tally on RISC-V.

## Siya -- the fifteenth galaxy

Keaton introduced `~siya` as the name for the user's own galaxy in
this test network. It joins the fourteen plant-named galaxies from
the registry. Siya is the galaxy that asks; the fourteen are the
galaxies that answer. The name carries Keaton's word and wants a
registry entry beside the fourteen, with its meaning and its role.

`~siya` passes the placeholder safety test: four letters, where a
real Urbit syllable is exactly three. It cannot parse as a valid `@p`.

## Prepend to Calfive

This project prepends to the front of the Calfive itinerary stack as
the new priority. The Lotus Working Studio (Equinox 1) and its
existing schedule remain in the stack behind it. Existing movements
whose destiny has shifted given Terrarium SLC progress should be
reviewed and reimagined where they no longer serve.

---

*May every page find its path, every galaxy answer its neighbor, and
the wire between them carry nothing the history does not already hold.*
