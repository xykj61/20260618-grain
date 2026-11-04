format session-log-v1
stamp 20261104.032416
editor Claude Code
provider Anthropic
product Claude Code
role repository voice
modality text
model claude-opus-4-6
model_status active runtime
voice Kyri
title Orbit 15 -- gate dispatch for calln mix/sub/mul
prompt kg -- continue Glow lowering orbits

think Orbit 15 extends the named-arg calln lowerer with the same dynamic gate dispatch pattern. Three gates -- mix (+%), sub (-%), mul (*%) -- with compute_expect and gate_op functions. The struct shape (Sample { left, right }) stays fixed; only the operator changes per gate. BadNames check retained since the demo still enforces left/right field names.
think Created two new .glow gen programs for sub and mul gates. Rewrote the Rye witness to test all three gates with six welcome/unwelcome checks, assert_contains helper, six cache file writes, and three .glow reads. Rewrote the rishi witness to build and run all six emitted binaries. Extended the desk witness with call-named-sub and call-named-mul pipeline blocks. Fixed em dash to ASCII in the lowerer format string.
obs GREEN on metal -- all six binaries (mix/sub/mul welcome and unwelcome) build and run with correct exit codes. Fascia 60.044 -> 60.045.

file [glow/lower_calln.rye](../../glow/lower_calln.rye) dynamic gate dispatch with compute_expect and gate_op for mix/sub/mul
file [glow/lower_calln_witness.rye](../../glow/lower_calln_witness.rye) full rewrite -- tests three gates, six cache files, three .glow reads
file [tools/g/glow_lower_calln_witness.rish](../../tools/g/glow_lower_calln_witness.rish) full rewrite -- six welcome/unwelcome binary builds
file [tools/g/glow_run_desk_witness.rish](../../tools/g/glow_run_desk_witness.rish) added call-named-sub and call-named-mul pipeline blocks
file [glow/gen/c/call-named-sub.glow](../../glow/gen/c/call-named-sub.glow) new named-arg sub gate demo program
file [glow/gen/c/call-named-mul.glow](../../glow/gen/c/call-named-mul.glow) new named-arg mul gate demo program
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.044 -> 60.045
file [README.md](../../README.md) fascia badge 60.044 -> 60.045

recommend keep-going -- Orbit 16 opens the next pipeline stage or deepens an existing surface
