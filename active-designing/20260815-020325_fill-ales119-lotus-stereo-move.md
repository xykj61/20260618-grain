# Fill lotus-audio — Lotus's `stereo_move`, the drag gesture carried into stereo

**Stamp:** `20260815.020325` · **Voice:** Kyri · **Style:** Radiant
**Chapter:** Six-Chapter double-seat, Chapter C (Lotus · the creative suite) · **waymark** lotus-audio · **rung** lotus-audio
**Stands on:** [`../lotus/move.rye`](../lotus/move.rye) (lotus-audio — mono `move`) · [`../lotus/pan.rye`](../lotus/pan.rye) (lotus-audio — the `StereoClip`) · [`../lotus/stereo_cut.rye`](../lotus/stereo_cut.rye) (lotus-audio) · [`../lotus/stereo_crop.rye`](../lotus/stereo_crop.rye) (lotus-audio) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (lotus-audio — `EditError`)

---

## The crux, and why it is next

lotus-audio lifted `cut` (remove a span) and lotus-audio lifted `crop` (keep a span) into stereo. `move` — carry a span somewhere new — is the third and last of the destructive span family, and naming its stereo twin makes the family **stand whole**: on a master a keeper can now remove a span, keep only a span, or drag a span to a new beat, always both speakers in lockstep. Lila, it is the closing move that completes the arc lotus-audio–118 opened.

## The rule, stated once

`stereo_move(sc, start, count, dest)` relocates `[start, start+count)` to `dest` in **both** channels, running lotus-audio's proven mono `move` on each with the **same** `start`, `count`, and `dest`. Because `move` can fault only with `BadRange` (a span outside the samples, or a dest outside the removed timeline) and both channels enter equal-length, the three range checks are made **once** against the shared length up front — so once they pass, each mono move is pre-validated and no refusal lands between the two channel edits. It reuses lotus-audio's `EditError` whole; each channel's `move` carries its own bounded scratch buffer.

## The four laws

1. **THE STEREO MOVE LAW** — left equals mono `move(left, start, count, dest)`, right equals mono `move(right, start, count, dest)`, each byte for byte.
2. **THE BALANCE / INVARIANT LAW** — `left.len == right.len` after and both hold their starting length (move relocates, never resizes), proven forward and backward.
3. **THE INVERSE LAW** — `stereo_move(start, count, dest)` then `stereo_move(dest, count, start)` returns both channels to the original byte for byte.
4. **THE ATOMICITY / DEGENERATE LAW** — a refusal (a bad span, a dest past `len − count`) leaves both channels untouched and balanced; `count = 0` the identity on both, `dest = start` the identity.

## Honest scope

Software only, purely local — two bounded i16 `Clip`s relocated through the proven mono `move` (one bounded scratch buffer per channel), reading no byte past either channel's `len`. No real sample rate, no network, no keys, no funds, no device, no speaker. No custody gate touched.
