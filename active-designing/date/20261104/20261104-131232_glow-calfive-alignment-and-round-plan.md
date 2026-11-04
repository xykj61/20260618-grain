# Glow Calfive Alignment and Round Plan

**Status:** Living -- checkable
**Room:** checkable
**Stamp:** `20261104.131232`
**Voice:** Kyri

---

## The question Keaton asked

Ensure the Glow language journey is the priority in our Calfive before Lotus, plan out
all the rounds, and consider unifying Calfive and rota so the elements match.

## Where we stand

Commit count at measurement: **14,425** (`git rev-list --count HEAD`).

- Orbit round: `(14425 - 1) % 15 + 1` = **10** (Capricorn, cardinal earth, law -- "What must stop")
- Quest place: `(14425 - 1) % 75 + 1` = **25** (last round of the current quest)

The Glow language journey checklist has five orbits remaining (11-15). The next commit
lands at 14,426, which is orbit round **11**. The five Glow orbits map naturally to
rounds 11-15, and Lotus resumes at round 1 of the next quest.

## The natural alignment

Each tablecloth orbit is a single-commit deliverable. The five remaining Glow orbits
map one-to-one to the five remaining Calfive rounds in this quest:

| Commit | Round | Sign | Mode | Element | Goal | Verb | Glow orbit | Work |
|---|---|---|---|---|---|---|---|---|
| 14,426 | 11 | Aquarius | fixed | air | fun | One clear type, studied | 11 | Interactive Glow REPL in Brushstroke |
| 14,427 | 12 | Pisces | dual | water | aesthetics | The wish. One beautiful close. | 12 | Glow-driven layout demo |
| 14,428 | 13 | sky | cardinal | aether | heart | Names the heart page | 13 | "Your First Glow Program" tutorial |
| 14,429 | 14 | sky | fixed | aether | heart | Holds one page whole | 14 | "Glow Meets the Screen" tutorial |
| 14,430 | 15 | sky | dual | aether | heart (Siya) | The full orbit | 15 | docs-geode/cookbook expansion |

**The verbs fit the work.** Round 11 (fun, "one clear type, studied") is the REPL where
a newcomer studies the type system by typing. Round 12 (aesthetics, "one beautiful close")
is the visual demo -- the wish made visible. Rounds 13-15 (heart) are the tutorials and
cookbook -- the heart of what the language is for.

## Rota bookend matches

The rota cycles the five elements by `N mod 5` where N is the commit count:

| Commit | Rota element | Calfive element | Match? |
|---|---|---|---|
| 14,426 | air (`14426 % 5 = 1`) | air (Aquarius) | **YES** |
| 14,427 | fire (`14427 % 5 = 2`) | water (Pisces) | no |
| 14,428 | water (`14428 % 5 = 3`) | aether (sky-13) | no |
| 14,429 | earth (`14429 % 5 = 4`) | aether (sky-14) | no |
| 14,430 | aether (`14430 % 5 = 0`) | aether (sky-15) | **YES** |

The bookends match -- air opens, aether closes -- and the three middle rounds carry
different elements. This is structural: Calfive uses 15 signs with 5 elements in a
3-per-element distribution, while the rota uses 5 elements in a mod-5 cycle. The two
orderings agree at the boundaries of every 5-round span and diverge in the interior.

## Why no superfluous commits are needed

Keaton asked whether adding empty commits could align the two systems perfectly. The
answer is no, and the reason is structural:

- Calfive distributes 5 elements across 15 rounds: each element appears 3 times
  (cardinal, fixed, dual). The cycle is `fire fire fire earth earth earth air air air
  water water water aether aether aether` -- three of each in sequence.
- Rota distributes 5 elements across a mod-5 cycle: `aether air fire water earth
  aether air fire water earth ...` -- one of each in strict rotation.

No amount of shifting makes three-in-a-row match one-in-five. The two calendars are
designed for different purposes -- Calfive for the panchanga's quality of time, rota for
the council's breadth of attention -- and their alignment at the bookends (round 1 and
round 5 of each 5-round span) is the natural harmony rather than a deficiency.

The natural alignment is already elegant: Glow finishes at round 15 (the full orbit,
Siya's chair), and Lotus recommences at round 1 (Aries, cardinal fire, talent --
"Commence!"). That is the cleanest possible boundary -- a full orbit closes, a new one
opens.

## What comes after: Lotus resumes fresh

| Commit | Round | Sign | Mode | Element | Goal | Verb | Lotus orbit | Work |
|---|---|---|---|---|---|---|---|---|
| 14,431 | 1 | Aries | cardinal | fire | talent | Commence! | Window | Brushstroke/Skate window (carried from Quest 1.1) |
| 14,432 | 2 | Taurus | fixed | earth | law | What must stop | 4 | Multiple tracks in Weave |
| 14,433 | 3 | Gemini | dual | air | fun | Double reading | 5 | The mixer bus |
| 14,434 | 4 | Cancer | cardinal | water | aesthetics | Home page | 6 | Track editing on the timeline |
| 14,435 | 5 | Leo | fixed | fire | talent | One proud claim | 7 | Multi-track export and polish (Quest 1.2 SLC) |

**Again the verbs fit.** Aries ("Commence!") opens the visual surface. Taurus ("What must
stop") enforces the multi-track discipline. Leo ("One proud claim") is the quest SLC --
one proud claim that a person can record, mix, and export.

## Priority ordering

**Glow before Lotus.** The Long Return says: do the work that will still read true on the
far side of the years. A language is that work. Lotus will import Glow's stdlib for its
parameter declarations, session notation, and plugin descriptors. Growing the stdlib
first means those imports land on solid ground. The Glow language journey's last five
orbits close the journey with tutorials and a cookbook -- the teaching that makes the
language usable. After that, Lotus takes the next quest with a fresh Aries start.

## Measurements

- `git rev-list --count HEAD` = **14,425** (free -- run it)
- Glow orbits remaining: **5** (11-15)
- Lotus Quest 1.2 orbits remaining: **5** (window + 4-7)
- Fascia at measurement: **60.055**
- Fascia after Glow journey closes (5 more orbits): **60.060**

Related: `foundations/20260826-014901_the-panchanga.md` (the calendar charter),
`expanding-prompts/20261007-165138_the-fifteen-and-the-five-goals.md` (the fifteen signs),
`context/SPELLBOOK.md` (the round load table),
`tablecloth/20261103-184811_glow-language-journey/CHECKLIST.md` (the Glow journey).
