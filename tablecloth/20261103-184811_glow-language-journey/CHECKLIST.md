# Glow Language Journey -- Master Checklist

**Journey: Clean Foundations, Living Stdlib, Ready for Lotus**
**Stamp:** `20261103.184811`
**Grows from:** 128 Glow modules, 70 witnesses, glow-language rune/lowering compiler, pleac/ stdlib sketches, stamp-and-name law, Comlink naming tendency, single-stranded foundation

---

## Journey 1 -- Clean the House (Deep Debride and Rename)

The ascending-number patterns violate the stamp-and-name law in spirit and the Comlink
tendency by design. Before growing Glow further, strip the numbered rungs from every
file, every header, every cross-reference -- and let the filename be the identity.

### Quest 1.1 -- Survey and Seat the Debride

*Know exactly what will move, how far it reaches, and what breaks.*
**Grows from:** the stamp-and-name law, the debride rule, the derived-spine rule, and
the measurements already taken (lotus-audio 241 numbers / 975 files / 10,887 occurrences / 243
commit messages; glow-language 348 numbers / 1,711 files; pixel-glass 5, glow-publishing 8, glass-keyboard 7, seva-broadcast 4, hearth-display
6, compass-surface 7).

- [x] **Orbit 1 -- Full census of every ascending-number pattern**
  Run a tree-wide scan that finds every `WAYMARK[0-9]+` pattern for all eight waymarks.
  Produce a machine-readable ledger: file, line, pattern, tier (living/dated/commit).
  Record the tier-1 commit-message count (cannot be rewritten without deep debride).
  **SLC gate:** the census script runs GREEN and the ledger agrees with the `git grep`
  counts to within zero -- no manual enumeration, no memory.

- [x] **Orbit 2 -- Seat the stamp-and-name rule extension**
  Write the rule page that names lotus-audio, glow-language, and all waymark-numbered patterns explicitly
  as subjects of the stamp-and-name law. The spirit already bans them; this orbit gives
  the letter teeth. Record the ruling in `.claude/rules/` and cite it from the debride
  checkpoint.
  **SLC gate:** the rule page exists, names the patterns, and cites the measurements from
  Orbit 1. A planted `lotus-audio` in a living file reds the census.

- [x] **Orbit 3 -- Waymark concept evaluation and decision**
  Write a design essay evaluating the waymark system against Comlink tendency, stamp-and-name,
  and single-stranded. Honest accounting: what waymarks give (collision-free ladder identity,
  SHA3 derivation, a registry), what they cost (four-letter coinages that violate Comlink
  clarity, a registry that must be maintained, ascending numbers that violate stamp-and-name),
  and what the replacement is. Record the decision -- keep, simplify, or replace -- as a
  foundation or a ruling on Keaton's word.
  **SLC gate:** the design essay exists in `active-designing/`, names both sides honestly,
  and the decision is recorded.
  **Decision:** retire the entire waymark system, on Keaton's word (`20261103`). Warm
  descriptive strings replace four-letter draws. Deep debride scope expands to include
  bare waymark names. Molt-breach preps rule page and registry onto shred-prep first.
  Synergize the tree shed with the deep debride.
  **Essay:** `active-designing/date/20261103/20261103-195243_waymark-retirement-and-warm-names.md`

### Quest 1.2 -- The Deep Debride

*Rewrite git history to remove every ascending-number rung from every commit.*
**Grows from:** Quest 1.1's census, rule extension, and waymark decision.

