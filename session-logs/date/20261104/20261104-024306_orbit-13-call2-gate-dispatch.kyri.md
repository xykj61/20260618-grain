format session-log-v1
stamp 20261104.024306
editor Claude Code
provider Anthropic
product Claude Code
role repository agent
modality text
model claude-opus-4-6
model_status active runtime
voice Kyri
title Orbit 13 -- call2 gate dispatch for sub and mul
prompt kg
think Orbit 13 mirrors Orbit 12's compose2 work onto call2. The lowerer had hard-coded add-only dispatch; now compute_expect and gate_op give it content-based routing to add/sub/mul -- same pattern, parallel module.
think Two new .glow programs exercise the sub and mul gates through the full pipeline. The Rye witness removed the comptime decl-walking block and grew to test all three gates with six welcome/unwelcome lowering checks.
think The rishi witness builds and runs six welcome/unwelcome binaries (add/sub/mul x welcome/unwelcome). The desk witness adds call-two-sub and call-two-mul pipeline tests.
obs lower_call2 now dispatches identically to lower_compose2 -- compute_expect returns the expected result per gate, gate_op returns the Rye operator string. Both refuse UnknownGate for anything outside add/sub/mul.
obs Fascia 60.042 -> 60.043.
[file](../../glow/lower_call2.rye) compute_expect and gate_op replace hard-coded add constant and gate check
[file](../../glow/lower_call2_witness.rye) tests add/sub/mul parse, lower, welcome/unwelcome, UnknownGate refusal
[file](../../glow/gen/c/call-two-sub.glow) new program -- two-arg call sub gate
[file](../../glow/gen/c/call-two-mul.glow) new program -- two-arg call mul gate
[file](../../tools/g/glow_lower_call2_witness.rish) builds/runs six welcome/unwelcome binaries
[file](../../tools/g/glow_run_desk_witness.rish) adds call-two-sub and call-two-mul pipeline tests
[file](../../README.md) fascia 60.042 -> 60.043
[file](../../construction/ITINERARY.md) fascia 60.042 -> 60.043, adds call2 gate dispatch
orbit round 13 Taurus -- the keystone
recommend keep-going -- Orbit 14 next; call2 and compose2 now share the same three-gate dispatch pattern
