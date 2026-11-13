# Kirtan Generation, MIDI, Dial, and Plugin Format

**Stamp:** `20261111.170815` -- **Status:** Living, checkable
**Room:** checkable -- design decisions for Lotus audio generation
**Style:** Gauge at the Field setting, with Radiant warmth

Keaton asked for four things at once: generate an instrumental minor key
kirtan song with fixed tempo and simple melody; implement a TAME-guided
version of TouchOSC; decide whether to support MIDI and MIDI keyboards;
and decide the plugin module name and format. This essay captures all
four decisions and the architecture that connects them.

## 1. Kirtan generation -- what the pipeline needs

A kirtan is devotional call-and-response music. Keaton wants instrumental,
minor key, fixed tempo, simple melody. That means the DAW needs modules
it does not yet have:

**What exists today:** bytes -> wire frames -> stream -> Clip -> Session
tracks -> fader -> pan -> transport -> CoreAudio. Every module processes
existing audio. None generates pitched sound from a note number.

**What is needed, in dependency order:**

1. **note.rye** -- pitch and scale. A MIDI note number (u7, 0-127) maps
   to a frequency. A scale is a set of intervals from a root. Named
   presets: natural minor, harmonic minor, major, pentatonic minor.
   The frequency table is comptime, in millihertz (u32), so no floating
   point touches the audio path.

2. **tempo.rye** -- beat clock. A BPM (u32, bounded 20-300) and a sample
   rate yield a samples-per-beat count. The beat clock tells the
   sequencer when each step falls, in samples. Builds on clock.rye's
   time base.

3. **synth.rye** -- wavetable oscillator. A 256-entry i16 wavetable
   (sine, triangle, square, saw), a 16.16 fixed-point phase accumulator,
   and an ADSR envelope in i16. render_note() takes a frequency in
   millihertz, a duration in samples, a velocity (u7), and writes i16
   PCM into a Clip. No floating point.

4. **sequence.rye** -- pattern sequencer. A pattern is a bounded array of
   steps. Each step: note (u7), velocity (u7), gate length (u8, in
   fractions of the step). The sequencer walks the pattern at the tempo
   clock's pace, calling synth.render_note() for each step, mixing
   results into a Clip.

5. **kirtan.rye** -- the generator that ties them together. Takes a root
   note, a scale (natural minor), a BPM, a simple call-and-response
   melody pattern, and renders an instrumental kirtan clip. This is the
   payoff -- one function call produces a song.

**Instrument voices for the kirtan:** a drone (tanpura -- a sustained
root+fifth wavetable), a melody (harmonium -- a brighter wavetable
playing the call-and-response pattern), and a rhythm (tabla -- a
percussive wavetable on a simple pattern). Three tracks in the Session,
mixed through the existing fader and pan graph.

## 2. MIDI -- yes, and it is naturally TAME

**Decision: support MIDI.** MIDI's data types are bounded by the protocol
itself:

- Note number: u7 (0-127) -- a perfect u7, bounded at birth
- Velocity: u7 (0-127) -- same
- Channel: u4 (0-15) -- four bits
- Control value: u7 (0-127)
- Pitch bend: u14 (0-16383) -- fourteen bits, center at 8192

Every value already names its own width. TAME Guidance asks for explicit
widths and bounded everything -- MIDI delivers both by specification.

**CoreMIDI on macOS** is the system MIDI framework. It gives us hardware
MIDI keyboard input (USB or Bluetooth) through a C API that Rye can call
at the seam, the same way coreaudio.rye calls AudioToolbox.

**Module: midi.rye** -- parse MIDI messages (3 bytes: status, data1,
data2), expose note-on/note-off/control-change events with typed fields.
A MIDI keyboard connected via CoreMIDI sends note events that drive the
synth in real time -- play a note, hear it immediately through the
existing CoreAudio output.

## 3. Dial -- the control surface (TouchOSC equivalent)

**Decision: the module is called Dial.** `lotus/dial.rye`. Per the
Comlink tendency, Dial is clear (a reader pictures a knob or a fader
instantly), fun to say, safe (no collision in the tree -- confirmed by
grep), and warm at any length.

TouchOSC is a customizable OSC (Open Sound Control) control surface. Our
TAME-guided equivalent:

**What Dial provides:**
- A grid of controls: faders (vertical sliders), knobs (rotary), buttons
  (momentary and toggle), XY pads
- Each control maps to a parameter: track volume, pan position, send
  level, synth parameter, tempo
- Controls rendered in the Brushstroke surface (the same pixel buffer
  lotus_window.rye already draws into)
- MIDI CC mapping: a hardware MIDI controller's knobs and faders drive
  Dial controls through midi.rye

**What Dial does not need:**
- Network OSC protocol -- TouchOSC's main purpose is sending OSC over
  WiFi to a DAW. We are the DAW. Dial controls the parameters directly
  in-process, with no network hop.
- A separate app -- Dial renders in the same window as the track list
  and waveform display.

**Control representation:**
```
Control = struct {
    kind: ControlKind,     // fader, knob, button, xy_pad
    value: u7,             // 0-127, same as MIDI CC
    label: [max_label]u8,  // short name
    label_len: u32,
    midi_cc: u7,           // which MIDI CC maps to this control
};
```

The u7 value range matches MIDI CC exactly, so a hardware knob at
position 64 sets Dial's fader to 64 with no conversion.

## 4. Plugin format -- .rye files, path names role

**Decision: no new extension.** A plugin is a `.rye` file that follows a
published API. The path names the role:

- `lotus/instruments/harmonium.rye` -- an instrument plugin
- `lotus/effects/reverb.rye` -- an effect plugin
- `lotus/generators/kirtan.rye` -- a generator plugin

The file exports a known set of public functions (process, render,
parameter_count, parameter_name, parameter_value, set_parameter). The
extension names the language; the path names the role. When Glow
compiles, `.glow` files follow the same pattern in their own path.

**Why no new extension:** an extension names a language, and a plugin is
not a language -- it is a role within a language. `.rye` already means
"Rye source that the Rye compiler builds." A plugin API is a contract
about which functions are exported, not about which compiler reads the
file. The Comlink tendency's three tests (clear, fun, safe) all pass for
the path-names-role convention.

## Architecture summary

```
note.rye -----> synth.rye -----> sequence.rye --> kirtan.rye
  (pitch)      (oscillator)      (pattern)        (generator)
                    ^
tempo.rye ----------|-----------> sequence.rye
  (beat clock)

midi.rye -----> synth.rye (real-time play)
  (input)  +--> dial.rye  (control mapping)

dial.rye -----> fader.rye, pan.rye, tempo.rye (parameter control)
  (surface)
```

All values are i16 PCM in the audio path. All parameters are u7
(0-127). All frequencies are u32 millihertz. No floating point.

## Build order

1. note.rye -- foundational, no audio dependencies
2. tempo.rye -- depends on clock.rye
3. synth.rye -- depends on note.rye, timeline.rye
4. sequence.rye -- depends on synth.rye, tempo.rye
5. midi.rye -- depends on note.rye (for note numbers)
6. dial.rye -- depends on midi.rye (for CC mapping)
7. kirtan.rye -- depends on all of the above

Each module carries its own selftest. Each is bounded, asserted, and
explicit-width per TAME Guidance.

Related: `lotus/clock.rye` (time base), `lotus/tone.rye` (filter,
not generator), `lotus/bell.rye` (EQ), `lotus/track.rye` (session
model), `lotus/lotus_window.rye` (Brushstroke surface).
