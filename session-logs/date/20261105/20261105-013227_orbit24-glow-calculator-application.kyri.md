format session-log-v1
stamp 20261105.013227
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 24 -- first Grain application: Glow calculator on freestanding RV32I
prompt kg -- continue through the Terrarium boot journey
think Orbit 24 lands the first Grain application -- a Glow expression calculator running in userspace under Caravan supervision on freestanding RV32I
think on freestanding without a keyboard, the calculator processes a static manifest of 10 GlowProgram entries -- what Brix evaluates to when there is no interactive I/O
think the Glow evaluator is stack-based with 9 operations (lit, add, sub, mul, neg, dbl, sqr, hlf, cnd), a bounded stack of 16 slots, and programs bounded at 8 instructions
think hlf uses @divTrunc(val, 2) for truncating integer division on RV32I -- Zig provides software division for freestanding targets
think the calculator runs inside a 'calculator' domain (id=2) under Caravan supervision with endpoint RW and notification R capabilities, both with lease=500
think each expression evaluation allocates 4 bytes from the calculator's Tally region (1024 byte budget) to prove allocation is bounded per computation
think the compound expression (+ (double 15) (half 24)) exercises multiple stack operations in sequence -- lit 15, dbl, lit 24, hlf, add -- proving the evaluator handles real Glow composition
think 10 programs test all 9 operations plus compound expressions: literal, add, double, square, sub-after-square, half, negate, conditional-true, conditional-false, and compound
obs clean first build and first QEMU run -- the evaluator's wrapping arithmetic (+%, -%, *%) keeps overflow safe on 32-bit
obs print_i32 handles negative numbers by detecting the sign bit and using @bitCast on the two's complement negation, avoiding undefined behavior on i32 minimum
obs 16 Mantra facts: 4 from boot (caravan-root, steward, manifest-read, calculator-domain) + 2 from capabilities + 10 from expression evaluations -- each evaluation is a recorded fact
loom terrarium=glow_app proofs=7 expressions=10 correct=10 glow_ops=9 stack_slots=16 calc_tally_used=40 calc_tally_budget=1024 steward_tally_used=467 steward_tally_budget=4096 mantra_facts=16 state_hash=0x04ace710 domains=3 capabilities=2
file [terrarium/src/glow_app.rye](../../terrarium/src/glow_app.rye) Orbit 24 SLC gate -- Glow stack-based calculator with 9 operations and 10 test expressions, running in calculator domain under Caravan supervision, 7 proofs
file [terrarium/glow_app_witness.rish](../../terrarium/glow_app_witness.rish) Orbit 24 Rishi witness -- 7 proof sections plus Tally, registry, and summary assertions
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 24 marked complete
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.081 to 60.082
recommend keep-going -- Orbit 25 lands the full boot witness and RV64G horizon scoping, the final orbit of this journey
