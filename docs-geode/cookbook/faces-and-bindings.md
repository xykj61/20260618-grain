# Faces and Bindings -- naming values

**Language:** EN - **Style:** Bhakta at the Door setting, with Radiant warmth (see `../../context/BHAKTA_STYLE.md`)
**Written:** `20261104.154400` - **Status:** Living recipe

---

A **face** gives a name to a value. The `=/` rune binds a name so that later lines can
refer to it. This is how you build up a computation step by step.

## A simple binding

```glow
=/  amount  5
amount
```

The first line binds the name `amount` to the value `5`. The second line returns it.

## Multiple bindings

```glow
=/  from  5
=/  amount  3
amount
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/m/multi-face.glow
```

Each `=/` adds one name. Later bindings can use earlier names:

```glow
=/  width  10
=/  height  5
=/  area  (mul width height)
area
```

Names are visible to everything that follows them.

## Typed bindings

A face can carry a type annotation:

```glow
=/  next-root=@u32  42
next-root
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/f/face-root.glow
```

`=@u32` tells the compiler this value is a 32-bit unsigned atom. The program will
refuse at compile time if the value does not fit.

## Bindings with computed values

A face can bind the result of a function call:

```glow
=/  n=@u32  (lent records)
n
```

```glow
=/  next-root=@u32  (mix root x)
next-root
```

The right side of `=/` can be any expression -- a literal, a function call, or a
nested computation.

## Mutation with `=.`

Once a name exists, `=.` changes what it points to:

```glow
=.  root  42
root
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/m/mutate-root.glow
```

`=.` replaces the value of an existing face. The name stays the same; the value
changes. This is the only way to update a binding in Glow.

---

*Name it, use it, and when you need to -- change it.*
