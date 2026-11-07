# Comlink Sessions -- How Two Machines Talk to Each Other

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page explains how two machines on a Grain network establish a secure
conversation. You will learn what Comlink is, how a session begins with a
cryptographic handshake, and how two galaxies exchange messages that only
they can read.

## What Comlink is

Comlink is Grain's wire protocol -- the set of rules two machines follow
when they talk to each other. The name says what it does: it is a link
for communication.

Every conversation on a Grain network passes through Comlink. When
~sunflower wants to send a message to ~basil, Comlink handles the
introduction, the encryption, and the delivery. The two machines do not
need to trust the network between them -- they only need to trust each
other, and Comlink gives them the tools to verify that trust.

## How a session begins

Before two galaxies can exchange any meaningful data, they perform a
Noise handshake. Noise is a well-studied cryptographic framework for
building encrypted channels. Here is what happens, step by step:

1. **~basil initiates.** It sends a hello message to ~sunflower,
   including its ephemeral public key -- a temporary key generated
   just for this session.

2. **~sunflower responds.** It sends back its own ephemeral public key,
   and both sides now compute a shared secret that only they know.

3. **Identity verification.** Each galaxy presents its Kumara identity --
   the long-term public key that says who they are on the network. Both
   sides check that the identity matches what they expect.

4. **The channel opens.** From this point forward, every message between
   ~basil and ~sunflower is encrypted with keys derived from that shared
   secret.

The entire handshake takes a fraction of a second. Once it completes,
the two galaxies hold a session -- an encrypted pipe through which they
exchange sealed datagrams.

## What the Noise handshake provides

The handshake gives three properties that matter to a farm cooperative:

- **Confidentiality.** Nobody between the two machines can read the
  messages. A relay galaxy like ~lavender passes the sealed bytes
  along without seeing what is inside.

- **Authentication.** Each side knows who it is talking to. ~basil
  knows it reached the real ~sunflower, not an impostor.

- **Forward secrecy.** Even if someone compromises a galaxy's long-term
  key in the future, past sessions stay private. The ephemeral keys
  used for each session are discarded after the session ends, so
  there is nothing left to decrypt old messages with.

## A simple exchange

Here is a concrete example. ~basil wants to record a sale of tomatoes
through ~sunflower, the seed galaxy that bootstraps the network:

1. ~basil and ~sunflower complete the Noise handshake (steps above).

2. ~basil composes a sealed datagram:
   ```
   type: transaction
   from: ~basil
   verb: sell
   subject: tomatoes
   amount: 24 crates
   ```

3. ~basil encrypts the datagram with the session key and sends it.

4. ~sunflower receives the sealed bytes, decrypts them with the same
   session key, verifies ~basil's Kumara signature on the transaction,
   and writes it to the local Mantra log.

5. ~sunflower sends back an acknowledgment datagram:
   ```
   type: ack
   ref: <hash of basil's transaction>
   status: recorded
   ```

6. ~basil receives the acknowledgment, verifies ~sunflower's signature,
   and marks the transaction as confirmed.

The whole exchange took two sealed datagrams. Both sides now hold the
same record of the sale, and nobody else on the network saw the contents.

## The transport underneath

In the current QEMU implementation, Comlink datagrams travel over UART --
the serial line between the emulated RISC-V processor and the host
machine. UART is simple and reliable, which makes it a good fit for
development and testing.

A real deployment would use TCP or UDP over a local network or the
internet. The Comlink protocol does not depend on the transport -- it
seals and unseals datagrams the same way whether they travel over a
serial wire, a Wi-Fi link, or an undersea cable. The transport carries
the bytes; Comlink protects them.

## Something to try

Think of two devices in your own life -- a phone and a laptop, or two
computers on the same network. Imagine them performing the Noise
handshake: each one generates a temporary key, they exchange keys, and
from that point on every message between them is encrypted. What changes
about the way those devices could talk to each other if nobody between
them could read the messages?

---

*May every message you send arrive safely, and may every conversation
you hold belong to you and the person you are speaking with.*
