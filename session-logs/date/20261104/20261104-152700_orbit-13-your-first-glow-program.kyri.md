format session-log-v1
stamp 20261104.152700
session-header [20261104-045214_ssh-decouple-and-nib-amend.kyri.md](20261104-045214_ssh-decouple-and-nib-amend.kyri.md)
voice Kyri
title Orbit 13 -- Your First Glow Program tutorial
prompt kg -- Orbit 13
orbit round 15 Siya -- the chair
think Orbit 13 spec: Bhakta-at-Door tutorial walking a newcomer from zero to a running Glow program
think covers what Glow is (one sentence), the five value types, bound-tick, face-lit with library import, gate programs, the six standard operations, REPL mention, and an exercise
think verified all example commands on metal: bound-tick hello.glow prints 10, named.glow with lib-core-arith inc prints 6, gate-double-u32.glow 7 prints 14
think initial exercise used gate form (bartis with sample) which fails for user-created files due to glow_run_worker.sh stem whitelist -- rewrote to fixture form using face-lit with lib-core-number square
think initial named.glow example missing /+ lib-core-arith import -- added to match the real use-lib-arith-inc.glow pattern
think gate example changed from "write your own" to pointing at existing glow/gen/g/gate-double-u32.glow, with naming convention note
obs Bhakta witness GREEN: pages=61 miss=0 verdict=ok
obs fascia 60.057 -> 60.058
[docs-geode/tutorials/your-first-glow-program.md](../../docs-geode/tutorials/your-first-glow-program.md) Bhakta-at-Door tutorial: bound-tick, face-lit, gate, six operations, exercise, radiant wish
[docs-geode/tutorials/README.md](../../docs-geode/tutorials/README.md) added row for Your First Glow Program
[tablecloth/20261103-184811_glow-language-journey/CHECKLIST.md](../../tablecloth/20261103-184811_glow-language-journey/CHECKLIST.md) Orbit 13 checked off
[construction/ITINERARY.md](../../construction/ITINERARY.md) fascia bumped to 60.058; Glow 11-13 in the line
[README.md](../../README.md) fascia badge updated to 60.058
recommend kg -- Orbit 14 is next: "Glow Meets the Screen" tutorial, Calfive round 14