- [x] **Orbits 4-5 (grouped) -- Checkpoint, sweep, shed, deep debride, force-push**
  Grouped on Keaton's word (`20261103`). One re-clone pays for waymark retirement,
  orphan shed, and fossil cuts combined. Execute in order:
  1. Record the walk-back checkpoint in `construction/CHECKPOINTS.md`.
  2. Molt-breach `waymark-ladders.md` to a living mutant carrying the warm-string table
     and retire `waymark-registry.kyri` to `construction/archive/waymark-registry-20261103.kyri`, both onto shred-prep
     Class M.
  3. Working-tree sweep: strip ascending-number patterns AND bare waymark names from
     all living files -- headers, cross-references, rosters, and prose. Replace with warm
     descriptive strings or module filenames.
  4. Class O orphan removal (1,165 across 10 rooms) and Class H/M fossil cuts (9 prepped),
     per `construction/SHRED_PREP.md`. Approved by Keaton `20261103`.
  5. Deep debride: `git filter-repo --replace-text` to strip ascending-number patterns
     AND bare waymark names from every commit message and every historical file.
  6. Re-sign every commit (`filter-branch --commit-filter 'git commit-tree -S'`).
  7. Force-push to origin. Every clone re-clones once.
  8. Update fascia to **60.0** on Keaton's word (post-debride baseline per
     `context/specs/20261103-201746_fascia-health-model.md`).
  **SLC gate (working-tree):**
  `git grep -cP '\b(lotus-audio|glow-language|pixel-glass|glow-publishing|glass-keyboard|seva-broadcast|hearth-display|compass-surface|compass-identity|compass-language|compass-world|harvest-yield|harvest-trade|harvest-commons|harvest-rest|cion-molt|cion-survey|cion-living-molt|cion-debride|cion-seal|front-door|dimeroll-expansion|open-image|mikrophone|constels-naming|slh-dsa|macos-native|usb-hearth|source-identity|djinn-exec)\b'`
  returns zero hits on living files outside dated testimony. Molt-breach artifacts on
  shred-prep. Warm-string replacements in place. Class O rooms and Class H/M fossils gone.
  **SLC gate (history):**
  `git log --all --oneline | grep -iE '\b(lotus-audio|glow-language|pixel-glass|glow-publishing|glass-keyboard)\b'`
  returns zero. Every commit is signed. The census script runs GREEN against the rewritten
  history. Fascia reads **60.0** on both README and ITINERARY.

