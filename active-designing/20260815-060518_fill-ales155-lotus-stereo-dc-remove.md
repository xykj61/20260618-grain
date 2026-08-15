# Fill lotus-audio — Lotus's stereo_dc_remove: the DC-offset remover carried into stereo, two independent means, the image-preserving translation

**Stamp:** `20260815.060518` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Chapter:** the Six-Chapter double-seat, Chapter C thread (Lotus · the creative suite) · **Waymark:** lotus-audio · **Rung:** lotus-audio
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-060518_fill-ales154-lotus-stereo-smooth-trim.md`](20260815-060518_fill-ales154-lotus-stereo-smooth-trim.md)

---

## The next crux, honestly chosen

The silence/analysis family is now whole in stereo (lotus-audio–154). Turning back to the still-unlifted processing rungs, `dc_remove` (lotus-audio) and `dc_block` (lotus-audio) are the highest mono rungs with no stereo twin — and DC removal is the tool every chain reaches for right after a nonlinearity, so it is the crux that lets the whole even-harmonic drive family (rectifier, tube, crush) be used honestly in stereo. In ascending order the block-mean remover (lotus-audio) comes first and is the foundation of the one-pole blocker (lotus-audio), so this rung takes it.

## The shape — the image-preserving counterpoint to the rectifier

`stereo_dc_remove(sc, start, count)` is the length-preserving per-channel lift, the same corner lotus-audio (`stereo_rectify`) took: validate the span once against the shared length, then run lotus-audio's proven mono `dc_remove` on each channel over `[start, start+count)`. The stereo insight is that the two channels carry **their own offsets** — an even map or asymmetric clip biases them by different amounts — so each channel removes its **own** mean, independently. `StereoDcError = dc_remove.DcError` (BadRange) reused whole; the lift adds no fault.

Where the rectifier is an even map that **collapses** an out-of-phase master to mono, DC removal is a per-channel **pure translation**, and a translation preserves every sample-to-sample difference — so it **preserves** the image. This rung is the honest opposite pole of lotus-audio, and the two prove the same field from two sides.

## The laws proven

- **The stereo DC-remove law (the crux):** each channel equals lotus-audio's mono `dc_remove` over the same span byte for byte — proven against the mono remover directly, a left biased +1100 and a right biased −500.
- **The independent-offset law (the stereo crux):** two channels carrying different offsets each land under one LSB independently — the left's offset never leaking into the right, a zero-mean channel unchanged while its partner is corrected.
- **The image-preserve law:** an out-of-phase master (right = −left AC) riding a common-mode +1000 offset returns **still exactly out of phase** — the antisymmetry kept, the honest opposite of the rectifier's collapse; a both-zero-mean master unchanged exactly; the map idempotent where nothing saturates.
- **The composition law:** it undoes the stereo rectifier's per-channel offset — a symmetric master rectified through lotus-audio rides a positive DC on both channels (left 18000, right 12000), and `stereo_dc_remove` restores a near-zero mean on each.
- **The balance / atomicity / degenerate law:** `left.len == right.len` after (values only); a refusal leaves both channels byte for byte untouched and still balanced; `count = 0` and the empty span are the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips DC-removed through the proven mono remover — a two-pass block statistic per channel (sum in i64 so the accumulation never overflows, then subtract, one saturate per sample), memoryless, no carried state, never a length. The "DC" is the arithmetic mean of the block, the zero-frequency component by definition, not a claim about any hardware highpass; the one-pole IIR DC blocker with carried state (lotus-audio) is the next rung. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
