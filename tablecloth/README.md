# Tablecloth -- project boards for living work

**Language:** EN
**Style:** Gauge at Field
**Voice:** Kyri
**Status:** Living
**Room:** Checkable

Tablecloth is the Brix-facing application database and artifact store. In this tree it also
holds **project boards** -- self-contained task management, checklist, and progress tracking
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

| Board | Equinox | Status |
|---|---|---|
| [`20261103-005948_lotus-working-studio/`](20261103-005948_lotus-working-studio/README.md) | Lotus DAW Equinox 1 -- The Working Studio | Active |
| [`20261103-184811_glow-language-journey/`](20261103-184811_glow-language-journey/README.md) | Glow Language Journey -- Clean Foundations, Living Stdlib, Ready for Lotus | Complete |
| [`20261104-161857_terrarium-boot-journey/`](20261104-161857_terrarium-boot-journey/README.md) | Terrarium Boot Journey -- From a Cold Hart to a Living World Under Glass | Active |
