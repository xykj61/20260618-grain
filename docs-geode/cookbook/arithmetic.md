# Arithmetic -- double, increment, decrement

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261104.154000` - **Status:** Living recipe

---

The `lib-core-arith` library gives you three operations on whole numbers: **double**,
**inc** (add one), and **dec** (subtract one). Each takes one value and returns one value.

## Doubling a number

Create a file called `double-five.glow`:

```glow
/+  lib-core-arith
=/  amount  5
%-  double  amount
```

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-arith-double.glow
```

The output is `10`.

**What each line does:**

- `/+  lib-core-arith` -- import the arithmetic library.
- `=/  amount  5` -- bind the name `amount` to the value `5`.
- `%-  double  amount` -- call the `double` arm with `amount` as input.

## Incrementing

```glow
/+  lib-core-arith
=/  amount  5
%-  inc  amount
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-arith-inc.glow
```

The output is `6`.

## Decrementing

```glow
/+  lib-core-arith
=/  amount  5
%-  dec  amount
```

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-arith-dec.glow
```

The output is `4`.

## What the library looks like inside

Open `glow/gen/l/lib-core-arith.glow`:

```glow
::  Multi-arm arithmetic library -- double, inc, dec.
::  All three arms are closed (computed by closed_expect).
|%
++  double
++  inc
++  dec
--
```

`|%` opens a multi-arm core, `++` names each arm, and `--` closes the core. The three
arms are compiled from this declaration into bounded Rye functions the runner calls.

---

*Three operations, each one step from where you started.*
