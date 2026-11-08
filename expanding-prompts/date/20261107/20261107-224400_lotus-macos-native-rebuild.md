# Lotus macOS Native Rebuild -- Terrarium-informed architecture

**Stamp:** `20261107.224400` - **Status:** Proposed - **Room:** checkable
**Voice:** Kyri - **Style:** Gauge at Field
**Grows from:** 240 Lotus Rye DSP modules, Terrarium extraction architecture (10 Swift modules from one 3,530-line monolith), `lotus/lotus_window.rye` visual surface proof, `lotus/coreaudio.rye` CoreAudio engine, `tools/rye/objc_seam.rye` Objective-C boundary
**Prepended to Calfive stack on Keaton's word `20261107`.**

---

## What this is

A native macOS application for Lotus -- Grain's creative suite -- built in Swift and AppKit from the start in the modular architecture Terrarium arrived at after eight extraction passes. Where Terrarium extracted ten modules from a 3,530-line monolith over ten movements, Lotus begins with those ten modules as the template and builds modular from day one.

## What already stands

| Asset | Lines | What it proves |
|---|---|---|
| `lotus/coreaudio.rye` | 313 | CoreAudio engine: open/start/callback/stop/close, i16 -> Float32, real-time thread safe |
| `lotus/record.rye` | 499 | AUHAL input capture, Float32-to-i16, RecordBuf, live metering, monitor playback |
| `lotus/lotus_window.rye` | 579 | NSApplication + NSWindow + pixel-buffer waveform + recording + playback via objc_seam |
| `lotus/transport.rye` | 205 | Play head: read the master forward, bounded block reads |
| `lotus/timeline.rye` | 285 | Clip model -- the unit the timeline arranges |
| `lotus/clock.rye` | 257 | Sample rate, timing, frame arithmetic |
| `tools/rye/objc_seam.rye` | 194 | Verified Objective-C message boundary for AppKit |
| 240 DSP modules | ~30,000 | The full audio processing ladder -- wire through catalog_verify |

## What the rebuild gives us

`lotus_window.rye` proves the audio chain works through a macOS window. The rebuild replaces that single 579-line Rye module with a proper Swift application that:

1. **Starts modular** -- each concern in its own Swift file from movement one, rather than extracting later
2. **Uses FFI to Rye** -- the same C-ABI bridge Terrarium uses for DimerollEngine and Bloom, calling into the proven Rye DSP modules
3. **Follows TAME guidance** -- bounded allocations, named errors, safety first
4. **Opens the door to Quest 1.2** -- multi-track mixer, timeline editing, FX chains all land in their own modules

## The Terrarium pattern, applied to Lotus

| Terrarium module | Lines | Lotus parallel | Purpose |
|---|---|---|---|
| `main.swift` | 504 | `main.swift` | AppDelegate, window, app lifecycle |
| `FrameGridView.swift` | 401 | `WaveformView.swift` | Visual rendering surface -- waveform display |
| `DimerollEngine.swift` | 730 | `AudioEngine.swift` | FFI bridge to Rye DSP -- CoreAudio + recording |
| `TabSetup.swift` | 675 | `MixerPanel.swift` | Channel strips, faders, pan, solo/mute |
| `QemuLauncher.swift` | 268 | `SessionManager.swift` | Session lifecycle -- open, save, close |
| `WireProtocol.swift` | 269 | `TransportControls.swift` | Play/stop/record, timeline position |
| `QemuUtilities.swift` | 176 | `AudioUtilities.swift` | Sample format conversion, buffer helpers |
| `TableViewDelegate.swift` | 264 | `TrackListDelegate.swift` | Track list table view delegate |
| `MenuActions.swift` | 195 | `MenuActions.swift` | Application menu items |
| `StatusAndHelpers.swift` | 118 | `StatusAndHelpers.swift` | Status bar, utility helpers |

## 15 movements

**Phase 1 -- The scaffold (movements 1-5).** Build the app shell and prove audio plays.

1. **Survey and architecture** -- this document. Name every module, its Terrarium parallel, and what it bridges.
2. **main.swift scaffold** -- AppDelegate, NSWindow, NSApplication lifecycle. Build GREEN with `swiftc`.
3. **AudioEngine.swift** -- FFI bridge to `lotus/coreaudio.rye` via C-ABI. Playback of a hardcoded buffer through CoreAudio.
4. **WaveformView.swift** -- Pixel-buffer waveform rendering in an NSView. Draw a sine wave to prove the surface.
5. **TransportControls.swift** -- Play/stop/record buttons wired to AudioEngine. Transport state machine.

**Phase 2 -- Recording and display (movements 6-10).** Wire recording, show the waveform, export.

6. **RecordingBridge** in AudioEngine -- FFI bridge to `lotus/record.rye` AUHAL input. Record and hear monitor.
7. **Live waveform** -- WaveformView displays the recording buffer in real time as AUHAL delivers frames.
8. **AudioUtilities.swift** -- Sample format helpers, buffer management, WAV export bridge.
9. **MenuActions.swift** -- File menu (new session, open, save, export WAV), Edit menu, Window menu.
10. **StatusAndHelpers.swift** -- Status bar (sample rate, recording time, peak meter), utility helpers.

**Phase 3 -- Multi-track and polish (movements 11-15).** The mixer, the timeline, integration.

11. **TrackListDelegate.swift** -- NSTableView for the track list. Add, remove, reorder tracks.
12. **MixerPanel.swift** -- Channel strip per track: gain fader, pan knob, solo/mute. Stereo mix bus.
13. **SessionManager.swift** -- Session save/load, multi-track WAV export of the stereo mix.
14. **TimelineView.swift** -- Horizontal timeline with clips, playback cursor, region selection.
15. **Integration and witness** -- Full session workflow end to end. Standing equipment GREEN with Lotus witnesses.

## Build command

Following Terrarium's pattern -- all Swift files compiled together:

```
swiftc -o lotus/app/LotusApp lotus/app/*.swift \
  -framework Cocoa -framework CoreGraphics \
  -framework AudioToolbox -framework CoreAudio \
  -import-objc-header lotus/app/bridge.h
```

The `bridge.h` header exposes the C-ABI symbols from the Rye modules that `AudioEngine.swift` calls through FFI.

## What this does not reach

- **The FX chain architecture** (Quest 2.1 orbits 8-10) -- that grows from the multi-track mixer this journey builds.
- **Skate/Brushstroke integration** -- the Swift app uses AppKit directly; Skate integration is a later concern.
- **The 240 DSP modules** -- they stay in Rye. The Swift app bridges to them through FFI rather than reimplementing them.
