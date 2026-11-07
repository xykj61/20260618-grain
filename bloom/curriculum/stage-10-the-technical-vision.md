# Stage 10 -- The Technical Vision

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

This is the last lesson, and it is a gathering. The nine stages before it each
built one piece. This stage puts them all together into one picture and asks:
**what does it look like when everything works?**

## The ten pieces, in one breath

1. **Two dragons** watch over everything -- a Guardian for safety and a
   Companion for joy. Every design begins by naming what it protects and what
   delight it offers.

2. **A kernel tree** gives the system its shape. The seL4 microkernel is the
   root, proved correct by mathematical proof. Caravan is the first branch,
   and every other program grows from it.

3. **Memory is a garden.** Every allocation is bounded, every width is named,
   and the garden arena keeps things tidy. A program that manages its memory
   well runs on a small machine for a long time.

4. **Processes are an orchestra.** Caravan conducts. Each dependent receives
   its grants -- memory, devices, communication -- and works within them. The
   orchestra plays because every voice knows when to enter and when to rest.

5. **Files are a sealed garden.** Mantra keeps the append-only log, and
   Amphora seals it in layers. A record that stays exactly as written is a
   record everyone can trust.

6. **Networks are rivers.** Comlink carries sealed datagrams between machines,
   and the Noise XX handshake proves each side's identity before a word is
   exchanged. Blake2s protects the wire. SHA3 protects the name.

7. **Identity is a treasure.** Kumara gives every person a key pair they
   generate themselves, with a name derived from their public key by SHA3-512.
   The name belongs to the person who holds the private key, and that
   ownership can be verified by anyone.

8. **The machine serves the ecology.** Whole-system thinking, biocyclic vegan
   agriculture, and a faithful record of what happens on the land. The
   technology is a tool, and the soil is what matters.

9. **What you own, you can fix.** Open source, named errors, bounded
   complexity, and the civic duty of building things a person can understand
   and repair.

10. **This stage** -- the vision that holds all nine together.

## The picture

Imagine a small cooperative farm. Five families work the land together. They
grow vegetables, tend fruit trees, and build soil with compost and cover crops.

Each family has a Grain machine -- a small, quiet computer about the size of a
book, running on solar power and a battery. The machine runs the seL4 kernel,
Caravan manages its processes, Mantra keeps its logs, and Amphora seals them.

The five machines talk to each other over Comlink, forming a small network --
a **Pond**. Each family has a Kumara identity, a key pair they generated
themselves. When Maria sends a message to David, her machine signs it with her
private key, seals it into a Comlink datagram, and sends it across the Pond.
David's machine verifies Maria's signature, opens the datagram, and delivers
the message.

The cooperative's records -- planting dates, soil tests, harvest weights, costs,
sales -- live in Mantra on every machine, replicated across the Pond. Amphora
seals them daily, weekly, and monthly. Five years from now, anyone can verify
that the records are exactly as they were written, because the seals are
mathematical proofs rather than promises.

Dimeroll tracks the money. The cooperative knows exactly what it spends on seed,
compost, and labor, and exactly what it earns at market. The numbers are real
because the log is faithful.

And every piece of this -- the kernel, the supervisor, the log, the seals, the
wire, the identity, the ledger -- is open source. If the cooperative's machines
need a change, a local technician can read the source, understand the design
(because the comments say why), make the change, run the witness, and deploy it.

The cooperative owns its machines, its records, its identity, and its tools.
That is the technical vision of Grain: **a personal machine that belongs to the
person who runs it, serves the ecology it lives in, and can be understood and
repaired by anyone with the will to learn.**

## Something to try

Draw a picture -- on paper, on a whiteboard, on a tablet -- of a small network
of five machines. Label each one with a family name. Draw lines between them
for the Comlink connections. Draw a small tree on each machine for the kernel
and Caravan. Draw a book on each for the Mantra log and an amphora beside it
for the seals. Draw a key for Kumara.

Then look at the picture and ask: what is missing? What would you add? What
would you change?

The answer is yours, and the source code is open. The ten stages gave you the
vocabulary. The building is yours to begin.

---

*May the front door stay plain and glad, so that everyone who finds it feels
welcome and everyone who walks through it finds something worth keeping. The
machine belongs to the person who runs it, the record to the person who wrote
it, and the harvest to the soil that grew it.*
