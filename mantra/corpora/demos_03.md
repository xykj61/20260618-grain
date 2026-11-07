# The Fourteen Galaxies -- A Puddle Test Network Registry

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page introduces the fourteen placeholder galaxies that every demo
on this shelf uses. It explains what a galaxy is in Grain's identity
system, why these galaxies are named for plants, and why their names
are deliberately shaped so they can never reach a real ship on the live
network.

## What a galaxy is

Grain inherits its naming system from Urbit's Azimuth identity layer.
The naming tree has four levels:

1. **Galaxy** -- the root of the tree. There are 256 possible galaxies.
   Each one sponsors up to 255 stars.
2. **Star** -- a mid-level node. Each star sponsors up to 65,535 planets.
3. **Planet** -- where most people live. A planet is a personal server
   with its own identity and keys.
4. **Moon** -- a temporary device identity sponsored by a planet, used
   for phones and tablets.

A galaxy name in Urbit is written with a tilde and exactly three
letters: `~zod`, `~bus`, `~nec`. Those three-letter syllables come
from a fixed table of 256 prefixes and 256 suffixes. Any name built
from those syllables is a real address on the live network.

## Why these galaxies are named for plants

Grain is an agricultural operating system. Its modules are named for
things a grower knows: Mantra (the log that remembers), Amphora (the
vessel that seals), Caravan (the convoy that supervises). The test
network follows the same principle. Each galaxy is named for a plant
that belongs in a biocyclic vegan garden -- a garden that builds soil
health without animal inputs, using companion planting, cover crops,
and perennial habitat.

## Why the names are safe

Every segment of these names is four to nine letters long. A real
Urbit name uses segments of exactly three letters. The mismatch is
structural: a four-letter segment cannot parse as a valid syllable from
the Urbit syllable table, so these names fail to resolve before they
ever reach the network.

This means a newcomer who copies `~sunflower` into a command will see
a parse error rather than accidentally contacting a real galaxy. The
safety comes from the shape of the name itself rather than from a
convention about which names are "reserved."

## The registry

| Galaxy | Plant | Why this plant | Testnet role |
|---|---|---|---|
| `~sunflower` | Sunflower -- heliotropic energy crop | Turns toward the light; a field of sunflowers orients a whole landscape | Seed galaxy, bootstraps the network |
| `~rosemary` | Rosemary -- companion plant, pest deterrent | Remembers (rosemary for remembrance); guards its neighbors | Identity authority demo |
| `~lavender` | Lavender -- pollinator habitat | Draws visitors from far away and sends them onward | Message relay demo |
| `~basil` | Basil -- kitchen garden staple | A garden's most-traded herb; everyone reaches for it | Dimeroll ledger demo |
| `~chamomile` | Chamomile -- calming tea herb | Steady, mild, helps everything around it settle | Consensus participant |
| `~oregano` | Oregano -- Mediterranean perennial | Comes back year after year, exactly the same | Mantra log replication demo |
| `~thyme` | Thyme -- ground cover, erosion control | Holds the soil in place; nothing slips past it | File storage demo |
| `~sage` | Sage -- wisdom herb | Teaches patience; the oldest plants are the strongest | Key rotation demo |
| `~mint` | Mint -- vigorous spreader | Finds every corner of the garden on its own | Network discovery demo |
| `~fennel` | Fennel -- deep-rooted soil breaker | Reaches deep and opens a path for what follows | Caravan supervision demo |
| `~marjoram` | Marjoram -- gentle oregano cousin | Softer, sweeter; the social one in the family | Surf Social demo |
| `~tarragon` | Tarragon -- essential in cooking | A single leaf changes the whole dish | Query engine demo |
| `~chive` | Chive -- allium companion | Grows in clusters; stronger together | MUR token demo |
| `~dill` | Dill -- fermentation friend | Helps things transform and agree | Mycelium consensus demo |
| `~siya` | Siya -- turmeric relative, sacred root | A golden rhizome that asks the soil what it holds | Content peer -- the one who recalls |

## How to read the demos

Every page on the demos shelf uses these fourteen galaxies in its
examples. When a demo says "`~sunflower` boots and seeds the network,"
it means the first galaxy in this registry is performing its role as
the seed node. When it says "`~basil` sends 100 MUR to `~chive`," it
means the ledger demo galaxy is transferring tokens to the token demo
galaxy.

The roles are teaching assignments rather than technical constraints.
Any galaxy can perform any role. The assignments give each galaxy a
personality that makes the demos easier to follow.

## Something to try

Pick any three galaxies from the table and imagine them as three
machines on a desk. What would happen if `~sunflower` booted first
and the other two joined? Which one would you ask to hold your farm's
daily records? Look at the plant names and notice that the answer
feels natural -- that is what a good naming convention does.

---

*May these fourteen names feel like friends by the time you reach
the last demo, and may the garden they come from keep growing.*
