# Vantage, Station, and Carry -- an RFC for Write-Once Cross-Platform Architecture

**Language:** EN
**Stamp:** `20261107.143100` (EDT)
**Voice:** Kyri with Teacher warmth
**Style:** Teacher + Gauge at the Field setting, with Radiant warmth
**Status:** Approved -- on Keaton's word `20261107.143845`; all seven recommendations seated
**Room:** vision
**Kin:** `foundations/20261002-111449_lila-and-the-long-return.md` - `foundations/20260823-204456_single-stranded.md` - `context/TAME_CORE.md` - `foundations/20260826-024943_follow-our-compass.md` - `foundations/20260822-014628_the-mechanism-and-the-metaphor.md`

---

## What this document is

This is a request for comment on how Grain's application logic -- the parts that make Bloom,
Dimeroll, and Realidream work -- should be separated from the platform they run on, so the same
logic can serve a desktop, a browser, and eventually a phone, without being rewritten each time.

If you have never touched this codebase, here is the shape in one paragraph: Grain is an operating
system built in a language called Rye, and it proves its designs on a simulated RISC-V computer
called Terrarium. Right now, the desktop application is a single Swift file -- `terrarium/app/main.swift` --
that tangles three jobs into 3,831 lines: talking to the Mac window system, running the
application logic (tabs, content, calculations), and managing the RISC-V emulator. This RFC
proposes to untangle them.

## What we measured

Before recommending anything, we read what is actually on disk.

| Module | What it does | Size | Status |
|---|---|---|---|
| `terrarium/app/main.swift` | Platform shell + application logic + emulation bridge, tangled | 3,831 lines, 78 functions | Living monolith |
| `terrarium/src/` | 40 freestanding RISC-V stages proving OS design patterns | ~12,000 lines of Rye | GREEN witnesses |
| `pond/` | OS application host -- enclosure policy, customs, 30+ apps | ~2,800 lines | Living, witnessed |
| `caravan/` | Process supervision, capabilities, domains, entrust/revoke | 114 hosted modules | Living, witnessed |
| `basin/basin.rye` | Bounded circular buffer for ScribexTally monitor | ~300 lines | Living -- NOT a kernel |
| `terrarium/src/preempt.rye` | M-mode preemptive scheduler with CLINT timer | ~200 lines | The actual privileged layer |

**The elder grain-sketchbook** (at `gratitude/grain-sketchbook/`) defined Basin as "the kernel
name" and Vantage as "the bring-up and verification companion." Both roles have since been
filled: Terrarium holds the emulation and proving ground, and Caravan holds the supervision and
capability design. The names Vantage and Carry are free to carry new meaning.

---

## The Seven Questions and Our Recommended Answers

Each recommendation is grounded in the foundations this tree keeps on purpose. The principle is
named first, the mechanism second, the metaphor last -- per the Mechanism and Metaphor foundation.

### Question 1: What is the relationship between Pond and Vantage?

**Principle:** Single-Stranded -- each module about one thing; compose rather than braid.

**Recommendation: Keep them separate. Pond hosts. Vantage serves.**

Pond is the floor where OS modules compose into a running whole a person trusts -- its charter
says so plainly at `pond/README.md`. It governs what an application MAY do: enclosure policy,
customs inspection, the sandbox boundary. Pond composes Caravan (isolation) and Tally (bounded
gardens) into a policy a program must satisfy.

Vantage is the write-once application logic that runs INSIDE that host. It is what the
application actually DOES -- render a Bloom tab, calculate a Dimeroll figure, display Realidream
content. Vantage knows nothing about which window system drew the pixels or which OS enforced
the sandbox.

The relationship is the same as a theater and a play. Pond is the theater -- it has the seats,
the exits, the fire code. Vantage is the play -- it runs wherever a theater will have it. A
play that also builds its own theater has braided two things that compose better apart.

### Question 2: What is the second platform?

**Principle:** Lila and the Long Return -- do the work that will still read true on the far side
of the years. Then take the glad keystone.

**Recommendation: WASM in the browser.**

The second platform is the one that teaches the most about what the abstraction boundary should
look like, for the least cost. WASM wins on both counts.

WASM is the most constrained target after macOS: no filesystem, no raw sockets, event-driven,
single-threaded by default. Any abstraction that satisfies both macOS (retained-mode AppKit) and
WASM (event-driven DOM) will satisfy every platform that comes after -- because it will have
been forced to draw a clean line between "what the logic needs" and "what the platform provides."

Terrarium already proves Rye compiles to freestanding targets. WASM is another freestanding
target. The compiler knows the road.

The Long Return says: a browser surface lasts. A person who visits a URL and sees Grain working
has met the project without installing anything. That is a door that stays open for years.

### Question 3: Which architectural option?

**Principle:** TAME -- safety first, performance second, joy third. Ship one real thing before
naming the next. The finishing edge holds.

Four options were evaluated:

