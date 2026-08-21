# open-image — the editing session survives a cold restart (undo *and redo* intact)

**Stamp:** `20260813.174500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — Chapter A (Hardware & Right-to-Repair) · waymark **open-image** · Photos-app journey · rung **open-image**
**Kin:** [`edit_cursor.rye` (open-image)](../image/edit_cursor.rye) · [`edit_store.rye` (open-image)](../pond/apps/edit_store.rye) · [`../.claude/rules/lila-and-the-long-return.md`](../.claude/rules/lila-and-the-long-return.md)

---

## Where the journey stands

The Photos app now edits without a wound (open-image), content-addresses the recipe (open-image), previews before committing (open-image, open-image, open-image), reverts (open-image), and walks a full undo/redo history through an `EditCursor` (open-image). One thing the cursor cannot yet do: **outlive the session that holds it.** Close the Photos app mid-edit — rewound two steps, a redo tail waiting — and the cursor lives only in memory. Reopen, and the road not taken is gone.

open-image already banks an *edit-list* content-addressed, and reproduces the edited image from cold. Yet an edit-list is only the applied recipe; it carries no live position and no redo tail. Storing the list alone would lose exactly what the cursor invented: the place a keeper stands, and the branch still reachable ahead of them.

## The crux

**Content-address the whole `EditCursor` — its full reachable history *and* its live position — so a cold reopen restores undo and redo both.** The one property a plain edit-list store cannot offer: a session reopened from cold still `can_redo()`, because the redo tail was stored, not just the prefix in effect.

This is the Lindy-durable close of the Photos-app persistence story: an editing session becomes a first-class content-addressed artifact, reproducible byte-for-byte out of the pair (source, session address), with the keeper's exact standing preserved.

## The shape (composition only — no new pixels, no new failure class of its own)

A new file `pond/apps/session_store.rye`, mirroring `edit_store.rye`:

- **Session record** — `format photo-session-v1`, then a `position N` line, then the whole `format photo-edits-v1` body (open-image's own render). A session honestly *wraps* an edit-list record, so the verb grammar is reused wholesale rather than duplicated.
- `render_session(cursor, out)` — write the header and `position`, then delegate to `photo_edits.render_edits` for the list body.
- `parse_session(text, out_cursor)` — check the session header, read the position, hand the remainder to `photo_edits.parse_edits`, then refuse `BadSession` if `position > list.count` (the cursor's governing invariant, checked at the trust boundary).
- `store_session(cat, store, name, cursor)` — render, then `tablecloth.store_artifact` (open-image) content-addressed; returns the beading report for the dedup dividend.
- `open_session(cat, store, name, out_cursor)` — `fetch_artifact` (every bead proven against its digest and the whole against its address **before** parse), then `parse_session`.
- `reopen_view(allocator, cat, store, name, source)` — `open_session` then `edit_cursor.view` over the source: the exact image the keeper last saw, from cold.

## What the witness must prove

1. **Undo *and redo* survive** — store a cursor rewound below its live edge (a redo tail present), reopen from cold, and the reopened cursor equals the original in both `list.count` and `position`, and still `can_redo()`. This is the crux open-image could not reach.
2. **The view from cold matches** — `reopen_view` equals the pre-store `view` byte-for-byte.
3. **The redo tail is real** — a `redo()` on the reopened cursor rolls forward to the same image the original would have.
4. **Dedup dividend** — the same session under two names is stored once.
5. **Verified before parse** — a tampered session refuses `DigestMismatch`, an unknown name refuses `UnknownArtifact`, each before a verb is read.
6. **Position bound** — a stored session claiming `position` past its list refuses `BadSession`; a bad header refuses `BadSession`.

No network, no key, no funds — pure composition over public APIs, exactly the register of every open-image rung so far.

## Why this is the next Lindy crux

An editing session that cannot survive a restart is a demo, not a tool. Making the session a content-addressed artifact is read once and relied on for years: it closes the open→edit→undo→reopen loop the Photos app has been building rung by rung, and it does so with no new storage model and no new pixels — only the small recipe, plus the one number that says where the keeper stands.
