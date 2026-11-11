# Onboarding UX -- the path from clone to glad

**Last updated:** `20261111.105128`
**Status:** Proposed -- awaiting Keaton's word
**Room:** Design
**Style:** Gauge at the Field setting

## What the survey read

Nine surfaces: `README.md`, `SOURCE.md`, `MAP.md`, `docs-geode/` (tutorials, lessons,
libraries), `manual/`, `docs/`, `CONTRIBUTING.md`, the Terrarium app itself, and the
public seed at `seed/`.

## What works well

The First Hour tutorial is strong -- six steps, Teacher at the Door, output verified by
`tutorial_output_scan.sh` and `first_hour_witness.rish`. The README carries a clear
"join here" link to that tutorial. MAP orients a newcomer to the seven rooms. Eight
lessons and twenty-three tutorials cover real ground across the product.

## Three gaps, in order of weight

### 1. No quick path to seeing something on screen

The First Hour requires fetching a toolchain and building from source -- roughly an hour
of terminal work before anything runs. There is no "clone and see something in five
minutes" path.

Terrarium is the most accessible entry point: a macOS native app (Swift/AppKit) with
audio playback and mixing, social feed (Surf), content-addressed store (Mantra), and
relay networking -- all recently built, all GREEN on metal. It has zero onboarding
documentation.

### 2. Recently-built features have no user-facing docs

Surf Social (identity, feed, follow, persistence), Surf Relay (publish/fetch over UDP),
Lotus Audio (mixer, waveform, session persistence), and Mantra (blob store, catalog
browser) -- all shipped in the last week, all proven by integration witnesses, none
documented in `docs-geode/`.

A newcomer who clones today finds tutorials for features that landed months ago and
nothing for the ones that just shipped.

### 3. The front door is poetic where it should also be concrete

The README says what Grain is *for* beautifully, yet does not quickly say what it *does*
-- what a person sees when they run it. SOURCE starts with a cloud pier (Vultr + NixOS),
which is heavy for someone who just wants to try the thing. Three teaching shelves
(`docs/`, `docs-geode/`, `manual/`) are not distinguished at the front door.

## Proposed chapter: five movements

| Movement | Name | What it lands |
|---|---|---|
| 1 | terrarium-quick-start | A `docs-geode/tutorials/` tutorial: clone, build Terrarium, see audio + social + store in under ten minutes on macOS. Teacher at the Door. Verified output. |
| 2 | feature-docs-sweep | One `docs-geode/` page per recently-shipped feature: Surf Social (identity, feed, follow), Surf Relay (publish/fetch over UDP), Lotus Audio (mixer, waveform, session persistence), Mantra (blob store, catalog). Teacher Style. |
| 3 | readme-concrete-section | A short "What you see when you run it" section in the README, between the poetry and the "join here" link -- three or four sentences naming the actual surfaces (audio, social, store, relay) a person will find. |
| 4 | entry-path-streamline | Rewrite SOURCE.md's opening to lead with the local path (clone + build) before the cloud pier. Add a one-line distinction between the three teaching shelves at MAP.md's front door. |
| 5 | terrarium-onboarding-witness | A witness that builds Terrarium, launches it (or proves the binary exists), and asserts the tutorial's claimed outputs. The tutorial earns its GREEN the same way the First Hour earns its own. |

## What this does not reach

- Screenshots and video (those want a hand and a screen recorder)
- A Linux/Windows Terrarium path (Terrarium is macOS-native today)
- A "try it in the browser" demo (that wants Terrarium-on-web, a different chapter)
- A vocabulary glossary for newcomers (a valuable door, yet a chapter of its own)
- Rewriting existing tutorials or lessons (those already work)

## The order follows Lila and the Long Return

Movement 1 is the long return -- a front-door tutorial that will still read true years
from now. Movement 2 documents what already works. Movements 3 and 4 improve what
already exists. Movement 5 proves the tutorial the same way this tree proves everything.

## Related

Survey read: `README.md`, `SOURCE.md`, `MAP.md`, `docs-geode/README.md`,
`docs-geode/tutorials/the-first-hour.md`, `docs-geode/lessons/` (8 lessons),
`manual/`, `docs/README.md`, `CONTRIBUTING.md`.
