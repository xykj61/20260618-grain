# lotus-audio — Lotus's stereo meter during playback, two meters read both channels live

**Stamp:** `20260814.130631` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after lotus-audio
**Waymark:** lotus-audio · rung lotus-audio
**Kin:** [`lotus-audio — the peak/RMS meter`](20260814-fill-ales13-lotus-meter.md) · [`lotus-audio — the stereo transport`](20260814-fill-ales15-lotus-stereo-transport.md) · [`lotus-audio — the stereo loop`](20260814-fill-ales16-lotus-stereo-loop.md) · [`lotus/stereo_meter.rye`](../lotus/stereo_meter.rye) · [`lotus/meter.rye`](../lotus/meter.rye) (lotus-audio, the Meter reused whole) · [`lotus/stereo_transport.rye`](../lotus/stereo_transport.rye) (lotus-audio, the stereo head)

---

## Why this round

The read side of the suite has three tools — play (lotus-audio), meter (lotus-audio), loop (lotus-audio). lotus-audio made the play head genuinely stereo and lotus-audio looped it over two channels; both now read a stereo master. The meter is the one tool still living only in mono time: lotus-audio can already `measure_stereo` a master **at rest**, yet nothing meters a stereo master **during playback** — a live stereo VU fed by the very blocks the stereo head plays. Lila and the Long Return: bringing the meter to the stereo read path completes the read side's third tool over two channels, so play, loop, and meter all read the same stereo master through the same head — the durable close of the read side's stereo arc. A punch region (record armed within marked points) would cross into the Mikrophone's capture side, a module seam that waits for Keaton's word; the stereo meter stays wholly within the read side.

## The one crux this rung fixes

**Two meters read both channels in lockstep, because the one stereo head hands each block to both channels at once.** lotus-audio's `read_block` fills both out buffers with the same count off a single position, so the stereo meter needs no new accumulation — it feeds lotus-audio's proven `Meter` per channel. The correctness beyond running lotus-audio twice is exactly the **lockstep**: both channels feed the same count every block, so the pair reads a matched-length stereo level, and **block-invariance holds per channel over the stereo transport** — metering a stereo master block by block off the one head gives the identical per-channel peak and RMS as lotus-audio's whole-master `measure_stereo`, at any block size. The live VU reads exactly what the stereo head plays.

## The shape

`lotus/stereo_meter.rye`:

- `StereoMeter` — one [`meter.Meter`](../lotus/meter.rye) per channel; a fresh meter reads silence in both.
- `feed(stereo_meter, block_left, block_right)` — feed each channel's block into its meter through lotus-audio's proven `feed` (which refuses `MeterFull` before any accumulation). The two blocks are one length (a stereo block from lotus-audio's `read_block`), asserted, so the two channel meters advance by the same count.
- `peak_left` / `peak_right` / `rms_left` / `rms_right` — the per-channel level, read through lotus-audio's proven `peak` / `rms`.

## What the witness proves (GREEN on metal)

`tools/al/ales_stereo_meter_witness.rish`: a fresh stereo meter reads silence in both channels; a stereo master metered **live** off lotus-audio's stereo transport, block by block at 1-, 2-, and 7-sample blocks, gives the **identical** per-channel peak and RMS as lotus-audio's whole-master `measure_stereo` (block-invariance per channel, the two channels feeding the same count every block); a loud left and a quiet right report distinct levels; a `StereoClip` rendered by lotus-audio's `power.render_stereo` meters its two channels exactly (a center pan's `0.707` per side, `700` on a `1000` source); metering never mutates either channel; and `feed` refuses `MeterFull` past the bound, leaving the meter untouched. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With play, loop, and meter all stereo, the read side is genuinely two-channel end to end. The next rung can name a **scrub** window (a small movable read a keeper drags), meter a **looping** stereo region live (lotus-audio's wrap under the lotus-audio meter), a **punch region** tying playback back to the Mikrophone's capture (a module seam, Keaton's word), or offer the keeper the **choice of law** on either axis. The real two-channel sound-card write a stereo master ultimately feeds stays a paused hardware research round, taken only on Keaton's word.
