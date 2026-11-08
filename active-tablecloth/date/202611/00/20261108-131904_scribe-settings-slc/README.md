# Scribe Settings SLC -- User Preferences for Terrarium

**Stamp:** `20261108.131904`
**Language:** EN
**Style:** Gauge at Field
**Status:** Active
**Room:** Checkable
**Voice:** Kyri

## What this board tracks

The first bounded SLC of the module composition tablecloth: a settings tab in Terrarium where a
person changes their preferences, persisted as `.kyri` files, readable through the existing Scribe
reader. This is the smallest working whole that teaches us how modules compose inside Terrarium.

## Links

- **Design:** [`../../../expanding-prompts/date/20261108/20261108-125817_grain-module-composition-tablecloth.md`](../../../../expanding-prompts/date/20261108/20261108-125817_grain-module-composition-tablecloth.md)
- **ITINERARY:** [`../../../../construction/ITINERARY.md`](../../../../construction/ITINERARY.md)
- **Scribe reader:** [`../../../../scribe/reader.rye`](../../../../scribe/reader.rye)
- **Scribe dashboard:** [`../../../../scribe/dashboard.rye`](../../../../scribe/dashboard.rye)
- **Tab pattern:** [`../../../../terrarium/app/TabSetup.swift`](../../../../terrarium/app/TabSetup.swift)

## The Scribe vs Brix distinction (approved by Keaton `20261108`)

**Scribe** = user preferences -- what a person changes in a settings panel. `.kyri` format.
Test: "Could a person change it in a settings panel?" -> Scribe.

**Brix** = system composition -- what a builder writes as a declarative manifest. `.brix` format,
following the infuse.nix composable pattern (each module owns its own declaration; the Steward
composes them). Test: "Does it describe what the system is made of?" -> Brix.

## Scope -- five movements, one phase

| Movement | What it proves | Signal |
|---|---|---|
| 1. Settings format and writer | `.kyri` settings round-trip: write defaults, read back, verify | selftest GREEN |
| 2. Scribe Vantage FFI bridge | Swift can load and save settings through C exports | selftest GREEN |
| 3. Settings tab scaffold | `focusScribe()` renders a panel with controls | tab visible in Terrarium |
| 4. Live persistence | Changes save on edit, load on launch | restart preserves settings |
| 5. Integration witness | End-to-end: write, read, render, persist, verify | witness GREEN |

## Settings (first resident)

These are the preferences a person changes on first use:

| Key | Type | Default | What it does |
|---|---|---|---|
| `theme` | string | `system` | `light`, `dark`, or `system` (follow OS) |
| `font_size` | integer | `13` | Editor font size in points |
| `sidebar_visible` | bool | `true` | Whether the sidebar panel shows |
| `recent_limit` | integer | `10` | How many recent projects to remember |
| `audio_monitor` | bool | `false` | Whether audio input monitoring is on by default |

The settings file lives at `~/.grain/scribe/settings.kyri` -- a path inside the user's home,
outside the project tree, so preferences travel with the person rather than the project.

## What stands when this SLC ships

A person opens Terrarium, taps the Settings tab, changes their theme and font size, closes the app,
reopens it, and finds their choices waiting. The settings are plain `.kyri` text a person can read
and edit by hand. Other stations (Dimeroll, Bloom, Audio) can query the current font size or theme
through the same Vantage bridge.
