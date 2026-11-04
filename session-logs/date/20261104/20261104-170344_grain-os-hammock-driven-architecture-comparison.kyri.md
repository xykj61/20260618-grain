format session-log-v1
stamp 20261104.170344
session-header [20261104-164949_orbit-1-root-consolidation-survey.kyri.md](20261104-164949_orbit-1-root-consolidation-survey.kyri.md)
voice Kyri
title grain-os Hammock-Driven architecture comparison
prompt Keaton asked to clone node777/grain-os as gratitude, compare DJINN's architecture to ours, and ask lots of questions for Mantra/Manyana-inspired diff resolution following Rich Hickey's Hammock-Driven-Design questions rubric
think read all eight grain-os docs: README.md, CLAUDE.md, ARCHITECTURE.md (1,164 lines), CAPABILITY_MODEL.md, GLOSSARY.md, BRIX.md, PLAN.md, RESEARCH.md
think grain-os is a working Zig capability microkernel at Phase 9 hardening -- nine phases each with exit criteria met, fuzz testing, model checking, deterministic simulator, aarch64 port, PCIe drivers, browser emulator, MCP-bridged AI agent interface
think fourteen module names shared between both trees: Caravan, Aurora, Tablecloth, Kumara, Brix, Steward, Envoy, Surf/Brushstroke, Amphora, Comlink, Mycelium, Mantra, Tally, Pond -- grain-os has working Zig implementations while our tree has designs and partial Rye implementations
think GLOSSARY.md explicitly says Glow/Rye are "From the owner's other project; not adopted" -- DJINN built grain-os in pure Zig without adopting the Glow/Rye language layer
think key fork decisions: rv64 vs rv32i, pure Zig vs Rye/Glow, ZON vs Kyri for Brix output, generation-based revocation (no derivation tree), Zig comptime IDL, self-issued Ed25519 identity, deterministic simulation testing, grain-emu vs Terrarium
think grain-os's Envoy protocol (discover/plan/apply/undo/ask/observe with MCP bridge) is arguably its most novel contribution -- exactly what our foundations describe but have not yet built
think recommendation: study and infuse, with a composition seam as the horizon -- adopt grain-os's proven patterns as design inputs, keep our language stack, witness discipline, and civic direction
obs grain-os's generation-based revocation is a strong departure from seL4's derivation tree -- CAPABILITY_MODEL.md's own Question 1 asks about aliases the kernel does not track
obs the "command language" grain-os proposes (typed pipelines over capabilities) maps naturally onto Glow, which is already a typed functional language with a pipeline concept
obs grain-os has no license chosen yet -- PLAN.md says "it should be settled before outside contributions" -- this is a gate for any composition approach
orbit round 13 Aquarius -- the water bearer pours; let the study pour observations for Keaton and DJINN to weigh
[active-designing/date/20261104/20261104-165753_grain-os-hammock-driven-architecture-comparison.md](../../active-designing/date/20261104/20261104-165753_grain-os-hammock-driven-architecture-comparison.md) Hammock-Driven comparison of grain-os to our tree -- 14 shared modules, 12 fork decisions, 12 questions for Keaton and DJINN
recommend check in (either) -- the twelve questions need Keaton and DJINN's word before any fork decision can move; the comparison document is the deliverable and it is written
