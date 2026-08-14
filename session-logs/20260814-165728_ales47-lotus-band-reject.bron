format session-log-v1
stamp 20260814.165728
editor Zed
model Fable 5
voice Kyri
host Ubuntu cloud pier — Eastern (EDT) time convention
title lotus-audio — Lotus's band-reject (notch): the EQ primitive pair made whole
prompt keep taking the next the Long Return Lila Lotus lap, self-approve the design round, send each finished increment, stop only at the custody gates in REMEMBER
think After landing lotus-audio the band-pass (keep the middle), the Long Return crux is its complement — the band-reject/notch (keep the edges, drop the middle). Together they are the EQ primitive pair; landing both makes that foundation whole.
think Design: where the band-pass is a CASCADE (high-pass into low-pass), the band-reject is a PARALLEL sum — a low-pass keeps the lows, a high-pass keeps the highs, added and clamped once. This is lotus-audio the shelf's own shape (scale two bands and sum, clamp once) with both retained bands at unity — no new arithmetic.
think Chosen from-silence like the shelf/stack (whole-span EQ shape), which also yields the elegant crux: equal cutoffs → low_pass(c) + high_pass(c) = x exactly (lotus-audio's complement law), so a zero-width reject band is the identity byte-for-byte. The band-pass was carried because it isolates a region; the notch shapes a span, so from-silence matches its kin.
obs Beautiful contrast recorded as a clause: a constant input — the band-pass drove it to zero (rejects DC), the notch settles it to itself (keeps DC). The pair's DC behaviour is exactly opposite, and each is proven.
obs Reused tone.precheck (added in lotus-audio) to check both cutoffs before either scratch is filled — no half-filtered span. Two scratch Clips (low, high), each bounded by the shared timeline.max_clip, asserted count <= buf.len.
obs GREEN on the first build across six clauses; lotus-audio band-pass selftest re-run stays GREEN, so the pair is whole and proven together. TAME bans clean, zero-assert ratchet unchanged.
loom witness=ales_notch_witness green=1 clauses=6 rungs_reused=3 new_files=3 pair=band-pass+band-reject
file lotus/notch.rye the band-reject — parallel low-pass + high-pass, summed and clamped once, equal cutoffs the identity
file tools/ales_notch_witness.rish builds, runs the selftest, asserts GREEN ales-notch, re-proves lotus-audio band-pass green
file active-designing/20260814-165728_fill-ales47-lotus-band-reject.md the self-approved design round for lotus-audio
file lotus/README.md front door synced — the lotus-audio band-reject sentence, the EQ primitive pair named whole
recommend keep-going next Lotus rung can sweep the notch's cutoffs, gain the retained bands (a parametric bell), or name the two edges in hertz through a real time base — all agent-doable, no custody gate reached
