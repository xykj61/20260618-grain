/* terrarium/layout64.ld -- where a freestanding RV64I stage lives.
 *
 * QEMU's `virt` machine for riscv64 begins executing at the base
 * of RAM, 0x8000_0000 -- the same address as the 32-bit machine.
 * `.text.init` is placed first so the very first instruction is
 * the one that gives the hart its stack. Orphan sections the
 * toolchain may emit are discarded, so nothing can slip in ahead
 * of `_start` at the reset address. Small-data sections are
 * folded into their parents. */
ENTRY(_start)
SECTIONS {
  . = 0x80000000;
  .text : { KEEP(*(.text.init)) *(.text*) }
  .rodata : { *(.rodata*) *(.srodata*) }
  .data : { *(.data*) *(.sdata*) }
  .bss : { *(.bss*) *(.sbss*) *(COMMON) }
  /DISCARD/ : {
    *(.eh_frame) *(.eh_frame_hdr)
    *(.riscv.attributes) *(.comment)
  }
}
