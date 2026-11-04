format session-log-v1
stamp 20261104.103121
session-header [20261104-045214_ssh-decouple-and-nib-amend.kyri.md](20261104-045214_ssh-decouple-and-nib-amend.kyri.md)
voice Kyri
title Orbit 2 scoping -- Weave seam check-in
prompt kg -- continue to Orbit 2 (record, meter, and monitor)
think CHECKLIST says "CoreAudio input capture to a Weave append" but the SLC gate is "record a take, see the meter move, hear playback of what was just recorded"
think Mantra's Weave (mantra/src/weave.rye) is a text-stream CRDT -- lines with identity, generation, merge. The DAW design says every action is a Weave event and state is a fold over the log
think full Weave integration for audio means: audio blobs stored separately, Weave events referencing them, event-sourced session state. That is significant architecture beyond the SLC gate
think the pragmatic scope: CoreAudio input capture to a Clip (timeline.rye), meter reads live, monitor routes input to output, existing transport plays back the recorded clip
think this meets the SLC gate and the Weave event-log wrapper can arrive at Quest 1.2 (Orbit 4-7) when multi-track and undo need it
think coreaudio_c.rye needs additions for input: AudioUnitGetProperty, kAudioOutputUnitProperty_EnableIO (property 21), AUHAL subtype (0x6168616c 'ahal')
think the existing coreaudio.rye is output-only (DefaultOutput subtype). Input capture needs AUHAL which supports both I/O
obs Orbit 2 crosses a module seam -- adding CoreAudio input, a recording model, and a monitor path. The CHECKLIST names Weave explicitly, so the scoping decision (Clip now, Weave wrapper later) needs Keaton's word
obs no weave, record, input, or capture modules exist in lotus/ yet. stream.rye is a byte FIFO for framed audio, session.rye is a sealed project document -- neither is the recording target
obs meter.rye, normalize.rye, stereo_meter.rye, stereo_normalize.rye all exist and are proven. The new work is input capture, the recording buffer, and the monitor path
[mantra/src/weave.rye](../../mantra/src/weave.rye) read -- text-stream CRDT, append-only history with merge
[lotus/stream.rye](../../lotus/stream.rye) read -- byte FIFO for framed audio, not the recording target
[lotus/session.rye](../../lotus/session.rye) read -- sealed project document (rack + cue sheet), not the recording target
[lotus/stereo_meter.rye](../../lotus/stereo_meter.rye) read -- two-channel lockstep meter, already proven
[tablecloth/20261103-005948_lotus-working-studio/CHECKLIST.md](../../tablecloth/20261103-005948_lotus-working-studio/CHECKLIST.md) read -- Orbit 2 scope and SLC gate
recommend check in (Claude) -- the CHECKLIST names Weave explicitly; building Clip-first with Weave wrapper later is the pragmatic scope, yet it is a design decision that needs Keaton's word before building
