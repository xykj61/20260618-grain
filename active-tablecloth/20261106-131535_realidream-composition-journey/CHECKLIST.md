# Realidream Composition Journey -- Master Checklist

**Stamp:** `20261106.131535`
**Voice:** Kyri
**Style:** Gauge at Field
**Status:** Living
**Room:** Checkable

---

## Act I: The Composing Seam (Movements 1-15)

### Quest 1: FrameGrid in the Glass (Movements 1-5)

- [x] **Movement 1: Import SkateCore into Terrarium build** -- PROVEN `20261106.132800`
  - SLC gate: `swiftc` compiles `terrarium/app/main.swift` with SkateCore sources, app launches
  - Added `InlineArrayEquatable.swift` -- retroactive `Equatable` for `InlineArray` where `Element: Equatable` (Swift 6.3.3 stdlib gap)
  - SkateCore builds as a module (`-swift-version 6`), Terrarium links it without strict concurrency
  - `import SkateCore` in `main.swift`, binary links `libSkateCore.dylib` + AppKit + Foundation
  - Two-step build: SkateCore module first, then Terrarium linking it

- [x] **Movement 2: FrameGrid NSView -- draw bounded text into AppKit** -- PROVEN `20261106.140200`
  - SLC gate: an `NSView` subclass draws a FrameGrid's 40x8 cells using Core Graphics
  - `FrameGridView` class with `draw(_:)` iterating 8 rows x 40 columns, Core Graphics fill and text draw
  - Palette slot 0 = default foreground (terminal green on black); slots 1-7 from SkateColor
  - Monospace font metrics (`NSFont.monospacedSystemFont`) size each cell, `isFlipped = true` for top-down layout
  - Test pattern: green bands (rows 0, 7) and purple block (row 3, cols 15-24) verify palette-to-color path
  - Wired into Terrarium window above the terminal scroll view with autoresizing

- [x] **Movement 3: Dual-pane window -- QEMU terminal beside FrameGrid** -- PROVEN `20261106.154200`
  - SLC gate: Terrarium window shows two panes side by side, both visible at launch
  - Left pane: NSScrollView with NSTextView showing QEMU serial output
  - Right pane: FrameGridView in a black container with test pattern (green bands, purple block)
  - NSSplitView with `.thin` divider style, `isVertical = true`, resizable
  - Window widened to 1040 (from 720) to accommodate side-by-side layout, 60/40 initial split
  - Framebuffer stage branch preserved (NSImageView above split view)
  - Fallback for pre-macOS 26: right pane is a plain black NSView

- [x] **Movement 4: Serial-to-grid bridge -- parse QEMU output into FrameGrid cells** -- PROVEN `20261106.161845`
  - SLC gate: QEMU serial output drives FrameGrid content in real time
  - Added `writeRow(row:text:)` public method to FrameGrid -- writes ASCII bytes into cells, truncates at 40, pads with space
  - `updateGrid()` in AppDelegate parses `serialBuffer` into lines, takes the last 8 non-empty, writes each to a grid row
  - Palette slot 1 (terminal green) paints each row's text region
  - Live update: each `appendText` call triggers `updateGrid`, so the grid scrolls as new serial lines arrive
  - Tested with `amphora_seal_g` (long output, scrolling) and `hello` (short output, one line)

- [x] **Movement 5: Quest 1 integration witness** -- PROVEN `20261106.143447`
  - SLC gate: witness script launches Terrarium with a QEMU stage, verifies QEMU output reaches the app
  - `tools/te/terrarium_quest1_witness.rish` runs the two-step build, launches Terrarium with `hello` stage
  - `tools/fixtures/te/terrarium_quest1_launch.sh` verifies: QEMU launched, hello output arrived, clean exit
  - All four movements proven: SkateCore build, FrameGridView in binary, app runs, serial-to-grid bridge works
  - Terrarium self-terminates after QEMU exits (dumpAndExit), so hello.elf causes a fast clean cycle

### Quest 2: Events Flow Back (Movements 6-10)

- [x] **Movement 6: EventRing keyboard adapter -- AppKit events to EventRing** -- PROVEN `20261106.152832`
  - SLC gate: `keyDown` events from NSView enter the EventRing and are readable
  - `SkateEvent` enum in `skate/Sources/SkateCore/SkateEvent.swift` -- keyDown, keyUp, mouseDown, mouseMove, mouseUp, each carrying associated values
  - FrameGridView overrides `acceptsFirstResponder` (true), `keyDown`, `keyUp` -- translates NSEvent to SkateEvent and pushes into EventRing
  - EventRing capacity respected -- `try eventRing.append()` catches `.full` and drops the event
  - Two-step build clean, Terrarium launches and exits clean with hello stage

- [x] **Movement 7: FrameGrid cursor -- visible cursor driven by EventRing**
  - SLC gate: arrow keys move a visible cursor cell in the FrameGrid
  - Cursor position stored as (row, column) bounded by SkateCoreBounds
  - Arrow keys (up/down/left/right) from the EventRing move the cursor
  - FrameGridView draws the cursor cell with an inverted palette
  - `processEvents()` drains EventRing on each keyDown, updates cursorRow/cursorCol, triggers needsDisplay
  - Cursor rendered as inverted palette (FG becomes BG fill, BG becomes text color); empty cells filled with defaultFG
  - Two-step build clean, Terrarium launches and exits clean with hello stage

