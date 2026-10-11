# The N = 512 fine-grid run, falsifiers written before the run

**Status:** Design -- falsifiers stamped `20261011.035019` and committed before any N = 512 run; result appended below after the run
**Room:** research for understanding (scratch model; no witness binds it yet)
**Kin:** [the fine capacity grid](20261011-034455_the-fine-capacity-grid-off-powers-of-two.md) - [the bit-sliced set index](20261011-033859_the-bit-sliced-set-index-falsifier-first.md) - [the set-associative line size](20261011-033405_the-set-associative-line-size-falsifier-first.md)

## What this door tests

The fine-grid paper read a polar-to-Cartesian working-set ratio of 2.39, 2.60 and 2.69 at N = 64, 128 and 256 on a modulo index, 8 ways, LRU, LINE 8, and named N = 512 as its next door. The falsifiers below were stated before that run, which the fine-grid paper could not claim for its own.

Unit: the floor is a count of sets, 8 lines each, at 5 percent excess over compulsory misses. Ratio is polar floor over Cartesian floor, dimensionless. Source: `session-output/polar-padded/fine_capacity.py`, untracked scratch, reusing `padded_bitslice.py`'s trace and stencil. The script is not changed for this door.

## Baseline check, before the falsifiers are read

The N = 256 row must reproduce from the script before N = 512 is read. The prior file `session-output/polar-padded/fine_capacity_nopad.txt` reads 2.69 at N = 256, LINE 8, unpadded. If a rerun at N = 256 does not land within 0.01 of 2.69, the script has drifted and no N = 512 row counts.

## Falsifiers, written before the run

- **F1 (band).** The unpadded ratio at N = 512, LINE 8, 5 percent, lies inside 2.6 to 3.0. Fires if it is below 2.6 or above 3.0. The band is the fine-grid paper's own, stated there before this door.
- **F2 (padding stays small).** At N = 512, LINE 8, the padded ratio differs from the unpadded by no more than 0.10. Fires if the gap is above 0.10. Reason: at LINE 8 the earlier sweeps read padding moving the ratio by 0.04 or less.
- **F3 (monotone curve).** The polar miss curve has zero monotone violations at N = 512. Fires on any violation, since a violation means the floor search read noise rather than capacity.

## What would change the reading

If F1 holds, the fine grid is the settled reading for this model, and the next door is the disk-size axis at a different radius. If F1 fires high, the ratio rises with N and the cause is the next thing to study, as the fine-grid paper said. If F2 fires, padding matters at LINE 8 on this disk, which reverses the padding-band reading and must be reported as such.

## Scope

Scratch model only. Fully associative is not claimed; the model is 8 ways with a modulo index. No hardware, no witness, no claim about any real cache. Confidence in F1 holding: low to medium, since N = 512 has four times the cells of N = 256 and the trend from 2.39 to 2.69 is only three points.

## Result

Appended after the run, below this line. The three falsifiers above are not edited.
