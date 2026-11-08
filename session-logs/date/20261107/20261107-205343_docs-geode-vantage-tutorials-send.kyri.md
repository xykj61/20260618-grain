format session-log-v1
stamp 20261107.205343
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title docs-geode Vantage tutorials and bloom-demos update -- send
prompt Keaton approved three docs-geode tutorial pages before closing the journey: building-vantage, vantage-wasm-compilation, and updating bloom-demos-in-terrarium

think building-vantage.md written from scratch -- Bhakta at Door, covers Vantage architecture, the FFI surface (12 bloom functions in a table), native build commands, selftest (15 claims), shared library build, and cross-references to the WASM tutorial and bloom-demos
think vantage-wasm-compilation.md written from scratch -- covers WASM and WASI in first-principles order, the build command with single-stranded $ROOT derivation (Keaton's requirement), what the binary exports (15 symbols) and imports (32 WASI functions), the readCStr pattern for C strings from WASM memory, and what to try next (browser shell)
think bloom-demos-in-terrarium.md updated -- added a "Where the content comes from" section explaining the Vantage extraction architecture (content defined once in Rye, platform shells call FFI functions), updated fourteen-galaxy references to fifteen (~siya added as the fifteenth galaxy), added ~siya to the galaxy name list, added cross-references to the two new tutorials
think tutorials README.md index updated with rows for both new tutorials
think Keaton also asked about the Bhakta -> Teacher Style molt-breach -- confirmed it was approved but deferred to Quest 5, recommended finishing this documentation round first then opening the molt as its own round, Keaton approved

obs three tutorial pages complete -- the documentation round for the Vantage extraction journey is landed
obs the Bhakta -> Teacher Style molt-breach is approved and ready to open as the next round on Keaton's word

file [docs-geode/tutorials/building-vantage.md](../../docs-geode/tutorials/building-vantage.md) new tutorial -- Vantage architecture, FFI surface, native build, selftest
file [docs-geode/tutorials/vantage-wasm-compilation.md](../../docs-geode/tutorials/vantage-wasm-compilation.md) new tutorial -- WASM/WASI build with $ROOT derivation, exports, readCStr
file [docs-geode/tutorials/bloom-demos-in-terrarium.md](../../docs-geode/tutorials/bloom-demos-in-terrarium.md) updated -- Vantage extraction section, fourteen -> fifteen galaxies, ~siya added, cross-references
file [docs-geode/tutorials/README.md](../../docs-geode/tutorials/README.md) added index rows for both new tutorials

recommend keep-going -- open the Bhakta -> Teacher Style molt-breach as the next round, then Quest 3 WASM scoping
