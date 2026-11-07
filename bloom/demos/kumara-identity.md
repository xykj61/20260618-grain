# Kumara Identity

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page explains how identity works in Grain: what a keypair is,
how a galaxy proves it is who it says it is, and how other galaxies
verify that proof. It walks through `~rosemary` generating a keypair,
signing a message, and `~basil` verifying the signature. It also
introduces the three hash algorithms Grain uses, and why each one was
chosen for its particular job.

## What Kumara is

Kumara is Grain's identity and naming system. The name comes from the
sweet potato -- kumara in te reo Maori -- because a sweet potato is a
root that stores well. Identity is the root of trust in a network, and
it needs to store well too: a key generated today must still work years
from now, on hardware that does not exist yet.

Kumara answers one question: **how does a machine prove it is who it
claims to be, without asking anyone's permission?**

## What a keypair is

A keypair is two numbers that are mathematically related:

- **The private key** is a number you keep secret. It lives on your
  machine and never leaves. Think of it as a wax seal that only you
  own.
- **The public key** is a number you share with everyone. It is
  derived from the private key, yet knowing the public key does not
  reveal the private key. Think of it as the pattern in the wax --
  anyone can look at it and confirm that only your seal made it.

In Grain, every galaxy holds one Ed25519 keypair. Ed25519 is a
specific signing algorithm built on Curve25519, designed by Daniel
Bernstein and implemented in Grain through Monocypher -- a small,
auditable cryptography library that fits in a few thousand lines of C.

## How signing works

When `~rosemary` wants to prove that a message came from her, she
signs it:

1. `~rosemary` writes a message: "The soil test results are ready"
2. `~rosemary`'s software takes the message and the private key, and
   runs them through the Ed25519 signing function
3. The result is a **signature** -- a 64-byte number that is unique to
   this exact message and this exact private key

The signature is attached to the message and sent to whoever needs it.

## How verification works

When `~basil` receives the signed message, she verifies it:

1. `~basil` takes the message, the signature, and `~rosemary`'s
   public key
2. `~basil`'s software runs them through the Ed25519 verification
   function
3. The function answers yes or no: did `~rosemary`'s private key
   produce this signature for this exact message?

If the answer is yes, `~basil` knows two things:

- The message really came from `~rosemary` (because only `~rosemary`
  has the private key that could produce that signature)
- The message has not been changed since `~rosemary` signed it
  (because changing even one letter would make the signature invalid)

If the answer is no, `~basil` rejects the message. Something is wrong
-- either the message was tampered with, or someone is pretending to
be `~rosemary`.

## A walkthrough with ~rosemary and ~basil

Here is how the identity exchange plays out on the Puddle:

```
~rosemary                               ~basil
---------                               ------
1. Generate keypair
   private key -> stays on ~rosemary
   public key  -> shared with everyone

2. Write message:
   "The soil test results are ready"

3. Sign the message
   sign(message, private_key) -> signature

4. Send message + signature    -------->

                                        5. Receive message + signature

                                        6. Look up ~rosemary's public key

                                        7. Verify
                                           verify(message, signature,
                                                  public_key) -> yes

                                        8. Trust the message
```

Every fact in a Mantra log is signed this way. Every message on a
Comlink channel is signed this way. Identity runs through everything.

## The three hash algorithms

A hash algorithm takes any amount of data and produces a fixed-size
fingerprint. If even one bit of the data changes, the fingerprint
changes completely. Grain uses three hash algorithms, each chosen for
a specific job:

### SHA3 -- for identity

SHA3 (also called Keccak) is the hash algorithm used in Kumara for
identity. It was selected by NIST (the United States National Institute
of Standards and Technology) after a public competition that ran from
2007 to 2012. It is well-studied, widely implemented, and considered
the strongest general-purpose hash available today.

Grain uses SHA3 wherever the stakes are highest: hashing public keys,
deriving addresses, and computing identity fingerprints. The cost is
speed -- SHA3 is slower than some alternatives on constrained hardware.
Identity operations happen infrequently (once at boot, once at key
rotation), so the speed cost does not matter here.

### Blake2s -- for the wire protocol

Blake2s is a fast hash algorithm designed for small hardware. It was
created by Jean-Philippe Aumasson and colleagues, building on the
design of ChaCha (another Bernstein algorithm). Grain uses Blake2s in
the Comlink wire protocol, where packets arrive hundreds of times per
second and each one needs a quick integrity check.

Blake2s produces a 256-bit hash and runs roughly twice as fast as SHA3
on RISC-V hardware. Speed matters on the wire because a slow hash
becomes a bottleneck that limits how many messages the network can
carry.

### djb2 -- for Mantra state hashes

djb2 is a simple, fast hash created by Daniel Bernstein. It is not
cryptographically strong -- it is easy to find two inputs that produce
the same hash. Grain uses djb2 only inside Mantra, for computing state
hashes that verify whether two nodes agree on the same log contents.

The choice is deliberate: Mantra state hashes are checked between nodes
that have already verified each other's identity with SHA3 and are
communicating over a Blake2s-checked wire. The state hash does not need
to resist an attacker -- it only needs to detect an honest disagreement
quickly. djb2 does that in a few instructions, which matters when the
log holds thousands of entries.

## Why three rather than one

A single hash algorithm would be simpler. Grain uses three because each
job has different requirements:

| Job | Requirement | Algorithm |
|---|---|---|
| Identity | Strongest standard, resistance to all known attacks | SHA3 |
| Wire protocol | Speed on RISC-V, integrity check for every packet | Blake2s |
| State agreement | Speed on large logs, detect honest disagreement | djb2 |

Using SHA3 for the wire protocol would slow down every packet. Using
djb2 for identity would weaken the foundation. Using Blake2s for state
hashes would work, yet djb2 is simpler and the extra strength is not
needed. Three tools, three jobs, each matched to what the job actually
requires.

## Something to try

Imagine you are `~rosemary` and your friend is `~basil`. Write a short
message on a piece of paper. Now fold it in half and put a sticker on
the fold -- that sticker is your signature. Hand it to your friend. If
the sticker is intact and they recognize it as yours, the message is
verified. If the sticker is torn, something went wrong in transit.

That is the whole idea: a mark that only you can make, and anyone can
check.

---

*May the keys you hold stay strong, and may every signature you send
arrive whole on the other side.*
