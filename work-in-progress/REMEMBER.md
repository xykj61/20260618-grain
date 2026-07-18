# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260718.193122` (Eastern) · voice Quin  
**Product nib:** glass-keyboard · hearth-display–5 · usb-hearth · HOLD0 · **HOLD1**  
**Suite nib:** glass-keyboard–6 · hearth-display–5 · usb-hearth–usb-hearth · HOLD0–HOLD1  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **pixel-glass** | GrapheneOS / Pixel SLC | pixel-glass–1 GREEN · pixel-glass real Pixel |
| **glow-publishing** | App framework / NativeActivity pack | glow-publishing.5 APK GREEN |
| **glass-keyboard** | English QWERTY glass keyboard | glass-keyboard–6 GREEN (Pixel look) |
| **seva-broadcast** | Sala broadcast live-session fold | seva-broadcast–2 GREEN · seva-broadcast check-in |
| **hearth-display** | Hearth · short home · Wired Glass | **hearth-display–5 closed** |
| **usb-hearth** | USB hearth carry Glass↔Desk | **usb-hearth–usb-hearth · HOLD0–HOLD1 GREEN** · usb-hearth check-in |

Canon: [`../docs/pixel-glass.md`](../docs/pixel-glass.md) · [`../docs/glow-publishing.md`](../docs/glow-publishing.md) · [`../docs/glass-keyboard.md`](../docs/glass-keyboard.md) · [`../docs/seva-broadcast.md`](../docs/seva-broadcast.md) · [`../docs/hearth-display.md`](../docs/hearth-display.md) · [`../docs/usb-hearth.md`](../docs/usb-hearth.md)

---

## Outer terminal (host shell — not ai-jail)

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
# usb-hearth→HOLD0 — pull hearth · station · ping gate · Desk hold line
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
rishi/bin/rishi run tools/setu_desk_hold1_witness.rish
```

---

## Phone look (hearth-display closed)

Hold row 1 → Settings: presets · `home ·` · `wire ·` · `cell ·` — all Pixel GREEN.

## Open doors

| Door | Kind |
|------|------|
| Ship HOLD1 Desk Skate hold | **send** |
| **usb-hearth** QEMU/Pixel CDC-NCM lab | **check-in** (parked) |
| Amber/Amphora Glass↔Desk fuse | **declined** — compose later (`133455`) |
| seva-broadcast · TAME Lap 3 | **check-in** |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
