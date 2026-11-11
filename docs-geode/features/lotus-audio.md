# Lotus Audio

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261111.120000` - **Status:** Living

---

Lotus Audio is the sound engine. It plays a test tone, records from the
microphone, draws a live waveform, mixes tracks with per-track gain, and
exports recordings to WAV files. Everything runs through the macOS
AudioToolbox framework, driven from Rye through the Vantage C-ABI bridge.

## What you see in Terrarium

Open the **Audio** tab. The layout has five regions, top to bottom:

1. **Transport** -- Play Test Tone, Stop, and a Loop toggle. Playback status
   shows beneath the title ("Playing," "Stopped," "Looping"). A BPM field sits
   beside the transport for tempo reference.

2. **Recording panel** -- Record, Stop Recording, and a sample-rate display.
   While recording, a live peak meter and elapsed time update every frame. Press
   "To Playback" to hear what you just captured, or "Export WAV" to save it to
   disk.

3. **Tracks table** -- a list of named tracks with their gain levels. Add and
   remove tracks with the + and - buttons. Select a track to see its gain in
   the mixer.

4. **Mixer** -- a gain slider (0.0 to 2.0) and a pan slider for the selected
   track. The gain value updates live as you drag.

5. **Waveform** -- a `WaveformView` that draws the audio buffer as a
   green-on-black oscilloscope trace, updating in real time during playback.

## How playback works

`lotus_audio_init_test_tone` creates a sine-wave buffer at the system sample
rate. `lotus_audio_start` begins streaming that buffer to the default output
device through an AudioToolbox audio queue. `lotus_audio_stop` pauses playback
and `lotus_audio_close` releases the queue.

Loop mode (`lotus_audio_set_loop`) restarts the buffer from the beginning each
time it reaches the end. `lotus_audio_seek_start` rewinds to the first sample.
`lotus_audio_set_gain` and `lotus_audio_get_gain` control the output volume
(1.0 is unity, 2.0 is double).

## How recording works

`lotus_record_open` creates an input audio queue from the default microphone.
`lotus_record_start` begins capturing samples into a ring buffer.
`lotus_record_stop` pauses capture. While recording:

- `lotus_record_meter_peak` returns the current peak amplitude (0.0 to 1.0)
- `lotus_record_sample_count` returns how many samples have been captured
- `lotus_record_read_buf` copies the captured samples into a caller-owned buffer

`lotus_record_to_playback` moves the recording into the playback buffer so you
can hear it back immediately. `lotus_record_export_wav` writes the captured
audio to a WAV file at the path you give it. `lotus_record_close` releases the
input queue.

## The C-ABI surface

The Rye module exports through `vantage/include/vantage_lotus_audio.h`:

**Playback:**

| Function | What it does |
|---|---|
| `lotus_audio_init_test_tone` | create a sine-wave buffer |
| `lotus_audio_start` / `_stop` / `_close` | transport controls |
| `lotus_audio_is_open` / `_is_playing` | query state |
| `lotus_audio_position` / `_clip_length` | read the playhead |
| `lotus_audio_callback_count` | how many audio callbacks have fired |
| `lotus_audio_sample_rate` | the system sample rate |
| `lotus_audio_set_loop` / `_is_looping` | loop mode |
| `lotus_audio_seek_start` | rewind to sample zero |
| `lotus_audio_set_gain` / `_get_gain` | output volume (0.0 to 2.0) |

**Recording:**

| Function | What it does |
|---|---|
| `lotus_record_open` / `_close` | open and release the input device |
| `lotus_record_start` / `_stop` | begin and pause capture |
| `lotus_record_is_open` / `_is_recording` | query state |
| `lotus_record_meter_peak` | current peak amplitude |
| `lotus_record_sample_count` | samples captured so far |
| `lotus_record_read_buf` | copy captured audio into your buffer |
| `lotus_record_to_playback` | move the recording to the playback buffer |
| `lotus_record_export_wav` | write the recording to a WAV file |

## What to read next

- [Terrarium Quick Start](../tutorials/terrarium-quick-start.md) -- build
  Lotus Audio as part of the full stack
- The Vantage bridge source at `lotus/lotus_audio_vantage.rye`