| Option | Shape | Cost | What it teaches |
|---|---|---|---|
| **A** | Split `main.swift` into three Swift files | Low | Nothing about cross-platform |
| **B** | Extract logic into Rye `vantage/`, keep Swift as shell | Medium | The seam shape, the FFI bridge, the one language crossing |
| **C** | Full decomposition: Vantage + Station + Carry + Terrarium-as-library | High | Everything, but builds abstractions before the second platform is named |
| **D** | Pond absorbs the role -- apps written in Rye run as Pond applications | Medium | Braids Pond's hosting with Vantage's logic |

**Recommendation: Option B.**

Option B extracts the application logic from Swift into Rye, creating `vantage/` as a new module
that holds Bloom, Dimeroll, and Realidream as platform-agnostic Rye code. The existing Swift in
`terrarium/app/` stays as the macOS shell -- it owns AppKit, the menu bar, the window, and the
QEMU lifecycle.

Why B and not the others:

- **Over A:** Option A defers the real question. Three Swift files are still three Swift files,
  and the day a browser target arrives, they rewrite from scratch. The Long Return says: do
  lasting work first. The extraction into Rye lasts.

- **Over C:** Option C builds the Station abstraction, the Carry bridge, and the
  Terrarium-as-library API before any of them has been tested against a real second platform.
  The hammock wisdom says: name the second platform, build one thing for it, and let the
  abstraction boundary reveal itself from the concrete case. C names the abstraction before
  the case.

- **Over D:** Option D braids two single-stranded modules. Pond's charter is enclosure policy
  and customs. Asking it to also be the runtime for application logic gives one module two
  jobs, which is the braid the Single-Stranded foundation warns against.

- **Safety:** Rye carries bounded assertions, explicit widths, and named errors where Swift
  carries runtime optionals. The extraction moves 1,800 lines from a language with runtime
  panics into a language with compile-time proofs. Safety first.

- **Joy:** The extraction ships one real thing. A developer who clones the tree finds
  `vantage/bloom.rye` and knows what it does from its filename. That is joy earned by
  clarity.

### Question 4: What stays in Terrarium?

**Principle:** Mechanism and Metaphor -- name the file, function, parameter before any image.

**Recommendation: Terrarium keeps ONLY the emulation bridge and the freestanding proving ground.**

What stays:

- The 40 freestanding RISC-V stages in `terrarium/src/` -- these are the bare-metal proofs of
  Aurora, Caravan, Tally, and Mantra design patterns. They talk to QEMU hardware through direct
  MMIO registers. They are the mechanism.
- The QEMU lifecycle management in `terrarium/app/main.swift` -- process launch, serial pipe,
  the CREQ/CRESP wire protocol. This is the emulation bridge.
- The macOS platform shell (AppKit window, menu bar, tab switching) -- this stays in
  `terrarium/app/` for now, as the de facto Station shell, until a second platform arrives
  and teaches us where the Station abstraction boundary belongs.

What leaves:

- The ~1,800 lines of application logic (Bloom tab rendering, Dimeroll calculations, Realidream
  content display) -- these move to `vantage/`.
- The data models behind each tab -- content manifests, calculation state, display
  configuration -- these move to `vantage/` as pure Rye modules with no platform dependency.

### Question 5: When does mobile happen?

**Principle:** Lila and the Long Return -- ship one real thing before naming the next.

**Recommendation: Defer Carry to a second journey.**

Mobile (iOS and Android) has the hardest platform bridges -- UIKit lifecycle management, Kotlin
JNI, backgrounding, state restoration, push notifications -- and the least architectural
leverage. Everything mobile teaches about the abstraction boundary, the browser teaches more
cheaply, because WASM's constraints are stricter and its feedback loop is faster.

The Long Return says: the Vantage extraction (Question 3) and the WASM proof (Question 2) are
the lasting work. Mobile is the work that serves the moment. Do the lasting work first, and
the mobile story writes itself on the ground the extraction already proved.

A concrete timeline: Carry earns its own journey after the Vantage extraction has shipped, the
WASM target has one working tab, and the seam between logic and platform has been tested on
two surfaces. That is when naming a third surface teaches something new.

### Question 6: What happens to the Basin name?

**Principle:** Comlink Tendency -- the clearest, most fun, safest word, at whatever length.

**Recommendation: Basin stays exactly what it is -- a bounded circular buffer.**

`basin/basin.rye` is a living module with a born name. It does one thing: it holds a circular
buffer for the ScribexTally performance monitor. It does that thing well, in about 300 lines.
It is not a kernel and was never built as one.

The elder whitepaper at `gratitude/grain-sketchbook/` named "Basin" as the kernel. That kernel
was never built. The roles it described are now filled:

