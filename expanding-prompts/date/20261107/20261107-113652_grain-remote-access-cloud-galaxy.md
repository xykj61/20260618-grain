# Grain Remote Access -- Cloud Galaxy via Kumara and Comlink

**Stamp:** `20261107.113652`
**Language:** EN
**Style:** Gauge at Field, with Radiant warmth
**Voice:** Kyri
**Status:** Proposed
**Room:** vision
**Depends on:** Mantra SLC Comlink Realidream (M1-M15) completing first

---

## Vision

A Grain galaxy runs on a cloud server -- the Vultr Dallas pier today -- and holds
its own Mantra state, Amphora sealed vessels, and Bloom content. A local macOS
native application connects to it securely through Kumara identity and Comlink,
and the user interacts with the remote galaxy's data through the local glass:
requesting pages, writing transactions, reading state. The wire between local
and cloud is Grain's own protocol, built on the same primitives the SLC already
proved on localhost.

The elder inspiration is Urbit's fake galaxy flag (`-F`), where a deterministic
identity runs for development. Here, `~sunflower` or `~siya` runs on the cloud
server with a known Kumara seed, and the local app addresses it by name and
verifies its public key. The difference: Grain's identity is Ed25519 via Kumara
rather than Azimuth on Ethereum, and the transport is Comlink UDP rather than
Ames.

## The three problems, and our own names for them

SSH, Mosh, and SCP each solve a real problem. Grain solves the same problems
with its own primitives and its own names, so a user never confuses these with
the Unix implementations they resemble.

| Problem | Unix tool | Grain name | What it does |
|---|---|---|---|
| Encrypted channel between two identities | SSH | **Strand** | Kumara key exchange, encrypted Comlink channel with forward secrecy |
| Persistent session that survives roaming | Mosh | **Tether** | UDP session resumption between local and cloud galaxy, survives IP changes |
| Content transfer between galaxies | SCP | **Ferry** | Mantra-addressed content transfer -- pages, vessels, state snapshots |

**Strand** is the encrypted wire between two Kumara identities. It establishes
a shared secret via X25519 key exchange (Kumara already holds Ed25519 keys;
the conversion is standard), then encrypts Comlink frames with ChaCha20-Poly1305
or XSalsa20-Poly1305 (both already in Monocypher, vendored at `vendor/monocypher`).

**Tether** is the persistent session. Like Mosh, it uses UDP and a session token
so the connection survives WiFi-to-cellular roaming, laptop sleep, and IP changes.
Unlike Mosh, the session token is a Kumara-signed nonce rather than a Unix
process attachment.

**Ferry** is content transfer. It moves Mantra-addressed content (Bloom pages,
Amphora vessels, state snapshots) between galaxies over a Strand. It is not a
general file copy -- it transfers what Mantra names, and the receiver verifies
what Kumara signed.

## Vault revival

Vault (the sealed-secret store from earlier chapters) composes naturally: the
cloud galaxy's Amphora vessels are sealed, and Vault holds the decryption keys.
A Strand session authenticated by Kumara can request Vault-held secrets that
the local galaxy is authorized to see. This is the access-control layer above
the transport.

## The fake galaxy flag

A cloud galaxy runs with a deterministic identity for development:

```
grain-galaxy --fake ~sunflower --port 38481 --bind 0.0.0.0
```

The `--fake` flag generates the Kumara keypair from a well-known seed (the same
`0x01` x 32 that `~sunflower` already uses in the test galaxies), so the local
app can verify the server's identity without a key exchange ceremony. In
production, the seed comes from Vault.

## Architecture

```
Local macOS app                      Cloud server (Vultr Dallas)
+------------------+                 +------------------+
|  Terrarium       |                 |  ~sunflower      |
|  (native glass)  |   Strand        |  (Grain galaxy)  |
|                  | <=============> |                  |
|  ~siya identity  |   Tether        |  Mantra state    |
|  Kumara keypair  |   (UDP)         |  Amphora vessels |
|  Comlink client  |                 |  Bloom content   |
|                  |   Ferry         |  Comlink server  |
+------------------+                 +------------------+
```

