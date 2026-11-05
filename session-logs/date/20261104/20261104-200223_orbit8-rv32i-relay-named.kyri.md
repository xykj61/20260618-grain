format session-log-v1
stamp 20261104.200223
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
title Orbit 8 -- RV32I relay and named stages
prompt kg -- continue the Terrarium boot journey
orbit round 3 Gemini -- the air that moves between
think relay.rye uses usize for CSR-width values (hartid, misa) which is correct for freestanding -- on RV32I usize becomes u32, matching the 32-bit register width
think named.rye imports std.crypto.hash.sha3.Sha3_512 which uses 64-bit internal state, yet Zig's implementation handles this on 32-bit targets through software -- the question is whether it compiles and produces correct output
think both files already built and ran on RV32I with zero code changes after Orbit 7 switched the build pipeline target
obs relay GREEN on RV32I: three-stage relay wakes hart 0, proves base integer + compressed ISA, rests cleanly with exit 0
obs named GREEN on RV32I: SHA3-512 of "named on the bare hart" produces 9c9f6b69ba766938dda360b25638dc54 prefix, byte-for-byte match with hosted openssl dgst -sha3-512
obs the module readiness survey's verdict confirmed again -- Aurora sources were already width-independent; the Orbit 7 build pipeline change was all both stages needed
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 8 marked done
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.065 -> 60.066; RV32I relay and named stages added to landed list
recommend keep-going -- Orbit 9 (Terrarium display integration) is next: bring QEMU output into the Terrarium window with styled display, font rendering, and scroll
