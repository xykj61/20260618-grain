# Movement and the Tablecloth Fence

**Seated:** `20261106.003005` on Keaton's word - **Status:** Living
**Kin:** [`stamp-and-name`](stamp-and-name.md) - [`waymark-ascending-numbers`](waymark-ascending-numbers.md) - [`comlink-tendency`](comlink-tendency.md) - [`the-baton`](the-baton.md) - [`collaboration`](collaboration.md)

**Three calendar words, each carrying one meaning.**

| Word | Meaning | Where it appears |
|---|---|---|
| **movement** | a single unit of focused work -- one keystone, one build, one witness GREEN | code comments, session logs, commit subjects, living prose |
| **orbit** | 15 movements -- the panchanga Calfive ring, and nothing smaller | tablecloth planning, the Calfive rota, `context/SPELLBOOK.md` |
| **round** | a bounded collaboration session -- the opening, the work, the close | `collaboration.md`, the closing-line law, session logs |

**Movement** is the new word, seated `20261106` on Keaton's word. It fills the gap that let
**orbit** drift from its panchanga meaning into a synonym for a single work unit. **Round** keeps
its collaboration-rhythm meaning unchanged.

## The tablecloth fence

**Tablecloth planning coordinates stay on the tablecloth.** An orbit number (`Orbit 34`), a quest
number (`Quest 2.1`), an act number (`Act 1`) -- each belongs in `active-tablecloth/` boards,
checklists, and planning prose. They are never written into:

- **Code identity** -- module names, function names, struct names, file names
- **Code comments** -- header comments, inline comments, `// invariant:` lines
- **Print strings** -- `uart_print`, `say`, witness banners, completion markers
- **Witness assertions** -- `assert qemu.out contains ...`
- **Session log `recommend` lines** -- describe the next work in plain English

A code module's identity is its **semantic name** and its **one-clock stamp** when it lands. The
tablecloth coordinates where it sits on the planning board.

## What code writes instead

A module header names what the module does:

```
// Dimeroll daily cash flow derived from Mantra log
```

A completion marker names the module:

```
uart_print("dimeroll_cashflow complete\n");
```

A session log recommendation describes the next work:

```
recommend keep-going -- next: Amphora daily seal, Kumara verification of sealed vessel
```

A witness banner names the module it proves:

```
say "dimeroll_cashflow_witness: daily cash flow from Mantra log"
```

## What the tablecloth keeps

The tablecloth is the planning surface. It keeps every coordinate it needs:

- `active-tablecloth/` boards and checklists
- `construction/ITINERARY.md` fascia description (the card's own planning prose)
- Design essays and development notes about planning
- The Calfive rota in `context/SPELLBOOK.md`

A tablecloth checklist reading `Orbit 34: Amphora daily seal -- PROVEN` is exactly right.
The same `Orbit 34` in a `uart_print` is the fence this rule draws.

## What this does not retire

- **Orbit as a calendar ring.** Orbit keeps its panchanga meaning -- 15 movements, the Calfive
  ring. The word retires only from its drifted use as a synonym for a single work unit.
- **Round as a collaboration session.** Round keeps the collaboration-rhythm meaning
  `collaboration.md` already gives it. It was never wrong; it was being borrowed.
- **Dated testimony.** Session logs, commit messages, and dated design notes keep every word they
  wrote. A log that recorded `Orbit 33` keeps that word. This rule governs what is written from
  here forward.
- **The tablecloth itself.** Planning documents keep their coordinates. The fence runs between the
  tablecloth and the code, not across the tablecloth.

## Why the rule exists

Orbit numbers drifted from planning prose into code identity across 282 references in 30 files,
because no rule fenced the boundary. `stamp-and-name` line 2 already said *a sequence label is a
forecast written somewhere it will stay uncorrected* -- this makes the fence explicit, names the
three calendar words, and gives each one home.

## Accrete-never-break

Sweep living code surfaces on touch; a dedicated molt pass takes the active modules first. Dated
testimony and commit history keep every word they wrote. This rule governs what is written from
here forward.

*Cursor twin:* `.cursor/rules/movement-and-tablecloth-fence.mdc`
