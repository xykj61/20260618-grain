format session-log-v1
stamp 20261106.112851
session-header [20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md](20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md)
voice Kyri
title Query by subject landed -- Movement 37 GREEN
prompt kg resume -- continue the Mantrapod RV64G journey at Quest 2.3, Movement 37
think Movement 37 is query by subject -- "Show me everything about tomatoes"
think query_by_subject scans all 9 transactions via str_eq byte-by-byte comparison against a subject string
think QueryResult struct holds up to 9 indices into the transactions array, with a count field -- same pattern as verb module
think initial build produced Mantra hash mismatch: 0xf6d9677e instead of expected 0xe9cf083f
think root cause: MantraLog.append had a completely different hash chain algorithm -- the subject module used a full Djb2 hash computation over previous state bytes concatenated with fact bytes, while the verb module uses the simple multiply-accumulate self.state_hash = self.state_hash *% 31 +% sig
think fix: replaced the elaborate Djb2-over-bytes block (lines 177-191) with the simple one-liner matching the verb module
think after fix: 19/19 ALL PROOFS PASSED, hash matches 0xe9cf083f
obs the dimeroll module pattern is solid -- the hash mismatch was a copy divergence rather than a design fault. The simple multiply-accumulate hash chain is the canonical algorithm across all dimeroll modules sharing the 9-transaction dataset.
rota none -- pure build, no rota this movement
orbit round 6 Virgo -- the earth verb, let it stop what must stop
file [terrarium/src/dimeroll_query_subject.rye](../../terrarium/src/dimeroll_query_subject.rye) freestanding RV64G module -- QueryResult struct, query_by_subject with str_eq, 19 proofs
file [terrarium/dimeroll_query_subject_witness.rish](../../terrarium/dimeroll_query_subject_witness.rish) witness -- build, QEMU 19-proof run, GREEN
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Movement 37 marked PROVEN
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.119 to 60.120, Movement 37 appended
recommend keep-going -- next: Movement 38, Query by date range, filter transactions by date bounds across the Mantra log
