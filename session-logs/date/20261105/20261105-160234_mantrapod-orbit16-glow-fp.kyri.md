format session-log-v1
stamp 20261105.160234
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 16 -- Glow floating-point on RV64FD
prompt Keaton asked to continue the Mantrapod RV64G journey with Orbit 16: F/D extensions, Glow floating-point expressions on RV64FD
think Orbit 16 opens Quest 1.4 -- floating-point and double-precision arithmetic on hardware FPU
think RISC-V FPU is disabled by default at boot; mstatus.FS bits 14:13 must be set in _start before any Zig FP code runs
think li t0, 0x6000; csrs mstatus, t0 sets FS=Dirty which enables FPU without trapping
think built with -mcpu=generic_rv64+m+f+d so compiler emits hardware fadd.d, fsub.d, fmul.d, fdiv.d
think GlowInst uses f64 instead of i32 from glow_m_ext.rye ancestor -- the evaluator stack is [max_eval_stack]f64
think print_f64_2dp adds 0.005 for rounding then extracts integer via @intFromFloat, multiplies remainder by 100 for fractional part
think 2.718 + 0.005 = 2.723 truncates to 2.72 at 2dp -- correct mathematical rounding, updated witness assertion to match
think f64_close uses epsilon 0.005 for comparison rather than exact equality -- IEEE 754 precision limits
think 8 expressions: 3.14 literal, 2.718 literal, (* 3.14 2.0) SLC gate, (+ 1.5 2.5), (- 10.0 3.75), (/ 22.0 7.0), (* (+ 1.0 0.5) 4.0) composite, (/ 355.0 113.0) better pi
obs SLC gate proven: (* 3.14 2.0) = 6.28 ok in QEMU output
obs F/D census: 44 total instructions -- 8 arith (2 fadd.d, 3 fsub.d, 2 fmul.d, 1 fdiv.d), 21 load/store (14 fld, 7 fsd), 5 flt.d, 3 fcvt, 6 fmv, 1 fneg.d
obs ELF size 7808 bytes -- compact for a full FP evaluator with display
obs all 4 witness stages GREEN on metal: CPU features, build, QEMU run (11 proofs), F/D census
obs Quest 1.4 opened -- Orbits 16-20 covering F/D extension applications
file [terrarium/src/glow_fp.rye](../../terrarium/src/glow_fp.rye) Orbit 16 floating-point Glow evaluator -- GlowOp bytecode, f64 stack, print_f64_2dp, FPU enable in _start, 8 expressions, 362 lines
file [terrarium/glow_fp_helper.sh](../../terrarium/glow_fp_helper.sh) build and F/D census helper -- two stages, llvm-objdump census with 13 instruction families
file [terrarium/glow_fp_witness.rish](../../terrarium/glow_fp_witness.rish) 4-stage witness -- CPU features, build, QEMU run with 11 proofs, F/D census
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 16 checked off with census numbers and witness reference
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia advanced 60.098 to 60.099, Orbit 16 description added
recommend keep-going Orbit 17 next -- Caravan FP context save/restore on RV64FD
