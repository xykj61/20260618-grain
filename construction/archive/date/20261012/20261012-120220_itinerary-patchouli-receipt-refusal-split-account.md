# ITINERARY account -- Patchouli: receipt refusal witness main split under seventy

**Stamp:** `20261012.120220` (EDT) -- **Lane:** Patchouli (`mantra/`, `tally/`) -- **Session log:** `session-logs/date/20261012/20261012-120220_patchouli-receipt-refusal-split.kyri`

**Mechanism.** `pub fn main` in `mantra/src/receipt_refusal_witness.rye` stood at 78 lines. It now calls three helpers in the original order: `claim_admission_refusals(fact)` (the field-by-field admission refusals), `claim_log_refusals(fact)` (the record's own refusals, marked `!void` because it appends), and `claim_render_refusals()` (the published-line bounds). `main` keeps the fixture, the three calls, and the GREEN line, unchanged byte for byte.

**Proof.** `rishi/bin/rishi run tools/t/tally_receipt_refusal_witness.rish` reads GREEN on metal: the clean leg reaches its GREEN claim, and all five planted drifts are refused, `legs=11 legs_expected=11 control_failed=0`. A fresh awk measure reads the longest function in the file at 64 lines, the `agrees` helper's neighbours still under seventy.

**Next candidate.** `run_selftest` in `mantra/bolt_apply_step_witness.rye`, at 72 lines by the same measure. Measured fresh; re-run the measurement rather than trusting this line.

**YOURS:** none on this lap. The held red `ContinuityFact.stamp` (use-after-return) and the two `%840` rulings stay on the card as the previous account left them.
