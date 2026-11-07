# Blake2s vs SHA3 -- An Honest Evaluation

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this essay teaches

This essay compares two hash algorithms -- SHA3 and Blake2s -- and
explains why Grain uses both rather than picking one. It is written for
a reader who may not have chosen a hash algorithm before and deserves
to understand the trade-offs honestly, without being told that one is
simply "better." It also introduces djb2, a simpler third algorithm
that serves a narrower purpose.

## What a hash algorithm does

A hash algorithm takes any amount of data -- a single word, a whole
book, a farm's daily transaction log -- and produces a fixed-size
fingerprint. Two properties make this useful:

1. **The same input always produces the same fingerprint.** If you hash
   "hello" today and hash "hello" tomorrow, you get the same result.
2. **A tiny change in the input produces a completely different
   fingerprint.** Changing "hello" to "hallo" produces a fingerprint
   that looks nothing like the first one.

These two properties let you verify data without reading every byte:
hash it, compare the fingerprint to the one you expected, and you know
whether anything changed.

## SHA3 -- the standard

SHA3, also called Keccak, is a hash algorithm that won a public
competition run by NIST (the United States National Institute of
Standards and Technology). The competition began in 2007, received 64
submissions, and ended in 2012 when Keccak was selected after five
years of public analysis.

**Strengths:**

- **Well-studied.** Hundreds of cryptographers have analyzed SHA3 over
  more than a decade. No practical attack has been found.
- **Standard.** NIST standardization means SHA3 is accepted by
  governments, financial institutions, and security auditors worldwide.
- **Internal structure.** SHA3 uses a sponge construction, which is
  fundamentally different from the Merkle-Damgard structure used by
  SHA-1 and SHA-2. This means that a breakthrough against SHA-2 would
  not automatically break SHA3.

**Trade-offs:**

- **Slower on small hardware.** SHA3's sponge construction requires
  more memory and more operations per byte than some alternatives.
  On a RISC-V processor running at modest clock speeds, this matters.
- **Larger state.** SHA3-256 uses a 1,600-bit internal state, which
  is comfortable on a desktop processor and tight on a microcontroller.

## Blake2s -- the fast one

Blake2s is a hash algorithm designed by Jean-Philippe Aumasson, Samuel
Neves, Zooko Wilcox-O'Hearn, and Christian Winnerlein. It builds on
the ChaCha stream cipher designed by Daniel Bernstein, and it was
created specifically for speed on small hardware.

**Strengths:**

- **Fast on RISC-V.** Blake2s runs roughly twice as fast as SHA3 on
  the same constrained hardware. For a wire protocol that hashes every
  packet, this difference is the difference between keeping up and
  falling behind.
- **Small state.** Blake2s uses a 256-bit internal state, which fits
  easily in the registers of a 32-bit RISC-V processor.
- **Simple.** The algorithm is straightforward to implement and
  audit. Fewer moving parts mean fewer places for a mistake.

**Trade-offs:**

- **Not a NIST standard.** Blake2s is widely respected in the
  cryptography community, yet it does not carry the institutional
  weight of a NIST selection. An auditor who requires NIST-approved
  algorithms will accept SHA3 and may question Blake2s.
- **Less public analysis than SHA3.** Blake2 has been studied
  extensively, yet SHA3's five-year public competition produced a
  larger body of third-party analysis.

## The comparison

| Property | SHA3-256 | Blake2s |
|---|---|---|
| Standard body | NIST (US federal standard) | Community (RFC 7693) |
| Internal structure | Sponge (Keccak) | ARX (ChaCha-based) |
| Output size | 256 bits | 256 bits |
| Internal state | 1,600 bits | 256 bits |
| Relative speed on RV64 | 1x (baseline) | Roughly 2x |
| Use in Grain | Kumara identity: keys, addresses, fingerprints | Comlink wire: packet integrity, channel binding |
| When it runs | Once at boot, once at key rotation | Hundreds of times per second |

## Why Grain uses both

The answer comes from matching the algorithm to the job:

**Identity needs the strongest standard.** A galaxy's keypair may last
for years. The hash that derives its address will be checked by every
node that ever verifies a signature from that galaxy. This is the place
where the strongest, most-studied algorithm belongs, even if it is
slower. SHA3 serves this job.

**The wire protocol needs speed on constrained hardware.** Comlink
hashes every packet that crosses the wire. On a RISC-V board running
at 1.5 GHz -- the kind of machine a small farm can afford -- a slow
hash becomes a bottleneck. Blake2s keeps the wire moving.

Neither algorithm is "better." Each is better at its own job. Using
SHA3 for the wire would slow every packet. Using Blake2s for identity
would trade institutional trust for speed that identity does not need.

## djb2 -- the third algorithm

Grain uses a third hash algorithm, djb2, in one specific place: Mantra
state hashes. djb2 is a simple hash created by Daniel Bernstein. It
runs in a few instructions and produces a 32-bit or 64-bit hash.

djb2 is not cryptographically strong. It is easy to find two inputs
that produce the same hash. Grain uses it anyway, because Mantra state
hashes serve a narrow purpose: detecting whether two nodes that have
already verified each other's identity (with SHA3) and are already
communicating over a verified wire (with Blake2s) agree on the same
log contents.

The state hash does not need to resist an attacker. It only needs to
detect an honest disagreement -- two nodes whose logs have drifted
apart -- and djb2 does that quickly.

| Algorithm | Cryptographic strength | Speed | Use in Grain |
|---|---|---|---|
| SHA3 | Strongest (NIST standard) | Moderate | Identity |
| Blake2s | Strong (community standard) | Fast | Wire protocol |
| djb2 | Not cryptographic | Fastest | State agreement only |

## The lesson

Choosing a hash algorithm is not about finding the "best" one. It is
about understanding what each job requires and matching the tool to the
requirement. Security where security matters (SHA3 for identity). Speed
where speed matters (Blake2s for the wire). Simplicity where simplicity
is enough (djb2 for state checks).

A system that uses one algorithm everywhere pays a tax somewhere: too
slow on the wire, or too weak at the foundation. Three tools, matched
to three jobs, let each job be served by what it actually needs.

## Something to try

Think about the locks in a building. The front door has a heavy
deadbolt -- that is SHA3. The internal office doors have quick-turn
handles -- that is Blake2s. The bathroom door has a simple latch that
tells you whether someone is inside -- that is djb2. Each lock matches
the level of security the door actually needs. What would happen if
every door had a deadbolt? What would happen if the front door had
only a latch?

---

*May every algorithm you choose serve the job it was given, and may the
choice be honest about what each one costs.*
