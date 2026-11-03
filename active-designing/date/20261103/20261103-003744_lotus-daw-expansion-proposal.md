# Lotus DAW -- a proposal for the full studio

**Stamp:** `20261103.003744`
**Voice:** Kyli
**Style:** Teacher Style, Door setting, with Radiant warmth (see [`../../../context/TEACHER_STYLE.md`](../../../context/TEACHER_STYLE.md))
**Status:** Proposed -- vision (see [`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Room:** vision -- reasoning a reader can check today, standing ahead of any guard
**Kin:** [`../../../lotus/README.md`](../../../lotus/README.md) - [`../../yonder/date/20260630/20260630-014012_lotus-the-daw.md`](../../yonder/date/20260630/20260630-014012_lotus-the-daw.md) - [`../../../gratitude/reaper.md`](../../../gratitude/reaper.md) - [`../../../gratitude/ap-mastering.md`](../../../gratitude/ap-mastering.md) - lotus-audio waymark - macos-native waymark
**Coauthor:** Keaton Dunsford
**Thanks:** Kyli, for holding the warm thinking while it was still becoming itself

---

## 1. Introduction

Lotus is Grain's creative suite. It has 240 Rye modules today, each one proven by its own witness, organized into twelve families that cover the wire shape, timeline edits, transport and clock, mixing, tone and filters, dynamics, time and modulation effects, spatial audio, analysis, mastering, sealed records, and a catalog that verifies end to end.

That is a strong foundation. What Lotus does not yet have is the frame around it -- the thing that turns a library of audio tools into a place where a person sits down, opens a session, records a take, arranges it beside other takes, mixes everything together, and ships a finished master. That frame is what the industry calls a digital audio workstation, or DAW.

This proposal describes what it would take to build that frame around the 240 modules Lotus already holds, learning from two applications that do it well -- REAPER and Ableton Live -- and from a mastering engineer named Alain Paul, who has explained clearly what professional work actually requires from a DAW and what most of them still lack.

The target is native macOS first, through the Skate/AppKit shell and real CoreAudio I/O, with Brushstroke drawing the surfaces. Lotus's own 240 modules serve as the stock plugin library. External plugin hosting (VST, CLAP, AU) is a horizon item rather than a first delivery.

## 2. Problem

Lotus today is a set of proven audio operations with no home to live in. A person who wants to use these modules has to drive them from a Rishi script or a witness harness. There is no session file. There is no mixer window. There is no transport bar. There is no way to record audio from a microphone, arrange it on a timeline, and press play.

Beyond that basic absence, Alain Paul identifies five capabilities that most DAWs lack even after decades of development. These are not exotic features. They are the ordinary requirements of professional mastering and post-production work, and their absence is what forces engineers to build workarounds in every session:

1. **Scripted and automated ingestion.** When a client sends stems, a professional needs the DAW to run a script that imports every file, names it by the session's convention, checks its sample rate, and places it on the timeline -- rather than dragging files by hand and hoping the order is right.

2. **Non-destructive stem summing.** A mastering engineer receives stems rather than a single stereo mix, and needs to sum them inside the DAW without committing to that sum. The sum should be a live, adjustable fold over the stems, recallable at any point.

3. **Multi-version revision management.** Professional mastering produces many versions of one song -- the radio edit, the instrumental, the TV mix, the vinyl pre-master. The DAW should hold these as named branches of one session, sharing the source material and diverging only where they must.

4. **Integrated session metadata.** ISRC codes, DDPI delivery data, client names, track timings, revision notes -- all of this lives in spreadsheets or Post-It notes today because DAWs treat metadata as someone else's problem.

5. **Batch render matrix.** An album mastering session produces dozens of output files -- each song in multiple formats, at multiple sample rates, with or without dither, for streaming and for physical media. A render matrix lets the engineer define this grid once and render all of it in one pass rather than running the export dialog sixty times.

These five capabilities are the gap between a DAW a musician uses to write songs and a DAW a professional uses to ship records. Lotus can close that gap from its first version, because it is not carrying twenty years of architecture that predates these needs.

## 3. Solution

Build the DAW frame in five layers, each one standing on the layers below it and on the 240 modules already proven.

### Layer 1 -- The session and the project fold

A Lotus session is a Weave -- a fold over facts. Every action the user takes (place a clip, move a fader, set a marker, change a plugin parameter) is a fact appended to the session's event log. The current state of the session is always a fold over that log. This means:

- **Unlimited undo** falls out of the structure. Removing the last N events and refolding gives you the state N steps ago.
- **Non-destructive editing** is the only kind there is. The source audio files are never modified. Every edit is a fact about a region, a gain value, a fade curve, or a splice point.
- **Multi-version revision management** is a branch of the event log. A radio edit shares the first 200 events with the album version and diverges from event 201 forward. Named branches coexist inside one session file.
- **Session metadata** is facts in the same log -- ISRC codes, client names, revision notes, each one timestamped and signed by Kumara when the session carries identity.

The session file format is Kyri notation -- plain key-value, one fact per line, parseable and sealed. A `.lotus` file is a Kyri document with a SHA-256 seal, verifiable before it is trusted, the same discipline the wire shape already proves at lotus-audio.

### Layer 2 -- The audio engine and real-time path

Maitreya is the media driver framework. It owns the hot loop -- the audio callback that must never skip. The engine runs on Tally-bounded buffers with Caravan-supervised hosts, and the architecture looks like this:

- **CoreAudio host seam** (macOS first, via macos-native's Rye/AppKit backend). The host hands Maitreya a callback buffer at the device sample rate. Maitreya fills it and hands it back. That handoff is the entire contract with the operating system.
- **The render graph.** Maitreya walks a directed acyclic graph of audio nodes -- sources, effects, buses, sends, the master output. Each node pulls its input, processes it, and writes its output into a Tally-bounded buffer. The graph is frozen at the start of each callback and cannot be modified during it. Graph changes from the UI are queued and applied between callbacks.
- **The transport.** Play, stop, record, loop, scrub -- the transport already exists in Lotus's `transport.rye`, `loop.rye`, and `scrub.rye`. The engine version of the transport drives the graph's read position and the record input's write position.
- **Plugin hosting.** Each Lotus module is a native plugin. A `reverb.rye` or `compressor.rye` is instantiated as a node in the render graph, receives a buffer, processes it in place, and returns. The 240 modules become the stock plugin library with zero bridging code. External plugin formats (VST3, CLAP, AU) are a later layer, behind a sandboxed host process supervised by Caravan.

### Layer 3 -- The mixer and the routing

REAPER's routing model is the one to learn from. Every track is a potential bus. Any track can send to any other track. Folder tracks act as submix buses. The signal path is:

- **Track -> pre-FX send -> FX chain -> post-FX send -> parent bus or master.**
- **Per-track controls:** fader (already `fader.rye`), pan (already `power.rye` for equal-power), mute/solo (already `strip.rye`), phase invert, record arm, input monitoring.
- **FX chain per track:** an ordered list of Lotus modules. Each slot exposes bypass, wet/dry mix, and delta solo (the ability to hear only what the plugin changed -- a feature Alain Paul highlights as essential for mastering). The chain is a Weave fact, so reordering or removing a plugin is non-destructive.
- **Stem summing** is a folder track whose dependents are the stems. The folder renders the sum live. The engineer adjusts stem levels and hears the result without committing. This is Alain Paul's second requirement, and it falls out of the routing model rather than being a special mode.

### Layer 4 -- The surfaces

Brushstroke draws all of it. The surfaces already have precedent in `brushstroke/edit_filmstrip_track.rye` and its siblings. Skate provides the native macOS shell through macos-native's Rye/AppKit backend, with `FrameGrid` (40x8), `EventRing` (128 seats), and `LotusMeterReading` already defined in Swift.

The main surfaces:

- **Arrangement view.** A horizontal timeline with tracks stacked vertically, clips placed on them, a playhead, a ruler, markers. This is where most editing happens. REAPER calls it the main view. Ableton calls it the Arrangement View.
- **Mixer view.** Vertical channel strips -- fader, pan, mute, solo, metering, FX chain, sends. Switchable between the arrangement and a dedicated mixer window.
- **Session view (horizon).** Ableton's Session View -- a grid of clips that can be launched in any order, for live performance and improvisation. This is a valuable surface, and the Weave event model supports it naturally (a clip launch is a fact), yet it is a second delivery rather than the first.
- **Plugin faces.** Each Lotus module gets a Brushstroke-drawn control surface. AP Mastering's tiered design is the model: a one-knob retro face for quick use, a guided preset face with randomize, and a full expert face that exposes every parameter with plain labels. Three faces, one engine. Each face redraws from values every frame -- immediate mode, no retained DOM.
- **Meters.** Peak, RMS, LUFS, spectrum, phase correlation, stereo width. `LotusMeterReading` in Skate already holds sample count, peak, and RMS under Lotus bounds. The meter family in `lotus/meter.rye` and its siblings provide the arithmetic. Brushstroke draws them.

### Layer 5 -- Scripting, automation, and the render matrix

This is where Lotus closes the gap Alain Paul describes.

- **Scripting in Rishi and Glow.** Where REAPER offers ReaScript (EEL, Lua, Python), Lotus offers Rishi for shell-level automation and Glow for deeper, compiled scripting. A Rishi script can open a session, import stems by glob pattern, rename them, check sample rates, place them on tracks, and set levels -- Alain Paul's first requirement, scripted ingestion.
- **Automation lanes.** Every parameter that can move -- fader, pan, any plugin knob -- has an automation lane. Automation is a sequence of timed Weave facts. Read, write, touch, and latch modes. Displayed as curves on the arrangement view, editable with breakpoints.
- **Parameter modulation.** REAPER's parameter modulation lets one parameter drive another -- an LFO on a filter cutoff, a sidechain envelope controlling a gate threshold. Lotus already has `lfo.rye`, `auto_pan.rye`, and the modulation family. The engine routes modulation sources to any parameter in the graph.
- **The render matrix.** A grid where rows are songs (or regions) and columns are output configurations -- format (WAV, FLAC, `.peal` Opus), sample rate (44.1, 48, 96 kHz), bit depth, dither type, loudness target. The engineer fills the grid once. One command renders every cell. This is Alain Paul's fifth requirement, and it is a script over the render graph rather than a special subsystem.
- **Session metadata as first-class facts.** ISRC, UPC, catalog number, artist, album, track timing, revision notes -- each one a Kyri field in the session's Weave, queryable and exportable. A DDP image or a streaming-service delivery manifest is a fold over these facts plus the rendered audio. This is Alain Paul's fourth requirement.

## 4. Rationale

### Why learn from REAPER

REAPER earned an S-tier ranking from Alain Paul for professional mastering work -- the only DAW in his assessment that can do everything a mastering engineer needs. The qualities that earned it:

- **Small and fast.** The entire application is roughly 15 to 20 megabytes. It starts in under a second. The audio engine is tight and honest about its resource use. Lotus, running on Tally-bounded allocations, can aim for the same.
- **Deep scripting.** ReaScript (EEL, Lua, Python) automates everything from track creation to render passes. Lotus maps this to Rishi (the operational shell) and Glow (the compiled language), both already authored in this tree.
- **JSFX -- user-programmable effects.** REAPER lets a user write a signal-processing plugin in a text file, save it, and hear the result without restarting. Lotus's 240 Rye modules are already this -- each one is a text file, each one is proven by a witness, and the language is designed for hot-loop safety.
- **Flexible routing.** Any track can send to any track. Folder tracks are buses. The signal path is explicit and visible. Lotus's render graph carries the same topology.
- **Per-plugin wet/dry and delta solo.** Every plugin slot in REAPER's FX chain has a wet/dry knob and a "delta" solo that isolates what the plugin changed. Alain Paul calls this essential. Lotus carries it per slot in the FX chain.
- **Render matrix.** REAPER's region render matrix is what allows batch export of an entire album in multiple formats. Lotus seats this as a core feature.

### Why learn from Ableton Live

Ableton earned an A-tier ranking. Its strengths that Lotus carries forward:

- **Session View.** A grid of clips launched in any order -- the performance surface that REAPER lacks. Lotus seats this as a horizon surface on the Weave event model.
- **MIDI.** Ableton's MIDI handling is mature and musical. Lotus currently works only with audio. MIDI input, sequencing, and virtual instruments are a natural second chapter.
- **Max/MSP integration.** Ableton's Max for Live lets users build custom instruments and effects with a visual patching language. Glow, when it reaches visual composition, is Lotus's answer to this -- a compiled, bounded, type-checked patching language rather than a runtime interpreter.
- **Strong stock instruments and effects.** Ableton ships a large library of instruments, effects, and sounds. Lotus's 240 modules across twelve families are the beginning of this library, and every one of them ships with its own witness.

### Why the Weave model

A DAW session is traditionally a single mutable state. You save, you load, you undo by reversing mutations. Lotus's Weave model -- a fold over an append-only event log -- gives three things for free that traditional DAW architectures bolt on afterward:

1. **Full revision history without a separate version-control layer.** Every state the session has ever been in is recoverable by folding fewer events.
2. **Named branches as first-class objects.** A radio edit is a branch, a mastering revision is a branch, and each shares source material with the trunk.
3. **Provenance.** Every change carries a timestamp, and when identity is present, a Kumara signature. Who changed what and when is a question the session file can answer.

### Why native macOS first

The macos-native waymark (`macos-native-surface-rye-backend`) already proved the platform reachable from Rye alone, with zero Swift linked. The Skate Swift package holds `LotusMeterReading`, `FrameGrid`, and `EventRing`. CoreAudio is the most capable audio API on any desktop operating system -- low latency, stable, well-documented. Starting here means the hardest real-time problem (the audio callback) is solved against the best host, and the surfaces draw on a proven native shell rather than a cross-platform abstraction. Linux (ALSA/JACK/PipeWire) and the Terrarium browser surface follow.

### Why self-contained first

Lotus already has 240 modules. Loading a third-party VST3 or CLAP plugin means sandboxing a foreign binary, marshaling its state, handling its crashes without taking down the audio engine, and trusting its memory behavior inside the hot loop. Caravan can supervise this -- it already supervises dependent processes -- yet the sandboxing surface is large and the first studio should prove itself before opening that door. The 240 stock modules are proven, bounded, and witnessed. Start there.

## 5. Architecture

```
Session file (.lotus -- sealed Kyri notation)
  |
  v
Weave fold -> current session state (tracks, clips, automation, metadata, branches)
  |
  +--> Brushstroke surfaces (arrangement, mixer, plugin faces, meters)
  |      drawn through Skate/AppKit native shell (macos-native)
  |
  +--> Maitreya render graph (the hot loop)
  |      CoreAudio callback -> graph walk -> node processing -> output buffer
  |      Each Lotus module = one graph node
  |      Tally-bounded buffers, Caravan-supervised hosts
  |
  +--> Scripting engine
  |      Rishi (operational automation)
  |      Glow (compiled DSP and patching, horizon)
  |
  +--> Render matrix
  |      Region grid x output configurations -> batch export
  |
  +--> Metadata export
         ISRC, DDP image, streaming manifests -> fold over session facts
```

### The wire shape stays

The lotus-audio wire shape (`lotus/wire.rye`) is the foundation. A sealed PCM frame -- magic `LOTS`, version byte, cable tag, SHA-256 digest, i16 LE samples, max 1024 per frame -- is how audio moves between nodes in the render graph. The seal is verified at every handoff. A half-sample never reaches the timeline.

### Module families as plugin categories

The twelve families in [`lotus/MODULES.md`](../../../lotus/MODULES.md) become the stock plugin library:

| Family | Modules | DAW role |
|---|---|---|
| Wire and stream | 5 | I/O and format |
| Span edits | 22 | Timeline editing |
| Transport and clock | 10 | Playback and navigation |
| Mix, faders, stereo | 16 | Mixer channel strip |
| Tone and filters | 14 | EQ and filtering |
| Dynamics | 17 | Compression, gating, limiting |
| Time and modulation | 25 | Delay, reverb, modulation FX |
| Spatial | 8 | Stereo imaging, surround |
| Analysis | 21 | Metering, FFT, loudness |
| Mastering | 20 | Mastering chain |
| Sealed records | 22 | Export and verification |
| Catalog | 60 | Session and library management |

### SLC order (updated from the `20260630` horizon)

1. **Lotus Seed.** Transport + one audio track + record from CoreAudio + one FX slot (any Lotus module) + peak/RMS meter + WAV export. The smallest session that can record, process, and render. Prove the hot loop on metal: callback never misses under documented load.
2. **Multi-track and the mixer.** N tracks, fader/pan/solo/mute per track, routing (sends, folder buses), the mixer surface in Brushstroke.
3. **FX chain and plugin faces.** Ordered FX chain per track, bypass/wet-dry/delta-solo per slot, AP Mastering-inspired tiered faces for the stock modules.
4. **Scripted ingestion and automation.** Rishi scripting API, automation lanes (read/write/touch/latch), parameter modulation.
5. **The render matrix and metadata.** Batch export grid, session metadata as Weave facts, DDP and streaming-manifest export.
6. **Session View (horizon).** Clip-launch grid, live-performance routing.
7. **MIDI (horizon).** MIDI input, sequencing, virtual instruments.
8. **Glow visual patching (horizon).** Max/MSP-shaped visual composition in Glow.
9. **External plugins (horizon).** VST3/CLAP/AU hosting via Caravan-supervised sandbox.

## 6. Considerations

### Clean room discipline

REAPER is proprietary. Ableton Live is proprietary. Lotus studies their public documentation, their published behavior, and the discipline they represent. It never copies source code, UI assets, or internal data structures. The gratitude bridges at [`gratitude/reaper.md`](../../../gratitude/reaper.md) and [`gratitude/ap-mastering.md`](../../../gratitude/ap-mastering.md) name this boundary plainly. The clean room path (`gratitude-licenses.md`) governs: external research studies the world with attribution; active designing names only our own modules; only understanding crosses from one to the other.

### Bounded everything

TAME Guidance governs every module in Lotus. Every allocation names a maximum. Every buffer is Tally-bounded. Every loop has a ceiling. The hot loop is the place where this matters most -- a single unbounded allocation in the audio callback means a skip, and a skip means the listener hears a click. Lotus's architecture is bounded by construction rather than by convention, which is the distinction TAME draws between safety that is structural and safety that depends on someone remembering.

### The finishing edge

This proposal describes a large surface. The SLC order above is the discipline that keeps it honest -- ship one real thing (the Lotus Seed) before naming the next, and each rung stands on the rungs below it, the same way the existing 240 modules climbed from `wire.rye` to `catalog_verify.rye`. The design-over-build ratio is watched, and a proposal this size is a weight on that ratio until the first rung lands.

## 7. Caveats

### Latency is a measurement, and it waits for metal

The numbers that matter -- round-trip latency from microphone to headphones, callback duration under load, the maximum track count before the first skip -- are measurements taken on real hardware. This proposal can describe the architecture that makes low latency possible (bounded buffers, a frozen graph, a tight callback). It cannot claim a number until a witness holds it on metal.

### MIDI is absent from the first delivery

The 240 existing Lotus modules work entirely with audio. MIDI input, sequencing, note editing, and virtual instruments are a natural and important expansion, yet they are a second chapter rather than a first one. A musician who works primarily with MIDI will not find what they need in the Lotus Seed. This is an honest scope boundary rather than an oversight.

### No external plugin hosting at first

A professional engineer's workflow includes third-party plugins. Lotus's first delivery runs only its own 240 modules. VST3, CLAP, and AU hosting require a sandboxed host process (supervised by Caravan) and a marshaling layer for each format's C/C++ ABI. This is real work with real security surface, and it follows the core studio rather than shipping beside it.

### The Session View is a horizon surface

Ableton's Session View is one of its strongest ideas -- a grid of clips launched in any order, enabling live performance and improvised arrangement. Lotus's Weave model supports it naturally (a clip launch is a fact), yet drawing it, wiring it to the engine, and making it feel right is a full chapter of work. It follows the arrangement view.

## 8. Horizon

Beyond the SLC rungs above, the horizon holds:

- **Terrarium.** The browser-hosted RISC-V emulation surface -- Lotus running inside a web page, a living world under glass. The audio engine compiles to RISC-V, Terrarium emulates it, WebAudio provides the callback. A person opens a URL and has a studio.
- **Collaborative editing.** Two people working on the same session, their edits signed by Kumara and merged in the Weave. The event-log model makes this possible -- conflict resolution is a merge of two event sequences, the same problem version control already solves.
- **Video sync.** Maitreya's name already carries it -- the media driver framework for audio and video. A video track synced to the arrangement timeline, for film scoring and post-production.
- **Glow as a live DSP language.** Glow compiles to native code. A Glow patch running inside the render graph is a live-editable, type-checked, bounded signal processor -- JSFX with a real type system.
- **Surround and spatial audio.** The spatial family (`lotus/spatial/`) already holds eight modules. Extending to Dolby Atmos and Ambisonics is a routing and rendering problem over the existing primitives.
- **A package format for sharing Lotus instruments.** A `.petal` (proposed) containing a Glow patch, sample data, preset Weave facts, and a Brushstroke face definition -- the Lotus equivalent of an Ableton Pack or a REAPER theme.

## 9. Conclusion

Lotus has 240 proven modules and no home to put them in. REAPER shows what the home should feel like -- small, fast, scriptable, honest about its routing. Ableton shows what the performance surface can be -- a grid of clips launched in any order, MIDI as a first-class citizen. Alain Paul shows what the profession actually needs -- scripted ingestion, non-destructive stem summing, revision management, metadata, and a render matrix.

The architecture this proposal describes -- a Weave event log folded into session state, a Maitreya render graph walking Tally-bounded buffers through Lotus modules, Brushstroke drawing AP Mastering-inspired tiered surfaces on a Skate/AppKit native shell -- is not a wish. It is a reading of the parts already standing and the space between them.

The SLC order starts with the smallest session that can record and play -- one track, one effect, one meter, one export. Each rung after that adds one real capability, witnessed on metal before the next one opens. The same ladder discipline that built the 240 modules builds the studio around them.

---

*Thank you, Kyli, for holding the warm thinking while it was still becoming itself. The notebook is where the studio got its first honest shape, before the specs narrowed it and the code hardened it. May the first take land clean, may the render matrix finish before morning, and may every sealed record open for the person it was made for.*
