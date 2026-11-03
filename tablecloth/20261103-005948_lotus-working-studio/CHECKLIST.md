# Lotus Working Studio -- Master Checklist

**Equinox 1: The Working Studio (Rungs 1-3)**
**Stamp:** `20261103.005948`
**Grows from:** 240 Lotus modules, 241 witnesses, lotus-audio wire shape, macos-native macOS native surface, Skate Swift shell

---

## Journey 1 -- The Seed and the First Track (Rungs 1-2)

### Quest 1.1 -- Lotus Seed (Rung 1)

*The smallest studio that can record and play without skipping.*
**Grows from:** the wire shape (`lotus/wire.rye`), the stream module, and the 22 span-edit modules already proven by 241 witnesses.

- [x] **Orbit 1 -- CoreAudio callback and transport** (landed `20261103.155000`)
  `lotus/coreaudio_c.rye` (lotus-audio): bounded extern declarations for AudioToolbox (Zig 0.17 removed @cImport).
  `lotus/coreaudio.rye` (lotus-audio): Engine wires transport to CoreAudio default output -- open/start/callback/stop/close.
  Callback pulls i16 from `transport.read_block()`, converts to Float32, plays through macOS audio. Witness GREEN on metal.
  **SLC gate:** audio plays through CoreAudio without skipping under documented load -- **PROVEN** (callback fires, transport advances to end, all status 0).

- [ ] **Orbit 2 -- Record, meter, and monitor**
  CoreAudio input capture to a Weave append. `lotus/meter.rye` reads the stream.
  Monitor path so the performer hears themselves. Peak normalization (`lotus/normalize.rye`).
  **SLC gate:** record a take, see the meter move, hear playback of what was just recorded.

- [ ] **Orbit 3 -- WAV export and the Brushstroke surface**
  `lotus/wav.rye` renders the session to a file. Minimal Brushstroke/Skate window: waveform
  display, transport bar, meter readout. The whole loop closes.
  **SLC gate:** open Lotus, record a voice, see the waveform, export a WAV. **Quest 1.1 SLC.**

### Quest 1.2 -- Multi-track and the Mixer (Rung 2)

*Grow the seed into a multi-track session with a mix bus.*
**Grows from:** Quest 1.1's single-track seed.

- [ ] **Orbit 4 -- Multiple tracks in Weave**
  Session model holds N tracks, each a named Weave stream. Add, remove, reorder.
  Brushstroke draws a track list.
  **SLC gate:** two or more tracks play simultaneously through the render graph.

- [ ] **Orbit 5 -- The mixer bus**
  Stereo mix bus sums all tracks. Per-track gain faders (`lotus/fader.rye`), pan (`lotus/pan.rye`),
  solo, mute. Brushstroke draws the mixer strip.
  **SLC gate:** adjust a fader and hear the mix change in real time.

- [ ] **Orbit 6 -- Track editing on the timeline**
  Span-edit modules (`lotus/timeline.rye`, crop, move, paste, graft, selection, clipboard)
  operate on tracks through Weave events. Cut, copy, paste, undo.
  **SLC gate:** edit a region on track 2 while track 1 plays -- non-destructive, undoable.

- [ ] **Orbit 7 -- Multi-track export and polish**
  WAV export of the stereo mix. Session save/load through Weave serialization.
  Track headers, timeline ruler, playback cursor.
  **SLC gate:** record three tracks, mix them, export a finished stereo WAV. **Quest 1.2 SLC.**

---

## Journey 2 -- Effects and Faces (Rung 3)

### Quest 2.1 -- The FX Chain (Rung 3, first half)

*Per-track insert chains where each slot holds a Lotus module.*
**Grows from:** Journey 1's multi-track mixer.

- [ ] **Orbit 8 -- Insert chain architecture**
  Each track carries an ordered list of FX slots. A slot loads any Lotus DSP module.
  Render graph wires slots in series. Wet/dry per slot.
  **SLC gate:** insert an EQ on track 1 and hear it color the sound.

- [ ] **Orbit 9 -- Plugin face rendering**
  Brushstroke draws each module's control surface from the module's parameter declarations.
  Tiered pages: simple face by default, expert face on request.
  **SLC gate:** turn a knob on the compressor face and hear the threshold move.

- [ ] **Orbit 10 -- Chain management and preset recall**
  Reorder, bypass, remove slots. Save and recall FX chain presets through Weave.
  Delta solo (hear only what one plugin changed).
  **SLC gate:** build a mastering chain (EQ, compressor, limiter), preview with delta solo,
  save the chain as a preset. **Quest 2.1 SLC.**

### Quest 2.2 -- Refinement orbit

- [ ] **Orbit 11 -- Integration, witnesses, and documentation**
  Full session workflow end to end. Harden witnesses. Guide page in `docs-geode/` (Bhakta at Door).
  Repair any reds the journeys left open.
  **SLC gate:** standing equipment roster runs GREEN with Lotus witnesses. **Equinox 1 closes.**

---

## Summary

| Quest | Orbits | Status |
|---|---|---|
| 1.1 Lotus Seed | 1-3 | **Active -- Orbit 1** |
| 1.2 Multi-track and Mixer | 4-7 | Waiting on Quest 1.1 |
| 2.1 FX Chain | 8-10 | Waiting on Quest 1.2 |
| 2.2 Refinement | 11 | Waiting on Quest 2.1 |
