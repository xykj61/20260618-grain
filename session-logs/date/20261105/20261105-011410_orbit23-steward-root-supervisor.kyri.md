format session-log-v1
stamp 20261105.011410
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Orbit 23 -- Steward root supervisor on freestanding RV32I
prompt kg -- continue through the Terrarium boot journey
think Orbit 23 lands Steward, the root supervisor that reads a Brix manifest and brings up domains -- the first process Caravan supervises
think a Brix manifest on freestanding is a static const array of ManifestEntry structs, each naming a domain, its Tally budget, its memory region base, and its initial capabilities (object type, rights mask, lease ticks)
think the manifest carries two entries: console (endpoint RW lease=200, notification R lease=200, 512 byte budget at 0x80181000) and compute (tcb RX lease=100, 256 byte budget at 0x80181200)
think Steward walks the manifest, creates each domain in the registry via DomainRegistry.create, confers capabilities from the manifest via the confer function, and spawns each under the Supervisor
think boot order: caravan-root domain (id=0) -> steward domain (id=1, granted cap_table RW lease=1000 from root) -> steward reads manifest -> console UP (id=2) -> compute UP (id=3)
think 9 proof sections: caravan root domain, steward domain, brix manifest read, steward boots manifest, verify running, manifest domains allocate, capability verification, registry census, mantra integrity
think steward's own Tally region at 4096 bytes (larger than Orbit 22's 2048) to accommodate the manifest-driven boot events -- ended at 324 of 4096 used
obs clean first build and first QEMU run -- the comptime asm .text.init entry point pattern continues to work reliably for larger binaries
obs 4 domains total in registry (caravan-root, steward, console, compute) proves the manifest-driven boot creates distinct domains rather than collapsing them
obs ManifestCap struct keeps the manifest self-describing -- each entry carries its own cap list rather than relying on a separate table
loom terrarium=steward proofs=9 mantra_facts=10 state_hash=0x4c380065 steward_tally_used=324 steward_tally_budget=4096 manifest_entries=2 domains_total=4 console_budget=512 compute_budget=256
file [terrarium/src/steward.rye](../../terrarium/src/steward.rye) Orbit 23 SLC gate -- Steward root supervisor with Brix manifest, 2-entry manifest boots console and compute domains, 9 proofs
file [terrarium/steward_witness.rish](../../terrarium/steward_witness.rish) Orbit 23 Rishi witness -- 9 proof sections plus Mantra and Tally assertions
file [tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md](../../tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md) Orbit 23 marked complete
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.080 to 60.081
recommend keep-going -- Orbit 24 lands the first Grain application, a Glow calculator or REPL running in userspace under Caravan supervision
