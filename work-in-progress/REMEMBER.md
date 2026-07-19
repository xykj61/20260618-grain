# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260719.145927` (Eastern) · voice Quin  
**Product nib:** glass-keyboard · hearth-display–5 · **usb-hearth.5** · HOLD0–HOLD1 · HOLD-W  
**Language nib:** **glow-language–39** GREEN · glow-language open  
**Suite nib:** glass-keyboard–6 · hearth-display–5 · usb-hearth–usb-hearth.5 · HOLD0–HOLD1 · HOLD-W · glow-language–39  
**Git nib:** `4446223846` glow-language jam→cue compose  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Now (language)

**glow-language** jam→cue compose GREEN `20260719.145738` — await **send**. Next door: **glow-language** check-in.

Smoke: `rishi/bin/rishi run tools/glow_run.rish glow/gen/compose-jam-cue.glow`

Pitfalls: copy face buffers out of `rf.parse` before return · Zig `packed` · cue subject must name prior pack face · expect **3**.

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **pixel-glass** | GrapheneOS / Pixel SLC | pixel-glass–1 GREEN · pixel-glass real Pixel |
| **glow-publishing** | App framework / NativeActivity pack | glow-publishing.5 APK GREEN |
| **glass-keyboard** | English QWERTY glass keyboard | glass-keyboard–6 GREEN (Pixel look) |
| **seva-broadcast** | Sala broadcast live-session fold | seva-broadcast–2 GREEN · seva-broadcast check-in |
| **hearth-display** | Hearth · short home · Wired Glass | **hearth-display–5 closed** |
| **usb-hearth** | USB hearth carry Glass↔Desk | **usb-hearth–usb-hearth.5 · HOLD0–HOLD1 · HOLD-W GREEN** · live “sent” eyes check-in |
| **glow-language** | Glow language SLC · nest · composition | **glow-language–39 GREEN** · jam→cue compose · glow-language next |

Canon: [`../docs/pixel-glass.md`](../docs/pixel-glass.md) · [`../docs/glow-publishing.md`](../docs/glow-publishing.md) · [`../docs/glass-keyboard.md`](../docs/glass-keyboard.md) · [`../docs/seva-broadcast.md`](../docs/seva-broadcast.md) · [`../docs/hearth-display.md`](../docs/hearth-display.md) · [`../docs/usb-hearth.md`](../docs/usb-hearth.md) · [`../docs/glow-language.md`](../docs/glow-language.md)

---

## Outer terminal (host shell — not ai-jail)

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
# usb-hearth→HOLD1 — pull · station · ping gate · hold line · Skate cells
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
# usb-hearth + usb-hearth.5 — lab card · TX gate (stand-in SKIP without usb0/ncm)
rishi/bin/rishi run tools/setu6_lab_probe_onpath_host.rish
rishi/bin/rishi run tools/setu65_lab_tx_onpath_host.rish
# device-free Skate + Wayland raster
rishi/bin/rishi run tools/setu_desk_hold_wayland_witness.rish
# eyes (host Wayland session — close the window when done):
# linengrow/bin/setu_desk_hold_wayland_look
```

---

## Phone look (hearth-display closed)

Hold row 1 → Settings: presets · `home ·` · `wire ·` · `cell ·` — all Pixel GREEN.

## Open doors

| Door | Kind |
|------|------|
| **glow-language** next language toward product-in-Glow | **check-in** |
| Live usb-hearth.5 **sent** on usb0/ncm | **check-in** (needs gadget/QEMU) |
| Amber/Amphora Glass↔Desk fuse | **declined** — compose later (`133455`) |
| seva-broadcast · TAME Lap 3 | **check-in** |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
