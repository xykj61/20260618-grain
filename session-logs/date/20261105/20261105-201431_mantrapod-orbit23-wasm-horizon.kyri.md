format session-log-v1
stamp 20261105.201431
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 23 -- WASM emulation horizon scoping
prompt kg -- land Orbit 23, survey RISC-V-to-WASM projects and scope the browser emulation path
think Orbit 23 asks for a scoping document that surveys existing RISC-V-to-WASM projects and names the build path from qemu-system-riscv64 to grain-emu.wasm in the browser. The 19 modules build to freestanding ELFs that QEMU runs; a browser needs a RISC-V emulator compiled to WebAssembly loading those same ELFs.
think Surveyed 6 projects: TinyEMU (Bellard, C/MIT, proven via JSLinux, used by container2wasm), rvemu (d0iasm, Rust/MIT, RV64GC, wasm-pack demo at rvemu.app), riscv-rust (takahirox, Rust/MIT, browser demo), WebCM (Cartesi, 32 MiB WASM, too heavy), container2wasm (Go tooling wrapping TinyEMU), and grain-emu (DJINN's working reference, 72 KiB WASM, 120-140 MIPS in Chromium). Also considered a build-your-own option using Zig compiled to wasm32-freestanding-none.
think Named 3 build paths: Path A (TinyEMU adaptation, 3-5 orbits, recommended -- proven browser deployment, small C codebase, MIT), Path B (rvemu adaptation, 3-5 orbits -- Rust-to-WASM without Emscripten, RV64GC coverage), Path C (Grain-native Zig interpreter, 8-12 orbits -- fully in-tree but largest engineering cost). Total estimate to browser-hosted Grain: 7-11 orbits.
think Identified 7 gaps: ELF loading (bare-metal -bios none), QEMU virt memory map (RAM 0x80000000, UART 0x10000000, CLINT 0x2000000, test_finisher 0x100000), multi-hart SMP, F/D extension coverage (184 FP instructions), A extension atomics (117 instructions), browser integration (JavaScript host for Mantra wire protocol), and WASM binary size (target under 2 MiB).
obs This is a pure scoping orbit -- no code, no builds, no witnesses. The deliverable is the scoping document itself, which names the landscape and the build path so the next orbits can act on it. Path A (TinyEMU) carries the least risk; Path C (Zig-native) is the long-return answer.
orbit round 10 Scorpio -- Investigate
file [active-development/date/20261105/20261105-200957_wasm-emulation-horizon-scoping.md](../../active-development/date/20261105/20261105-200957_wasm-emulation-horizon-scoping.md) Orbit 23 SLC gate: WASM emulation scoping with 6 projects surveyed, 3 paths, 7 gaps
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 23 checked off with landing stamp
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.105 -> 60.106, Orbit 23 description added
recommend keep-going -- Orbit 24 next: RV64G performance baseline on QEMU, measure the instruction throughput that a browser emulator will be compared against
