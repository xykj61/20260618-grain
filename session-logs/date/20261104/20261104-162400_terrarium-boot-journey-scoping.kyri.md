format session-log-v1
stamp 20261104.162400
session-header [20261104-045214_ssh-decouple-and-nib-amend.kyri.md](20261104-045214_ssh-decouple-and-nib-amend.kyri.md)
voice Kyri
title Terrarium boot journey -- scoping and project board
prompt Keaton redirected from parallel fleet ship work toward foundational boot process and microkernel. Target RV32I, no Nock, Terrarium as macOS native QEMU host, Urbit pill concept applied to real silicon. Project name terrarium-boot-journey
think read Aurora's proven stages -- seed.rye (69 lines, freestanding QEMU virt, UART, test_finisher), relay.rye (80 lines, Machine struct with usize hartid/isa, CSR reads via inline assembly), layout.ld (base 0x80000000), and aurora_run.rish (builds riscv64-freestanding-none, runs qemu-system-riscv64 -- both need RV32I equivalents)
think read Caravan boot.rye first 80 lines -- declaration-driven supervisor with five checkable properties (Coverage, Order, Fidelity, Constancy, Refusal), max_restarts_per_dependent=3, "hosted ground: real processes, pure policy, no kernel underneath it yet" -- needs to move to bare metal
think surveyed module sizes: Caravan 114 files ~300K lines, Tally 15 files ~1.7K lines, Mantra 15 files ~10.5K lines, aurora/src/ 11 stages
think initialized grain-www submodule at gratitude/grain-www and read DJINN's architecture: worker-based WASM RISC-V emulator, three configs in configs.json (dev full system with Steward/Caravan/screen/keyboard/disk, ktest kernel tests, faults failure handling), BLAKE3 for Envoy audit chain, virtio-gpu/input for desktop
think read DJINN's dev.brix manifest -- declaration-driven boot with Steward as builder, 15 domains (console, rng, flaky crash-recovery test, hello task, registry, kv store, envoy agent, consent, tablecloth content store, kumara identity, ledger signed log, surf desktop, shell, mycelium network, comlink, guestbook), each with named capabilities, bounded budgets, and protocol versioning. Agent block defines leased and askable grants
think boot sequence follows TAME priority order: (0) pill with compilers as raw RV32I assembly, (1) self-compile proves compilers real, (2) Tally bounds all allocation (safety first), (3) Aurora makes boot visible (performance second), (4) Mantra logs every fact (joy third -- deterministic replay), (5) Caravan supervises everything with named capabilities
obs the key width change for RV32I: relay.rye's Machine struct uses usize (64-bit on RV64, 32-bit on RV32I), and aurora_run.rish line 44 targets riscv64-freestanding-none while line 51 runs qemu-system-riscv64 -- both need riscv32 equivalents
obs DJINN's Brix manifest is the design Caravan should learn from: declaration-driven domains, named capabilities with protocols and budgets, Steward as root supervisor that reads the manifest and brings up the system. The pattern is proven in grain-www's browser emulator
obs scoped 23 orbits across 4 journeys: Journey 1 (pill and self-compile, 9 orbits), Journey 2 (TAME boot sequence with Tally/Aurora/Mantra, 6 orbits), Journey 3 (Caravan microkernel and Grain userspace, 5 orbits), Journey 4 (RV32I inside RV64G, 3 orbits future-scoped)
[tablecloth/20261104-161857_terrarium-boot-journey/README.md](../../tablecloth/20261104-161857_terrarium-boot-journey/README.md) project board README with argument, target ISA, boot sequence, design links
[tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) master checklist with 23 orbits across 4 journeys, SLC gates for each
[tablecloth/20261104-161857_terrarium-boot-journey/PROGRESS.md](../../tablecloth/20261104-161857_terrarium-boot-journey/PROGRESS.md) append-only progress log, board opened
[tablecloth/README.md](../../tablecloth/README.md) added terrarium-boot-journey board row, marked glow-language-journey Complete
[construction/ITINERARY.md](../../construction/ITINERARY.md) Incense reallocated to terrarium-boot-journey, Pheromone glow-language journey marked complete
recommend check in (Claude) -- the project board is scoped and the ITINERARY is updated; Keaton reviews the 23-orbit plan before Orbit 1 begins
