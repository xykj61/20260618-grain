format session-log-v1
stamp 20261104.120638
session-header [20261104-045214_ssh-decouple-and-nib-amend.kyri.md](20261104-045214_ssh-decouple-and-nib-amend.kyri.md)
voice Kyri
title Quest 1.2 scoping -- Brushstroke window orbit from five proven probes
prompt check in -- scope the first orbit of Quest 1.2 (the visual window)
think surveyed five macOS native probes: macos_window_probe, macos_cell_grid_probe, macos_view_class_probe, macos_resize_scale_probe, macos_app_shell_probe -- all use objc_seam.rye, all proven on metal, no Swift linked
think macos_cell_grid_probe is the closest ancestor -- it imports skate_grid.rye, builds a real Grid, rasterizes cells to a pixel buffer, hands a CGImage to NSWindow's content view layer via CoreGraphics
think macos_app_shell_probe adds what the cell grid lacks: a real NSApplication with activation policy, a menu bar with Quit wired to terminate:, and finishLaunching
think the first Quest 1.2 orbit combines both patterns with lotus/record.rye -- the recording engine's RecordBuf holds i16 samples, and the waveform renderer reads that buffer to fill Skate grid cells
think build command adds -lobjc -framework Cocoa -framework CoreGraphics to the existing -framework AudioToolbox -framework CoreAudio
think no Swift is crossed -- the entire AppKit surface runs through objc_seam.rye's verified selectors, exactly as the five probes already demonstrate
obs five probes already prove every piece separately: app lifecycle (shell probe), Skate grid rasterization to NSWindow (cell grid probe), custom NSView subclass (view class probe), resize and retina scale (resize probe), and the objc seam that binds them all
obs layout bridge (Orbit 11) validates LayoutCell against Skate's 40x8 grid bounds, and SkateCore's FrameGrid.swift already has LotusMeterReading with sample and peak bounds
obs proposal: one new file lotus/lotus_window.rye combining the app shell and cell grid patterns with the recording engine -- waveform rendered as Skate grid cells, transport state displayed, bounded event loop redraws on each turn
obs SLC gate for the orbit: open Lotus in a window, see a waveform of the recording, play it back -- the three claims of Quest 1.2's gate
[tools/rye/objc_seam.rye](../../tools/rye/objc_seam.rye) the one verified Objective-C boundary -- all five probes and the new window module share it
[tools/rye/macos_app_shell_probe.rye](../../tools/rye/macos_app_shell_probe.rye) app lifecycle pattern: NSApplication, menu bar, finishLaunching, bounded event pump
[tools/rye/macos_cell_grid_probe.rye](../../tools/rye/macos_cell_grid_probe.rye) Skate grid rasterization to NSWindow via CGBitmapContext -- the direct ancestor of the waveform display
[tools/rye/layout_bridge.rye](../../tools/rye/layout_bridge.rye) LayoutCell validation against Skate grid bounds (Orbit 11)
[skate/Sources/SkateCore/FrameGrid.swift](../../skate/Sources/SkateCore/FrameGrid.swift) LotusMeterReading and SkateCoreBounds already in place
[lotus/record.rye](../../lotus/record.rye) RecordBuf with i16 samples, AUHAL input capture, WAV export -- the engine the window module imports
orbit round 9 Sagittarius -- let the verb color the keystone: aim for the target that opens the rest
recommend check in (Claude) -- module seam (recording engine + AppKit surface); Keaton's word before building
