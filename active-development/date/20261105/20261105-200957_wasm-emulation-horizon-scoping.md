# WASM Emulation Horizon Scoping -- from QEMU to `grain-emu.wasm`

**Stamp:** `20261105.200957`
**Status:** Living -- checkable
**Room:** active-development
**Orbit:** 23 of the Mantrapod RV64G journey (Quest 1.5)
**Style:** Gauge at the Field setting, with Radiant warmth
**Grows from:** 22 orbits of RV64G port, 19 modules proven on freestanding RISC-V,
Terrarium macOS app launching QEMU for both RV32I and RV64G

---

## The question

What is the path from `qemu-system-riscv64` to `grain-emu.wasm` -- a browser-hosted
RISC-V emulator serving the same Grain stack that runs on QEMU today?

The 19 modules build to freestanding ELFs. QEMU runs them. A browser needs a RISC-V
emulator compiled to WebAssembly, loading those same ELFs, speaking the same UART
protocol the Terrarium Swift app already speaks.

---

## Survey of existing RISC-V-to-WASM projects

### 1. TinyEMU (Fabrice Bellard) -- C, MIT

The engine behind JSLinux. A small, self-contained RISC-V system emulator written in C.
It boots Linux and runs in the browser. container2wasm uses TinyEMU for its RISC-V
guest path. Compiles to WASM via Emscripten. Supports virtio devices, CLINT, PLIC,
and a framebuffer. The most battle-tested option -- JSLinux has run publicly for years.

**Strengths:** Proven browser deployment. Small codebase (a few thousand lines of C).
MIT license. Already handles virt-machine peripherals our ELFs expect.
**Gaps:** Designed for Linux boot (OpenSBI + kernel), not bare-metal ELFs. Our modules
use `-bios none -kernel <elf>` on QEMU, which loads the ELF at 0x80000000 with no
firmware. TinyEMU expects a BIOS/kernel boot flow. Adapting it to raw ELF load is the
primary integration cost.

### 2. rvemu (d0iasm) -- Rust, MIT

A Rust RISC-V emulator targeting RV64GC. Ships a browser version via wasm-pack at
rvemu.app, running xv6. Supports CLINT, PLIC, virtio, and a device tree. Published
on crates.io as a library.

**Strengths:** Rust -- compiles to WASM via wasm-pack or wasm-bindgen without
Emscripten. RV64GC coverage matches our target ISA. MIT license.
**Gaps:** Designed around xv6/Linux boot. UART and device model may differ from QEMU
virt. The browser demo is a terminal, not a canvas. Last significant activity predates
2024 based on crate publish dates. Community is small.

### 3. riscv-rust (takahirox) -- Rust, MIT

A Rust processor emulator with WASM output. Runs xv6 and Linux in the browser at
takahirox.github.io/riscv-rust. Includes a debugger.

**Strengths:** Working browser demo with WASM. Rust. MIT license.
**Gaps:** Similar to rvemu -- oriented toward OS boot. Smaller community. The RISC-V
extension coverage is less clearly documented than rvemu.

### 4. WebCM (Cartesi/edubart) -- C, Apache-2.0

Browser terminal booting Alpine Linux on emulated RISC-V. Ships as a single 32 MiB
WASM file built from the Cartesi Machine emulator with Emscripten.

**Strengths:** Full Linux in the browser, proving the performance is achievable.
**Gaps:** 32 MiB is large. The Cartesi Machine is a deterministic execution engine
with its own memory model -- adapting it to load our ELFs would be heavier than
starting from TinyEMU or rvemu. Apache-2.0 is permissive.

### 5. container2wasm (ktock) -- Go tooling, experimental

Converts Docker container images to WASM. Uses TinyEMU for RISC-V guests, Bochs for
x86. The Go tooling wraps the emulator build; the emulator itself is still TinyEMU.

