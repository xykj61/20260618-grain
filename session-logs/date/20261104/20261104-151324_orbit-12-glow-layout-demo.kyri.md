format session-log-v1
stamp 20261104.151324
session-header [20261104-045214_ssh-decouple-and-nib-amend.kyri.md](20261104-045214_ssh-decouple-and-nib-amend.kyri.md)
voice Kyri
title Orbit 12 -- Glow-driven layout demo in a Skate window
prompt kg -- Orbit 12
orbit round 14 Pisces -- the wish
think layout demo needs a table of operations evaluated at startup, displayed in a Skate window
think six entries chosen: add, sub, mul, mix (XOR), jam, cue -- the full stdlib tour
think repl_eval.evaluate computes each result; public constants let the witness prove geometry without AppKit
think row_y(i) = margin + (max_rows - 1 - i) * row_height gives top-to-bottom reading order in Cocoa bottom-left coords
think make_field helper takes a rect and text, creates a read-only NSTextField via objc_seam
think witness is standalone: proves all six operations match expected and all geometry bounds hold
think initial mix expected value wrong (383 instead of 127); 255 XOR 128 = 127, corrected
think unused string_cls parameter in verify_text_sels removed from signature and call site
obs witness GREEN: 6/6 operations proven, all geometry assertions hold
obs GUI confirmed on metal: 520x284 window, header + six labeled rows with computed results, Cmd+Q quit
obs fascia 60.056 -> 60.057
[glow/glow_layout_demo.rye](../../glow/glow_layout_demo.rye) Skate window with six stdlib operations in a column layout; table-driven, public geometry constants
[glow/glow_layout_demo_witness.rye](../../glow/glow_layout_demo_witness.rye) standalone witness proving 6 operations and geometry bounds without AppKit
[tablecloth/20261103-184811_glow-language-journey/CHECKLIST.md](../../tablecloth/20261103-184811_glow-language-journey/CHECKLIST.md) Orbit 12 checked off
[construction/ITINERARY.md](../../construction/ITINERARY.md) fascia bumped to 60.057
[README.md](../../README.md) fascia badge updated to 60.057
recommend kg -- Orbit 13 is next: Glow-driven interactive calculator, Calfive round 13
