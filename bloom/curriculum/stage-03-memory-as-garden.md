# Stage 3 -- Memory as Garden

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

Memory is where a running program keeps the things it is working with right
now. A calculator keeps the numbers it is adding. A text editor keeps the
words you are typing. A web browser keeps the page it is showing you.

When a program needs memory, it asks the operating system for some. When it is
done, it gives that memory back. This is allocation -- asking for a piece of
the machine's memory, using it, and returning it.

In Grain, we call the place where memory is managed the **garden**, because a
garden is a bounded plot of land where you plant what you need, tend it while
it grows, and harvest it when it is ready.

## Why memory needs bounds

A machine has a fixed amount of memory. A small computer -- the kind a farm
might use to keep its records -- may have 1 gigabyte, which is roughly one
billion bytes. That sounds like a lot, and it is, until a program asks for
more than its share.

A program that asks for memory without limit is a program that can crowd out
every other program on the machine. It is a weed in the garden -- not because
it intends harm, but because nothing told it to stop growing.

Grain's discipline is: **every allocation names a maximum.** Before a program
asks for memory, it says how much it will need at most. The garden allocator
checks that number against what is available and either grants the request or
returns a named error. No silent failures. No mysterious slowdowns. A clear
answer, every time.

## The garden arena

In Grain's own language, Rye, the garden allocator is set up like this:

```rye
const garden = init.arena.allocator();
// invariant: garden is the only allocator in authored Rye
```

The word `arena` means a region of memory that is allocated once and freed all
at once when the program is done with it. It is like planting a row of seeds
at the start of the season and harvesting the entire row at the end. This is
simpler and safer than planting and harvesting one seed at a time, because
there is no chance of forgetting to harvest one.

The name `garden` is Grain's own warm word for this allocator. Every authored
Rye file uses it, and only it. This consistency means that anyone reading any
module in Grain knows exactly where the memory comes from.

## Explicit widths

Memory is measured in bits and bytes. A bit is a 0 or a 1. A byte is eight
bits. A number stored in memory takes up a certain width -- a certain number
of bits.

Grain uses explicit widths, which means every number names exactly how wide
it is:

- **`u32`** -- an unsigned 32-bit integer. It can hold values from 0 to
  4,294,967,295. This is the standard width for counts, indices, and lengths
  inside a running program.

- **`u64`** -- an unsigned 64-bit integer. It can hold values from 0 to
  about 18.4 quintillion. This is the standard width for things that travel
  between machines or are saved to storage -- timestamps, file sizes, network
  addresses.

- **`usize`** -- a width that matches the machine's own address size. On a
  32-bit machine it is 32 bits; on a 64-bit machine it is 64 bits. In Grain,
  `usize` is used **only at the boundary** where Rye talks to the underlying
  system, never in the program's own logic.

The rule is: **say what width you mean, and say why.** A number that is `u32`
because it counts items in a bounded list carries a comment naming the bound.
A number that is `u64` because it measures time carries a comment naming the
clock.

## Something to try

Think of your own kitchen. The countertop has a fixed area -- that is your
memory. When you cook, you set out the ingredients you need -- that is
allocation. When you are done, you clean up -- that is deallocation.

Now imagine a kitchen where nobody ever cleaned up. The countertop fills with
old ingredients, dirty bowls, and open containers. Eventually there is no
room to cook anything new. That is what happens when a program does not manage
its memory.

The garden discipline is the habit of cleaning up, built into the language
itself so that forgetting is not an option.

In the next stage, we will look at how programs run together -- the orchestra
that turns a collection of instruments into music.

---

*A garden that names its rows and tends its soil feeds a household for years.
So does a program that names its allocations and returns what it borrows.*
