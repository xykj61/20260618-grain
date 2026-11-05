# Grain -- project Makefile
#
# Run from the repository root. Each target names one documented
# command a newcomer can type after cloning.
#
# Prerequisites:
#   vendor/zig-toolchain/zig   (vendored Zig 0.17.0)
#   rishi/bin/rishi             (the Rishi shell -- rye build rishi/)
#   qemu-system-riscv32         (Homebrew: brew install qemu)

.PHONY: terrarium help

STAGE ?= hello

help:
	@echo "Grain Makefile -- run from the repository root"
	@echo ""
	@echo "  make terrarium         build + run RV32I hello on QEMU"
	@echo "  make terrarium STAGE=x build + run a named stage"
	@echo ""
	@echo "Prerequisites: vendor/zig-toolchain/zig, rishi/bin/rishi,"
	@echo "               qemu-system-riscv32"

terrarium:
	@test -x rishi/bin/rishi \
		|| { echo "error: rishi/bin/rishi not found"; exit 1; }
	rishi/bin/rishi run tools/te/terrarium_run.rish $(STAGE)
