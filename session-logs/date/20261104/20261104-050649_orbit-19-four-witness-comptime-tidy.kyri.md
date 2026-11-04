format session-log-v1
stamp 20261104.050649
session-header 20261104/20261104-045214_ssh-decouple-and-nib-amend.kyri.md
voice Kyri
title Orbit 19 -- four-witness comptime tidy
prompt kg -- continue orbit tidy work
think Scanned the four remaining lowerers with `_expect` constants: `lower_compose_core_add.rye`, `lower_compose_core_payload.rye`, `lower_shop_gate.rye`, `lower_shop_nest.rye`. All four have LIVE `_expect` constants used in the module body, so none can be removed -- only the witness comptime decl-walking blocks are tidy targets.
think All four witnesses carried the identical comptime block (lines 12-16 or 14-18): `comptime { for (@typeInfo(lower).@"struct".decls) |decl| { _ = &@field(lower, decl.name); } }` with the REDS %463/%470 comment. Removed the block and bumped `witness_version` to `20261104.050649` in each.
think Built and ran all four witnesses: compose-core-add (6 GREEN lines), compose-core-payload (18 GREEN lines), shop-gate (113 GREEN lines), shop-nest (107 GREEN lines). All four print their updated version string and close GREEN.
obs Unlike prior orbits where `_expect` constants were dead, all four here are live -- used in the lowerer's own runtime logic. The tidy is witness-only: removing the comptime decl-walking workaround that forced semantic analysis of every declaration.
obs Fascia moves `60.048` to `60.049` -- both `construction/ITINERARY.md` and root `README.md` updated.
file [glow/lower_compose_core_add_witness.rye](../../glow/lower_compose_core_add_witness.rye) comptime block removed, witness_version bumped
file [glow/lower_compose_core_payload_witness.rye](../../glow/lower_compose_core_payload_witness.rye) comptime block removed, witness_version bumped
file [glow/lower_shop_gate_witness.rye](../../glow/lower_shop_gate_witness.rye) comptime block removed, witness_version bumped
file [glow/lower_shop_nest_witness.rye](../../glow/lower_shop_nest_witness.rye) comptime block removed, witness_version bumped
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.048 to 60.049
file [README.md](../../README.md) fascia badge 60.048 to 60.049
recommend keep-going -- 26 witnesses with comptime blocks remain; the four lowerer _expect constants are all live and stay
