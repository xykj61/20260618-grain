format session-log-v1
stamp 20261105.111338
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantrapod RV64G Orbit 7 -- Glow M-extension calculator
prompt land Orbit 7: Glow calculator with mul and div opcodes proving hardware M-extension instructions on RV64IM
think Orbit 7 proves hardware multiply and division. glow_app.rye has mul but no div opcode (only hlf which divides by 2). A focused new source glow_m_ext.rye with 5 opcodes (lit add sub mul div) and 6 expressions exercises both mul and div hardware instructions.
think key design: GlowOp enum with div using @divTrunc for truncating integer division. Six expressions cover direct multiply, direct division, truncating division (100/3=33), and composite expressions mixing mul with add or div.
think build: -mcpu=generic_rv64+m gives +i,+m,+zmmul -- explicit RV64IM. ELF 6816 bytes (smaller than Orbit 6's 8024 for self_compile). Build ~148 ms.
think QEMU run: 6/6 expressions correct. Both SLC gates pass: (* 7 8) = 56 and (/ 144 12) = 12. Run ~118 ms.
think disassembly: llvm-objdump with -mattr=+m confirms 4 mul and 2 div (divw/divuw) hardware instructions. Without -mattr=+m the instructions show as <unknown> -- learned this during Orbit 6.
think witness stages: (1) CPU feature verification via --verbose-llvm-cpu-features, (2) build with timing, (3) QEMU run with SLC gate assertions, (4) disassembly confirming hardware instructions, (5) wall time report.
think Rishi syntax: learned from Orbit 6 that all shell commands must be let var = run ["sh" "-c" "..."] on one line. grep -w instead of grep '\b...\b' because \b does not survive Rishi shell escaping.
obs Orbit 7 is the first Glow program with division. glow_app.rye's hlf opcode divides by 2 only -- glow_m_ext.rye adds general integer division via @divTrunc, which Zig compiles to hardware divw/divuw on RV64M. The focused 325-line source proves M-extension arithmetic independent of the larger boot stack.
obs critical finding from Orbit 6 carries forward: Zig's default baseline_rv64 includes +a,+c,+d,+f,+i,+m -- effectively RV64GC. Quest 1's "RV64I" builds were actually RV64GC. Quest 2's transition is from implicit RV64GC to explicit RV64IM with -mcpu=generic_rv64+m.
file [terrarium/src/glow_m_ext.rye](../../terrarium/src/glow_m_ext.rye) Orbit 7 source: 325 lines, 5 opcodes (lit add sub mul div), 6 expressions, stack-based evaluator
file [terrarium/glow_m_ext_witness.rish](../../terrarium/glow_m_ext_witness.rish) Orbit 7 witness: 5 stages -- features, build, QEMU run, disassembly, timing. GREEN on metal
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/CHECKLIST.md) Orbit 7 checked off with stamp and finding
file [active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md](../../active-tablecloth/20261105-085747_mantrapod-rv64g-journey/PROGRESS.md) Orbit 7 progress entry prepended
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.089 -> 60.090, Mantrapod Orbits 1-7
file [README.md](../../README.md) fascia badge 60.089 -> 60.090
recommend keep-going -- Orbit 8 is next: Amphora seal performance on RV64M. The M extension's hardware multiply feeds Amphora's content-addressing hash. SLC gate: seal a 4 KiB vessel, verify it, report wall time.
