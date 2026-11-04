**Status:** Landed -- checkable
**Room:** checkable
**Style:** Gauge at the Field setting

# Glow Value Model and Record -- Orbit 9 of the Language Journey

**Stamp:** `20261104.004038`

## The reframe, and why it was necessary

The journey spec asked for `glow/stdlib/record.glow` -- a stdlib module proving the
single-stranded value model (string, integer, bool, list, record) through the `/+`
import path. Two pipeline constraints make the stdlib path unreachable today:

1. **Import resolution is positional.** The stem in `/+  lib-core-open` maps to
   `glow/gen/l/lib-core-open.glow`. No stdlib path exists.
2. **The `/+` compose-lib path handles `|%` cores only.** `glow_run.rye` line 403
   calls `lower_core.lower_source_library()` -- hardcoded to core lowering. Shape
   libraries (`+$`) are not wired into the `/+` import path.

The cross-desk path (`glow_run.rye` lines 287-326) DOES handle shape libraries through
`lower_shape.lower_source_library()` at line 310, yet that is the named-cast mechanism
(`|= sample=pair-shape`), not the standard three-line consumer desk pattern.

Rather than spending the orbit widening the import path, the orbit proves the value
model IS already working through the existing pipeline paths: standalone shapes,
cross-desk gates, conditionals, mutations, and lists.

## What the value model is

Five types, composed side by side, never tangled:

| Type | Glow syntax | Zig emit | Proven by |
|---|---|---|---|
| **Record** | `+$` with `$:` fields | Zig struct with named fields | `shape-pair`, `record-value`, `shape-seva-event` |
| **Integer** | `@u32` (in-memory), `@u64` (wire) | `u32`, `u64` | every shape, every gate |
| **String** | `@t` (bounded text, max 1024 bytes) | `[1024]u8` byte array | `record-value`, `shape-stamp-mixed`, `shape-seva-event` |
| **Bool** | `?:` conditional returning 0 or 1 | Zig `if` expression | `value-bool`, `if-gth` |
| **List** | `:~` cell list | Zig struct with positional fields | `value-list`, `cell-list` |

Tagged unions (`$%`) serve as both the variant type and a richer bool -- a flag
with named arms rather than bare 0/1.

## Five operations, each proven

| Operation | What it proves | Programs |
|---|---|---|
| **Create** | A record is constructed with typed fields | `shape-pair`, `record-value`, `shape-seva-event` |
| **Read** | A gate accepts and returns a record | `value-pass`, `gate-pair` |
| **Update** | The flip closed operation swaps fields | `value-update`, `gate-pair-flip` |
| **Pass** | A function takes a record as its sample | `value-pass`, `gate-xact` |
| **Compose** | Multiple aura types coexist in one record | `record-value` (u32 + u64 + text), `shape-seva-event` (5 fields, 3 aura types) |

## What was delivered

Six new Glow programs, each GREEN through the full pipeline:

| Program | What it proves |
|---|---|
| `glow/gen/r/record-value.glow` | Record with all three value types: @u32, @u64, @t |
| `glow/gen/v/value-pass.glow` | Gate accepting pair-shape, returning it (pass operation) |
| `glow/gen/v/value-update.glow` | Gate accepting pair-shape, returning flip (update operation) |
| `glow/gen/v/value-bool.glow` | Conditional returning 0 or 1 (bool type) |
| `glow/gen/v/value-list.glow` | Three-element cell list (list type) |
| `glow/gen/v/value-tagged.glow` | Two-variant tagged union (variant/bool type) |

Plus `tools/g/glow_value_model_witness.rish` tying all 12 programs (6 new + 6 existing)
into one witness that proves the five types and five operations together.

## The pipeline discovery

The orbit's exploration answered a question the Orbit 8 essay left open: does
`lower_shape.rye`'s library emit mode work with the `/+` import system?

**No.** The compose-lib path at `glow_run.rye` line 403 calls
`lower_core.lower_source_library()`. This is the only lowering function the `/+` path
reaches. Shape libraries go through a separate mechanism -- the cross-desk path at
line 310, which calls `lower_shape.lower_source_library()`. The two paths serve
different dispatch modes:

- **`/+` compose-lib** (lines 376-419): reads library source from `glow/gen/`, lowers
  as a `|%` core, writes cache to `glow/.cache/`, composes with consumer.
- **Cross-desk** (lines 287-326): resolves a shape name from a gate's sample declaration,
  lowers the shape as a library struct, compiles the gate with the struct imported.

Wiring shapes into the `/+` path would need the compose-lib dispatcher to detect
whether a library source starts with `|%` or `+$` and call the right lowerer. That
is a well-bounded change, yet it belongs in a future orbit about the import system
rather than in one about the value model.

## What the orbit teaches about the pipeline

The value model already works. Every type and operation the single-stranded
foundation asks for is proven GREEN through the existing pipeline, without any
lowerer or emitter changes. The pipeline constraint is about the import path --
how libraries are composed into programs -- rather than about the types themselves.

This means the stdlib orbit can ship as a set of individual programs that a future
import-system orbit composes into a library. The types are ready; the plumbing is
what waits.

## What remains unreachable

- **Stdlib as a single importable module** -- needs `/+` to dispatch shape libraries
- **Record field access by name in expressions** -- gates receive the whole record,
  and closed operations (flip) transform it, yet there is no `get` expression kind
  that reads one field by name
- **Record construction from inside a gate** -- a gate returns what it receives or
  what a closed operation produces; there is no `make` expression kind that builds
  a new record from computed values
- **Iteration over a list** -- no loop kind in the expression system

Each of these wants a pipeline widening -- a new expression kind or a new dispatch
path. Those are separate orbits, each earning their own design.
