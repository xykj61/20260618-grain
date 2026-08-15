# Fill lotus-audio — Lotus's stereo_expand_env: the attack/release downward expander carried into stereo, the linked envelope driving one linked widening over time — the stereo time-varying dynamics quartet made whole

**Stamp:** `20260815.070944` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Chapter:** the Six-Chapter double-seat, Chapter C thread (Lotus · the creative suite) · **Waymark:** lotus-audio · **Rung:** lotus-audio
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-070439_fill-ales163-lotus-stereo-limit-env.md`](20260815-070439_fill-ales163-lotus-stereo-limit-env.md)

---

## The next crux, honestly chosen

lotus-audio and lotus-audio carried the gate and the limiter into stereo over time; this rung takes the last of the three mechanical siblings lotus-audio opened — the **attack/release downward expander carried into stereo** — and with it the stereo time-varying dynamics quartet (compress · gate · limit · expand, each over one linked envelope) is whole, exactly as the memoryless quartet closed at lotus-audio.

The mono family crossed this seam at lotus-audio, spending lotus-audio's envelope to drive lotus-audio's deepened floor so a note's tail falls smoothly rather than being wrenched down. Stereo spends lotus-audio's linked envelope to drive lotus-audio's linked widening: one detector, one gain, the quiet pushed down together so the image never tears as the space between phrases opens.

## The shape — one linked envelope, one widening, over time

`stereo_expand_env(sc, start, count, threshold, ratio, attack, release)` validates threshold, ratio, both coefficients, and the span once, then per pair:

- **Advance the one shared envelope** toward the linked peak `max(|left|, |right|)` clamped to the rail, by lotus-audio's `stereo_env_step` (attack while rising, release while falling — the proven lotus-audio step, reused whole).
- **Envelope at or above the threshold** → the expander is idle, both pass byte for byte (continuous at the threshold).
- **Envelope below the threshold** → the envelope's deficit `threshold − e` is widened by the ratio, `exp = max(0, threshold − deficit·num/den)` (exactly lotus-audio's/lotus-audio's deepened floor, computed on the linked *envelope* not the bare sample), and the **one** gain `exp/e ∈ [0, 1)` is applied to **both** raw samples — the linked widening, driven by the linked, time-smoothed detector. A shared envelope of exactly zero arises only when both channels are silent, so no divide by zero and nothing to expand.

`StereoExpandEnvError = expand_env.ExpandEnvError` (BadThreshold, BadRatio, BadCoeff, BadRange) reused whole. Carried-state (`stereo_expand_follow_carry`) and from-silence (`stereo_expand_follow`) forms, one implementation, so they cannot drift.

## The laws proven

- **The instantaneous law (the crux link):** unit attack and unit release make the linked envelope the instantaneous linked peak every sample, so `stereo_expand_env` equals lotus-audio's memoryless `stereo_expand` byte for byte on both channels — the time-varying rung's zero-smoothing limit is exactly the memoryless rung already proven.
- **The linked-gain-over-time law:** a left-always-peak master has `left'` equal to lotus-audio's mono `expand_env(left)` byte for byte (the shared envelope equals the mono envelope of the peak-holding channel), the right scaled by the identical fraction `exp/e` — while the independent per-channel `expand_env` genuinely differs (the image-tearing bug this prevents).
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair returns still out of phase, no magnitude expands, no sign flips.
- **The knob laws:** unit ratio is the identity everywhere on both; a slower release eases the widening longer (a quiet tail after a loud passage is attenuated less, monotone in the release knob).
- **The carry law:** a span expanded in two pieces (the second continuing the first's ending shared envelope) equals expanding the whole once, byte for byte on both — the release easing across the call boundary.
- **The at-threshold / silence / balance / atomicity / degenerate law:** a master whose linked envelope never falls below the threshold passes byte for byte on both; silence stays silence; `left.len == right.len` after; a bad threshold, sub-unity or zero-denominator ratio, illegal coefficient, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope — one linked-peak comparison and at most one widen and one multiply-then-divide for the gain per channel, all in i64 (`|sample|·exp ≤ 32768·32767` never overflows), the gain `exp/e ∈ [0, 1)` so every scaled magnitude is at most its input's and fits i16. The threshold is a magnitude in sample units, the ratio a plain fraction, the attack and release fractions per sample index rather than milliseconds against a clock. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
