# Right to Repair Software

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this essay teaches

This essay applies the right-to-repair principle -- familiar from
tractors, phones, and appliances -- to software. It is written for
anyone who has ever been told "you cannot fix that" about a tool they
depend on, and who suspects that answer serves the vendor more than
the owner. It connects to Bloom curriculum Stage 9, Right to Repair.

## The principle

The right to repair says: if you own a thing, you may fix it. You may
open it, study how it works, replace the broken part, and put it back
together. You may hire someone to do this for you. The manufacturer
may not prevent you from repairing what you own.

This principle is law in a growing number of places for physical
goods -- tractors, phones, medical equipment. It is not yet law for
software, yet the same reasoning applies. Software breaks. Software
has errors. Software needs maintenance. The person who depends on
it deserves the ability to fix it, or to hire someone who can.

## Open source as the foundation

The first requirement is access to the source code. Source code is
the human-readable text that a programmer writes. It is compiled --
translated -- into the machine-readable form that your computer runs.
Without the source code, fixing software is like repairing an engine
with the hood welded shut.

Grain's source code is open. Anyone may read it, study it, modify it,
and share their modifications. This is not generosity -- it is a
structural decision. A farm that depends on software it cannot read
is a farm that depends on a stranger's continued goodwill, and
goodwill is not a foundation.

## Named errors

When software encounters a problem, it produces an error. The quality
of that error determines whether the person running the software can
understand what went wrong.

A poor error says: "Error: something went wrong." A person reading
this knows nothing they did not already know.

A named error says: "StorageFull: the Mantra log has reached its
capacity of 32 facts. Archive or remove older entries before adding
new ones." A person reading this knows what happened, why, and what
to do about it. A community technician reading this knows where to
look in the code.

Grain uses named errors throughout. Every error has a name, and every
name appears in the source code exactly once, so a person who reads
the error can find the code that produced it. This is a design
discipline, not an accident -- it costs effort to maintain, and the
effort is owed to the person who will read the error at ten o'clock
on a Tuesday when the system stops working.

## Bounded complexity

A tractor that a village mechanic can maintain serves its owner better
than a tractor that requires a factory-trained specialist with
proprietary diagnostic equipment. The same is true of software.

Grain bounds its complexity deliberately:

- **Explicit widths.** Every number in the system has a declared size.
  A counter that holds values up to 4 billion says so in the code.
  A technician reading the code knows what each number can hold
  without guessing.

- **Bounded allocations.** Every collection in the system has a maximum
  size declared at construction. The system will not silently grow
  until it exhausts memory. It will tell you, by name, when it
  reaches its limit.

- **Short functions.** Each function does one thing and fits on a
  screen. A technician can read a function, understand it, and decide
  whether it is the source of a problem -- without scrolling through
  hundreds of lines.

- **Assertions.** The code states what must be true at each step and
  checks those statements as it runs. When an assertion fails, the
  failure message says exactly which assumption was violated.

These are not luxuries. They are the software equivalent of labeled
fuse boxes, accessible oil filters, and bolts in standard sizes. They
make the system fixable by a person with reasonable training and
reasonable tools.

## The civic duty

Building software that people depend on and then making it unfixable
is a civic failure. A food system that runs on software nobody can
maintain is a food system with a single point of failure that nobody
can reach.

The duty runs in both directions. The developer owes clear code,
named errors, and honest documentation. The community owes support
for the technicians who learn to maintain the software -- the same
way a community supports the mechanics, electricians, and plumbers
who maintain its physical infrastructure.

Grain is designed so that a person with programming training -- not
necessarily the original developer -- can read the code, find the
problem, and fix it. That person might be a university student, a
cooperative's IT volunteer, or a professional hired for the task. The
code is written for them, because they are the ones who will be there
at ten o'clock on that Tuesday.

## Something to try

Find the error log on a piece of software you use -- a phone app, a
web service, a desktop program. Read the most recent error message.
Can you tell what went wrong? Can you tell what to do about it? Can
you imagine a community technician reading the same message and
knowing where to look?

The distance between your answer and "yes" is the distance between
software as a product and software as infrastructure.

---

*A tool that can be fixed is a tool that can be trusted. A system
that names its errors, bounds its complexity, and opens its source
code is a system that respects the person who depends on it -- and
the community that will maintain it long after the original builder
has moved on.*
