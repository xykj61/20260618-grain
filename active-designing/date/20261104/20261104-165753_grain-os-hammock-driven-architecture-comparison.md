# grain-os Hammock-Driven Architecture Comparison

**Stamp:** `20261104.165753`
**Voice:** Kyri
**Style:** Gauge at Field
**Status:** Living
**Room:** Checkable -- every claim names its source file in grain-os or this tree

---

## What this is

A side-by-side comparison of DJINN's `node777/grain-os` (a working Zig capability
microkernel at Phase 9 hardening) against this tree's own architecture, following Rich
Hickey's Hammock-Driven-Design questions rubric from `gratitude/hammock-driven-development.md`.
The comparison covers every shared module name, names the fork decisions where the two
trees diverge, and closes with questions for Keaton and DJINN to resolve.

**Source:** `gratitude/grain-os/` (gitlink submodule, committed `20261104`). All grain-os
citations reference files in that submodule. This tree's citations reference their living paths.

---

## 1. The Problem -- What are we trying to solve?

Both trees answer the same question: **a personal computer whose owner holds the keys, where
authority is explicit, the system is a value, and an AI agent can operate it safely.**

grain-os states it as five qualities (ARCHITECTURE.md section 1): intimate, social, secure,
clear, loyal. This tree states it through foundations: custody-first, the grain and the crossing,
lila and the long return.

**The shared thesis:** agents need narrow, typed, revocable authority and a legible system --
not root shells that scrape text.

---

## 2. What do we know? -- Facts from each tree

### ISA target

| | grain-os | This tree |
|---|---|---|
| **Primary ISA** | **rv64** (riscv64, Sv39) | **rv32i** (the minimal integer-only subset) |
| **Secondary** | aarch64 (kernel suite passes on QEMU Cortex-A72); x86_64 planned | None yet |
| **Source** | `caravan/src/arch/riscv64/` | `context/specs/` RV32I target; Terrarium |

**Fork decision %1:** rv64 vs rv32i. grain-os chose rv64 because real hardware (StarFive
VisionFive 2, Milk-V Jupiter, SiFive HiFive Premier) ships rv64. This tree chose rv32i as
the minimal target a small farm's device can afford, where a bound exists so the program
runs on a machine a small grower can own.

### Implementation language

| | grain-os | This tree |
|---|---|---|
| **Kernel and system** | **Zig 0.17.0** exactly | **Rye** (Zig-descended, authored here) |
| **Manifest language** | **Brix** evaluating to **ZON** | **Brix** evaluating to **Kyri** |
| **Shell/scripting** | Typed pipelines over capabilities (proposed) | **Glow** (authored here) + **Rishi** |
| **Notation** | ZON (Zig Object Notation) | **Kyri** (plain key-value, one field per line) |

**Fork decision %2:** Pure Zig vs Rye/Glow. DJINN built everything in Zig without adopting
Glow or Rye (GLOSSARY.md: "From the owner's other project; not adopted"). This tree's whole
language stack -- Rye, Glow, Rishi, Brix, Kyri -- is authored here and is the project's
identity. The question is whether the working kernel should be Zig (proven, DJINN has it
running) or Rye (ours, carrying TAME guidance and the value model).

### Implementation completeness

| | grain-os | This tree |
|---|---|---|
| **Kernel** | **Working.** Phase 9 hardening. Boots on QEMU, runs SMP, passes fuzz and model checking | **Design.** Caravan architecture specified; partial Rye implementation |
| **IPC measured** | yield ~660 instructions, call/reply ~2,070 instructions (QEMU one hart) | Not yet measured |
| **System layer** | Steward, Registry, Ledger, typed IDL -- all working | Designs and partial implementations |
| **Desktop** | Surf compositor, shell, dock -- boots to a desktop | Brushstroke surface; Skate/Surf frame grid |
| **Browser** | grain-emu: 72KB WASM, 120-140 MIPS in Chromium, boots full system | Terrarium: proposed, not yet built |
| **Networking** | Mycelium (virtio-net, UDP/IP), Comlink (Noise XX sessions), two-instance test passing | Comlink and Mycelium designed; partial Rye |
| **Storage** | Tablecloth (crash-safe, sealed objects, Argon2id), Kumara (Ed25519), Ledger (signed chain) | Tablecloth and Kumara designed; Amphora (sealed vessels) in Rye |
| **Boot** | Aurora (A/B generations, content-chunked, trial boot with fallback) | Aurora design; six proven stages on QEMU RV64 |
| **Agent interface** | Envoy: discover/plan/apply/undo/ask/observe, MCP bridge, harness | Not yet built |
| **Drivers** | virtio-console, virtio-rng, virtio-gpu, virtio-input, virtio-net, virtio-blk, NVMe, Intel e1000, xHCI USB, Bochs framebuffer | None yet |