The local app acts on behalf of `~siya`, requesting content from `~sunflower`
and the other galaxies that `~sunflower` federates with. The user sees Bloom
pages, not wire frames.

## Gratitude -- permissive sources to study

| Project | License | What we study |
|---|---|---|
| **Monocypher** | CC0 / BSD-2-Clause | Already vendored. X25519, ChaCha20-Poly1305, Ed25519-to-X25519 conversion |
| **libsodium** | ISC | Sealed box pattern, key exchange, AEAD constructions |
| **Mosh** (MIT) | MIT | UDP session resumption, state synchronization protocol, roaming design |
| **Dropbear** | MIT | Minimal SSH server implementation patterns, key exchange |
| **TinySSH** | Public domain | Minimal SSH with NaCl/TweetNaCl, no legacy crypto |
| **Zig stdlib crypto** | MIT | X25519, ChaCha20, Poly1305 -- already in our compiler |

All permissive. The clean-room discipline holds: we study concepts and write our
own Rye implementations. Monocypher is already vendored and proven (Amphora uses
it for Kumara signing).

## Movements (proposed, 15 movements in 3 phases)

### Phase 1 -- Strand encrypted channel (movements 1-5)

1. **X25519 key exchange witness:** Kumara Ed25519 keys convert to X25519, two
   galaxies derive a shared secret. Prove on localhost.
2. **AEAD frame encryption:** Comlink frames encrypted with ChaCha20-Poly1305
   using the shared secret. Prove round-trip on localhost.
3. **Strand handshake protocol:** Initiator sends ephemeral X25519 public key,
   responder replies, both derive session keys. Prove mutual authentication.
4. **Strand over real UDP:** Same handshake and encryption over a real network
   socket rather than localhost loopback. Prove on two processes.
5. **Strand witness:** End-to-end encrypted Comlink content request over Strand.
   Siya requests a page from sunflower, wire is encrypted, content matches.

### Phase 2 -- Tether persistent session (movements 6-9)

6. **Session token:** Kumara-signed nonce establishes a session. Prove token
   verification and replay rejection.
7. **UDP session resumption:** Client reconnects after simulated IP change
   (rebind to different local port). Prove content delivery continues.
8. **Tether heartbeat and timeout:** Bounded keepalive, session expires after
   configurable silence. Prove timeout and reconnection.
9. **Tether witness:** Full persistent session -- connect, transfer, simulate
   roaming, reconnect, continue transfer. All content verified.

### Phase 3 -- Ferry content transfer and cloud deployment (movements 10-15)

10. **Ferry protocol:** Named content transfer -- request a Mantra path, receive
    verified content. Prove Amphora vessel transfer with seal verification.
11. **Fake galaxy server:** `grain-galaxy --fake ~sunflower` serves Bloom
    content and Mantra state over Strand. Prove on localhost.
12. **Cloud deployment:** Deploy fake galaxy to Vultr Dallas. Prove Strand
    connection from local machine to cloud.
13. **Terrarium integration:** macOS native app connects to cloud galaxy via
    Strand, requests Bloom pages, renders in glass. Wire invisible to user.
14. **Multi-galaxy federation:** Cloud sunflower federates with local rosemary,
    oregano, thyme. Siya requests from any through sunflower as relay.
15. **Final witness:** Full stack -- local Terrarium app connects to cloud
    galaxy over Strand with Tether persistence, requests and renders all Bloom
    content from 4 galaxies, Vault-held keys authorize access, every page
    renders in the glass as if it were local.

---

## Sequencing recommendation

Complete the Mantra SLC Phase 3 (M11-M15: Caravan/Tally lowering for RISC-V)
first. That gives a proven freestanding stack the cloud galaxy eventually runs
on. Then open this as a new SLC on the Calfive stack, with the Comlink wire,
Kumara identity, and Mantra content from M1-M10 as its foundation.

---

*May the wire between two galaxies carry nothing the reader cannot verify, and
may the glass show what the glass has always shown -- the content, and only the
content.*
