# Mantrapod Board Selection -- RISC-V hardware for bare-metal Dimeroll

**Status:** Living -- checkable
**Room:** active-development (scoping, would not outlive the code)
**Style:** Gauge at the Field setting
**Last updated:** 20261106.121723
**Journey:** `active-tablecloth/20261105-085747_mantrapod-rv64g-journey/` Movement 41

This document evaluates RISC-V single-board computers for running the Mantrapod -- a freestanding
RV64G Dimeroll ledger -- on real silicon. The evaluation criteria are bare-metal maturity, UART
accessibility, community documentation, form factor for enclosure, and price.

## Evaluation criteria

The Mantrapod boots freestanding RV64G ELF binaries with no OS. It communicates over UART serial.
It needs:

- **RV64GC or wider** -- the `+m+a+f+d` extensions the QEMU builds already target
- **Bare-metal boot path** -- the ability to load a flat binary or ELF without a full Linux stack
- **Documented UART base address and register layout** -- 16550-compatible preferred, since the
  terrarium UART driver already speaks that protocol
- **Community bare-metal precedent** -- at least one proven bare-metal project on the SoC
- **Enclosure-friendly form factor** -- small enough for a field-deployable Mantrapod
- **Reasonable price** -- under $100 USD for the board alone

## Candidates

### StarFive VisionFive 2

