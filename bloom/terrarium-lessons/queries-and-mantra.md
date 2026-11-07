# Queries and Mantra

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this tutorial teaches

This tutorial walks through the Mantra tab and the query system in
Terrarium. By the end, you will know what a query is, what the four
query types do, what the Mantra tab shows, and why the event log is
append-only.

## What a query is

A query is a question asked of the records. Instead of reading every
transaction one by one, you ask the system to find the ones that match
a condition. The answer is a filtered list -- the transactions that fit,
with everything else set aside.

Grain supports four kinds of queries, each filtering by a different
property of the transaction.

## The four query types

**Query by verb: what happened?**

Filter transactions by their action type. Ask for all harvests, all
sales, all plantings, or all compost entries. The system walks through
the Mantra log, checks each fact's verb, and returns the ones that
match.

Example: query by verb "sell" returns every sale transaction -- the
subject, the quantity, the price, and the day it happened.

**Query by subject: about what?**

Filter transactions by what they involve. Ask for everything about
tomatoes, everything about peppers, or everything about seeds. The
system checks each fact's subject string and returns the matches.

Example: query by subject "tomatoes" returns every transaction that
touched tomatoes -- plantings, harvests, sales, and compost entries
together.

**Query by date range: when?**

Filter transactions by when they happened. Give a start day and an end
day, and the system returns every transaction in that window, inclusive
on both ends.

Example: query by date range days 1 through 7 returns the first week's
transactions. Query by days 8 through 10 returns the last few days.
Together, the two queries cover every transaction in the log -- a
completeness check the witnesses verify.

**Query by account: who earned what?**

Combine verb and subject filtering with revenue calculation. Ask for
all sales of a particular product, and the system returns the total
revenue earned from that product.

Example: query by account for tomatoes returns every sell transaction
involving tomatoes and sums the revenue. The result is a plain-text
report showing each sale, the quantity, the price, and the total.

## What the Mantra tab shows

The Mantra tab displays the append-only event log -- every fact the
system has recorded, in the order it was recorded. Each entry shows:

- A sequence number (its position in the log)
- The key (a structured string like `sell:tomatoes`)
- The value (the details: quantity, unit, price)
- The Kumara signature (proof of who recorded it)
- The hash chain link (connecting this entry to the one before it)

The log reads from top to bottom, oldest first. New entries appear at
the end. Nothing in the middle ever changes.

## Why append-only matters

An append-only log has one rule: entries are added at the end, and
nothing already written is ever changed or removed.

This matters because it means nobody can silently alter the past. If
a transaction was recorded on day 3, it is still there on day 300,
exactly as it was written. If someone tried to change it, the hash
chain would break -- each entry's hash depends on the entry before it,
so altering one entry changes every hash after it, and the system
detects the tampering.

For a farm, this means the growing records, the harvest records, and
the sales records are permanent. An auditor, a customer, or the
grower themselves can look at the log at any time and trust that
what they see is what actually happened. The records are as honest
as the day they were written.

## Something to try

Open the Mantra tab and scroll through the event log. Find a sell
transaction and note its key and value. Then imagine asking: "How
many sales happened this week?" That question is a query by verb
and date range combined. Think about which entries from the log would
appear in the answer, and check your guess against what the query
returns.

The log is the single source of truth. Every query, every dashboard
number, and every inventory balance traces back to it.

---

*An honest record is the simplest kind of trust there is. The Mantra
log holds every fact in the order it arrived, and the queries are
just different ways of asking what the record already knows.*
