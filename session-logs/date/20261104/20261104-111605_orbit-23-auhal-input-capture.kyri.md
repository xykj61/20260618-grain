format session-log-v1
stamp 20261104.111605
session-header [20261104-045214_ssh-decouple-and-nib-amend.kyri.md](20261104-045214_ssh-decouple-and-nib-amend.kyri.md)
voice Kyri
title Orbit 23 -- AUHAL input capture with live metering, GREEN on metal
prompt kg -- continue from context summary, apply final callback registration edit and build
think prior session applied 6 of 7 edits to fix zero-callback red -- AUHAL render callback on output bus 0 never fires without an explicit output device; the fix switches to input callback (property 2005) on global scope
think applied the final edit: callback registration changed from au_prop_set_render_callback on au_scope_input to au_prop_set_input_callback on au_scope_global
think built and ran -- still zero callbacks. The input callback also needs the default input device assigned explicitly, because AUHAL has no implicit device assignment unlike DefaultOutput
think added AudioObjectGetPropertyData extern, AudioObjectPropertyAddress struct, and five constants (audio_object_system_object, audio_hardware_prop_default_input_device, audio_object_prop_scope_global, audio_object_prop_element_main, au_prop_current_device) to coreaudio_c.rye
think added device lookup and assignment block in record.rye open() -- AudioObjectGetPropertyData reads the default input device ID, AudioUnitSetProperty assigns it to the AUHAL unit on global scope
think built with -framework CoreAudio alongside -framework AudioToolbox for AudioObjectGetPropertyData
think GREEN: 9 callbacks, 4608 samples, meter count=4608 peak=0 (silence -- no one speaking), to_clip 4096 (truncated to max_clip), playback 5 callbacks, double-open refused
obs the root cause was two missing pieces: (1) AUHAL needs kAudioOutputUnitProperty_SetInputCallback (2005) rather than kAudioUnitProperty_SetRenderCallback (23) for input-only capture, and (2) AUHAL needs the default input device assigned explicitly via kAudioOutputUnitProperty_CurrentDevice (2000) -- without both, the callback never fires
obs peak=0 is correct for silence during an automated selftest -- the meter accumulation path is proven by count matching recorded samples
obs the build needs both -framework AudioToolbox (for AudioUnit functions) and -framework CoreAudio (for AudioObjectGetPropertyData)
[lotus/coreaudio_c.rye](../../lotus/coreaudio_c.rye) added AudioObjectGetPropertyData extern, AudioObjectPropertyAddress struct, au_prop_current_device, audio_object constants
[lotus/record.rye](../../lotus/record.rye) switched to input callback (2005), added device lookup and assignment, callback allocates own stack buffer via AudioUnitRender on bus 1
[construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.052 to 60.053, Orbit 23 added
[README.md](../../README.md) fascia badge 60.052 to 60.053
loom witness=record_selftest callbacks=9 samples=4608 meter_count=4608 peak=0 playback_callbacks=5
orbit round 6 Virgo -- let Earth's verb color the keystone: a bound placed on every allocation
recommend kg -- Orbit 2 SLC gate is "record a take, see the meter move, hear playback of what was just recorded" -- the core capture engine is GREEN; next is wiring the selftest to record actual audio (longer capture with audible input) and verifying the meter moves with real signal