**Strengths:** Proves the TinyEMU-to-WASM pipeline works end to end.
**Gaps:** The tool targets container images, not bare-metal ELFs. The useful piece is
TinyEMU itself, which we would use directly.

### 6. grain-emu (DJINN / grain-os) -- Zig, working reference

DJINN's grain-os project already ships a working RISC-V emulator compiled to WASM.
Measured at 72 KiB of WASM, achieving 120-140 MIPS in Chromium, booting the full
grain-os system. Pure Zig. This is the primary reference for Terrarium -- Keaton
confirmed on `20261104` that grain-emu is the working reference and Terrarium is our
name for the same concept, carrying our own design language and voice.

**Strengths:** Already exists and works. 72 KiB is dramatically smaller than every
other surveyed option. Boots the same images QEMU runs. Written in the same language
(Zig) this tree authors in. The performance (120-140 MIPS) is proven in a real browser.
**Gaps:** License and adaptation terms need verification before adoption. Our 19 RV64G
modules assume the QEMU virt memory map -- grain-emu's memory map may differ. Our
multi-hart and atomic modules need SMP support in the emulator. Integration with our
Mantra wire protocol and Terrarium's browser surface is new work regardless.

### 7. Build-your-own with Emscripten or Rust-to-WASM

Write a minimal RV64IMAFD interpreter in C or Rust, compile to WASM. The interpreter
needs only: instruction decode, integer + M + A + F/D execution, UART at 0x10000000,
CLINT timer at 0x2000000, test_finisher at 0x100000, and enough virt-machine memory
map to match QEMU's layout.

**Strengths:** Smallest possible WASM binary after grain-emu (which is already 72 KiB).
No Linux boot path, no virtio, no PLIC -- our modules use none of these. The interpreter
matches exactly what our ELFs need.
**Gaps:** Largest engineering cost. Must implement and prove every instruction our 19
modules emit. The instruction census from Orbit 20 (M=42, A=117, FP=184, CSR=23)
bounds the surface but does not shrink it.

---

## The build path -- three candidates

### Path A -- Adapt TinyEMU (recommended)

1. Fork TinyEMU's RISC-V core (MIT, ~3,000 lines of C).
2. Strip the Linux boot path. Add raw ELF loading at 0x80000000 (read ELF headers,
   map segments, set PC to entry point).
3. Keep UART at 0x10000000, CLINT at 0x2000000, add test_finisher at 0x100000.
4. Compile with Emscripten: `emcc -O2 -s WASM=1 -s ALLOW_MEMORY_GROWTH=1`.
5. Write a JavaScript host that loads the WASM module, feeds an ELF file, and
   connects UART output to a browser terminal or canvas.
6. The Terrarium Swift app's UART protocol (seed, facts, state hash, MVERIFY)
   becomes the JavaScript host's protocol -- same wire format, different transport.

**Estimated cost:** 3-5 orbits. The C is small and the QEMU virt memory map is
well-documented. The primary risk is F/D extension coverage in TinyEMU -- verify
before committing.

### Path B -- Adapt rvemu (Rust)

1. Fork rvemu (MIT, Rust).
2. Replace the xv6/Linux boot path with raw ELF loading.
3. Adjust the UART and peripheral addresses to match QEMU virt.
4. Build with wasm-pack. No Emscripten needed.
5. Same JavaScript host as Path A.

**Estimated cost:** 3-5 orbits. Rust-to-WASM is clean. The risk is that rvemu's
device model may differ enough from QEMU virt to require significant peripheral
rewrites. RV64GC coverage is explicitly claimed.

### Path C -- Write a minimal interpreter

1. Write an RV64IMAFD interpreter in Zig (our own language), compile to WASM via
   Zig's `wasm32-freestanding-none` target.
2. Implement only the instructions our 19 modules use (bounded by the census).
3. Same ELF loader and host as above.

**Estimated cost:** 8-12 orbits. The interpreter is bounded but must be proven
instruction by instruction. The payoff is zero external dependency and a codebase
entirely in the tree's own language and style. This is the Grain-native path.

