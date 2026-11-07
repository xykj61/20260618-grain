# Running the Standing Roster

*Your tree carries a set of guards. Each one checks that something the tree promises is still
true. Running them all at once is called a **cold endurance run**, and this page is how you do it.*

**Language:** EN - **Style:** Bhakta at the Door setting, with Radiant warmth (see `../../context/BHAKTA_STYLE.md`)
**Written:** `20261103.145835`
**Status:** Living
**Room:** mixed -- the commands are checkable; the workflow advice is judged
**Where this sits:** home is [`../../README.md`](../../README.md) - the first hour is
[`the-first-hour.md`](the-first-hour.md) - the standing roster lives at
[`../../tools/fixtures/s/standing_equipment_run.sh`](../../tools/fixtures/s/standing_equipment_run.sh) -
the foundation behind halting on a red is
[`../../foundations/20260816-214652_standfast-the-stopped-line.md`](../../foundations/20260816-214652_standfast-the-stopped-line.md) -
TAME Guidance governs all code: [`../../context/TAME_GUIDANCE.md`](../../context/TAME_GUIDANCE.md)

---

## What a guard is

A **guard** is a small program that checks one promise the tree makes. It might check that every
file a page links to actually exists, or that a number a rule cites is still true, or that a
module compiles and its own proof passes.

Guards live under [`../../tools/`](../../tools/). Each one is a Rishi script (`.rish`) paired
with a scan (`.sh`) that does the measuring.

A **witness** is the guard's word for itself. When you see `*_witness.rish`, that is a guard
you can run.

## What the standing roster is

The **standing roster** is the list of every guard this tree carries. Running the whole roster
is called an **endurance run**. There are two kinds:

- A **cold endurance run** establishes where the tree stands before you begin work. It runs
  every guard against the tree as it is right now.
- A **hot endurance run** exercises the tree after you have made changes, to prove that what
  you changed still holds.

The roster runner lives at
[`../../tools/fixtures/s/standing_equipment_run.sh`](../../tools/fixtures/s/standing_equipment_run.sh).

## Your first run

Open a terminal in the tree's root directory and type:

```sh
sh tools/fixtures/s/standing_equipment_run.sh
```

The runner starts working through the guards, one at a time. Each guard prints its name, its
verdict, and how long it took:

```
dated_path green 45s 45012ms
exec_bit green 2s 2341ms
```

### Standfast -- halt on first red

By default, the runner **halts on the first red**. This is the **standfast** behavior: safety
first, per [TAME Guidance](../../context/TAME_GUIDANCE.md). When a guard answers red, the
runner prints:

```
standfast: halting on first red -- pass --full for the complete roster
```

This is the right default. A red means something is wrong, and knowing which thing is wrong --
right now, before anything else runs -- is more useful than a list of three hundred other
results you will read after the repair.

### The full roster

When you want every guard to run regardless of reds -- for example, to see the whole picture
after a large migration -- pass `--full`:

```sh
sh tools/fixtures/s/standing_equipment_run.sh --full
```

This runs every guard in the roster and reports all verdicts at the end. It can take thirty
minutes or more on a large tree.

### A single guard

To run one guard by name:

```sh
sh tools/fixtures/s/standing_equipment_run.sh exec_bit
```

This runs only that guard and reports its verdict.

## The five verdicts

Every guard answers with one of five words:

| Verdict | What it means |
|---------|---------------|
| **green** | The promise holds. |
| **red** | The promise is broken. Read the evidence file to learn what went wrong. |
| **gated** | The guard could not run because something it depends on is not available -- a missing tool, a submodule not fetched, a platform this machine is not. |
| **absent** | The guard's own file is missing from this tree. |
| **unrun** | The guard was skipped by the runner (for example, it belongs to a tier or cadence that this run did not include). |

## Where evidence lands

When a guard answers red, it writes an **evidence file** explaining what it found. These live
in [`../../fleet/standing-equipment-reds/`](../../fleet/standing-equipment-reds/).
Each file is named after its guard:

```sh
cat fleet/standing-equipment-reds/dated_path.txt
```

Read the evidence file before you repair anything. It tells you what the guard measured and
what it expected.

## The lock

Only one roster run can happen at a time. The runner creates a lock directory at
`fleet/standing-equipment-run.lock.d` while it works. If a run was interrupted (a
terminal closed, a process killed), the lock stays behind. Remove it by hand:

```sh
rmdir fleet/standing-equipment-run.lock.d
```

## A typical workflow

Here is one way to work with the roster day to day.

1. **Pull and run.** After pulling new work, run the default (standfast) pass. If the tree is
   clean, every guard greens and the run finishes. If something is wrong, you see it
   immediately.

2. **Read the red.** The standfast message names the guard. Read its evidence file, understand
   what broke, and fix it.

3. **Run again.** After the fix, run the default pass again. The guard that was red should now
   be green, and the next guard runs. Repeat until the whole roster passes.

4. **The full pass.** After a large change -- a Zig version migration, a tree-wide rename, a
   deep debride -- run `--full` to see the complete picture. Expect it to take time. The
   evidence files for every red will be waiting when it finishes.

## What the roster does not check

The roster checks the tree's own promises: paths resolve, modes are set, numbers agree, modules
compile, proofs pass. It does not check whether the software does what a person wants. That is
what your own eyes are for -- run the program, use it, and see whether it feels right.

## Where to go next

- [**The First Hour**](the-first-hour.md) -- if you have not built the tree yet, start there.
- [**TAME Guidance**](../../context/TAME_GUIDANCE.md) -- the code discipline behind every guard.
- [**Reds First**](../../foundations/20260729-224828_reds-first-and-the-allocation.md) -- what
  happens when something is wrong, and why the red comes before new work.
- [**The Standfast**](../../foundations/20260816-214652_standfast-the-stopped-line.md) -- the
  foundation behind halting on first red: the line stops, and the reason is named.
