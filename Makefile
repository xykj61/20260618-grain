# Grain -- project Makefile
#
# Run from the repository root. Each target names one documented
# command a newcomer can type after cloning.
#
# Prerequisites:
#   vendor/zig-toolchain/zig   (vendored Zig 0.17.0)
#   rishi/bin/rishi             (the Rishi shell -- rye build rishi/)
#   qemu-system-riscv32         (Homebrew: brew install qemu)

.PHONY: terrarium terrarium-build terrarium-app help

STAGE ?= hello

help:
	@echo "Grain Makefile -- run from the repository root"
	@echo ""
	@echo "  make terrarium          build + run RV32I hello on QEMU"
	@echo "  make terrarium STAGE=x  build + run a named stage"
	@echo "  make terrarium-build    build the RV32I ELF only"
	@echo "  make terrarium-app      build + run the macOS Terrarium window"
	@echo ""
	@echo "STAGE searches terrarium/src/ then aurora/src/."
	@echo ""
	@echo "Prerequisites: vendor/zig-toolchain/zig, rishi/bin/rishi,"
	@echo "               qemu-system-riscv32, swiftc (Xcode)"

terrarium:
	@test -x rishi/bin/rishi \
		|| { echo "error: rishi/bin/rishi not found"; exit 1; }
	rishi/bin/rishi run tools/te/terrarium_run.rish $(STAGE)

terrarium-build:
	@mkdir -p terrarium/.build
	@if [ -f terrarium/src/$(STAGE).rye ]; then \
		SRC=terrarium/src/$(STAGE).rye; \
		LD=terrarium/layout.ld; \
	elif [ -f aurora/src/$(STAGE).rye ]; then \
		SRC=aurora/src/$(STAGE).rye; \
		LD=aurora/layout.ld; \
	else \
		echo "error: no source for stage '$(STAGE)'"; exit 1; \
	fi; \
	env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye build \
		$$SRC \
		-target riscv32-freestanding-none -fno-entry \
		-T $$LD \
		-femit-bin=terrarium/.build/$(STAGE).elf

terrarium-app: terrarium-build
	@mkdir -p terrarium/.build
	swiftc -o terrarium/.build/Terrarium \
		terrarium/app/main.swift \
		-framework AppKit
	terrarium/.build/Terrarium $(STAGE)
