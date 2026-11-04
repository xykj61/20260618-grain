format session-log-v1
stamp 20261104.051355
session-header 20261104/20261104-045214_ssh-decouple-and-nib-amend.kyri.md
voice Kyri
title Orbit 20 -- seven-witness comptime tidy with str_repeat quota fix
prompt kg -- continue orbit tidy work
think Scanned the 49 remaining witnesses carrying comptime decl-walking blocks. Identified seven non-lowerer witnesses: expr, face_lit, nest_type, refusal, text_floor, tokens, truth_semantics. Six had the standard single-loop pattern; refusal_witness had TWO loops (walking both refusal and zig_ident imports).
think Removed all seven comptime blocks and bumped witness_version to 20261104.051355 in each.
think refusal_witness failed to build -- str_repeat("c", 1025) exceeds Zig's default 1000 backwards-branch comptime quota. Verified this is a pre-existing red: the witness also fails at HEAD before my edits. The str_repeat utility (tally/str_repeat.rye, symlinked as glow/tally_str_repeat.rye) lacked a @setEvalBranchQuota call. Fixed by adding @setEvalBranchQuota(n + 100) inside the comptime block, which raises the quota only when the loop count exceeds the default 1000.
think After the quota fix, all seven witnesses built and ran GREEN: expr (21), face_lit (7), nest_type (127), refusal (23), text_floor (4), tokens (21), truth_semantics (6) -- 209 GREEN lines total.
obs The str_repeat quota fix repairs a pre-existing build failure surfaced by the tidy. The refusal_witness binary on disk was stale from before the Zig 0.16 to 0.17 molt-breach that introduced str_repeat as a replacement for the removed ** operator.
obs Fascia moves 60.049 to 60.050 -- both construction/ITINERARY.md and root README.md updated.
file [glow/expr_witness.rye](../../glow/expr_witness.rye) comptime block removed, witness_version bumped
file [glow/face_lit_witness.rye](../../glow/face_lit_witness.rye) comptime block removed, witness_version bumped
file [glow/nest_type_witness.rye](../../glow/nest_type_witness.rye) comptime block removed, witness_version bumped
file [glow/refusal_witness.rye](../../glow/refusal_witness.rye) comptime block removed (two loops -- refusal and zig_ident), witness_version bumped
file [glow/text_floor_witness.rye](../../glow/text_floor_witness.rye) comptime block removed, witness_version bumped
file [glow/tokens_witness.rye](../../glow/tokens_witness.rye) comptime block removed, witness_version bumped
file [glow/truth_semantics_witness.rye](../../glow/truth_semantics_witness.rye) comptime block removed, witness_version bumped
file [tally/str_repeat.rye](../../tally/str_repeat.rye) added @setEvalBranchQuota(n + 100) to fix pre-existing comptime quota exceeded
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.049 to 60.050, git nib carried forward
file [README.md](../../README.md) fascia badge 60.049 to 60.050
recommend keep-going -- 42 witnesses with comptime blocks remain; next batch is rune_* and lower_* families
