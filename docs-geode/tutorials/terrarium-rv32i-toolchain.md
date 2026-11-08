# Terrarium -- Your First RV32I Program

**Style:** Teacher at the Door setting, with Radiant warmth

This page walks you through building and running a bare-metal program
on a 32-bit RISC-V machine. By the end you will have compiled a small
Rye program, started a virtual machine, and seen it print a line to
your terminal -- all without an operating system.

## What you need

Three tools, all already in the tree:

- **Rye** (`rye/bin/rye`) -- a Zig-based compiler that knows how to
  target bare metal on RISC-V. It lives in the repository.
- **Zig** (`vendor/zig-toolchain/zig`) -- the cross-compiler Rye
  calls. It supports dozens of targets, and `riscv32-freestanding-none`
  is the one we use here. No separate GCC cross-compiler is needed.
- **QEMU** (`qemu-system-riscv32`) -- an emulator that pretends to be
  a RISC-V computer. Install it with your package manager if it is not
  already present:
  - macOS: `brew install qemu`
  - NixOS: `nix-env -iA nixpkgs.qemu` (or add `qemu` to your
    system packages)
  - Debian / Ubuntu: `sudo apt install qemu-system-misc`

## What the program does

The program is at `terrarium/src/hello.rye`. It does four things, in
order:

1. **Sets up a stack.** The machine wakes with nothing -- no memory
   layout, no stack pointer. The first instruction points the stack
   pointer at a safe address in RAM.
2. **Writes a message.** Each byte of a greeting is written, one at a
   time, to a special address (`0x10000000`) that QEMU watches. Every
   byte that arrives there appears on your terminal.
3. **Powers down.** Writing a particular value (`0x5555`) to another
   special address (`0x100000`) tells the emulator to shut the machine
   down cleanly.
4. **Loops forever, just in case.** If the shutdown did not take, the
   program sits in a tight loop rather than running off into whatever
   happens to be in memory next.

## Build and run

From the repository root:

```
rishi/bin/rishi run tools/te/terrarium_run.rish
```

You will see:

```
building 'hello' (freestanding riscv32) ...
waking 'hello' in qemu-system-riscv32 (machine virt) ...
----
Terrarium hello: a hart woke on RV32I, spoke this line, and halted.

----
qemu exited with status 0
```

Exit status 0 means the hart (the RISC-V word for a hardware thread)
asked the machine to rest, and the machine did.

## What just happened

Rye compiled `terrarium/src/hello.rye` into a freestanding ELF binary
targeting `riscv32-freestanding-none`. That means:

- **riscv32** -- 32-bit RISC-V instruction set (RV32I).
- **freestanding** -- no operating system. The program is the only
  thing running.
- **none** -- no ABI conventions from an OS to follow.

The linker script at `terrarium/layout.ld` tells the compiler where to
place the program in memory. QEMU's `virt` machine expects the first
instruction at address `0x80000000`, so that is where the program
begins.

QEMU then loads the ELF, sets the program counter to `_start`, and the
hart begins executing -- just as real hardware would.

## The linker script

A linker script is a small file that tells the compiler where each
section of the program goes in memory. Ours says:

- Start at `0x80000000` (the base of RAM on QEMU's virt machine).
- Put the code (`.text`) first, with the startup code (`.text.init`)
  at the very beginning.
- Put read-only data (`.rodata`), writable data (`.data`), and
  zero-initialized data (`.bss`) after the code.
- Throw away unwind tables and compiler metadata that a bare-metal
  program does not need.

## Where this fits

Terrarium is the browser-hosted RISC-V emulation surface -- a living
world under glass. This bare-metal program is the first step: proving
that the cross-compilation toolchain works and that a program can speak
on the virtual machine. The journey continues from here toward a pill
that boots into Caravan.

## Next steps

- Read `terrarium/src/hello.rye` -- it is 45 lines and every line
  carries a comment explaining what it does.
- Try changing the greeting and rebuilding.
- Look at Aurora's 64-bit seed at `aurora/src/seed.rye` to see the
  same pattern on riscv64.
