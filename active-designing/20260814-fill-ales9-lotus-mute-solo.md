# lotus-audio — Lotus's mute and solo

**Stamp:** `20260814.121500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after lotus-audio
**Waymark:** lotus-audio · rung lotus-audio
**Kin:** [`lotus-audio — the fader column`](20260814-fill-ales8-lotus-fader-column.md) · [`lotus-audio — the track table`](20260814-fill-ales6-lotus-track-table.md) · [`lotus/strip.rye`](../lotus/strip.rye) · [`lotus/fader.rye`](../lotus/fader.rye) (lotus-audio)

---

## Why this round

lotus-audio gave each track a fader — a level. Yet a mixing keeper reaches, constantly and almost without thinking, for two switches that sit right beside the level on every channel strip ever built: **mute** (silence this track) and **solo** (silence every *other* track). They are how a mix is auditioned — mute the vocal to hear the bed, solo the kick to place it. A fader column without mute and solo is a set of levels; with them, it is a desk a keeper actually works.

Lila and the Long Return: mute and solo are the most durable road left open from lotus-audio — the channel strip is read on the ten-thousandth day, and mute/solo are its two most-used controls after the fader itself. A transport loop only extends the lotus-audio read head; a crossfade curve refines the lotus-audio fade; pan waits on stereo, a larger architectural opening. The two switches first, and they compose **directly** on the fader I just built.

## The one crux this rung fixes

**Mute and solo are a pure resolution to an effective level — they add no new sum and no new saturation.** The temptation is to teach `render` a second summing path that skips muted tracks; the durable move is the opposite. A channel strip resolves, per track, to an **effective fader**: an audible track carries its own fader, a silenced track carries `0/1`. Then the mix is lotus-audio's `fader.render`, delegated whole. The only sum in the suite stays the one wide-i64-accumulate-then-saturate-once that lotus-audio/lotus-audio already prove — a track silenced by mute or solo simply contributes zero.

The desk rule, stated positively (the one subtle decision): **solo, when any track holds it, wins.** A soloed track is always heard — solo overrides even its own mute (solo-in-place, the standard). When no track is soloed, every un-muted track is heard. So the presence of *any* solo flips the whole desk from "hear the un-muted" to "hear only the soloed."

## The shape

`lotus/strip.rye`:

- `Strip` — a `fader.Fader` (lotus-audio) plus two flags, `muted` and `soloed`. Default an audible unity strip.
- `any_solo(strips)` — true when any strip holds solo; the one fact that flips the desk.
- `audible(strip, solo_active)` — the desk rule as a predicate: a soloed strip is always heard; otherwise heard only when no solo is active and it is not muted.
- `resolve(strips, out)` — map each strip to its effective fader (`fader` if audible, else `silence` = `0/1`).
- `render(session, strips, clock, out)` — resolve the column, then delegate to `fader.render` whole. `strips.len` equals `session.count` (asserted). Every refusal is lotus-audio's, forwarded: `BadGain`, `ClipFull`, `DurationTooLong`.

A column of default strips (no mute, no solo, unity fader) resolves to a unity fader column, so `render` reproduces lotus-audio's `fader.render` byte-for-byte — the channel strip **generalizes** the fader column rather than replacing it. lotus-audio's `fader.rye` stands untouched; the strip composes over its public API (accrete-never-break).

## What the witness proves (GREEN on metal)

`tools/ales_strip_witness.rish`: no mute and no solo reproduces lotus-audio's fader mix byte-for-byte; a muted track goes silent, the rest unchanged; a soloed track silences every other track even un-muted ones; two solos are heard together; a muted-and-soloed track is still heard (solo-in-place overrides its own mute); a zero denominator on an audible strip forwards `BadGain`; a track past the master bound forwards `ClipFull`. GREEN on the first build. Purely local — no socket, no network, no keys, no funds, no real device.

## The road on

With the fader and its two switches, a channel strip is nearly whole. The next Lotus rung can name **pan** (a fader per channel as stereo opens — the larger architectural move from mono to two channels), a transport **loop** over a marked region (extending lotus-audio), or the equal-power **crossfade curve** lotus-audio's fade still awaits. The audio-interface **hardware** stays a paused research round, taken only on Keaton's word.
