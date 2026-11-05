format session-log-v1
stamp 20261105.004644
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 21 -- Caravan capability model on freestanding RV32I
prompt kg -- continue through the Terrarium boot journey
think Orbit 21 opens Quest 1.5 (The Living World) with the Caravan capability model -- the microkernel's access control on freestanding RV32I
think distilled from 111 hosted Caravan .rye files into 5 portable kernel object types: untyped, tcb, endpoint, notification, cap_table
think rights mask uses 3 bits in u32 -- READ=1, WRITE=2, EXECUTE=4 -- and W xor X falls naturally from the grammar since exercise checks requested rights against the mask
think bounded leases count down by tick; at zero the capability auto-expires and exercise is refused
think confer grants a capability with a rights mask and lease countdown; revoke withdraws it; exercise performs a two-wall check (active flag + rights)
think cap table bounded at 8 slots per domain, domain registry at 4 domains -- both ceilings proven by REFUSED messages on overflow
think 9 proof sections in kmain: domain creation, confer, exercise R+W, rights wall (X refused), tick/expire, post-expiry refusal, revoke, cap table ceiling, domain registry ceiling
think inline MantraLog records 11 facts with chain integrity via prev_hash linking and keyed djb2 hash
obs first compile needed two fixes: unused return values from confer() and registry.create() -- Zig requires discarding non-void returns with _ =
obs Rishi witness syntax learned from tame_boot_witness.rish: use let (not set), run ["sh" "-c" "..."] for complex commands, result.out contains "string" (not contains result.out "string")
obs all 9 proofs GREEN on first QEMU run after the compile fixes -- the model is clean
obs state hash 0xcb853e4a across 11 Mantra facts, 880 of 4096 Tally bytes used -- the capability system fits comfortably inside the existing budget
loom terrarium=caravan_cap proofs=9 mantra_facts=11 state_hash=0xcb853e4a tally_used=880 tally_budget=4096 domains=2 caps_per_domain=8 max_domains=4
file [terrarium/src/caravan_cap.rye](../../terrarium/src/caravan_cap.rye) Orbit 21 SLC gate -- Caravan capability model with 5 object types, rights masks, bounded leases, confer/revoke/exercise
file [terrarium/caravan_cap_witness.rish](../../terrarium/caravan_cap_witness.rish) Orbit 21 Rishi witness -- 9 proof sections plus Mantra and Tally assertions
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 21 marked complete
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.078 to 60.079
recommend keep-going -- Orbit 22 lands Caravan process supervision: a dependent that exceeds its lease or allocation budget is stopped
