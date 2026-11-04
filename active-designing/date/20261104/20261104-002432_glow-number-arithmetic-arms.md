**Status:** Landed -- checkable
**Room:** checkable
**Style:** Gauge at the Field setting

# Glow Number Arithmetic Arms -- Orbit 8 of the Language Journey

**Stamp:** `20261104.002432`

## The reframe, and why it was necessary

The journey spec asked for `glow/stdlib/number.glow` with explicit-width arithmetic
(u32, u64), conversion, bounds checking, and named errors on overflow. Five pipeline
constraints make that unreachable today:

1. **Arms always return u32.** `emit_arm_methods` emits `pub fn name(sample: u32) u32`.
   A u64 return would need a signature change across the emit path.
2. **The expression system is Nock-native.** `expr.rye` knows seven kinds -- face,
   literal, cast_literal, lent_of, mix_of, jam_of, cue_of -- none of which is
   general addition, subtraction, multiplication, or division.
3. **Named errors need a return-type change.** Zig's error unions (`LowerError!u32`)
   require the caller to handle them, and the consumer desk pattern (`%-  gate  face`)
   has no error-handling syntax.
4. **Consumer desks are exactly 3 lines.** `lower_compose_lib.rye` line 202 hard-refuses
   anything else. Error handling would need at least a fourth line.
5. **Import resolution is positional.** The stem maps to `glow/gen/<first-letter>/<stem>.glow`.
   No stdlib path exists yet.

Rather than spending the orbit widening the pipeline (iteration, polymorphic return,
error unions), the orbit proves what CAN be proven: three new closed arithmetic arms
that expand the vocabulary beyond the original double/inc/dec.

## What was delivered

Three new closed arms in the number family:

| Arm | Semantics | Zig emit | Example: square(5) |
|---|---|---|---|
| **square** | sample times sample | `sample *% sample` | 25 |
| **half** | integer division by 2 | `sample >> 1` | 2 |
| **negate** | two's complement negation | `0 -% sample` | 4294967291 |

All three use wrapping arithmetic (`*%`, `-%`) or logical shift (`>>`), consistent
with the existing arms. No overflow trap, by design -- the pipeline's arithmetic is
u32 wrapping throughout, and negate(5) returning 4294967291 is the correct two's
complement answer.

## The four parallel pipeline edits

Adding a closed arm requires updating four functions that know arm names:

| Function | File | What it emits |
|---|---|---|
| `arm_body_sample` | `lower_core.rye` | Zig body for standalone mode (`sample` parameter) |
| `arm_body_payload` | `lower_core.rye` | Zig body for payload mode (`self.{face}` field access) |
| `arm_expect_closed` | `lower_core.rye` | Expected return value for library-side check |
| `closed_expect` | `lower_compose_lib.rye` | Expected return value for consumer-side check |

`square` in payload mode takes two format arguments (`self.{s} *% self.{s}`) rather than
one, which is the one structural difference from the existing arms.

## What the orbit teaches about the pipeline

The closed-arm path is a lookup table. Adding an arm means adding one row to each of
four tables and creating one library file and one consumer per arm. The path is
mechanical and bounded -- the orbit proves it scales to six closed arms with no
parser or lowerer changes.

The open-arm path (Orbit 7's lent, pack, unpack) parses expression bodies from source.
Together, the two orbits prove both paths through the full pipeline.

## What remains unreachable

- **Explicit u64 arithmetic** -- arms return u32 only
- **Named errors on overflow** -- no error-union return path in the emit
- **Conversion between widths** -- no cast kind in the expression system
- **Iteration** -- no loop kind in the expression system
- **Multi-argument operations** -- consumer desks pass one argument

Each of these wants a pipeline widening -- a new expression kind, a new return type,
or a new consumer syntax. Those are separate orbits, each earning their own design.
