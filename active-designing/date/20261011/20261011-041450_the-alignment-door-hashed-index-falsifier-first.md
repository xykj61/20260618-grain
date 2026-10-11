# The alignment door on a hashed index, falsifiers written before the run

**Status:** Design -- falsifiers stamped `20261011.041450` and committed before any hashed run; result appended below after the run
**Room:** research for understanding (scratch model; no witness binds it yet)
**Kin:** [the grid-step control](20261011-040649_the-grid-step-control-falsifier-first.md) - [the N = 384 and 640 sawtooth](20261011-035855_the-disk-size-series-at-384-and-640-falsifier-first.md) - [the fine capacity grid](20261011-034455_the-fine-capacity-grid-off-powers-of-two.md)

## What this door tests

The grid-step control cleared the search spacing. The sawtooth in the polar-to-Cartesian ratio survives at 1 percent steps: 2.69, 2.59 and 2.88 at N = 256, 384 and 640 on the fine grid, with 2.65 at N = 512 and 2.39 at N = 64. The one cause still open is the one the disk-size paper named first: that the zig-zag tracks the ring-to-set alignment, meaning how each polar ring's lines fall across the modulo set index.

This door tests that cause directly. It swaps the set index and changes nothing else. If the zig-zag is an alignment artifact of `line % sets`, a hashed index that breaks the alignment should flatten the ratio across N.

Unit: the floor is a count of sets, 8 lines each, at 5 percent excess over compulsory misses. The ratio is polar floor over Cartesian floor, dimensionless.

## The change, and only the change

The copy `session-output/polar-padded/fine_capacity_hash.py` is `fine_capacity.py` with one function replaced. The modulo `misses()` becomes a hashed index: a line goes to set `((line * 2654435761) & 0xFFFFFFFF) % sets`, a 32-bit Knuth multiplicative hash taken before the modulo. Everything else is unchanged: 8 ways, LRU, LINE 8, unpadded, the same deterministic disk and trace, the same 3 percent grid to `smax = 1 << 13`. The original file is left alone.

## Falsifiers, written before the run

- **A1 (flattening).** At the hashed index, the unpadded ratio at N = 256, 384, 512 and 640 has a spread, maximum minus minimum, of at most 0.10. Fires if the spread exceeds 0.10. Reason: the modulo readings span 2.59 to 2.88 over those four sizes, a spread of 0.29. If alignment drives the sawtooth, removing it should collapse the spread well inside 0.10, which is about 4 percent of the ratio.
- **A2 (baseline control).** At the hashed index, the Cartesian floor at each of N = 256, 384, 512 and 640 is within 10 percent of the modulo Cartesian floor: 12.4, 19.2, 25.0 and 28.8 sets. Fires if any one differs by more than 10 percent. Reason: if the hash moves the Cartesian baseline itself, the ratio is comparing two different models, and A1 cannot be read as a statement about alignment. A2 firing voids the door. It does not support A1.
- **A3 (monotone curve).** The hashed polar curve has zero monotone violations at all four sizes. Fires on any violation, since a violation means the floor search read noise rather than the model.

## What would change the reading

- **A1 holds and A2 holds:** the sawtooth tracks the modulo alignment at these sizes. The hashed model is flat, so the zig-zag is an index artifact of `line % sets`, and the model's ratio is then a property of the index, not of the disk. This still says nothing about any real cache.
- **A1 fires and A2 holds:** the sawtooth survives an index that breaks ring-to-set alignment, so alignment is not the cause. The next door is then something in the ring sizes themselves, such as how the ring's line count changes at each N, and it gets its own falsifier.
- **A2 fires:** the door is void. The hash has changed the baseline, and the next door is a hash that leaves the Cartesian floor unchanged, or a shuffled modulus control.
- **A3 fires:** the floor search misread the hashed curve, and the ratios at that size are not usable until the grid is rerun.

## What this door does not test

It does not test a real cache, a real trace, or any hardware. It does not show that the hash is the right index for any machine. It tests one cause of one zig-zag, in one scratch model, with one hash constant. A flat result would name alignment as the candidate cause. It would not prove alignment is the only cause.

## Scope

Scratch model only. Eight ways, LRU, LINE 8, unpadded, deterministic disk and trace. No hardware, no witness, no claim about any real cache. Confidence that A1 holds: medium, since a Knuth hash scrambles the ring-to-set relation but might not match the modulo's average miss, which A2 is there to catch. Confidence that A2 holds: medium-high, since the Cartesian trace is a regular grid that a multiplicative hash spreads evenly.

## Result

Appended after the run, below this line. The three falsifiers above are not edited.
