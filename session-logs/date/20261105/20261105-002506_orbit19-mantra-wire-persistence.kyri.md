format session-log-v1
stamp 20261105.002506
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 19 -- Mantra persistence through the wire
prompt kg -- continue through the Terrarium boot journey
think Orbit 19 asks guest-side Mantra facts to travel out through the UART wire and replay identically on the host side -- the green line between Terrarium and a pier
think guest module mantra_wire.rye builds the same 5-boot-fact MantraLog as Orbit 18 (identical seed, payloads, and algorithms), serializes each fact over UART in structured text: MSEED, MFACT, MSTATE lines
think host side in main.swift implements Djb2Swift (wrapping arithmetic with &<< and &+ operators), hexToBytes, writeU32BE, keyedDjb2Sign -- an independent djb2 implementation in Swift
think handleMantraWire parses seed from MSEED line, extracts seq/prev_hash/payload_len/tag/payload from each MFACT line, replays the chain verifying each tag and chain link, computes final state hash
think three Zig fixes needed: replaced ** repeat operator with while-loop copy (Zig 0.17 freestanding whitespace error), replaced [_]u8{0} ** 76 with undefined for canonical_bytes, replaced for (0..N) range with while loop
think one Swift fix needed: buf.contains("MSTATE:") triggered before the full 8-char hex hash arrived over serial -- changed to regex "MSTATE:[0-9a-f]{8}\n" to wait for complete line
obs both sides independently compute state hash 0xbc186e04 -- the same value Orbit 18 proved, now verified across the wire by an independent Swift implementation
obs MVERIFY:ok sent back through stdin pipe to guest UART RX, guest reads it, prints GREEN, exits cleanly via sifive test finisher
loom terrarium=mantra_wire facts=5 state_hash=0xbc186e04 wire_protocol=MSEED+MFACT+MSTATE host_verify=djb2_swift
file [terrarium/src/mantra_wire.rye](../../terrarium/src/mantra_wire.rye) guest module -- builds MantraLog, serializes over UART wire, waits for host verification
file [terrarium/app/main.swift](../../terrarium/app/main.swift) host handleMantraWire with independent Djb2Swift replay, regex-based MSTATE detection
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 19 marked complete
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.076 to 60.077
recommend keep-going -- Orbit 20 is the TAME boot integration witness, a single Rishi script proving the full boot sequence