- [ ] **Movement 8: ConsentRail integration -- user consent flows**
  - SLC gate: a consent prompt appears in the FrameGrid, Enter accepts, Escape declines
  - ConsentRail presents a question in the FrameGrid's bottom row
  - EventRing delivers the user's keypress (Enter or Escape)
  - The consent result flows back to the caller

- [ ] **Movement 9: Scene switching -- Cmd+1 and Cmd+2**
  - SLC gate: Cmd+1 focuses the QEMU terminal pane, Cmd+2 focuses the FrameGrid pane
  - NSWindow key equivalent handling for Cmd+1 and Cmd+2
  - Focus indicator (subtle border or title highlight) shows which pane is active
  - Keyboard events route to the focused pane only

- [ ] **Movement 10: Quest 2 integration witness**
  - SLC gate: witness script verifies keyboard events flow through EventRing to FrameGrid cursor
  - Launch Terrarium, simulate keyboard input
  - Verify cursor moves in the FrameGrid
  - Verify Cmd+1/Cmd+2 switches focus between panes

### Quest 3: Navigation Shell (Movements 11-15)

- [ ] **Movement 11: Tab bar -- one tab per module view**
  - SLC gate: a tab bar shows at least two tabs (Terminal, Grid), clicking switches the active view
  - NSTabView or a custom segmented control above the main content area
  - Tab 1: QEMU Terminal (existing serial view)
  - Tab 2: FrameGrid (the composed SkateCore view)
  - Tabs are addable by future modules

- [ ] **Movement 12: Sidebar skeleton -- module navigation**
  - SLC gate: a collapsible sidebar lists available modules, selecting one switches the main view
  - NSOutlineView or NSTableView in a sidebar position
  - Initial entries: Terminal, FrameGrid, Dimeroll (placeholder), Mantra (placeholder)
  - Cmd+0 toggles sidebar visibility

- [ ] **Movement 13: Keyboard shortcut registry**
  - SLC gate: Cmd+T opens a new tab, Cmd+W closes the current tab, Cmd+[ goes back
  - Centralized shortcut registry mapping key combinations to actions
  - NSMenuItem key equivalents for menu bar integration
  - Shortcuts print to the status bar on activation (for visibility during development)

- [ ] **Movement 14: Status bar -- connection state and current module**
  - SLC gate: a status bar at the bottom of the window shows QEMU connection state and the active module name
  - Left: connection indicator (green dot when QEMU process alive, red when stopped)
  - Center: current module name (Terminal, FrameGrid, etc.)
  - Right: movement count and stage name

- [ ] **Movement 15: Act I integration witness -- the navigable shell**
  - SLC gate: witness script proves the full shell -- tabs, sidebar, shortcuts, status bar, live QEMU data
  - Launch Terrarium, verify all UI elements render
  - Verify tab switching, sidebar navigation, keyboard shortcuts
  - Verify QEMU serial data flows through to both Terminal and FrameGrid views
  - This is the shell that DJINN's Bit Design System fills when gate %6 opens

---

## Bookmarks

### What exists today

| Component | Path | State |
|---|---|---|
| SkateCore Swift Package | `skate/Package.swift` | 7 data types, headless, tested |
| Terrarium macOS app | `terrarium/app/main.swift` | 820 lines, AppKit + QEMU |
| Brushstroke Rye modules | `brushstroke/*.rye` | 56+ rendering modules |
| Pond/Realidream modules | `pond/apps/realidream_*.rye` | View, derive, fuse, reader, reread |
| Pond/Scooter modules | `pond/apps/scooter_*.rye` | Channel, compose, nav, paint, scroll |
| Mantrapod QEMU modules | `terrarium/*.rye` | 40+ freestanding RV64G modules, all GREEN |

### What this journey builds

| Milestone | Movement | What it delivers |
|---|---|---|
| SkateCore in Terrarium | 1 | SkateCore compiles with Terrarium |
| FrameGrid rendered | 2-3 | Bounded text grid visible in AppKit |
| Live QEMU bridge | 4-5 | Serial output drives FrameGrid in real time |
| Keyboard events | 6-7 | AppKit events flow through EventRing to cursor |
| Scene switching | 8-9 | Cmd+1/Cmd+2, consent flows |
| Navigation shell | 11-15 | Tabs, sidebar, shortcuts, status bar |

### Dependencies

- **DJINN gate %6:** The Bit Design System governs the rendering pipeline. This journey
  composes headless types into AppKit, not a rendering engine. Gate %6 is respected.
- **Mantrapod board acquisition:** PAUSED per Keaton's word. All movements run on QEMU.
- **Swift 6.2 / macOS 26.0:** Required for SkateCore's `InlineArray`. This pier runs
  Swift 6.3.3 on macOS 26.6.
