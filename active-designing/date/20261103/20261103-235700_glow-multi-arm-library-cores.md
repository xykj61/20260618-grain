# Multi-arm library cores -- what the pipeline holds and what it reaches for

**Stamp:** `20261103.235700` - **Status:** Landed - **Room:** checkable
**Orbit:** 7 of the glow-language journey (`tablecloth/20261103-184811_glow-language-journey/CHECKLIST.md`)
**Witness:** `tools/g/glow_multi_arm_witness.rish` -- GREEN on metal, 2 libraries, 6 consumers

## What the orbit asked for

The journey spec called for Python-style string and list operations: join, split, length, map,
filter, fold, take, drop. Eight standard library arms that a newcomer from Python or JavaScript
would reach for first.

## What the pipeline actually holds

Five constraints bound what an orbit can deliver today, each discovered by reading the code
rather than assumed from the spec.

1. **Import resolution is positional.** The stem in `/+  lib-core-open` maps to
   `glow/gen/l/lib-core-open.glow` by first letter. A library lives where the resolver looks.

2. **A consumer desk is exactly three lines.** `lower_compose_lib.rye` line 202 returns an error
   when the input is not exactly three lines: import, face assignment, one-arg call. No second
   call, no chaining, no intermediate bindings.

3. **Every arm returns `u32`.** `emit_arm_methods` in `lower_core.rye` emits
   `pub fn name(sample: u32) u32` for every arm. The pipeline has no polymorphic return, no
   compound type, no list.

4. **The expression system is Nock-native, not general arithmetic.** Seven kinds:
   `face`, `literal`, `cast_literal`, `lent_of`, `mix_of`, `jam_of`, `cue_of` -- identity,
   constants, length, XOR, pack (shift+OR), unpack (mask). No addition, subtraction, multiply,
   compare, or conditional. These are the primitives Nock's own arithmetic reduces to.

5. **`closed_expect` knows three names.** `double`, `inc`, `dec` -- each a closed arm whose
   output is computed from the sample without an expression body. Adding a fourth closed arm
   name means adding a case to `closed_expect` in `lower_compose_lib.rye`.

## What the orbit delivered instead

Map the spec's eight operations onto what the expression system reaches:

| Spec operation | Pipeline equivalent | Arm | Expression kind |
|---|---|---|---|
| length | atom length (demo) | `lent` | `lent_of` |
| join / pack | bit-pack two atoms | `pack` | `jam_of` |
| split / unpack | bit-unpack to original | `unpack` | `cue_of` |
| double | closed arithmetic | `double` | closed (no body) |
| increment | closed arithmetic | `inc` | closed (no body) |
| decrement | closed arithmetic | `dec` | closed (no body) |
| map / filter / fold | **deferred** -- requires iteration | -- | -- |
| take / drop | **deferred** -- requires slicing | -- | -- |

Two multi-arm library cores, each exercising the parser's `max_arms = 3` ceiling:

- **`lib-core-arith`** -- three closed arms (double, inc, dec). All three dispatch through
  `closed_expect` and return computed values with no expression body.
- **`lib-core-atom-ops`** -- three open arms (lent, pack, unpack). Each carries an expression
  body that the lowerer emits as Zig. `lent` returns a constant (the demo length), `pack`
  shifts and ORs, `unpack` masks.

Six consumer desk programs, one per arm per library, each exactly three lines. Every consumer
imports its library through the `/+` path, binds a face, and calls one arm.

## The fix that made it work

`lower_core.rye` line 108 emitted `return {d};` for the `.lent_of` expression kind in library
mode (`with_main=false`). The generated Zig function `pub fn lent(sample: u32) u32 { return 5; }`
left `sample` unused, and Zig refuses unused function parameters. The fix emits
`_ = sample; return {d};` (or `_ = self.{s};` for payload structs), suppressing the unused
parameter error while keeping the demo constant semantics. The error only manifested in library
mode because in standalone mode (`with_main=true`) the compiler saw `sample` used in the check
expression that calls the arm.

## What the orbit proves

The parser (`rune_core.rye`) handles up to three arms per `|%` core. The lowerer
(`lower_core.rye`) emits each arm as a method on a Zig struct. The compose path
(`lower_compose_lib.rye`) resolves any arm by name against the core's spec and dispatches to
`closed_expect` or `open_expect` as the arm's kind requires. The witness runs all eight programs
through the full pipeline -- parse, lower, emit Rye, compile Zig, run -- and asserts GREEN on
each.

## What reaches further

Iteration (map, filter, fold) and slicing (take, drop) need a loop construct the expression
system does not carry. Adding one is a language extension -- a new `Kind` in `expr.rye`, a new
emitter in `lower_core.rye`, a new expect in `lower_compose_lib.rye` -- rather than a
configuration of what stands. That work belongs to a later orbit, where the expression system
itself grows.
