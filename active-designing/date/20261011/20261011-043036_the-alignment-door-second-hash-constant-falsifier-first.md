# The alignment door on a second hash constant, falsifiers written before the run

**Status:** Design -- falsifiers stamped `20261011.043036` and committed before any run; result appended below after the run
**Room:** research for understanding (scratch model; no witness binds it yet)
**Kin:** [the hashed-index door](20261011-041450_the-alignment-door-hashed-index-falsifier-first.md) - [the N = 384 and 640 sawtooth](20261011-035855_the-disk-size-series-at-384-and-640-falsifier-first.md) - [the fine capacity grid](20261011-034455_the-fine-capacity-grid-off-powers-of-two.md)

## What this tests

The hashed-index door at `20261011.041450` used one hash constant, 2654435761 (0x9E3779B1), and it fired all three falsifiers. Its Cartesian baseline moved 12 percent at N = 256 and 11 percent at N = 640, which voided the door. So that run cannot say whether ring-to-set alignment drives the zig-zag.

This door keeps the same model and changes one thing only: the multiplicative constant, to 2246822507 (0x85EBCA6B, the murmur-style finalizer constant). The question is whether a different hash, which still breaks ring-to-set alignment, keeps the Cartesian baseline close enough for the alignment reading to be tested at all.

The copy is `session-output/polar-padded/fine_capacity_hash2.py`. It differs from `fine_capacity_hash.py` only in that constant. The original files are left alone.

## Falsifiers, written before the run

- **B1 (flattening).** At this constant, the unpadded ratio at N = 256, 384, 512 and 640 has a spread, maximum minus minimum, of at most 0.10. Fires if the spread exceeds 0.10. Reason: the modulo readings span 2.59 to 2.88 (a spread of 0.29), and the first hash constant spread 0.47. If alignment drives the sawtooth, a second hash should also flatten it.
- **B2 (baseline control).** At this constant, the Cartesian floor at each of N = 256, 384, 512 and 640 is within 10 percent of the modulo Cartesian floor: 12.4, 19.2, 25.0 and 28.8 sets. Fires if any one differs by more than 10 percent. Reason: a constant that moves the baseline compares two different models, so B1 cannot then speak about alignment. B2 firing voids the door. It does not support B1.
- **B3 (monotone curve).** The hashed polar curve has zero monotone violations at all four sizes. Fires on any violation, since a violation means the floor search read noise.

## What would change the reading

- **B1 holds and B2 holds:** a second, independent hash flattens the sawtooth while keeping the baseline. That is a stronger case that the zig-zag is an artifact of the modulo index, and it still says nothing about a real cache.
- **B1 fires and B2 holds:** the sawtooth survives a second index that breaks alignment, so alignment is not the cause at these sizes. The next door moves to ring sizes.
- **B2 fires:** the door is void again, and the next door is a constant or shuffle that leaves the baseline alone.
- **B3 fires:** the floor search misread the hashed curve, and those ratios are not usable.

## What this door does not test

It does not test a real cache, a real trace, or any hardware. It tests one index family at one more constant, in one scratch model. A flat result would name the modulo index as the likely source of the zig-zag. It would not prove that the modulo is the only cause.

## Scope

Scratch model only. Eight ways, LRU, LINE 8, unpadded, deterministic disk and trace. No witness, no claim about any real cache. Confidence that B2 holds: medium, since the first constant already moved the baseline by 12 percent and a different constant may not do better. Confidence that B1 holds: low to medium, since the first hash did not flatten the curve.

## Result

Appended after the run, below this line. The three falsifiers above are not edited.
