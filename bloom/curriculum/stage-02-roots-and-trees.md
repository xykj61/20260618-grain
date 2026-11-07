# Stage 2 -- Roots and Trees

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

A kernel is the innermost program in an operating system. It starts before
anything else, and everything else depends on it. If the kernel stops, the
whole machine stops.

In Grain, we think of the kernel as a tree. Its roots reach into the hardware
-- the processor, the memory, the storage. Its trunk carries instructions
upward. Its branches hold the programs that a person actually sees and uses.

## Why a tree

A tree is a good picture for a kernel because of three things it does:

1. **It stands on its own roots.** A tree does not borrow its foundation from
   another tree. The kernel talks directly to the hardware, and nothing sits
   between them. In Grain, the kernel is built on seL4, which is a microkernel
   -- a kernel so small that every line of its code has been checked by a
   mathematical proof. Small is strong here: fewer lines mean fewer places
   for something to go wrong.

2. **It feeds everything above it.** The tree's roots pull water and minerals
   from the soil and send them upward through the trunk. The kernel does the
   same with the machine's resources -- processor time, memory, access to
   storage. Every program running on the machine receives these resources
   through the kernel, and only through the kernel.

3. **It grows in bounded rings.** A tree adds one ring of wood each year, and
   each ring has a definite thickness. The kernel adds capabilities the same
   way -- one layer at a time, each with a clear boundary. In Grain, this
   discipline is called TAME Guidance, and its first rule is: **bound
   everything**. Every allocation of memory names a maximum. Every list names
   a maximum length. Every loop names a maximum number of repetitions. A
   program that tries to exceed a bound is stopped cleanly, with a named
   error that says what happened and why.

## The three layers

From the roots upward, the tree has three layers:

**The kernel (seL4).** This is the verified microkernel. It handles the most
basic operations: giving a program time on the processor, protecting one
program's memory from another, and passing messages between programs. It is
small enough to fit in a few thousand lines of code, and every one of those
lines has been proven correct.

**The root tasks (Caravan).** Above the kernel sit the programs that manage
other programs. In Grain, this layer is called Caravan. Caravan starts
programs, watches them while they run, and stops them cleanly when they are
done. Each running program is called a dependent -- something held up by
what it was granted, the way a branch is held up by the trunk.

**The application modules.** These are the programs a person actually uses:
Mantra (the log of what happened), Comlink (messages between machines),
Kumara (identity and naming), Dimeroll (accounting), and many others. Each
one is a branch of the tree, drawing its resources from Caravan and
ultimately from the kernel.

## Bounds in practice

Here is what a bound looks like in Grain's own language, Rye:

```rye
const max_items: u32 = 256;
// invariant: items never exceeds max_items
```

That single line says: this collection holds at most 256 items. The number is
a `u32` -- an unsigned 32-bit integer, which means it can hold values from 0
to about 4.3 billion. The comment above the bound says why it is there. In
Grain, every bound carries a comment that names the reason.

The Guardian Dragon enforces these bounds. A program that asks for item number
257 does not get a mysterious crash -- it gets a named error, a clear message
that says "you asked for more than this collection holds." That clarity is a
kindness to the person who will read the error message later, which may be
you.

## Something to try

Think of a program you use every day -- a web browser, a text editor, a
calculator. Ask yourself: how many tabs can it hold? How many characters can
it accept in a single input field? How many items can it show in a list?

Most programs do not have clear answers to these questions, because most
programs do not name their bounds. Grain names every one. The Guardian Dragon
keeps count so the person does not have to.

In the next stage, we will look at memory itself -- the garden where every
program plants what it needs and harvests what it grew.

---

*A tree that knows the depth of its own roots can weather any wind. So can a
kernel that names its own bounds.*
