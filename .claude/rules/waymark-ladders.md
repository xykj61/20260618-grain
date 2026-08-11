# Waymark Ladders — Draw Before You Number

**Canon:** `context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md` · witness `tools/waymark_derive.rish` · Lexicon **Waymark**.

## When a ladder opens

Before the first rung is written as `X0` / `X1` / … in TASKS, ROADMAP, compressors, module titles, or session logs that speak as *now*:

1. Choose a **canonical hyphenated input name** for the ladder (stable, descriptive, lowercase).
2. Set `input_name` in `tools/waymark_derive.rish` and run `rishi/bin/rishi run tools/waymark_derive.rish`.
3. Seat the printed four-letter **waymark** in Lexicon + the script’s seated-draws comment + exclude list.
4. Name every rung `WAYMARK0`, `WAYMARK1`, … — never a bare capital letter alone (`B0`, `G0`) for a new ladder.

## Seated waymarks (do not redraw)

| Waymark | Input | Ladder |
|---|---|---|
| **pixel-glass** | `grapheneos-pixel-mobile-emulation` | Pixel / GrapheneOS SLC |
| **glow-publishing** | `glow-application-framework-and-publishing` | App framework / packaging |
| **glass-keyboard** | `glow-english-qwerty-glass-keyboard-3` | Glass English QWERTY keyboard |
| **seva-broadcast** | `sala-broadcast-live-session-fold` | Seva broadcast session fold (was bare B0–B3) |
| **hearth-display** | `glow-glass-hearth-display-and-wired-sync` | Hearth display presets · short home · Wired Glass |
| **glow-language** | `glow-language-rune-heads-nest-and-lowering-2` | Glow language SLC · rune heads · nest · composition |
| **usb-hearth** | *(hand-seated; not a corpus draw — absent from flw)* | USB hearth carry Glass↔Desk |
| **source-identity** | `source-pier-papers-identity-refresh` | SOURCE.md identity · remotes · apps · onboarding refresh |
| **djinn-exec** | `djinn-bozo-exec-keaton-murr-hats` | DJINN → Bozo exec · Keaton → Murr exec · Linn→Bozo Capricorn 10 |
| **compass-language** | `glow-language-runes-stdlib-and-pipeline` | Compass Chapter Equinox 1 — The Language (Glow runes · stdlib/PLEAC · Brix-infuse · pipeline) |
| **compass-identity** | `kumara-identity-comlink-and-fractal-network` | Compass Chapter Equinox 2 — Identity & Network (Kumara · d12/d60 topology · Comlink · settlement) |
| **compass-surface** | `realidream-surface-and-quin-inference-and-mcp-2` | Compass Chapter Equinox 3 — Surface & Intelligence (Realidream · Quin voices · MCP-in-Bron) |
| **compass-world** | `ship-pilot-publishing-grainphone-and-commerce` | Compass Chapter Equinox 4 — The World (Ship-Pilot · publishing · Grainphone · commerce) |
| **harvest-yield** | `harvest-season-equinox-1-yield` | Harvest Chapter Equinox 1 — Yield (prove built modules on real data) |
| **harvest-trade** | `harvest-season-equinox-2-trade` | Harvest Chapter Equinox 2 — Trade (fair-trade certification · cash-first) |
| **harvest-commons** | `harvest-season-equinox-3-commons` | Harvest Chapter Equinox 3 — Commons (Skate social layer · community) |
| **harvest-rest** | `harvest-season-equinox-4-rest` | Harvest Chapter Equinox 4 — Rest (consolidation · saga close · 3/4 reading) |
| **cion-molt** | `meta-season-chronological-labeling-molt` | cion-molt Meta-Chapter — molt·debride·sweep count-up IDs → chronological/semantic labels (after Compass) |

**Hand-seated names on the exclude roster** (not waymark draws): **SEVA** (viewer; absent from flw), **MAND** (M vane; in flw), **MONA** (prior name of Mand — one season). **SALA** retired from exclude with the Sala→Seva alias close.

Corpus pin: `tools/fixtures/flw-four-letter.txt` · witness `tools/waymark_derive_witness.rish`.

## Accrete-never-break

Dated logs and research that already say `B0` / `B1` / `B2` stay readable. Living *Now* lines, new modules, new commits, and compressors use **seva-broadcast** (and other seated waymarks) from the draw forward.

## Collision

If the derive assert goes RED (word hits a seated module or waymark name), append `-2` to `input_name` and redraw — same method as the spec.
