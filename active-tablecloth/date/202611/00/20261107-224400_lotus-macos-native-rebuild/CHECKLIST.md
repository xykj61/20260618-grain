# Lotus macOS Native Rebuild -- Composed Inside Terrarium Station

**Stamp:** `20261107.224400`
**Grows from:** 240 Lotus Rye DSP modules, Terrarium Station (10 Swift modules, Vantage FFI pattern)
**Expanding prompt:** [`../../../../expanding-prompts/date/20261107/20261107-224400_lotus-macos-native-rebuild.md`](../../../../expanding-prompts/date/20261107/20261107-224400_lotus-macos-native-rebuild.md)
**Prepended to Calfive stack on Keaton's word `20261107`. Revised to composition approach `20261107`.**

---

## Phase 1 -- Audio Tab in Station (Movements 1-5)

Add Lotus Audio to the existing Terrarium Station and prove audio plays.

- [x] **Movement 1 -- Survey and architecture** (landed `20261107`)
  Surveyed lotus/ (242 Rye files, zero Swift), read key modules (coreaudio.rye 313, record.rye 499, transport.rye 205, timeline.rye 285, clock.rye 257 -- 2,332 lines across 7 files). Mapped Terrarium extraction pattern. Revised to composition inside Station on Keaton's word.
  **SLC gate:** expanding prompt names every module and its FFI bridge -- **PROVEN**.

- [x] **Movement 2 -- Audio tab scaffold** (landed `20261107`)
  Added `"Audio"` to `sidebarModules` in main.swift, `focusAudio()` in TabSetup.swift (warm amber theme), `case "Audio"` dispatch in TableViewDelegate.swift. Build GREEN with existing `swiftc` command.
  **SLC gate:** Audio tab appears in sidebar, selects to a placeholder panel, build GREEN -- **PROVEN**.

- [ ] **Movement 3 -- Vantage audio FFI bridge**
  `vantage/lotus_audio.rye` with C-ABI exports for CoreAudio playback. Header and module map. Build `liblotus_audio.dylib`.
  **SLC gate:** audio plays through the Station via FFI bridge.

- [ ] **Movement 4 -- Waveform panel**
  Pixel-buffer waveform rendering in the Audio tab. Draw a sine wave to prove the surface.
  **SLC gate:** waveform draws in the Audio tab.

- [ ] **Movement 5 -- Transport controls**
  Play/stop/record buttons wired to the audio FFI bridge. Transport state machine in the tab.
  **SLC gate:** buttons control playback.

## Phase 2 -- Recording and Display (Movements 6-10)

Wire recording, show the waveform, export WAV.

- [ ] **Movement 6 -- Recording bridge**
  FFI bridge to `lotus/record.rye` AUHAL input. Record and hear monitor.
  **SLC gate:** record audio through the Station.

- [ ] **Movement 7 -- Live waveform**
  Waveform panel displays the recording buffer in real time as AUHAL delivers frames.
  **SLC gate:** waveform scrolls during recording.

- [ ] **Movement 8 -- Audio utilities**
  Sample format helpers, buffer management, WAV export through the FFI bridge.
  **SLC gate:** export a recorded take as WAV.

- [ ] **Movement 9 -- Audio menu items**
  Audio-specific menu actions wired into the existing MenuActions.swift.
  **SLC gate:** menu items work end to end.

- [ ] **Movement 10 -- Audio status panel**
  Sample rate, recording time, peak meter in the Audio tab's status area.
  **SLC gate:** status bar shows live recording stats.

## Phase 3 -- Multi-track and Polish (Movements 11-15)

The mixer, the timeline, integration.

- [ ] **Movement 11 -- Track list**
  NSTableView inside the Audio tab for multiple tracks. Add, remove, reorder.
  **SLC gate:** multiple tracks visible and selectable.

- [ ] **Movement 12 -- Mixer panel**
  Channel strip per track: gain fader, pan knob, solo/mute. Stereo mix bus.
  **SLC gate:** adjust a fader and hear the mix change in real time.

- [ ] **Movement 13 -- Session persistence**
  Session save/load for multi-track state, stereo mix export.
  **SLC gate:** save a session, reopen it, export stereo mix.

- [ ] **Movement 14 -- Timeline view**
  Horizontal timeline with clips, playback cursor, region selection.
  **SLC gate:** timeline shows clips, cursor follows playback.

- [ ] **Movement 15 -- Integration and witness**
  Full session workflow end to end. Standing equipment GREEN with Lotus audio witnesses.
  **SLC gate:** record, mix, export a finished stereo WAV through the Station.

---

## Summary

| Phase | Movements | Status |
|---|---|---|
| 1 Audio Tab in Station | 1-5 | **Active** -- survey landed |
| 2 Recording and Display | 6-10 | Waiting on Phase 1 |
| 3 Multi-track and Polish | 11-15 | Waiting on Phase 2 |
