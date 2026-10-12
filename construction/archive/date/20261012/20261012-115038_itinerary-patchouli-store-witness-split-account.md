# ITINERARY -- Patchouli store witness split, account (shelved whole)

**Stamp:** `20261012.115038` (EDT) -- **Lane:** Patchouli (mantra/ and tally/)
**Status:** Account, shelved whole from the card by the writer-sheds rule. Living
pointer stays on `construction/ITINERARY.md` beside its YOURS lines.

## The card block as it stood before this lap (kept verbatim)

**PATCHOULI -- THE LANE'S ACCOUNTS, SHELVED WHOLE.** [Account shelved](archive/date/20261012/20261012-081818_itinerary-patchouli-head-record-split-account.md) -- `snapshot_export.rye`'s head-record parse split under the 70-line bound, six snapshot witnesses GREEN (log `20261012.081818`). **YOURS:** a held red, not booked (the pin reads 65,532 of 65,536, so no row can enter): `ContinuityFact.stamp` returns a slice into a local buffer, a use-after-return shape the split kept unchanged. The fix changes a public struct type, so it waits on your word. The family queue reads empty again on `20261012` (log `20261012.045759`). **YOURS:** two rulings, both gating `%840` (`tally/kumara.rye:36`, legacy `sign` under `catch unreachable`, reproduced `20261010.174431`). The ledger is deadlocked (`reds_pin_capacity_scan.sh`: `pin_deadlocked=1`, `rows_that_fit=0`, no foldable row), so the row waits off the pin. Then: the legacy `sign` seam (`amphora/`, `aurora/`, `comlink/` callers) to `sign_checked`, or keep it.

## This lap -- the store witness main, split under seventy

`mantra/src/store_witness.rye` main ran 125 lines, the longest function the lane's
witness mains carried. It now calls three claim helpers, one per pen:

- `claim_blob_round_trip` -- claims 1 to 4 in pen `one`.
- `claim_ceiling_edges` -- claims 5 and 6 in pen `two`.
- `claim_head_states` -- claims 7 and 7b in pen `three`.

Each helper returns the pens it opened, and `main` sums them, so the three-pen postcondition
still reads the count the helpers return. Claim 8 and the closing GREEN line stay in `main`.
Claim 7 writes a well-formed 64-character HEAD name, since HEAD stores and returns the name it is
given and the claim never needed a real blob there.

Proven: `rishi/bin/rishi run tools/m/mantra_store_witness.rish` GREEN (eight claims, six breaks
caught), and the built binary runs GREEN on a fresh pen, printing nine claim lines and the summary.
The print strings were carried over unchanged and checked by reading the diff, not by a saved
before-and-after capture of the binary's output. The TAME style check reads nothing against the file. Re-run the guard rather than trusting this line.

**Next candidate, measured fresh rather than named by an earlier lap:** `receipt_refusal_witness`
at 78 lines (`mantra/src/receipt_refusal_witness.rye`). It is a witness main in the same lane.

No REDS row booked. No claim needed: no new instrument, no booked red taken.
