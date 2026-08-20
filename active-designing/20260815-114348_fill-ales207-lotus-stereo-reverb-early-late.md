# Fill lotus-audio — Lotus's stereo reverb early/late balance (the first reflections against the diffuse wash, per ear)

**Stamp:** `20260815.114348` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Chapter:** the Six-Chapter double-seat, Chapter C thread (Lotus · the creative suite) · waymark **lotus-audio** · rung **lotus-audio**
**Kin:** [`20260815-113645_fill-ales206-lotus-reverb-early-late.md`](20260815-113645_fill-ales206-lotus-reverb-early-late.md) · [`20260815-101449_fill-ales193-lotus-stereo-reverb-wet-dry-mix.md`](20260815-101449_fill-ales193-lotus-stereo-reverb-wet-dry-mix.md) · [`../.claude/rules/lila-and-the-long-return.md`](../.claude/rules/lila-and-the-long-return.md)

---

## The crux this round takes

lotus-audio gave the **mono** reverb its early/late balance — a crossfade between a room's discrete first reflections and its diffuse late wash. Yet a keeper mixing a **stereo master** still had no such knob; the early/late balance stopped at mono, exactly as the wet/dry mix did before lotus-audio carried *it* across. This rung is the thin twin lotus-audio named next: the **same** crossfade, over **both** channels of a `StereoClip`, one shared early bank, room, and balance, the image held.

The ladder always closes the mono/stereo pair before opening a fresh axis — Lila within the finishing edge. It composes proven stages exactly as lotus-audio did: the early reflections per ear are lotus-audio's `multitap_ms` (run once per channel, each reading its own dry), the late wash is lotus-audio's `stereo_reverb_preset`, and the blend is the same linear balance run per channel with no cross-channel read.

## The shape — the early reflections against the late wash, per ear, one balance knob

`stereo_reverb_early_late(sc, clk, room, start_ms, count_ms, balance_num, balance_den)`:

1. Assert the channels enter balanced; assert the clock; refuse a bad balance fraction (`BadBalance`) before any write.
2. Compute the **EARLY** signal on a full **copy** of the master: lotus-audio's `multitap_ms` over the room's fixed early bank (lotus-audio's own published banks), run on **each** channel of the copy — the left ear reads the left's dry, the right the right's, never crossed. The copy absorbs every fault the multi-tap could raise, so the real master stays untouched and balanced on refusal.
3. Compute the **LATE** signal in place on the master: lotus-audio's `stereo_reverb_preset` UNCHANGED — the room's diffuse wash across both channels. It prechecks before any write, so a fault here leaves both channels dry and balanced.
4. **Blend** each channel's early against its own late over the span, the same linear weighted average per sample, saturated once, with no cross-channel read:
   `out[i] = saturate((balance_den − balance_num)·early[i]/balance_den + balance_num·late[i]/balance_den)`.

## The provable laws the witness proves

1. **THE EARLY EDGE (`balance == 0`)** — each channel equals lotus-audio's `multitap_ms` over the room's published early bank, byte for byte. Fully toward early is exactly the discrete first reflections, per ear.
2. **THE LATE EDGE (`balance == den`)** — equals lotus-audio's `stereo_reverb_preset` over the span, byte for byte on both channels.
3. **THE BLEND IS BETWEEN** — a half balance differs from both edges on each channel, and each sample of each channel is the honest weighted average of its own early and its own late, byte for byte.
4. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel; a genuinely stereo master keeps its channels distinct — no crossing.
5. **THE CHANNELS LEAVE BALANCED** and silence stays silence.
6. **THE FAULTS FORWARD, ATOMIC** — a bad balance fraction `BadBalance`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name with both channels untouched and balanced (the early multi-tap runs on the copy, the late preset prechecks).

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, lotus-audio's fixed reverb banks and lotus-audio's fixed early-tap banks, and one bounded full-master copy for the early signal, siloed to `lotus/`. No new audio arithmetic — the crossfade is lotus-audio's proven linear blend run per ear, each channel's early and late computed by a proven stage, saturated once. The early banks are named in **milliseconds**, so one room sounds the same at any sample rate; the balance is a named fraction, not a decibel. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The early/late axis then stands whole, mono and stereo. A fresh reverb axis opens next — **width** (the stereo spread of the tail) or **freeze** (an infinite-hold sustain).
