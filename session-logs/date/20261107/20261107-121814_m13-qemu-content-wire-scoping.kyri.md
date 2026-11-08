format session-log-v1
stamp 20261107.121814
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title M13 scoping -- QEMU content wire protocol design
prompt continue from prior context -- M13 next after M12 pushed
think M13 spec says "the same request-response that ran on localhost in movement 10 runs inside the Terrarium emulator"
think M10 used hosted Rye with libc UDP sockets -- freestanding RISC-V guest has no libc, no networking
think existing Terrarium pattern: UART serial wire protocol between guest and Swift host (see mantra_wire stage)
think M13 approach: new CREQ/CRESP wire protocol over UART, same content addressing and SHA3 verification, transport changes from UDP to UART
think three pieces needed: freestanding guest (terrarium/src/comlink_content.rye), Swift host stage (content_wire in main.swift), Rishi witness
think this crosses a module seam -- Terrarium Swift app is 3,733 lines, needs a new stage handler
obs only qemu-system-riscv32 available, no user-mode emulation -- must use Terrarium freestanding pattern
obs existing wire protocols: WIRE:fact/ACK (simple), MFACT/MSEED/MSTATE/MVERIFY (Mantra), both use UART serial
obs the "same request-response" means same content, same digest verification, same peers -- only transport differs
file [terrarium/boot_witness.rish](../../terrarium/boot_witness.rish) read -- 9-stage boot witness showing QEMU freestanding pattern
file [terrarium/src/mantra_wire.rye](../../terrarium/src/mantra_wire.rye) read -- Mantra wire protocol, closest prior art
file [terrarium/app/main.swift](../../terrarium/app/main.swift) read lines 2560-2640 -- wire and Mantra wire handlers
file [expanding-prompts/date/20261107/20261107-085813_mantra-slc-comlink-realidream.md](../../expanding-prompts/date/20261107/20261107-085813_mantra-slc-comlink-realidream.md) read M13 spec
recommend check-in (Claude) -- M13 crosses the Terrarium Swift seam and introduces a new wire protocol; Keaton's word on the UART-relay approach before building
