# Glow layout shapes and ceiling gates -- Orbit 10

**Status:** Landed -- checkable
**Room:** checkable
**Stamp:** `20261104.014047`
**Style:** Gauge at Field
**Witness:** `tools/g/glow_layout_witness.rish` -- GREEN on metal
**Kin:** `active-designing/date/20261104/20261104-004038_glow-value-model-record.md` (Orbit 9, the value model this orbit composes)

## What this orbit proves

Three Glow shapes encoding color, position, and dimension on Skate's bounded grid, and
five ceiling gates validating each field against the grid's own constants. The composed
`layout-cell` shape (7 fields) is the largest authored shape in the tree, and it proves
that the value model composes color and position into a single record.

## The three shapes

| Shape | Fields | What it encodes |
|---|---|---|
| `layout-color` | red, green, blue | An 8-bit-per-channel color (0-255 each) |
| `layout-rect` | col, row, width, height | Position and extent on the grid |
| `layout-cell` | red, green, blue, col, row, width, height | Color and position composed in one record |

All three lower through `rune_shape.rye`, emit valid Rye, compile, and exit 0. The
7-field cell shape sits well within the `max_fields = 15` ceiling at `glow/rune_shape.rye:29`.

## The five ceiling gates

Each gate is a standalone program returning 1 (admit) or 0 (refuse), following the
consumer desk pattern already proven by the Skate gates in Orbit 4.

| Gate | Ceiling | Law |
|---|---|---|
| `gate-layout-channel-ceiling-u32` | 255 | `brushstroke/skate_cell_grid.rye` -- 8-bit palette |
| `gate-layout-col-ceiling-u32` | 39 | `grid_cols = 40`, 0-indexed |
| `gate-layout-row-ceiling-u32` | 7 | `grid_rows = 8`, 0-indexed |
| `gate-layout-width-ceiling-u32` | 40 | cannot exceed the grid's column count |
| `gate-layout-height-ceiling-u32` | 8 | cannot exceed the grid's row count |

Every gate uses the `gth` comparison operator, which is the cleanest path through the
gate conditional parser at `glow/rune_shop_gate.rye:150-195`. The parser also supports
`eq` and composed `(gth face (mul face2 face3))`, yet `gth` alone answers the ceiling
question directly.

## Both-sides proof

The witness tests each gate on both sides of its boundary:

- **channel:** 0 admits, 255 admits, 256 refuses
- **col:** 0 admits, 39 admits, 40 refuses
- **row:** 0 admits, 7 admits, 8 refuses
- **width:** 1 admits, 40 admits, 41 refuses
- **height:** 1 admits, 8 admits, 9 refuses

The prior value model witness runs GREEN within the same pass -- no regression.

## What was not built, and why

**Composed bounds** (`col + width <= 40`) were the original design. The gate conditional
parser does not support `add` as a composed operand -- only `mul` is wired at
`rune_shop_gate.rye:406-435`. Rather than widen the parser for one orbit, per-field
ceilings validate each dimension independently. A future orbit that widens the
expression system can compose the bounds then.

**Zero-width and zero-height** are structurally allowed. A hidden element has no extent,
and refusing zero would prevent a layout from describing an invisible spacer. The gates
validate the ceiling, and a floor gate at zero would admit everything.

## Files

- `glow/gen/l/layout-color.glow` -- 3-field color shape
- `glow/gen/l/layout-rect.glow` -- 4-field rectangle shape
- `glow/gen/l/layout-cell.glow` -- 7-field composed cell shape
- `src/gate/gate-layout-channel-ceiling-u32.glow` -- channel <= 255
- `src/gate/gate-layout-col-ceiling-u32.glow` -- col <= 39
- `src/gate/gate-layout-row-ceiling-u32.glow` -- row <= 7
- `src/gate/gate-layout-width-ceiling-u32.glow` -- width <= 40
- `src/gate/gate-layout-height-ceiling-u32.glow` -- height <= 8
- `tools/g/glow_layout_witness.rish` -- both-sides witness
- `tools/g/glow_run_worker.sh` -- five new stems registered in `arity_accepts()`
