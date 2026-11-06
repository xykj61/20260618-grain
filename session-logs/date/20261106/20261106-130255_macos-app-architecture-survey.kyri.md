format session-log-v1
stamp 20261106.130255
session-header [20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md](20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md)
voice Kyri
title macOS application architecture survey and tablecloth bookmark
prompt Keaton asked four questions: bookmark the Mantrapod board idea in the tablecloth, show how to launch the native macOS app, is it one app or many, and have we solved Brushstroke/Skate dynamic routing, scene tabs, page navigation, mouse/keyboard, and keyboard shortcut interface design.
think Searched the entire tree for routing, scene tabs, navigation, keyboard shortcuts. Found none. The macOS surface is four separate pieces: Terrarium (AppKit app for QEMU), SkateCore (Swift library), Brushstroke (80 Rye modules), and 7 macOS probes proving the Rye-to-AppKit ObjC runtime seam.
think EventRing is a generic bounded ring buffer with no event vocabulary. FrameGrid is layout. The macOS probes proved NSView registration, resize, menu bar, and app lifecycle through the ObjC runtime -- the wiring works, yet no application sits on top of it.
think Brushstroke filmstrip modules have scroll/scrub for navigating image frames -- filmstrip-specific, not app-level routing.
obs Honest answer: dynamic routing, scene tabs, page navigation, and keyboard shortcut interface design do not exist. The foundation is laid (Rye-to-AppKit seam proven, bounded data structures ready), yet the architecture composing them into a navigable, keyboard-driven application is future work.
obs Bookmarked the Milk-V Mars 4 GB board acquisition in the tablecloth journey checklist. Board acquisition awaits Keaton's word.
orbit round 10 Capricorn -- the verb is stop
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) added Bookmarks section with board acquisition details
recommend check-in (Claude) -- the macOS application surface is several separate pieces awaiting composition; dynamic routing, scene tabs, and keyboard shortcuts are future chapters to open on Keaton's word
