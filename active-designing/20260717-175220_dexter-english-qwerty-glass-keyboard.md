# Dexter English QWERTY Glass Keyboard

*Graphene’s system IME does not reliably appear on bare NativeActivity. Glow paints its own English QWERTY on Skate — iOS-inspired modes from public notes, clean-room — and drains taps into the seated Dexter Action path. Cursor blink is a sibling lap. Ladder waymark: **glass-keyboard**.*

**Version:** `20260717.175220` (Eastern) · waymark **glass-keyboard** + glass-keyboard `20260717.180025`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Mixed — design seated; **glass-keyboard** layout tables Checkable GREEN; paint still vision (Two Rooms).
**World study:** [`../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md`](../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md)
**Compressor:** [`../docs/glass-keyboard.md`](../docs/glass-keyboard.md)

---

## Decisions Seated Here

1. **D3 Pixel look** — GREEN for install + `DEXTER line · glow`; **honest gaps:** no system soft keyboard visible; no blinking cursor.
2. **Do not depend on Graphene/AOSP IME** for glass typing. Keep hardware KEY drain (D3) as a bonus path.
3. **Implement a Glow-owned English QWERTY on-screen keyboard** under the Dexter / Brushstroke / Sala stack — Skate-painted, tap → `window_input.Action`.
4. **Layout family:** iOS English modes as publicly described (letters · numbers · symbols · emoji), Glow names and art. No Apple assets. Other languages later.
5. **Foundations, TAME root, and Glow rune surface stay unmoved.** This is product glass, not a new rune nest.
6. **Waymark glass-keyboard** — drawn `20260717.180025` from input `glow-english-qwerty-glass-keyboard-3` via `tools/waymark_derive.rish`. Living rungs **glass-keyboard–glass-keyboard**.
7. **Cursor blink** is lap **glass-keyboard**.

## Clean-Room Law

Study public layout/behavior notes only. Emit Glow layout tables (Rye). Never vendor iOS keyboard binaries, SF Symbols packs, or copied bitmaps.

## Named Laps (waymark glass-keyboard)

| Lap | Claim | State |
|---|---|---|
| **glass-keyboard** | English letters + numbers + symbols **layout tables** | **GREEN** · `tools/dexter_glass_keyboard_witness.rish` |
| **glass-keyboard** | Paint letters mode on Skate; hit boxes | open |
| **glass-keyboard** | Tap → Dexter Action → live line refresh | open |
| **glass-keyboard** | Blinking caret on `DEXTER line · …` | open |
| **glass-keyboard** | Emoji mode SLC (bounded frequent set) | open |
| **glass-keyboard** | Pixel look — keys + caret + type by tap | open |

## Aligned Next

**glass-keyboard** — paint the letters page on Skate with hit boxes.

## Related

- Study · layout · waymark law · Dexter reviving silo · [`../docs/glass-keyboard.md`](../docs/glass-keyboard.md)

---

*May every key we show be one we painted, and every blink mark a living line.*
