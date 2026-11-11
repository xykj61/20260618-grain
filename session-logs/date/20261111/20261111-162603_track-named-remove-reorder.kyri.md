format session-log-v1
stamp 20261111.162603
editor Claude Code CLI
provider Anthropic
product Claude Code
role repository agent
modality text
model claude-opus-4-6
model_status active runtime
configured_model claude-sonnet-4-6
voice Kyri
title track.rye -- named tracks, remove, reorder
prompt Keaton said kg after the Radiant pass; Lotus pause lifted; resume Quest 1.2 Orbit 4 -- the data model half: named tracks, add/remove/reorder
think Orbit 4 checklist lines 41-44 ask four things: session model holds N named tracks, add/remove/reorder, Brushstroke draws a track list, SLC gate two tracks play simultaneously. The data model is the first two.
think read track.rye (350 lines, 8 selftest cases GREEN) -- Session holds max_tracks=8 Track structs, add_track takes (session, clip, at_ms). Extending Track with a name field and adding remove/swap is the task.
think API stability: 12 files import track.rye, roughly 40+ call sites of add_track all using the 3-arg form. Adding a name argument would break every one. Keep add_track stable, add name_track as a separate operation, give Track's new fields zero defaults so existing initializers work unchanged.
think added max_track_name=32 (u32 bound), extended TrackError with BadIndex, extended Track with name:[max_track_name]u8 and name_len:u32 both defaulting to zero
think four new public functions: name_track (bounded copy with intCast at usize seam), track_name (returns slice), remove_track (shift-compact with copy_disjoint), swap_tracks (std.mem.swap)
think each new function carries >=2 invariant assertions per TAME, uses named errors with try, intCast at the usize seam with a preceding bound assert
think added 6 new selftest cases (8-13): name read-back, remove-shift, swap, remove-BadIndex refusal, swap-BadIndex refusal, name truncation at max_track_name
obs all 13 selftest cases GREEN on metal. Version bumped to 20261111.160000. Zero changes to add_track signature -- all 40+ existing call sites across 12 importing files work unchanged.
obs Orbit 4 data model half complete. Two requirements remain: Brushstroke track list visual (lotus_window.rye) and SLC gate proof (two tracks through coreaudio.rye).
[file](../../lotus/track.rye) extended Track with name fields, added name_track/track_name/remove_track/swap_tracks, 6 new selftest cases, version bumped
recommend keep-going -- commit and send the data model, then Brushstroke track list visual in lotus_window.rye
