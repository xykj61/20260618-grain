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

- [x] **Movement 3 -- Vantage audio FFI bridge**
  `lotus/lotus_vantage_audio.rye` with 9 C-ABI exports for CoreAudio playback. Header at `vantage/include/vantage_lotus_audio.h`, VantageLotus module map entry. `liblotus_audio.dylib` built and linked. Selftest 6 claims GREEN, play/stop buttons wired in Audio tab, full Terrarium build GREEN. Bridge lives in `lotus/` (Zig package root restriction blocks cross-directory imports).
  **SLC gate:** audio plays through the Station via FFI bridge -- **PROVEN**.

- [x] **Movement 4 -- Waveform panel**
  `terrarium/app/WaveformView.swift` -- NSView subclass following FrameGridView pixel-buffer pattern. `override func draw` gets CGContext, renders 512-sample sine wave (3 cycles) with amber stroke, translucent fill, and grid lines (center line + quarter lines). Wired into `focusAudio()` in TabSetup.swift with Auto Layout below play/stop buttons, full-width with 24px margins, 120pt height. Dark amber theme matching the Lotus Audio tab. Build GREEN, waveform visible on screen.
  **SLC gate:** waveform draws in the Audio tab -- **PROVEN**.

- [x] **Movement 5 -- Transport controls** (landed `20261108`)
  Loop toggle, D2 144.16 Hz tone (A=432 tuning), seek-to-start on play, looping render callback that resets transport position at clip end. WaveformView draws matching square wave (period 306). Three new FFI exports (`set_loop`, `is_looping`, `seek_start`), selftest 8 claims GREEN. Terrarium build GREEN, app launched, D2 tone loops continuously.
  **SLC gate:** buttons control playback -- **PROVEN**.

## Phase 2 -- Recording and Display (Movements 6-10)

Wire recording, show the waveform, export WAV.

- [x] **Movement 6 -- Recording bridge** (landed `20261108`)
  9 recording FFI exports in `lotus/lotus_vantage_audio.rye` bridging `lotus/record.rye` AUHAL input: `lotus_record_open/start/stop/close`, state queries (`is_open`, `is_recording`), `meter_peak`, `sample_count`, `to_playback` (transfer recording to master clip). C header updated with 9 declarations. Swift UI wired with Record/Stop Rec buttons in Audio tab. Selftest 13 claims GREEN with no-mic resilience (graceful zero-sample handling in background/CI environments).
  **SLC gate:** record audio through the Station -- **PROVEN**.

- [x] **Movement 7 -- Live waveform** (landed `20261108`)
  Added `lotus_record_read_buf` FFI export to bridge (copies i16 samples from RecordBuf to caller buffer, bounded by min of available and max_out). C header updated. Swift timer-based polling at 20Hz: `startRecordWaveformTimer()` creates a repeating Timer that calls `pollRecordingBuffer()`, which reads i16 via FFI, converts to Float via `/32768.0`, feeds `WaveformView.update(buffer:)`. Status label shows sample count and peak meter during recording. Selftest 14 claims GREEN. Terrarium build GREEN.
  **SLC gate:** waveform scrolls during recording -- **PROVEN**.

- [x] **Movement 8 -- Audio utilities** (landed `20261108`)
  Added `lotus_record_export_wav` FFI export bridging `lotus/wav.rye` encoder -- calls `wav.encode` on the recording buffer with the shared clock's sample rate, returns byte length through C-ABI boundary. C header updated. Swift "Export WAV" button in Audio tab with NSSavePanel-based file save dialog, proper error handling and status feedback. Selftest 15 claims GREEN (RIFF header verification when samples > 0, returns 0 on empty buffer).
  **SLC gate:** export a recorded take as WAV -- **PROVEN**.

- [x] **Movement 9 -- Audio menu items** (landed `20261108`)
  Added Audio submenu to the menu bar with six items: Play Test Tone (Cmd+Shift+P), Stop Playback (Cmd+Shift+.), Start Recording (Cmd+Shift+R), Stop Recording (Cmd+Shift+Opt+R), Export WAV (Cmd+Shift+E). Added Focus items for Dimeroll (Cmd+3), Mantra (Cmd+4), Bloom (Cmd+5), and Audio (Cmd+6) to the View menu. Audio tab protected from Cmd+W close. Each menu action delegates to the existing button handlers. Terrarium build GREEN.
  **SLC gate:** menu items work end to end -- **PROVEN**.

- [x] **Movement 10 -- Audio status panel** (landed `20261108`)
  Added a rounded dark status panel below the Export WAV button with three monospace labels: sample rate (Hz), recording time (M:SS.ss), and peak meter (raw + dB). Panel updates live at 20Hz during recording via `updateAudioStatusPanel()`. Shows sample rate on playback start, final stats on recording stop. Tags 910-912 for panel label lookup. Terrarium build GREEN.
  **SLC gate:** status bar shows live recording stats -- **PROVEN**.

## Phase 3 -- Multi-track and Polish (Movements 11-15)

The mixer, the timeline, integration.

- [x] **Movement 11 -- Track list** (landed `20261108`)
  NSTableView inside the Audio tab below the status panel with two columns (Name width 200, Gain width 60), NSScrollView wrapper (height 120, dark amber theme), "+ Track" and "- Track" buttons. Data model: `audioTracks: [(name: String, gain: Float)]` initialized with one default track. TableViewDelegate dispatches via `=== audioTrackTable` identity check. Minimum-one-track enforcement on remove, selection management on add/remove. Terrarium build GREEN.
  **SLC gate:** multiple tracks visible and selectable -- **PROVEN**.

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
| 1 Audio Tab in Station | 1-5 | **COMPLETE** -- all 5 movements PROVEN |
| 2 Recording and Display | 6-10 | **COMPLETE** -- all 5 movements PROVEN |
| 3 Multi-track and Polish | 11-15 | Waiting on Phase 2 |
