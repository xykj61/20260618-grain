format session-log-v1
stamp 20261105.115320
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 9 -- software division survey on RV64IM
prompt kg -- Orbit 9: software division removal survey across freestanding sites
think survey every multiply/divide site in all 17 freestanding sources, classify each as runtime/comptime/shift/assembly/strings
think grep for / % *% /= @divTrunc across terrarium/src/*.rye, found 59 sites in 14 files (3 files with zero arithmetic)
think runtime sites (38) all emit hardware M-extension instructions when built with -mcpu=generic_rv64+m
think comptime sites (8) resolved by the compiler at build time, no instruction emitted
think shift sites (7) are power-of-two multiplies/divides, strength-reduced to sll/srl/andi
think assembly site (1) is the Glow pill's own repeated-subtraction loop in self_compile.rye:157 -- Glow compiler output, not Rye arithmetic
think strings sites (5) are literal * and / inside string constants, not arithmetic operations
think Rishi interprets all $ in shell command strings as its own variable references -- moved shell loops to a helper script terrarium/m_ext_survey_helper.sh
think witness has 5 stages: CPU features, build all 17, disassembly M-ext check, software division check, clean module check
obs zero remaining software multiply/divide sites in authored Rye freestanding code
obs the one software division (Glow pill assembly in self_compile.rye) is the Glow compiler's own output -- a separate concern for a future orbit
obs 17/17 sources build for RV64IM, 13/13 arithmetic modules show hardware M-extension instructions, 0 software division loops
obs Rishi $ escaping lesson: no $ of any form can appear in Rishi shell command strings -- helper scripts are the clean solution for shell loops with variables
obs fascia 60.091 -> 60.092 (0.001 per proven orbit)
file [terrarium/m_ext_division_survey_witness.rish](../../terrarium/m_ext_division_survey_witness.rish) 5-stage witness: CPU features, 17/17 builds, 13/13 M-ext, 0 software division, clean check -- GREEN on metal
file [terrarium/m_ext_survey_helper.sh](../../terrarium/m_ext_survey_helper.sh) shell helper for survey witness, avoids Rishi $ interpretation with 4 stages: build, arith, swdiv, clean
file [active-development/date/20261105/20261105-114516_rv64m-software-division-survey.md](../../active-development/date/20261105/20261105-114516_rv64m-software-division-survey.md) survey document with full classification of all 59 arithmetic sites across 17 freestanding sources
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 9 checked off
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md) Orbit 9 entry prepended
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.091 -> 60.092, Orbits 1-8 -> Orbits 1-9
file [README.md](../../README.md) fascia badge 60.091 -> 60.092
orbit round 7 Libra -- the aesthetics that balance
recommend keep-going -- Orbit 10 next: M extension integration witness proving all M-ext work with hardware arithmetic throughout
