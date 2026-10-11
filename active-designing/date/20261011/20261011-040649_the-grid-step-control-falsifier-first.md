# The grid-step control on the sawtooth, falsifiers written before the run

**Status:** Design -- falsifiers stamped `20261011.040649` and committed before any 1 percent grid run; result appended below after the run
**Room:** research for understanding (scratch model; no witness binds it yet)
**Kin:** [the N = 384 and 640 sawtooth](20261011-035855_the-disk-size-series-at-384-and-640-falsifier-first.md) - [the fine capacity grid](20261011-034455_the-fine-capacity-grid-off-powers-of-two.md)

## What this door tests

The disk-size series read a ratio that zig-zags across N: 2.39, 2.60, 2.69, 2.59, 2.65 and 2.88 at N = 64, 128, 256, 384, 512 and 640. The previous door named two causes. One is that the sawtooth is a property of the scratch model's index alignment, the ring-to-set relation. The other is a measurement artifact: the floor search steps the set count by 3 percent, and the crossing is read by linear interpolation between grid points. At a floor near 20 to 90 sets, one grid step is about 1 set, so the interpolation error is a few percent of the ratio.

Before the alignment cause is discussed, the artifact has to be ruled out. This door changes the grid step and nothing else. It does not test the alignment cause itself.

Unit: the floor is a count of sets, 8 lines each, at 5 percent excess over compulsory misses. The ratio is polar floor over Cartesian floor, dimensionless. Source: `session-output/polar-padded/fine_capacity.py`, untracked scratch, unchanged. The new run uses a copy, `session-output/polar-padded/fine_capacity_grid1.py`, which differs in one line: the step factor in `grid()` goes from `1.03` to `1.01`, and `smax` drops from `1 << 13` to `1 << 9`. The floors sit near 90 sets at most, so a cap at 512 cannot move a crossing. The copy is written in this lap and the original is left alone.

## Falsifiers, written before the run

- **G1 (grid independence).** At the 1 percent step, the unpadded ratio at N = 256, N = 384 and N = 640 each lies within 0.05 of its 3 percent value: 2.69, 2.59 and 2.88. Fires if any of the three differs by more than 0.05. Reason: 0.05 is about two percent of the ratio, roughly the interpolation error a 3 percent step could add at these floors, so a larger shift would mean the 3 percent grid was reading its own spacing.
- **G2 (the dip and the rise survive).** At the 1 percent step, N = 384 reads below 2.65, and N = 640 reads above 2.75. Fires if N = 384 reads 2.65 or above, or N = 640 reads 2.75 or below. Reason: these are the two readings the sawtooth rests on, so both must survive a finer grid for the zig-zag to stand as a model property.
- **G3 (monotone curve).** The polar miss curve has zero monotone violations at all three sizes on the 1 percent grid. Fires on any violation, since a violation means the floor search read noise.

## What would change the reading

If G1, G2 and G3 hold, the grid step does not produce the sawtooth at these sizes, and the sawtooth is a property of the scratch model. The alignment question stays open and becomes the next door. If G1 fires, the 3 percent readings are partly a grid artifact, and the earlier sawtooth claim is narrowed to the 1 percent values. If G2 fires, the N = 384 dip or the N = 640 rise was the grid, and the sawtooth reduces to a single point at 640.

## What this door does not test

It does not test whether the sawtooth tracks the ring-to-set alignment. That needs its own falsifier, written and committed before its run, and it is named here as the door after this one. Reading G1 to G3 as a confirmation of alignment would be a mistake, since they test only the grid.

## Scope

Scratch model only. Eight ways, LRU, modulo index, LINE 8, unpadded, deterministic disk and trace. No hardware, no witness, no claim about any real cache. Confidence that G1 holds: high, since the step change is small against the spacing of the readings. Confidence that G2 holds: medium, since the 384 reading sits only 0.01 under the band it was measured against.

## Result

Appended after the run, below this line. The three falsifiers above are not edited.
