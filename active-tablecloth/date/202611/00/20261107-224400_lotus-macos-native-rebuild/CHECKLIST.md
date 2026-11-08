# Lotus macOS Native Rebuild -- Terrarium-Informed Architecture

**Stamp:** `20261107.224400`
**Grows from:** 240 Lotus Rye DSP modules, Terrarium extraction architecture, `lotus/lotus_window.rye` visual surface proof
**Expanding prompt:** [`../../../../expanding-prompts/date/20261107/20261107-224400_lotus-macos-native-rebuild.md`](../../../../expanding-prompts/date/20261107/20261107-224400_lotus-macos-native-rebuild.md)
**Prepended to Calfive stack on Keaton's word `20261107`.**

---

## Phase 1 -- The Scaffold (Movements 1-5)

Build the app shell and prove audio plays through Swift/AppKit + Rye FFI.

- [x] **Movement 1 -- Survey and architecture** (landed `20261107`)
  Surveyed lotus/ (242 Rye files, zero Swift), read key modules (coreaudio.rye 313, record.rye 499, lotus_window.rye 579, objc_seam.rye 194, transport.rye 205, timeline.rye 285, clock.rye 257 -- 2,332 lines across 7 files). Mapped Terrarium extraction pattern (10 Swift modules from 3,530-line monolith) as the architecture template.
  **SLC gate:** expanding prompt names every module, its Terrarium parallel, and what it bridges -- **PROVEN**.

- [ ] **Movement 2 -- main.swift scaffold**
  AppDelegate, NSWindow, NSApplication lifecycle. Build GREEN with `swiftc`.
  **SLC gate:** window opens, app responds to quit.

- [ ] **Movement 3 -- AudioEngine.swift**
  FFI bridge to `lotus/coreaudio.rye` via C-ABI. Playback of a hardcoded buffer through CoreAudio.
  **SLC gate:** audio plays through the Swift app.

- [ ] **Movement 4 -- WaveformView.swift**
  Pixel-buffer waveform rendering in an NSView. Draw a sine wave to prove the surface.
  **SLC gate:** waveform draws in the window.

- [ ] **Movement 5 -- TransportControls.swift**
  Play/stop/record buttons wired to AudioEngine. Transport state machine.
  **SLC gate:** buttons control playback.

## Phase 2 -- Recording and Display (Movements 6-10)

Wire recording, show the waveform, export WAV.

- [ ] **Movement 6 -- RecordingBridge in AudioEngine**
  FFI bridge to `lotus/record.rye` AUHAL input. Record and hear monitor.
  **SLC gate:** record audio through the Swift app.

- [ ] **Movement 7 -- Live waveform**
  WaveformView displays the recording buffer in real time as AUHAL delivers frames.
  **SLC gate:** waveform scrolls during recording.

- [ ] **Movement 8 -- AudioUtilities.swift**
  Sample format helpers, buffer management, WAV export bridge.
  **SLC gate:** export a recorded take as WAV.

- [ ] **Movement 9 -- MenuActions.swift**
  File menu (new session, open, save, export WAV), Edit menu, Window menu.
  **SLC gate:** menu items work end to end.

- [ ] **Movement 10 -- StatusAndHelpers.swift**
  Status bar (sample rate, recording time, peak meter), utility helpers.
  **SLC gate:** status bar shows live recording stats.

## Phase 3 -- Multi-track and Polish (Movements 11-15)

The mixer, the timeline, integration.

- [ ] **Movement 11 -- TrackListDelegate.swift**
  NSTableView for the track list. Add, remove, reorder tracks.
  **SLC gate:** multiple tracks visible and selectable.

- [ ] **Movement 12 -- MixerPanel.swift**
  Channel strip per track: gain fader, pan knob, solo/mute. Stereo mix bus.
  **SLC gate:** adjust a fader and hear the mix change in real time.

- [ ] **Movement 13 -- SessionManager.swift**
  Session save/load, multi-track WAV export of the stereo mix.
  **SLC gate:** save a session, reopen it, export stereo mix.

- [ ] **Movement 14 -- TimelineView.swift**
  Horizontal timeline with clips, playback cursor, region selection.
  **SLC gate:** timeline shows clips, cursor follows playback.

- [ ] **Movement 15 -- Integration and witness**
  Full session workflow end to end. Standing equipment GREEN with Lotus witnesses.
  **SLC gate:** record, mix, export a finished stereo WAV through the Swift app.

---

## Summary

| Phase | Movements | Status |
|---|---|---|
| 1 Scaffold | 1-5 | **Active** -- survey landed |
| 2 Recording and Display | 6-10 | Waiting on Phase 1 |
| 3 Multi-track and Polish | 11-15 | Waiting on Phase 2 |
