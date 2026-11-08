# Grain Module Composition -- Tablecloth Proposal

**Stamp:** `20261108.125817`
**Language:** EN
**Style:** Gauge at Field
**Status:** Proposed -- questions open, awaiting Keaton's word on scope and ordering
**Room:** vision -- reasoning a reader can check today, standing ahead of any guard
**Voice:** Kyri

---

## What Keaton asked

Pause the Lotus Audio rebuild (15 movements landed, all three phases PROVEN) and open a new
tablecloth project addressing the composition layer: how Grain's modules compose into a working
system a person can use. The ask names nine areas and invites questions before scoping begins.

## The nine areas, reordered by dependency depth

The areas Keaton named fall into three tiers. A surface depends on what it saves to, and what it
saves to depends on who owns it.

### Tier 1 -- Foundation (the ground everything rests on)

**1a. Mantra filesystem abstractions.**
Where a project lives, how it is addressed, what "save" and "open" mean. Whether to model
macOS/Ubuntu/NixOS filesystems or design our own content-addressed store aligned with TAME guidance
and the microkernel design. The five primitives (keypair, signed event, append-only log, pure fold,
capability) already answer this: a project is a **log** of **signed facts**, addressed by its
**content hash**, and a "save" is an **append**. The question is how this maps to a host filesystem
today (macOS Finder, NixOS store) while staying true when the host is Caravan on seL4.

**1b. Caravan supervisor model.**
How modules are started, stopped, restarted, and composed. s6 (ISC-licensed, skarnet.org public
docs) and SixOS (GPL, study-only) are the research surface. The Steward concept is already named in
the ITINERARY: reads a Brix manifest, builds domains, manages lifecycle with bounded restart,
wires typed IPC, manages capability leases. This is the process-level equivalent of what Mantra is
at the data level.

**1c. Kumara identity.**
Who owns the project, who can read it, who can share it. Without Kumara keys and Comlink
addressing, nothing is truly "owned" and social features have no ground.

### Tier 2 -- Configuration (how the system describes itself)

**2a. Scribe + Brix unification.**
Whether Scribe (the settings reader) and Brix (the declarative system description) are one module
or two complementary ones. Whether system configuration is versioned through Mantra (yes -- a
config change is a signed fact on a log, so rollback is replay). The settings module refactored for
Terrarium: what settings exist, where they live, how a user changes them.

**2b. Window management.**
How Terrarium manages multiple views, panels, and stations. River and Zig Wayland libraries are
GPL-licensed research (study public docs only). The macOS surface uses AppKit's own window
management. The question is whether there is a cross-surface abstraction worth building, or whether
each target (macOS AppKit, Wayland, Terrarium browser) keeps its own window model with a shared
layout language described in Brix.

### Tier 3 -- Surface (what a person sees and touches)

**3a. Surf Social on Brushstroke/Skate.**
Microblogging-style social, inspired by Nostr's model (public-key identity, signed events, relay
architecture) but rearchitected to align with Comlink (our Ames), Kumara (our Azimuth), and
Mantra (our Clay). Each post is a signed fact on a log; a feed is a fold over subscribed logs.
Realidream is the aesthetic and conceptual frame.

**3b. Audio format choice.**
WAV vs OGG Vorbis vs FLAC vs a custom container. For a TAME-aligned platform: store lossless
(bounded PCM in a simple container), offer export in open formats. WAV is uncompressed PCM -- the
simplest, most bounded, no codec dependency. FLAC is lossless with compression. OGG Vorbis is
lossy. For first-resident use, raw PCM in our own Amphora vessel may be the TAME answer: the
simplest possible representation, content-addressed, with compression as a separate optional step.

**3c. Lotus recording red.**
The test tone plays; recording shows 0 samples. The bridge selftest exercises recording in loopback
(writing synthetic samples), yet the UI path likely needs macOS microphone permission and a real
AUHAL input device callback. A bounded fix, not a tablecloth item.

