format session-log-v1
stamp 20260814.230352
editor Zed
model Fable 5
voice Kyri
host Ubuntu cloud pier — Eastern (EDT) time convention
title lotus-audio — Lotus's voiced/unvoiced/silent classifier, the first rung to fuse two analysis readers
prompt recur the itinerary the Long Return Lila; after lotus-audio sent, take the next agent-doable Lotus lap, self-approve, prove GREEN, send as its own signed round
think lotus-audio's doc named a voiced/unvoiced classifier reading the crossing count against the meter's RMS as a next crux. the Long Return it is the oldest decision in speech processing (every codec, VAD, pitch tracker); Lila it is the FIRST rung to compose two analysis families (lotus-audio zero_cross + lotus-audio meter) over one span, so it proves the readers cooperate rather than merely coexist.
think The whole correctness is composition: the verdict must equal a hand-built decision from count_crossings and a Meter's RMS over the same span — the classifier is the fusion rule, not a third reader that could disagree. Law 5 checks that across a grid of floors and splits.
think Ordering invariant: the energy gate reads FIRST (rms < floor → silent) before the crossing gate — a quiet many-crossing span is silence, not a fricative. Proved by law 4 (floor dominates) and law 9 (span discipline: loud samples outside the span, quiet inside, verdict silent).
think Build red: the Zig type system saw meter.feed's MeterFull and count_crossings' CountFull escaping ClassifyError; widened the union to zero_cross.ZeroCrossError || meter.MeterError || BadFloor — honest about what the composed readers may raise even though neither bound can fire on a span ≤ max_clip. Second build GREEN.
obs Read-only kept as the strongest span discipline — both features read, none write; law 6 checks the clip byte-for-byte unchanged.
obs Scope honest — a three-valued label over one span, not a phoneme or a probability; adaptive floors, time windowing, and a real sample rate are named as later rungs rather than faked.
loom witness=ales_voiced_witness green=1 laws=9 module_bytes=13k
file lotus/voiced.rye lotus-audio — the Verdict enum + classify(), fusing lotus-audio's crossing count and lotus-audio's RMS over one span, read-only.
file tools/ales_voiced_witness.rish the witness — builds, runs the selftest, asserts the GREEN line.
file active-designing/20260814-230352_fill-ales94-lotus-voiced-unvoiced-classifier.md the self-approved design read naming the fusion rule and nine laws.
recommend keep-going — the next Lotus crux the lotus-audio doc names (a windowed classifier sliding the decision across a clip, a voice-activity gate opening lotus-audio on the voiced verdict, or an adaptive floor), each its own self-approved round; no custody gate reached.
