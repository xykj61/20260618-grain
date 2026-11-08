# Reading the Network Demos

**Style:** Teacher at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page explains how to read the nine network demo walkthroughs
on Bloom's demos shelf. It suggests an order, describes the
narrative style each demo uses, and names what you will understand
by the end.

## The suggested reading order

The demos build on each other. Reading them in this order gives
each page the foundation it needs:

1. **Galaxy Registry** -- Meet the fourteen placeholder galaxies
   and learn why their names are safe to copy. Every other demo
   refers to these galaxies by name, so this page is the one to
   read first.

2. **Pond/Puddle Quickstart** -- Learn what Pond is (the
   networking layer) and what a Puddle is (a small test network).
   This page explains how galaxies discover each other and form
   a connected mesh.

3. **Kumara Identity** -- Understand keypairs, digital signatures,
   and the three hash algorithms Grain uses. Identity is how
   galaxies prove who they are, and every layer above it depends
   on this proof.

4. **Blake2s vs SHA3 Evaluation** -- An honest comparison of
   Grain's two hash algorithms. This page explains why Grain
   uses two rather than one, and what each one is good at.

5. **Comlink Sessions** -- See how two galaxies open an encrypted
   channel. This page walks through the Noise handshake that
   protects every message on the network.

6. **Mycelium and MUR Consensus** -- Learn how the network agrees
   on the state of the world. This page introduces the consensus
   protocol and the MUR token that measures participation.

7. **MUR Token Transfer** -- Follow five transfer scenarios across
   the fourteen galaxies. This page shows what happens when tokens
   move, including multi-hop relays and split-and-rejoin.

8. **Surf Social Design** -- Meet the social surface that sits on
   top of the network: posts, feeds, comments, and moderation.

9. **Surf Social Walkthrough** -- Spend a narrative day on the
   network, from morning posts to evening moderation, and see how
   the social layer uses everything the earlier demos introduced.

## The narrative style

Each demo is written as a walkthrough rather than a reference. It
describes what happens step by step, in the order it happens. When
a demo says "`~sunflower` boots and seeds the network," it is
telling a story: this galaxy did this thing, and here is what
happened next.

This style means you can read each demo like a short chapter in a
book. The characters are the fourteen galaxies. The plot is the
network coming to life. By the time you finish the last demo, you
have watched the network boot, agree, transact, and socialize --
all in your imagination, all safe to copy.

## You do not need to read them all

If you are interested in identity and cryptography, read the
Galaxy Registry, Kumara Identity, and the Blake2s evaluation.
If you care about consensus and tokens, read Mycelium and the
MUR Transfer demo. If you want to see the social layer, start
with Surf Social Design.

Every demo names the pages it builds on, so you can always go
back for a foundation you missed.

## Something to try

Read the Galaxy Registry and then jump to the MUR Token Transfer
demo. Notice that the transfer scenarios mention galaxies you
already met in the registry. That recognition -- "I know who
`~basil` is" -- is exactly what reading the registry first gives
you.

---

*May these nine walkthroughs read like a story worth finishing,
and may the network they describe feel ready to meet you halfway.*
