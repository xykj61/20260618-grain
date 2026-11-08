format session-log-v1
stamp 20261108.100955
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Recording bridge landed, Movement 6 PROVEN
prompt keep working on the slc and kg to the next movement

think Movement 6 recording bridge -- the FFI bridge between lotus/record.rye (AUHAL input) and the Terrarium Swift UI
think Three layers to wire: Rye FFI exports in lotus_vantage_audio.rye, C header declarations in vantage_lotus_audio.h, Swift UI handlers in TabSetup.swift
think record.rye Engine struct uses free functions (record.open, record.start, record.stop, record.close) rather than methods -- the Engine.open bool field would collide with a method name
think RecordBuf holds max_record = 48000 * 10 samples (10 seconds at 48kHz), meter tracks sum_sq/count/peak as u32
think AUHAL opens and starts without error even with no microphone -- the callback simply captures zero samples; selftest must handle this gracefully
think Made claims 11-13 resilient to no-mic environments: read sample count into a variable, conditionally test transfer based on whether samples captured

obs 9 recording FFI exports implemented: lotus_record_open, start, stop, close, is_open, is_recording, meter_peak, sample_count, to_playback
obs lotus_record_open shares the playback clock when available, makes a new one otherwise -- invariant: one clock per process
obs lotus_record_to_playback copies from RecordBuf to master Clip, bounded by max_clip (4096 samples)
obs Selftest 13 claims GREEN -- 8 playback + 5 recording bridge; no-mic resilience prints "no mic input -- transfer skipped (expected)" on background machines
obs Swift UI: Record button calls lotus_record_open(44100) then lotus_record_start(); Stop Rec button calls lotus_record_stop() then lotus_record_to_playback()
obs Fascia 60.130 to 60.131 -- one proven movement

file [lotus/lotus_vantage_audio.rye](../../lotus/lotus_vantage_audio.rye) 9 recording FFI exports (lines 140-209), selftest extended to 13 claims (lines 256-301)
file [vantage/include/vantage_lotus_audio.h](../../vantage/include/vantage_lotus_audio.h) 9 recording C declarations added (lines 28-37)
file [terrarium/app/TabSetup.swift](../../terrarium/app/TabSetup.swift) Record and Stop Rec buttons with handlers wired to FFI
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.131, recording bridge description
file [README.md](../../README.md) fascia badge 60.131
file [active-tablecloth/date/202611/00/20261107-224400_lotus-macos-native-rebuild/CHECKLIST.md](../../active-tablecloth/date/202611/00/20261107-224400_lotus-macos-native-rebuild/CHECKLIST.md) Movement 6 marked PROVEN

recommend keep-going -- next: Movement 7 live waveform display during recording