### Path D -- Compose grain-emu core with Terrarium surface

1. Study grain-emu's architecture, memory map, and ISA coverage.
2. Verify license terms allow adaptation.
3. Adapt its ELF loading to accept our bare-metal ELFs (if needed).
4. Wire its UART output into the Terrarium browser host's Mantra wire protocol.
5. Build the Terrarium browser surface (canvas, terminal, or both) around it.

**Estimated cost:** 2-4 orbits if grain-emu's memory map and ISA coverage match
our needs; 4-6 if significant adaptation is required. The payoff is a working
72 KiB emulator on day one, proven at 120-140 MIPS, written in Zig. The cost is
a dependency on another project's architecture decisions.

---

## Gaps, each named

1. **ELF loading.** None of the surveyed projects load bare-metal ELFs the way QEMU's
   `-bios none -kernel` does. Every path requires writing an ELF segment mapper.

2. **QEMU virt memory map.** Our ELFs assume QEMU's virt machine layout: RAM at
   0x80000000, UART at 0x10000000, CLINT at 0x2000000, test_finisher at 0x100000.
   Any emulator must match this map or the ELFs must be relinked.

3. **Multi-hart.** Our multi_hart and preempt modules use 2 harts with CLINT IPI.
   TinyEMU supports SMP; rvemu's SMP support is unclear. Path C must implement
   hart scheduling.

4. **F/D extensions.** 184 floating-point instructions across 4 modules (glow_fp,
   fp_context, dimeroll_price, lotus_audio). TinyEMU's F/D coverage needs verification.
   rvemu claims RV64GC which includes F and D.

5. **A extension (atomics).** 117 atomic instructions across 4 modules (atomic_cap,
   atomic_registry, multi_hart, preempt). LR/SC and AMO semantics must be correct
   under emulation. Single-threaded WASM simplifies this -- no real concurrency.

6. **Browser integration.** The Terrarium Swift app reads UART output line by line and
   drives a macOS window. The WASM host must do the same in JavaScript: read UART,
   parse the Mantra wire protocol, render to a canvas or terminal element. This is
   new code regardless of which emulator path is chosen.

7. **WASM binary size.** WebCM ships at 32 MiB. TinyEMU alone should be under 1 MiB
   of WASM. Our ELFs total ~150 KiB. A page load under 2 MiB is achievable on
   Path A or B; Path C should be the smallest.

---

## Recommendation

**Path D (compose grain-emu core with Terrarium surface) is the recommended first
step.** grain-emu already works at 72 KiB and 120-140 MIPS -- the hardest part of the
problem is solved. The remaining work is adaptation (ELF loading, memory map
alignment, UART protocol) and browser surface integration. This carries less risk than
any other path because the emulation core is proven.

**Path A (TinyEMU adaptation) is the fallback** if grain-emu's architecture does not
align with our needs after closer study. TinyEMU is proven in the browser, MIT-licensed,
and small enough to read in a day.

**Path C (Grain-native interpreter) is the long-return answer.** A RISC-V interpreter
written in Zig, compiled to WASM, would be the tree's own tool all the way down. It
is worth building -- after grain-emu or TinyEMU proves the browser integration works
and establishes the JavaScript host's shape.

**Estimated orbit budget for browser-hosted Grain:**
- Path D to first browser boot: **2-4 orbits**
- JavaScript host with Mantra wire protocol: **2-3 orbits**
- Canvas rendering (Terrarium in the browser): **2-3 orbits**
- Total to browser-hosted Grain stack: **6-10 orbits**

This fits inside Act II's 25-orbit budget alongside the Dimeroll field ledger, or it
could form a parallel quest.

---

## What this document is not

This is a scoping document -- a survey of the landscape and a named build path. It is
not a commitment to any path, and it does not open work on any of them. The next orbit
(24) measures RV64G performance on QEMU, which is the baseline any browser emulator
will be compared against.
