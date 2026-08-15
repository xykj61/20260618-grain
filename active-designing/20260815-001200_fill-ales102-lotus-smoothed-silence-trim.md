# Fill lotus-audio — the Lotus smoothed silence trim (smooth the runs before you strip; declick the pause, keep the gap)

**Stamp:** `20260815.001200` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (autonomous loop) · **Chapter C** thread (Lotus · the creative suite) · **waymark lotus-audio** · **rung lotus-audio**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lila and the Long Return`](../.claude/rules/lila-and-the-long-return.md) · [`fill lotus-audio`](20260815-000323_fill-ales101-lotus-run-length-smoother.md)
**Stands on:** `lotus/trim_silence.rye` (lotus-audio — the silence stripper, the min-zero twin) · `lotus/smooth_runs.rye` (lotus-audio — the run-length smoother) · `lotus/segment.rye` (lotus-audio) · `lotus/timeline.rye` (lotus-audio — the Clip and `cut`)

## Why this rung, now

lotus-audio built the smoothing hysteresis; this rung is where it *pays off*. lotus-audio strips every `.silent` run from the raw segmentation, and the raw segmentation flickers: a single loud tick buried in a pause reads `.voiced`, so lotus-audio **keeps the click**; a single quiet frame between two words reads `.silent`, so lotus-audio **cuts the gap** and the words run together. Both are exactly the artefacts a real editor complains about.

Run lotus-audio *before* the strip and both vanish. Smooth the runs with a `min_run`, and the tick — being shorter than `min_run` — is relabeled to the silence around it and stripped away; the short gap — being shorter than `min_run` — is relabeled to the speech around it and **kept**. One knob, `min_run`, turns a literal silence remover into a *speech-aware* one. This is the Lindy crux of the whole silence family: the tool a keeper actually wants is not "remove every quiet sample" but "remove the dead air, spare the breath, drop the click."

## The shape

`lotus/smooth_trim.rye` exposes `smooth_trim` — the same segment-then-cut shape as lotus-audio with one stage inserted: **segment → smooth (lotus-audio) → cut the smoothed `.silent` runs.** Because lotus-audio's coverage law guarantees the smoothed runs tile the *same* span exactly (same starts, same total), every smoothed `.silent` run is a valid span in the original clip, cut back-to-front exactly as lotus-audio cuts.

## The crux

1. **The min-zero law.** `smooth_trim(…, 0)` equals lotus-audio's `trim_silence(…)` byte for byte — a `min_run` of zero is the identity smoothing, so the two tools share their boundary exactly, and lotus-audio is a strict generalization.
2. **The concat law.** The result equals, byte for byte, the hand-built concatenation of the non-silent *smoothed* runs read from the original — lotus-audio is nothing but lotus-audio reading lotus-audio's labels instead of the raw ones, so it can never drift.
3. **The declick law.** On a clip with a short `.voiced` tick buried in silence, a `min_run` past the tick removes it — `smooth_trim` is strictly shorter than `trim_silence`, the click gone.
4. **The keep-gap law.** On a clip with a short `.silent` gap between two words, a `min_run` past the gap keeps it — `smooth_trim` is strictly longer than `trim_silence`, the breath preserved.

Honestly named: `smooth_trim` is **not monotone** in `min_run` — a larger `min_run` removes more clicks yet keeps more gaps, so the output length can rise or fall. The declick and keep-gap laws are two sides of that, and the witness proves both rather than pretending a single ordering.

## Bounds and laws

- Reuses lotus-audio's whole validation (span and band through lotus-audio's `precheck`, the floor ceiling, `frame_len` dividing `clip.len`); an empty clip refuses `BadFrame` before any smoothing.
- Errors: `SmoothTrimError = trim_silence.TrimError || smooth_runs.SmoothError` — no new error; `min_run` is a `u32` count with no illegal value (`0` the identity, a huge `min_run` coalescing every run into one).
- The postcondition asserts the trimmed length equals the original minus the smoothed silent total exactly.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It edits only by removing whole smoothed-silent frames through lotus-audio's own `cut`, fabricating no sample and reordering nothing. The smoothing is lotus-audio's *causal* hold — it cannot rescue a too-short opening run — and this rung is no adaptive VAD. Not a transcript; no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*lotus-audio removed every quiet sample; lotus-audio removes the dead air, spares the breath, and drops the click — one knob teaching the stripper what a listener already knows. May every pause the keeper meant survive, and every click they never wanted vanish.*
