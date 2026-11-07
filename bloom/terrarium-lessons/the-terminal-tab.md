# The Terminal Tab

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this tutorial teaches

This tutorial walks through the Terminal tab in Terrarium -- the place
where you run RISC-V programs on your Mac. By the end, you will know
what QEMU is, how to run a witness, how to read the output, and how to
tell if something went wrong.

## What QEMU is

QEMU is an emulator. It pretends to be a different kind of computer so
that programs written for that computer can run on yours. In Grain's
case, QEMU pretends to be a RISC-V computer -- the open processor
architecture that Grain targets -- while actually running on your Mac's
ARM processor.

This means you can write code for RISC-V, compile it, and test it
without owning a RISC-V board. The Terminal tab is where that emulated
computer lives inside Terrarium.

## Running a witness

A witness is a program that proves something works. It runs a module,
checks the results, and reports whether the checks passed. To run a
witness:

1. Click the Terminal tab in Terrarium
2. The emulator starts with the Grain boot sequence
3. A witness script runs the compiled RISC-V program through QEMU
4. Output appears in the terminal area as text

You do not type commands into the Terminal tab directly in most cases --
the witness scripts handle the invocation. What you see is the output
streaming in as the emulated program runs.

## Reading the output

Witness output follows a pattern. Here is what to look for:

**Module name and stage.** Each witness announces itself at the start:
the module it is testing and which stage of the proof it is running.

**Proof lines.** Each check prints a result. A line that says a value
matches the expected value is a passing proof. The witness counts them.

**Mantra state hash.** Many witnesses end by printing a hexadecimal
number like `0xe9cf083f`. This is the state hash -- a fingerprint of
everything the Mantra event log recorded during the run. If you run the
same transactions in the same order, you get the same hash every time.
That is how replay identity is proven.

**GREEN.** The word GREEN at the end means every check passed. This is
the verdict -- the single word that tells you the module is working
correctly.

## Common patterns

- `dimeroll_ledger_witness GREEN on metal` -- the Dimeroll ledger
  module passed all its proofs
- `14/14 proofs` -- fourteen checks were run and all fourteen passed
- `state hash 0xe9cf083f` -- the Mantra log produced this fingerprint
- `ALL PROOFS PASSED` -- every proof in the run succeeded
- `replay identity proven` -- two independent runs produced the same
  state hash

## How to tell if something went wrong

If a witness fails, you will see one of these:

- **A proof line showing a mismatch.** The expected value and the actual
  value are printed side by side, and they differ.
- **RED instead of GREEN.** The verdict word changes.
- **A crash or hang.** The output stops partway through, or QEMU prints
  an error about an illegal instruction or a memory fault.

A failure is not a disaster -- it is information. The output tells you
which proof failed and what the actual value was, so you can investigate
what went wrong.

## Something to try

Watch a witness run from start to finish. Follow the output line by
line. Find the module name, count the proofs, spot the Mantra state
hash, and look for the GREEN verdict. Once you can read a witness, you
can read every witness in the system -- they all follow the same pattern.

---

*A proof is a promise kept in public. The Terminal tab is where every
module keeps its promise, one GREEN verdict at a time, on an emulated
computer that runs exactly the same way every time.*
