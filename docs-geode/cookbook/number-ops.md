# Number Operations -- square, half, negate

**Language:** EN - **Style:** Bhakta at the Door setting, with Radiant warmth (see `../../context/BHAKTA_STYLE.md`)
**Written:** `20261104.154100` - **Status:** Living recipe

---

The `lib-core-number` library gives you three operations: **square** (multiply a number
by itself), **half** (divide by two, rounding down), and **negate** (flip the sign in
the underlying representation).

## Squaring a number

```glow
/+  lib-core-number
=/  amount  7
%-  square  amount
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-number-square.glow
```

The output is `49`.

## Halving a number

```glow
/+  lib-core-number
=/  amount  10
%-  half  amount
```

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-number-half.glow
```

The output is `5`. For odd numbers, `half` rounds down -- `half 7` gives `3`.

## Negating

```glow
/+  lib-core-number
=/  amount  5
%-  negate  amount
```

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-number-negate.glow
```

Negate flips the value in the Nock representation. For small positive integers, the
result is the bitwise complement under the atom encoding.

## Combining libraries

You can import more than one library in the same program. A program that doubles and
then squares would import both `lib-core-arith` and `lib-core-number`, binding
intermediate results with `=/`.

---

*Square it, halve it, or flip it -- each one step and one value.*
