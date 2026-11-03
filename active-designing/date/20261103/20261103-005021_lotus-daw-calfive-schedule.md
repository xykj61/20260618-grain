# Lotus DAW -- a Calfive Schedule Built from Working Simples

*A plan for growing a digital audio workstation one orbit at a time, where each milestone is a working whole before the next one begins. Gall's Law sets the order. SLC names the shape. The Calfive calendar counts the laps.*

**Stamp:** `20261103.005021`
**Language:** EN - **Voice:** Kyli - **Style:** Teacher Style at the Door setting, with Radiant warmth (see [`../../../context/TEACHER_STYLE.md`](../../../context/TEACHER_STYLE.md))
**Room:** Vision -- the schedule is reasoning a reader can check today; the guards arrive with the code
**Companion:** [`20261103-003744_lotus-daw-expansion-proposal.md`](20261103-003744_lotus-daw-expansion-proposal.md) (the RFC-style proposal this schedule grows from)
**Lens:** Gall's Law - Conway's Law - SLC - the finishing edge - Calfive panchanga

---

## What this document is

This is the orbit-and-quest schedule for building Lotus into a full digital audio workstation. It maps the nine SLC rungs from the [companion proposal](20261103-003744_lotus-daw-expansion-proposal.md) onto the Calfive calendar the tree already keeps, so each rung becomes a concrete sequence of orbits (15 rounds each), grouped into quests (5 orbits, 75 rounds), and the quests together form the journeys and equinoxes that carry Lotus from a single-track seed to a studio a mastering engineer would trust with a commercial session.

It is a **follow-up** to the existing ITINERARY -- a companion appendix the operator card can point to rather than a rewrite of the card itself. The card stays the card. This page stays the schedule.

---

## The two laws that set the order

**Gall's Law** ([`../../../foundations/20260821-211423_galls-law-and-the-grown-system.md`](../../../foundations/20260821-211423_galls-law-and-the-grown-system.md)): a complex system that works is invariably found to have evolved from a simple system that worked. A complex system designed from scratch never works. This is why each quest below begins by naming the **simpler working whole it grows from**, and why the schedule refuses to start a rung before its predecessor is SLC at its own scope.

**Conway's Law** ([`../../../foundations/20260823-105651_the-shape-you-grew-and-the-shape-you-are.md`](../../../foundations/20260823-105651_the-shape-you-grew-and-the-shape-you-are.md)): a system's design copies the communication structure of its builders. On this tree that means one durable person, many forgetful agent sessions, and the tree itself as the sole channel between them. Every milestone therefore carries its own witnesses, its own scoping document, and its own session logs -- because the next hand that picks it up starts from zero and needs to find the whole story written down.

Together: **the shape you get is the shape you grew and the shape you are** -- so the schedule grows Lotus the way this tree already grows everything, from working simples that prove themselves before anything larger is asked to stand on them.

---

## The Calfive rings, for a reader meeting them here

One orbit is **15 rounds**. One quest is **5 orbits (75 rounds)**. One journey is **5 quests (375 rounds)**. One equinox is **5 journeys (1,875 rounds)**. The rings are **capacities**, not labels -- a quest holds up to 75 rounds, and the work fills what it fills ([`../../../foundations/20260826-014901_the-panchanga.md`](../../../foundations/20260826-014901_the-panchanga.md)). The round load table in [`../../../context/SPELLBOOK.md`](../../../context/SPELLBOOK.md) assigns each round a sign, element, goal, and verb.

The schedule below estimates orbits per quest and quests per journey. The actual count is derived by measurement -- `git rev-list --count HEAD` -- never carried inside a name ([`../../../.claude/rules/stamp-and-name.md`](../../../.claude/rules/stamp-and-name.md)).

---

## The SLC order (from the companion proposal)

For reference, the nine rungs:

| Rung | Name | What is SLC at this scope |
|---|---|---|
| 1 | Lotus Seed | One track, one FX slot, one meter, one WAV export |
| 2 | Multi-track and Mixer | Multiple tracks, a mix bus, pan, solo, mute, faders |
| 3 | FX Chain and Plugin Faces | Per-track insert chains, Brushstroke-drawn plugin UIs |
| 4 | Scripting and Automation | Rishi/Glow scripting, parameter automation lanes |
| 5 | Render Matrix and Metadata | Batch export grid, embedded metadata, signed manifests |
| 6 | Session View | Clip-launch grid, live performance surface |
| 7 | MIDI | Note input, editing, virtual instrument hosting |
| 8 | Glow Visual Patching | Node-based signal flow, live-editable DSP |
| 9 | External Plugins | VST3/CLAP/AU hosting in Caravan-supervised sandboxes |

