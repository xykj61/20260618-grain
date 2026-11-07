# The State at the Center

**Style:** Bhakta at the Door setting, with Radiant warmth

## What this teaching explores

This teaching introduces the most directly useful idea from Grain's
lineage: build the operating system as a single pure function --
`new_state = transition(old_state, event)` -- so the entire system is one
value that changes only at clean, well-defined moments.

## What state is

Every computer holds information that changes over time. The documents you
have open, the messages waiting for you, the temperature reading from a
sensor -- all of this is state. Most computers scatter their state across
dozens of places: files on a disk, rows in a database, variables in memory,
configuration in a registry. When something goes wrong, finding out what
the computer actually knows right now is genuinely hard, because you have
to look in all of those places at once.

## The single-function idea

Grain takes a different approach. Instead of scattering state across many
places, it gathers everything the system knows into one value -- one
complete picture of the world as the system sees it. When something
happens (a message arrives, a timer fires, a person presses a key), a
single function takes the old picture and the event, and produces the new
picture.

That function is called the **transition function**, and it works exactly
like a recipe:

1. Here is what we knew a moment ago (the old state).
2. Here is what just happened (the event).
3. Here is what we know now (the new state), and here is what we should
   do about it (the effects to send outward).

Nothing else changes the state. No background process sneaks in and
modifies a value. No two threads race to update the same record. The
transition function is the only door, and it opens one event at a time.

## How Grain's modules carry this idea

- **Mantra** is the log of every event that has ever passed through the
  transition function. Because the function is pure -- the same old state
  and the same event always produce the same new state -- you can replay
  the entire log from the beginning and arrive at exactly the current
  state. The log is the complete history, and the current state is a
  living summary of it.

- **Caravan** is the supervisor that sits around the transition function
  and manages the effects. When the function says "send this message" or
  "set this timer," Caravan carries out those instructions and brings
  the responses back as new events. The function computes; Caravan acts.

- **Tally** manages the memory the transition function works in. Tally's
  discipline is to allocate all memory at startup and never grow or free
  it while the system runs. This means the function never has to worry
  about running out of memory mid-step -- the budget is known before the
  first event arrives. Tally uses named regions called **gardens**, each
  with a fixed size, so every piece of memory has a home and a limit.

- **The four kernel variants** (Riyo, Reya, Trey, Triz) are four
  implementations of the same transition function, written in Glow. They
  differ in how they compute, yet they agree on what the result should be
  for any given event. Running more than one and comparing their answers
  is how Grain catches errors that a single implementation might miss.

## Why this is powerful

When the entire system is one function over one value, several hard
problems become simple:

- **Recovery.** If the system crashes, replay the log. You arrive at the
  same state you had before, because the function is deterministic.
- **Debugging.** To understand what happened, read the log. Every event
  that changed the system is recorded, in order.
- **Testing.** To test the system, give the function a known state and a
  known event, and check that the output matches what you expect. No
  mocking, no simulating -- the function is the whole thing.
- **Auditing.** To verify that the system did what it should have done,
  walk the log and check each transition. The record is complete and
  tamper-evident, because Mantra signs every fact.

## Something to try

Think of a simple system you interact with daily -- a thermostat, a to-do
list, a bank account. Try writing down its transition function in plain
words: "If the current state is X and the event is Y, the new state is Z."
You will find that even a simple system has more events than you first
expect, and that writing the function down makes the system's behavior
completely clear.

May the state at the center hold steady, and may every transition carry the
system forward honestly.
