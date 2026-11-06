format session-log-v1
stamp 20261106.130454
session-header [20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md](20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md)
voice Kyri
title Architecture questions answered -- macOS app, navigation, Realidream distinctions
prompt Keaton asked four questions: how to launch the native macOS app, is it one app or many, has Brushstroke/Skate navigation been designed, and should this be a Realidream application with unified or distinct layers
think Spawned two research forks: one for macOS app launch and structure, one for Brushstroke/Skate navigation design status. The navigation fork returned comprehensive answers covering all four parts. Read SkateCore Swift Package, Brushstroke sources, Terrarium app, Pond/Realidream files, the Realidream foundation document, and the Lexicon entry.
think Terrarium is the one native macOS app -- 821-line single-file AppKit wrapping QEMU for RISC-V emulation. SkateCore is a headless Swift test library. Brushstroke is Rye rendering modules. Seven macOS probes prove the Rye-to-AppKit seam. None beyond Terrarium is a launchable application.
think Dynamic routing, scene/tab/page navigation, and keyboard shortcuts are NOT designed yet. The foundation is laid -- SkateCore data types, proven Rye-to-AppKit seam, Swift 6.2 AppKit decision -- yet the composing architecture does not exist. The Skate DAG rendering platform proposals sit behind DJINN's custody gate %6.
think On Realidream: the tree already draws clear distinctions. Realidream is the branded Pond/Pool application face, Skate is the paint framework, Brushstroke is the rendering language. Recommended keeping the three-layer distinction -- each layer serves a different reader. Terrarium stays in its own lane. Composing them into one navigable macOS application would be a new journey.
obs The macOS surface today is one working application (Terrarium) and several proven capabilities awaiting composition. The Realidream vision -- editor and browser as one -- lives in foundations and Pond modules yet has no running shell. Opening the navigation and routing chapter requires DJINN's gate %6 and Keaton's word.
orbit round 10 Capricorn -- the verb is stop
file [skate/Package.swift](../../skate/Package.swift) read: Swift Package with SkateCore library, headless data types
file [terrarium/app/main.swift](../../terrarium/app/main.swift) confirmed: the one native macOS app, 821 lines, AppKit + QEMU
file [foundations/20260825-233310_realidream.md](../../foundations/20260825-233310_realidream.md) read: editor and browser as one, over a single graph, targets Skate
recommend check-in (Claude) -- composing SkateCore, Brushstroke, and the proven Rye-to-AppKit seam into one navigable macOS application with dynamic routing and keyboard shortcuts is a new journey awaiting Keaton's word; board acquisition also awaits
