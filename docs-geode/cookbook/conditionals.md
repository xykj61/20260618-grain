# Conditionals -- choosing between two paths

**Language:** EN - **Style:** Bhakta at the Door setting, with Radiant warmth (see `../../context/BHAKTA_STYLE.md`)
**Written:** `20261104.154300` - **Status:** Living recipe

---

A conditional in Glow uses the `?:` rune. It takes three parts: a test, a value when
the test is true, and a value when the test is false. Every conditional produces a
value -- there is no "if" without an "else."

## Greater-than check

```glow
?:  (gth tick 32)
  1
  0
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/i/if-gth.glow
```

`gth` is a built-in that returns true when the first value is greater than the second.
Here, if `tick` (the program's input counter) is greater than 32, the result is `1`;
otherwise `0`.

## Conditional with computation

```glow
?:  (gth tick 32)
  (mix root x)
  0
```

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/i/if-mix.glow
```

The true branch can be any expression. Here it calls `mix` (XOR) on `root` and `x`
when the condition holds, and returns `0` otherwise.

## Reading the shape

Every `?:` follows one pattern:

```
?:  <test>
  <true-value>
  <false-value>
```

- The test is always in parentheses when it calls a function: `(gth tick 32)`.
- Both branches must produce a value of the same kind.
- You can nest conditionals by placing another `?:` in either branch.

## What `gth` compares

`gth` compares two atoms as unsigned integers. Glow has no negative numbers at this
level -- every value is a natural number or a tree of natural numbers. So `gth 5 3`
is true, `gth 3 5` is false, and `gth 5 5` is false.

---

*One test, two paths, always a value.*
