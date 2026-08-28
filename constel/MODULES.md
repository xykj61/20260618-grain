# Constel -- every module in this directory

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Meter setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living roster -- **32 rows against 32 `.rye` modules**, held as one set by [`../tools/co/constel_module_roster_witness.rish`](../tools/co/constel_module_roster_witness.rish)
**Front door:** [`README.md`](README.md) - **Rung reasoning:** [`LADDER.md`](LADDER.md)

Every `.rye` file in `constel/` carries a row here, and every row names a file that stands in this
directory. A guard holds both directions at zero, so a rung that lands without a row reds on the lap
it arrives rather than going unlisted for a season. Each sentence is written from that module's own
`//!` head comment, normalized to plain ASCII.

The twelve families below follow the ladder's own order, constels-naming through constels-naming. The rung reasoning --
what each one leans on and what it proves -- lives in [`LADDER.md`](LADDER.md).

---

## Naming and membership -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`name.rye`](name.rye) | constels-naming: a fake-pier name that can never be a real ship -- the naming law and the name primitive. |
| [`roster.rye`](roster.rye) | constels-naming: a bounded registry of fake piers, holding up to `max_piers` distinct members. |

## The greeting -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`handshake.rye`](handshake.rye) | constels-naming: two fake piers greet, proven pure -- agreement before exchange. |
| [`wire.rye`](wire.rye) | constels-naming: the handshake framed for a local wire, verify-before-trust across a self-describing frame. |
| [`exchange.rye`](exchange.rye) | constels-naming: the handshake carried end to end across frames, two piers reaching a COMPLETE `Session`. |

## The local transport -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`channel.rye`](channel.rye) | constels-naming: a bounded byte channel, one frame read at a time -- the single hard thing a real transport adds. |
| [`switchboard.rye`](switchboard.rye) | constels-naming: a whole local constellation routed by name, each pier holding its own mailbox. |

## The whole sky speaks -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`gossip.rye`](gossip.rye) | constels-naming: one frame reaching the whole constellation at once, the broadcast a shared fact leans on. |
| [`census.rye`](census.rye) | constels-naming: announce and collect, so the caller knows who is present and who is silent. |

## Deciding -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`quorum.rye`](quorum.rye) | constels-naming: from a census, decide whether a strict majority may act at all. |
| [`elect.rye`](elect.rye) | constels-naming: from a quorum, elect ONE leader -- the quorum's intersection making that leader unique. |
| [`decree.rye`](decree.rye) | constels-naming: from an election, commit ONE value, once. |

## The replicated log -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`log.rye`](log.rye) | constels-naming: a sequence of decrees the whole sky agrees on, in order, so the ledger can never fork. |
| [`reconfig.rye`](reconfig.rye) | constels-naming: change the constellation safely through JOINT CONSENSUS, a strict majority in both configs. |
| [`snapshot.rye`](snapshot.rye) | constels-naming: compact the log so it can serve forever, a bounded log holding an unbounded history. |
| [`catchup.rye`](catchup.rye) | constels-naming: a lagging pier brought current from a leader's snapshot plus tail. |

## Safe across re-election -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`term.rye`](term.rye) | constels-naming: leadership made safe across re-election -- a monotonic term, so an old leader cannot commit. |
| [`repair.rye`](repair.rye) | constels-naming: the leader heals a follower's divergent suffix by Raft's Log Matching Property. |
| [`commit.rye`](commit.rye) | constels-naming: a leader commits an old-term entry only through a current-term one (Raft's Figure 8). |

## The machine and the read -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`apply.rye`](apply.rye) | constels-naming: the committed log drives a state machine, each client request applied EXACTLY ONCE. |
| [`read.rye`](read.rye) | constels-naming: a linearizable read that appends nothing, the read-index (Raft section 8). |

## Election safety -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`vote.rye`](vote.rye) | constels-naming: a vote goes only to an up-to-date log, the election restriction (Raft section 5.4.1). |
| [`prevote.rye`](prevote.rye) | constels-naming: a partitioned pier cannot disrupt a stable sky, pre-vote (Raft section 9.6). |
| [`transfer.rye`](transfer.rye) | constels-naming: leadership transfers only to a caught-up successor (Raft section 3.10). |
| [`tenure.rye`](tenure.rye) | constels-naming: a leader holds tenure only while a majority still answers, CheckQuorum (Raft section 6.2). |

## Membership change, and the lemma beneath it -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`learner.rye`](learner.rye) | constels-naming: a new member joins as a non-voting LEARNER and is promoted only once caught up (Raft section 4.2.1). |
| [`admit.rye`](admit.rye) | constels-naming: the whole add-a-member lifecycle, closed -- the learner's catch-up gate joined to the joint switch. |
| [`flexquorum.rye`](flexquorum.rye) | constels-naming: flexible quorums, the truth beneath the majority lemma (Howard, Malkhi and Spiegelman 2016). |
| [`depart.rye`](depart.rye) | constels-naming: the whole remove-a-member lifecycle, closed, including a leader that removes itself. |

## Fast reads and endurance -- constels-naming to constels-naming

| Module | What it does |
|---|---|
| [`lease.rye`](lease.rye) | constels-naming: a lease read, safe under a bounded clock (Raft section 6.4.1), falling back to the read-index. |
| [`durable.rye`](durable.rye) | constels-naming: durable state -- a pier survives a restart without ever forgetting its vote. |

## The real transport -- constels-naming

| Module | What it does |
|---|---|
| [`socket.rye`](socket.rye) | constels-naming: the constels-naming switchboard with every mailbox backed by a real UDP descriptor on 127.0.0.1 -- same names, same refusals, same sealed frame, and the kernel doing the routing. |

---

## What this roster reaches, and what it leaves to the rung

This page proves the **set**: every module has a row and every row has a module. Whether a row's
sentence still describes the code is the rung's own witness to answer, and thirty-one of them stand
in [`../tools/f/`](../tools/f/), each printing a GREEN line naming exactly what it proved. Run them
from [`LADDER.md`](LADDER.md).
