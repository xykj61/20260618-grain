# Stage 9 -- Right to Repair

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

When a tool breaks, the person who owns it should be able to fix it. A farmer
whose tractor stops running in the middle of harvest needs to open the hood,
find the fault, and make the repair -- that day, with the parts and knowledge
available. The same is true for software.

**Right to repair** means that the person who uses a machine has the right to
understand how it works, to diagnose what went wrong, and to fix it
themselves or choose who fixes it for them. It is a civic principle as old as
toolmaking, and Grain is built around it.

## What makes software repairable

Three things make a program repairable, and all three are choices the builder
makes before the first user ever sees it.

1. **Open source.** The program's source code -- the human-readable
   instructions a programmer writes -- is available to anyone who runs the
   program. This means a person with the right skills can read how the program
   works, find a fault, and write a correction.

   Grain's source code is open. Every module -- Caravan, Mantra, Amphora,
   Comlink, Kumara, Dimeroll -- can be read, studied, and improved by anyone.

2. **Named errors.** When something goes wrong, the program says what went
   wrong, in plain words. Stage 4 described how Caravan returns a named error
   when a dependent asks for something outside its grants. That pattern runs
   through every Grain module: a fault produces a message that tells a person
   exactly what happened, so the repair begins with understanding rather than
   guessing.

3. **Bounded complexity.** A program built from small, well-defined pieces is
   easier to repair than a program built as one enormous tangle. Each piece
   does one thing, and when that thing breaks, the repair stays inside that
   piece. This is why Grain's modules are separate: Mantra keeps the log,
   Amphora seals it, Comlink carries messages, Kumara holds identity. A fault
   in one module stays in that module, and the repair stays there too.

## The civic duty

Right to repair is a **civic** principle -- it belongs to the community, and
it carries a responsibility. A builder who makes something repairable is
giving a gift to everyone who will ever use it: the gift of independence. A
builder who makes something that only they can fix is keeping a dependency.

Grain chooses the first. Every design decision in this project is weighed
against the question: **can the person who uses this fix it themselves?** If
the answer is yes, the design is carrying its weight. If the answer is no,
the design owes a reason, and that reason is written down.

This is what TAME Guidance (the code discipline from Stage 2) means by
**safety first**: a safe program is a program whose errors are named, whose
bounds are stated, and whose pieces are small enough to understand. Safety
and repairability are two names for the same thing, seen from two sides.

## What repair looks like in practice

A cooperative running Grain on their own hardware finds that the Amphora
sealing schedule is taking longer than expected. They open the source code
for the sealing module, read the comments (which say **why** each threshold
was chosen, per TAME Guidance), and find that the daily seal window is
configured for a machine with more memory than theirs.

They change the threshold to match their hardware, rebuild the module, and
run the witness -- a small test program that proves the module still works
correctly after the change. The witness passes. They deploy the change and
the sealing runs on time.

At every step, the cooperative had what they needed: the source code to read,
the comments to understand, the witness to verify, and the freedom to make
the change. That is right to repair in software.

## Something to try

Think of a tool you use every day -- a phone, a bicycle, a kitchen appliance.
Ask three questions about it:

1. If it broke today, could you open it and look inside?
2. If you found the problem, could you get the part to fix it?
3. If someone else fixed it, could you choose who?

The answers tell you how repairable that tool is. A tool that answers yes to
all three respects the person who owns it. Grain aims to answer yes to all
three for every person who runs it.

In the final stage, we will look at the full vision -- where all ten stages
come together into one picture of what Grain is building and why it matters.

---

*A tool you can fix is a tool you truly own. A program whose source you can
read, whose errors speak plainly, and whose pieces you can hold in your hands
is a program that belongs to the person who runs it.*
