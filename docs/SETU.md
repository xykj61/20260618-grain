# usb-hearth — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: pull the Hearth fold, apply on Desk, arm a lane ping, cross hosted UDP, then wear the NCM-shaped ethernet frame before real gadget bring-up.*

**Status:** Checkable — operator compressor (usb-hearth–usb-hearth GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (usb-hearth NCM frame GREEN)  
**Compresses:** [`hearth-display.md`](hearth-display.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

USB pulls the fold; Desk inherits a station; `usb_desk` seals a ping; that ping crosses localhost UDP; the same bytes wear Comlink’s virtio-net + Ethernet header (CDC-NCM packet shape). Live gadget bring-up on Pixel/QEMU is **usb-hearth**.

**Waymark:** **usb-hearth**. Sibling **hearth-display** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **usb-hearth** | adb pull pointer + Bron | `setu0_hearth_pull_witness` | **GREEN** |
| **usb-hearth.5** | Desk apply → `station.bron` | `setu05_desk_apply_witness` | **GREEN** |
| **usb-hearth** | `usb_desk` lane ping → `lane_ping.bin` | `setu1_lane_ping_witness` | **GREEN** |
| **usb-hearth** | Ping crosses hosted UDP :38501 | `setu2_lane_wire_witness` | **GREEN** `20260718.134348` |
| **usb-hearth** | NCM-shaped virtio+eth wrap/unwrap | `setu3_ncm_frame_witness` | **GREEN** `20260718.134613` |
| **usb-hearth** | Live CDC-NCM / gadget bring-up | — | open — check-in |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu2_lane_wire_witness.rish
rishi/bin/rishi run tools/setu3_ncm_frame_witness.rish
```

---

*May every wire carry the fold home before it tries to live.*
