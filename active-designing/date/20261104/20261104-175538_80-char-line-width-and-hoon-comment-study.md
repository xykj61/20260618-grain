# 80-Char Line Width and Hoon Comment Study

**Last updated:** `20261104.175538`
**Status:** Proposed -- checkable -- awaiting Keaton's word
**Room:** checkable
**Style:** Gauge at the Field setting, with Radiant warmth

## The question

Should TAME Guidance adopt Urbit's elder 80-character line width instead of TigerBeetle's 100, and should Glow adopt Hoon's `::` inline comment pattern with code at ~57 characters and comments on the right margin?

## The answer, in one line

**Yes to 80 characters. Yes to the column-57 `::` comment pattern for Glow. The beauty is real, the accessibility argument is strong, and now is the cheapest time.**

---

## Part 1 -- 80 characters vs 100 characters

### What Hoon actually does (measured from urbit/urbit sys/ core)

Four files measured: `hoon.hoon`, `arvo.hoon`, `zuse.hoon`, `lull.hoon` -- 28,132 lines total.

- **99.8% of lines fit within 80 chars** (28,068 of 28,132)
- Only **64 lines exceed 80** -- nearly all inline-comment lines running 1-3 chars past
- The effective standard is **80 columns**, held without a formal linter, by the discipline of tall-form alone

### What TigerBeetle says (TAME's ancestor)

> "Hard limit all line lengths, without exception, to at most 100 columns for a good typographic 'measure'."

TigerBeetle chose 100 for Zig, a language whose function signatures and generic instantiations run wider than Hoon's tall form. The reasoning is physical -- just enough for a readable line, never hidden by a scrollbar.

### What our tree carries today (measured this lap)

| Family | Files | Lines over 80 | Lines over 100 | Gap (81-100) |
|---|---|---|---|---|
| **Rye** (.rye) | 2,631 | 130,952 | 68,125 | 62,827 |
| **Rishi** (.rish) | 2,673 | 69,906 | 39,016 | 30,890 |
| **Shell** (.sh) | 1,325 | 58,941 | 9,349 | 49,592 |
| **Glow** (.glow) | 497 | 622 | 94 | 528 |
| **Living Markdown** | 1,146 | 35,603 | 15,856 | 19,747 |
| **Rule files** (.claude/rules/) | 51 | 2,189 | 766 | 1,423 |
| **Totals (living Tier 3)** | ~8,323 | **~297,024** | ~133,440 | **~163,584** |

The incremental cost of 80 over 100: **~163,584 lines in living files** need wrapping. The 81-100 range is the new work.

Testimony (session logs, dated files) carries another ~484,346 lines over 80, governed by accrete-never-break and the approved molt breach.

### The accessibility argument

80 characters fits:

- A **tablet in portrait** (768px at typical terminal fonts)
- A **phone in landscape** with a monospace font at readable size
- A **split-pane terminal** on a laptop -- two 80-column panes side by side
- **GitHub's diff view** without horizontal scrolling (the rendered view wraps at ~80 for diffs)
- **Printed code** on A4 or US Letter at 10pt monospace

100 characters fails the first three and strains the fourth. The difference is who can read the code without scrolling sideways, and that is an accessibility win that compounds: every file touched, every tutorial written, every contribution reviewed reads cleanly on a wider set of devices.

### The cost, honestly named