| Property | Value |
|---|---|
| **SoC** | StarFive JH7110 |
| **Cores** | 4x SiFive U74 RV64GC @ 1.5 GHz + 1x S7 monitor core |
| **RAM** | 2 GB / 4 GB / 8 GB LPDDR4 |
| **UART base** | 0x10000000 (UART0), DesignWare APB UART (snps,dw-apb-uart), 16550-compatible |
| **UART register stride** | 4 bytes (reg-shift 2), 24 MHz input clock |
| **Entry point** | 0x40000000 (differs from QEMU virt's 0x80000000) |
| **Boot** | SPI flash or UART recovery mode |
| **I/O** | 2x Gigabit Ethernet, USB 3.0, 40-pin GPIO, M.2 M-Key, microSD |
| **Form factor** | 100 mm x 72 mm (credit-card-plus) |
| **Price** | ~$55 (2 GB), ~$65 (4 GB), ~$85 (8 GB) |
| **Bare-metal precedent** | Yes -- D-language bare-metal blog (zyedidia.github.io), NuttX RTOS port, U-Boot early debug UART confirmed at 0x10000000 |
| **Community** | Strong -- device tree well documented, JH7110 datasheet available at doc-en.rvspace.org |

**Strengths.** The best-documented JH7110 SoC for bare-metal work. The UART at 0x10000000 is
confirmed by U-Boot (`DEBUG_UART_BASE 0x10000000`, `DEBUG_UART_CLOCK 24000000`,
`DEBUG_UART_NS16550`, `DEBUG_UART_SHIFT 2`) and by a [Star64/JH7110 NuttX RTOS write-up](https://lupyuen.codeberg.page/articles/privilege)
that walks the register offsets. The entry point 0x40000000 differs from QEMU virt, so the linker
script needs a second variant -- a one-line change in `terrarium/layout64.ld`.

**Weaknesses.** Peripheral documentation beyond UART is thin -- the [JH7110 datasheet](https://doc-en.rvspace.org/JH7110/PDF/JH7110I_DS.pdf)
exists yet many register maps are incomplete. Larger form factor than the Milk-V Mars.

### Milk-V Mars

| Property | Value |
|---|---|
| **SoC** | StarFive JH7110 (same as VisionFive 2) |
| **Cores** | 4x SiFive U74 RV64GC @ 1.5 GHz + 1x S7 monitor core |
| **RAM** | 1 GB / 2 GB / 4 GB / 8 GB LPDDR4 |
| **UART base** | 0x10000000 (same SoC, same register layout) |
| **UART access** | 3.3V TTL on 40-pin GPIO header, 115200 8N1 |
| **Entry point** | 0x40000000 (same SoC) |
| **Boot** | 16 MB SPI flash or UART serial download mode (recovery button) |
| **I/O** | Gigabit Ethernet, USB 3.0, 40-pin GPIO, microSD |
| **Form factor** | ~45 mm x ~25 mm (credit-card sized, Raspberry Pi CM4 compatible) |
| **Price** | ~$30 (1 GB), ~$40 (2 GB), ~$50 (4 GB) |
| **Bare-metal precedent** | Inherits all JH7110 bare-metal work from VisionFive 2 |
| **Community** | Good -- same SoC community, Milk-V forum active |

**Strengths.** Same JH7110 as the VisionFive 2, so every bare-metal finding transfers directly.
Significantly smaller form factor -- ideal for the Mantrapod enclosure (Movement 48). Lower price
at every RAM tier. The recovery button for UART serial download simplifies initial flashing.

**Weaknesses.** No independent bare-metal documentation -- relies entirely on VisionFive 2 and
JH7110 community work. Fewer I/O options (single Ethernet, no M.2). Less widely available at
retail.

### SpacemiT K1 (Milk-V Jupiter, Sipeed LicheePi 3A, Banana Pi BPI-F3)

| Property | Value |
|---|---|
| **SoC** | SpacemiT K1 |
| **Cores** | 8x X60 RV64GCVB (RVA22 profile) @ 1.6 GHz, dual-cluster |
| **RAM** | Up to 16 GB LPDDR4x |
| **UART base** | 0xd4017000 (UART0), 0x100-byte register window |
| **Boot** | BootROM -> signed FSBL -> U-Boot SPL (RSA-signed images required) |
| **I/O** | Varies by board -- Milk-V Jupiter has PCIe x8, dual GbE, USB 3.0 |
| **Form factor** | Milk-V Jupiter: mini-ITX (170 mm x 170 mm); Sipeed LicheePi 3A: smaller |
| **Price** | ~$50-100 depending on board and RAM |
| **Bare-metal precedent** | None found |
| **Community** | Linux-focused -- [Bianbu Linux SDK](https://bianbu-linux.spacemit.com/en/device/peripheral_driver/UART), no bare-metal SDK |

**Strengths.** More powerful SoC -- 8 cores, RVA22 profile with vector extensions. Higher RAM
ceiling. The RISC-V debug framework is supported.

**Weaknesses.** No bare-metal community at all. The boot path requires RSA-signed first-stage
bootloader images with proprietary DDR training firmware, confirmed by [U-Boot SPL documentation](https://docs.u-boot.org/en/latest/board/spacemit/k1-spl.html).
The UART at 0xd4017000 is documented only in [Linux device tree patches](https://lists.openwall.net/linux-kernel/2024/07/04/22),
not in a bare-metal reference. The mini-ITX form factor (Jupiter) is far too large for
enclosure. The signed-boot requirement adds a layer of complexity that the JH7110 boards avoid
entirely.

## Recommendation

**Milk-V Mars, 4 GB RAM.**

The JH7110 SoC has the strongest bare-metal foundation of any available RISC-V board. Both the
VisionFive 2 and the Milk-V Mars share it, so every UART register offset, boot path, and
community finding applies to both. The Mars wins on three counts that matter for the Mantrapod:

1. **Form factor.** The credit-card size fits an enclosure. The VisionFive 2 is nearly twice the
   footprint.
2. **Price.** $50 for 4 GB against $65 for the same RAM on the VisionFive 2.
3. **Recovery button.** UART serial download mode simplifies bare-metal flashing without needing
   a working SPI image first.

The 4 GB RAM tier is more than sufficient -- the freestanding Dimeroll modules use a few kilobytes
of stack and static data.

The SpacemiT K1 is more powerful yet lacks any bare-metal community, requires signed boot images,
and its UART register map comes only from Linux device tree patches rather than a bare-metal
reference. For a project that boots freestanding ELF binaries with no OS, the JH7110's proven
16550-compatible UART and direct boot path are worth more than eight cores.

**What changes in the terrarium build.** The only code change needed for real hardware is a second
linker script with `_start = 0x40000000` instead of `0x80000000`, and board-specific UART clock
initialization. The UART register layout (16550 at 4-byte stride) matches what the terrarium
driver already speaks.

## Acquisition

Board acquisition is a physical action. The Milk-V Mars 4 GB is available from milkv.io, Amazon,
and AliExpress. A USB-to-UART adapter (3.3V TTL, such as an FTDI FT232R or CP2102) is needed for
serial console access through the 40-pin GPIO header.

**SLC gate for Movement 41:** this spec document is filed. Board acquisition is Keaton's word.
