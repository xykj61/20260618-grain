format session-log-v1
stamp 20261108.102718
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Live waveform display via timer-based FFI polling
prompt Continue SLC -- land Movement 7 (live waveform during recording)

think Movement 7 needs the waveform panel to update in real time as AUHAL delivers frames. The bridge already has the recording buffer in rec_buf. Need a new FFI export to read that buffer from Swift, then a timer in Swift that polls it and feeds WaveformView.
think Added lotus_record_read_buf FFI export -- copies min(rec_buf.len, max_out) i16 samples into a caller-provided buffer. Bounded copy, no allocation across the boundary.
think Extended selftest to 14 claims -- new claim 13 tests read_buf returns bounded count, zero when no mic input.
think Swift side: stored audioWaveformView and audioRecordTimer as AppDelegate properties. Timer fires at 20Hz (0.05s interval), calls pollRecordingBuffer() which reads i16 via FFI, converts to Float via /32768.0, feeds WaveformView.update(buffer:). Status label shows sample count and peak.
obs Bridge selftest 14 claims GREEN. Terrarium build GREEN (only expected version warnings). The timer approach avoids threading complexity -- CoreAudio's render callback delivers samples on its own thread into rec_buf, and the main-thread timer polls the snapshot.

file [lotus/lotus_vantage_audio.rye](../../lotus/lotus_vantage_audio.rye) added lotus_record_read_buf FFI export, extended selftest to 14 claims
file [vantage/include/vantage_lotus_audio.h](../../vantage/include/vantage_lotus_audio.h) added lotus_record_read_buf declaration
file [terrarium/app/main.swift](../../terrarium/app/main.swift) added audioWaveformView and audioRecordTimer properties
file [terrarium/app/TabSetup.swift](../../terrarium/app/TabSetup.swift) stored waveformView reference in focusAudio, added startRecordWaveformTimer/stopRecordWaveformTimer/pollRecordingBuffer methods, wired timer start on record and stop on record-stop
file [active-tablecloth/date/202611/00/20261107-224400_lotus-macos-native-rebuild/CHECKLIST.md](../../active-tablecloth/date/202611/00/20261107-224400_lotus-macos-native-rebuild/CHECKLIST.md) marked Movement 7 PROVEN, Phase 2 at 2/5
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.131 to 60.132, updated description
file [README.md](../../README.md) fascia badge 60.131 to 60.132

recommend keep-going -- next: Movement 8 audio utilities (sample format helpers, buffer management, WAV export through FFI bridge)
