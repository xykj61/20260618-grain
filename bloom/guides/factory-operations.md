# Factory Operations Guide

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this guide teaches

This guide walks through the daily operations of a small food processing
facility -- a kitchen, a mill, a drying room, a bottling line -- using
Grain as its record-keeping system. It assumes you are turning raw farm
produce into shelf-stable or value-added products: dried herbs, preserved
vegetables, sauces, flours, oils, or any other food product that starts
in a field and ends in a jar, a bag, or a bottle.

## Receiving

Every batch begins with receiving raw material. When produce arrives from
the farm:

1. **Inspect it.** Check quality, quantity, and condition. Is it fresh?
   Is it the variety you expected? Is the weight correct?

2. **Record it.** Enter the delivery into Mantra: the date, the farm of
   origin, the crop, the variety, the weight, and the condition. If the
   farm uses Grain too, their shipping record and your receiving record
   describe the same event from two sides.

3. **Store it properly.** Refrigerate what needs cold. Keep dry goods dry.
   First in, first out -- use the oldest stock first.

## Batch processing

Each production run is a batch, and each batch gets its own record:

- **Batch number.** A unique identifier. Grain's Mantra log timestamps
  each entry, so the timestamp itself serves as a natural batch number.

- **Inputs.** What went into this batch: which lot of tomatoes, which
  batch of herbs, which oil, which salt. Record the quantity of each.

- **Process.** What you did: cooking temperature and time, drying
  temperature and duration, pressing pressure, milling settings. Record
  the steps as you perform them.

- **Output.** What came out: the number of jars, bags, or bottles, and
  the total weight or volume. Record the yield -- how much finished
  product you got from how much raw material.

- **Quality check.** Taste it, measure it, test it. Record the result.
  A pH reading on a preserve, a moisture reading on a dried herb, a visual
  inspection of a flour -- whatever quality check applies to your product.

## Traceability

If a customer asks where their jar of sauce came from, the batch record
answers: this batch, made on this date, from tomatoes grown at this farm,
harvested on this date, from this field. That chain -- field to jar -- is
traceability, and it is what Grain's append-only records provide.

If something goes wrong -- a batch that does not taste right, a product
that spoils early -- the batch record tells you what was different about
that batch. Was the raw material from a different farm? Was the processing
temperature lower than usual? Was the storage time longer? The record is
where the investigation begins.

## Inventory

Know what you have:

- **Raw materials on hand.** How much of each input is in storage? When
  was it received? What is its shelf life?

- **Finished products on hand.** How many units of each product are ready
  to sell? When were they made?

- **Packaging materials.** Jars, lids, labels, boxes. Running out of
  packaging stops production as surely as running out of ingredients.

Record inventory changes as they happen -- when material arrives, when a
batch consumes it, when finished products ship out. The Dimeroll ledger
tracks the financial side; the Mantra log tracks the physical side.

## Something to try

Next time you cook a meal, write down every ingredient, its quantity, and
where it came from. Write down the steps you followed and the time each
step took. Write down how the result tasted.

You have just created a batch record. A food processing facility does
exactly this, at scale, for every batch it produces.

---

*A jar of preserved tomatoes carries a summer inside it. A batch record
carries the whole story of that summer -- the field, the harvest, the
kettle, the seal -- so the person who opens the jar can trust what they
hold.*
