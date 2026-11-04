# Fascia Health Model -- a readiness metric, not a clutter score

**Seated:** `20261103.201746` on Keaton's word - **Status:** Living
**Home:** [`../../README.md`](../../README.md) (badge) and [`../../construction/ITINERARY.md`](../../construction/ITINERARY.md) (card)
**Kin:** [`../../.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md) - [`../../.claude/rules/quality-assurance.md`](../../.claude/rules/quality-assurance.md) - [`../../.claude/rules/lila-and-the-long-return.md`](../../.claude/rules/lila-and-the-long-return.md)
**Room:** checkable

## What the number means

**Fascia is how ready this tree is to serve the person who runs it.** Clean files with no
shipped product is a tidy empty house, and a tidy empty house does not earn 90. The number
reflects product readiness, code security, design elegance, and real use -- not file
tidiness alone.

The elder fascia metric (`tools/gen/chapter/fascia_metric.rish`) computed a 0-100 clutter
score from four signals: orphan files, ratchet counts, class-A hits, and over-70 functions.
That instrument stays as one input into the reading. **The number on the door is Keaton's
word**, governed by this model rather than derived from a formula.

## The decade model

The tree is pre-alpha. The entire 60s decade is the pre-ship era. **70 is the far door,
and nothing before a shipped product with real users earns it.**

| Fascia | What earns it |
|---|---|
| **60.0** | Post-debride baseline: clean history, warm names, shed complete, guards green |
| **61-63** | Glow stdlib proven, Brushstroke demos running, docs-geode teaching |
| **64-66** | First Lotus complete on macOS native, proven on metal, security reviewed |
| **67-69** | Shipped to real users, first-resident use confirmed, elegance pass landed |
| **70.0** | The far door -- real users in steady use, the tree serves someone besides us |

## Increment discipline

**0.01 per proven orbit.** Each orbit that lands with its SLC gate green adds 0.01 to the
fascia number. A breakthrough orbit -- one that ships a real capability or closes a
significant gap -- earns **0.1 or more on Keaton's word**. The metric stays conservative,
and Keaton's hand stays on the dial.

**Why 0.01 and not more.** A 15-orbit journey moves the needle 0.15. That is honest for
a housekeeping journey. The distance from 60 to 70 is 1,000 proven orbits at the base
rate, which maps to the real distance between a clean tree and a shipped product. Larger
jumps come from Keaton's word when the work earns them.

## Where the number lives

Two homes, one number:

- **`README.md`** -- the badge on the front door, visible to anyone who opens the repository.
- **`construction/ITINERARY.md`** -- the operator card, beside the git nib, visible to every
  ship at every lap open.

Both are updated in the same commit as the orbit that earned the change. Neither is a
computed output -- each is a manually governed value that reflects Keaton's assessment of
where the tree stands.

## What the number is not

**Not a grade the tree gives itself.** The QA report card (Gauge Style) grades individual
artifacts. The fascia number grades the whole tree's readiness, and only Keaton's word
moves it past the 0.01 orbit increment.

**Not a formula output.** The clutter metric stays as an instrument that informs the
reading. The reading itself is a judgment about product readiness, code security, design
elegance, and real use.

**Not a target to optimize toward.** The happy zone foundation and the output-over-activity
foundation both warn against mistaking a rising number for real progress. The number
follows the work; the work follows Lila and the Long Return.

## Why the model exists

The prior fascia metric measured one axis (clutter) and would have claimed 90 after a
shed -- a score that says the tree is nearly perfect while no product has shipped, no
real user has touched it, and the security of the code modules remains unconfirmed even
with passing tests. Keaton corrected this on `20261103`: the number should be honest
about where we actually are, and where we actually are is pre-alpha.
