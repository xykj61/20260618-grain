# The Home Forge

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

A home forge is a small, quiet computer that lives in your house and does
the heavy thinking your handheld device asks for. Instead of sending your
questions to a distant company's servers, the forge keeps everything
local -- your data stays yours, your records stay yours, and the answers
come from a machine you own.

This page explains what a home forge is, why it matters, and what it
needs to do its job well.

## Why a forge at home

When you ask a phone or a tablet to help you write, plan, or look
something up, the question usually travels across the internet to a
large data center. The answer comes back, yet the company running that
center now holds a copy of what you asked, and it decides what you pay
for the privilege.

A home forge changes that. It keeps the conversation inside your own
walls. The machine belongs to you, the records it keeps belong to you,
and nobody else sees what you asked or what it answered.

For a small farm, a community kitchen, or a household keeping its own
books, this means the forge can help with planning, record-keeping, and
learning without any of that information leaving home.

## What the forge needs

A home forge needs three things:

1. **Enough memory to hold a working model.** A language model -- the
   kind of program that reads and writes text -- needs room to think.
   Current open models that run well on a single machine ask for 64 to
   128 gigabytes of unified memory. A machine built around an AMD Strix
   Halo processor, for example, offers 128 gigabytes in a small, quiet
   box that fits on a shelf.

2. **Open firmware and drivers.** The programs that talk to the
   processor and the graphics chip should be ones you can read, verify,
   and update yourself. AMD's current Linux drivers and firmware tools
   are published openly, which means a community can inspect them and a
   household can update them without asking permission.

3. **A host system you can describe and rebuild.** The operating system
   running on the forge should be written down in a way that lets you
   rebuild it from scratch on new hardware. NixOS is one system that
   works this way -- you describe what you want in a file, and the
   system builds itself to match.

## How the forge fits the network

The forge does not work alone. It is one half of a two-part design:

- **The forge** stays at home. It runs the heavy work -- reading long
  documents, answering questions, keeping the household's signed records.
- **The handheld device** travels with you. It is light, simple, and
  connected to the forge by a sealed channel that carries your own key.

The handheld asks; the forge answers. The channel between them is
addressed by a key only you hold, so the conversation stays between your
hand and your home.

## What a forge is not

A forge is not a cloud service. It does not phone home, it does not
require a subscription, and it does not stop working when the internet
goes down. It is a machine on your shelf, running programs you chose,
keeping records you own.

It is also not a replacement for every service a household might use.
Some tasks genuinely need a connection to the wider world -- sending a
message to a neighbor, checking the weather, ordering supplies. The
forge handles what can stay local, and the network handles what cannot.

---

*May every household that wants one find a forge within reach.*
