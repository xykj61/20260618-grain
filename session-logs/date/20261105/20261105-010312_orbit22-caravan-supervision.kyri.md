format session-log-v1
stamp 20261105.010312
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 22 -- Caravan process supervision on freestanding RV32I
prompt kg -- continue through the Terrarium boot journey
think Orbit 22 extends Orbit 21's capability model with process supervision -- the supervisor mediates all allocations and faults a dependent that exceeds its Tally budget
think each dependent gets its own Region (Tally budget): worker at 256 bytes, greedy at 64 bytes, supervisor log at 2048 bytes -- three independent budgets
think ProcessState enum (ready, running, stopped, faulted) tracks lifecycle; Supervisor struct holds bounded process array (max 4) and mediates every allocation through request_alloc
think the overbudget path: greedy allocates 32 of 64 bytes, then requests 48 more (would need 80/64), Tally refuses, process transitions to faulted, supervisor stops it
think stopped dependents cannot allocate -- request_alloc checks state before touching the Region, which is the safety wall
think supervisor's own Region (for Mantra logging) bounded at 2048 bytes separately from dependents' Regions -- proven by printing all three tallies at the end
think 11 proof sections in kmain: supervisor domain, spawn worker, worker alloc, spawn greedy, greedy alloc, overbudget fault, stop faulted, stopped refused, worker healthy, table ceiling, separate regions
obs first build failed silently -- _start landed at 0x80035680 instead of 0x80000000 because the naked function was placed after ubsan_rt in .text; fixed by using comptime asm with explicit .section .text.init directive
obs all 11 proofs GREEN on first QEMU run after the .text.init fix -- the supervision model is clean
obs domain registry expanded to max_domains=8 (was 4 in Orbit 21) to accommodate supervisor domain plus dependents plus overflow test
obs inline MantraLog records 10 facts with chain integrity via prev_hash linking and keyed djb2 hash
loom terrarium=caravan_supervision proofs=11 mantra_facts=10 state_hash=0x40a03a12 supervisor_tally_used=540 supervisor_tally_budget=2048 worker_budget=256 greedy_budget=64 max_processes=4
file [terrarium/src/caravan_supervision.rye](../../terrarium/src/caravan_supervision.rye) Orbit 22 SLC gate -- Caravan process supervision with per-dependent Tally budgets, overbudget faulting, stopped refusal, process table ceiling
file [terrarium/caravan_supervision_witness.rish](../../terrarium/caravan_supervision_witness.rish) Orbit 22 Rishi witness -- 11 proof sections plus Mantra and Tally assertions
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 22 marked complete
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.079 to 60.080
recommend keep-going -- Orbit 23 lands Steward, the root supervisor that reads a Brix manifest and brings up domains
