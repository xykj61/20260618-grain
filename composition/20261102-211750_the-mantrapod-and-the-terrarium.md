# The Mantrapod and the Terrarium, side by side

**Stamp:** `20261102.211750`
**Voice:** Kyli
**Style:** Teacher Style, Door setting
**Status:** Living
**Room:** mixed -- reflection

---

One is hardware. The other is software pretending to be hardware. They are the same machine at two stages of the same argument, and the argument is: what happens when forgetting is a feature?

## The device

The Mantrapod is a pocket computer. Paper-like reflective screen, RAM only, one USB-C wire or none, open RISC-V processor, screwed together for repair. The price target is three hundred fifty to five hundred fifty dollars, which is the range where a person choosing carefully can reach it and a person choosing cheaply passes it by. That price is a filter on purpose: the device is for someone who has decided what they want from a computer, not for someone buying the default.

RAM only means everything you are working on lives in memory while the device is powered, and dissolves when the power goes away. A deliberate act -- a commit, a sync, a save through the one wire -- is what makes anything persist. The rest goes. Not because the device failed to save, and not because the user forgot to save, but because dissolving is what the hardware does, by design, the way a whiteboard erases.

The four trades are real trades, each with its honest cost:

- **Forgetting is privacy.** A device holding nothing by default has nothing to hand over. The cost: you must deliberately keep what matters.
- **One wire is clarity.** Connected or not connected is visible across a room. The cost: no wireless convenience.
- **Screws are repair.** Every part a person might replace comes apart with common tools. The cost: thicker, heavier, no glue elegance.
- **Open silicon is freedom.** The processor's design is published and a second source can fabricate it. The cost: slower than a proprietary chip at the same price.

Each trade is worth taking for someone, and not worth taking for everyone. The Mantrapod is not trying to be everyone's computer. It is trying to be someone's computer completely.

## The emulator

Terrarium is a browser tab. Inside it, a RISC-V emulator boots Caravan, the kernel, loads Steward, the root supervisor, and runs Grain userspace -- the same environment the Mantrapod will run on metal, faithfully reproduced in software. A living world under glass.

The glass is the point. A person who has never seen the hardware can open a browser, watch Steward read the Brix manifest, watch domains come up, watch capability leases count down, and see what forgetting looks like when it is working. The emulator does not approximate the device. It runs the same code, bounded by the same memory, executing the same single-stranded discipline -- one thread, one event at a time, the same TAME compass that governs everything else in this tree.

Terrarium is also the falsifier. The mikrophone waymark names the forgetting firmware, the "memory that forgets" session buffer: bounded capture held only while powered, persisted only on a deliberate commit, provably dissolved on power-down. If people using Terrarium find the deliberate act of keeping something too tedious, the premise fails at the ergonomic level. That failure is discovered in a browser tab, before anyone has paid for a circuit board. The honest response to a failed premise is to write it down, not to build the board anyway.

## Where they meet

The green line between the two is Mantra. The Mantrapod's RAM holds Mantra facts -- signed, append-only, replayable. A sync through the one wire appends those facts to a pier. Terrarium's emulated RAM holds the same Mantra facts, and a sync from the browser does the same thing. The facts are the same shape, the replay is deterministic, and the two environments produce identical projections from identical logs.

That is where the single-stranded principle earns its keep. One thread of execution means the replay is deterministic without locks, without coordination, without the class of errors that comes from two things happening at the same time. The Mantrapod forgets and the Terrarium forgets, and when either one syncs, the facts that were deliberately kept produce the same state on the pier. Not "compatible state." The same state, field for field, provable by replaying the log.

## What each one teaches the other

The Mantrapod teaches the Terrarium what matters. Real hardware has a power budget, a screen that refreshes slowly, a user who puts the thing in a pocket and walks away. A Terrarium that runs beautifully in a browser but would drain a battery in twenty minutes has learned the wrong lessons. So the emulator's memory bound matches the device's. The emulator's event rate matches the device's. The glass shows a world that could be real, and the constraint is what makes that promise honest.

The Terrarium teaches the Mantrapod what works. Before a board is fabricated, a thousand people can try the interface, find the moment where forgetting is annoying rather than freeing, and write that down. The firmware gets proven in software first. The Steward's capability leases get tuned. The Brix manifest gets simplified. All of that learning happens inside a browser, and none of it costs a circuit board.

## Side by side

The device that forgets and the glass that shows forgetting. The metal that someone will hold and the browser that everyone can open. One is expensive to build and cheap to copy; the other is cheap to build and free to share. They are two sides of the same argument, and the argument is that a computer built around forgetting gives its user something no computer built around remembering can: the certainty that what is gone is gone, and what remains was chosen.

---

*May the glass stay clear and the metal stay honest, each one making the other more worth building.*
