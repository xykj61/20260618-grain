# Lotus macOS Native Rebuild -- composed inside Terrarium Station

**Stamp:** `20261107.224400` - **Status:** Proposed, revised `20261107` - **Room:** checkable
**Voice:** Kyri - **Style:** Gauge at Field
**Grows from:** 240 Lotus Rye DSP modules, Terrarium Station (10 Swift modules, Vantage FFI pattern), `lotus/coreaudio.rye` CoreAudio engine, `lotus/record.rye` AUHAL capture
**Prepended to Calfive stack on Keaton's word `20261107`.**

---

## What this is

Lotus Audio composed inside Terrarium's Station as a Vantage module -- one AppDelegate, one build command, one tab system. Rather than building a standalone `lotus/app/`, Audio joins Terminal, Grid, Dimeroll, Mantra, and Bloom in the existing sidebar. The 240 Rye DSP modules stay as the audio backbone; a Vantage FFI bridge (`vantage/lotus_audio.rye` -> `vantage/include/vantage_lotus.h`) exposes them to Swift, following the same pattern Bloom and Dimeroll already use.

## What already stands

| Asset | Lines | What it proves |
|---|---|---|
| `lotus/coreaudio.rye` | 313 | CoreAudio engine: open/start/callback/stop/close, i16 -> Float32, real-time thread safe |
| `lotus/record.rye` | 499 | AUHAL input capture, Float32-to-i16, RecordBuf, live metering, monitor playback |
| `lotus/transport.rye` | 205 | Play head: read the master forward, bounded block reads |
| `lotus/timeline.rye` | 285 | Clip model -- the unit the timeline arranges |
| `lotus/clock.rye` | 257 | Sample rate, timing, frame arithmetic |
| 240 DSP modules | ~30,000 | The full audio processing ladder -- wire through catalog_verify |
| `terrarium/app/` | 3,600 | The Station -- 10 Swift modules with sidebar, tabs, Vantage FFI |
| `vantage/bloom.rye` | -- | Bloom Vantage bridge -- the pattern to follow |
| `vantage/dimeroll.rye` | -- | Dimeroll Vantage bridge -- the pattern to follow |

## Why composition inside Station

Single-stranded sameness: one native write-once implementation carries the compass rota and panchanga planning as one app. The Station already handles the window, sidebar, tab lifecycle, menu system, and build pipeline. Lotus adds a tab, not an app.

The tradeoff is named: CoreAudio's real-time audio thread shares a process with QEMU's CPU loop. They run on separate threads by construction, and CoreAudio's callback is a hardware interrupt that macOS delivers regardless of other thread activity.

## The Vantage FFI pattern

Each Vantage module follows three steps, already proven by Bloom and Dimeroll:

1. **Rye module** (`vantage/lotus_audio.rye`) -- exports C-ABI functions
2. **C header** (`vantage/include/vantage_lotus.h`) -- declares those symbols
3. **Module map entry** in `vantage/include/module.modulemap` -- Swift imports as `import VantageLotus`

Swift files in `terrarium/app/` call the FFI bridge. The build command already compiles `terrarium/app/*.swift` with `-I vantage/include -L vantage/lib`.

## 15 movements

**Phase 1 -- Audio tab in Station (movements 1-5).** Add Lotus Audio to the existing app and prove audio plays.

1. **Survey and architecture** -- this document. Map the composition approach: Lotus as a Vantage module inside Station.
2. **Audio tab scaffold** -- add `"Audio"` to sidebar, `focusAudio()` in TabSetup.swift, build GREEN with existing `swiftc` command.
3. **Vantage audio FFI bridge** -- `vantage/lotus_audio.rye` with C-ABI exports for CoreAudio playback. Header and module map. Build `liblotus_audio.dylib`.
4. **Waveform panel** -- pixel-buffer waveform rendering in the Audio tab. Draw a sine wave to prove the surface.
5. **Transport controls** -- play/stop/record buttons wired to the audio FFI bridge. Transport state machine in the tab.

**Phase 2 -- Recording and display (movements 6-10).** Wire recording, show the waveform, export.

6. **Recording bridge** in the Vantage module -- FFI bridge to `lotus/record.rye` AUHAL input. Record and hear monitor.
7. **Live waveform** -- waveform panel displays the recording buffer in real time as AUHAL delivers frames.
8. **Audio utilities** -- sample format helpers, buffer management, WAV export through the FFI bridge.
9. **Audio menu items** -- audio-specific menu actions wired into the existing MenuActions.swift.
10. **Audio status panel** -- sample rate, recording time, peak meter in the Audio tab's status area.

**Phase 3 -- Multi-track and polish (movements 11-15).** The mixer, the timeline, integration.

11. **Track list** -- NSTableView inside the Audio tab for multiple tracks. Add, remove, reorder.
12. **Mixer panel** -- channel strip per track: gain fader, pan knob, solo/mute. Stereo mix bus.
13. **Session persistence** -- session save/load for multi-track state, stereo mix export.
14. **Timeline view** -- horizontal timeline with clips, playback cursor, region selection.
15. **Integration and witness** -- full session workflow end to end. Standing equipment GREEN with Lotus audio witnesses.

## Build command

The existing Station build, extended with the Lotus Vantage library when the FFI bridge lands:

```
rye/bin/rye build-lib vantage/lotus_audio.rye -dynamic \
  -femit-bin=vantage/lib/liblotus_audio.dylib
swiftc -I terrarium/.build -I vantage/include \
  -L terrarium/.build -L vantage/lib \
  -lSkateCore -lbloom -ldimeroll -llotus_audio \
  -o terrarium/.build/Terrarium terrarium/app/*.swift \
  -framework AppKit
```

Until the FFI bridge lands (movement 3), the existing build command works unchanged -- the Audio tab is a pure Swift placeholder.

## What this does not reach

- **The FX chain architecture** -- that grows from the multi-track mixer this journey builds.
- **Standalone Lotus app** -- retired in favor of composition inside Station. The 240 DSP modules stay in Rye and are bridged through Vantage FFI.
- **WASM audio** -- Web Audio API integration for grain-emu.wasm is a separate concern from macOS CoreAudio.
