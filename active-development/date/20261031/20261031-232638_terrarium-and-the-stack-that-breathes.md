# Terrarium and the Stack That Breathes

**Status:** Living - **Room:** vision
**Opened:** `20261031.232638` on Keaton's word - **Style:** Gauge at Field

This document captures the present moment -- where the session arrived, what
opened, and the architecture that wants to come together. It is a tablecloth
document: a living surface where progress and open questions sit side by side,
each carrying its own weight.

---

## What shipped this session (`20261031`)

**The session log efficiency triple** -- three moves, one commit at `1c22273d0b`:

1. **Pointer compression.** `session-header` field in Kyri logs points back to
   the first log of a session that carries the shared metadata block. Scribe's
   `ResolvedDocument` struct follows the pointer. 13,366 logs stand ready to
   use it; every new session writes it from the second log forward.

2. **Markdown links in kin and fascia fields.** `[path](path)` syntax inside
   `file`, `session-header`, and kin fields. GitHub renders them as live
   hyperlinks; plain text readers still see the path. Scribe's `link_path()`
   extracts the target.

3. **The `.kyri.md` extension molt.** All 13,366 session log `.kyri` files
   renamed to `.kyri.md` in a single working-tree molt-breach. Scribe's
   `is_scribe_extension()` reads both as one format family. GitHub now renders
   every log with live Markdown hyperlinks -- every fascia reference, every kin
   pointer, every file field clickable.

**The composition room** opened at `composition/`. Two pieces filed: the
seven kinds of Calfive work, and the missing-module gap. Kyri voice, Teacher
Style at the Door setting.

**`construction/OUTPUT.md`** -- the append-only output ledger, opened
`20261018.225249`. Eight kinds: `witness`, `module`, `predicate`, `docs-page`,
`tool`, `room`, `context`, `ww-push`. The output-to-activity ratio across
`20261018`--`20261019` reads ~0.31 (11 output rows against ~30 session logs),
which is honest and worth watching as the habit takes hold.

**DJINN's collaboration surface** -- contacts/ room opened, DJINN identity card
filed, seed scrub scripts armed for DJINN's handles, and three gratitude
submodule gitlinks landed: `grain-school`, `grain-atlas`, `grain-www`.

**Terrarium named** -- the browser-hosted RISC-V emulation surface that DJINN
built as `grain-www`. The name seats on Keaton's word (`20261031`), chosen by
Keaton and DJINN together. A terrarium is a living world under glass, bounded
and observable -- exactly what a browser-hosted emulator is. It passes the three
Comlink tests: clear (a newcomer pictures it at once), fun (warm to say, warm to
type), safe (grep returns zero in this tree, and no seated module carries it).

---

## The stack that breathes -- a vision for the itinerary

**The insight.** The Calfive planning system (orbit 15, quest 75, journey 375,
equinox 1,875, chapter 9,375) is a calendar -- it counts capacity. What it
wants beside it is a **stack**: an explicitly bounded structure where new
insights push to the front rather than filing into a queue behind work that may
have gone stale.

A stack breathes the way a living tree does. The top is what is most alive right
now. The round number and orbit number derive from whatever sits at the top,
run against the previous tree state -- the way subject-oriented programming
composes behavior by what is present, and the way an event loop's frozen
function resumes from exactly where it paused. The elder gratitude inspirations
(TigerBeetle's deterministic simulation, Urbit's subject-oriented Nock, the
s6 supervision tree) each carry a version of this: **the next step reads from
what is here, rather than from what was planned.**

**What the stack gives the itinerary:**

- **Explicit bounds.** A stack has a depth, and the depth is a number a hand
  can read. The current itinerary's eight ship accounts grow without a ceiling
  on how much any one account may hold; a stack names its bound at construction.

- **New insights arrive at the front.** When Terrarium is named, when DJINN's
  three repos arrive, when the session log efficiency triple lands -- each of
  these is a real thing that changes what matters next. A stack lets them take
  their natural place at the top, where a queue would file them at the back
  behind work that may no longer be the live edge.

