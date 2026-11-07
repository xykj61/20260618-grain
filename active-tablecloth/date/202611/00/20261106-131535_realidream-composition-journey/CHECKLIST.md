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

- [x] **Movement 8: ConsentRail integration -- user consent flows** -- PROVEN `20261106.161200`
  - SLC gate: a consent prompt appears in the FrameGrid, Enter accepts, Escape declines
  - ConsentRail folded frame renders in bottom 3 rows of FrameGrid with dark blue background, yellow text
  - Prompt line `[Enter] accept  [Esc] decline` in gray on the third overlay row
  - Press 'c' to trigger test consent; Enter resolves accepted, Escape resolves declined
  - EventRing delivers keypress; arrow keys blocked while consent is active
  - `showConsent(rail:callback:)` public API for callers; `resolveConsent(accepted:)` clears state and fires callback
  - Two-step build clean, Terrarium launches and exits clean with hello stage

- [x] **Movement 9: Scene switching -- Cmd+1 and Cmd+2** -- PROVEN `20261106.163500`
  - SLC gate: Cmd+1 focuses the QEMU terminal pane, Cmd+2 focuses the FrameGrid pane
  - NSMenu with View menu containing Cmd+1 (Focus Terminal) and Cmd+2 (Focus Grid)
  - `focusTerminal()` makes textView first responder, `focusGrid()` makes FrameGridView first responder
  - Focus indicator: 2px blue border on the active pane's container, removed from the inactive pane
  - `updateFocusIndicator()` reads `window.firstResponder` and sets border accordingly
  - scrollView and gridContainer promoted to AppDelegate properties for border updates
  - Keyboard events route to the focused pane via standard NSResponder chain
  - Two-step build clean, Terrarium launches and exits clean with hello stage

- [x] **Movement 10: Quest 2 integration witness** -- PROVEN `20261106.170500`
  - SLC gate: witness script verifies keyboard events flow through EventRing to FrameGrid cursor
  - `tools/te/terrarium_quest2_witness.rish` runs the build, exercises a headless Swift harness, builds Terrarium
  - `tools/fixtures/te/terrarium_quest2_harness.swift` -- 16 proofs across 6 test functions
  - `tools/fixtures/te/terrarium_quest2_launch.sh` -- build-and-run script for the harness
  - All 16 proofs GREEN: SkateEvent, EventRing, FrameGrid, ConsentRail, integration flow, cursor movement
  - Quest 2 complete -- all 5 movements proven

### Quest 3: Navigation Shell (Movements 11-15)

- [x] **Movement 11: Tab bar -- one tab per module view** -- PROVEN `20261106.180200`
  - SLC gate: a tab bar shows at least two tabs (Terminal, Grid), clicking switches the active view
  - NSSplitView replaced with NSTabView (`.topTabsBezelBorder`), two tabs: Terminal and Grid
  - Tab 1 wraps NSScrollView/NSTextView (QEMU serial); Tab 2 wraps FrameGridView container
  - Cmd+1/Cmd+2 select tabs via `tabView?.selectTabViewItem(at:)` and set first responder
  - Focus border indicators removed -- tab selection makes the active view obvious
  - Tabs are addable by future modules via `NSTabViewItem` append
  - Quest 2 witness GREEN (16 proofs), Terrarium builds and launches clean

- [x] **Movement 12: Sidebar skeleton -- module navigation** -- PROVEN `20261106.184500`
  - SLC gate: a collapsible sidebar lists available modules, selecting one switches the main view
  - NSSplitView wraps sidebar (left, 180px) and NSTabView (right)
  - NSTableView with plain style, no header, dark background (white: 0.15), row height 28
  - Four entries: Terminal, Grid, Dimeroll (placeholder), Mantra (placeholder)
  - NSTableViewDataSource and NSTableViewDelegate on AppDelegate via extensions
  - Selecting Terminal or Grid row switches the corresponding tab
  - Cmd+0 toggles sidebar visibility (hide/show with split position)
  - Quest 2 witness GREEN (16 proofs), Terrarium builds and launches clean

