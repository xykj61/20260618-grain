# Calfive Stack Check-In -- Horizons After Terrarium SLC

**Stamp:** `20261107.085816` -- **Status:** Living -- **Room:** development
**Style:** Gauge at the Field setting, with Radiant warmth

## Tablecloth Project Status

Six tablecloth projects stand. Three are complete, one is 80% done, one is 50% done, and one is paused.

| Project | Done | Open | Status |
|---|---|---|---|
| **Glow language journey** | 14 | 0 | COMPLETE |
| **Terrarium boot journey** | 25 | 0 | COMPLETE |
| **Realidream composition journey** | 30 | 0 | COMPLETE |
| **Mantrapod RV64G journey** | 40 | 10 | 80% -- board acquisition PAUSED |
| **Bloom onboarding journey** | 15 | 15 | 50% -- open movements remain |
| **Lotus working studio** | 4 | 8 | PAUSED at 33% |

## Mantrapod -- 10 Open Movements

Movements 41-50 all depend on physical board acquisition, which is PAUSED per Keaton's word. Every remaining movement requires real hardware: board selection, hello on real UART, full boot, wire protocol, integration witness, Dimeroll field ledger, power-cycle resilience, enclosure, first resident deployment, and journey completion witness. These movements remain sound -- they describe the path from QEMU to metal, and that path has not changed. **Horizon: resume when board acquisition unpauses.**

## Bloom Onboarding -- 15 Open Movements

The Bloom journey landed 75 movements across 4 acts. The onboarding tablecloth tracks 30 movements, 15 complete. The remaining 15 cover interactive features (search, bookmarks, progress tracking) and integration polish. These still make sense as a future SLC -- each would make the learning experience more lovable. **Horizon: resume as a future SLC milestone, after Mantra SLC.**

## Lotus Working Studio -- 8 Open Movements

Lotus is paused at 33%. It covers the creative suite -- audio wire shape, CoreAudio engine, MIDI, mixer, effects. The design is sound and the architecture spec is written. **Horizon: resume when the Mantra filesystem and Comlink networking give Lotus a real storage and transport layer to build on.** The new Mantra SLC tablecloth directly unblocks Lotus by providing the content path infrastructure.

## What Changes With the New Mantra SLC Priority

The new tablecloth project -- Mantra SLC with Comlink networking -- prepends to the front of the Calfive stack. This means:

1. **Mantra SLC** becomes the active priority
2. **Bloom onboarding** waits behind it -- still sound, still wanted, lower urgency
3. **Mantrapod** remains paused on board acquisition -- unchanged
4. **Lotus** benefits from Mantra landing first -- the filesystem and network layer it needs

No movements need to be cancelled or reimagined. The three complete journeys (Glow, Terrarium boot, Realidream) stay complete. The three open journeys each have a clear reason to wait, and Mantra SLC directly strengthens two of them (Bloom gets real content paths; Lotus gets real storage).

## The Calfive Stack After Prepend

```
TOP -> Mantra SLC + Comlink networking (NEW -- prepended)
       Bloom onboarding (15 open movements)
       Mantrapod RV64G (10 open movements -- PAUSED on board)
       Lotus working studio (8 open movements -- PAUSED)
```

The stack breathes: the new priority at the top, the rest ordered by readiness and dependency, each carrying a clear horizon for when it resumes.
