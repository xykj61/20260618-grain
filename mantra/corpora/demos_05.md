# MUR Token Transfer -- Five Scenarios Across the Puddle

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page walks through five demonstration scenarios showing how MUR
tokens move between galaxies in a Grain Puddle. Each scenario builds
on the one before it, from a simple two-party transfer to a full
network partition and recovery.

All 14 demo galaxies participate: ~sunflower (seed), ~rosemary
(identity), ~lavender (relay), ~basil (ledger), ~chamomile (consensus),
~oregano (replication), ~thyme (storage), ~sage (key rotation), ~mint
(discovery), ~fennel (supervision), ~marjoram (social), ~tarragon
(query), ~chive (MUR token), and ~dill (Mycelium consensus).

## Scenario 1 -- Simple transfer

**What happens:** ~sunflower sends 100 MUR to ~basil.

Step by step:

1. ~sunflower composes a transfer event:
   ```
   verb: transfer
   from: ~sunflower
   to: ~basil
   amount: 100 MUR
   ```

2. ~sunflower signs the event with its Kumara key and submits it to
   the current consensus round.

3. ~dill includes the event in the round's proposal. All 14 galaxies
   validate: does ~sunflower have at least 100 MUR? The answer is yes.

4. The round commits. Every galaxy updates its local ledger:
   - ~sunflower's balance decreases by 100 MUR
   - ~basil's balance increases by 100 MUR

5. Both ~sunflower and ~basil can query their local Mantra log and see
   the transfer recorded with its timestamp, signatures, and round
   number.

**What the galaxies keep:** Every galaxy holds the same ledger entry.
The transfer is a fact in the Mantra log, sealed by the consensus round
that committed it.

## Scenario 2 -- Multi-hop relay

**What happens:** ~chamomile sends 50 MUR to ~oregano, relayed through
~lavender.

In a Puddle, not every galaxy has a direct Comlink session with every
other galaxy. ~chamomile and ~oregano may be on opposite sides of the
network, with ~lavender sitting between them as a relay.

Step by step:

1. ~chamomile composes a transfer event for 50 MUR to ~oregano and
   signs it.

2. ~chamomile sends the sealed datagram to ~lavender through their
   existing Comlink session.

3. ~lavender forwards the sealed datagram to ~oregano. ~lavender cannot
   read the contents -- it passes the bytes along without seeing the
   amount or the parties involved.

4. The transfer enters the consensus round through whichever galaxy
   submits it to ~dill. The event itself carries ~chamomile's signature,
   so it does not matter who delivers it.

5. The round commits. All 14 galaxies update their ledgers:
   - ~chamomile's balance decreases by 50 MUR
   - ~oregano's balance increases by 50 MUR
   - ~lavender's balance is unchanged -- relaying costs nothing

**What the galaxies keep:** The same ledger entry as Scenario 1, with
~chamomile and ~oregano as the parties. ~lavender's role as relay is
not recorded in the Mantra log -- only the transfer itself matters.

## Scenario 3 -- Consensus round with all 14 voting

**What happens:** A busy round with transfers, harvests, and MUR
movements all committed together.

Step by step:

1. ~dill collects a batch of pending events:
   - ~basil sells 24 crates to ~sunflower (earns 30 MUR)
   - ~oregano harvests 12 bushels (earns 20 MUR)
   - ~chive transfers 75 MUR to ~fennel
   - ~sage rotates its Kumara key (no MUR change)
   - ~marjoram posts a farm update (earns 5 MUR for contribution)

2. ~dill assembles the proposal and sends it to all 14 galaxies.

3. Each galaxy validates independently:
   - Does ~chive have 75 MUR? Check.
   - Is ~sage's new key properly derived? Check.
   - Are all signatures valid? Check.

4. All 14 vote yes. The round commits.

5. Every galaxy applies the five events in order. Balances shift:
   ~basil gains 30 MUR, ~oregano gains 20, ~chive loses 75, ~fennel
   gains 75, ~marjoram gains 5. The net change across the network
   is +55 MUR (newly earned through work).

**What the galaxies keep:** Five events in one round, all ordered and
signed. Any galaxy can replay the round and arrive at the same balances.

## Scenario 4 -- Partition, divergence, and reconciliation

**What happens:** The network splits into two groups, each continues
locally, and they reconcile when the partition heals.

Step by step:

1. A network fault divides the 14 galaxies into two groups:
   - Group A (8 galaxies): ~sunflower, ~rosemary, ~lavender, ~basil,
     ~chamomile, ~oregano, ~thyme, ~sage
   - Group B (6 galaxies): ~mint, ~fennel, ~marjoram, ~tarragon,
     ~chive, ~dill

2. Group A has 8 members -- a majority. It can continue committing
   consensus rounds. ~chamomile takes over as the round proposer
   since ~dill is in Group B.

3. Group B has only 6 members -- not a majority. It cannot commit
   new rounds. Pending events queue up but do not become official.

4. Group A commits 3 rounds during the partition. Group B waits.

5. The partition heals. All 14 galaxies can communicate again.

6. Group B's galaxies fetch the 3 rounds they missed from Group A
   peers. They validate each round, verify the signatures, and
   apply the events to their local logs.

7. Group B's queued events enter the next round proposed by ~dill,
   now that full consensus is possible again.

**What the galaxies keep:** After reconciliation, all 14 hold the same
log. Group A's 3 rounds are official history. Group B's pending events
either commit in a new round or are rejected if they conflict with
what Group A already committed.

## Scenario 5 -- Log agreement after a burst

**What happens:** A burst of 20 transfers in rapid succession, followed
by a verification that all galaxies hold the same Mantra log.

Step by step:

1. Over the course of one minute, 20 transfer events arrive from 10
   different galaxies. ~dill batches them into 4 consensus rounds of
   5 events each.

2. Each round goes through the full proposal-validate-vote-commit
   cycle. Some galaxies are slower than others -- ~thyme and ~mint
   receive round 3's commit while still processing round 2's votes.

3. After the burst, ~tarragon (the query engine galaxy) runs a log
   agreement check: it asks each galaxy for the hash of its Mantra
   log at round 51 (the last committed round).

4. All 14 galaxies report the same hash. The logs agree.

5. ~tarragon runs a second check: it picks 5 random events from the
   burst and asks each galaxy to return the full event with its
   signatures. All 14 return identical events.

**What the galaxies keep:** A consistent, ordered, hash-verified log.
The burst tested throughput -- 20 events in 4 rounds -- and the
agreement check proved that speed did not sacrifice correctness.

## Something to try

Pick one of the five scenarios and trace it with a pencil and paper.
Draw 14 circles for the galaxies, give each a starting balance of
1,000 MUR, and walk through the transfers. After each round, write
the new balances next to each circle. Notice how every circle ends up
with the same total when you add them all together -- MUR earned
through work increases the total, but transfers only move it around.

---

*May every token you earn reflect real work, and may every ledger you
keep tell the same honest story as your neighbor's.*
