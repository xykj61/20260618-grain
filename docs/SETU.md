# usb-hearth — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: carry the Hearth fold over USB, apply on Desk, arm a Comlink lane ping on `usb_desk`, then prove that ping crosses a hosted UDP stand-in before real CDC-NCM.*

**Status:** Checkable — operator compressor (usb-hearth–usb-hearth GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (usb-hearth hosted UDP GREEN)  
**Compresses:** [`hearth-display.md`](hearth-display.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

USB pulls the fold; Desk inherits a station; `usb_desk` seals a ping; that ping crosses localhost UDP as the Setu lane stand-in. Real CDC-NCM gadget networking waits as **usb-hearth**.

**Waymark:** **usb-hearth**. Sibling **hearth-display** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **usb-hearth** | adb pull pointer + Bron; Desk parse | `setu0_hearth_pull_witness` | **GREEN** `20260718.132731` |
| **usb-hearth.5** | Desk apply → `station.bron` | `setu05_desk_apply_witness` | **GREEN** `20260718.133328` |
| **usb-hearth** | `usb_desk` lane ping → `lane_ping.bin` | `setu1_lane_ping_witness` | **GREEN** `20260718.133853` |
| **usb-hearth** | Ping crosses hosted UDP (port 38501) | `setu2_lane_wire_witness` | **GREEN** `20260718.134348` |
| **usb-hearth** | CDC-NCM gadget lane | — | open — check-in |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
rishi/bin/rishi run tools/setu1_lane_ping_witness.rish
rishi/bin/rishi run tools/setu2_lane_wire_witness.rish
```

---

*May every wire carry the fold home before it tries to live.*
