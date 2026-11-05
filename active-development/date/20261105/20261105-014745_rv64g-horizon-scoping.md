# RV64G Horizon Scoping -- RV32I living inside RV64G per Gall's Law

**Status:** Proposed -- scoping document for the next Terrarium journey
**Stamp:** `20261105.014745`
**Room:** checkable
**Style:** Gauge at Field
**Grows from:** Terrarium boot journey (`active-tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md`), 25 orbits landed on freestanding RV32I

## What stands

The RV32I boot journey proved every layer of Grain's stack on a 32-bit freestanding hart:

| Layer | What it proved | Witness |
|---|---|---|
| Pill | Self-compile identity (djb2 hash match) | `terrarium/boot_witness.rish` stage 1 |
| Tally | Bounded arena with ceiling refusal | stage 2 |
| Aurora | Framebuffer console with serial fallback | stage 3 |
| Mantra | Append-only event log with replay identity | stages 4-5 |
| Caravan | Capability model with W xor X, process supervision | stages 6-7 |
| Steward | Root supervisor booting domains from Brix manifest | stage 8 |
| Application | Glow calculator evaluating 10 expressions, 10/10 correct | stage 9 |

Every stage is bounded by Tally, observable through Aurora, recorded by Mantra. The boot witness proves all nine in sequence on QEMU `qemu-system-riscv32 -machine virt`.

## What RV64G adds

RV64G is the 64-bit general-purpose RISC-V profile: RV64I base integer plus M (multiply/divide), A (atomics), F (single-float), D (double-float). The `G` is shorthand for `IMAFD`.

| Extension | What it unlocks for Grain |
|---|---|
| **RV64I** | 64-bit address space -- Tally's `u32` indices address 4 GiB rather than constraining layout |
| **M** | Hardware multiply/divide -- Mantra's djb2 hash and any future crypto run at native speed |
| **A** | Atomic load/store/swap -- Caravan's capability table and domain registry become safe under preemption |
| **F/D** | Floating-point -- Glow numeric expressions, Lotus audio sample processing |

## Gall's Law: the simple system that works comes first

The RV32I system works. It boots, it self-compiles, it bounds, it observes, it records, it supervises, it runs applications. The RV64G journey carries that working system into a wider address space rather than rewriting it for one.

Concretely: every `.rye` module under `terrarium/src/` today compiles to `riscv32-freestanding-none`. The next journey changes the target to `riscv64-freestanding-none` and addresses the gaps that surface.

## Known gaps

1. **Zig target and linker script.** `terrarium/layout.ld` places RAM at `0x80000000` with a 128 MiB region. RV64 QEMU virt uses the same base address; the script needs 64-bit output format (`OUTPUT_FORMAT("elf64-littleriscv")`).

2. **Explicit widths.** TAME Guidance seats `u32` as the in-memory width and `u64` as the wire width. On RV64I, `usize` is 64 bits. The seam-only `usize` rule already governs this: arithmetic stays in `u32`, `@intCast` at the Zig API edge. No authored struct field, parameter, or return type changes.

3. **Atomics for real concurrency.** RV32I runs a single hart with no preemption. RV64G's A extension enables multi-hart and preemptive scheduling. Caravan's capability table and domain registry need atomic compare-and-swap for concurrent access. This is the largest new surface.

4. **QEMU machine model.** `qemu-system-riscv64 -machine virt` provides the same UART at `0x10000000`, the same sifive test finisher at `0x00100000`, the same ramfb interface. Memory-mapped I/O addresses are identical; register widths change.

5. **Floating-point context.** Caravan's process supervision needs to save and restore F/D registers on context switch. The CSR layout for `fcsr`, `fflags`, `frm` is standard RISC-V.

6. **Self-compile on RV64.** The Glow-to-RV32I code generator emits 32-bit instructions. A RV64 target needs `lw`/`sw` for 32-bit values and `ld`/`sd` for 64-bit pointers, and the register-width assumptions in the generated assembly need a pass.

## Proposed journey shape

Five quests of five orbits, the same Calfive shape:

- **Quest 1 -- The Wider Hart.** RV64I freestanding target, linker script, hello on UART, each existing stage building and running on 64-bit. No new features; the working system moves whole.
- **Quest 2 -- Hardware Arithmetic.** M extension: hardware multiply/divide in Mantra's hash, Glow's mul operation, any site currently using software division. Measure the speedup.
- **Quest 3 -- Atomic Supervision.** A extension: Caravan's capability table and domain registry use atomic operations. Multi-hart boot on QEMU (2 harts minimum). Preemptive scheduling.
- **Quest 4 -- Numeric Precision.** F/D extensions: Glow floating-point expressions, Lotus audio sample types. Context save/restore in Caravan.
- **Quest 5 -- The Living World, Wider.** Full boot witness on RV64G. The complete stack runs on the wider hart. Terrarium's WASM horizon: `grain-emu.wasm` packaging the RV64G emulation for the browser.

## What does not move

- **TAME order stays.** Safety (Tally) first, visibility (Aurora) second, replay (Mantra) third.
- **Explicit widths stay `u32` in-memory.** The wider address space is a platform fact, not a design choice. Tally budgets, Mantra fact counts, Caravan lease durations -- all stay `u32` because their domains are bounded well below 4 GiB.
- **The boot witness shape stays.** `terrarium/boot_witness.rish` proves the same nine stages. The RV64G witness adds stages for M, A, and F/D.
- **Gall's Law stays.** Each quest carries the working system forward. No quest rewrites what the previous one proved.