- **~297,024 lines** in living files need wrapping (the full 80-char census)
- **~163,584** of those are new work beyond what a 100-char ratchet would already ask
- **Glow is nearly clean** -- only 622 lines across 497 files, and half the files have zero overlong lines
- **Rye is the biggest job** -- 130,952 lines across 2,289 files (87% of Rye files have at least one)
- **Rishi and shell** are 99% affected, largely from long `say` messages and `assert ... else` lines
- **Rule files** are 100% affected -- every one has lines over 80
- A mechanical `fmt`-style tool can handle Rye (Zig's `zig fmt` respects width); Rishi, shell, and prose need judgment

### The recommendation

**Adopt 80 characters as TAME Guidance's line-width standard.** This is a departure from TigerBeetle's 100 -- the first such departure -- and the reasons earn it:

1. **Hoon proves it works** for a language of comparable density -- 99.8% compliance across the kernel
2. **Accessibility widens the audience** -- tablets, phones, split panes, printed code, diffs
3. **Now is the cheapest time** -- the tree is young enough that the ratchet has not yet compounded
4. **Glow matches Hoon** -- the two languages would share a line-width discipline, which honors the ancestor
5. **Safety first** -- 80 chars makes code visible on more devices; a line hidden behind a scrollbar is a line a reviewer may not read

**Phase the ratchet:**

- **Phase 1 (immediate):** Gate Glow at 80 -- it is nearly there (622 lines)
- **Phase 2 (dedicated round):** Rye sources, using `zig fmt` with a column cap, plus manual judgment for comments
- **Phase 3 (on touch):** Rishi, shell, and Markdown ratchet down on touch, ceiling falling
- **Testimony:** Session logs and dated files take the approved molt breach; new logs are written at 80 from this stamp

---

## Part 2 -- The Hoon inline comment pattern

### What Hoon actually does (measured)

From the four core Urbit files:

- **78.5% of all inline comments (2,361 of 3,007) align `::` at column 57**
- Code fills columns 1-56; a space pad; `::` at 57-58; comment text runs to ~column 78
- Average comment portion: **13.6 characters** -- enough for a verb and a noun
- Average total line with col-57 `::`: **71.1 characters** -- well within 80
- Comment density: ~32.5% overall -- one comment for every two lines of code

Example from `hoon.hoon`:

```
++  biff                                                ::  apply
++  bind                                                ::  argue
++  bond                                                ::  replace
```

Section banners use `::::` at column 0, padded to column 56, closed with `::` at the right margin. Arm documentation: `::  +name: description`. Parameter documentation: `::  a: augend`.

### Why it works

The column-57 alignment creates a **visual margin** -- the code body sits left, the comments sit right, and the eye can read either column independently. It is the same principle as a well-set book page with marginal notes, and it enforces brevity in the comment (13 characters means you say the one thing that matters).

Hoon's **tall form** reinforces this -- multi-line expressions keep each subexpression on its own 2-space-indented line, so code naturally stays under 56 characters even in deep nesting. Wide form (single-line) is used only when the whole expression fits. The 80-char limit and tall form are **mutually reinforcing**.

### The recommendation for Glow

**Adopt the column-57 `::` inline comment pattern as a Glow style guide option.**

- **Inline comments:** code at columns 1-56, space pad, `::` at 57-58, comment text to column 79
- **Full-line comments:** `::` at the current indent level, followed by the comment -- allowed and welcome
- **Section banners:** `::::` with padding, matching Hoon's convention
- **Documentation comments:** `::  +name: description` for function heads

Glow already uses `::` for comments (confirmed in `glow/tokens.rye` at the tokenizer level), so the syntax is already there. What this seats is the **column alignment** and the **width budget**: ~56 chars for code, ~20 chars for comment, 80 total.

This gives Glow a comment discipline inherited directly from Hoon -- honoring the ancestor in the code's own shape, not just in the rune sigils.

---

## Part 3 -- Q10 license gate is clear

DJINN merged the MIT license to `grain-os` main at commit `80d14c5`. Verified by pulling the submodule. The license reads:

> MIT License, Copyright (c) 2026 node777

The submodule pointer advances from `0e26780` to `80d14c5` (one file added: `LICENSE`). Q10 is **CLEAR** -- study-and-infuse may proceed under MIT terms.

---

## The reprinted recommendation

### What to build next, in TAME priority order (safety > performance > joy)

**The Long Return, updated with today's findings:**

1. **Seat the 80-char line-width standard in TAME Guidance** (safety -- accessible code)
   - Write the rule change in `context/TAME_GUIDANCE.md` and `.claude/rules/tame-guidance.md`
   - Build the line-length gate tool (distinct from `width-check.rish`, which is about `usize` types)
   - Gate Glow at 80 immediately (622 lines to fix -- the cheapest family)
   - Ratchet everything else under a ceiling that only falls

2. **Seat the column-57 `::` comment style in the Glow style guide** (joy -- the beauty Hoon already found)
   - Document the pattern in `context/GLOW_STYLE.md` or its equivalent
   - Apply to Glow sources on touch
   - The column number is the ancestor's gift -- it is not arbitrary, it is measured

3. **Q3 session log format spec** (the Long Return -- durable infrastructure)
   - The `*.{name}.md` format, Ember voice system, code block wrapping
   - This was the prior round's recommended next keystone and it still holds
   - The approved molt breach is ready; the format shape needs a ruling before execution

4. **Commit the grain-os submodule update** (Q10 gate -- clear the path)
   - Advance `gratitude/grain-os` from `0e26780` to `80d14c5`
   - Q10 is now CLEAR for study-and-infuse

5. **Begin the 80-char ratchet sweep** (dedicated rounds, as Keaton offered)
   - Glow first (622 lines, half the files already clean)
   - Rye second (130,952 lines -- the big job, `zig fmt` assists)
   - Rishi, shell, and prose on touch

### What Keaton's word seats

- **The 80-char standard** -- a departure from TigerBeetle's 100, toward Urbit's discipline
- **The column-57 `::` pattern** -- Glow's comment alignment, inherited from Hoon
- **The ratchet phasing** -- which families move first, and how many dedicated rounds

## Related

- `context/TAME_GUIDANCE.md` -- the supplement where the line-width standard lives
- `gratitude/TIGER_STYLE.md` -- TigerBeetle's 100-column standard (TAME's ancestor)
- `glow/tokens.rye` -- Glow's `::` comment tokenizer (already built)
- `tools/l/line_length_census_witness.rish` -- the existing census (measured rather than gated)
- `active-designing/date/20261104/20261104-172718_grain-os-fork-decisions-response.md` -- the twelve fork decisions
