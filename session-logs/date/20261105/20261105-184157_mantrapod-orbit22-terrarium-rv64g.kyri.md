format session-log-v1
stamp 20261105.184157
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 22 -- Terrarium macOS app on RV64G
prompt kg -- land Orbit 22, Terrarium launches qemu-system-riscv64 for _g stages
think Orbit 22 asks the Swift Terrarium app to launch riscv64 instead of riscv32 for RV64G stages. The _g suffix convention names ELFs built for full RV64G (IMAFD). is64Bit already checked hasSuffix("64") from earlier orbits; added hasSuffix("_g") so both naming conventions select riscv64. Also discovered multi_hart_g needs -smp 2 -- added isMultiHart = stage.hasPrefix("multi_hart") and injected -smp 2 into the QEMU argument list when true.
think Wrote terrarium_rv64g_witness.rish proving 4 stages through the glass: glow_app_g (10/10 correct), steward_g (2 domains UP), amphora_seal_g (seal verify + tamper detect), multi_hart_g (atomic proofs on 2 harts). Initial run caught the multi_hart gap -- hart 1 timed out without -smp 2. Added the flag, rebuilt, ALL GREEN.
obs Three changes to main.swift: line 3 comment updated to say "riscv32 or riscv64", line 28 isMultiHart detection added, line 181 -smp 2 injected for multi-hart stages. The is64Bit change from the prior conversation (hasSuffix("_g")) was already in place.
orbit round 9 Scorpio -- Investigate
file [terrarium/app/main.swift](../../terrarium/app/main.swift) isMultiHart detection and -smp 2 injection for multi-hart stages through the glass
file [terrarium/terrarium_rv64g_witness.rish](../../terrarium/terrarium_rv64g_witness.rish) Orbit 22 SLC gate: 4 stages proven through Terrarium on riscv64
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 22 checked off with landing stamp
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.104 -> 60.105, Orbit 22 description added
recommend keep-going -- Orbit 23 next: WASM emulation horizon scoping, survey existing RISC-V-to-WASM projects, name the build path, estimate the orbit cost
