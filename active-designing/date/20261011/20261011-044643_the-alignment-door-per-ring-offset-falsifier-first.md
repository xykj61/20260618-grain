# The alignment door on a per-ring offset, falsifiers written before the run

**Status:** Design -- falsifiers stamped `20261011.044643` and committed before any run; result appended below after the run
**Room:** research for understanding (scratch model; no witness binds it yet)
**Kin:** [the label shuffle](20261011-044005_the-alignment-door-label-shuffle-falsifier-first.md) - [the second hash constant](20261011-043036_the-alignment-door-second-hash-constant-falsifier-first.md) - [the hashed-index door](20261011-041450_the-alignment-door-hashed-index-falsifier-first.md) - [the N = 384 and 640 sawtooth](20261011-035855_the-disk-size-series-at-384-and-640-falsifier-first.md)

## What this tests

The label shuffle retired one door: a per-set permutation of the modulo index is a relabeling, so
it cannot change which lines share a set, and it reproduced the modulo sawtooth exactly. Its named
next door is a **per-ring offset** that changes the line-to-set partition itself:

    set = (line + off[ring]) % sets

where `ring` is the polar ring of the line and `off[ring]` is a seeded integer in `[0, sets)`. Two
lines that sit on different rings can now share a set or not, depending on their offsets. That is
what the earlier doors could not change.

The question is the same one the earlier doors asked: is the zig-zag in the polar-to-Cartesian
floor ratio across N caused by ring-to-set alignment? If the modulo index puts the start of every
ring into the same few sets, a random per-ring offset should break that alignment and flatten the
sawtooth.

This needs ring tags, which the captured trace does not carry. The construction, chosen here and
not tested against any other choice:

- **Line ring.** A line's ring is the ring of the polar cell at the line's first address,
  `L * LINE`. A line can straddle two rings in the unpadded layout, so this is a definition, not a
  measurement, and the falsifier R1 checks that it reproduces the baseline when the offsets are zero.
- **Offset draw.** For each set count `s`, `off[r]` comes from `random.Random(SEED + 1000 * s + r)`
  with `SEED = 1`, one draw per ring, reduced modulo `s`. One seed only, so the result carries a
  single-construction caveat in every reading.
- **Cartesian arm.** Unchanged. It has no rings, so the offset is applied to the polar arm only.

Scope: the scratch model only, 8 ways, LRU, line size 8, unpadded, 5 percent tolerance. No hardware,
no witness, and no claim about any real cache.

## Prior readings the falsifiers cite

| N | Arm | Cartesian floor (sets) | Polar floor (sets) | Ratio | Monotone violations | Source |
|---|---|---|---|---|---|---|
| 256 | modulo | 12.4 | 33.3 | 2.69 | 0 | `fc256_base_20261011.txt`, label-shuffle paper |
| 384 | modulo | 19.2 | 49.7 | 2.59 | 0 | `fc384_640_nopad_20261011.txt`, label-shuffle paper |
| 640 | modulo | -- | -- | 2.88 | 0 | sawtooth paper `20261011.035855` |

Under the modulo index the ratio spreads 0.29 across N = 256, 384 and 640 (2.59 to 2.88). That spread
is the sawtooth this door tests.

## Falsifiers, written before the run

- **R1 (identity).** With every `off[ring] = 0`, the ratio and the Cartesian and polar floors at
  N = 256 and N = 384 match the modulo table above to the printed precision (ratio within 0.01,
  floors exact). Reason: if zero offsets change a reading, the ring-tag construction is not the
  modulo baseline, and no offset result can be read.
- **R2 (Cartesian fixed).** At every N run, the Cartesian floor under the offset arm equals its
  modulo value. Reason: the offset touches only the polar arm. A moved Cartesian floor means a bug.
- **R3 (alignment flattens the sawtooth).** Across N = 256, 384 and 640 with seeded offsets, the
  spread of the ratio (max minus min) is at most 0.10. **Supports** the alignment reading. The
  falsifier **fires** if the spread is at least 0.29, which is the modulo spread: the offsets
  remove none of the zig-zag, and ring-to-set alignment is not its cause in this model. Between 0.10
  and 0.29 reads as inconclusive, and the paper says so rather than choosing a side.
- **R4 (penalty survives).** With offsets, the ratio stays at or above 2.0 at every N run. Reason:
  the headline claim is a polar penalty near three times. A fall below 2.0 at any N means the penalty
  depends on the alignment, which would also weaken the earlier claim. The falsifier **fires** on any
  reading below 2.0.
- **R5 (monotone curve).** The polar curve under offsets has zero monotone violations at every N run.
  The second hash constant broke this, with 14 to 23 violations. A per-ring offset is a partition
  change of the same kind, so the same check applies. Any violation **fires** the falsifier, and the
  paper reports the count rather than reading it as noise.

## Ordering

R1 is run first. If R1 fails, the run stops and the paper says so; no offset result is read. Then
R2 to R5 are read from the same run. The falsifiers are not edited after the run; a reading that
contradicts one is reported as a fire, not as a sign the falsifier was mis-set.

---

Appended after the run, below this line. The five falsifiers above are not edited.
