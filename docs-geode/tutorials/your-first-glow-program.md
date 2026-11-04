# Your First Glow Program

*From nothing to a running Glow program. One path, straight through.*

**Language:** EN - **Style:** Bhakta at the Door setting, with Radiant warmth (see `../../context/BHAKTA_STYLE.md`)
**Written:** `20261104.154500` - **Status:** Living tutorial
**Room:** checkable -- every quoted output block is read off a real run
**You will need:** a working Grain tree (see [The First Hour](the-first-hour.md)) with the Zig toolchain at `vendor/zig-toolchain/zig`
**Where this sits:** home is [`../../README.md`](../../README.md)

---

## What Glow is, in one sentence

Glow is Grain's own programming language. A Glow program is a small text file that describes a
computation -- what to name, what to compute, what to hand back. Glow files end in `.glow`, and
a tool called `glow_run` lowers them into Rye (Grain's systems language) and runs the result.

You do not need to know Rye to write Glow. The tool handles that bridge for you.

## The five values

Glow's value model has five types, and nothing else:

| Type | What it holds | Example |
|---|---|---|
| **integer** (`@u32`) | a whole number from 0 to 4,294,967,295 | `42` |
| **wide integer** (`@u64`) | a whole number up to 18 quintillion | an epoch timestamp |
| **bool** | true or false | a comparison result |
| **text** (`@t`) | a bounded string of characters | `hello` |
| **list** | an ordered collection of values | a sequence of records |

Every value has a named size. There is no value in Glow that can grow without limit.

## Your first program

Create a file called `hello.glow` anywhere in the tree (the `glow/gen/` room is a fine place).
Write these two lines:

```
::  My first Glow program -- a bound with a ceiling of 10.
|-  10
```

The first line is a **comment**. In Glow, comments begin with `::` and run to the end of the
line.

The second line is a **bound-tick rune** (`|-`). It declares a bounded trap with a ceiling of
10. When it runs, it prints the number 10 -- the ceiling it was given.

## Running it

From the root of your Grain tree:

```
rishi/bin/rishi run tools/g/glow_run.rish hello.glow
```

You will see output that ends with:

```
10
EXIT:0
```

The `10` is your program's result. `EXIT:0` means it lowered and ran without error.

If you placed the file at `glow/gen/h/hello.glow`, the command is:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/h/hello.glow
```

## A program with a name

A bound-tick gives back one number. A **face-lit rune** (`=/`) lets you name a value and use
it later. Write a second file, `named.glow`:

```
::  A named value -- bind the name 'amount' to 5, then increment it.
/+  lib-core-arith
=/  amount  5
%-  inc  amount
```

Four lines, four ideas:

1. `::` -- a comment, as before.
2. `/+  lib-core-arith` -- import the arithmetic library so `inc` is available.
3. `=/  amount  5` -- bind the name `amount` to the integer `5`.
4. `%-  inc  amount` -- call the library function `inc` (increment) with `amount`.

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish named.glow
```

The result is `6` -- five, incremented by one.

## A program that takes input

A **bartis rune** (`|=`) creates a gate -- a function that takes a value from the outside.
The tree already has one at `glow/gen/g/gate-double-u32.glow`:

```
::  Thin bartis generator -- double call body; sample from Rishi argv.
|=  sample=@u32
%-  double  sample
```

This program expects one number as input. Run it with a sample:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/g/gate-double-u32.glow 7
```

The result is `14` -- seven, doubled.

Try it with other numbers:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/g/gate-double-u32.glow 100
```

The result is `200`.

Gate programs that take input live in `glow/gen/g/` and follow a naming convention the
runner expects. The fixture programs you write yourself -- bound-ticks, face-lits, and
library calls -- can use any name.

## The six standard operations

Glow's standard library provides six operations you can use right away. You have already met
`inc` and `double`. Here are all six in the arithmetic family:

| Operation | What it does | Example |
|---|---|---|
| `inc` | adds one | `inc 5` gives `6` |
| `dec` | subtracts one | `dec 5` gives `4` |
| `double` | multiplies by two | `double 7` gives `14` |
| `half` | divides by two (integer) | `half 7` gives `3` |
| `square` | multiplies by itself | `square 4` gives `16` |
| `negate` | flips sign (wrapping) | `negate 1` gives `4294967295` |

Each one takes a single `@u32` and hands back a single `@u32`. Every result fits the same
bounded type -- there is no surprise growth.

## The interactive REPL

Glow also has an interactive mode where you can type expressions and see results immediately.
The REPL understands parenthesized expressions:

```
(add 2 3)       :: gives 5
(sub 10 3)      :: gives 7
(mul 4 5)       :: gives 20
42               :: gives 42 (a bare number)
```

The REPL lives at `glow/glow_repl.rye` and is demonstrated in the Brushstroke interactive
window (Orbit 11 of this journey).

## Exercise: write a program that squares a number

You have everything you need. Create a file called `my-square.glow` in the `glow/gen/`
room (any letter subdirectory is fine):

```
::  Square 5 using the number library.
/+  lib-core-number
=/  amount  5
%-  square  amount
```

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/m/my-square.glow
```

If the result is `25`, you have written your second Glow program. Try changing the `5` to
another number and running it again.

## Where to go from here

- [Recursion in Glow](recursion-in-glow.md) -- how Glow handles repeated work with an explicit
  stack rather than hidden recursion.
- [Glow Meets the Screen](glow-meets-the-screen.md) -- how Glow drives a visible window through
  Brushstroke (Orbit 14 of this journey, coming next).
- The `glow/gen/` room holds 385 Glow programs, each a small example you can read and run.

---

*May the first program stay plain and glad, and may every one after it land as cleanly.*
