# Stage 5 -- Garden of Files

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

A file is a named piece of information stored so it can be found again later.
A recipe written on a card, a photograph in an album, a ledger in a drawer --
each is a file in the everyday sense. A computer file is the same idea kept in
electronic storage rather than on paper.

In Grain, files are managed by two systems working together: **Mantra** keeps
the record of what happened, and **Amphora** seals that record so it cannot
be changed without anyone noticing.

## Mantra -- the log of what happened

Mantra is a log. Every action the system takes -- storing a new file, changing
a setting, sending a message -- is written into Mantra as a single entry.
Each entry records what happened, when it happened, and who asked for it.

The log is append-only, which means entries are added at the end and always
kept. This is like a bound notebook where you write on the next blank line
and every page stays. The whole history of the system is there, in order, for
anyone who needs to read it.

Why append-only? Because a record that stays exactly as written is a record
everyone can trust. An append-only log proves itself -- the entries are there
because they happened, and they are there in the order they happened.

## Content addressing

Every piece of data in Mantra is stored by its content rather than by a name
someone chose. Here is what that means.

When Mantra receives a piece of data, it runs a mathematical function called a
hash over the data's bytes. The hash produces a short, fixed-length number
that is unique to that exact data -- if even one byte changes, the hash
changes completely. Mantra uses this hash as the data's address.

This is called **content addressing**, and it gives two things for free:

1. **Integrity.** To check whether a piece of data has been changed, run the
   hash again and compare. If the hashes match, the data is exactly what it
   was. If they differ, something changed. No trust required -- the math
   does it.

2. **Deduplication.** If two programs store the same data, they get the same
   hash, which means the data is stored only once. The garden stays free of
   copies.

## Amphora -- the sealed vessel

An amphora is an ancient vessel for storing oil, wine, or grain. It was sealed
at the source and opened at the destination, and the seal proved it had not
been opened on the way.

Grain's Amphora does the same thing with data. It takes a set of log entries
from Mantra, computes a seal over all of them -- a single hash that covers
every byte -- and stores that seal. The seal is a promise: if you re-compute
it later and it still matches, every entry is exactly as it was.

Amphora seals are built in layers:

- A **daily seal** covers one day's log entries.
- A **weekly seal** covers seven daily seals.
- A **monthly seal** covers the weekly seals of one month.

Each layer's seal includes the seals below it, the way a wax seal on a crate
includes the seals on each jar inside. To verify the whole month, check the
monthly seal. To verify one day, check only that day's seal. The work is
proportional to what you are checking, not to the whole history.

## Something to try

Keep a simple log for one day. Write down every significant thing you do --
woke up, ate breakfast, started working, took a call -- with the time beside
it. At the end of the day, read the log from top to bottom.

You will notice something: the log tells you things your memory cannot.
Exactly when you started, exactly what order things happened in, and whether
you did what you thought you did. That is the value of a faithful record, and
it is what Mantra gives every process on the system.

In the next stage, we will look at how machines talk to each other -- the
rivers that carry messages between them.

---

*A vessel sealed at the source and opened at the destination carries trust
across any distance. So does a log whose every entry is hashed and whose
every seal can be checked.*
