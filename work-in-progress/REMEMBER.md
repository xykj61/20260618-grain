# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260718.122145` (Eastern) · voice Quin  
**Product nib:** seva-broadcast bare-ret chat GREEN · **glass-keyboard / hearth-display design seated** (build next)  
**Suite nib:** glass-keyboard–5 GREEN · mode round-trip GREEN  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **pixel-glass** | GrapheneOS / Pixel SLC | pixel-glass–1 GREEN · pixel-glass real Pixel GrapheneOS |
| **glow-publishing** | App framework / NativeActivity pack | glow-publishing.5 APK GREEN · glow-publishing admitted glass |
| **glass-keyboard** | English QWERTY glass keyboard | glass-keyboard–5 GREEN · **glass-keyboard** ret=newline · ↑=send (design) |
| **seva-broadcast** | Sala broadcast live-session fold | seva-broadcast–2 GREEN · seva-broadcast check-in |
| **hearth-display** | Hearth display · short home · Wired Glass | hearth-display+ open · waymark `20260718.122145` |

Canon: [`../docs/pixel-glass.md`](../docs/pixel-glass.md) · [`../docs/glow-publishing.md`](../docs/glow-publishing.md) · [`../docs/glass-keyboard.md`](../docs/glass-keyboard.md) · [`../docs/seva-broadcast.md`](../docs/seva-broadcast.md) · [`../docs/hearth-display.md`](../docs/hearth-display.md)

---

## Outer terminal (host shell — not ai-jail)

The jail has **no** `/dev/bus/usb`. Pack inside Cursor; install from a plain host terminal:

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices   # must show device (not unauthorized)
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
```

Re-pack after glass edits: `rishi/bin/rishi run tools/tube05_apk_pack_witness.rish` (inside jail is fine).

---

## Phone look (this pack — pre-glass-keyboard)

1. **ret** — still **submit** until glass-keyboard lands; bare ret → `chat ·`; typed → `chat · …`.
2. **em / 123 → abc** — mode round-trip; app stays open (finish-zone).
3. **Close** — only `TAP ABOVE KB TO CLOSE` (Skate 13).
4. After glass-keyboard: **ret** = newline · **↑** = send.

---

## Open doors

| Door | Kind |
|------|------|
| **glass-keyboard** newline + ↑ send | **kg** (design seated) |
| **hearth-display** Bron hearth `home_id` + preset | **kg** after glass-keyboard |
| Host install if APK rebuilt | **kg** |
| seva-broadcast · TAME Lap 3 · Sensors orientation · Setu name | **check-in** |
| hearth-display Settings UI · Wired Glass metalsmoke | **check-in** |

Silo: [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md)

---

## Words

| Word | Means |
|------|--------|
| **remember** | Reprint this card |
| **kg** | Keep going — not ship |
| **align** | Walk compass · fix plan drift |
| **send** | Commit · push · merge to pier |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