- **Process supervision** -- Caravan, 114 modules, witnessed
- **Capability domains** -- `caravan_cap.rye` and `caravan_supervision.rye`, proven on bare metal
- **Preemptive scheduling** -- `preempt.rye`, M-mode CLINT timer on freestanding RV64
- **Bring-up and verification** -- Terrarium, 40 stages, all GREEN

A future kernel that composes preempt, caravan_cap, and caravan_supervision onto real hardware
would be **Caravan on hardware** -- which is what it already is in the freestanding stages,
honestly named. Reclaiming the Basin name for that kernel would ask a reader to forget what
Basin actually is today, which violates the Comlink Tendency's first test: clear.

### Question 7: What is the simplest thing that works?

**Principle:** The finishing edge -- ship one real thing before naming the next.

**Recommendation: Extract one tab. Build one witness. Ship.**

The simplest thing that works is:

1. Extract Bloom's tab data model from `main.swift` into `vantage/bloom.rye`.
2. Build one witness that proves the Rye module produces identical output to the Swift original
   for a known set of content pages.
3. Wire `main.swift` to call the Rye module through a thin FFI bridge instead of its own
   inline Swift logic.
4. Ship.

That single extraction teaches the seam shape (what crosses the Swift/Rye boundary), proves the
FFI bridge (how Swift calls Rye), and ships one real thing a developer can read and test. The
rest of the extraction -- Dimeroll, Realidream, the remaining tabs -- follows the same pattern
the first one proved.

The hammock says: name the second platform (WASM), build one thing for it (one Bloom tab in
Rye, compiled to WASM, rendering in a browser), and let the abstraction boundary reveal itself
from the concrete case. That one tab, working in two places, is worth more than a perfect
architecture diagram working in zero.

---

## Proposed Journey Shape

Following the Calfive calendar, this work fits a **75-movement journey** across **5 quests**:

| Quest | Title | Movements | What ships |
|---|---|---|---|
| **1** | Extract Vantage | 15 | `vantage/bloom.rye` extracted, FFI bridge proven, witness GREEN |
| **2** | Station macOS | 15 | Clean separation of AppKit shell from Vantage logic in `terrarium/app/` |
| **3** | Station WASM | 15 | One Bloom tab rendering in a browser via Rye-to-WASM compilation |
| **4** | Remaining extraction | 15 | Dimeroll and Realidream moved to `vantage/`, all witnesses GREEN |
| **5** | Teacher molt and polish | 15 | Bhakta -> Teacher Style unification, tools/ cleanup, documentation |

Each quest is 15 movements -- one orbit. Each movement ships one witnessed thing. The journey
is 75 movements -- one quest of quests -- which is the panchanga's own ring.

**Quest 1 is the keystone.** It proves the seam, proves the bridge, and ships one tab that
works. If Quest 1 succeeds, the rest is mechanical. If Quest 1 reveals that the FFI bridge is
too expensive or the seam falls in the wrong place, that finding is worth the whole journey.

---

## What this RFC does not decide

- **Station as a named module.** The Station abstraction earns its own directory after the WASM
  target has proven where the boundary belongs. Until then, the macOS shell stays in
  `terrarium/app/` and the name stays proposed.
- **Carry as a named module.** Mobile is deferred to a second journey.
- **A kernel name.** The kernel that composes Caravan's supervision with Preempt's scheduling
  earns its name when it is built. "Caravan on hardware" is the description, not the baptism.
- **Pond changes.** Pond's charter is unchanged. It hosts. Vantage serves inside it.

---

## The foundations this rests on

Every recommendation above traces back to a foundation this tree already keeps:

| Foundation | What it said | How it applied |
|---|---|---|
| **Single-Stranded** | Each module about one thing; compose, don't braid | Pond hosts, Vantage serves -- two jobs, two modules |
| **Lila and the Long Return** | Do lasting work first; ship one real thing before naming the next | Rye extraction lasts; WASM lasts; mobile waits |
| **TAME** | Safety first, performance second, joy third | Rye's compile-time bounds over Swift's runtime optionals |
| **Compass** | Check in before module seams | This RFC is the check-in |
| **Mechanism and Metaphor** | Name the concrete thing before the image | Every answer names files and line counts before it names a pattern |
| **Two Rooms** | Mark what is proven as proven and what is proposed as proposed | This whole document sits in the vision room, plainly marked |
| **Comlink Tendency** | The clearest word wins | Basin stays a buffer; Caravan stays supervision; Vantage is new and clear |
| **Finishing Edge** | Ship one real thing | Extract one tab, build one witness, ship |

---

## Closing

The simplest true thing about this RFC: 1,800 lines of application logic live inside a
platform-specific file, and they do not need to. Moving them into their own home -- in a
language that bounds what it promises -- is the work that lasts. Everything else this document
proposes follows from that one extraction, tested against a second platform, and trusted
because a witness proved it.

The play is ready. It needs a theater, and then it needs a second theater. The first theater
is already built. The second is a browser tab anyone can open.

May the extraction land cleanly, and may what it teaches be worth the reaching.
