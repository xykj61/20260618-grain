# glass-keyboard — Glow English QWERTY glass keyboard ladder

*Waymark for Dexter’s on-Skate English keyboard. Own keys; Graphene IME stays optional hardware path. Compresses the silo; never replaces it.*

**Status:** Checkable — operator compressor
**Depth:** guide
**Ceiling:** ≤80 lines
**Last updated:** 2026-07-17
**Compresses:** [`20260717-175220_dexter-english-qwerty-glass-keyboard.md`](../active-designing/20260717-175220_dexter-english-qwerty-glass-keyboard.md) · study [`20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md`](../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md)

---

## Thesis — paint the hand

Bare NativeActivity does not attach Graphene/AOSP soft IME reliably. **glass-keyboard** is Glow’s own English QWERTY on Skate: layout tables → paint → tap → Dexter `Action`. iOS-inspired modes from public notes; clean-room.

**Waymark draw:** input `glow-english-qwerty-glass-keyboard-3` · SHA3-512 · flw.txt → **glass-keyboard** (`tools/waymark_derive.rish`, `20260717.180025`).

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **glass-keyboard** | Letters · numbers · symbols layout tables | `tools/dexter_glass_keyboard_witness.rish` | **GREEN** `20260717.180025` |
| **glass-keyboard** | Paint letters mode on Skate; hit boxes | same witness · pack | **GREEN** `20260717.180558` |
| **glass-keyboard** | Tap → Dexter Action → live line | glass-keyboard | open |
| **glass-keyboard** | Blinking caret on Dexter line | glass-keyboard+ | open |
| **glass-keyboard** | Emoji mode SLC (bounded) | glass-keyboard | open |
| **glass-keyboard** | Pixel look — keys + caret + type by tap | glass-keyboard · glass-keyboard | open |

## Hands-on

```bash
rishi/bin/rishi run tools/waymark_derive.rish   # input_name = …-keyboard-3
rishi/bin/rishi run tools/dexter_glass_keyboard_witness.rish
```

Layout: [`linengrow/dexter_glass_keyboard_layout.rye`](../linengrow/dexter_glass_keyboard_layout.rye).

---

*May every rung name its ladder, and every key prove before it paints.*
