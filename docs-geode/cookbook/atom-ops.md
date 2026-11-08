# Atom Operations -- length, pack, unpack

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261104.154200` - **Status:** Living recipe

---

The `lib-core-atom-ops` library works with atoms at a lower level: **lent** measures
how many bits a value takes, **pack** serializes a value into a single atom (using Nock's
`jam` encoding), and **unpack** reverses it (using Nock's `cue` decoding).

## Measuring length

```glow
/+  lib-core-atom-ops
=/  amount  255
%-  lent  amount
```

Run the existing example:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-atom-ops-lent.glow
```

`lent` returns the number of bits needed to represent the value. For `255` (eight bits
all set), the result is `8`.

## Packing a value

```glow
/+  lib-core-atom-ops
=/  amount  42
%-  pack  amount
```

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-atom-ops-pack.glow
```

`pack` applies Nock's `jam` encoding: it serializes the value into a compact binary
atom. The exact output depends on the input's structure.

## Unpacking a value

```glow
/+  lib-core-atom-ops
=/  amount  42
%-  unpack  amount
```

Run it:

```
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/u/use-lib-atom-ops-unpack.glow
```

`unpack` applies `cue` to `jam` of the input, round-tripping through the serialization.
For a simple atom, `unpack` returns the original value.

## When to use these

- **lent** -- when you need to know how large a value is in bits, for bounds checking
  or allocation.
- **pack** -- when you need to serialize a value for storage or transmission.
- **unpack** -- when you need to restore a value from its serialized form.

---

*Measure it, pack it, bring it back.*
