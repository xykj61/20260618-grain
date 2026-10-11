# The disk-size series at N = 384 and 640, falsifiers written before the run

**Status:** Design -- falsifiers stamped `20261011.035855` and committed before any N = 384 or N = 640 run; result appended below after the run
**Room:** research for understanding (scratch model; no witness binds it yet)
**Kin:** [the N = 512 fine-grid run](20261011-035019_the-n512-fine-grid-falsifier-first.md) - [the fine capacity grid](20261011-034455_the-fine-capacity-grid-off-powers-of-two.md)

## What this door tests

The N = 512 run read the polar-to-Cartesian working-set ratio at 2.65, against 2.69 at N = 256, 2.60 at N = 128 and 2.39 at N = 64. So the rise with N has turned on this model, and the peak sits near N = 256 on four points. The N = 512 paper named this door: a disk-size series at N = 384 and N = 640 on the same fine grid, to decide whether the peak sits near 256 or moves.

Unit: the floor is a count of sets, 8 lines each, at 5 percent excess over compulsory misses. Ratio is polar floor over Cartesian floor, dimensionless. Source: `session-output/polar-padded/fine_capacity.py`, untracked scratch, unchanged for this door, run as `python3 fine_capacity.py nopad 384 640` from `session-output/polar-padded/`.

## Baseline check, before the falsifiers are read

The N = 256 row reproduces from `fc256_base_20261011.txt` at 2.69. The N = 384 and N = 640 rows count only if the scratch script still reads that N = 256 baseline within 0.01 on this rerun.

## Falsifiers, written before the run

- **F1 (band).** The unpadded ratio at N = 384 and at N = 640, LINE 8, 5 percent, each lies inside 2.6 to 3.0. Fires if either is below 2.6 or above 3.0. The band is the fine-grid paper's own, carried unchanged from the N = 512 door.
- **F2 (peak holds near 256).** Neither the N = 384 ratio nor the N = 640 ratio exceeds 2.74, which is the N = 256 value of 2.69 plus 0.05. Fires if either exceeds 2.74. Reason: the N = 512 reading of 2.65 says the rise has turned, and a return above the N = 256 value at either intermediate or larger disk would mean the peak moved past 256 or the curve is not unimodal.
- **F3 (monotone curve).** The polar miss curve has zero monotone violations at both N = 384 and N = 640. Fires on any violation, since a violation means the floor search read noise rather than capacity.

## What would change the reading

If F1, F2 and F3 hold, the ratio is flat-to-falling above N = 256 on this model, and the peak sits near 256 within the resolution of these five points. If F2 fires, the peak has moved past 256 and the next question is where, which the N = 512 reading did not settle. If F1 fires low at either size, the band itself is not stable across disk size and the fine-grid band reading must be narrowed.

## Scope

Scratch model only. Eight ways, LRU, modulo index, LINE 8, deterministic disk and trace. No hardware, no witness, no claim about a real cache. Confidence in F2 holding: medium, since the N = 512 point is the only evidence of the turn and the disk grows by a factor the trend has not yet been tested across.

## Result

Appended after the run, below this line. The three falsifiers above are not edited.
