# Stage 6 -- Rivers of Networks

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

A single machine keeps its own records, runs its own programs, and serves the
person in front of it. A network is what happens when two or more machines
decide to talk to each other -- sharing records, passing messages, and working
together on things no single machine could do alone.

In Grain, the system that handles communication between machines is called
**Comlink**. The name says what it does: it links the communication between
two points, the way a river links two villages.

## What a message is

A message is a piece of data sent from one machine to another. It has three
parts:

1. **The sender.** The machine (and the process on that machine) that created
   the message.
2. **The recipient.** The machine (and the process on that machine) that should
   receive it.
3. **The payload.** The actual data -- a log entry, a file, a question, an
   answer.

Comlink wraps every message in a sealed datagram. A datagram is a single
packet of data that carries its own addressing, the way a letter carries its
own envelope with the sender and recipient written on the outside. "Sealed"
means the datagram is protected so that nobody between the sender and the
recipient can read it or change it without the change being detected.

## The Noise handshake

Before two machines can send sealed messages, they need to agree on a shared
secret -- a key that both sides know and nobody else does. The process of
agreeing on this key is called a **handshake**.

Grain uses a handshake protocol called Noise. Noise is a well-studied,
publicly documented way for two machines to identify each other and establish
a shared secret over an untrusted network. The specific pattern Grain uses is
called **Noise XX**, which means both sides prove their identity to each
other during the handshake itself.

The handshake works in three messages:

1. The first machine sends a greeting that includes a fresh random number.
2. The second machine responds with its own fresh random number and proves
   it holds the key it claims.
3. The first machine proves it holds its key too.

After these three messages, both machines share a secret key that nobody who
listened to the handshake can reconstruct. Every message from that point
forward is encrypted with this key, so even if someone captures the data on
the wire, they see only scrambled bytes.

The handshake uses **Curve25519** for the key agreement (a widely trusted
algorithm designed by Daniel Bernstein), **ChaChaPoly** for the encryption
(fast and safe on small machines), and **Blake2s** for the internal hashing
(chosen specifically because it is efficient on 32-bit processors, the kind
of hardware a small farm or workshop is likely to have).

## Why Blake2s here, and SHA3 elsewhere

Grain uses two hash families, each where it fits best:

- **SHA3** is used for identity and permanent names (Stage 7 will explain
  this). SHA3 is a NIST standard -- reviewed by the world's cryptographers
  over many years -- and it is the right choice for things that must last
  forever: a person's name on the network, a sealed vessel in the archive.

- **Blake2s** is used inside the Noise handshake, where speed on small
  hardware matters. A handshake happens every time two machines connect, so
  the hash runs many times a day. Blake2s is designed to be fast on 32-bit
  processors while remaining safe, and the Noise protocol specifies it as a
  standard choice.

Two families, two purposes. Neither is better than the other in the abstract
-- each is best at its own job.

## Something to try

Send a letter to a friend -- a real letter, on paper, in an envelope. Write
your name and address in the top-left corner (the sender). Write their name
and address in the center (the recipient). Put your message inside (the
payload). Seal the envelope (the datagram seal).

When your friend receives the letter, they know who sent it (your handwriting
and return address), they know the envelope was not opened on the way (the
seal is intact), and they can read the message. That is what Comlink does,
at machine speed, many times a second.

In the next stage, we will look at identity itself -- how a machine and a
person are named on the network so that names cannot be forged or stolen.

---

*A river does not choose who drinks from it. A network that seals its messages
lets everyone drink in safety, and the water arrives as clean as it left.*
