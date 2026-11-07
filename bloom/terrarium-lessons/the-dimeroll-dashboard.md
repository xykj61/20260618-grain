# The Dimeroll Dashboard

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this tutorial teaches

This tutorial walks through the Dimeroll tab in Terrarium -- the place
where you see the financial ledger. By the end, you will know what
Dimeroll is, how to read a transaction, how to find inventory and cash
flow summaries, and what "replay identity" means in plain words.

## What Dimeroll is

Dimeroll is Grain's financial ledger. It records what a farm grows,
harvests, sells, composts, and observes -- every transaction that
touches money or materials. The name suggests a coin rolling across
a table: small, steady, honest movement of value from one place to
another.

The Dimeroll tab in Terrarium displays this ledger as a readable
dashboard, drawn from the same Mantra facts that the Terminal tab
proves.

## What you see

The Dimeroll dashboard shows three views of the same data:

**Transaction journal.** A list of every transaction in the order it
happened. Each line shows the date, the verb (what kind of action it
was), the subject (what it involved), the quantity, and the price if
one applies. For example:

- Day 1: plant tomatoes, 200 units
- Day 5: harvest tomatoes, 45 units
- Day 8: sell tomatoes, 20 units at 600 each

The journal is the complete story. Everything else on the dashboard is
derived from it.

**Inventory on hand.** A summary of what the farm currently holds. For
each subject (tomatoes, peppers, leaves), the inventory shows the
running balance -- how many units are available right now. This number
is computed from the journal: plantings add, harvests add, sales
subtract, composting subtracts. A negative balance would mean more was
taken out than put in, which the system prevents.

**Cash flow summary.** A summary of revenue by subject. Only sell
transactions contribute to revenue. The dashboard shows the total
revenue per product and the grand total. This is the financial picture:
how much money came in, and from what.

## How the numbers come from Mantra facts

Every transaction is recorded as a Mantra fact -- a signed, timestamped
entry in the append-only event log. The Dimeroll dashboard reads these
facts and computes the journal, inventory, and cash flow from them.

This means the dashboard never stores its own numbers. It derives them
fresh from the Mantra log each time. If the log has nine transactions,
the dashboard shows nine journal entries, and the inventory and cash
flow reflect exactly those nine transactions -- nothing more, nothing
less.

## How to read a transaction line

A transaction line carries five pieces of information:

1. **Day** -- when the transaction happened
2. **Verb** -- what kind of action: plant, harvest, sell, compost,
   or note
3. **Subject** -- what was involved: tomatoes, peppers, seeds, etc.
4. **Quantity** -- how much
5. **Price** -- the price per unit, if the verb is sell (other verbs
   have no price)

Reading a line: "Day 8, sell tomatoes, 20 at 600" means on day 8, the
farm sold 20 units of tomatoes at 600 units of currency each, for a
total of 12,000.

## What replay identity means

Replay identity is a simple idea with a powerful consequence. It means:
if you take the same transactions and process them again from the
beginning, you get exactly the same answer.

In practice, this is proven by building two independent copies of the
ledger in separate areas of memory, feeding them the same transactions,
and comparing their state hashes at the end. If the hashes match, the
calculation is deterministic -- it does not depend on luck, timing, or
hidden state.

Why this matters: it means anyone can verify the ledger. You do not
have to trust the person who computed the totals. You can replay the
same transactions yourself and check that you get the same answer.
That is what makes the record trustworthy.

## Something to try

Open the Dimeroll tab and find the transaction journal. Pick one
transaction and trace it through to the inventory summary -- does
the balance reflect that transaction? Then find the cash flow summary
and check whether the sell transactions add up to the total shown.
The numbers should agree, because they all come from the same source.

---

*A ledger is a mirror held up to the work of a season. The Dimeroll
dashboard is where that mirror hangs -- clear, honest, and always
willing to show the same reflection to anyone who looks.*
