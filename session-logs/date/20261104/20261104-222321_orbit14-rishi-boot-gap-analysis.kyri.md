format session-log-v1
stamp 20261104.222321
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 14 -- Rishi boot sequencer and self-compile gap analysis
prompt kg -- continue the Terrarium boot journey
think Orbit 14 has two SLC gates: (a) a Rishi script inside the pill calls three stages in order on QEMU, and (b) a gap analysis document names every missing feature with line counts
think for part (a), wrote rishi_boot.rye -- a 184-line Rye module proving Rishi's orchestration pattern on freestanding RV32I: three stages (memory, bounded, identity) called in order through function pointers in a Stage struct array, each returning ok (0) or not_ok (1), with the sequencer stopping on first failure
think the stage dispatch pattern uses a const array of Stage structs with name and function pointer fields, iterated with a for loop -- this is the Rishi `run` + check `ok` pattern compiled to bare metal
think stage_memory writes 0xDEAD_BEEF to 4 slots and reads them back, stage_bounded fills a budget of 6 with 2*idx+1 values and checks length and contents, stage_identity computes 15 two independent ways (3+5+7 and sum 1..5) and checks agreement
think for part (b), measured the full gap: Rishi interpreter is 5,014 lines across 5 files with 379 hosted stdlib refs, 21 process-spawning refs, 28 I/O refs, 265 memory refs, 27 dynamic allocation refs; Glow code generator is 290-line shell using 59 shell utility calls
think the honest gap: self-compilation requires rewriting the code generator in Rye (~400-600 lines), reading source from an embedded constant or Amphora vessel, and emitting assembly to UART or memory buffer -- narrower than porting the full Rishi interpreter
obs QEMU output: `rishi_boot: sequencing 3 stages` / `run memory ... ok` / `run bounded ... ok` / `run identity ... ok` / `rishi_boot: all 3 stages passed` -- exit code 0. The boot sequencer speaks on the bare hart
obs gap analysis names 9 missing Glow features (string processing, variable-length buffers, file I/O, shell execution, loops, pattern matching, multi-line strings, error handling, extended arithmetic) and 15 Rishi features with gap status (6 done, 3 remove, 2 architecture change, 2 medium gap, 1 small gap, 1 blocked on Orbit 16)
orbit round 14 Capricorn -- the verb is Stop
file [terrarium/src/rishi_boot.rye](../../terrarium/src/rishi_boot.rye) 184-line boot sequencer with 3 stages, function pointer dispatch, ok/not_ok protocol, 7 invariant assertions -- GREEN on QEMU freestanding RV32I
file [active-development/date/20261104/20261104-221943_rishi-self-compile-gap-analysis.md](../../active-development/date/20261104/20261104-221943_rishi-self-compile-gap-analysis.md) gap analysis measuring Rishi interpreter (5,014 lines, 379 hosted stdlib refs) and Glow code generator (290-line shell, 59 utility calls) against self-compilation requirements
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 14 marked done
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.071 -> 60.072, nib carried forward
recommend keep-going -- Orbit 15 is the keystone: self-compile proof where the pill compiles its own source and the hash matches