---

## 3. Module-by-module comparison -- the fourteen shared names

### Caravan (the microkernel)

| | grain-os | This tree |
|---|---|---|
| **Object types** | 12: Untyped, CNode, Thread, PageTable, Frame, Endpoint, Signal, SchedContext, Lease, Irq, IrqControl/SchedControl/DebugConsole, Channel (planned) | Designed: capabilities, leases, dependents; `caravan/` has 136 tracked files |
| **Capability size** | 16 bytes: object index (u32), generation (u32), rights (u16), protocol (u16), badge (u32) | Not yet specified at this precision |
| **Revocation** | Generation-based (bump generation invalidates all caps at once) + Leases for selective (up to 4 levels). No derivation tree -- a deliberate departure from seL4 | Designed: revocation through leases |
| **Kernel heap** | None. All memory from Untyped regions with double-ended allocation | Designed: no kernel heap (TAME: bound everything) |
| **Scheduling** | MCS (mixed criticality scheduling contexts), preemption, round robin, throttling, donation to passive servers | Designed: MCS scheduling |
| **Syscalls** | 10 | Not yet counted |
| **Core design** | `handle(hart, now, event)` behind a comptime arch interface; deterministic state machine | Event door designed; deterministic by intent |
| **SMP** | Working: secondary harts via SBI HSM, per-hart run queues, kernel lock, IPI kicks | Not yet |
| **Testing** | Fuzz every kernel entry, model checker (every call order in 7 IPC/revocation scenarios), scenario tests, deterministic simulator | Witness-based; no fuzz or model checking yet |

**Question for Keaton and DJINN:** grain-os's generation-based revocation (no derivation tree)
is a strong departure from seL4. CAPABILITY_MODEL.md's Question 1 asks whether bumping a
generation can ever leave a capability reachable through an alias the kernel does not track.
Has DJINN's model checker covered this case? What did the 10^6 random-step simulator find?

### Aurora (the boot)

| | grain-os | This tree |
|---|---|---|
| **Shape** | Content-chunked system images, two-slot superblock, trial boot with automatic fallback, A/B generations pushed through Envoy | Six proven stages on QEMU RV64; design for generation-based boot |
| **Measured boot** | Yes: kernel through Steward, every domain, Ledger; attestations signed by identity and checked by independent implementation | Not yet |

**Question:** grain-os's Aurora upgrades through Envoy (the AI agent pushes a generation).
This tree's Aurora is designed around the same pattern. Do we adopt grain-os's exact protocol
(`upload` with deduplication, `switch_to`/`rollback`) or redesign for our own value model?

### Tablecloth (the content store)

| | grain-os | This tree |
|---|---|---|
| **Shape** | Two superblock slots, append-only log, crash-safe (one superblock write per commit), public and sealed objects (XChaCha20-Poly1305), Argon2id-wrapped master key, Mantra names and tips, circular log with reclaim | Designed; project boards in `tablecloth/` |
| **Crash safety** | Proven: crash simulator cuts power at every device operation of an upgrade-and-rollback scenario | Not yet tested |
| **Driver** | virtio-blk | Not yet |

**Question:** Tablecloth's crash safety is proven by a simulator that cuts power at every
device operation. This is the TigerBeetle-inspired DST approach. Should our Tablecloth adopt
the same crash model, or do we need a different one for rv32i's memory constraints?

### Kumara (identity)

| | grain-os | This tree |
|---|---|---|
| **Shape** | Ed25519 identity, sealed in the store, named by three words from a 1024-word bank; signatures bind who asked | Ed25519 identity designed; `kumara/` has 6 tracked files |
| **Key storage** | Sealed in Tablecloth under the owner's passphrase | Designed: shard modules in `vault/` |

