format session-log-v1
stamp 20260815.114348
editor Zed
model Fable 5
voice Kyri
host cloud pier — Eastern (EDT) time convention
title lotus-audio — Lotus's stereo reverb early/late balance, the first reflections against the diffuse wash per ear
prompt recur loop — continue the Lotus/lotus-audio ladder the Long Return Lila, each finished rung its own signed round pushed to origin and xykj61, stop at the custody gates
think lotus-audio gave the mono reverb its early/late balance; the ladder always closes the mono/stereo pair before opening a fresh axis, so the thin twin is stereo_reverb_early_late — the same crossfade over both channels of a StereoClip, one shared early bank/room/balance, the image held. Mirrored lotus-audio (stereo_reverb_mix) exactly, swapping the dry snapshot for the EARLY reflections (lotus-audio multitap_ms per channel on a copy) and the wet for the LATE preset (lotus-audio stereo_reverb_preset in place).
think No stereo timed multi-tap exists (only lotus-audio stereo_multitap, index-named), so the early half runs lotus-audio's proven multitap_ms once per channel on the copy — the mono discipline twice, exactly lotus-audio's own argument, each channel reading its own dry, no cross-channel snapshot. StereoReverbEarlyLateError = multitap_time.MultitapTimeError || stereo_reverb_preset.StereoReverbPresetError || BadBalance; the early multi-tap on the copy and the late preset's precheck keep the master untouched on any refusal (atomic).
obs Witness GREEN on the first metal pass — no RED to book. Six laws on a 1024-sample bench with two distinct impulses: the early edge per channel equals multitap_ms over the room's published early bank byte for byte; the late edge equals stereo_reverb_preset byte for byte on both channels; a half balance differs from both edges and each sample of each channel is the honest weighted average, byte for byte; the image is held (centred identical, stereo distinct — no crossing); the channels leave balanced and silence stays silence; faults forward atomic (BadBalance, DurationTooLong, BadRange, both channels untouched). lotus-audio stereo preset, lotus-audio multi-tap, and lotus-audio mono early/late all re-run GREEN beside it; TAME bans clean, width exit 0. The early/late axis now stands whole for mono and stereo.
loom witness=ales_stereo_reverb_early_late_witness selftest=GREEN laws=6 channels=2 max_clip=4096 bench_samples=1024 early_banks=3 balance=1/2
file active-designing/20260815-114348_fill-ales207-lotus-stereo-reverb-early-late.md the self-approved design round naming the crux, shape, and six laws
file lotus/stereo_reverb_early_late.rye the rung — the stereo early/late crossfade, lotus-audio multi-tap early per ear over a copy against lotus-audio late in place, blended per channel
file tools/ales_stereo_reverb_early_late_witness.rish the witness proving six laws and re-proving lotus-audio/lotus-audio/lotus-audio green beside it
recommend keep-going — the early/late axis is whole for mono and stereo; the next crux is a fresh reverb axis — width (the stereo spread of the tail) or freeze (an infinite-hold sustain).
