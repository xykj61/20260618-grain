format session-log-v1
stamp 20261111.143653
editor Claude Code
provider Anthropic
product Claude Code
role repository
modality text
model claude-opus-4-6
model_status active runtime
voice Kyri
title treap and persistent vector research for Tablecloth internals
prompt Keaton approved sequence: (1) Glow language journey (already complete), (2) treap/persistent-vector research, (3) Colloquium waits
think Tablecloth's vector store runs exact brute-force k-nearest -- correct at current scale, and the question is what structure it grows toward
think two candidates from the ancestry: treaps (Urbit's native map/set via Aragon-Seidel 1989) and persistent vectors (Clojure's immutable collections via Bagwell 2001)
think treaps give O(log n) ordered operations, structural sharing, split/merge -- right for the naming catalog (key-value map with prefix queries), wrong for the embedding matrix (scattered nodes, poor cache locality for dot-product inner loop)
think persistent vectors give O(log32 n) effectively-O(1) operations, contiguous 32-element leaves, structural sharing -- right for the record store (scan reads leaves in order, append is O(1), swap-and-pop handles removal)
think the two-structure answer: treap for the naming layer, persistent vector for the record store, snapshot of the whole database is two root pointers
obs this is a bounded study lap -- ideas cross the clean-room boundary in words, never in code
obs the brute-force scan stays at current scale; the persistent vector's leaf layout keeps it nearly as fast as a flat array
obs implementation and benchmarking are separate laps, each bounded by TAME
[file](../../active-designing/date/20261111/20261111-143331_treap-persistent-vector-tablecloth-internals.md) design essay evaluating treaps and persistent vectors for Tablecloth's internal data structures
recommend check-in (Claude) -- Colloquium awaits Keaton's read of the automobile-patent bill; Lotus awaits Keaton's word to unpause; treap research complete as a vision document
