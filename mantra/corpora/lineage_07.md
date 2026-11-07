# The Whole in Every Part

**Style:** Bhakta at the Door setting, with Radiant warmth

## What this teaching explores

This teaching introduces the idea that a reliable whole can be built
entirely from local parts that agree wherever they overlap. In
mathematics, this idea has a precise name -- the sheaf condition -- and
it turns out to describe exactly how Grain's own data and log systems
work.

## Start with a puzzle

Imagine a group of neighbors, each of whom keeps a record of the weather
on their street. Each record is local -- it covers only what one person
can see from their own window. Yet wherever two neighbors can see the same
intersection, their records agree: the same rain at the same time, the
same temperature within their instruments' precision.

Now ask: can these local records be assembled into one coherent city-wide
weather map, with no contradictions?

The answer is yes, provided every overlap agrees. This is the core
insight, and it does not depend on weather. It works for any kind of data:
if the pieces agree wherever they touch, they glue into a consistent
whole.

## The sheaf condition, in plain words

Mathematicians call this the **sheaf condition**, and it says exactly what
the weather puzzle says:

1. You have data spread across many local patches.
2. Wherever two patches overlap, their data agrees.
3. Therefore, the local pieces assemble into one global picture, with no
   contradictions.

That is the entire idea. The word "sheaf" comes from a bundle of stalks
tied together -- each stalk is a local piece, and the binding is the
agreement on overlaps.

## How Grain uses this idea

Grain's own architecture is built on this principle, in two places:

**Kyri's value model.** Kyri is Grain's notation for data -- plain
key-value records, one field per line. Kyri's central promise is that
values compose by being placed side by side, and they never tangle. Two
records that share a field name agree on its meaning, so they can be
combined into a larger record without contradiction. This is the sheaf
condition applied to data structure: local pieces that agree on overlaps
glue into a whole.

**Mantra's fold.** Mantra is Grain's log -- an append-only sequence of
signed facts. The current state of the system is reconstructed by folding
over that sequence: start with nothing, apply each fact in order, and
arrive at the present. Each fact is a local piece of knowledge. Because
the facts are immutable and signed, they cannot contradict each other
after they are recorded. The global state -- everything the system knows
right now -- is assembled from those local facts, with no contradictions,
exactly as the sheaf condition describes.

## Why this matters

The sheaf condition is a test you can apply to any system you build or
maintain:

- **Are the local pieces consistent?** If two parts of your system
  describe the same thing, do they agree? If they do, the whole system
  is reliable. If they do not, something needs attention.

- **Can you build the whole from the parts?** If every local piece is
  honest and every overlap agrees, you do not need a central authority to
  declare what the truth is. The truth assembles itself from the parts.

This is why Grain uses an append-only log rather than a central database
that can be edited. Each signed fact is a local piece. Agreement is
enforced by immutability -- once a fact is recorded, it cannot be changed
to contradict another. The whole picture is always available, always
consistent, and always rebuildable from the parts.

## Something to try

Pick a topic you know well -- the layout of your kitchen, the rules of a
game, the schedule of a bus route. Try describing it in pieces, each piece
covering only one small area, and make sure that wherever two pieces
overlap, they agree. Then assemble the pieces into one picture. If the
overlaps are consistent, the picture assembles cleanly. If one overlap
disagrees, that disagreement is exactly where the design wants attention.

May the parts agree, and may the whole they build be worthy of the care
that made each one honest.
