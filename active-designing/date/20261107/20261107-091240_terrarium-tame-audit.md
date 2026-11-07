# Terrarium TAME Audit -- main.swift and SkateCore

**Stamp:** `20261107.091240`
**Language:** EN
**Style:** Gauge at Field, with Radiant warmth
**Voice:** Kyri
**Status:** Living
**Room:** checkable
**Kin:** [`context/TAME_GUIDANCE.md`](../../../context/TAME_GUIDANCE.md) -- the operational supplement
**Kin:** [`context/TAME_CORE.md`](../../../context/TAME_CORE.md) -- the compressed core
**Kin:** [`session-logs/date/20261107/20261107-021200_bloom-journey-close-and-next.kyri.md`](../../../session-logs/date/20261107/20261107-021200_bloom-journey-close-and-next.kyri.md) -- the survey that named this audit

---

## What was read

- **`terrarium/app/main.swift`** -- 3,733 lines, 76 functions, 3 types. The entire macOS Terrarium application in one file.
- **`skate/Sources/SkateCore/*.swift`** -- 9 files, 1,409 lines. The well-composed counterexample.

Every line was read. The findings below are concrete, line-numbered, and mechanically verifiable.

## The positive example: SkateCore

SkateCore demonstrates what this tree already knows how to do well. Nine files, each owning one concern: `FrameGrid.swift` (cell grid), `ConsentRail.swift` (consent overlay), `EventRing.swift` (bounded ring buffer), `ReceiptCard.swift` (receipt rendering), `ImageEditHistory.swift` (undo stack), `AccessibilitySnapshot.swift` (VoiceOver support). Named types, bounded errors, proper module separation.

main.swift uses SkateCore types correctly where it reaches for them -- `FrameGridView` at line 3105 composes `FrameGrid` from SkateCore rather than reimplementing it. The composition boundary between SkateCore and AppDelegate is the one clean seam in the file.

## Single-stranded violations

**TAME's first structural rule: each module handles one concern.** main.swift handles at minimum seven:

| Concern | Lines | Weight |
|---|---|---|
| Window/tab/sidebar management | 149-426, 2221-2342 | ~400 lines |
| QEMU process launch and bridge | 1423-1521, 2348-2562 | ~370 lines |
| Dimeroll tab UI and data | 522-865, 1523-2219, 2840-3100 | ~1,470 lines |
| Bloom content loading and tab | 943-1421 | ~480 lines |
| Mantra wire protocol | 867-941, 2566-2732 | ~240 lines |
| FrameGrid rendering | 3105-3495 | ~390 lines |
| Crypto helpers | 3668-3724 | ~57 lines |

**AppDelegate** (lines 49-148) holds ~50 mutable instance variables with no encapsulation. It is the single owner of every concern above. A change to Bloom's content loading requires reading past Dimeroll's column definitions, QEMU's argument builder, and the Mantra wire handler to understand the file.

### Proposed extractions

Each extraction is a Swift file that main.swift's AppDelegate delegates to, rather than a rewrite:

1. **`QemuBridge.swift`** -- `launchQemu()`, `launchDimerollStage()`, `findQemu()`, `captureFramebuffer()`, QMP socket helpers. Owns the `Process` instances and the stdout pipe.
2. **`BloomLoader.swift`** -- `loadBloomLessons()` and the seven room-loading blocks. Returns structured content rather than mutating AppDelegate arrays.
3. **`DimerollController.swift`** -- `focusDimeroll()`, `rebuildDimerollColumns()`, `handleDimerollQuery()`, the dashboard phased launch. Owns the column definitions and the active-module state.
4. **`DimerollParser.swift`** -- The seven parse functions (`parseDimerollInventoryLine` through `parseDimerollSealLine`) and the dispatch logic in `parseDimerollTransactions()`.
5. **`MantraWireHandler.swift`** -- `handleWireFact()`, `handleMantraWire()`, the djb2 chain replay.
6. **`CryptoHelpers.swift`** -- `Djb2Swift`, `keyedDjb2Sign`, `hexToBytes`, `writeU32BE`.
7. **`WindowBuilder.swift`** -- The inline window/tab-bar/sidebar construction from `applicationDidFinishLaunching`.

## Sameness violations

**TAME asks: when you see the same shape three times, extract it.**

### 1. Bloom room loading (lines 943-1215) -- 7x repeated

Seven nearly identical blocks, one per Bloom room. Each:
- Builds a directory path from the repo root
- Calls `FileManager.default.contentsOfDirectory`
- Filters for `.md` suffix
- Sorts alphabetically
- Reads each file's contents
- Appends `(index, filename, title, body)` to an array

The only thing that varies: the subdirectory name and the destination array. A single function `loadRoom(subdirectory: String) -> [(Int, String, String, String)]` would replace all seven.

