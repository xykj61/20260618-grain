# Mandate Folds into Tablecloth, Colloquium Born Fresh

**Stamp:** `20261111.121521` -- **Status:** Living, checkable -- **Room:** checkable
**Style:** Gauge at the Field setting, with Radiant warmth
**Kin:** `context/LEXICON.md` -- `context/CIVIC_STYLE.md` -- `.claude/rules/comlink-tendency.md` -- `.claude/rules/lila-and-the-long-return.md`

## What this seats, on Keaton's word (`20261111`)

Three decisions, each with its own evidence.

### 1. Mandate's vector search folds into Tablecloth as a capability

Mandate (`mandate/`) is a 4,541-line vector store -- upsert normalizes to unit vector, k-nearest
by cosine similarity, zero-copy, bounded exact, Kumara-keyed. It was conceived `20260810` on
Keaton's own prompt ("kg build Mandate, our turbopuffer, with your design"), seven weeks after the
Turbopuffer research document (`external-research/yonder/20260619-220012_tablecloth-tame-datastore.md`)
was written. That research is titled "Tablecloth -- A TAME-Aligned Datastore" -- it was
Tablecloth's from the start, and Mandate borrowed the unit-vector trick from it.

The handoff baton (`expanding-prompts/date/20260810/20260810-025942_the-handoff-baton-vision-checkpoint.md`)
names "turbopuffer gratitude beside a deeper Tablecloth" in its Interfaces section. The two were
always linked in the founding vision.

**Mandate has zero connection to the living Terrarium surface.** No `mandate_vantage.rye` in
`vantage/`, no Terrarium tab (the "Store" tab is "Mantra Store" per `terrarium/app/TabSetup.swift`).
The only references from `pond/apps/` are three comment-level mentions -- `corpus_real.rye`,
`tablecloth_keyed.rye`, and `mcp_kyri.rye` note its patterns in `//!` doc comments yet import
nothing from it.

**"Mandate" fails the Comlink tendency's clarity test.** It means "an official command" and tells a
newcomer nothing about vector search. Meanwhile Tablecloth already has a designed aspect called
**Gleaner** (Lexicon line 464) -- precedent for capabilities folding in as named aspects rather than
standalone modules.

**What folds:** the store's core -- unit-vector normalization, bounded k-nearest cosine search,
the Kumara-keyed storage discipline -- becomes a Tablecloth capability. Tablecloth currently lives
in five files (`pond/apps/tablecloth.rye` 531 lines, `pond/apps/tablecloth_brix.rye` 155,
`pond/apps/tablecloth_keyed.rye` 367, `pond/apps/tablecloth_index.rye` 145,
`brushstroke/tablecloth.rye` 531) totaling 1,729 lines. The vector store adds roughly 4,500
lines of proven, witnessed code -- real substance joining its rightful home.

**What the fold does not touch:** Mandate's object-storage backing, WAL, named-object bucket,
serve protocol, and Comlink sealed serve each carry their own design decisions. Those stay examined
case by case during the migration rather than assumed to merge wholesale.

### 2. Colloquium born fresh as the civic-legislative module

Colloquium is **not a rename of Mandate**. It is a new module born for governance work -- civic
legislation, patent analysis, policy drafting -- written in Civic Style (`context/CIVIC_STYLE.md`).

The name passes all three Comlink tests:

- **Clear** -- a colloquium is a gathering for discussion; a newcomer grasps it
- **Fun** -- lighter and warmer than "Mandate," a pleasure to say
- **Safe** -- zero collisions in the tree (`git grep -i colloquium` returns nothing)

**The founding document** is an automobile-patent nullification bill written in Civic Style -- a
real piece of governance writing that exercises the module's purpose from its first breath. The
bill argues that automobile patents should be nullified to move cars from consumer goods toward
public safety utilities, modeled on aviation's open-standard discipline. Civic Style governs:
name the outcome you actually want, name what the reward measures, and keep the two in alignment.

**What Colloquium inherits from Mandate:** nothing. It is born fresh, the way the Comlink tendency
prefers -- a module earns a new name by being re-grown beside its elder, born-named. The
governance aspirations that the double-seat expansion essay
(`active-designing/date/20260816/20260816-205859_double-seat-expansion-eight-seasons.md`) once
envisioned for a Mandate expansion -- litigation, legislation proposals, federal contracts -- find
their home here instead, under a name that fits.

### 3. Treap and persistent vector research as a future bounded lap

Keaton raised treap and Clojure persistent vectors as potential data structures for Tablecloth's
internals. Zero references to either exist anywhere in the tree today (`git grep -i treap` and
`git grep -i 'persistent vector'` both return empty). This is fresh thinking.

**Proposed as a bounded research lap after the fold lands**, so the research informs a Tablecloth
that already holds its vector search capability. The research would study:

- Treap (tree + heap) as a bounded, randomized balanced tree
- Clojure's persistent vector (wide branching factor, structural sharing, O(log32 N) access)
- How either or both might serve Tablecloth's append-only, content-addressed store model

## The sequence

1. **Fold Mandate into Tablecloth** -- the vector store rejoins the module it was always researched for
2. **Birth Colloquium** -- automobile-patent nullification bill in Civic Style as the founding document
3. **Research treap/persistent vectors** -- bounded lap informing Tablecloth's internals

The Mantra Comlink Realidream is already 15/15 complete (all movements M1-M15 checked with GREEN
witnesses in `active-tablecloth/date/202611/00/20261107-090000_mantra-slc-comlink-realidream/CHECKLIST.md`),
so this chapter opens on a clean slate.

## Why this order

Lila-first, return-first. The fold is Long Return work -- reuniting what the founding vision
always intended. Colloquium is Lila within that tier -- the glad keystone that opens the
governance surface. The research follows, informing what the fold has already built.
