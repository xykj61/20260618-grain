# Tablecloth -- project boards for living work

**Language:** EN
**Style:** Gauge at Field
**Voice:** Kyri
**Status:** Living
**Room:** Checkable

Project boards for living work -- decoupled from `tablecloth/` (the Brix database module) on
Keaton's word `20261105`. Self-contained task management, checklist, and progress tracking
folders for each active equinox or initiative. Inspired by `construction/` (the work-in-progress
stack), each board carries everything a new session needs to pick up the work cold: a checklist,
a progress log, scoping documents, and links back to the design and the ITINERARY.

## Convention

Each board is a timestamped subfolder: `YYYYMMDD-HHMMSS_project-name/`. Inside it:

- **`README.md`** -- what this board tracks, links to the design, the schedule, and the ITINERARY
- **`CHECKLIST.md`** -- the master checklist with one row per orbit, checked on completion
- **`PROGRESS.md`** -- append-only log of completed milestones with stamps and witnesses

A board is self-contained. A session opening the board reads its README and CHECKLIST, finds
what is next, and works from there.

## Active boards

All boards now live under `date/YYYYMM/NN/` (folded `20261107`).

| Board | Equinox | Status |
|---|---|---|
| [`20261103-005948_lotus-working-studio/`](date/202611/00/20261103-005948_lotus-working-studio/README.md) | Lotus DAW Equinox 1 -- The Working Studio | Active |
| [`20261103-184811_glow-language-journey/`](date/202611/00/20261103-184811_glow-language-journey/README.md) | Glow Language Journey -- Clean Foundations, Living Stdlib, Ready for Lotus | Complete |
| [`20261104-161857_terrarium-boot-journey/`](date/202611/00/20261104-161857_terrarium-boot-journey/README.md) | Terrarium Boot Journey -- From a Cold Hart to a Living World Under Glass | Complete |
| [`20261105-085747_mantrapod-rv64g-journey/`](date/202611/00/20261105-085747_mantrapod-rv64g-journey/README.md) | Mantrapod RV64G Journey -- From a Working Hart to a Living Server | Active |
| [`20261106-131535_realidream-composition-journey/`](date/202611/00/20261106-131535_realidream-composition-journey/README.md) | Realidream Composition Journey -- From Proven Pieces to One Living Surface | Active |
| [`20261106-204953_bloom-onboarding-journey/`](date/202611/00/20261106-204953_bloom-onboarding-journey/README.md) | Bloom Onboarding Journey -- 15 open movements remain | Active |
| [`20261107-090000_mantra-slc-comlink-realidream/`](date/202611/00/20261107-090000_mantra-slc-comlink-realidream/README.md) | Mantra SLC -- Comlink Realidream Content Network | Active -- TOP of Calfive stack |

## Folding convention

Boards fold by month into `date/YYYYMM/NN/`, where `NN` starts at `00` and rolls
to `01`, `02`, etc. if a month shelf exceeds 256 entries. Example:
`active-tablecloth/date/202611/00/20261103-005948_lotus-working-studio/`. The basename
stays globally unique per the stamp-and-name law, and the fold is invertible from the
basename alone (read the first 6 characters for `YYYYMM`, start at `00/`). The `NN`
overflow shelf ensures the tree scales past 256 projects per month without breaking
the bound.
