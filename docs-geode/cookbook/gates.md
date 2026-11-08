# Gates -- functions that take input

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261104.154500` - **Status:** Living recipe

---

A **gate** is a function. The `|=` rune creates one. It names the input (called the
**sample**) and then computes a result from it.

## A gate that returns its input

```glow
|=  sample=amount-shape
sample
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/g/gate-amount.glow
```

This gate takes one value (`sample`) typed to `amount-shape` and returns it unchanged.
The simplest possible gate -- it proves the shape compiles and the value passes through.

## How gates connect to libraries

Every arm inside a library is a gate. When you write:

```glow
/+  lib-core-arith
=/  amount  5
%-  double  amount
```

The `%-` rune calls the `double` arm, which is itself a gate: it takes `amount` as its
sample and returns `amount` doubled.

## The bound tick -- the smallest generator

```glow
|- 32
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/b/bound-tick.glow
```

`|-` is a special form: it creates a generator with a bounded tick counter. The value
`32` sets the upper bound. This is the smallest complete Glow program -- one rune, one
number.

## Multi-arm cores

A core with multiple arms uses `|%`:

```glow
|%
++  double
++  inc
++  dec
--
```

Each `++` names an arm. `--` closes the core. This is how `lib-core-arith` is built.
Each arm is a gate the caller reaches with `%-`.

---

*A gate takes input and gives back a result. A core holds many gates under one roof.*
