format session-log-v1
stamp 20261106.121723
session-header [20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md](20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md)
voice Kyri
title Board selection spec -- Movement 41, Act III begins
prompt kg -- continue Mantrapod RV64G journey, Movement 41
think Movement 41 spec: choose a board, document SoC, RAM, I/O, device tree, UART base, community support quality. SLC gate: board acquired, spec document in active-development.
think Web research covered three candidates: StarFive VisionFive 2 (JH7110 SoC), Milk-V Mars (same JH7110), SpacemiT K1 (8-core X60). Searched for UART base addresses, bare-metal boot paths, community precedent, pricing, and form factor.
think JH7110 boards (VisionFive 2 and Milk-V Mars) have the strongest bare-metal foundation -- UART at 0x10000000 confirmed by U-Boot DEBUG_UART_BASE and NuttX RTOS write-up, 16550-compatible with 4-byte stride, 24 MHz clock. Entry point 0x40000000 differs from QEMU virt's 0x80000000, requiring a second linker script variant.
think SpacemiT K1 lacks any bare-metal community, requires RSA-signed boot images with proprietary DDR training firmware, and its UART at 0xd4017000 is documented only in Linux device tree patches. Eliminated.
think Between the two JH7110 boards: Milk-V Mars wins on form factor (credit-card vs credit-card-plus), price ($50 vs $65 for 4 GB), and recovery button for UART serial download. Same SoC means all bare-metal findings transfer.
obs Recommendation: Milk-V Mars 4 GB. The 16550-compatible UART at the same base address as a standard DesignWare APB UART means the terrarium driver speaks the right protocol already. The only code change for real hardware is a second linker script with entry point 0x40000000 and board-specific UART clock initialization.
obs Board acquisition is a physical action awaiting Keaton's word. The spec document half of the SLC gate is filed. A USB-to-UART adapter (3.3V TTL) is also needed.
orbit round 10 Capricorn -- the verb is stop
file [active-development/date/20261106/20261106-121723_mantrapod-board-selection.md](../../active-development/date/20261106/20261106-121723_mantrapod-board-selection.md) board selection spec: 3 candidates evaluated, Milk-V Mars 4 GB recommended
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Movement 41 spec filed annotation added
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.124, Movements 1-41, Movement 41 description appended
recommend check-in (Claude) -- board acquisition awaits Keaton's word; once acquired, Movement 42 is hello on real UART
