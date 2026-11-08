# Quest 3: WASM Station -- first movements

**Stamp:** `20261107.215733` -- **Status:** Living -- **Room:** development

## What the study found

grain-emu.wasm (72 KiB, at `gratitude/grain-www`) is a working RV64 RISC-V emulator that
runs in any browser. The study read its full WASM API through `worker.js`, `app.js`, and
`configs.json`.

**Architecture:** `rv64imac_zicsr_zifencei_zihintpause` -- RV64 with Integer, Multiply,
Atomic, and Compressed extensions. No floating-point (F/D) hardware -- soft-float ABI.

**Memory map:** QEMU virt machine at `0x80000000` -- the same base address our
`terrarium/layout64.ld` targets. Console UART at `0x10000000`, test finisher at
`0x100000` -- matching our own `hello.rye` and every freestanding module.

**ELF loading:** grain-emu parses ELF internally. The JS host calls `grain_alloc(len)`,
copies the raw ELF bytes into WASM memory, and calls `grain_start(ptr, len, harts,
ram_mib, device_mask, true)`. The return code 0 means success.

**Run loop:** `grain_run(2_000_000)` executes up to 2M instructions and returns a status:
0 = exit, 1 = yield, 2 = timer, 3 = more work. The JS host calls this in ~30ms slices
via `setTimeout`, yielding to the browser between slices.

**I/O host functions grain-emu imports:**
- `host_console(ptr, len)` -- log output
- `host_port(port, ptr, len)` -- console (port 0) or envoy (port 1) output
- `host_entropy(ptr, len)` -- RNG fill
- `host_now_ms()` -- performance clock
- `host_disk_flushed()` -- disk dirty signal
- `host_display(x, y, w, h)` -- screen dirty rectangle

## Compatibility assessment

| Property | grain-emu | Terrarium RV64 ELFs | Compatible? |
|---|---|---|---|
| Architecture | RV64IMAC | RV64GC (IMACFD + C) | partial -- F/D missing |
| ABI | soft-float | double-float | ok for no-float code |
| RAM base | 0x80000000 | 0x80000000 | yes |
| UART address | 0x10000000 | 0x10000000 | yes |
| Test finisher | 0x100000 | 0x100000 | yes |
| ELF format | ELF64 RISC-V | ELF64 RISC-V | yes |

**The gap:** grain-emu lacks F and D extensions. Our `hello64.elf` is built with
`-target riscv64-freestanding-none` through `rye build`, which enables F/D by default
via the double-float ABI. Even though `hello64.rye` uses no floating-point instructions,
the compiled binary may contain F/D register saves in function prologues.

**The path forward:** Build `hello64.elf` with `-mabi=lp64` (soft-float) instead of the
default `-mabi=lp64d` (double-float), matching grain-emu's ISA. This is a build flag
change, not a source change.

## First three movements

**Movement 1: Minimal browser host.**
Build `terrarium/web/index.html` and `terrarium/web/worker.js` -- the smallest possible
page that loads grain-emu.wasm and boots an ELF. Console output appears in a `<pre>` tag.
No canvas, no disk, no envoy -- just UART. Prove it serves locally with `python3 -m
http.server`.

**Movement 2: Soft-float RV64 build.**
Add a `terrarium_run64_soft.rish` build script (or a flag to `terrarium_run64.rish`) that
builds with `-mabi=lp64` and `-march=rv64imac` to match grain-emu. Build `hello64.elf`
in soft-float and place it where the browser host can fetch it.

**Movement 3: First browser boot.**
Copy `grain-emu.wasm` and the soft-float `hello64.elf` into `terrarium/web/`, serve the
page, and open it in a browser. The UART output
`Terrarium hello: a hart woke on RV64I, spoke this line, and halted.`
appears in the page's console panel. This is the proof that grain-emu runs our code.

## What follows

Once the first boot is proven, the remaining movements extend the surface: multi-hart
(`multi_hart64.elf`), Caravan supervision (`caravan_supervision64.elf`), screen output
(`framebuf.elf` ported to RV64), and eventually the full Steward with Mantra and Glow.
The scoping document at `active-development/date/20261105/20261105-200957_wasm-emulation-horizon-scoping.md`
maps the full Quest 3 arc.
