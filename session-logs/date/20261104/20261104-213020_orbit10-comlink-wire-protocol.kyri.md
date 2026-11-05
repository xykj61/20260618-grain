format session-log-v1
stamp 20261104.213020
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
title Orbit 10 -- Comlink wire protocol
prompt kg -- continue the Terrarium boot journey
orbit round 5 Leo -- the talent that shines
think the wire protocol proves bidirectional UART communication between the RV32I guest and the Terrarium macOS host -- the channel that carries Mantra facts in Quest 1.4
think guest stage wire.rye sends WIRE:fact=terrarium.orbit.10 over UART TX and polls LSR bit 0 for the host's ACK response on UART RX, bounded at 200M polls
think host main.swift accumulates serial output into serialBuffer, detects a complete fact line with regex WIRE:fact=.+\n, extracts the value, and writes ACK:value\n back through Process.standardInput pipe to QEMU's stdin, which QEMU delivers to guest UART RX
think first run failed: pipe chunk splitting caused the host to trigger on partial WIRE:fact=t before the full line arrived -- same class of red as the Orbit 9 framebuffer trigger, fixed by requiring a complete line with trailing newline via regex match
think wire stage uses -display none -serial stdio (not -nographic which multiplexes the QEMU monitor onto stdio and would corrupt the protocol)
obs wire.rye GREEN on RV32I: sends structured fact over UART TX, polls UART RX with bounded busy-wait, compares ACK against expected string, prints WIRE ROUND-TRIP CONFIRMED
obs main.swift wire support proven on metal: serialBuffer regex trigger detects complete fact line across chunk splits, inputPipe delivers ACK through QEMU stdin to guest UART RX
obs full pipeline GREEN: guest sends fact, host receives and ACKs, guest confirms round-trip, QEMU exits cleanly (0)
obs the SLC gate is met -- a message sent from the RV32I guest arrives at the Terrarium host and a response travels back, logged on both sides
file [terrarium/src/wire.rye](../../terrarium/src/wire.rye) guest-side Comlink wire stage: send fact, poll for ACK, verify round-trip
file [terrarium/app/main.swift](../../terrarium/app/main.swift) wire stage support: isWireStage config, inputPipe for stdin, regex trigger for complete fact lines, handleWireFact method
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 10 marked done
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.067 -> 60.068; Comlink wire protocol added to landed list
recommend kg -- Quest 1.2 is complete; Orbit 11 (Minimal Glow-to-RV32I code generator) opens Quest 1.3 -- the Pill
