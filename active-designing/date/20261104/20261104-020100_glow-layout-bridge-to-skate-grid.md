# Glow Layout Bridge to Skate Grid -- Orbit 11

**Seated:** `20261104.020100` on Keaton's word - **Status:** Living - **Room:** checkable

## What the bridge does

Glow's lowered layout shapes produce standalone programs with `pub fn main()`. They cannot be
imported by other Rye modules. The bridge is a Rye module (`tools/rye/layout_bridge.rye`) that
mirrors the Glow-lowered `LayoutCellShape` struct -- same seven `u32` fields, same defaults --
and adds Skate grid bound constants and a validation function.

## What each file does

- **`tools/rye/layout_bridge.rye`** -- the bridge module. Exports `LayoutCell` (7 fields matching
  the Glow lowered struct), five bound constants matching the Orbit 10 ceiling gates
  (`max_channel=255`, `max_col=39`, `max_row=7`, `max_width=40`, `max_height=8`), `validate` that
  checks every field against its bound, and `to_skate_color` that casts `u32` channels to
  Skate's `u8` triple with asserted bounds.

- **`tools/rye/layout_bridge_consumer.rye`** -- a standalone program that imports the bridge and
  proves validate on both sides: valid cells pass, each bound violation is caught by name, and
  boundary cells (exactly at the ceiling) pass without off-by-one error. Eight assertions.

- **`tools/g/glow_layout_bridge_witness.rish`** -- proves the Glow shapes still lower, the Rye
  consumer builds and runs, the lowered struct and the bridge struct have the same field count,
  and each bound constant matches its ceiling gate. Chains the prior layout witness as a
  regression check.

## The constraint the bridge names

Lowered Glow shapes have their own `main` entry point. Rye's `@import` resolves relative to the
importing file's directory, and a module with `pub fn main` cannot be imported as a library.
The bridge is the Rye-side mirror of the Glow type: one struct, one source of truth for the
bounds, and a validate function that catches the same violations the Glow gates refuse.

## What the witness proves

- Glow layout-color and layout-cell lower and build (EXIT:0)
- The Rye consumer builds, imports the bridge, and all 8 assertions pass
- The lowered cell and the bridge cell both carry 7 `u32` fields
- Each of the 5 bound constants matches its ceiling gate value
- The prior layout witness (3 shapes, 5 ceiling gates proven both sides) is GREEN

Related: Orbit 10 essay `20261104-014047_glow-layout-shapes-and-ceiling-gates.md`
