format session-log-v1
stamp 20261104.194849
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 6 -- Terrarium macOS application shell
prompt kg (continue Terrarium boot journey -- Orbit 6 macOS app shell)
think SLC gate for Orbit 6: a native macOS window that launches qemu-system-riscv32 as a dependent process and captures its serial output -- the glass you look through. Prove the window opens, QEMU starts, and the hello program speaks through the glass.
think Single-file AppKit approach in terrarium/app/main.swift. NSWindow with NSTextView (black background, green monospaced text). Foundation Process spawns QEMU with -nographic, Pipe captures stdout. readabilityHandler dispatches output to main thread and appends to the text view. 10-second timeout auto-terminates QEMU. On termination, dumps text view content to stdout for verification and exits.
think Makefile gains two new targets: terrarium-build (ELF only, using the same rye build flags as terrarium_run.rish) and terrarium-app (depends on terrarium-build, compiles Swift, runs the app). The terrarium-build target extracts the build command from the Rishi script into Make so the GUI path does not need to run the full Rishi script.
think The #filePath trick resolves the repo root at compile time from the source file's own location (terrarium/app/ -> terrarium/ -> root), so the app finds the ELF without hardcoded paths.
obs Proven on metal: swiftc compiled clean, make terrarium-build produced the ELF, the Terrarium window launched, QEMU started as a dependent (pid visible), and the hello program's output appeared: "Terrarium hello: a hart woke on RV32I, spoke this line, and halted." followed by "qemu exited with status 0". SLC gate met.
obs Quest 1.2 (The Glass and the Seed) is now open. Orbit 7 ports Aurora's seed to RV32I.
orbit round 15 Aries -- the glass opens; a hart speaks through it
file [terrarium/app/main.swift](../../terrarium/app/main.swift) AppKit window launching QEMU as a dependent, capturing serial output in NSTextView
file [Makefile](../../Makefile) added terrarium-build and terrarium-app targets
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) marked Orbit 6 done
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.063 -> 60.064; macOS app shell added to landed orbits
recommend keep-going -- Orbit 7 (RV32I Aurora seed port) is the next keystone