**Question:** grain-os's three-word names from a 1024-word bank give `1024^3` = ~1 billion
names. Is that sufficient for the network scale this tree envisions? Our Kumara design may
want a different word bank size or format.

### Brix (the manifest language)

| | grain-os | This tree |
|---|---|---|
| **Evaluates to** | **ZON** (Zig Object Notation) | **Kyri** (plain key-value notation) |
| **Features** | Blocks, templates (`like` for inheritance), units (`1ms`, `4s`, `128KiB`), comments, total deterministic evaluation, no I/O, no recursion | Designed: composition language declaring systems |
| **Error messages** | File, line, column, and fix suggestions | Not yet built |
| **Schema** | `grain/manifest/schema.zig` validates at compile time and run time | Designed but not yet implemented |

**Fork decision %3:** ZON vs Kyri as Brix's output. grain-os chose ZON because Zig's own
build system reads it natively, so one toolchain handles manifests end to end. This tree chose
Kyri because the notation is authored here and carries the voice's own name. GLOSSARY.md notes:
"Until shared, 'evaluates to plain Kyri' reads as 'evaluates to plain data.'"

### Steward (the root task / manifest builder)

| | grain-os | This tree |
|---|---|---|
| **Shape** | Root task loaded from ELF embedded in kernel; builds domains from manifests; badged service wiring; restart on fault with limits; revokes dead provider's services | Designed: the root task concept exists |
| **Boot image** | BLAKE3 program hashes and a closure hash, built by `tools/pack`, verified at boot | Not yet built |

### Envoy (the AI agent interface)

| | grain-os | This tree |
|---|---|---|
| **Protocol** | `hello`, `discover`, `describe`, `call`, `plan`, `apply` (all-or-nothing with rollback), `undo`, `ask`, `observe` (BLAKE3-chained audit log), `bye` | Not yet designed at protocol level |
| **Host tools** | `tools/envoy.py` (client library), grainsh (structured shell), MCP bridge (every method becomes an MCP tool) | Not yet |
| **Agent leases** | Manifest `agent` section; Steward creates badged, protocol-stamped, use- and time-limited leases per boot | Not yet |

**This is arguably grain-os's most novel contribution.** A working AI agent interface with
typed capabilities, audit logging, rollback, and MCP bridge -- exactly what this tree's
foundations describe but have not yet built. The MCP bridge means any Claude session can
operate a grain-os instance through standard MCP tools today.

**Question:** Should we adopt Envoy's protocol wholesale, adapt it, or design our own? The
all-or-nothing `plan`/`apply` with rollback is a strong pattern.

### Surf / Brushstroke (the compositor / rendering surface)

| | grain-os | This tree |
|---|---|---|
| **grain-os name** | Surf: apps draw typed brushstrokes (`surf.v1`); the whole screen reads back as data (`scene.v1`) | Brushstroke: the rendering surface; Skate/Surf: FrameGrid and EventRing |
| **Desktop** | Working: compositor, shell, dock, buttons, text -- tested via QMP screendump + Envoy readback | Design and partial implementation |
| **Key insight** | "applications describe their windows as fills, panels and lines of text with roles, so the whole screen reads back as data, and an agent sees what the owner sees without guessing from pixels" | Same thesis: typed drawing primitives |

**This is the same idea in both trees**, and grain-os has it working. The screen-as-data
concept -- where an agent reads the display as typed structure rather than pixel-scraping --
is shared. `alias-sameness.md` already seats Surf and Skate as peer names.

### Comlink (networking)

| | grain-os | This tree |
|---|---|---|
| **Transport** | Noise XX sessions keyed by Kumara identities over UDP; LAN discovery; sturdy references backed by kernel leases; remote typed calls through Envoy; object transfer by hash | Designed: wires, the communication layer; 118 tracked files in `comlink/` |
| **Two-instance test** | Passing: two QEMU instances on one link | Not yet |

### Mycelium (network substrate)

| | grain-os | This tree |
|---|---|---|
| **Shape** | virtio-net driver, link-local IPv4, ARP, UDP | Designed: network substrate; 119 tracked files in `mycelium/` |

### Mantra (event log)

| | grain-os | This tree |
|---|---|---|
| **grain-os role** | Names and tips inside Tablecloth; the content-addressing scheme | Event log -- versions and replay; 67 tracked files, 2,310 inbound refs |
| **Ledger** | Separate: signed, sealed, append-only chain; every agent action recorded | Separate concept in this tree too |

