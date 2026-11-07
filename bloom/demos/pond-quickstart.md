# Pond/Puddle Quickstart

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page explains what Pond is, what a Puddle is, and how fourteen
galaxies on a local network find each other, exchange messages, and
agree on shared facts. There is no code to run yet -- this is a
teaching document that makes the concepts concrete using the fourteen
plant-named galaxies from the [Galaxy Registry](galaxy-registry.md).

## What Pond is

Pond is Grain's peer-to-peer network layer. The name comes from a
simple image: many grains of sand beside water make a pond. Many Grain
machines beside a network make a Pond.

A Pond is the full network -- every Grain machine that can reach every
other. In a Pond, each node holds its own data, signs its own facts,
and talks directly to its peers. There is no central server that
everyone depends on. If one machine goes offline, the rest continue.

Pond is built from three pieces that you have already met in the
curriculum:

- **Comlink** handles the wire protocol -- how two machines open a
  sealed channel and exchange packets
- **Mantra** handles the log -- what each machine remembers and how
  it proves its memory is intact
- **Kumara** handles identity -- who each machine is and how it proves
  its name

## What a Puddle is

A Puddle is a small test Pond -- a pond that fits in your hand. It
runs on a local network (the machines on your desk, or a set of
virtual machines on one computer) and uses the same protocols as a
full Pond, only smaller.

A Puddle is useful for learning, testing, and developing. Everything
you learn on a Puddle applies to a full Pond, because the software
is the same. The only difference is size.

## The fourteen-galaxy Puddle

Imagine fourteen machines on a local network. Each one runs Grain and
holds one of the fourteen placeholder galaxies:

```
Local network (one room, one switch, fourteen machines)

  ~sunflower  ~rosemary  ~lavender  ~basil
  ~chamomile  ~oregano   ~thyme     ~sage
  ~mint       ~fennel    ~marjoram  ~tarragon
  ~chive      ~dill
```

Each machine knows its own galaxy name, holds its own private key,
and can sign messages that any other machine can verify.

## What happens when the Puddle boots

### Step 1 -- ~sunflower seeds the network

`~sunflower` is the seed galaxy. It boots first and begins listening
for other galaxies. It holds the initial list of who is allowed to
join -- in a fourteen-galaxy Puddle, that list contains all fourteen
names.

When `~sunflower` starts, it:

1. Generates its Ed25519 keypair (or loads one it already has)
2. Signs a genesis fact: "I am `~sunflower`, and this Puddle begins now"
3. Writes that fact into its Mantra log
4. Opens a Comlink listener on the local network

At this point, the Puddle has one galaxy and one fact.

### Step 2 -- ~basil joins

`~basil` boots and looks for a seed galaxy on the local network.
It finds `~sunflower` and opens a Comlink channel:

1. `~basil` and `~sunflower` perform a Noise handshake -- a
   cryptographic protocol that gives both sides a shared secret
   without either one sending a password in the clear
2. `~basil` presents its public key and says: "I am `~basil`,
   and I would like to join"
3. `~sunflower` checks the list, finds `~basil`, and signs a fact:
   "`~basil` has joined the Puddle"
4. Both galaxies write that fact into their Mantra logs

Now the Puddle has two galaxies, and both of them agree on two facts:
the genesis and the join.

### Step 3 -- ~lavender relays

`~lavender` joins the same way `~basil` did. Once it is part of the
Puddle, it takes on a special role: relaying messages between galaxies
that cannot reach each other directly.

Imagine that `~chamomile` and `~oregano` are on opposite sides of the
room and their network cables do not cross. `~lavender` sits between
them and can reach both. When `~chamomile` sends a message to
`~oregano`, `~lavender` receives it, verifies the signature, and
forwards it. The message is still signed by `~chamomile` -- `~lavender`
carries it without changing it, the way a postal worker carries a
sealed letter.

### Step 4 -- all fourteen join

One by one, the remaining galaxies boot, handshake with a galaxy
already in the Puddle, and join. After all fourteen have joined:

- Every galaxy holds a Mantra log with the same facts
- Every galaxy can send a signed message to any other galaxy
- Every galaxy can verify that a message really came from who it
  claims to come from

The Puddle is alive.

## What the Puddle can do

With all fourteen galaxies running, the Puddle can demonstrate every
layer of Grain's network:

- **Identity** -- `~rosemary` generates keys and `~basil` verifies
  a signature (see [Kumara Identity](kumara-identity.md))
- **Communication** -- `~lavender` relays a sealed message between
  `~chamomile` and `~oregano` (see [Comlink Session](comlink-session.md))
- **Consensus** -- all fourteen vote on a shared fact
  (see [Mycelium and MUR](mycelium-mur-design.md))
- **Transactions** -- `~sunflower` sends 100 MUR to `~basil`
  (see [MUR Token Demo](mur-token-demo.md))
- **Social** -- `~marjoram` posts a message and `~tarragon` follows
  (see [Surf Social Walkthrough](surf-social-walkthrough.md))

## Something to try

Draw the fourteen galaxies on a piece of paper, arranged in a circle.
Draw a line from `~sunflower` to `~basil` (the first join). Then draw
a line from `~sunflower` to `~lavender` (the second join). Now imagine
`~lavender` drawing a line to `~chamomile` -- that is the relay path.
By the time all fourteen have joined, the circle is full of lines, and
every galaxy can reach every other through at most one relay.

---

*May the Puddle on your desk feel like a real network, because it is
one -- small enough to hold, honest enough to trust.*
