format session-log-v1
stamp 20261105.154640
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 15 -- A extension integration witness
prompt kg after Orbit 14: land A extension integration witness proving all four A-extension modules together on 2-hart RV64IMA, final orbit of Quest 1.3
think Orbit 15 SLC gate: a_extension_witness.rish runs GREEN on 2-hart RV64MA. Integration pattern follows m_extension_witness from Orbit 10 -- build all modules, run each on QEMU with key assertions, combined instruction census.
think Four modules to compose: atomic_cap (7 proofs, lr/sc/amoadd/amoswap), atomic_registry (8 proofs, cmpxchgWeak/amoswap/amoadd), multi_hart (5 proofs, needs -smp 2, lr/sc/amoadd/fence), preempt (5 proofs, CLINT timer/CSR/context save-restore).
think Helper script design: build stage compiles all 4 with -mcpu=generic_rv64+m+a, reports individual and total ELF sizes. Census stage runs llvm-objdump across all 4 ELFs, counts A-ext (lr.w, sc.w, amoadd.w, amoswap.w) and trap (mret, csr*, sd, ld, fence) instructions with per-module and total breakdowns.
think Witness design: 7 stages matching integration pattern. Stage 1 probes CPU features (+a, +m, +zaamo, +zalrsc). Stage 2 builds all 4 via helper. Stages 3-6 run each module on QEMU with its key proof assertions. Stage 7 runs combined census.
obs All 7 stages GREEN on first run. Combined census: 37 A-ext instructions (13 lr.w, 13 sc.w, 8 amoadd.w, 3 amoswap.w), 21 CSR instructions (2 mret, 2 csrrw), 80 fence, 142 sd, 90 ld across 4 modules. 25 proofs total.
obs Per-module breakdown: atomic_cap 19 A-ext + 0 trap, atomic_registry 13 A-ext + 0 trap, multi_hart 5 A-ext + 1 trap, preempt 0 A-ext + 20 trap. The A-ext and trap instruction families are cleanly separated by module purpose.
obs Total ELF: 33,832 bytes (9120 + 10040 + 7128 + 7544). Quest 1.3 (A extension) is complete -- all five orbits landed.
loom witness=a_extension_witness stages=7 proofs=25 modules=4 a_ext_total=37 lr=13 sc=13 amoadd=8 amoswap=3 csr_total=21 fence=80 sd=142 ld=90 elf_bytes_total=33832
rota none -- pure implementation, no rota this lap
orbit round 15 Libra -- the air sign that weighs and balances
[terrarium/a_extension_witness.rish](../../terrarium/a_extension_witness.rish) 7-stage integration witness: features, build-all, 4 QEMU runs, combined census
[terrarium/a_extension_helper.sh](../../terrarium/a_extension_helper.sh) build-all and combined census helper for 4 A-extension ELFs
[active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 15 checked, Quest 1.3 complete
recommend keep-going -- Quest 1.4 (F/D extensions, Orbit 16: Glow floating-point expressions) is next
