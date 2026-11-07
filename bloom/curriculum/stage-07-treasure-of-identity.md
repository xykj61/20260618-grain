# Stage 7 -- Treasure of Identity

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this stage teaches

Identity is the answer to the question: **who are you, and how do I know it
is really you?**

On the internet as most people use it today, identity is borrowed. You sign
up for an account on someone else's server, they give you a username and
password, and they can take it away, change the rules, or close the service
whenever they choose. Your name belongs to them, not to you.

In Grain, identity works differently. Your name belongs to you, proven by a
key that only you hold, and nobody -- not the network, not a company, not the
operating system itself -- can take it from you or speak as you without that
key.

The system that handles identity in Grain is called **Kumara**.

## Keys and signatures

The foundation of owned identity is a pair of numbers called a **key pair**.
One number is the **private key** -- you keep this secret and never share it.
The other is the **public key** -- you give this to everyone who needs to
know who you are.

The two keys are linked by mathematics: a message signed with the private key
can be verified by anyone holding the public key, yet the public key reveals
nothing about the private key. This is called **asymmetric cryptography**,
and it is the same principle that protects online banking, encrypted email,
and secure websites.

In Grain, key pairs are generated using **Monocypher**, which is an
implementation of the Ed25519 signature scheme -- the same scheme used by
many security-critical projects, chosen because it is fast, well-studied, and
fits on small hardware.

When you sign a message, you are placing a seal that says: "This message came
from the person who holds this private key." Anyone can verify the seal by
checking it against your public key. If the seal checks out, the message is
authentic. If it does not, the message was either forged or tampered with.

## Kumara naming

Kumara gives every identity on the network a name that is derived from the
identity's own public key. Here is how it works:

1. Generate a key pair (private and public).
2. Run **SHA3-512** over the public key. SHA3-512 is a hash function from
   the SHA3 family -- the same family Stage 6 mentioned for permanent names.
   The "512" means it produces a 512-bit hash, which is 64 bytes.
3. The resulting hash becomes the basis of your network name.

Because the name is derived from the key, and the key belongs to you alone,
the name belongs to you alone. Two different keys will always produce two
different names. And because SHA3-512 is a one-way function, nobody can work
backward from your name to your key.

This is **self-sovereign identity**: you own your name because you own your
key, and you own your key because nobody else has ever seen it.

## Why SHA3 for identity

Stage 6 explained that Grain uses Blake2s inside the Noise handshake for its
speed on small hardware. Identity uses a different hash -- SHA3 -- for a
different reason:

- **Permanence.** A network name lasts as long as the network exists. It is
  written into logs, sealed into vessels, and stored by every machine that
  has ever spoken with you. The hash that produces it must be one the world's
  cryptographers have studied deeply and endorsed formally.

- **NIST standardization.** SHA3 was selected through a public competition
  that ran from 2007 to 2012 and drew entries from cryptographers around the
  world. The winner, Keccak, became the SHA3 standard. That process is a
  form of trust that no single project can earn on its own.

- **Independence from SHA2.** SHA3 is built on entirely different mathematics
  from the SHA2 family (which includes SHA-256). If a weakness is ever found
  in SHA2's design, SHA3 is unaffected, and vice versa.

Blake2s is excellent at what it does -- fast wire hashing on small hardware.
SHA3 is excellent at what it does -- permanent, independently verified,
standards-track naming. Each serves where it is best.

## The two tiers

Grain organizes its hashing into two tiers:

- **SHA3-512** for canonical, forever names -- the kind of name that Kumara
  generates. These names outlive any single machine or session.

- **SHA3-256** for working storage -- the hashes inside a Mantra log or an
  Amphora seal. These hashes are verified often and need to be compact, yet
  they still benefit from SHA3's design strength.

Where an external protocol fixes the hash choice -- such as Blake2s in the
Noise handshake, or SHA-256 in a compatibility layer -- Grain uses what the
protocol requires and names the reason.

## Something to try

Write your full name on a piece of paper. Now imagine that this is the only
copy of your name in the world -- nobody else has it written anywhere, and if
you lose it, you lose your name.

That is what a private key feels like. It is a piece of information that
proves who you are, and it works only because you are the only one who has
it. Keep it safe, the way you would keep the only copy of something
irreplaceable.

In the next stage, we will look outward -- at the ecology that a machine
serves, the soil it helps tend, and the living systems it is part of.

---

*A name that belongs to you because of what you hold, rather than what someone
granted, is a name that lasts as long as you keep it. That is the treasure
Kumara guards.*
