format session-log-v1
stamp 20261104.234010
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 17 -- Aurora framebuffer and console on freestanding RV32I
prompt kg -- land Orbit 17 Aurora console on RV32I

think Orbit 17 brings visibility to the TAME boot: Aurora draws to a ramfb framebuffer on the bare RV32I hart, with all memory bounded by Tally's arena
think the module needs to handle two modes -- serial-only (no ramfb device, exit via test finisher) and display (ramfb via fw_cfg DMA, wfi loop for screendump capture)
think fw_cfg DMA is DEVICE_BIG_ENDIAN -- the little-endian RV32I guest must byte-swap every register access
think static memory layout: code at 0x80000000, stack at 0x80100000, ramfb cfg at 0x80180000, DMA at 0x80180100, framebuffer at 0x80200000
think framebuffer is 320x240 XRGB8888 = 307200 bytes, bounded by Tally arena budget of 311296 bytes with 4096 remaining for overhead
think 8x8 bitmap font gives 40x30 glyph grid -- enough for a meaningful boot status display
think console_putc mirrors every character to UART first, then draws to framebuffer only when has_display is true -- one code path for both modes

obs UART mirror red: console_puts called uart_puts for whole strings, but console_print_u32 called console_putc per digit, which did not mirror to UART -- numbers vanished from serial output; fixed by adding uart_tx write at the top of console_putc and removing the redundant uart_puts from console_puts
obs ramfb optional red: find_ramfb_selector hit unreachable when no ramfb device present in serial-only mode; fixed by returning ?u16 and gating all framebuffer operations on has_display bool
obs main.swift red: isFramebufStage only matched "framebuf", not "aurora_console" -- QEMU launched without -device ramfb; fixed by adding || stage == "aurora_console"
obs serial-only mode GREEN: full boot sequence with all numbers, ceiling REFUSED, clean exit code 0 via sifive test finisher
obs display mode GREEN: ramfb found via fw_cfg directory traversal, DMA configured, framebuffer captured via QMP screendump, PPM parsed and displayed in Terrarium NSImageView
obs Tally arena bounds the entire framebuffer: 307200 of 311296 bytes allocated, remaining = 0 after overhead, OutOfBounds ceiling refusal proven
obs fascia 60.074 to 60.075; Quest 1.4 Orbit 17 complete

loom terrarium=aurora_console serial_exit=0 display_mode=GREEN arena_budget=311296 fb_bytes=307200 glyphs=40x30 font=8x8

orbit round 2 Taurus -- what must stop: unbounded framebuffer allocation stops here, Tally holds every byte

[terrarium/src/aurora_console.rye](../../terrarium/src/aurora_console.rye) new module -- Tally-bounded ramfb framebuffer with 8x8 bitmap font console, optional display with serial fallback
[terrarium/app/main.swift](../../terrarium/app/main.swift) added aurora_console to isFramebufStage detection
[tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) marked Orbit 17 complete
[construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.074 to 60.075, Aurora console added to landed list

recommend keep-going -- Orbit 18 Mantra event log on freestanding RV32I, the replay layer completes the TAME triad
