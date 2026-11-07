format session-log-v1
stamp 20261107.140727
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Terrarium bare-metal answer and design dialogue reprint
prompt reprint the design dialogue after also answering: is the Terrarium application running in our simulated RISC-V environment using Aurora/Caravan/Tally microkernel system call API surface?
think read steward.rye, preempt.rye, aurora_console.rye to confirm: every freestanding stage directly accesses hardware MMIO registers (UART at 0x10000000, test finisher at 0x00100000, CLINT at 0x200BFF8). No kernel, no syscall table, no trap handler dispatching to named services.
think steward.rye: reads a Brix manifest table and creates domains, but the "create" is a struct write to a registry array, not a syscall. UART output is bare uart_tx() writing one byte at a time to a volatile pointer.
think preempt.rye: CLINT timer interrupts trigger context switches between two domains. The scheduler saves and restores 31 GP regs + mepc directly. This is M-mode code acting as the kernel -- it IS the privileged layer, not calling into one.
think aurora_console.rye: framebuffer carved from Tally arena at 0x80200000, text rendered through an 8x8 bitmap font, fw_cfg DMA to QEMU ramfb device. All direct MMIO, no abstraction layer between application and hardware.
think the CREQ/CRESP wire protocol in comlink_content.rye sends bytes one at a time to uart_tx. The Swift host reads the serial pipe. This is character-level serial I/O, not a syscall interface.
think Basin -- the kernel that would sit between application code and hardware, providing named syscalls for Aurora console, Caravan capability operations, Tally allocation, and Mantra content -- has not been built. Each stage re-proves the design pattern from scratch, which is exactly what a proving ground does.
obs answer: NO. Terrarium freestanding stages implement Aurora/Caravan/Tally/Mantra as design patterns on bare metal with direct MMIO. Basin (the kernel providing a syscall API) does not exist yet. Each stage re-implements UART I/O and halt from scratch. The CREQ/CRESP wire protocol is serial I/O, not syscalls.
obs this is architecturally significant for Vantage: Terrarium's role is emulation bridge and OS-module proving ground, not application runtime. Write-once application logic (Bloom, Dimeroll, Realidream) currently lives in main.swift as platform-coupled Swift. Vantage would give it a platform-agnostic home.
obs reprinted the full 5-question design dialogue with the bare-metal answer prepended. Awaiting Keaton's word on Pond/Vantage distinction, quest shape, and whether to proceed with the RFC document.
file [terrarium/src/steward.rye](../../terrarium/src/steward.rye) root supervisor on RV32I -- reads Brix manifest, creates domains, all via direct MMIO
file [terrarium/src/preempt.rye](../../terrarium/src/preempt.rye) preemptive round-robin scheduler -- CLINT timer, M-mode context switch, two domains
file [terrarium/src/aurora_console.rye](../../terrarium/src/aurora_console.rye) framebuffer console -- Tally arena, ramfb DMA, 8x8 font, all direct MMIO
file [terrarium/src/comlink_content.rye](../../terrarium/src/comlink_content.rye) CREQ/CRESP wire protocol -- character-by-character UART serial, not syscalls
recommend check-in (Claude) -- Keaton's word on five design questions before writing the RFC document
