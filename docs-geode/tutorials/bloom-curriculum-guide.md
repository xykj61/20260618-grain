# Bloom Curriculum Guide -- Ten Stages from First Principles

**Style:** Teacher at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

Bloom's curriculum is a sequence of ten stages that carry a reader from
no background at all to a working understanding of what Grain is and how
its pieces fit together. This page maps those ten stages, explains how
each one builds on the one before it, and helps a teacher or self-guided
learner plan their path through the material.

## The ten stages

### Stage 1 -- Meeting the Dragons (What Grain Is)

The first stage introduces computing by metaphor. A computer is a
collection of dragons, each with a job: one remembers things, one draws
pictures, one listens. No prior knowledge is assumed. The stage closes
by naming Grain as the system that teaches these dragons to work
together.

### Stage 2 -- Roots and Trees (Rye)

The second stage introduces Rye, the programming language Grain is
written in. Rye descends from Zig, a language designed for safety and
explicit resource management. The stage teaches what a variable is, what
a function is, and why Rye insists that every allocation name its
budget.

### Stage 3 -- Memory as Garden (Glow)

The third stage introduces Glow, Grain's own higher-level language. Glow
descends from Hoon, Urbit's functional language, and uses rune-based
syntax. The stage explains how Glow expressions evaluate, how comments
work (the `::` convention), and what it means for a language to be
referentially transparent.

### Stage 4 -- Orchestra of Processes (Joy Has a Rank)

The fourth stage introduces the priority order that governs every
decision in the system: safety first, performance second, joy third.
It explains why safety is structural rather than a checklist, why
performance is measured rather than guessed, and why joy -- clarity,
naming things, saying why -- earns the last vote rather than no vote.

### Stage 5 -- Garden of Files (Identity)

The fifth stage introduces Kumara, Grain's identity layer. A key is
something only you hold. A signature proves you made a decision. A hash
verifies that data has not changed. The stage walks through keypair
generation, signing, and verification without assuming any background
in cryptography.

### Stage 6 -- Rivers of Networks (Aurora Display)

The sixth stage introduces networking through Comlink, Grain's
communication layer. It explains datagrams, sealed channels, the Noise
handshake, and why every message is encrypted even on a local network.
The river metaphor carries the stage: a message flows from source to
destination, sealed against tampering.

### Stage 7 -- Treasure of Identity (Personal Server)

The seventh stage introduces the idea of a personal server -- a machine
that belongs to you, answers to you, and keeps your records under your
own key. It explains what makes Grain different from a cloud service:
your name belongs to you because of what you hold, not what someone
granted.

### Stage 8 -- Ecology and Stewardship (Mantra)

The eighth stage introduces Mantra, Grain's append-only event log. Every
fact that enters the log is signed, hashed, and chained. The stage
explains replay identity -- running the same events through the same
logic produces the same state, always -- and why that matters for a
grower keeping daily records.

### Stage 9 -- Right to Repair (Caravan)

The ninth stage introduces Caravan, Grain's process supervision layer.
Caravan watches over the programs that run on a Grain machine, granting
capabilities, enforcing budgets, and stopping anything that exceeds its
bounds. The stage explains capability-based security in plain terms:
a program can do only what it was explicitly given permission to do.

### Stage 10 -- The Technical Vision (First Application)

The tenth stage brings everything together. A Glow program runs under
Caravan supervision, writes to Mantra, and displays results through
Aurora -- the first complete Grain application. The stage closes by
naming what comes next: the ecology that the system serves.

## How the stages build on each other

The curriculum follows a deliberate order:

1. **Stages 1-3** introduce the machines and their languages. A reader
   who finishes Stage 3 can read simple Rye and Glow code.
2. **Stages 4-5** introduce the values and the identity system. A reader
   who finishes Stage 5 understands why safety outranks speed and how
   a key proves who you are.
3. **Stages 6-7** introduce the network and the personal server. A
   reader who finishes Stage 7 understands what it means to own a
   machine rather than rent an account.
4. **Stages 8-10** introduce the systems that make ownership real:
   the log that remembers, the supervisor that enforces, and the
   application that ties them together.

Each stage assumes only what the stages before it taught. A reader who
starts at Stage 1 with no background can reach Stage 10 without ever
needing to look something up elsewhere.

## Something to try

Read through the stage titles in order and try to retell the story in
your own words. If you can explain what Grain is, why identity matters,
and how Mantra keeps records honest -- using only what you remember from
the titles -- then the curriculum has done its job, because the titles
themselves are the outline.

---

*Ten stages, ten doors. Each one opens onto the next, and the last one
opens onto the world the system was built to serve.*