- [x] **Movement 13: Keyboard shortcut registry**
  - SLC gate: Cmd+T opens a new tab, Cmd+W closes the current tab, Cmd+[ goes back
  - Shortcuts menu with three NSMenuItems: New Tab (Cmd+T), Close Tab (Cmd+W), Previous Tab (Cmd+[)
  - Status bar (NSTextField, 22px) at bottom of window shows shortcut activations
  - newTab creates dynamic tabs with placeholder views; closeTab refuses built-in Terminal/Grid tabs
  - previousTab wraps to last tab when at first position
  - Quest 2 witness GREEN (16 proofs), Terrarium builds and launches clean

- [x] **Movement 14: Status bar -- connection state and current module**
  - SLC gate: a status bar at the bottom of the window shows QEMU connection state and the active module name
  - Left: connection indicator (green dot when QEMU process alive, red when stopped)
  - Center: current module name (Terminal, FrameGrid, etc.)
  - Right: movement count and stage name
  - NSView container replaces single NSTextField, three fields: connectionLabel, moduleLabel, infoLabel
  - NSTabViewDelegate added to AppDelegate, updateStatusBar called on tab switch, QEMU launch, and termination
  - showShortcutStatus temporarily overrides center field, auto-restores after 2 seconds
  - Quest 2 witness GREEN (16 proofs), Terrarium builds and launches clean

- [x] **Movement 15: Act I integration witness -- the navigable shell**
  - SLC gate: witness script proves the full shell -- tabs, sidebar, shortcuts, status bar, live QEMU data
  - `terrarium_act1_witness.rish` GREEN: composes Quest 1, Quest 2, and Quest 3 in one pass
  - SkateCore builds (9 files), Quest 2 harness passes (16 proofs), Terrarium builds
  - 13 Quest 3 binary symbol checks: NSTabView, NSTableView, NSSplitView, Shortcuts, New/Close/Previous Tab, Focus Terminal/Grid, status connection/module, tab delegate, sidebar entries
  - QEMU integration proven: hello.elf launched, output reached app, clean exit
  - Act I (The Composing Seam): all 14 movements proven on metal

---

## Act II: The Field Ledger (Movements 16-30)

### Quest 1: Dimeroll in the Glass (Movements 16-20)

- [x] **Movement 16: Dimeroll tab -- sidebar entry creates a dedicated view** -- PROVEN `20261106.215000`
  - SLC gate: clicking "Dimeroll" in the sidebar creates and switches to a Dimeroll tab
  - Dimeroll tab with identifier "dimeroll", NSTextView with dark theme (warm gold text on near-black)
  - `focusDimeroll()` creates tab on first click, finds existing on subsequent clicks
  - Sidebar handler wired, status bar shows "Dimeroll", Cmd+W protects the tab
  - Act I witness GREEN after changes -- all 14 prior movements still proven

- [x] **Movement 17: Dimeroll stage launcher -- run a Dimeroll ELF from the tab** -- PROVEN `20261106.171836`
  - SLC gate: launching `dimeroll_tx_g.elf` from the Dimeroll tab shows farm transactions in the text view
  - `launchDimerollStage(_:)` spawns `qemu-system-riscv64` with the named ELF, captures UART via pipe
  - `dimerollProcess` property stores the Process, separate from the main `qemuProcess`
  - Output streams into `dimerollTextView` via `appendDimeroll(_:)` with warm gold attributed text
  - Termination handler reports exit status; existing process terminated before re-launch
  - Binary contains `launchDimerollStage`, `appendDimeroll`, `dimerollProcess` symbols
  - Terrarium builds clean, main QEMU integration unaffected

- [x] **Movement 18: Module selector -- pick which Dimeroll module to run** -- PROVEN `20261106.172652`
  - SLC gate: a dropdown or segmented control lets the user choose among the 10 Dimeroll modules
  - NSPopUpButton with 10 entries in a container above the text view, plus a Run button
  - `dimerollModules` array maps display labels to ELF basenames
  - `dimerollModuleChanged(_:)` clears the text view header and launches the selected stage
  - `dimerollRunClicked(_:)` re-runs the current selection
  - Auto Layout positions popup and scroll view; popup at top, text view fills remaining space
  - Binary contains `dimerollModulePopUp`, `dimerollModuleChanged`, `dimerollRunClicked`, `dimerollModules` symbols
  - Two-step build clean, main QEMU integration unaffected

- [x] **Movement 19: Structured output parsing -- transaction lines into table rows**
  - SLC gate: Dimeroll UART output is parsed into an NSTableView with columns per transaction field
  - Parse the five transaction verbs (plant, harvest, sell, compost, note) and their arguments
  - NSTableView with columns: #, Verb, Subject, Quantity, Price, Unit
  - Raw UART text view stays available via NSSegmentedControl toggle (Table / Raw)
  - `parseDimerollTransactions` buffers incoming UART text and splits on newlines
  - `parseDimerollLine` extracts `[N] (verb subject qty [unit] [price])` tuples into typed array
  - NSTableViewDataSource dispatch distinguishes sidebar table from Dimeroll table via identity check
  - Two-step build clean, 7 new symbols in binary, hello stage unaffected

- [x] **Movement 20: Quest 1 integration witness** -- PROVEN 20261106
  - Launch script (`terrarium_act2_quest1_launch.sh`) and Rishi witness (`terrarium_act2_quest1_witness.rish`)
  - 12 binary symbol checks: focusDimeroll, dimerollProcess, dimerollModulePopUp, dimerollModuleChanged, dimerollRunClicked, dimerollModules, NSPopUpButton, dimerollTableView, dimerollViewToggled, dimerollRawBuffer, dimerollTransactions, dimeroll_tx_g
  - QEMU integration: dimeroll_tx_g launched, output reached app, transaction line parsed, clean exit
  - File-based output capture avoids Rishi string-length limit on large QEMU terminal dumps

### Quest 2: Ledger Views (Movements 21-25)

- [x] **Movement 21: Inventory summary view**
  - SLC gate: running `dimeroll_inventory_g.elf` displays parsed inventory in a formatted table
  - NSTableView with columns: Subject, Quantity, derived from UART output
  - Final inventory state: tomatoes 95, peppers 15, leaves 30

- [x] **Movement 22: Cash flow view**
  - SLC gate: running `dimeroll_cashflow_g.elf` displays cash flow in a running-total format
  - Sale transactions with computed totals (tomatoes 12000, peppers 3750, total 15750)
  - Separate column for per-unit price and quantity sold

- [x] **Movement 23: Ledger page rendering**
  - SLC gate: running `dimeroll_ledger_g.elf` displays a paginated journal with all 9 transactions
  - Each transaction on its own line with verb, subject, quantity, metadata
  - Page header with farm name and date range

- [x] **Movement 24: Price arithmetic and seal display**
  - SLC gate: running `dimeroll_price_g.elf` shows FP arithmetic; `dimeroll_seal_g.elf` shows Amphora hash
  - Price view: per-unit calculations with integer arithmetic shown
  - Seal view: Amphora hash (0xb3db1acd) and the sealed data it covers

- [x] **Movement 25: Quest 2 integration witness**
  - SLC gate: witness proves all four ledger views parse and display correctly
  - Headless harness tests inventory, cash flow, ledger, and price/seal data models
  - QEMU integration: each Dimeroll module launched and output verified

### Quest 3: Query and Dashboard (Movements 26-30)

- [x] **Movement 26: Query panel -- select and run queries** -- PROVEN `20261106.191235`
  - SLC gate: a query panel lets the user pick query type (verb, subject, date, account) and execute
  - NSPopUpButton for query type, NSTextField for query parameter with contextual placeholder
  - Run Query button launches the corresponding `dimeroll_query_*_g.elf` module
  - `dimerollQueryTypeChanged` updates placeholder; `dimerollQueryRunClicked` syncs module popup and launches ELF
  - Second toolbar row below module selector, content area anchored to query row bottom
  - Build clean, all symbols in binary

- [x] **Movement 27: Query results display** -- DONE `20261106.192737`
  - SLC gate: query results appear in the Dimeroll tab as filtered transaction rows
  - NSTableView populated from parsed QEMU output
  - Each of the four query types produces correctly filtered results
  - `parseDimerollQueryLine` splits pipe-delimited rows, skips headers, stores 5-tuple
  - Four query-specific column layouts in `rebuildDimerollColumns`, col1-col4 identifiers
  - `numberOfRows` and `dimerollCellView` branch on `hasPrefix("dimeroll_query_")`
  - Build clean, all symbols in binary

- [x] **Movement 28: Dimeroll dashboard -- combined summary view** -- LANDED `20261106.194645`
  - SLC gate: a dashboard tab shows inventory, cash flow, and seal at a glance
  - Three sections in one scrollable view: inventory table, cash flow totals, Amphora seal hash
  - Driven by running three Dimeroll modules in sequence via phase chaining in terminationHandler
  - Dashboard is a pseudo-module at popup index 0 -- no real ELF, chains inventory/cashflow/seal
  - Build clean, dashboard symbols confirmed in binary

- [x] **Movement 29: Mantra tab -- placeholder for the next act** -- `20261106.195400`
  - SLC gate: clicking "Mantra" in the sidebar creates a Mantra tab with placeholder content
  - focusMantra() lazy-creates tab with identifier "mantra", soft purple on near-black
  - closeTab() protects "mantra" alongside the three existing built-in tabs
  - Build clean, focusMantra symbol confirmed in binary

- [x] **Movement 30: Act II integration witness -- the field ledger** (`20261106.200349`)
  - SLC gate: witness proves the full Dimeroll composition -- tab, launcher, selector, views, queries, dashboard
  - Composes Quest 1, Quest 2, and Quest 3 in one pass
  - All Dimeroll modules proven through Terrarium: 10 ELFs launched, output parsed, views rendered
  - Act II (The Field Ledger): all movements proven on metal
  - `terrarium_act2_witness.rish` GREEN: 24 symbols, 10 QEMU modules, all 30 movements proven

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
| Dimeroll tab and launcher | 16-20 | Sidebar creates Dimeroll view, launches QEMU stages |
| Ledger views | 21-25 | Inventory, cash flow, ledger page, price, seal display |
| Query and dashboard | 26-30 | Query panel, results, combined dashboard, Mantra placeholder |

### Dependencies

- **DJINN gate %6:** The Bit Design System governs the rendering pipeline. This journey
  composes headless types into AppKit, not a rendering engine. Gate %6 is respected.
- **Mantrapod board acquisition:** PAUSED per Keaton's word. All movements run on QEMU.
- **Swift 6.2 / macOS 26.0:** Required for SkateCore's `InlineArray`. This pier runs
  Swift 6.3.3 on macOS 26.6.