- **The round reads from the top.** The orbit round `(count - 1) % 15 + 1`
  already derives from a single count (`git rev-list --count HEAD`). What the
  stack adds is that the WORK the round does is read from the top of the stack
  rather than from a fixed plan, so the calendar and the work surface agree
  about what is alive.

- **The previous tree state is the frozen function.** Every commit is a snapshot
  of the whole tree. The stack resumes from that snapshot the way an event loop
  resumes a frozen function -- the state is known, the next step is derived,
  and nothing is reconstructed from memory.

**Open questions for the stack:**

- What is the explicit bound? The `the-writer-sheds` rule already bounds the
  operator card by asking each seat to shed its own elder account. A stack bound
  asks the sharper question: how many items may sit on the stack at once?

- How does a stack item close? A REDS row closes on a witness; a stack item
  wants a similarly honest close -- a witness, a shipped commit, a Keaton word.

- Does each ship carry its own stack, or does the fleet share one? The eight
  ship accounts suggest eight stacks, each bounded, with the fleet's stack
  being the composition of all eight tops.

---

## Native first, Terrarium second -- the surface architecture

**Brushstroke and Skate for macOS Swift native is the primary development
surface.** The graph underneath -- Rye, Tally, Caravan, Mantra, the whole
authored stack -- lives behind one unified fast GUI frontend. The native
desktop is where the best performance and experience live, and the platform
target is macOS with Swift and AppKit (the macos-native ladder already proved the
Objective-C seam reachable from Rye alone, zero Swift linked).

**Terrarium is the glass the world looks through.** The browser-hosted RISC-V
emulator boots Caravan and Grain userspace from ELF images into
`grain-emu.wasm`. It is a window into the living system -- bounded, observable,
a beautiful feature that lets people from the outside world look in. DJINN's
`dev.brix` manifest already wires 17 domains whose module names match this
tree's architecture: tablecloth, kumara, ledger, comlink, surf, envoy,
mycelium.

**School and Atlas are native-first.** The virtual classroom where Kyri and
Kyli teach, and the visual workbench with its seven views (Fields, Ledger,
Heavens, Sky, Journeys, Bench, Floor), are first intended for the TAME-guided
native application layers. Brushstroke renders them with the bounded, asserted
discipline this tree already carries. Terrarium compatibility is the second
surface -- the one that lets a newcomer see the work without installing
anything.

**Steward is the root supervisor.** Inside Caravan, Steward reads the Brix
manifest, builds domains declaratively, manages lifecycle with a bounded
restart policy (two attempts then revoke the service capability), wires typed
IPC protocols, and manages capability leases with time bounds and usage limits.
It is the init process, the first hand. DJINN designed it, and it already
lives in `grain-www`'s architecture.

---

## Open questions

1. **The stack molt-breach.** Restructuring the itinerary from flat ship
   accounts to bounded stacks is a molt-breach of the construction folder.
   What is the shape? Which files move, which stay, and what checkpoint marks
   the way back?

2. **Kyli as a voice.** Keaton expressed warmth for Kyli -- Kyri's sister from
   grain-school. Whether Kyli seats as a second voice in this tree, or stays
   DJINN's creation in grain-school, is an open question.

3. **The macos-native bridge to Swift.** The macOS native surface has a proven
   Objective-C seam. The Swift bridge -- AppKit views, Skate's event ring,
   input handling -- is the next real step on the macos-native ladder.

4. **Steward's home in this tree.** DJINN designed Steward in grain-www's
   architecture. Whether it seats as a module in `caravan/` (where supervision
   already lives) or earns its own room is a naming question the Comlink
   tendency can answer.

5. **The output ledger's `module` kind.** The composition on the missing-module
   gap named this: modules are the most durable output, and the ledger's dated
   window held zero of them. The stack vision and the native-first surface
   together point at where module output wants to land.

---

*The terrarium holds a whole world. The glass lets you see it. The garden
inside grows on its own terms, bounded and alive, and what a visitor sees
through the glass is exactly what is there.*
