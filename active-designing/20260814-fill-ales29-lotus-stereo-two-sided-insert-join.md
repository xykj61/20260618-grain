# lotus-audio -- Lotus's stereo two-sided insert-join, both channels both seams in lockstep

**Stamp:** `20260814.143348` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after lotus-audio
**Waymark:** lotus-audio - rung lotus-audio
**Kin:** [`lotus-audio -- the two-sided insert-join`](20260814-fill-ales28-lotus-two-sided-insert-join.md) - [`lotus-audio -- the stereo crossfade join`](20260814-fill-ales27-lotus-stereo-crossfade-join.md) - [`lotus/stereo_insert_join.rye`](../lotus/stereo_insert_join.rye) - [`lotus/insert_join.rye`](../lotus/insert_join.rye) (lotus-audio, `insert_join` run once per channel) - [`lotus/pan.rye`](../lotus/pan.rye) (lotus-audio, the `StereoClip` whose channels share one length)

---

## Why this round

lotus-audio gave a mono `Clip` the trailing-seam law: a span dropped into the **middle** of a clip has two seams, not one, and `insert_join` crosses both equal-power (lotus-audio's `join` applied once per edge) so neither boundary steps into a click. Yet a Lotus master is a `StereoClip` -- two Clips heard together -- and a keeper inserts a stereo span, not one channel. The graft (lotus-audio), clipboard (lotus-audio), and the stereo append-join (lotus-audio) already carried the copy, the paste, and the one-sided join into stereo, keeping both channels in lockstep; the two-sided insert owes the same.

Lila and the Long Return: the stereo two-sided insert is the highest-Lindy next move -- it makes the trailing-seam law usable on the object a keeper actually edits -- and it reuses lotus-audio's `insert_join` whole over its public API, adding no new arithmetic and no new seam law. It stays wholly local, touching no gate. This is the exact twin of the move lotus-audio made for the append-join.

## The one crux this rung fixes

**A stereo two-sided insert runs the same trailing-seam law on both channels and grows them by the same shared count -- or touches neither.** Two facts make this exact:

- **The seam law is per-channel, the lockstep is shared.** Each channel is two-sided-inserted at the same `at`, `lead`, and `trail`, so each carries its own audio through its own two equal-power seams while both end one length (`clip + span - lead - trail`).
- **Atomicity from values-independence.** A `StereoClip`'s two channels are always one length (lotus-audio's invariant), and a stereo span is one length (the two incoming heads must match, refused `BadRange` otherwise). Every one of lotus-audio's guards -- the past-the-master `at`, the `lead`/`trail` widths, the overlap-under-two check, the overflow -- depends **only** on the shared length and the shared span dimensions, never on a sample's value. So `insert_join` on the left succeeds **if and only if** it succeeds on the right: a refused insert refuses on the first channel, atomically (lotus-audio's scratch build leaves that channel untouched on its own refusal), before the second is ever called, and a legal insert lands in both. This is the "capacity checked first" discipline the graft, clipboard, and stereo join already keep, made airtight by the fact that no guard reads audio.

## The shape

`lotus/stereo_insert_join.rye`:

- `insert_join_stereo(master, at, ins_left, ins_right, lead, trail)` -- insert a stereo span into a stereo master at `at`, crossing both seams of both channels in lockstep. Refuses `BadRange` when the two incoming channels differ in length, or on any of lotus-audio's own per-seam refusals (a past-the-master `at`, a `lead`/`trail` wider than its neighbour, an overlap under two); refuses `ClipFull` when the two-seam result would overflow. Applies lotus-audio's `insert_join.insert_join` to each channel; `try` carries the exact fault by name.

Errors are lotus-audio's `timeline.EditError` reused whole -- the stereo insert, like the mono insert it wraps, names no new fault.

## What the witness proves (GREEN on metal)

`tools/al/ales_stereo_insert_join_witness.rish`: a 10-sample master with a 5-sample span inserted at the middle over lead 2 / trail 2 lands both channels at length 11 and still aligned; each channel carries its own audio through its own two seams (left flowing 100->200, right 500->600) with its leading seam pure outgoing and trailing seam pure incoming; and an unequal-length span, a past-the-master position, a lead wider than the head, a trail wider than the following audio, and an overflow each refuse by name leaving both channels untouched and aligned. Purely local -- no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With the stereo two-sided insert, the trailing-seam law lands on the object a keeper works with -- the seam story `join` opened is closed for both mono and stereo. The next rung can offer a **multi-slot clipboard** (a named rack of held spans), let the **graft or paste** join rather than butt by default (an edit that crossfades its seams whenever they would step), or carry a held span across the lotus-audio audio **wire** as its own framed payload (a module seam, taken on Keaton's word). The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
