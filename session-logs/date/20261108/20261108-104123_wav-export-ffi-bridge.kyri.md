format session-log-v1
stamp 20261108.104123
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title WAV export through FFI bridge -- Movement 8 PROVEN
prompt Continue SLC -- land Movement 8 (audio utilities, WAV export through FFI bridge)

think Movement 8 SLC gate is "export a recorded take as WAV." The bridge already has rec_buf with recorded i16 samples, and lotus/wav.rye has a proven encoder. Need a new FFI export that calls wav.encode on the buffer and returns byte length, plus Swift UI with NSSavePanel for the file save.
think Added lotus_record_export_wav to lotus/lotus_vantage_audio.rye -- reads sample rate from shared clock (fallback 44100), slices rec_buf to its length, calls wav.encode into caller-provided output buffer, returns byte length or 0 on error. No allocation crosses the boundary.
think Extended selftest from 14 to 15 claims -- new claim 14 tests WAV export (RIFF header check when samples > 0, returns 0 on empty buffer), old claim 14 (close) renumbered to 15.
think Swift side: added "Export WAV" button in focusAudio() below Record/Stop Rec buttons. Handler audioExportWavPressed reads sample count, allocates buffer sized to 44 + count * 2, calls lotus_record_export_wav through FFI, opens NSSavePanel with .wav content type, writes Data slice to chosen URL. Status label shows byte count on success or descriptive message on empty/cancel/failure.
obs Bridge selftest 15 claims GREEN. Terrarium build GREEN. The WAV export completes the audio utilities gate -- a person can now record audio through the Station and export it as a standard WAV file via the native macOS save dialog.

file [lotus/lotus_vantage_audio.rye](../../lotus/lotus_vantage_audio.rye) added lotus_record_export_wav FFI export calling wav.encode, extended selftest to 15 claims
file [vantage/include/vantage_lotus_audio.h](../../vantage/include/vantage_lotus_audio.h) added lotus_record_export_wav declaration
file [terrarium/app/TabSetup.swift](../../terrarium/app/TabSetup.swift) added Export WAV button with NSSavePanel handler, centered below record buttons
file [active-tablecloth/date/202611/00/20261107-224400_lotus-macos-native-rebuild/CHECKLIST.md](../../active-tablecloth/date/202611/00/20261107-224400_lotus-macos-native-rebuild/CHECKLIST.md) marked Movement 8 PROVEN, Phase 2 at 3/5
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.132 to 60.133, updated description
file [README.md](../../README.md) fascia badge 60.132 to 60.133

recommend keep-going -- next: Movement 9 audio menu items (audio-specific menu actions wired into MenuActions.swift)
