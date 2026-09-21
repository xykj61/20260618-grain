# usb-hearth — device-wire lab harness

*Approved after Desk Hearth Hold closed. Opens the CDC-NCM / device-wire lab without claiming a live gadget iface that is not present.*

**Stamp:** `20260718.201232` (Eastern)  
**Status:** Checkable — usb-hearth GREEN (stand-in on this host)  
**Voice:** Quin  
**Compresses into:** [`../docs/usb-hearth.md`](../../docs/usb-hearth.md)

---

## Claim

Desk holds a **lab card** (`lab.kyri`): usb-hearth payload ready · host iface `none|usb0|ncm*` · mode `stand-in|armed`. Device-free fixtures GREEN. Host probe writes the card; stand-in is honest when Pixel is still charging+debug.

## Budget

- One status mold + `lab.kyri`
- Device-free witness + host probe rish
- No root configfs / no Amber fuse / no live AF_PACKET TX yet

## Next

**usb-hearth.5** — framed TX once a real `usb0`/`ncm` appears (Pixel NCM gadget or QEMU). Needs check-in when the gadget path is chosen.

---

*May the lab name the wire before it pretends to cross it.*
