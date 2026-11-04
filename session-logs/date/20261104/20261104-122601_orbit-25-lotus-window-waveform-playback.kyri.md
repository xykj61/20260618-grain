format session-log-v1
stamp 20261104.122601
session-header [20261104-045214_ssh-decouple-and-nib-amend.kyri.md](20261104-045214_ssh-decouple-and-nib-amend.kyri.md)
voice Kyri
title Orbit 25 -- Lotus window with waveform display and playback
prompt kg -- build the first Quest 1.2 orbit combining app shell, cell grid rasterization, and the recording engine into one window module
think wrote lotus/lotus_window.rye combining three proven patterns: NSApplication lifecycle from app_shell_probe, pixel buffer to CGBitmapContext to CGImage to layer from cell_grid_probe, and AUHAL input capture from record.rye
think first build failed at verify() -- the want parameter takes ObjC type encodings (@@:, v@:@, B@:q, etc) not selector names; corrected all 22 verify calls from the probes' own proven encodings
think display selectors need their proper classes: NSView for setWantsLayer: and layer, CALayer for setContents: -- not null or window class
think waveform renderer maps RecordBuf samples to 640 pixel columns, finds peak absolute value per column, draws mirrored bar from center line up and down -- bounded by sample_peak_max and view_h
think recording runs for 20 event-pump turns with live waveform updates on each turn, then stops and renders the final state
think playback copies RecordBuf to a Clip via to_clip() (4096 samples max), opens the coreaudio playback engine, and runs 200 event-pump turns while the audio plays
think handles microphone permission gracefully -- if record.open fails, displays empty waveform and prints SKIP with instructions
obs GREEN on metal: 19,456 samples recorded (38 callbacks), waveform rendered, 4096-sample clip played back (220 callbacks) -- all three SLC claims proven
obs symlink lotus/objc_seam.rye -> ../tools/rye/objc_seam.rye created in prior session, following established lotus/tally_copy.rye pattern
obs no new @memcpy, no std.debug.assert, opening triad present, snake_case throughout, explicit u32 widths, named errors with WindowError
loom lotus_window=selftest samples=19456 callbacks_record=38 callbacks_play=220 clip_len=4096 verdict=GREEN
orbit round 10 Capricorn -- let the verb color the keystone: what must stop; the first Quest 1.2 orbit stops at the visual proof
[lotus/lotus_window.rye](../../lotus/lotus_window.rye) new module -- NSApplication + menu bar + NSWindow + pixel-buffer waveform + AUHAL recording + CoreAudio playback in one standalone selftest
[lotus/objc_seam.rye](../../lotus/objc_seam.rye) symlink to tools/rye/objc_seam.rye enabling bare @import from lotus/
[construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.054 -> 60.055, Orbit 25 added to landed list
[README.md](../../README.md) fascia badge 60.054 -> 60.055
recommend kg -- Orbit 26: the window stays open with a redraw timer, or the Skate grid integration replaces raw pixel columns with cell-based waveform display
