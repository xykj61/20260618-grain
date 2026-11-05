format session-log-v1
stamp 20261104.194006
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 5 -- developer workflow and DX foundations
prompt kg (continue Terrarium boot journey -- Orbit 5 DX foundations)
think SLC gate for Orbit 5: git clone + one documented command builds and runs the RV32I hello on QEMU; MAP.md reflects the current tree shape. The three deliverables: Makefile, MAP.md update, and proof the workflow runs.
think The Makefile wraps the proven terrarium_run.rish script rather than duplicating its flags. One target: `make terrarium` (with STAGE variable defaulting to hello). This keeps the source of truth in one place and the Makefile as the newcomer's front door.
think .gitignore needs `!/Makefile` allow-back because the root `/*` deny-all pattern blocks any new root file by default. Added it beside the other root file allow-backs.
think MAP.md Room 4 module ring table gains terrarium/ ("a living world under glass (RV32I)") placed after aurora/ (the boot), since Terrarium is the glass that wraps Aurora's hart.
obs `make terrarium` proven on metal: "Terrarium hello: a hart woke on RV32I, spoke this line, and halted." with exit 0. The one-command workflow meets the SLC gate.
obs Quest 1.1 (The Clearing) is now complete -- all five orbits landed. Quest 1.2 (The Glass and the Seed) begins with Orbit 6, the Terrarium macOS application shell.
orbit round 15 Aries -- the orbit closes a clearing; the next opens the glass
file [Makefile](../../Makefile) root Makefile wrapping terrarium_run.rish for one-command build+run
file [.gitignore](../../.gitignore) added !/Makefile allow-back
file [MAP.md](../../MAP.md) added terrarium/ to Room 4 module ring table after aurora/
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) marked Orbit 5 done
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.062 -> 60.063; DX foundations added to landed orbits list
recommend keep-going -- Quest 1.1 complete; Orbit 6 (Terrarium macOS application shell) opens Quest 1.2
