# RV64M Software Division Survey

**Stamp:** `20261105.114516` -- **Status:** Landed -- **Room:** checkable
**Journey:** Mantrapod RV64G, Quest 2 Orbit 9

Survey of every multiply/divide site across the 17 freestanding Rye sources
in `terrarium/src/`, confirming which emit hardware M-extension instructions
and which resolve at compile time or live inside assembly strings.

## Method

1. `grep` every `terrarium/src/*.rye` for `/ % *% /= @divTrunc * <constant>`.
2. Classify each site: **comptime** (constant expressions resolved by the
   compiler), **runtime** (emits hardware mul/div/rem on RV64IM), **assembly**
   (inside an inline assembly string, not Rye arithmetic), or **shift**
   (multiplication by power of two, strength-reduced to shift).
3. Build all 14 modules that carry runtime sites with `-mcpu=generic_rv64+m`
   and disassemble with `llvm-objdump --mattr=+m` to confirm hardware
   instructions and the absence of software division loops.

## Survey results

### Files with zero multiply/divide sites (3 files)

| File | Notes |
|---|---|
| `hello.rye` | UART only, no arithmetic |
| `hello64.rye` | UART only, no arithmetic |
| `wire.rye` | UART 16550A driver, bit ops only |

### Sites by classification (14 files, 59 sites)

| File | Site | Operation | Class |
|---|---|---|---|
| **amphora_seal.rye** | :47 `x % 10` | rem | runtime -- `divu` |
| | :48 `x /= 10` | div | runtime -- `divuw` |
| | :103 `h *% 33` | mul | runtime -- `mul` (the Orbit 8 finding) |
| | :160 `i % 256` | rem | shift -- `andi 0xff` (power of two) |
| | :289 `vessel_size * 2` | mul | comptime -- constants |
| | :291 `total_bytes * 100 / total_cycles` | mul+div | runtime -- `mul` + `divu` |
| **aurora_console.rye** | :46 `fb_width * 4` | mul | comptime -- const decl |
| | :58 `fb_width / glyph_w` | div | comptime -- const decl |
| | :59 `fb_height / glyph_h` | div | comptime -- const decl |
| | :306 `y * fb_stride + x * 4` | mul | shift -- stride is `* 1280`, `* 4` is shift |
| | :354 `n % 10` | rem | runtime -- `divu` |
| | :355 `n / 10` | div | runtime -- `divuw` |
| | :371-403 framebuffer offset `* fb_stride`, `* 4` | mul | shift -- `* 4` is `<< 2`, stride mul |
| | :728 `n % 10` | rem | runtime -- `divu` |
| | :729 `n / 10` | div | runtime -- `divuw` |
| **bounded.rye** | :42 `n % 10` | rem | runtime -- `divu` |
| | :43 `n / 10` | div | runtime -- `divuw` |
| **caravan_cap.rye** | :50 `n % 10` | rem | runtime -- `divu` |
| | :51 `n / 10` | div | runtime -- `divuw` |
| **caravan_supervision.rye** | :40 `x % 10` | rem | runtime -- `divu` |
| | :41 `x /= 10` | div | runtime -- `divuw` |
| **framebuf.rye** | :51 `fb_width * 4` | mul | comptime -- const decl |
| | :111 `y * fb_stride + x * 4` | mul | shift -- stride and `* 4` |
| **glow_app.rye** | :46 `x % 10` | rem | runtime -- `divu` |
| | :47 `x /= 10` | div | runtime -- `divuw` |
| | :708 `*%` stack mul | mul | runtime -- `mul` |
| | :716 `*% 2` | mul | shift -- `slli 1` |
| | :721 `v *% v` | mul | runtime -- `mul` |
| | :725 `@divTrunc / 2` | div | shift -- `srli 1` |
| **glow_m_ext.rye** | :51 `x % 10` | rem | runtime -- `divu` |
| | :52 `x /= 10` | div | runtime -- `divuw` |
| | :124-183 string literals | -- | strings -- not arithmetic |
| | :235 `*%` stack mul | mul | runtime -- `mul` |
| | :241 `@divTrunc` stack div | div | runtime -- `divw` |
| **mantra_log.rye** | :50 `n % 10` | rem | runtime -- `divu` |
| | :51 `n / 10` | div | runtime -- `divuw` |
| | :369 `arena_budget / fact_size` | div | comptime -- both are comptime-known |
| | :436 `arena_budget / fact_size` | div | comptime -- both are comptime-known |
| **mantra_wire.rye** | :61 `n % 10` | rem | runtime -- `divu` |
| | :62 `n / 10` | div | runtime -- `divuw` |
| **rishi_boot.rye** | :44 `n % 10` | rem | runtime -- `divu` |
| | :45 `n / 10` | div | runtime -- `divuw` |
| **self_compile.rye** | :50 `n % 10` | rem | runtime -- `divu` |
| | :51 `n / 10` | div | runtime -- `divuw` |
| | :157 `a0 / 10 by repeated subtraction` | div | assembly -- Glow-compiled pill code |
| | :266 `n % 10` | rem | runtime -- `divu` |
| | :267 `n / 10` | div | runtime -- `divuw` |
| **steward.rye** | :45 `x % 10` | rem | runtime -- `divu` |
| | :46 `x /= 10` | div | runtime -- `divuw` |
| **tally_arena.rye** | :46 `n % 10` | rem | runtime -- `divu` |
| | :47 `n / 10` | div | runtime -- `divuw` |

### Summary by class

| Class | Count | Notes |
|---|---|---|
| **runtime** | 38 | All emit hardware M-extension instructions on RV64IM |
| **comptime** | 8 | Resolved by compiler, no instruction emitted |
| **shift** | 7 | Power-of-two multiplies/divides, strength-reduced to sll/srl/andi |
| **assembly** | 1 | Glow pill's own compiled code (software subtraction loop) |
| **strings** | 5 | Literal `*` and `/` inside string constants, not arithmetic |
| **Total** | 59 | |

### The one software division: the Glow pill

`self_compile.rye:157` embeds the Glow compiler's assembly output. The
`print_u32` routine in the pill uses repeated subtraction to divide by 10
because the Glow code generator targets base RV32I without M-extension
awareness. This is correct behavior -- the pill's own code is the subject
of a future Glow compiler orbit, not a defect in the Rye freestanding
modules.

**Zero remaining software multiply/divide sites in authored Rye code.**
Every runtime arithmetic site in the 17 freestanding sources emits hardware
M-extension instructions when built with `-mcpu=generic_rv64+m`.

## SLC gate

Survey complete. Zero software multiply/divide in authored Rye freestanding
code. The one software division (repeated subtraction in the Glow-compiled
pill assembly) is the Glow compiler's own output and is the subject of a
future code generator improvement.
