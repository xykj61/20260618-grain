format session-log-v1
stamp 20261107.155516
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title main.swift static data extraction survey complete
prompt kg -- identify the next static data cluster in main.swift for vantage/ extraction
think read the full 3,530-line file in stages: lines 30-200, 200-534, 536-900, 900-1200, 1200-1700, 1700-2050, 2050-2250
think mapped every function, data structure, and code section across the entire file
think the two major static data clusters -- Bloom (lessons, navigation, categories) and Dimeroll (modules, query types, column configs) -- are already extracted
think remaining code is: AppKit UI setup and layout, QEMU process management, seven stateful parseDimeroll* parsers, wire protocol handlers, FrameGridView rendering, Mantra crypto helpers
think sidebarModules is the only remaining static data -- 5 items, too small to justify its own FFI module and shared library
think stage classification booleans (lines 39-48) derive from runtime CLI args, not static configuration
think launchQemu timeout values (lines 2197-2202) are stage-conditional runtime behavior, not extractable data
think considered extracting Mantra crypto helpers (Djb2Swift, keyedDjb2Sign, hexToBytes, writeU32BE) -- 60 lines of pure algorithm
think crypto helpers are too small and too tightly coupled to the stateful handleMantraWire loop for FFI to be worthwhile -- djb2 is four lines of math, FFI overhead per hash call would cost more than it saves
think checked crypto/ library -- has real crypto (ed25519, sha256, etc.) but djb2 is non-cryptographic and does not belong there
think checked SkateCore (1,409 lines across 9 files) -- all UI types (FrameGrid, EventRing, ConsentRail, AccessibilitySnapshot), nothing extractable
think checked terrarium/ for other source files -- only main.swift exists
obs Quest 1 "Extract Vantage" is complete for what is extractable today -- Bloom and Dimeroll were the two data clusters, both proven with 30 FFI symbols and 30 selftest claims across two witnesses GREEN
obs the RFC estimated approximately 1,800 lines moving to vantage/ -- 312 moved so far, the gap reflects that most remaining code is AppKit UI and stateful I/O rather than data or pure logic
obs the remaining Quest 1 movements should pivot to Quest 2 territory -- restructuring the monolith into a Station shell is where the real line-count reduction lives
orbit round 5 Aries -- the talent verb
rota lap 14600, row 0 -- Aether, the row that hears; surfaced: the survey listened for extraction targets across the whole codebase and heard that the harvest is complete
[terrarium/app/main.swift](../../terrarium/app/main.swift) full scan complete -- no extractable static data or pure logic remains that justifies FFI overhead
[skate/Sources/SkateCore/](../../skate/Sources/SkateCore/) 1,409 lines, all UI types -- nothing extractable
[crypto/](../../crypto/) existing library has real crypto; djb2 does not belong there
recommend check-in (Claude) -- Quest 1 extraction harvest is complete, the next constructive work is Quest 2 Station macOS shell restructuring
