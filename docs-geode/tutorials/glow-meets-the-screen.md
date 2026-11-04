# Glow Meets the Screen

*From a text result to a visible window. One path, straight through.*

**Language:** EN - **Style:** Bhakta at the Door setting, with Radiant warmth (see `../../context/BHAKTA_STYLE.md`)
**Written:** `20261104.153200` - **Status:** Living tutorial
**Room:** checkable -- every quoted output block is read off a real run
**You will need:** a working Grain tree (see [The First Hour](the-first-hour.md)) with the Zig toolchain at `vendor/zig-toolchain/zig`, and a macOS machine (the window system uses AppKit)
**Where this sits:** home is [`../../README.md`](../../README.md) - the prior tutorial is [Your First Glow Program](your-first-glow-program.md)

---

## What this tutorial covers

In [Your First Glow Program](your-first-glow-program.md), every result appeared as a number in
the terminal. This tutorial shows you how Glow drives a visible window on screen -- a real
macOS window with text fields you can see and read.

Two programs already do this:

- **The REPL** (`glow/glow_repl.rye`) -- a window where you type a Glow expression, press
  Return, and see the result update live.
- **The layout demo** (`glow/glow_layout_demo.rye`) -- a window showing a column of six
  standard operations and their computed results.

You will build both, read the layout code, and change what appears on screen.

## How Glow reaches a window

Glow is a language for computation. It does not draw pixels or open windows by itself. The
bridge works like this:

```
Glow expression  -->  repl_eval.rye  -->  Rye module  -->  AppKit window
```

1. **Glow** describes the computation -- `(add 2 3)` or `(mul 4 5)`.
2. **repl_eval.rye** is a small evaluator written in Rye that parses and computes the result.
3. **The Rye module** (`glow_repl.rye` or `glow_layout_demo.rye`) opens a macOS window using
   `objc_seam.rye` -- a boundary layer that talks to AppKit through Objective-C message sends.
4. **The window** shows the result as a text field.

You do not need to understand `objc_seam.rye` to follow this tutorial. Think of it as the
bridge between your program and the screen, the same way `glow_run` is the bridge between
a `.glow` file and the terminal.

## Building and running the REPL

The REPL is a single Rye file that opens a window with an input field and an output field.

Build and run it:

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run glow/glow_repl.rye -lc -lobjc -framework Cocoa -framework CoreGraphics
```

A window appears. Type `(add 2 3)` and press Return. The output field shows `5`.

Try these:

```
(sub 10 3)        :: shows 7
(mul 4 5)         :: shows 20
(mix 255 128)     :: shows 127  (bitwise XOR)
42                 :: shows 42   (a bare number)
```

Type a malformed expression -- say, `(add 2)` -- and the output shows a named error. The
evaluator refuses what it cannot parse, rather than guessing.

Press Cmd+Q to close the window.

## Building and running the layout demo

The layout demo computes six expressions at startup and displays them in a column:

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run glow/glow_layout_demo.rye -lc -lobjc -framework Cocoa -framework CoreGraphics
```

A window appears showing a header and six rows. Each row has a label (the expression) and a
result (the computed answer):

```
(add 2 3)       5
(sub 10 3)      7
(mul 4 5)       20
(mix 255 128)   127
(jam 3 7)       196615
(cue 196615)    7
```

Press Cmd+Q to close the window.

## Reading the layout code

Open `glow/glow_layout_demo.rye` in your editor. The structure has three parts worth seeing:

### The entry table

Near the top of the file, a table of six entries defines what appears on screen:

```rye
pub const entries = [max_rows]Entry{
    .{ .expr = "(add 2 3)", .expected = 5 },
    .{ .expr = "(sub 10 3)", .expected = 7 },
    .{ .expr = "(mul 4 5)", .expected = 20 },
    .{ .expr = "(mix 255 128)", .expected = 127 },
    .{ .expr = "(jam 3 7)", .expected = 196615 },
    .{ .expr = "(cue 196615)", .expected = 7 },
};
```

Each entry is an expression and its expected result. The expected value is what the witness
checks -- if the evaluator ever returns a different answer, the witness catches it.

### The geometry constants

Below the entries, a set of public constants defines the window's layout:

```rye
pub const row_height: u32 = 36;
pub const margin: u32 = 20;
pub const view_w: u32 = 520;
pub const view_h: u32 = header_y + 48;
```

Every dimension is a named constant with an explicit `u32` width. There is no layout that
can grow without a ceiling -- the same bounded discipline that governs Glow values governs
the window that shows them.

### The row position function

```rye
pub fn row_y(i: u32) u32 {
    assert(i < max_rows);
    return margin + (max_rows - 1 - i) * row_height;
}
```

This places each row from top to bottom in a window where y = 0 is the bottom (macOS
convention). Row 0 appears at the top of the column, row 5 at the bottom.

## Changing what appears on screen

Here is the exercise. Open `glow/glow_layout_demo.rye` and change one entry in the table.
For example, replace the last entry:

```rye
.{ .expr = "(cue 196615)", .expected = 7 },
```

with:

```rye
.{ .expr = "(add 100 200)", .expected = 300 },
```

Rebuild and run:

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run glow/glow_layout_demo.rye -lc -lobjc -framework Cocoa -framework CoreGraphics
```

The bottom row now shows `(add 100 200)` with the result `300`. You changed what a Glow
program shows on screen by editing one line of a table.

When you are done experimenting, revert the change so the witness stays GREEN:

```
git checkout glow/glow_layout_demo.rye
```

## Where to go from here

- [Your First Glow Program](your-first-glow-program.md) -- the prior tutorial, if you have
  not read it yet.
- The `glow/gen/` room holds 385 Glow programs, each a small example you can read and run.
- `glow/repl_eval.rye` is the evaluator: 6 operations, one error type with 4 named variants,
  and a `max_input_len` of 256 characters. Reading it is a good way to see how a bounded
  parser works in Rye.

---

*May the first window stay plain and glad, and may what you change on screen be exactly what you meant.*
