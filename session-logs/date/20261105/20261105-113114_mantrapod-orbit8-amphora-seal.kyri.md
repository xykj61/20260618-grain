format session-log-v1
stamp 20261105.113114
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 8 -- Amphora seal performance on RV64M
prompt kg -- Orbit 8: Amphora seal performance on RV64M
think djb2 content-addressing hash uses h *% 33 -- does the compiler emit hardware mul or strength-reduce to shift+add?
think build amphora_seal.rye targeting -mcpu=generic_rv64+m (RV64IM only)
think vessel structure: 128-byte header (format, stamp, shoulder) + 3968-byte cargo (repeating 0x00-0xFF) = 4096 bytes
think three tests: seal the vessel (compute djb2 over all 4096 bytes), verify (recompute and compare), tamper (flip one byte, confirm hash changes)
think RDCYCLE instruction for on-chip cycle counting of seal and verify operations
think first witness attempt used wrong Rishi syntax (${features.ok} instead of assert features.ok) -- fixed by reading Orbit 7 working patterns
think QEMU riscv64 does not support -device sifive_test -- program terminates via wfi loop with timeout 10 wrapper
obs djb2 h *% 33 compiles to genuine hardware mul instruction at 0x8000064c -- the compiler does NOT strength-reduce multiply-by-33 to shift+add on RV64IM with -OReleaseSmall
obs disassembly shows 1 mul (djb2 hot loop) + 2 divu/divuw (print_u32 division by 10) = 3 M-extension instructions total
obs seal hash 0x3f401b51, verify PASS, tamper detected -- all three proofs on a single 4 KiB vessel
obs ELF 6792 bytes, build 156 ms, run 120 ms, seal approximately 40K cycles, verify approximately 61K cycles
obs fascia 60.090 -> 60.091 (0.001 per proven orbit)
file [terrarium/src/amphora_seal.rye](../../terrarium/src/amphora_seal.rye) freestanding Amphora vessel seal with djb2 hash, 4 KiB vessel, seal/verify/tamper tests
file [terrarium/amphora_seal_witness.rish](../../terrarium/amphora_seal_witness.rish) 5-stage witness: CPU features, build, QEMU run, disassembly, wall time -- GREEN on metal
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 8 checked off
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md) Orbit 8 entry prepended
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.090 -> 60.091, Orbits 1-7 -> Orbits 1-8
file [README.md](../../README.md) fascia badge 60.090 -> 60.091
orbit round 6 Virgo -- the law that must stop
recommend keep-going -- Orbit 9 next: software division removal survey across freestanding sites
