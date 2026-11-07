# Stage 1 -- Meeting the Dragons

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

A computer is a machine that follows instructions. An operating system is the
set of instructions that lets a person use that machine -- to write, to count,
to talk to someone far away, to keep a record safe.

Grain is an operating system. It is built for people who want to own their
own machine and their own records: a small farm keeping its soil data, a
family keeping its letters, a school keeping its lessons. The machine belongs
to the person who holds it, and Grain is what makes that promise real.

## The two dragons

Every operating system carries two responsibilities, and in Grain we give each
one a name.

**The Guardian Dragon** watches over safety. It makes sure that one program
cannot reach into another program's work. It makes sure that the machine does
not try to do more than it can. It makes sure that a record, once sealed, stays
exactly as it was. The Guardian Dragon is serious and careful, and it never
sleeps.

**The Companion Dragon** watches over joy. It makes sure that the screen is
clear and the colors are warm. It makes sure that a button does what it looks
like it should do. It makes sure that the person using the machine feels at
home. The Companion Dragon is playful and kind, and it pays attention to every
small thing.

A good operating system needs both dragons. Safety without joy makes a machine
that nobody wants to use. Joy without safety makes a machine that cannot be
trusted. Grain keeps them together.

## Where the dragons live

The Guardian Dragon lives in three places:

1. **The kernel** -- the innermost layer, which talks directly to the hardware.
   The kernel decides who gets to use the processor and for how long. In Grain,
   the kernel is built on seL4, a small, verified program that has been
   mathematically proven to do what it says it does.

2. **The bounds** -- every program in Grain names a maximum for everything it
   asks for. A maximum amount of memory. A maximum number of items in a list.
   A maximum length for a message. These bounds are the Guardian Dragon's
   rules, and a program that tries to break them is stopped before it can.

3. **The seals** -- a record in Grain can be sealed with a cryptographic hash,
   which is a fingerprint computed from the record's own contents. If a single
   letter changes, the fingerprint changes. The Guardian Dragon checks these
   fingerprints.

The Companion Dragon lives in three places too:

1. **The surface** -- what appears on screen. In Grain, this is called
   Brushstroke, and it paints every pixel the person sees.

2. **The names** -- every module in Grain has a warm, clear name. Caravan
   watches over running programs. Mantra keeps the log of everything that
   happened. Comlink carries messages between machines. A name you can say
   aloud is a name you can remember.

3. **The lessons** -- the page you are reading right now. The Companion Dragon
   believes that understanding should be offered freely, in plain words,
   to anyone who asks.

## Something to try

Open a terminal on your machine and type:

```
echo "hello, grain"
```

The machine reads your words, carries them through the kernel, and prints them
back. That round trip -- your words in, the machine's answer out -- is the
simplest thing an operating system does, and it is the foundation everything
else is built on.

In the next stage, we will look at the kernel itself -- the tree whose roots
hold everything up.

---

*The Guardian Dragon and the Companion Dragon are waiting. They have been here
since the first line of code, and they will be here when the last one is
written. Welcome.*
