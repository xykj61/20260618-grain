# Scribe Settings SLC -- Checklist

**Stamp:** `20261108.131904`
**Status:** Active

## Phase 1 -- Scribe Settings (5 movements)

- [x] **Movement 1: Settings format and writer** -- define `format scribe-settings-v1`, add `is_settings()` to reader, write `scribe/writer.rye` for serialization, selftest round-trip GREEN
- [x] **Movement 2: Scribe Vantage FFI bridge** -- `scribe/scribe_vantage.rye` with C exports (`scribe_settings_load`, `scribe_settings_save`, getters), build as dylib, C header, modulemap
- [x] **Movement 3: Settings tab scaffold** -- `focusScribe()` in TabSetup.swift following the NSTabViewItem pattern, basic panel with theme/font/sidebar controls
- [ ] **Movement 4: Live persistence** -- settings save on change through FFI, load on app launch, other tabs can query
- [ ] **Movement 5: Integration witness** -- end-to-end: create settings file, verify round-trip through FFI and UI, witness GREEN

## Progress

| Movement | Stamp | Commit | Fascia |
|---|---|---|---|
| Settings format and writer | `20261108.133227` | `fec08383ae` | 60.141 |
| Scribe Vantage FFI bridge | `20261108.135617` | `fa6d4405e6` | 60.142 |
| Settings tab scaffold | `20261108.141106` | `5c9510c4ec` | 60.143 |
