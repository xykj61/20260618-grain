format session-log-v1
stamp 20261105.093753
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 1 -- RV64I build target and UART hello
prompt land the first orbit of the Mantrapod RV64G journey: add the RV64I build target, get a minimal hello on qemu-system-riscv64
think the QEMU virt memory map is identical across word widths -- UART at 0x1000_0000, test finisher at 0x0010_0000, RAM base at 0x80000000 -- so the hello64 stage reuses the same addresses as hello.rye
think first build attempt with default flags hit R_RISCV_HI20 out of range -- on RV64, lui sign-extends to 64 bits, so the medlow code model (absolute addressing) can only reach [-2GiB, +2GiB). code placed at 0x80000000 is right at the boundary
think adding -OReleaseSmall stripped debug runtime but one relocation in kmain still overflowed by exactly one past the boundary value of 524288
think the cure is -mcmodel=medany, which uses PC-relative addressing (auipc instead of lui) -- works regardless of absolute address. both flags needed together: -OReleaseSmall -mcmodel=medany is the standing RV64 recipe
think this does NOT affect RV32I because the 32-bit address space is only 4GiB and lui+addi can reach all of it
obs the medlow vs medany discovery is the real technical finding of this orbit -- it will govern every future RV64 stage in Terrarium
obs witness proves three things: build succeeds on riscv64-freestanding-none, QEMU wake prints expected output containing "RV64I", and file(1) confirms 64-bit RISC-V ELF identity
rota none -- pure implementation, no rota this lap
orbit round 9 Sagittarius -- the archer aims
[file](../../terrarium/src/hello64.rye) RV64I hello stage -- hart wakes, speaks to UART, halts via sifive test finisher
[file](../../terrarium/layout64.ld) RV64I linker script -- same base address 0x80000000 as RV32I, ENTRY(_start), .text.init first
[file](../../tools/te/terrarium_run64.rish) RV64I build + QEMU wake runner -- carries -OReleaseSmall -mcmodel=medany
[file](../../terrarium/hello64_witness.rish) Orbit 1 witness -- build, wake, ELF identity, GREEN on metal
[file](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 1 marked GREEN with stamp and witness
[file](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md) Orbit 1 entry prepended
[file](../../construction/ITINERARY.md) fascia 60.083 -> 60.084 with Mantrapod RV64G Orbit 1
[file](../../README.md) fascia badge 60.083 -> 60.084
scope this session, this hand
status written before send
recommend kg -- Orbit 2 is the _start + UART port from RV32I stages, mechanical with medany recipe now proven