**Note:** grain-os uses "Mantra" narrowly (content names in Tablecloth), while this tree
uses it broadly (the event log, versions, replay). Same word, different scope.

### Tally (bounded allocation)

| | grain-os | This tree |
|---|---|---|
| **grain-os** | Not named in grain-os; the concept exists as "the kernel never allocates" + Untyped region budgets | Bounded allocation: arena, ceiling, budget; 19 tracked files, 1,801 refs |

**Note:** grain-os implements the discipline TAME Guidance describes (bound everything, no
kernel heap, object budgets) without using the name "Tally." The implementation is the proof.

### Pond (domain isolation)

| | grain-os | This tree |
|---|---|---|
| **grain-os** | "Domains" in Steward; private regions; each domain in its own address space | The enclosure -- domain isolation; 249 tracked files, 1,070 refs |

### Amphora (sealed vessels)

| | grain-os | This tree |
|---|---|---|
| **grain-os** | Sealed objects in Tablecloth (XChaCha20-Poly1305, owner-bound keyed names) | Sealed vessels -- content-addressed storage; 13 tracked files, 498 refs |

---

## 4. The Hammock Questions -- what Rich Hickey asks us to sit with

### What are the inputs to the problem?

- **grain-os:** 9 phases of working code, ~110 Zig source files, fuzz and model checking,
  two-architecture kernel suite, browser emulation, MCP bridge
- **This tree:** 14,437 commits of design, witness infrastructure, language stack (Rye, Glow,
  Rishi, Brix, Kyri), 33 module rooms, TAME guidance, the civic and custody-first direction

### What are the constraints?

- **rv64 vs rv32i** -- the most load-bearing fork. rv64 runs on real hardware today. rv32i
  is the minimal target for devices a small grower can afford
- **Zig vs Rye** -- grain-os has a working kernel in Zig. This tree's language stack is its
  identity. Can they compose rather than compete?
- **Working code vs working design** -- grain-os shipped; this tree specified. Neither is
  wrong; both are incomplete without the other
- **License** -- grain-os PLAN.md: "none is chosen yet; it should be settled before outside
  contributions." This is a gate

### What don't we know?

1. Whether grain-os's generation-based revocation is sound under concurrent multi-hart
   access with DMA (CAPABILITY_MODEL.md Question 1, their own open question)
2. Whether the rv32i target is achievable with grain-os's architecture or whether the memory
   model fundamentally requires 64-bit addresses (Sv39 assumes rv64)
3. Whether Brix can evaluate to Kyri instead of ZON without losing the schema validation
   grain-os's Zig comptime provides
4. What DJINN's position is on the language question -- Glow/Rye adoption, or Zig-native
5. What the license will be and whether it permits the kind of composition we want

### What is the essence of the problem?

**Two trees grew the same idea independently. One grew code; the other grew design, language,
and culture. The question is how to compose them so each tree's strength serves the other,
rather than forcing one to become the other.**

### What are the tradeoffs?

| Approach | Gain | Cost |
|---|---|---|
| **Adopt grain-os wholesale** | Working kernel, working desktop, working browser, working agent | Lose this tree's language stack, TAME discipline, witness infrastructure, civic direction |
| **Study and infuse** | Keep our identity; adopt grain-os's proven patterns where they answer questions we have not yet answered | Slower; must rebuild what grain-os already ships |
| **Compose at the seam** | grain-os provides the kernel and system layer; this tree provides the language, culture, and civic direction | Requires a clean interface; the rv64/rv32i question must resolve |
| **Parallel paths** | Each tree grows independently; shared names help readers navigate | Duplicated effort; the two eventually diverge |

---

## 5. Questions for Keaton and DJINN

### Architecture

1. **rv64 or rv32i?** grain-os targets rv64 with Sv39 paging. Can Caravan's core run on
   rv32i (Sv32), or does the 16-byte capability model assume 64-bit addresses? If rv32i is
   essential for the "machine a small grower can afford" thesis, what does the port look like?

2. **Generation-based revocation soundness.** CAPABILITY_MODEL.md Question 1 asks about
   aliases the kernel does not track. Has the model checker explored this? What did the
   10^6-step simulator find about generation overflow or wraparound?

