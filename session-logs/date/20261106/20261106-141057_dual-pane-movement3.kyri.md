format session-log-v1
stamp 20261106.141057
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Dual-pane window -- Movement 3 of Realidream Composition Journey PROVEN
prompt kg -- Movement 3, dual-pane window with QEMU terminal beside FrameGrid
think vertical stacking (Movement 2) replaced with NSSplitView for side-by-side layout -- isVertical = true gives left/right panes, dividerStyle .thin for a clean resize handle
think right pane wraps FrameGridView in a black container NSView with 8pt padding, so the grid floats on black rather than hugging the divider -- autoresizingMask .minYMargin pins grid to top-left
think window widened from 720 to 1040 to give both panes room -- 60/40 initial split via setPosition, minSize raised to 600x300
think framebuffer stage branch preserved: NSImageView sits above the split view, split view fills the remaining height below it
think fallback for pre-macOS 26 (no InlineArray): right pane is a plain black NSView placeholder, split view still works
obs NSSplitView with two subviews works cleanly -- addSubview order determines left/right, setPosition after adding to window sets the initial divider position
obs zero warnings after changing var mask to let mask (resizable is now always on)
obs app launches with amphora_seal_g.elf, QEMU serial output fills left pane, test pattern (green bands, purple block) renders in right pane, divider resizable
[terrarium/app/main.swift](../../terrarium/app/main.swift) replaced vertical stacking with NSSplitView dual-pane layout -- terminal left, FrameGridView right, resizable thin divider
[active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md](../../active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md) Movement 3 checked off
[active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md](../../active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md) Movement 3 progress entry
recommend keep-going -- next: Movement 4, serial-to-grid bridge -- parse QEMU output into FrameGrid cells
