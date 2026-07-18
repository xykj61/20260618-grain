# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260718.130756` (Eastern) · voice Quin  
**Product nib:** glass-keyboard Pixel GREEN · **hearth-display–2 sent** (hold-open perfect)  
**Suite nib:** glass-keyboard–6 · hearth-display–2  

**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **pixel-glass** | GrapheneOS / Pixel SLC | pixel-glass–1 GREEN · pixel-glass real Pixel |
| **glow-publishing** | App framework / NativeActivity pack | glow-publishing.5 APK GREEN |
| **glass-keyboard** | English QWERTY glass keyboard | glass-keyboard–6 GREEN (Pixel look) |
| **seva-broadcast** | Sala broadcast live-session fold | seva-broadcast–2 GREEN · seva-broadcast check-in |
| **hearth-display** | Hearth display · short home · Wired Glass | **hearth-display–2 sent** · next: Wired Glass · home_id |

Canon: [`../docs/pixel-glass.md`](../docs/pixel-glass.md) · [`../docs/glow-publishing.md`](../docs/glow-publishing.md) · [`../docs/glass-keyboard.md`](../docs/glass-keyboard.md) · [`../docs/seva-broadcast.md`](../docs/seva-broadcast.md) · [`../docs/hearth-display.md`](../docs/hearth-display.md)

---

## Outer terminal (host shell — not ai-jail)

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
```

---

## Phone look (glass-keyboard · hearth-display closed)

1. Short tap row 1 → cycle presets (persists).  
2. Hold row 1 ~½s → list under finger; tap a name to set.  
3. `ret` = newline; `^` = send.

## Witnesses (device-free)

```bash
rishi/bin/rishi run tools/hearth_lulu0_witness.rish
rishi/bin/rishi run tools/hearth_lulu1_witness.rish
rishi/bin/rishi run tools/hearth_lulu2_witness.rish
```

---

## Open doors

| Door | Kind |
|------|------|
| **Wired Glass / Setu** (affirmed next) | **check-in** thin face |
| **home_id editor** (affirmed next) | **check-in** thin face |
| seva-broadcast · TAME Lap 3 | **check-in** |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
