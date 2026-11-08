# Surf Social SLC -- Checklist

**Stamp:** `20261108.165438`
**Status:** Active

## Phase 1 -- Surf Social (5 movements)

- [x] **Movement 1: Surf Vantage bridge** -- `surf/surf_vantage.rye` with C exports for keypair generation (Ed25519 via std.crypto), event creation (kind + content + timestamp), event signing, event verification, in-memory feed (add/count/list). Build as dylib, C header, modulemap. Selftest GREEN.
- [x] **Movement 2: Surf tab scaffold** -- new "Social" sidebar entry in Terrarium, timeline view with post display (author pubkey, timestamp, content), compose field at top
- [x] **Movement 3: Post persistence** -- events stored as Mantra blobs, feed catalog persisted to disk, timeline loads from store at launch
- [ ] **Movement 4: Feed composition** -- follow a pubkey, filter timeline by followed authors, unfollow. Local-only relay model (own events + followed feeds from Mantra store)
- [ ] **Movement 5: Integration witness** -- end-to-end: keypair gen, sign event, verify, store to Mantra, load feed, filter by author. GREEN on metal.

## Progress

| Movement | Stamp | Commit | Fascia |
|---|---|---|---|
| Surf Vantage bridge | `20261108.170653` | `3a01bf0530` | 60.151 |
| Surf tab scaffold | `20261108.171940` | `1a60c14438` | 60.152 |
| Post persistence | `20261108.173707` | `7bb7a761f4` | 60.153 |
