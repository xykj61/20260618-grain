# Fill lotus-audio — Lotus's cue sheet, sealed: the arrangement map verifies before it is trusted

**Stamp:** `20260814.153033` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — the next agent-doable Lotus rung, purely local
**Chapter:** the Six-Chapter double-seat, Chapter C thread (Lotus · the creative suite) · waymark **lotus-audio** · rung **lotus-audio**
**Stands on:** [`../lotus/cue_sheet.rye`](../lotus/cue_sheet.rye) (lotus-audio) · [`../lotus/rack_seal.rye`](../lotus/rack_seal.rye) (lotus-audio) · [`../lotus/markers.rye`](../lotus/markers.rye) (lotus-audio) · [`../lotus/wire.rye`](../lotus/wire.rye) (lotus-audio)

---

## Why this rung, and why now

lotus-audio gave the rack sheet an integrity gate: a saved rack verifies before it is trusted, so a flipped byte or a truncated tail is caught at the gate rather than parsed as some other rack. Yet a keeper saves **two** kinds of thing — the rack (the held audio spans) *and* the cue sheet (the arrangement map: where the intro, verse, chorus, and outro fall). lotus-audio lets that map travel as a `format lotus-cue-sheet-v1` record, yet it carries **no proof it arrived whole** — the same gap lotus-audio closed for the rack. A hand-edited marker position or a truncated map parses as *some other arrangement* without a word.

**the Long Return:** an integrity gate on a persistence format is durable — a silent wrong parse is the worst outcome a saved file can have, and the arrangement map is saved as often as the audio. **Lila:** the hard-but-tractable core is already proven for the rack — this rung reveals that **the verify-before-trust seal is not specific to a rack; it is a law for any travels-as-text record.** Applying it to the cue sheet both protects the arrangement map and demonstrates the generalization, without disturbing the shipped `rack_seal.rye`.

Purely local — a Sha256 over an in-process text record. No signature, no key, no socket, no network, no funds, no device.

## The crux

**A sealed cue sheet parses back to exactly the same markers track only when its digest matches its body — `verify_and_parse` recomputes the Sha256 over the embedded lotus-audio record and refuses `DigestMismatch` before a single marker is trusted.** Two facts make it exact, mirroring lotus-audio: `seal_sheet` wraps lotus-audio whole (it renders the plain record with `cue_sheet.render_sheet` and writes a Sha256 over exactly those body bytes, the digest covering the canonical text with nothing added or omitted), and verify runs before trust (`verify_and_parse` checks the digest first and hands the body to `cue_sheet.parse_sheet` only on a match, so no corrupt record reaches the parser — the integrity gate is independent of and prior to every lotus-audio grammar and position-bound check).

The one honest difference from the rack seal: `cue_sheet.parse_sheet` validates marker positions against a `master` clip (a marker cannot fall past the audio), so `verify_and_parse` takes that `master` and passes it through — the integrity gate first, the position bounds after, both before any marker is trusted.

## Shape

A new module `lotus/cue_seal.rye`, two public functions parallel to `rack_seal`:

- `seal_sheet(m: *const markers.Markers, out: []u8) CueSealError!u32` — render the lotus-audio record as the body and backfill a Sha256 over exactly it, under a `format lotus-cue-sheet-sealed-v1` header and a `digest <64 hex>` line. Refuses `Overflow` rather than writing past the buffer.
- `verify_and_parse(text: []const u8, master: *const pan.StereoClip, out: *markers.Markers) CueSealError!void` — the integrity gate before trust. `CueSealError = error{DigestMismatch} || cue_sheet.MarkerTextError`.

The sealed header is distinct from both the plain cue-sheet header and the rack's sealed header, so no record is ever mistaken for another kind.

## What the witness proves

`tools/ales_cue_seal_witness.rish`, GREEN on metal:

1. **The crux** — a sealed four-marker track round-trips through `verify_and_parse`, every position and name recovered, the body exactly the plain lotus-audio record.
2. **Flipped body byte** — a single changed digit in the body refuses `DigestMismatch`, the output track left empty.
3. **Truncated tail** — a dropped last byte refuses `DigestMismatch`.
4. **Malformed seal** — a plain (unsealed) record, a missing digest line, a short digest, and a non-hex digest each refuse `BadRecord` (structural, distinct from a content mismatch).
5. **Overflow** — a seal into a too-small buffer refuses `Overflow`.

## The road on

With both the rack sheet (lotus-audio) and the cue sheet (lotus-audio) sealed, the verify-before-trust law is shown to be general. The next purely-local rung is a **session file** — one sealed document bundling a keeper's whole project (the rack *and* the cue sheet over one master), or the eventual refactor that lifts the shared seal into one place both wrappers call. The **signed** carry (who wrote a sheet, via a Kumara key) and the **wire** carry stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May a keeper's map arrive as whole as their audio, and may every saved arrangement read true on its ten-thousandth day.*
