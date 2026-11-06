# Realidream Composition Journey -- From Proven Pieces to One Living Surface

**Stamp:** `20261106.131535`
**Voice:** Kyri
**Style:** Gauge at Field
**Status:** Living
**Room:** Checkable
**Captain:** Incense
**Coauthor:** Keaton Dunsford

---

## 1. Introduction

The Mantrapod RV64G journey proved every layer of Grain's freestanding stack on QEMU --
self-compiling identity, bounded allocation, a Dimeroll field ledger with daily seal, and
a query engine across four dimensions. Forty movements, all GREEN.

Today those proofs speak through raw UART serial text in a Terrarium window. The person
reads hex hashes and proof counts scrolling past. The numbers are real, the system works,
and the surface is still the terminal a developer reads, rather than the application a
grower opens.

This journey carries those proven QEMU modules into the macOS surface they were always
meant to reach: **SkateCore's bounded data types rendered in Terrarium's AppKit window,
navigable by keyboard, composing the proven freestanding stack with the native GUI
framework.** The Realidream vision -- editor and browser as one surface -- is the far
horizon this composition points toward. Each movement here lays one stone on that path.

The pieces already exist. SkateCore holds seven Swift data types -- FrameGrid (text grid),
EventRing (event queue), ConsentRail (consent flow), ImageEditHistory, and three receipt
types -- all bounded, all headless, all proven by their own test suite. Terrarium holds
an 820-line AppKit application that launches QEMU and captures serial output. Brushstroke
holds 56 Rye rendering modules. Pond holds 40 Rye application modules including the
Realidream view, the Scooter navigation, and the Mantra browser and editor.

What does not yet exist: a composing seam between SkateCore and Terrarium. No FrameGrid
has ever drawn into an NSView. No EventRing has ever received an AppKit keyboard event.
No scene management, no tab navigation, no keyboard shortcut registry. The foundation is
laid and the architecture is open.

DJINN's custody gate %6 guards the Skate DAG rendering platform and the Bit Design System.
This journey works within that boundary -- composing the proven headless types into
AppKit views, wiring events, building navigation -- without designing the rendering
pipeline that gate %6 governs. When that gate opens, the shell this journey builds is
what the design system fills.

See `CHECKLIST.md` for the full movement-by-movement plan.

## 2. Problem

Three gaps stand between the proven freestanding modules and a usable macOS application:

1. **No rendering seam.** SkateCore's FrameGrid holds 40x8 cells of bounded text. No code
   draws those cells into an NSView. Terrarium's NSTextView shows raw serial output but
   does not speak SkateCore.

2. **No event bridge.** AppKit delivers keyboard and mouse events through `NSResponder`.
   SkateCore's EventRing accepts generic `Sendable` events. No adapter translates between
   them.

3. **No navigation.** Terrarium shows one view in one window. There is no tab bar, no
   sidebar, no scene switching, no keyboard shortcut registry. A person opening the
   application sees the QEMU terminal and nothing else.

## 3. Solution

Compose in three quests, each building on the one before it.

**Quest 1: FrameGrid in the Glass** (Movements 1-5). Import SkateCore into Terrarium's
build. Write an `NSView` subclass that draws a FrameGrid. Place it beside the QEMU terminal.
Parse serial output into FrameGrid cells. Witness: live QEMU data flowing through SkateCore
into a native AppKit view.

**Quest 2: Events Flow Back** (Movements 6-10). Write an EventRing adapter that takes
AppKit keyboard and mouse events. Drive a cursor through the FrameGrid from the EventRing.
Wire ConsentRail for user-facing consent flows. Add scene-switching keyboard shortcuts
(Cmd+1, Cmd+2). Witness: keyboard events flow through EventRing to a visible FrameGrid
cursor.

**Quest 3: Navigation Shell** (Movements 11-15). Build a tab bar (one tab per module
view). Add a sidebar skeleton for module navigation. Register keyboard shortcuts
(Cmd+T new tab, Cmd+W close, Cmd+[ back). Add a status bar showing connection state and
current module. Witness: a navigable shell with tabs, sidebar, shortcuts, and live QEMU
data.

## 4. Constraints

- **DJINN gate %6 stays closed.** The Skate DAG rendering platform proposals belong to
  DJINN. This journey composes headless types into AppKit views, not a rendering pipeline.
- **Single-file discipline.** Terrarium stays a single `main.swift` unless complexity
  demands otherwise. SkateCore imports as a Swift Package.
- **QEMU development continues.** Every movement runs on QEMU. No real hardware required.
- **Bounded by Tally.** Every new type carries a named capacity. SkateCoreBounds governs.
- **macOS 26.0 minimum.** SkateCore requires Swift 6.2 `InlineArray`. This pier runs 26.6.

## 5. Kin

- **Realidream foundation:** `foundations/20260825-233310_realidream.md`
- **SkateCore Swift Package:** `skate/Package.swift` (7 source files)
- **Terrarium app:** `terrarium/app/main.swift` (820 lines)
- **Brushstroke modules:** `brushstroke/*.rye` (56+ files)
- **Pond application modules:** `pond/apps/` (realidream, scooter, mantra, and more)
- **Mantrapod RV64G journey:** `active-tablecloth/20261105-085747_mantrapod-rv64g-journey/`
- **Alias-sameness (Surf/Skate):** `.claude/rules/alias-sameness.md`
- **Terrarium naming:** `.claude/rules/comlink-tendency.md` (browser-hosted RISC-V emulation)
