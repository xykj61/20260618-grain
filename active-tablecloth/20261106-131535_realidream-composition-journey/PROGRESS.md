# Realidream Composition Journey -- Progress Log

**Stamp:** `20261106.131535`
**Voice:** Kyri
**Style:** Gauge at Meter
**Status:** Living

---

## Progress

| Stamp | Movement | What landed | Witness |
|---|---|---|---|
| 20261106.191235 | 26 | Query panel -- NSPopUpButton for query type (By Verb/Subject/Date/Account), NSTextField with contextual placeholder, Run Query button; `dimerollQueryTypeChanged` updates placeholder, `dimerollQueryRunClicked` syncs module popup and launches selected query ELF | Build clean, `dimerollQueryTypes` + `dimerollQueryTypeChanged` + `dimerollQueryRunClicked` symbols in binary |
| 20261106.185704 | 25 | Quest 2 integration witness -- 7 binary symbols, 6 parser functions, 6 QEMU modules launched and verified; `terrarium_act2_quest2_witness.rish` GREEN | All 5 movements proven on metal, Act II Quest 2 complete |
| 20261106.184025 | 24 | Price arithmetic and seal display -- `parseDimerollPriceLine` pattern-matches transaction/proof/summary lines without markers, `parseDimerollSealLine` extracts key-value pairs between DIMEROLL FIELD LEDGER markers, both views with dedicated column layouts | Build clean, `dimerollPrice` + `dimerollSeal` symbols in binary, `parseDimerollPriceLine` + `parseDimerollSealLine` in nm demangle |
| 20261106.183500 | 23 | Ledger page rendering -- `parseDimerollLedgerLine` extracts 6-column journal rows (#/Verb/Subject/Qty/Price/Total) from multi-section UART output, filters by `Int(cells[0])` to skip inventory and cash flow sub-tables, `rebuildDimerollColumns` adds 6-column ledger case | Build clean, `dimerollLedger` symbol in binary, `parseDimerollLedgerLine` in nm demangle |
| 20261106.181827 | 22 | Cash flow view -- `parseDimerollCashflowLine` extracts Subject/Revenue from UART ledger table, `rebuildDimerollColumns` adds cashflow case with 2 columns, `numberOfRows` and `dimerollCellView` branch on `dimeroll_cashflow_g` | Build clean, `dimerollCashflow` symbol in binary, `parseDimerollCashflowLine` in nm demangle |
| 20261106.180722 | 21 | Inventory summary view -- `parseDimerollInventoryLine` extracts Subject/On Hand from UART ledger table, `rebuildDimerollColumns` swaps table between 6-column transactions and 2-column inventory, `dimerollActiveElf` routes line parsing | Build clean, `dimerollInventory` + `dimerollActiveElf` + `dimerollInLedgerTable` symbols in binary, `rebuildDimerollColumns` + `parseDimerollInventoryLine` in nm demangle |
| 20261106.180300 | 20 | Act II Quest 1 integration witness -- launch script and Rishi witness prove all 4 Dimeroll-in-the-Glass movements; 12 binary symbol checks, QEMU launches dimeroll_tx_g, output parsed, clean exit | `terrarium_act2_quest1_witness.rish` GREEN: all 4 movements proven on metal |
| 20261106.174122 | 19 | Structured output parsing -- `parseDimerollTransactions` buffers UART, `parseDimerollLine` extracts `[N] (verb subject qty [unit] [price])` tuples, NSTableView with 6 columns, NSSegmentedControl toggles Table/Raw | Build clean, `dimerollCellView` + `dimerollRawBuffer` + `dimerollTable` + `dimerollViewToggle` + `dimerollViewToggled` + `parseDimerollLine` + `parseDimerollTransaction` symbols in binary |
| 20261106.172652 | 18 | Module selector -- NSPopUpButton with 10 Dimeroll modules, Run button, `dimerollModuleChanged` launches selected ELF | Build clean, `dimerollModulePopUp` + `dimerollModuleChanged` + `dimerollRunClicked` + `dimerollModules` symbols in binary |
| 20261106.171836 | 17 | Dimeroll stage launcher -- `launchDimerollStage(_:)` spawns `qemu-system-riscv64`, captures UART into `dimerollTextView`, separate from main QEMU process | Build clean, `launchDimerollStage` + `appendDimeroll` + `dimerollProcess` symbols in binary |
| 20261106.171231 | 16 | Dimeroll tab -- sidebar entry creates dedicated view with `focusDimeroll()`, warm gold text on near-black, tab protected from Cmd+W, status bar recognizes module | Act I witness GREEN: all 14 prior movements still proven, no regression |
| 20261106.163107 | 15 | Act I integration witness -- composes Quest 1, Quest 2, Quest 3; 16 headless proofs, 13 binary symbol checks, QEMU integration proven | `terrarium_act1_witness.rish` GREEN: all 14 movements proven on metal |
| 20261106.210500 | 14 | Status bar with connection state and active module -- three-field NSView, NSTabViewDelegate, QEMU lifecycle wired | Quest 2 witness GREEN (16 proofs), Terrarium builds and launches clean |
| 20261106.195500 | 13 | Keyboard shortcut registry -- Shortcuts menu, Cmd+T/Cmd+W/Cmd+[, status bar at bottom | Quest 2 witness GREEN (16 proofs), Terrarium builds and launches clean |
| 20261106.184500 | 12 | Sidebar skeleton -- NSSplitView wraps NSTableView sidebar and NSTabView, Cmd+0 toggle | Quest 2 witness GREEN (16 proofs), Terrarium builds and launches clean |
| 20261106.180200 | 11 | Tab bar -- NSTabView replaces NSSplitView, Terminal and Grid tabs, Cmd+1/Cmd+2 select | Quest 2 witness GREEN (16 proofs), Terrarium builds and launches clean |
| 20261106.170500 | 10 | Quest 2 integration witness -- 16 proofs across 6 test functions, all GREEN | `terrarium_quest2_witness.rish` GREEN: SkateEvent, EventRing, FrameGrid, ConsentRail, integration flow, cursor |
| 20261106.163500 | 9 | Scene switching -- Cmd+1 focuses terminal, Cmd+2 focuses grid, blue border indicator | Two-step build clean, Terrarium launches and exits clean with hello stage |
| 20261106.161200 | 8 | ConsentRail integration -- consent overlay in bottom 3 rows, Enter accepts, Escape declines, 'c' triggers test | Two-step build clean, Terrarium launches and exits clean with hello stage |
| 20261106.155800 | 7 | FrameGrid cursor -- visible cursor driven by EventRing, arrow key movement | Two-step build clean, cursor inverts palette at position, arrow keys move it |
| 20261106.152832 | 6 | EventRing keyboard adapter -- `SkateEvent` enum and AppKit key wiring | Two-step build clean, Terrarium launches, key events enter EventRing |
| 20261106.143447 | 5 | Quest 1 integration witness -- `terrarium_quest1_witness.rish` proves Movements 1-4 end to end | GREEN: build, launch, QEMU output, clean exit all verified |
| 20261106.161845 | 4 | Serial-to-grid bridge -- `writeRow` API on FrameGrid, `updateGrid` parses serialBuffer into last 8 lines, palette slot 1 green | Tested amphora_seal_g (scrolling) and hello (single line), two-step build clean |
| 20261106.154200 | 3 | Dual-pane window -- NSSplitView, terminal left, FrameGridView right, resizable divider | Both panes visible, QEMU runs in left, test pattern in right, two-step build clean |
| 20261106.140200 | 2 | FrameGrid NSView draws 40x8 cell grid -- Core Graphics, palette colors, test pattern visible | `FrameGridView` renders, two-step build clean, Terrarium launches with grid |
| 20261106.132800 | 1 | Import SkateCore into Terrarium build -- InlineArray Equatable extension, two-step module build | `swiftc` clean, `import SkateCore` compiles, binary links |
| 20261106.131535 | -- | Journey board created, 15 movements planned | -- |
