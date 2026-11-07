format session-log-v1
stamp 20261107.142101
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Caravan/Basin evaluation and hammock-driven design analysis
prompt reprint the design dialogue after evaluating the Caravan/Basin distinction and providing hammock-driven design analysis and question asking for the whole project proposal
think Basin in the living tree is basin/basin.rye -- a circular buffer, the ScribexTally monitor's holding pool. The Lexicon (line 225) records exactly this. Zero references to Basin in terrarium/src/. The elder whitepaper's "Basin kernel" was never built.
think Caravan is the complete supervision and capability model: 114 hosted Rye modules (objects, entrust, revoke, exercise, capabilities, domains, channels, regions, grants). Freestanding proofs at terrarium/src/caravan_cap.rye (capability model on RV32I) and caravan_supervision.rye (per-dependent Tally budgets).
think preempt.rye implements M-mode scheduling with CLINT timer interrupts and context switching -- it IS the privileged layer. The "kernel" the elder whitepaper attributed to Basin is already Caravan (supervision/capabilities) + preempt.rye (hardware scheduling), proven both hosted and freestanding.
think Rich Hickey's hammock-driven development: state the problem, ask the hard questions, sleep on them. The six questions: (1) is platform coupling the actual pain or monolith pain? (2) is Vantage a module or a pattern? (3) does Terrarium lose its app or does the app lose its coupling? (4) is Station one module or three? (5) are Pond's 30+ apps the proto-Vantage? (6) what is the simplest thing that could work?
think four options named: A (split main.swift into three Swift files), B (extract logic to Rye vantage/, keep Swift shell), C (full decomposition -- Vantage/Station/Carry/Terrarium-as-library), D (Pond absorbs the role). The hammock says name the second platform and build one thing for it before designing the abstraction.
obs Basin is not a kernel. Basin is a circular buffer. The elder whitepaper's "Basin kernel" concept was absorbed by Caravan (114-module supervision system) + Terrarium (40-stage freestanding proving ground). A future kernel composing preempt + caravan_cap + caravan_supervision would be called Caravan on hardware -- same module, lower privilege level.
obs the hammock analysis raises six question families organized by what they question: the problem itself, Vantage's identity, Terrarium's scope, Station/Carry shape, Pond/Vantage relationship, and the simplest thing that could work. Each family carries concrete checkable sub-questions.
obs the deepest question is whether the second platform is near enough to justify the abstraction now, or whether Option A (split main.swift) buys 80% of the clarity at 10% of the cost. The hammock says the abstraction follows the second implementation, not the first.
file [basin/basin.rye](../../basin/basin.rye) circular buffer module -- ScribexTally monitor holding pool, NOT a kernel
file [caravan/README.md](../../caravan/README.md) 114 hosted modules, 121 witnesses, five words: dependent/domain/channel/region/grant
file [terrarium/src/caravan_cap.rye](../../terrarium/src/caravan_cap.rye) freestanding capability model -- domains, capabilities, bounded leases, direct MMIO
file [terrarium/src/caravan_supervision.rye](../../terrarium/src/caravan_supervision.rye) freestanding process supervision -- per-dependent Tally budgets
file [terrarium/src/preempt.rye](../../terrarium/src/preempt.rye) M-mode scheduler -- CLINT timer, context switch, the privileged layer itself
file [gratitude/grain-sketchbook/docs/2026-03-27-002209-edt-rye-basin-vantage-toroidal-kernel-whitepaper.md](../../gratitude/grain-sketchbook/docs/2026-03-27-002209-edt-rye-basin-vantage-toroidal-kernel-whitepaper.md) elder whitepaper -- Basin and Vantage definitions superseded by living tree
file [pond/README.md](../../pond/README.md) OS application module -- customs, enclosure policy, 30+ apps in apps/
recommend check-in (Claude) -- Keaton's word on the six hammock questions, the Pond/Vantage distinction, and which of the four options to pursue before writing the RFC document