- [x] **Orbit 6 -- pleac/ rename to docs-geode/cookbook/**
  Move `pleac/` (3 files: strings.rye, lists.rye, numbers.rye) to `docs-geode/cookbook/`.
  The name "pleac" is an inherited external acronym ("Programming Language Examples Alike
  Cookbook") that violates the Comlink tendency -- a newcomer cannot guess what it means.
  `docs-geode/cookbook/` says exactly what it is. Repoint all references. Update the README
  to Bhakta at the Door setting. Add the rename to the deep debride history rewrite if
  timing allows, or land it as a working-tree commit.
  **SLC gate:** `pleac/` is gone. `docs-geode/cookbook/` holds the three files with their
  existing content. Every reference resolves. The docs-geode Bhakta witness runs GREEN.

---

## Journey 2 -- Furnish the House (Stdlib, Demos, Tutorials)

With the house clean, grow Glow into a language somebody would choose. Each orbit adds
a real capability, proves it on metal, and teaches it in docs-geode. This follows the
SLC footsteps of Terrarium (bounded runtime), Aurora (display), and Caravan (supervision)
-- each one a working simple before it was a framework.

### Quest 2.1 -- Glow Stdlib Seed

*The smallest standard library that lets a real program run without reaching for Rye.*
**Grows from:** the 128 existing Glow modules, the cookbook in `docs-geode/cookbook/`,
and the Terrarium/Aurora/Caravan pattern of growing from working simples.

- [ ] **Orbit 7 -- String and list operations in Glow**
  Grow the cookbook's `strings.rye` and `lists.rye` into real Glow stdlib modules.
  `glow/stdlib/string.glow` and `glow/stdlib/list.glow` -- join, split, length, map,
  filter, fold, take, drop. Each operation bounded, each with a named error on overflow.
  Witnesses prove every function against the Rye originals in the cookbook.
  **SLC gate:** a Glow program imports `string` and `list`, runs join/split/map/filter,
  and the witness proves parity with the Rye cookbook.

- [ ] **Orbit 8 -- Number and arithmetic operations**
  `glow/stdlib/number.glow` -- explicit-width arithmetic (u32, u64), conversion, bounds
  checking. Grow the cookbook's `numbers.rye` into real Glow. Named errors on overflow
  (not silent wrapping). Modular arithmetic where wanted, stated explicitly.
  **SLC gate:** a Glow program does bounded arithmetic, the witness proves every edge
  (max, zero, overflow-refused).

- [ ] **Orbit 9 -- Record and the value model**
  `glow/stdlib/record.glow` -- the single-stranded value model: string, integer, bool,
  list, record. Records compose side by side, never tangled. A record is created, read,
  updated, and passed -- five operations, each bounded, each proven.
  **SLC gate:** a Glow program creates a record, updates a field, passes it to a function,
  and the witness proves the value model holds.

### Quest 2.2 -- Glow Meets the Surface

*Prove Glow can drive a real visual program, not only a compiler pass.*
**Grows from:** Quest 2.1's stdlib, Brushstroke/Skate's Swift shell, the macOS native
surface at `loca/`.

- [ ] **Orbit 10 -- Brushstroke/Skate "Hello Glow" demo**
  A minimal Brushstroke window driven by Glow: open a Skate AppKit window, draw a
  colored rectangle, close on keypress. The Glow program describes the layout; Rye
  renders it through the Skate surface. This is the "Hello World" of Glow meeting glass.
  **SLC gate:** a macOS window opens, draws what the Glow program describes, and closes
  cleanly. Witness proves the render and the close.

- [ ] **Orbit 11 -- Interactive Glow REPL in Brushstroke**
  A Skate window with a text input field. Type a Glow expression, see the result below.
  The REPL evaluates through the existing `glow/expr.rye` pipeline. This is how a
  newcomer meets the language -- type something, see what happens.
  **SLC gate:** type `(add 2 3)` in the window, see `5` appear. Type a malformed
  expression, see a named error. Witness proves both paths.

- [ ] **Orbit 12 -- Glow-driven layout demo**
  A Skate window where the layout itself is a Glow program: a column of labeled rows,
  each row showing a stdlib operation and its result. The program is a tour of the stdlib
  that also happens to be a working GUI. This proves Glow can describe a real interface.
  **SLC gate:** the window opens, shows at least five stdlib operations with their results,
  and resizes cleanly. Witness proves the layout and the operations.

### Quest 2.3 -- Glow in docs-geode

*Teach the language to newcomers. Every demo earns a tutorial.*
**Grows from:** Quest 2.2's demos, the existing 10 tutorials and 8 lessons in docs-geode,
the Bhakta register.

- [ ] **Orbit 13 -- docs-geode/tutorials: "Your First Glow Program"**
  A Bhakta-at-Door tutorial that walks a newcomer from zero to a running Glow program.
  Assumes no background. Covers: what Glow is (one sentence), how to run a program,
  the value model (string, integer, bool, list, record), a small exercise. Written in
  Teacher Style with Kyli voice.
  **SLC gate:** the tutorial exists in `docs-geode/tutorials/`, the Bhakta witness
  runs GREEN, and a person following the steps can run a Glow program.

- [ ] **Orbit 14 -- docs-geode/tutorials: "Glow Meets the Screen"**
  A tutorial that walks a newcomer from the REPL demo (Orbit 11) to the layout demo
  (Orbit 12). Covers: how Glow drives Brushstroke, the layout model, how to change
  what appears on screen. Written in Bhakta at Door.
  **SLC gate:** the tutorial exists, the Bhakta witness runs GREEN, and a person
  following the steps can modify the layout demo.

- [ ] **Orbit 15 -- docs-geode/cookbook expansion and cross-references**
  Grow `docs-geode/cookbook/` from 3 files to at least 8 -- one per stdlib module plus
  common patterns (error handling, bounded loops, record composition, list transforms).
  Each recipe is a standalone page that runs. Cross-reference from the tutorials.
  Add a `docs-geode/libraries/glow-stdlib.md` reference page listing every function.
  **SLC gate:** the cookbook holds at least 8 runnable pages. The library reference
  lists every stdlib function with type and bounds. The Bhakta witness runs GREEN.

---

## Summary

| Quest | Orbits | Focus |
|---|---|---|
| 1.1 Survey and Seat | 1-3 | Measure, rule, decide |
| 1.2 Deep Debride | 4-5 (grouped), 6 | Sweep+shed+rewrite, rename |
| 2.1 Stdlib Seed | 7-9 | String, list, number, record |
| 2.2 Glow Meets the Surface | 10-12 | Brushstroke demos |
| 2.3 Glow in docs-geode | 13-15 | Tutorials and cookbook |

---

## Design Rationale

### Why the filename IS the identity

The lotus-audio and glow-language numbers were a forecast wearing a name's clothes. `lotus-audio` says nothing
a newcomer can hold -- it is a position in a sequence only the sequence's author remembers.
`coreaudio.rye` says what the file does. The Comlink tendency asks for "the clearest, most
fun, safest word -- at whatever length that word wants to be," and a filename already is
that word. Rosters like `lotus/MODULES.md` group modules by function -- Transport, Mixer,
Effects -- which is how a reader actually finds what they need. A number between a waymark
and a module name was overhead that served neither search nor understanding.

### Why one big molt-breach rather than a gradual sweep

A gradual sweep writes new files without numbers while old files keep them, so for months
the tree speaks two dialects and every cross-reference has to ask which one it is in. A
single deep debride pays the re-clone cost once and lands a tree where every file, every
commit message, and every cross-reference speaks plainly. The tree has already proven this
works: the urbit-lineage drop rewrote 2,901 commits and re-signed every one.

### On waymarks: what they give and what they cost

**What they give.** A collision-free four-letter identifier for a work ladder, drawn from
SHA3 over a canonical input. A sealed registry that proves no name was drawn twice. A way
to say "the Lotus chapter" in four letters that grep finds cleanly.

**What they cost.** Four-letter coinages that fail the Comlink tendency's first test --
a newcomer cannot guess what lotus-audio, glow-language, pixel-glass, or compass-surface mean. The ascending-number
rungs violate stamp-and-name. The registry must be maintained, sealed, and witnessed.
The waymark-ladders rule page is one of the longest in the tree, precisely because the
system needs that much explanation.

**The honest question.** A waymark without ascending numbers is just a name. And the
Comlink tendency already governs names. If the four-letter draw were replaced by a warm
descriptive name -- "lotus-audio" rather than "lotus-audio", "glow-language" rather than "glow-language"
-- the tree loses the SHA3 collision-proofing and gains clarity, warmth, and one fewer
system to maintain. The collision risk on descriptive names is real yet manageable:
grep the tree before you seat one. The registry answers a question the tree has asked
six times in its history; whether it will ask it six hundred more is the bet.

**Orbit 3 decided the waymark question on Keaton's word (`20261103`): retire the entire
system.** Warm descriptive strings replace four-letter draws. The deep debride strips
bare waymark names alongside ascending numbers. The ascending-number rungs were already
done; now the waymarks themselves follow.

### Why Glow before Lotus

Lila and the Long Return says: do the work that will still read true on the far side of
the years. A language is that work. Lotus will import Glow's stdlib for its parameter
declarations, its session notation, its plugin descriptors. Growing the stdlib now means
those imports land on solid ground. The single-stranded foundation says: each module is
about one thing, and they meet through one value model. A stdlib that embodies that
discipline is worth more to every future importer than a month of Lotus orbits built
on a language that has not yet found its own shape.

### The Terrarium/Aurora/Caravan footsteps

Each of those modules started as the smallest working thing that could be proven on metal,
then grew by adding one real capability at a time. Terrarium is a bounded runtime.
Aurora is a display surface. Caravan is a supervisor. None of them announced sixteen
rounds and stopped at six. They shipped one simple, lovable, complete thing and then
shipped the next.

Glow follows the same path. Orbit 7 ships a string library. Orbit 10 ships a window.
Orbit 13 teaches a newcomer. Each orbit is complete in itself. The journey is the sum
of the orbits, and the orbits are the work.
