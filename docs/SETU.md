# usb-hearth — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: pull · apply · ping · UDP · NCM frame · live framed socket · device-wire payload bound — before Pixel/QEMU gadget bind.*

**Status:** Checkable — operator compressor (usb-hearth–usb-hearth GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (usb-hearth device payload GREEN)  
**Compresses:** [`hearth-display.md`](hearth-display.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

The fold crosses USB as files, then as a sealed ping, then as an NCM-shaped frame on a live socket, then as a virtio-sized device payload (`lane_frame.bin`). Live CDC-NCM iface / QEMU device-wire lab bind is **usb-hearth**.

**Waymark:** **usb-hearth**. Sibling **hearth-display** owns the preference mold.

## Rung table

| Rung | Claim | Witness | State |
|------|-------|---------|-------|
| **usb-hearth** | adb pull Bron | `setu0_hearth_pull_witness` | **GREEN** |
| **usb-hearth.5** | Desk station apply | `setu05_desk_apply_witness` | **GREEN** |
| **usb-hearth** | `usb_desk` lane ping | `setu1_lane_ping_witness` | **GREEN** |
| **usb-hearth** | Bare ping UDP :38501 | `setu2_lane_wire_witness` | **GREEN** |
| **usb-hearth** | NCM-shaped wrap | `setu3_ncm_frame_witness` | **GREEN** |
| **usb-hearth** | Framed ping live UDP :38502 | `setu4_framed_lane_witness` | **GREEN** |
| **usb-hearth** | Fits device max_frame · `lane_frame.bin` | `setu5_device_payload_witness` | **GREEN** `20260718.184537` |
| **usb-hearth** | QEMU/Pixel CDC-NCM / device-wire lab | — | open — check-in |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu4_framed_lane_witness.rish
rishi/bin/rishi run tools/setu5_device_payload_witness.rish
rishi/bin/rishi run tools/setu4_gadget_probe_onpath_host.rish
```

---

*May every wire carry the fold home before it tries to live.*
