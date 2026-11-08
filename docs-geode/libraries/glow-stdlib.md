# Glow Standard Library Reference

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261104.154600` - **Status:** Living reference

---

This page lists every function in the Glow standard library. Each function lives inside
a multi-arm core (a `|%` block) that you import with `/+` and call with `%-`.

## How to use a library function

```glow
/+  lib-core-arith
=/  amount  5
%-  double  amount
```

1. `/+` imports the library by name.
2. `=/` binds a value to a name.
3. `%-` calls one arm of the library with your value.

## Arithmetic -- `lib-core-arith`

Source: `glow/gen/l/lib-core-arith.glow`

| Arm | Input | Output | What it does |
|-----|-------|--------|-------------|
| `double` | one atom | atom | Multiply by two |
| `inc` | one atom | atom | Add one |
| `dec` | one atom | atom | Subtract one (bounded at zero) |

All three arms are closed (computed by `closed_expect`).

## Number operations -- `lib-core-number`

Source: `glow/gen/l/lib-core-number.glow`

| Arm | Input | Output | What it does |
|-----|-------|--------|-------------|
| `square` | one atom | atom | Multiply the value by itself |
| `half` | one atom | atom | Divide by two, rounding down |
| `negate` | one atom | atom | Bitwise complement under Nock encoding |

All three arms are closed.

## Atom operations -- `lib-core-atom-ops`

Source: `glow/gen/l/lib-core-atom-ops.glow`

| Arm | Input | Output | What it does |
|-----|-------|--------|-------------|
| `lent` | one atom | atom | Count the bits needed to represent the value |
| `pack` | one atom | atom | Serialize with `jam` encoding |
| `unpack` | one atom | atom | Round-trip through `jam` then `cue` |

## Identity -- `lib-core-open`

Source: `glow/gen/l/lib-core-open.glow`

| Arm | Input | Output | What it does |
|-----|-------|--------|-------------|
| `id` | one atom | atom | Return the input unchanged |

## Single-arm libraries

These libraries each expose one arm. They exist as focused modules for programs that
need only one operation.

| Library | Arm | What it does |
|---------|-----|-------------|
| `lib-core-double` | `double` | Multiply by two |
| `lib-core-nest` | `pack` | Serialize with `jam` |
| `lib-core-cue-jam` | `unpack` | Round-trip `jam` then `cue` |

## REPL operations

The interactive REPL (`glow/repl_eval.rye`) provides six operations typed at the prompt:

| Operation | Arity | What it does |
|-----------|-------|-------------|
| `add` | binary | Add two atoms |
| `sub` | binary | Subtract (bounded at zero) |
| `mul` | binary | Multiply two atoms |
| `mix` | binary | XOR two atoms |
| `jam` | binary | Serialize (jam encoding) |
| `cue` | unary | Deserialize (cue decoding) |

Input is bounded at 256 characters (`max_input_len`). Named errors: `Overflow`,
`MalformedExpr`, `EmptyInput`, `UnknownOp`.

## Built-in runes

These are part of the language, available in every program without an import:

| Rune | Name | What it does |
|------|------|-------------|
| `\|-` | bound tick | Create a generator with a bounded counter |
| `=/` | face | Bind a name to a value |
| `=.` | mutate | Change what an existing name points to |
| `?:` | conditional | Choose between two values based on a test |
| `\|=` | gate | Create a function taking one input |
| `\|%` | core | Create a multi-arm core (a group of functions) |
| `++` | arm | Name one arm inside a core |
| `--` | close | End a core |
| `/+` | import | Load a library |
| `%-` | call arm | Call one arm of a library |
| `gth` | greater than | Compare two atoms (true if first is larger) |
| `mix` | XOR | Bitwise exclusive-or of two atoms |

## Bounds and safety

Every Glow program runs inside a bounded tick counter set by `|-`. The evaluator refuses
input past `max_input_len` (256 characters). Library arms are compiled as closed
functions -- their bounds are proven at compile time by `closed_expect`.

---

*One page, every function. The cookbook shows how to use them; this page shows what they are.*