## Blind spots Keaton may not have named

**The dependency chain is the constraint.** Surf Social depends on Comlink + Kumara (identity),
which depend on Mantra (data), which depends on Caravan (process supervision). A social feed
without owned identity is a centralized service wearing a decentralized costume. The Long Return
says: lay the foundation before painting the ceiling.

**SLC means decoupled, single-stranded, with sameness as the macro.** Each module listed above
needs its own SLC -- a working whole a person can use -- before it composes with others. The
finishing edge holds: ship one real thing before naming the next. Fifteen SLCs at once is fifteen
plans wearing one name.

**The "where to save" question is really three modules.** Where it lives (Mantra store), how to
find it (Scribe index / Brix manifest), and who owns it (Kumara keys). These three compose rather
than braid.

**Terrarium is two targets already.** The macOS native app (AppKit) and the browser station
(WASM + Brushstroke). Window management for each is a different surface. A cross-surface
abstraction is worth building only if both targets share enough layout logic to justify it -- and
the Brix layout language may already be that abstraction.

**The Nostr study needs a clean crossing.** Nostr's NIP specs are public domain (CC0), so the
study surface is clear. The architecture (keypair identity, signed events, relay distribution)
maps almost directly onto our five primitives. The crossing is: their relay is our Comlink peer,
their event is our Mantra fact, their pubkey is our Kumara point. Name the mapping once in
external-research, then build in our own words.

## Questions for Keaton before scoping

1. **Which tier do you want to start in?** The Long Return says Tier 1 (foundation). Lila might
   say Tier 3 (Surf Social is the glad keystone that makes everything feel real). The tension
   between them is the real question.

2. **One tablecloth or three?** Each tier is a natural tablecloth boundary. One project covering
   all nine areas risks the design-over-build ratio tipping toward planning. Three projects --
   foundation, configuration, surface -- each ship a working whole.

3. **Scribe settings first or Mantra filesystem first?** Scribe settings for Terrarium is a
   bounded, shippable SLC: a settings panel in the sidebar, preferences persisted to disk, a clean
   module other stations can import. It composes with what we have today. Mantra filesystem is
   deeper and longer-lasting, yet harder to prove on metal quickly.

4. **Is Surf Social the next Lila after foundation, or does Lotus resume first?** The recording
   red is a small fix. The full Lotus DAW has 75 movements planned. Surf Social is a different
   glad keystone. Which one calls?

5. **Audio format: WAV stays as the default export, and we add FLAC/OGG Vorbis as options later?**
   Or do we default to FLAC (lossless, open, compressed) from the start? The TAME answer is:
   store uncompressed (simplest, most bounded), compress on export (user's choice of format).

6. **Window management: is Brix the layout language for all surfaces?** Or does each surface
   (macOS, Wayland, browser) keep its own layout with Brix as the configuration layer above it?

## Recommended path -- Lila-first, Long Return-first

**Book the recording red** as REDS (Lotus paused, fix rides when it resumes).

**Start with Scribe settings for Terrarium** -- bounded, shippable, composes with what stands.
A settings panel in the sidebar, preferences persisted, importable by other stations. This is the
smallest working whole that teaches us how modules compose inside Terrarium, and it ships before
the deeper questions need answers.

**Then Mantra filesystem SLC** -- the content-addressed store, the "save" and "open" verbs, the
foundation Surf Social will stand on.

**Then Surf Social** -- once Mantra stores things and Kumara names who owns them, a social feed
is a fold over subscribed logs, and the whole thing composes from pieces already proven.

**Lotus resumes** when the composition layer can support it -- when "save a project" and "open a
project" are real verbs in Terrarium.

This order answers the Long Return first (Mantra, Kumara, Caravan are the lasting work) and Lila
within each tier (Scribe settings is the glad keystone for Tier 2, Surf Social for Tier 3).

---

*These are notes. Keaton's word opens the tablecloth.*