3. **Envoy adoption.** The discover/plan/apply/undo/ask/observe protocol with MCP bridge is
   exactly what this tree's foundations describe. Is there a reason NOT to adopt it as-is?

4. **Tablecloth crash model.** The crash simulator cuts power at every device operation. Is
   this model sufficient for rv32i targets where the storage device may be an SD card with
   different failure modes than virtio-blk or NVMe?

### Language

5. **Glow/Rye/Rishi adoption.** GLOSSARY.md says "not adopted." What is DJINN's position?
   Is there a path where grain-os's kernel stays Zig and the system layer above it speaks
   Glow, or are the two stacks fundamentally incompatible?

6. **Brix output: ZON or Kyri?** Both are "plain data." ZON has the advantage of Zig's own
   comptime validation. Kyri has the advantage of being authored here and carrying the voice.
   Can Brix evaluate to both, with a format flag, or must one win?

7. **The command language.** grain-os's PLAN.md proposes "pipelines over capabilities" for
   the shell. Glow is already a typed functional language with a pipeline concept. Is there
   a composition where Glow IS the command language grain-os describes?

### Identity and naming

8. **Kumara word bank.** grain-os uses 1024 four-letter words giving ~1 billion three-word
   names. Is that the right bank size? Should the word bank be shared between both trees?

9. **Module names.** GLOSSARY.md maps this tree's proposed names onto grain-os's
   implementation. When do we seat the renames? Phase 4 left-over item: "Code renames to the
   owner's proposed names (GLOSSARY.md), now that Phase 4 is done: this needs the owner's
   go-ahead on the mapping."

### Governance

10. **License.** grain-os has none chosen. This tree's gratitude-licenses discipline requires
    knowing the license before depending on code. What license does DJINN intend? Does it
    permit the kind of composition where grain-os provides the kernel layer and this tree
    builds above it?

11. **Contribution flow.** If we find a red in grain-os's capability model during our study,
    how does the fix flow? PR to `node777/grain-os`, or a conversation between Keaton and
    DJINN that results in DJINN's own commit?

12. **grain-emu vs Terrarium.** grain-os has a working WASM RISC-V emulator (72KB, 120-140
    MIPS). This tree proposes Terrarium for the same purpose. Do we adopt grain-emu, build
    Terrarium from scratch, or compose (grain-emu as the emulation core inside a Terrarium
    surface)?

---

## 6. What I observe, said plainly

grain-os is further along in implementation than I expected. Nine phases, each with an exit
criterion met, fuzz testing, model checking, a deterministic simulator, an aarch64 port, PCIe
drivers, a browser emulator, and an MCP-bridged AI agent interface -- all in pure Zig. DJINN
built a working capability microkernel from scratch and tested it seriously.

The overlap in module names is not coincidence -- DJINN and Keaton share the vision. The
GLOSSARY.md explicitly maps this tree's proposed names onto DJINN's implementations. The
question is not WHETHER to learn from grain-os but HOW MUCH to adopt.

My recommendation, following Hickey's "sleep on it" advice: **study and infuse, with a
composition seam as the horizon.** Adopt grain-os's proven patterns (Envoy protocol, Tablecloth
crash model, generation-based revocation) as design inputs. Keep this tree's language stack,
witness discipline, and civic direction. Let the rv64/rv32i question settle by measurement --
can grain-os's Caravan core compile for rv32i, and what does the binary size look like?

The twelve questions above are the ones worth sitting with. Not all need answers today; some
need a hammock and a good night's sleep.

---

## Measurement

Every claim about grain-os cites a file in `gratitude/grain-os/docs/`. Every claim about this
tree cites a living path or a measurement command. Both figures are free -- run them rather
than trusting this table.

```
# grain-os source size
git -C gratitude/grain-os ls-files '*.zig' | wc -l          # .zig file count
git -C gratitude/grain-os ls-files | wc -l                  # total file count

# This tree's module rooms with shared names
for d in amphora aurora caravan comlink kumara mantra mycelium pond tally; do
  echo "$d: $(git ls-files "$d/" | wc -l) files, $(git grep -l "$d/" -- '*.md' '*.rish' '*.rye' '*.kyri' '*.kyri.md' '*.sh' | wc -l) refs"
done
```
