# Fill lotus-audio — Lotus's reverberant tone shelf (the reverb's two-band EQ)

**Stamp:** `20260815.112557` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Chapter:** the Six-Chapter double-seat, Chapter C thread (Lotus · the creative suite) · waymark **lotus-audio** · rung **lotus-audio**
**Kin:** [`20260815-111333_fill-ales203-lotus-stereo-reverb-gate-env.md`](20260815-111333_fill-ales203-lotus-stereo-reverb-gate-env.md) · [`20260815-104206_fill-ales198-lotus-reverb-tone.md`](20260815-104206_fill-ales198-lotus-reverb-tone.md) · [`../.claude/rules/lila-and-the-long-return.md`](../.claude/rules/lila-and-the-long-return.md)

---

## The crux this round takes

lotus-audio closed the gate axis whole — mono and stereo, static and shaped. The gate lives; the axis that stays thin is **tone**. lotus-audio gave the reverberant tail a **darkness knob** — a plain first-order high-cut, one direction only: the tail could be darkened, never brightened, and the low wash could never be lifted or trimmed. Yet the tone control a keeper actually turns on a reverb is a proper **shelving EQ** — two knobs, bass and treble, each boosting *or* cutting its own band of the tail independently, so the wash sits warm and dark, bright and airy, or thinned of mud, from one span. Every real reverb carries this (the "reverb EQ", the low/high shelves on a plate).

This rung is that shelf — Lila within the tone axis (the richer control the darkness knob was the first taste of), and a clean composition of proven stages: lotus-audio's named-room wet, then lotus-audio's two-band shelf over the span. It opens the mono/stereo pair whose stereo twin follows next.

## The shape — reverberate the span wet, then tone-shelve the tail

`reverb_shelf(clip, clk, room, start_ms, count_ms, coeff_num, coeff_den, bass_num, bass_den, treble_num, treble_den)`:

1. Assert the clock; **pre-check the shelf setting** — the split coefficient in (0, 1], neither band denominator zero, the span in-bounds — with lotus-audio's own `precheck`, **before any write**, so a bad setting leaves the clip *dry* (the atomicity crux).
2. Convert the span through lotus-audio's clock (`DurationTooLong`) and range-check it (`BadRange`) before any write — the same conversion `reverb_preset` uses.
3. Run lotus-audio's `reverb_preset` over the span — the **wet**, in place, unchanged.
4. Tone-shelve the wet span through lotus-audio's `shelf` at the same coefficient and gains — the low band scaled by bass, the high band by treble, summed in the wide domain and saturated once.

To keep one law for "a legal shelf," this round adds a `pub precheck` to `shelf.rye` (mirroring `tone.precheck`) and refactors `shelf` to call it — additive, lotus-audio's witness re-runs green.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`bass == unity AND treble == unity`)** — equals lotus-audio's `reverb_preset` over the span, byte for byte, at any coefficient. A flat EQ is the un-shelved reverb.
2. **IT EQUALS ITS COMPOSITION** — for a real shelf (bass 2/1, treble 1/2), equals `reverb_preset` then `shelf.shelf` byte for byte; and the shelved tail differs from its wet.
3. **THE TREBLE CUT DARKENS** — a treble-cut tail's high-frequency roughness (summed first-difference) is strictly less than the un-shelved wet's — lotus-audio's direction, now one of two.
4. **THE BASS BOOST LIFTS** — a bass-boost tail's total absolute energy is strictly greater than the wet's — the low wash rises, the colour the high-cut could never reach.
5. **SILENCE STAYS SILENCE.**
6. **THE FAULTS FORWARD, ATOMIC** — an illegal coefficient `BadCoeff`, a zero band denominator `BadGain`, each with the clip **untouched (still dry)**; a span past the clip `DurationTooLong`; an out-of-range span `BadRange`; each by name before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `Clip`, a validated clock, and lotus-audio's fixed banks, siloed to `lotus/`. No new audio arithmetic — the shelf is lotus-audio's proven two-band shelf over the proven wet, each band scaled in the wide i64 domain and saturated once. A **wet-tail** shelf; the split is a fraction per sample index (a crossover in hertz is a later rung, as `reverb_ms` followed the index-named reverb), so it means the same split at any sample rate. A true in-loop damped-comb tone (a filter inside each comb's feedback) stays the richer horizon lotus-audio already named. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The **stereo** tone shelf — the same two-band shelf over both channels of a `StereoClip`, one shared bass, treble, and split, the image held — is the thin twin (lotus-audio). Then the tone axis stands whole in both its plain-darkness and full-shelf forms, mono and stereo, and a fresh reverb axis opens: **width** (the stereo spread of the tail), **freeze** (an infinite-hold sustain), or **early/late balance**.
