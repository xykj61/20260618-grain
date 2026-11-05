format session-log-v1
stamp 20261104.230642
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 15 -- self-compile proof, the keystone
prompt kg -- continue Terrarium boot journey, Orbit 15

think the SLC gate asks: the self-compile runs on QEMU RV32I and each compiled output's Amphora hash matches the sealed vessel that compiled it
think the pill needs to embed its own Glow source, compile it to assembly in memory, hash the output, and compare against a sealed constant
think djb2 hash chosen because (h << 5) + h uses only shifts and adds -- no mul instruction needed on RV32I base ISA
think host-side seal script runs the shell code generator on the same source and computes the djb2 hash with python3 -- this is the ground truth
think the freestanding module reproduces the same algorithm: feed preamble bytes through hasher, format the li instruction line, feed postamble bytes, compare
think Zig multiline string literals (\\) each carry a trailing \n -- the assembly templates must be byte-identical to what the shell codegen emits
think the preamble is 379 bytes (18 lines), the li line is variable (li_prefix + decimal + newline), the postamble is 1567 bytes (71 lines), total 1965 bytes for fortytwo.glow

obs self_compile_seal.sh computes sealed_hash 0x079080D9 from the shell code generator's output
obs self_compile.rye builds cleanly for riscv32-freestanding-none on first attempt -- no errors
obs QEMU output: parsed literal = 42, computed hash = 0x079080d9, sealed hash = 0x079080d9, MATCH -- identity proven
obs exit code 0 from sifive test finisher -- the pill halts cleanly after proving identity
obs three new files: terrarium/src/seal/glow_source.txt (embedded source), terrarium/tools/self_compile_seal.sh (host seal), terrarium/src/self_compile.rye (the keystone module, 348 lines)
obs Quest 1.3 (The Pill) now complete: Orbits 11-15 all landed, from the first Glow-to-RV32I code generator through the self-compile proof

file [terrarium/src/self_compile.rye](../../terrarium/src/self_compile.rye) keystone module -- djb2 hasher, Glow parser, assembly templates, identity proof on freestanding RV32I
file [terrarium/src/seal/glow_source.txt](../../terrarium/src/seal/glow_source.txt) embedded copy of fortytwo.glow for compile-time @embedFile
file [terrarium/tools/self_compile_seal.sh](../../terrarium/tools/self_compile_seal.sh) host-side seal script computing ground-truth djb2 hash via python3
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 15 marked done
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.072 to 60.073, self-compile proof added to landed list

recommend keep-going -- Quest 1.3 complete; Orbit 16 opens Quest 1.4 (The TAME Boot)
