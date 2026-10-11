# The alignment door on a set-spread stagger, falsifiers written before the run

**Status:** Design -- falsifiers stamped `20261011.052411` and committed before any run; result appended below after the run
**Room:** research for understanding (a scratch model, no hardware, no witness)
**Kin:** [the structured stagger](20261011-051108_the-alignment-door-structured-stagger-falsifier-first.md) - [the per-ring offset](20261011-044643_the-alignment-door-per-ring-offset-falsifier-first.md) - [the label shuffle](20261011-044005_the-alignment-door-label-shuffle-falsifier-first.md)

## What this tests

The structured stagger paper named two next doors and did not choose between them. One was a stop on the
ring-start family. The other was a stagger whose offset depends on the set count rather than on a
constant, so the rings spread evenly across the set index:

    off[r] = (r * sets) // rings        (each value lies in [0, sets))

The constant stagger `off[r] = r * K mod sets` gave a polar floor within 2 to 3 percent of the modulo
index at K = 2 and K = 3. This door asks whether spreading the rings across the whole set range, rather
than stepping them by a fixed amount, changes that. Chosen here, and not tested against any other
construction: an even spread is the one stagger whose offsets do not repeat in a short cycle.

The question stays the one the earlier doors asked: is the zig-zag in the polar-to-Cartesian ratio across
N caused by ring-to-set alignment? The same caveats apply as before: one ring-of-line definition, one
model (8 ways, LRU, line size 8, unpadded, 5 percent tolerance), and no claim about any real cache.

## Prior readings the falsifiers cite

| N | Arm | Cartesian floor (sets) | Polar floor (sets) | Ratio | Polar monotone | Source |
|---|---|---|---|---|---|---|
| 256 | modulo | 12.4 | 33.3 | 2.69 | 0 | per-ring offset paper, R1 |
| 384 | modulo | 19.2 | 49.7 | 2.59 | 0 | per-ring offset paper, R1 |
| 640 | modulo | 28.8 | 83.0 | 2.88 | 0 | per-ring offset paper, R1 |

Under the modulo index the ratio spreads 0.29 across N = 256, 384 and 640. Under the constant stagger,
K = 2 and K = 3, the spread fell to 0.24 and 0.23.

## Falsifiers, written before the run

- **T1 (bounds).** Every offset lies in `[0, sets)` at every N and every set count run. Reason: the
  set-spread offset is a scaled index, and an offset outside its range would fold the ring onto the
  wrong set silently. The falsifier **fires** on any offset outside the range.
- **T2 (Cartesian fixed).** At every N run, the Cartesian floor equals its modulo value (12.4, 19.2 and
  28.8). Reason: the offset touches the polar arm only. A moved Cartesian floor means a bug.
- **T3 (spread).** Across N = 256, 384 and 640, the spread of the ratio (max minus min) is at most 0.10.
  **Supports** the alignment reading. The falsifier **fires** if the spread is at least 0.29, the modulo
  spread, since the stagger then removes none of the zig-zag. Between 0.10 and 0.29 reads as
  inconclusive, the same reading the constant stagger received.
- **T4 (penalty survives).** The ratio stays at or above 2.0 at every N. Reason: the headline claim is a
  polar penalty near three times. A fall below 2.0 means the penalty depends on the stagger.
- **T5 (monotone curve).** The polar curve has zero monotone violations at every N. The random draw broke
  this at 384 and the constant stagger did not, so this stagger is held to the same check. Any violation
  **fires** the falsifier, and the count is reported as read.

**Prediction, stated before the run and not a falsifier.** An even spread should land near the constant
stagger: polar floors within about 3 percent of modulo, and a spread between 0.10 and 0.29. If it lands
far outside that band, the result is news, and the paper will say so rather than soften it.

**Ordering.** The falsifiers are committed before the script is run. The script is the existing
`stagger_offset.py` with one added branch, selected by an environment variable, so the constant-stagger
results reproduce unchanged.

## Result

Appended after the run, below this line. The five falsifiers above are not edited.
