# PATCHOULI account -- head-record parse split, and a held red

**Stamp:** `20261012.081818` - **Lane:** mantra/ (snapshot export) - **Status:** GREEN, one held red

## What landed

`mantra/snapshot_export.rye` `parse_head_record_content` stood at 76 lines, past the 70-line bound the
TAME tidy rule asks of a production function. The line scan moved into a private
`scan_head_record_lines` over a private `HeadRecordFields` struct, whose defaults carry the two
`'0'`-filled buffers the old locals set by hand. The parse keeps the invariant asserts, the early
`Truncated` return, the identity decode, and the return value. Behavior is unchanged: the same
refusals fire on the same inputs, in the same order.

## Measured before and after

| Reading | Before | After |
|---|---|---|
| `parse_head_record_content` | 76 lines | about 45 lines |
| `scan_head_record_lines` | -- | about 35 lines |
| Snapshot witnesses GREEN | 5 of 5 (wire, replay, horizon, projection, batch-count) | 6 of 6 (adds hosted) |

## Held red -- a dangling slice returned from the parse

`ContinuityFact.stamp` is a slice. Both the old and the new parse return
`continuity_stamp[0..len]`, which points into a local buffer that the function's own return value
outlives. `verify_head_record` reads only the digest, the epoch and the identity, so no witness
dereferences the stamp and nothing reds. The refactor keeps the shape exactly, and it does not fix
the shape here.

- **What went wrong:** a returned slice points at a stack local.
- **What caught it:** reading the function's return statement while splitting it.
- **What it taught:** a split that copies a struct by value does not move a buffer the struct points into.

The row is held, not booked. `construction/REDS.md` reads 65,532 of its 65,536 bytes, and the
ledger's own capacity scan reads `pin_deadlocked=1`, so no row can enter until Keaton rules on the
pin. The fix itself is a ruling for Keaton as well: the stamp either copies into a caller-owned
buffer, or the type takes a length and a buffer. Either changes a public struct.

## Why no claim was needed

The split edits one existing file and books no new instrument, so the claim rule's exemption for an
ordinary repair applies. No REDS row was taken off the ledger.

## Still open

The held `%840` red (legacy `sign` under `catch unreachable`, `tally/kumara.rye:36`) and its two
rulings are unchanged; see the PATCHOULI pointer on the card.
