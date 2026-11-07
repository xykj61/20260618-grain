# Mycelium Consensus -- How the Network Agrees

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page explains how galaxies in a Grain Puddle network reach
agreement about what happened and in what order. You will learn what
Mycelium is, what MUR tokens represent, and how a consensus round works
from proposal to commitment.

## What Mycelium is

Mycelium is Grain's consensus layer -- the part of the system that
ensures every galaxy in a Puddle agrees on the same history. The name
comes from the underground fungal network that connects trees in a
forest. In a real forest, mycelium threads carry nutrients and signals
between roots that cannot see each other. In a Grain network, Mycelium
carries agreement between galaxies that cannot trust each other's clocks
or memories.

Consensus means that all participants hold the same ordered list of
events. When ~basil records a sale and ~oregano records a harvest, every
galaxy in the Puddle agrees on which happened first. This matters
because the order of events determines the state of every account, every
inventory record, and every sealed vessel in the network.

## What MUR is

MUR stands for Mycelium Unit of Record. It is the network's own unit of
account -- a way to track who contributed what to the shared work of
keeping the network running.

A galaxy earns MUR by participating honestly in consensus rounds:
validating transactions, voting on proposals, and storing the shared
Mantra log. A galaxy that goes offline or submits false votes earns
nothing for that round. MUR is not money in the way a dollar or a euro
is money -- it is a record of contribution, like hours logged in a
cooperative's ledger.

The 14 galaxies in our demo Puddle each start with an equal allocation
of MUR. As they participate in consensus rounds, their balances shift
to reflect who has been doing the work of keeping the network honest.

## How a consensus round works

A consensus round is one cycle of proposing, checking, voting, and
committing. Here is how it unfolds across our 14 demo galaxies:

### Step 1 -- Proposal

~dill, the Mycelium consensus galaxy, proposes a state transition. A
state transition is a batch of new events that should be added to the
shared history. For example:

```
proposal round 47
  event 1: ~basil sells 24 crates of tomatoes to ~sunflower
  event 2: ~oregano harvests 12 bushels of oregano
  event 3: ~chive transfers 50 MUR to ~chamomile
```

~dill signs this proposal with its Kumara identity and sends it to
every other galaxy through Comlink.

### Step 2 -- Validation

Each galaxy receives the proposal and checks it against its own local
copy of the Mantra log:

- Does ~basil have 24 crates to sell? Check the inventory.
- Does ~chive have 50 MUR to transfer? Check the balance.
- Are the Kumara signatures on each event valid?
- Does the proposal follow from the last agreed state?

Each galaxy performs these checks independently. No galaxy trusts
another galaxy's answer -- it reads its own copy of the log and
decides for itself.

### Step 3 -- Voting

Each galaxy sends a signed vote back to ~dill:

- **Yes** means "I checked this proposal against my log and it is
  valid."
- **No** means "I found a problem" -- and the vote includes which
  event failed and why.

### Step 4 -- Counting

~dill collects the votes. If a majority of the 14 galaxies vote yes --
at least 8 of 14 -- the round succeeds.

### Step 5 -- Commitment

~dill broadcasts a commit message containing the proposal and the
signed votes. Every galaxy appends the new events to its Mantra log
in the agreed order. The state of the network advances by one round.

## What happens when galaxies disagree

Sometimes a galaxy votes no. Perhaps ~sage was briefly offline and
missed an earlier round, so its copy of the Mantra log is one step
behind. When ~sage checks ~basil's inventory against its outdated log,
the numbers do not match.

If the majority still votes yes, the round commits. ~sage and any other
galaxies that voted no must now replay the committed rounds they missed.
They fetch the missing entries from a peer, verify each one, and bring
their local log up to date. Once caught up, they rejoin the next round
as full participants.

This is what makes consensus robust: a few galaxies can fall behind
or disagree, and the network continues. The only requirement is that a
majority stays honest and current.

## What happens when the network splits

If the network partitions -- say 7 galaxies on one side and 7 on the
other -- neither side has a majority, so neither side can commit new
rounds. Both groups pause and wait. When the partition heals, the
galaxies compare logs, replay what they missed, and resume.

No data is lost in a partition. Each side keeps its local copy of the
log intact. The network simply waits until enough galaxies can talk to
each other again.

## Something to try

Imagine you and thirteen friends are keeping a shared notebook. Any of
you can propose a new entry, but the entry only becomes official when
at least eight of you agree it is correct. What happens if three friends
are away for the afternoon? The remaining eleven can still agree on new
entries. What happens if exactly seven are on each side of a closed
door? Both groups wait until the door opens. That is consensus.

---

*May the networks you build find agreement gently, and may every
participant's honest work be recorded and remembered.*
