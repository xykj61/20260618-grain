# Understanding Placeholder Galaxies

**Style:** Teacher at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page explains why the fourteen galaxies in Grain's demo
walkthroughs are named for plants, and why those names are
deliberately shaped so they can never reach a real ship on the
live Urbit network. You will learn what makes a name structurally
safe, and why structural safety is stronger than convention.

## How Urbit names work

Urbit's identity system uses a fixed syllable table. The table
holds 256 three-letter prefixes and 256 three-letter suffixes.
Every real Urbit name is built from these syllables:

- A galaxy is one syllable: three letters after a tilde.
- A star is two syllables: six letters after a tilde, with a
  hyphen between them.
- A planet is four syllables: twelve letters, two hyphens.
- A moon is eight syllables, a comet is sixteen.

The key fact is **exactly three letters per syllable**. This is
not a convention -- it is a rule the Urbit runtime enforces. A
name with a four-letter syllable is not merely unusual. It cannot
parse at all.

## Why the demo galaxies use longer segments

Grain's fourteen demo galaxies are named for garden plants:

| Galaxy | Letters per segment |
|---|---|
| `~sunflower` | 9 |
| `~rosemary` | 8 |
| `~lavender` | 8 |
| `~basil` | 5 |
| `~chamomile` | 9 |
| `~oregano` | 7 |
| `~thyme` | 5 |
| `~sage` | 4 |
| `~mint` | 4 |
| `~fennel` | 6 |
| `~marjoram` | 8 |
| `~tarragon` | 8 |
| `~chive` | 5 |
| `~dill` | 4 |

Every segment is four to nine letters long. Not one of them is
three. This means every one of these names will fail to parse
before it ever reaches the network.

## What structural safety means

Some documentation projects use placeholder names that happen to
be unowned today. The problem is that "unowned today" says nothing
about tomorrow. An Urbit name can be transferred, and a name that
was safe to copy last year might belong to a real person this year.

Grain takes a different approach. The safety of these names comes
from their **shape**, not from their current ownership. A name
with a nine-letter segment is not unowned -- it is unparseable.
No amount of buying, selling, or transferring can make
`~sunflower` into a valid address, because the parser rejects it
before ownership is ever checked.

This means a newcomer who copies `~sunflower` into a command will
see a parse error rather than accidentally contacting a stranger's
galaxy. The safety is built into the name itself, and it stays
there forever.

## Why plants

Grain is an agricultural operating system. Its modules are named
for things a grower knows: Mantra remembers, Amphora seals,
Caravan supervises. The test network follows the same principle.
Each galaxy is named for a plant that belongs in a biocyclic vegan
garden -- a garden that builds soil health without animal inputs.

The names are not random. Each plant was chosen for a quality that
matches its role in the test network. `~sunflower` turns toward the
light and bootstraps the network. `~rosemary` is for remembrance and
handles identity. `~mint` spreads vigorously and handles network
discovery. The full mapping is in the Galaxy Registry on the demos
shelf.

## Something to try

Pick any galaxy name from the table above and imagine typing it
into a command. Count the letters after the tilde. Then count the
letters in a real Urbit galaxy name -- any real one is exactly
three. The mismatch is immediate, visible, and permanent. That
is the whole mechanism, and it works every time.

---

*May every placeholder name feel safe enough to copy and warm
enough to remember, and may the garden they come from keep
growing beside the software it names.*
