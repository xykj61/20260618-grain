# Mantrapod RV64G Journey -- Progress Log

**Append-only.** Each entry records a landed milestone with its stamp and witness.

---

| Stamp | Milestone | Witness |
|---|---|---|
| `20261105.095422` | Orbit 3 GREEN -- Tally arena on RV64I. Region allocates, hits 2048-byte ceiling, receives OutOfBounds. Gardens refuses DuplicateName, NameEmpty, Full. All `u32` budgets and indices portable with zero source changes. | `terrarium/tally64_witness.rish` |
| `20261105.094456` | Orbit 2 GREEN -- pill identity on RV64I. djb2 hash `0x079080D9` matches sealed constant identically -- all hash computation uses `u32` arithmetic over string constants, so widening to 64-bit registers changes nothing. Zero source changes to `self_compile.rye`. | `terrarium/pill64_witness.rish` |
| `20261105.093245` | Orbit 1 GREEN -- RV64I build target + UART hello. medany code model discovered: `lui` sign-extends on RV64 so medlow cannot reach 0x80000000. `-OReleaseSmall -mcmodel=medany` is the standing RV64 recipe. | `terrarium/hello64_witness.rish` |
| `20261105.085747` | Board opened; 50 orbits across 10 quests in 3 acts scoped | -- |