### 2. Dimeroll parse functions (lines 1592-1882) -- 7 parsers sharing one pattern

Each parser:
- Checks for a table-header sentinel string (`"--- DIMEROLL FIELD LEDGER ---"`, `"-- SLC GATE --"`, etc.)
- Splits pipe-delimited rows
- Trims whitespace from fields
- Appends an unnamed tuple to a specific array

The table-header detection and pipe-splitting are identical across all seven. A shared `parsePipeDelimitedRow(line: String, sentinel: String) -> [String]?` would factor the common logic, leaving each parser responsible only for its field mapping.

### 3. `rebuildDimerollColumns()` (lines 2024-2142) -- 11 if-else branches

Each branch builds an array of column definitions (title, width, identifier) for a different ELF module. The shape is identical: `columns = [("Title", width, "id"), ...]`. A dictionary `[String: [(String, CGFloat, String)]]` mapping module names to column definitions would replace the 120-line if-else chain.

### 4. `dimerollCellView()` (lines ~2950-3100) -- 8 if-else branches

Each branch extracts a field from an unnamed tuple by index position. The positional access (`row.0`, `row.1`, `row.5`) is fragile and unreadable. Named structs (see below) would make each branch a property access.

### 5. `findQemu()` duplicated (lines 1444-1458 and 2822-2837)

The same QEMU binary search logic appears in two places. The second instance (line 2822) is a standalone function; the first is inline in `launchDimerollStage()`.

### 6. `keyDown`/`keyUp` character extraction (lines ~3350-3400)

Both handlers extract the first character from the event with identical logic. A shared helper would serve both.

## Massive methods

TAME asks for short functions named with a verb. Seven methods exceed 100 lines:

| Method | Lines | What it does |
|---|---|---|
| `focusDimeroll()` | ~343 | Builds entire Dimeroll tab UI inline |
| `applicationDidFinishLaunching()` | ~277 | Builds window, tab bar, sidebar, status bar |
| `loadBloomLessons()` | ~272 | Loads all 7 Bloom rooms |
| `launchQemu()` | ~153 | Builds QEMU arguments and launches process |
| `dimerollCellView()` | ~150 | 8-branch cell rendering |
| `handleMantraWire()` | ~135 | Mantra chain verification with djb2 replay |
| `rebuildDimerollColumns()` | ~120 | 11-branch column definitions |

Each of these methods handles multiple concerns within its body. `focusDimeroll()` builds labels, tables, buttons, scroll views, and layout constraints -- five distinct responsibilities in one method.

## Unnamed types

Seven data arrays use unnamed tuples instead of structs:

```
var dimerollInventory: [(Int, String, String, String, String, String)] = []
var dimerollCashflow: [(Int, String, String, String, String)] = []
var dimerollLedger: [(Int, String, String, String, String, String)] = []
var dimerollSeal: [(Int, String, String, String)] = []
var dimerollGate: [(Int, String, String, String)] = []
var dimerollSchedule: [(Int, String, String, String, String)] = []
var dimerollBitfield: [(Int, String, String, String)] = []
```

A reader accessing `row.4` must count tuple positions to know what field they are reading. Named structs (`DimerollInventoryRow`, `DimerollCashflowRow`, etc.) would make every access self-documenting and every parse function's output checkable by the compiler.

## What this audit does not propose

- **A rewrite.** The extractions above are mechanical file splits. AppDelegate delegates to the new modules; the behavior stays identical.
- **New features.** The audit names what is tangled and where to cut. Each extraction is a future SLC movement.
- **SkateCore changes.** SkateCore is well-composed and stays as it is.
- **Urgency.** The Mantra SLC is the active priority. This audit produces a punch list for a future refactoring SLC, ordered by the sameness and single-stranded findings above.

## The punch list, ordered by impact

1. **Extract BloomLoader** -- highest sameness (7x repeated), cleanest boundary, and directly relevant to the Mantra SLC (Movement 9 wires Comlink into the lesson loader).
2. **Extract DimerollParser** -- second-highest sameness (7 parsers sharing one pattern), plus unnamed types. Named structs arrive with this extraction.
3. **Extract QemuBridge** -- resolves the duplicated `findQemu()` and isolates process management.
4. **Extract CryptoHelpers** -- smallest extraction (57 lines), zero dependencies on AppDelegate state.
5. **Extract MantraWireHandler** -- isolates the Mantra wire protocol, directly relevant to the Mantra SLC.
6. **Extract DimerollController** -- the largest extraction, best done after DimerollParser provides named types.
7. **Extract WindowBuilder** -- the UI construction code, best done last since it touches the most AppDelegate state.

---

*May each module hold one concern, each name say what it means, and the whole read as clearly as the SkateCore it already built.*
