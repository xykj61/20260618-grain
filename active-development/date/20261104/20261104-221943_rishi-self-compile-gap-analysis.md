# Rishi Bootstrap and Self-Compile Gap Analysis

**Stamp:** `20261104.221943`
**Status:** Living -- checkable
**Room:** active-development (scoping for Orbit 15)
**Style:** Gauge at Meter setting

## What this document is

A gap analysis between the current Glow-to-RV32I code generator
(`terrarium/tools/glow_to_rv32i.sh`, 290 lines of shell) and what
self-compilation on freestanding RV32I would require. The SLC gate for
Orbit 14 asks for this survey alongside the boot sequencer proof.

---

## The code generator today

The Glow-to-RV32I code generator is a 290-line POSIX shell script that
reads a `.glow` source file and emits a `.S` assembly file. It handles
six Glow forms:

| Form | Meaning | Lines |
|------|---------|-------|
| `^- @u32 <N>` | cast literal | ~15 |
| `=/ <name> <N>` | face binding | ~20 |
| `%- <op> <name>` | stdlib call (double, inc, dec, square, half, negate) | ~45 |
| `?: (gth a b) T F` | conditional | ~35 |
| `/+ <lib>` | library import (parsed, ignored) | ~5 |
| bare `<N>` | literal integer | ~10 |

It uses 59 calls to shell utilities (`sed`, `awk`, `grep`, `tr`, `cat`,
`echo`, `printf`), 10 shell control-flow constructs (`while`, `for`,
`if`, `case`, `read`, `local`), and an intermediate `.parse` file for
the two-pass pipeline.

## The hosted Rishi interpreter today

The full Rishi interpreter is 5,014 lines of Rye across 5 source files:

| File | Lines | Purpose |
|------|-------|---------|
| `main.rye` | 3,760 | interpreter core: parser, evaluator, REPL, file runner |
| `match.rye` | 1,024 | pattern matching |
| `parse_int.rye` | 95 | integer parsing |
| `tally_copy.rye` | 78 | bounded memory copy |
| `tally_str_repeat.rye` | 57 | string repetition |

**Hosted dependencies** (features that require an OS and cannot run
freestanding on RV32I without replacement):

| Dependency | References | What it does |
|------------|-----------|--------------|
| `std.process.*` | 21 | spawn child processes (`run` command) |
| `std.Io.*` | 28 | file handles, stdout, stderr |
| `std.mem.*` | 265 | string comparison, slicing, allocation |
| `std.fmt.*` | ~20 | number-to-string formatting |
| `std.posix.*` | ~15 | signal handling (SIGHUP, SIGINT, SIGTERM) |
| `std.atomic.*` | 2 | pending signal flag |
| `allocator.alloc` / `garden` | 27 | dynamic heap allocation |
| File I/O (`read-file`, `write-file`, `list-dir`) | 12 | filesystem access |

## Gap: code generator to self-compilation

For the code generator to compile itself on RV32I, it would need to
handle every feature it uses. Here is what is missing, measured against
the shell script's actual usage:

### Missing Glow language features

| Feature | Used by generator | Current backend support | Gap |
|---------|-------------------|------------------------|-----|
| String processing (concatenation, comparison) | ~40 sites | none | **full gap** |
| Variable-length string buffers | ~15 sites | none | **full gap** |
| File I/O (read source, write output) | 4 sites | none | **full gap** -- no filesystem on bare RV32I |
| Shell command execution (`sed`, `awk`, `grep`) | 59 sites | none | **full gap** -- no shell on bare RV32I |
| Loops (`while read`, `for`) | ~10 sites | none | **full gap** |
| Pattern matching / parsing | ~25 sites | none | **full gap** |
| Multi-line string handling | ~8 sites | none | **full gap** |
| Error handling (exit codes, conditionals) | ~12 sites | partial (`?:` with `gth`) | **large gap** |
| Arithmetic beyond add/sub | ~5 sites | partial (no mul/div in ISA) | **small gap** -- repeated add/sub proven |

### Missing Rishi features for freestanding boot orchestration

| Feature | Hosted lines | Freestanding equivalent | Gap |
|---------|-------------|------------------------|-----|
| `run` (process spawn) | ~80 | call Rye function directly | **architecture change** -- no processes on bare metal |
| `read-file` / `write-file` | ~80 | UART or Amphora vessel | **architecture change** -- no filesystem |
| `list-dir` | ~50 | not applicable | **remove** |
| `env` | ~20 | compile-time constant | **small gap** |
| `say` / `print` | ~30 | UART write (already proven) | **done** -- Orbits 3-13 proved this |
| `let` bindings | ~60 | stack variables (already proven) | **done** |
| `if/then/else` | ~40 | branch instructions (already proven) | **done** |
| `for-each` | ~30 | loop with counter (already proven) | **done** |
| `assert` | ~25 | halt on failure (already proven) | **done** |
| Integer arithmetic | ~40 | RV32I add/sub (already proven) | **done** |
| String interpolation | ~50 | UART print chain | **medium gap** |
| `map` / `where` | ~40 | bounded loop with filter | **medium gap** |
| Signal handling | ~30 | not applicable on bare metal | **remove** |
| Dynamic allocation (`garden`) | 27 sites | Tally arena (Orbit 16) | **blocked on Orbit 16** |
| Pattern matching (`match.rye`) | 1,024 lines | freestanding subset | **large gap** |

## Summary: what is proven and what remains

**Proven in Orbits 3-14:**
- UART print (string and u32) -- freestanding on RV32I
- Bounded arrays with invariant assertions -- freestanding on RV32I
- Stage sequencing with ok/not-ok -- freestanding on RV32I (`rishi_boot.rye`)
- Glow-to-RV32I compilation of 6 forms -- 8 programs GREEN
- Function pointers for stage dispatch -- freestanding on RV32I

**The honest gap for self-compilation (Orbit 15):**

The current code generator is a shell script. Self-compilation on bare
RV32I means the compiler must be rewritten in a language that compiles
to freestanding RV32I (Rye or Glow itself). The shell utilities (`sed`,
`awk`, `grep`) must become string-processing functions in that language.

**Minimum viable self-compile path:**
1. Rewrite the code generator in Rye (replacing 290 lines of shell with
   ~400-600 lines of Rye that parse Glow source and emit `.S` text)
2. The Rye rewrite reads source from an Amphora vessel or embedded
   constant (no filesystem needed)
3. The Rye rewrite emits assembly to a UART or memory buffer
4. Cross-compile the Rye rewrite to freestanding RV32I
5. Run on QEMU; the output assembly is captured from UART
6. Assemble the captured output; the result matches the original ELF

**Estimated cost:** 2-3 orbits for the Rye rewrite, 1 orbit for the
freestanding proof, 1 orbit for the hash comparison. Orbit 15's SLC
gate asks for the keystone proof; the path above reaches it.

**What Orbit 15 does NOT require:**
- Full Rishi interpreter on bare metal (5,014 lines)
- File I/O, process spawning, or signal handling
- Dynamic heap allocation (the compiler's working set is bounded)
- Pattern matching beyond simple string comparison

The self-compile proof is narrower than a full Rishi port. It proves
that the compiler can rebuild itself, and that identity holds across
the rebuild. The rest of Rishi arrives with Caravan in Quest 1.5.

---

Related: `tablecloth/20261104-161857_terrarium-boot-journey/CHECKLIST.md` Orbit 14
