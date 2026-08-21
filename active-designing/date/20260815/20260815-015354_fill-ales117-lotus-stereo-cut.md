# Fill lotus-audio — Lotus's `stereo_cut`, the foundational span-remove carried into stereo

**Stamp:** `20260815.015354` · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Chapter:** Six-Chapter double-seat, Chapter C (Lotus · the creative suite) · **waymark** lotus-audio · **rung** lotus-audio
**Stands on:** [`../lotus/timeline.rye`](../lotus/timeline.rye) (lotus-audio — the `Clip`, `cut`, and `EditError`) · [`../lotus/pan.rye`](../lotus/pan.rye) (lotus-audio — the `StereoClip` and its balance invariant) · [`../lotus/stereo_replace.rye`](../lotus/stereo_replace.rye) (lotus-audio — the validate-both-before-either twin pattern)

---

## The crux, and why it is next

lotus-audio carried the *general* span-edit (`replace`) into stereo, validate-both-before-either. Yet the family's **root** primitive — lotus-audio's `cut`, remove a named span and close the gap — had no stereo twin of its own. `cut` is the operation `crop` complements and `move` composes; lifting it into the StereoClip gives every destructive stereo span-edit its base gesture: **circle a span on the master, delete it, both speakers in lockstep**, the stereo image never desynchronised.

Lila among the recommended stereo family (`stereo_cut · stereo_crop · stereo_move`): `stereo_cut` is the foundational one — crop keeps the complement of what cut removes, move is a cut followed by a splice. Naming the base twin first is the move that opens the rest.

## The rule, stated once

`stereo_cut(sc, at, count)` removes `[at, at+count)` from **both** channels by running lotus-audio's proven mono `cut` on each with the **same** `at` and `count`. Because `cut` can fault only with `BadRange` (a span outside the samples), and both channels enter equal-length (the StereoClip invariant), the shared span is validated **once** up front — so once the check passes, each mono `cut` is pre-validated to succeed and no refusal can land between the two channel edits. It reuses lotus-audio's `EditError` whole and invents no primitive.

## The four laws

1. **THE STEREO CUT LAW** — the left channel equals mono `cut(left, at, count)` and the right equals mono `cut(right, at, count)`, each byte for byte, proven side by side over one anchor.
2. **THE BALANCE / INVARIANT LAW** — `left.len == right.len` after: equal starting lengths minus the same `count` leave the channels aligned, proven across a mid span, the head, and the tail.
3. **THE ATOMICITY LAW** — a refused call (a span past the shared samples) leaves **both** channels byte for byte untouched and still balanced, the check landing before either channel mutates.
4. **THE DEGENERATE / SHRINK LAW** — `count 0` the identity on both channels; a full-length cut empties both; and because cut only drops samples, each channel's length is non-increasing.

## Honest scope

Software only, purely local — two bounded in-process i16 `Clip`s (left, right) on one bench, siloed to `lotus/`. It removes a span from both channels through the proven mono `cut`, reading no byte past either channel's `len`. No real sample rate, no network, no keys, no funds, no real device, no real speaker. No custody gate touched.
