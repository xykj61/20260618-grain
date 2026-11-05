format session-log-v1
stamp 20261104.195858
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
title Orbit 7 -- RV32I Aurora seed port
prompt kg -- continue the Terrarium boot journey
orbit round 2 Taurus -- the earth that holds still
think the seed code itself is already RV32I-compatible -- u8 and u32 types only, li sp and j kmain are valid RV32I instructions, no 64-bit registers or RV64-specific opcodes
think the port is purely in the build pipeline: target triple riscv64 -> riscv32, drop -mcmodel=medium (a 64-bit-only flag), switch qemu-system-riscv64 -> qemu-system-riscv32
think QEMU virt memory map is identical across word widths: UART 0x10000000, test finisher 0x00100000, RAM 0x80000000 -- so linker script addresses unchanged
think Makefile terrarium-build already searches terrarium/src/ then aurora/src/ with matching linker script selection, so aurora stages run through Terrarium with no further changes
obs the seed was width-independent from the start -- the port was a three-line build pipeline change rather than a code rewrite, which validates the module readiness survey's verdict that Aurora is RV32I-ready
obs both SLC gates proven on metal: aurora/run.sh seed speaks and exits 0 on qemu-system-riscv32; make terrarium-app STAGE=seed shows the same output through the macOS window
file [tools/au/aurora_run.rish](../../tools/au/aurora_run.rish) switched target to riscv32-freestanding-none, dropped -mcmodel=medium, switched to qemu-system-riscv32
file [aurora/src/seed.rye](../../aurora/src/seed.rye) comment-only update: qemu-system-riscv64 -> qemu-system-riscv32
file [aurora/layout.ld](../../aurora/layout.ld) comment-only: freestanding stage -> freestanding RV32I stage; em-dash to ASCII --
file [Makefile](../../Makefile) terrarium-build now searches terrarium/src/ then aurora/src/ with matching linker script
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 7 marked done
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.064 -> 60.065; RV32I Aurora seed port added to landed list
recommend keep-going -- Orbit 8 (RV32I relay and named stages) is next: port relay and named to RV32I, prove SHA3-512 crypto on the 32-bit ISA
