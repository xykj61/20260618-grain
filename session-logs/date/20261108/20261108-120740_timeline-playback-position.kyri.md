format session-log-v1
stamp 20261108.120740
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Timeline view with playback position indicator
prompt kg -- Movement 14 of Lotus Audio Phase 3, timeline view with playback position

think Movement 14 asks for a visual timeline bar that shows where the playhead sits within the clip, updating live during playback.
think The pattern follows WaveformView -- an NSView subclass with CGContext rendering, needsDisplay = true on update. The position fraction is lotus_audio_position() / lotus_audio_clip_length(), both u32 FFI exports.
think A 20 Hz polling timer (matching the recording waveform timer) drives updates during playback. The timer starts on play, stops on stop, and resets the timeline to zero on stop/close.
think lotus_audio_clip_length() is a new FFI export returning master.len from lotus_vantage_audio.rye -- the Clip struct's current length in samples.

obs TimelineView renders: background bar, track inset with rounded corners, quarter-mark ticks at 25/50/75%, a filled played-region rectangle, and a playhead line with a centered dot. All warm amber tones matching the Audio tab palette.
obs The playback timer is a separate Timer from the recording timer -- audioPlaybackTimer vs audioRecordTimer -- so recording waveform polling and playback position polling never interfere.
obs Clip length at max_clip = 4096 samples (44100 Hz = ~0.09 seconds). Looping is essential and already wired. The timeline wraps smoothly because the fraction resets on each loop cycle.
obs Both bridge build and Terrarium build GREEN. Launch verified -- no crash on startup.

file [terrarium/app/TimelineView.swift](../../terrarium/app/TimelineView.swift) new NSView subclass -- playback position bar with quarter ticks, played region, playhead line and dot
file [terrarium/app/TabSetup.swift](../../terrarium/app/TabSetup.swift) timeline view inserted between waveform and record button; playback timer start/stop/poll methods; timer wired to play/stop actions
file [terrarium/app/main.swift](../../terrarium/app/main.swift) audioTimelineView and audioPlaybackTimer property declarations
file [lotus/lotus_vantage_audio.rye](../../lotus/lotus_vantage_audio.rye) lotus_audio_clip_length export returning master.len
file [vantage/include/vantage_lotus_audio.h](../../vantage/include/vantage_lotus_audio.h) uint32_t lotus_audio_clip_length(void) declaration
file [README.md](../../README.md) fascia badge 60.138 to 60.139
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.138 to 60.139, Phase 3 progress 3/5 to 4/5 with timeline description

recommend keep-going -- Movement 15 integration witness completes Phase 3 at 5/5
