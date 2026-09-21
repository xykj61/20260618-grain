# glow-language — Cores thin battery brief

**Status:** Checkable — thin face GREEN `20260718.224030`  
**Depth:** brief  
**Last updated:** 2026-07-18 (`20260718.223906`)  
**Voice:** Quin  
**Waymark:** **glow-language** · compressor [`../docs/glow-language.md`](../../docs/glow-language.md)

---

## Why now

Composition through glow-language can bind faces, call gates across lines, and type `@u32` desks. Glass still needs a **module shape** — a battery of named arms — before Glow can author what NativeActivity imports. That shape is Hoon's **core**: cell of battery + payload. Glow takes the *shape*, not Hoon's gold/iron/lead/zinc variance (Option A in [`../external-research/20260717-003402_hoon-core-variance-glow-rune-kyri-brix-fusion.md`](../../external-research/20260717-003402_hoon-core-variance-glow-rune-kyri-brix-fusion.md)).

## Thin face claim (glow-language)

Exactly three Glow lines, no payload sample yet:

```
|%
++  double
--
```

| Piece | Meaning |
|-------|---------|
| `|%` | Open a core with named arms |
| `++  <arm>` | One named arm (closed demo: `double` only) |
| `--` | Close the core |

**Lower:** one Rye `struct` holding `double(sample: u32) u32` (`sample *% 2`), plus a `main` that calls it with demo atom `5` and expects `10`.

**Not in this face:** multiple arms · wet cores · variance · sample/payload molds · importing the core from another desk.

## Witness gate

- Parse refuse: wrong line count, unknown arm, missing `--`
- Welcome exit 0 / unwelcome exit 1
- Desk `glow/gen/core-double.glow` on the desk hop

## Held for glow-language+ (landed `20260718.225150`)

Two-arm batteries and library emit (no `main`) landed as **glow-language–16**. Still held: payload/sample · face→core compose · three-plus arms.

---

*One battery, one arm, ordinary Rye underneath.*