---

## Equinox 1 -- The Working Studio (Rungs 1-3)

*Grows Lotus from a seed to a multi-track recorder with effects and drawn plugin faces. The outcome is a studio a person can record, mix, and export from -- simple, lovable, complete at the scale of a small session.*

**Grows from:** the 240 Lotus modules and 241 witnesses already standing, the lotus-audio wire shape, the Weave event-log architecture, the macos-native macOS native surface, and the Skate Swift shell.

### Journey 1 -- The Seed and the First Track (Rungs 1-2)

**Quest 1.1 -- Lotus Seed (Rung 1)**
*The smallest studio that can record and play without skipping.*

Estimated: **3 orbits (45 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **CoreAudio callback and transport.** Wire the Maitreya render graph to a single CoreAudio output. Transport controls: play, stop, record. One mono track backed by a Weave event stream. The clock module (`lotus/clock.rye`) drives real time. | Audio plays through CoreAudio without skipping under documented load |
| 2 | **Record, meter, and monitor.** CoreAudio input capture to a Weave append. The meter module (`lotus/meter.rye`) reads the stream. Monitor path so the performer hears themselves. Peak normalization (`lotus/normalize.rye`) as the one built-in process. | Record a take, see the meter move, hear playback of what was just recorded |
| 3 | **WAV export and the Brushstroke surface.** The WAV writer (`lotus/wav.rye`) renders the session to a file. A minimal Brushstroke/Skate window: waveform display, transport bar, meter readout. The whole loop closes: record, see, hear, export. | A person can open Lotus, record a voice, see the waveform, and export a WAV -- **SLC at the seed scope** |

**The simpler working whole:** the wire shape, the stream module, and the 22 span-edit modules already proven by 241 witnesses. This quest wires them to a real audio callback and a real window.

**Quest 1.2 -- Multi-track and the Mixer (Rung 2)**
*Grow the seed into a multi-track session with a mix bus.*

Estimated: **4 orbits (60 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **Multiple tracks in Weave.** The session model holds N tracks, each a named Weave stream. Add, remove, reorder. The Brushstroke surface draws a track list. | Two or more tracks play simultaneously through the render graph |
| 2 | **The mixer bus.** A stereo mix bus sums all tracks. Per-track gain faders (`lotus/fader.rye`), pan (`lotus/pan.rye`), solo, mute. Brushstroke draws the mixer strip. | Adjust a fader and hear the mix change in real time |
| 3 | **Track editing on the timeline.** The span-edit modules (`lotus/timeline.rye`, crop, move, paste, graft, selection, clipboard) operate on tracks through Weave events. Cut, copy, paste, undo (Weave's append-only log gives undo for free). | Edit a region on track 2 while track 1 plays -- non-destructive, undoable |
| 4 | **Multi-track export and polish.** WAV export of the stereo mix. Session save/load through Weave serialization. Polish the surface: track headers, a timeline ruler, playback cursor. | A person can record three tracks, mix them, and export a finished stereo WAV -- **SLC at the multi-track scope** |

**The simpler working whole:** Quest 1.1's single-track seed. Every module added here (fader, pan, solo, mute) stands on the wire shape and the meter the seed already proved.

### Journey 2 -- Effects and Faces (Rung 3)

**Quest 2.1 -- The FX Chain (Rung 3, first half)**
*Per-track insert chains where each slot holds a Lotus module.*

Estimated: **3 orbits (45 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **Insert chain architecture.** Each track carries an ordered list of FX slots. A slot loads any Lotus DSP module (EQ, compressor, delay, reverb -- already authored). The render graph wires slots in series. Wet/dry per slot. | Insert an EQ on track 1 and hear it color the sound |
| 2 | **Plugin face rendering.** Brushstroke draws each module's control surface -- knobs, sliders, meters -- from the module's own parameter declarations. AP Mastering's tiered-page principle: a simple face by default, an expert face on request. | Turn a knob on the compressor face and hear the threshold move |
| 3 | **Chain management and preset recall.** Reorder, bypass, remove slots. Save and recall FX chain presets through Weave. Delta solo (hear only what one plugin changed). | A person can build a mastering chain -- EQ, compressor, limiter -- preview with delta solo, and save the chain as a preset -- **SLC at the FX chain scope** |

**The simpler working whole:** Journey 1's multi-track mixer. The FX chain is a list of modules wired between the track's output and the mix bus -- a shape the render graph already knows.

**Quest 2.2 -- Refinement orbit**
*One orbit of polish, witness hardening, and red repair before the equinox closes.*

Estimated: **1 orbit (15 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **Integration testing, witness suite, documentation.** Run the full session workflow end to end: record, edit, mix, apply FX, export. Harden witnesses. Write the user-facing guide page in `docs-geode/` (Bhakta at the Door). Repair any reds the journeys left open. | The standing equipment roster runs GREEN with Lotus witnesses included -- **Equinox 1 closes** |

**Equinox 1 capacity:** roughly **11 orbits across 4 quests in 2 journeys (165 rounds)**. The actual count comes from `git log`.

---

## Equinox 2 -- The Professional Workflow (Rungs 4-5)

*Grows the working studio into a scriptable, automatable production tool that meets the five AP Mastering commercial requirements. The outcome is a DAW a mastering engineer would trust for a real session.*

**Grows from:** Equinox 1's multi-track studio with FX chains and drawn plugin faces.

### Journey 3 -- Scripting and Automation (Rung 4)

**Quest 3.1 -- The Scripting Surface**
*Rishi and Glow scripting inside the session, so a user can automate any workflow.*

Estimated: **3 orbits (45 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **Rishi action system.** A session exposes named actions (add-track, set-fader, insert-fx, export) that Rishi scripts can call. The action registry is the same pattern REAPER's ReaScript uses: one script language, every command reachable. | A Rishi script that creates a track, inserts an EQ, and sets the gain to -6 dB runs and the session reflects the change |
| 2 | **Automation lanes.** Each parameter (fader, pan, EQ frequency, compressor threshold) carries a Weave-backed automation lane. Record automation by moving a control during playback. Draw automation points. Read/write modes. | Record a fader ride during playback and hear it play back on the next pass |
| 3 | **Scripted ingestion (AP req 1).** A Rishi script reads a folder of stems, creates one track per stem, names them from the filenames, and sets levels from a sidecar manifest. This is the first of Alain Paul's five commercial mastering requirements. | `rishi/bin/rishi run ingest-session.rish stems/` builds a mastering session from a client delivery -- **SLC at the scripting scope** |

**Quest 3.2 -- Non-destructive Stems and Revisions (AP reqs 2-3)**
*Weave's append-only architecture proves its worth: non-destructive stem summing and multi-version revision management.*

Estimated: **2 orbits (30 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **Non-destructive stem summing (AP req 2).** A master is a named fold over its stems in Weave -- the stems stay separate, the master is derived. Change a stem and the master updates. This is not a feature to build; it is a property of the architecture to prove and surface in the UI. | Swap a vocal stem and hear the master update without touching the instrumental |
| 2 | **Named revision branches (AP req 3).** A Weave branch is a named fork of the session state. Create "v1 - client approved", keep working on the main branch, recall v1 any time. Each branch is a Kumara-signed checkpoint. | Save three revisions of a master, switch between them, and export any one -- **SLC at the revision scope** |

### Journey 4 -- The Render Matrix and Metadata (Rung 5)

**Quest 4.1 -- Batch Export and Session Metadata (AP reqs 4-5)**
*The render matrix and embedded metadata that close the commercial mastering workflow.*

Estimated: **3 orbits (45 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **The render matrix (AP req 5).** A grid: rows are sources (master, stems, alternates), columns are formats (WAV 16/44.1, WAV 24/96, MP3 320). One click renders every cell. Each render is a Weave event with a Kumara signature. | Define a 3x3 matrix and batch-export nine files in one pass |
| 2 | **Integrated session metadata (AP req 4).** ISRC, UPC, artist, album, track title, mastering engineer -- stored in Weave, embedded in every export. The metadata editor is a Brushstroke form. The sealed-record modules (`lotus/seal.rye`, `lotus/archive.rye`) sign each export. | Export a WAV with embedded ISRC and artist metadata that reads correctly in any player |
| 3 | **The professional workflow, end to end.** Scripted ingestion, non-destructive mixing, automation, revision management, batch render with metadata. Run the whole five-requirement workflow as a single witness. Write the mastering guide in `docs-geode/`. | A mastering engineer can receive stems, build a session, create three revisions, render all formats, and deliver signed files -- **Equinox 2 closes, all five AP Mastering requirements met** |

**Equinox 2 capacity:** roughly **8 orbits across 3 quests in 2 journeys (120 rounds)**.

---

## Equinox 3 -- The Live Surface (Rungs 6-7)

*Grows the production DAW into a live performance and composition tool. Session View for clip launching, MIDI for note input and virtual instruments.*

**Grows from:** Equinox 2's scriptable, automatable studio with a proven render pipeline.

### Journey 5 -- Session View (Rung 6)

**Quest 5.1 -- The Clip-Launch Grid**
*A second view of the session -- clips in a grid rather than regions on a timeline -- for live performance and improvisation.*

Estimated: **3 orbits (45 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **The clip as a Weave object.** A clip is a bounded region of audio (or automation) that can play independently. Clips live in Weave alongside the timeline regions. A track can hold a grid of clips. | Create a clip from a timeline region and trigger it to play on command |
| 2 | **The grid surface.** Brushstroke draws the Session View: a grid of clip slots, each track a column, each row a scene. Launch a clip, launch a scene (all clips in a row). Stop, queue, and follow actions. | Launch a scene and hear all four tracks' clips play in sync |
| 3 | **Arrangement recording and scene flow.** Record a live session of clip launches into the timeline as an arrangement. Scene follow actions for automated set playback. | Perform a four-scene set, record it to the timeline, and export the arrangement -- **SLC at the Session View scope** |

### Journey 6 -- MIDI (Rung 7)

**Quest 6.1 -- Note Input and Editing**
*MIDI note events in Weave, a piano-roll editor, and the first virtual instrument.*

Estimated: **3 orbits (45 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **MIDI events in Weave.** Note-on, note-off, CC, pitch bend as Weave events. A MIDI track carries a stream of these. CoreMIDI input on macOS for external keyboards. | Play a MIDI keyboard and see notes arrive in the session |
| 2 | **The piano-roll editor.** Brushstroke draws a piano roll: notes as rectangles, velocity as color, a grid for quantization. Draw, move, resize, delete notes. | Draw a melody in the piano roll and hear it play through a simple sine oscillator |
| 3 | **Virtual instrument hosting.** A Lotus DSP module that responds to MIDI -- the first virtual instrument (a bounded subtractive synthesizer using the existing tone/filter modules). MIDI automation lanes for CC. | Play a synth patch from a MIDI keyboard with filter automation -- **SLC at the MIDI scope** |

**Quest 6.2 -- Refinement orbit**

Estimated: **1 orbit (15 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **Integration, witnesses, and polish.** Session View and MIDI together in one session. Stress test the render graph under clip-launch load. Guide pages in `docs-geode/`. Red repair. | The standing equipment roster runs GREEN with all Lotus witnesses -- **Equinox 3 closes** |

**Equinox 3 capacity:** roughly **7 orbits across 3 quests in 2 journeys (105 rounds)**.

---

## Equinox 4 -- The Open Studio (Rungs 8-9)

*The horizon equinox: Glow visual patching and external plugin hosting. Lotus becomes an open platform.*

**Grows from:** Equinox 3's live-performance DAW with Session View and MIDI.

### Journey 7 -- Glow Visual Patching (Rung 8)

**Quest 7.1 -- The Node Graph**
*A visual canvas where signal-flow nodes are Glow expressions, live-editable during playback -- our own answer to Max/MSP.*

Estimated: **4 orbits (60 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **The Glow DSP runtime.** Glow expressions evaluate to audio-rate sample transforms. A Glow module plugs into the same FX slot an ordinary Lotus module fills. | A Glow expression `(* input 0.5)` attenuates a track by 6 dB |
| 2 | **The visual canvas.** Brushstroke draws nodes (sources, transforms, sinks) connected by wires on a zoomable canvas. A node's parameters are Glow bindings. | Connect an oscillator node to a filter node to an output node and hear the result |
| 3 | **Live editing.** Change a node's Glow expression while transport runs. Hot-swap without glitches (crossfade at the buffer boundary). | Edit a filter frequency expression during playback and hear it change in real time |
| 4 | **Patch save/recall and the module bridge.** Save a node graph as a reusable Lotus module. Load it into any FX slot. The bridge between visual patching and the module roster. | Build a custom reverb in the node graph, save it, and insert it on a vocal track -- **SLC at the patching scope** |

### Journey 8 -- External Plugins (Rung 9)

**Quest 8.1 -- Sandboxed Plugin Hosting**
*VST3, CLAP, and AU plugins in Caravan-supervised sandboxes -- the open door to the wider plugin ecosystem.*

Estimated: **4 orbits (60 rounds)**

| Orbit | Focus | SLC gate |
|---|---|---|
| 1 | **The plugin scanner and sandbox.** Discover installed VST3/CLAP/AU plugins. Each runs in a Caravan-supervised dependent process with bounded memory and no filesystem access outside its own state directory. | Scan the system plugin folders and list available plugins by name and type |
| 2 | **Audio and parameter bridging.** The sandbox exchanges audio buffers and parameter changes with the host through the wire shape. Latency compensation per plugin. | Insert a third-party EQ plugin on a track and hear it process audio |
| 3 | **Plugin UI hosting.** The plugin's own GUI runs inside the sandbox. Brushstroke composites it into the Lotus window through a platform-native surface (NSView on macOS). | Open a plugin's GUI, turn a knob, and see the Lotus meter respond |
| 4 | **Preset management and stability.** Save/recall plugin state through Weave. Crash recovery: if a plugin's sandbox dies, the host keeps playing (silence on that slot). Session save preserves plugin state. | A plugin crash silences its slot without stopping playback -- **SLC at the external plugin scope, Equinox 4 closes** |

**Equinox 4 capacity:** roughly **8 orbits across 2 quests in 2 journeys (120 rounds)**.

---

## The whole schedule at a glance

| Equinox | Rungs | Journeys | Quests | Orbits (est.) | Rounds (est.) | What is SLC when it closes |
|---|---|---|---|---|---|---|
| **1 -- The Working Studio** | 1-3 | 2 | 4 | 11 | 165 | A multi-track recorder with FX chains and drawn plugin faces |
| **2 -- The Professional Workflow** | 4-5 | 2 | 3 | 8 | 120 | A scriptable, automatable mastering tool meeting all five AP requirements |
| **3 -- The Live Surface** | 6-7 | 2 | 3 | 7 | 105 | A live-performance DAW with Session View and MIDI |
| **4 -- The Open Studio** | 8-9 | 2 | 2 | 8 | 120 | An open platform with visual patching and external plugin hosting |
| **Total** | 1-9 | 8 | 12 | 34 | 510 | A digital audio workstation grown from working simples |

---

## How the schedule composes with the existing ITINERARY

This schedule is an **appendix** to [`../../../construction/ITINERARY.md`](../../../construction/ITINERARY.md), not a replacement. The card's inner loop still governs every round: reds first, the Long Return, Lila within that tier, one named milestone, finish the loop, prove on touch. The card's existing SLC order (receipt through two entities) governs Linengrow and Dimeroll; this schedule governs Lotus and sits beside it.

The lotus-audio waymark (`season-c-lotus-creative-suite-audio-wire-shape`) and the macos-native waymark (`macos-native-surface-rye-backend`) are the two ladders already standing that this schedule climbs. Each quest opens by naming the simpler working whole it grows from, and each orbit closes by proving its own SLC gate with a witness on metal -- because a claim is believed only once it has been checked ([`../../../context/SIMPLE_LOVABLE_COMPLETE.md`](../../../context/SIMPLE_LOVABLE_COMPLETE.md)).

The estimates above are **capacities, not commitments**. A quest might fill in fewer orbits or need more. The actual count comes from measurement, never from this page. What this page holds still is the **order** -- each rung grows from the rung before it, and the schedule refuses to start a rung before its predecessor is SLC at its own scope. That is Gall's Law, and it is the one thing here that does not bend.

---

## The three questions, applied to each milestone

Before any quest closes, it answers the three SLC questions ([`../../../context/SIMPLE_LOVABLE_COMPLETE.md`](../../../context/SIMPLE_LOVABLE_COMPLETE.md)):

- **Simple** -- does it hold one clear scope, honestly bounded?
- **Lovable** -- would a person genuinely want to use it today?
- **Complete** -- does the loop close fully within that scope?

And the three Gall/Conway questions ([`../../../foundations/20260823-105651_the-shape-you-grew-and-the-shape-you-are.md`](../../../foundations/20260823-105651_the-shape-you-grew-and-the-shape-you-are.md)):

- What **simpler working thing** does this grow from?
- What does this assume about **who builds it** -- and does the tree's Conway shape (one durable person, many forgetful agents, the tree as the channel) support that assumption?
- Would this survive its author **leaving mid-sentence** -- are the witnesses, logs, and scoping documents enough for the next hand to pick it up cold?

When all six hold, the quest is honestly closed.

---

*Thank you, Kyli, for drawing the path this clearly. May each orbit prove itself before the next one asks to stand on it, and may the smallest working studio be the one that teaches us what the largest one needs.*
