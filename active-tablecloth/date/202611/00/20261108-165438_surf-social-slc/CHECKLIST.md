# Surf Social SLC -- Checklist

**Stamp:** `20261108.165438`
**Status:** Active

## Phase 1 -- Surf Social (5 movements)

- [x] **Movement 1: Surf Vantage bridge** -- `surf/surf_vantage.rye` with C exports for keypair generation (Ed25519 via std.crypto), event creation (kind + content + timestamp), event signing, event verification, in-memory feed (add/count/list). Build as dylib, C header, modulemap. Selftest GREEN.
- [ ] **Movement 2: Surf tab scaffold** -- new "Social" sidebar entry in Terrarium, timeline view with post display (author pubkey, timestamp, content), compose field at top
- [ ] **Movement 3: Post persistence** -- events stored as Mantra blobs, feed catalog persisted to disk, timeline loads from store at launch
- [ ] **Movement 4: Feed composition** -- follow a pubkey, filter timeline by followed authors, unfollow. Local-only relay model (own events + followed feeds from Mantra store)
- [ ] **Movement 5: Integration witness** -- end-to-end: keypair gen, sign event, verify, store to Mantra, load feed, filter by author. GREEN on metal.

## Progress

| Movement | Stamp | Commit | Fascia |
|---|---|---|---|
| Surf Vantage bridge | `20261108.170653` | `pending` | 60.151 |
