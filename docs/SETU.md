# usb-hearth — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: pull the Hearth fold, apply on Desk, arm a lane ping, cross UDP, wear an NCM-shaped frame, then carry that framed ping on a live socket before gadget bring-up.*

**Status:** Checkable — operator compressor (usb-hearth–usb-hearth GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (usb-hearth framed live lane GREEN)  
**Compresses:** [`hearth-display.md`](hearth-display.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

USB pulls the fold; Desk inherits a station; `usb_desk` seals a ping; the ping wears Comlink’s NCM-shaped frame and crosses a live localhost UDP socket. Host may probe for `usb0`/`ncm` (SKIP when absent). Pixel/QEMU CDC-NCM iface bring-up is **usb-hearth**.

**Waymark:** **usb-hearth**. Sibling **hearth-display** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **usb-hearth** | adb pull pointer + Bron | `setu0_hearth_pull_witness` | **GREEN** |
| **usb-hearth.5** | Desk apply → `station.bron` | `setu05_desk_apply_witness` | **GREEN** |
| **usb-hearth** | `usb_desk` lane ping | `setu1_lane_ping_witness` | **GREEN** |
| **usb-hearth** | Bare ping over UDP :38501 | `setu2_lane_wire_witness` | **GREEN** |
| **usb-hearth** | NCM-shaped virtio+eth wrap | `setu3_ncm_frame_witness` | **GREEN** |
| **usb-hearth** | Framed ping over live UDP :38502 · gadget probe SKIP | `setu4_framed_lane_witness` · host probe | **GREEN** `20260718.184323` |
| **usb-hearth** | CDC-NCM gadget iface bring-up | — | open — check-in |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu4_framed_lane_witness.rish
rishi/bin/rishi run tools/setu4_gadget_probe_onpath_host.rish
```

---

*May every wire carry the fold home before it tries to live.*
