# Bounded Optimization

**Style:** Bhakta at the Door setting, with Radiant warmth

## What this teaching explores

This teaching introduces the idea of optimization within hard limits --
tuning a system when the things you are adjusting cannot go past certain
boundaries, and when some of them wrap around. This connects directly to
Grain's core discipline: bound everything, and know the maximum before
you run.

## What optimization means

Optimization is the practice of adjusting something to make it work
better. A gardener optimizes a planting layout by moving rows closer or
farther apart until each plant gets enough light. A baker optimizes a
recipe by adjusting flour and water until the bread rises just right.

In computing, optimization means adjusting a system's settings --
called parameters -- until the system performs as well as it can. A
compiler might adjust how aggressively it reorders instructions. An
inference engine might adjust how confidently it draws conclusions from
partial information.

## The problem with unbounded tuning

Most optimization methods assume the parameters can take any value at
all -- they can grow without limit in any direction. This works fine in
theory, yet real systems always have limits:

- A temperature cannot go below absolute zero.
- An angle wraps around: 360 degrees is the same as 0 degrees.
- A memory budget has a ceiling that cannot be crossed.
- A proportion must stay between 0 and 1.

When an optimizer ignores these limits, it can waste effort exploring
impossible values, or it can bounce awkwardly off a boundary it was never
designed to handle.

## The torus: a shape for bounded, wrapping values

Here is where the geometry helps. A **torus** is the mathematical name
for the shape of a doughnut. It is what you get when you take a flat
rectangle and glue the top edge to the bottom edge, and the left edge to
the right edge. Everything wraps around. There are no edges, no corners,
and no boundaries to bounce off.

When the parameters you are tuning genuinely wrap around (like angles) or
must stay within hard limits (like budgets), the torus is a natural home
for them. An optimizer that knows it is walking on a torus handles the
wrapping gracefully -- it steps smoothly from 359 degrees to 1 degree
without any special boundary logic.

## How this connects to Grain

Grain's TAME Guidance -- the code discipline that governs every module --
has one rule above all others: **bound everything.** Every allocation
names a maximum. Every collection has a limit. Every loop has a ceiling.
The system knows its own boundaries before it starts.

Bounded optimization is the same discipline applied to tuning. Instead of
asking "what is the best value?" and searching in every direction, it asks
"what is the best value within these known limits?" The search space is
compact (it has a definite size), deterministic (the same inputs produce
the same path), and reproducible (anyone can re-run it and arrive at the
same answer).

This matters for a system meant to run on modest hardware -- the kind of
machine a small farm or a community workshop can afford. An optimizer that
stays within known bounds uses predictable memory and finishes in
predictable time, which is exactly what TAME asks of every other part of
the system.

## Something to try

Think of something you have tuned by hand -- the seasoning in a dish,
the angle of a lamp, the timing of your morning routine. Identify the
limits: what is the minimum, what is the maximum, and does anything wrap
around (like the hours on a clock)? Notice how knowing the limits
changes the way you search. You do not try every possibility -- you
explore the bounded space, and the bounds themselves guide you toward
what works.

May every search stay within the bounds it was given, and may the answer
it finds be one the system can honestly keep.
