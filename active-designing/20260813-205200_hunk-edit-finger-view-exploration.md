# open-image — the finger-driven Photos editor: a finger edits the picture, the glass repaints, from one cursor

**Stamp:** `20260813.205200` · **Status:** Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **open-image** (Chapter A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Chapter A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-204548_hunk-edit-touch-input-exploration.md`](20260813-204548_hunk-edit-touch-input-exploration.md) — open-image's finger classifier · [`20260813-203500_hunk-edit-touch-view-exploration.md`](20260813-203500_hunk-edit-touch-view-exploration.md) — open-image's painted view
**Kin:** [`Lila and the Long Return`](../.claude/rules/lila-and-the-long-return.md) · [`../pond/apps/preset_touch_view.rye`](../pond/apps/preset_touch_view.rye) — open-image, the scroll arc's own capstone

---

## Why this round, now

The Photos editing arc now holds three proven pieces that still stand slightly apart. open-image reads a finger into an `edit_input.Gesture` (a tap on a strip commits a verb, a swipe walks the history) but moves no cursor. open-image owns a cursor and paints exactly its applied prefix, but takes a gesture already made, not a finger. open-image applies a gesture to a cursor. What a real device wants is one object it hands raw finger coordinates to and watches the picture change — the touch surface and the glass sharing one history.

The scroll arc closed exactly this at open-image: `TouchView` bound open-image's finger session and open-image's painted view to one cursor, so the page a keeper saw could never drift from where the finger scrolled. Reading **Lila and the Long Return**, the edit arc's own finger-driven view is the symmetric capstone — the last mile of the Photos editing story, composing only proven parts.

## The crux

> **A finger and the picture share one cursor: `finger_up` classifies the touch through open-image and, when a gesture fires, applies it through open-image to the one owned cursor; `paint` renders exactly that cursor's applied prefix. So a tap on the strip repaints the edited image, a left swipe repaints the earlier one, a right swipe the later — the glass can never drift from what the finger just did, structurally. The exact parallel of open-image for scroll.**

## The shape

`brushstroke/edit_finger_view.rye`:

- `EditFingerView { input: EditTouch, view: EditTouchView }` — the finger classifier (open-image) and the cursor-owning painted view (open-image), bound so the finger drives the view's one cursor.
- `open(cols, rows, cell_px, swipe_px)` — open both sub-surfaces, so a bad grid refuses `BadView` and a bad cell or swipe refuses `BadCell` / `BadSwipe`, each once at construction.
- `bind(edit)` — lay a verb onto the gesture strip (delegates to open-image's `bind`, refusing `StripFull`).
- `finger_down(x, y)` — arm the finger surface at the landing point.
- `finger_up(x, y)` — classify the completed touch; if a gesture fires, apply it to the view's cursor and return it, else return `null`. The one call that turns a finger into a picture change.
- `paint(allocator, source)` — the down-map of exactly the cursor the finger just moved (delegates to open-image's `paint`).
- `depth()` — the undo depth, for a caller's affordance.

The whole object adds no arithmetic and no new refusal — it only routes a finger through two proven seams into one shared cursor.

## What the witness proves on metal

An 8×8 two-tone image on a 2×2 grid over a one-verb strip (`flip_h`) on a ten-pixel cell: a fresh surface paints the source (the left cell red); a tap on the strip cell repaints the flipped image (the left cell blue) — the picture followed the finger; a left swipe repaints the source (red again); a right swipe repaints the flip (blue); a tap off the strip fires nothing and the picture is unchanged; `paint` equals a direct `view.paint` cell-for-cell (no drift); a zero grid and a zero cell each refuse at open by name. open-image classifier, open-image view, open-image seam, and open-image cursor GREEN beneath.

## Where this journey goes next (named intent, not yet built)

- **The strip painted beside the picture.** Render the gesture strip as a Skate row of verb chips above the image, so a keeper reads the palette they are tapping (reusing open-image's down-map for each chip).
- **A gesture session that travels.** Record the raw finger session content-addressed, so a keeper's whole touch edit reproduces from a name (composes open-image's edit store).

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The finger read is open-image; the picture is open-image; the move is open-image. No new arithmetic, storage, or render primitive.
- **Bounds, widths, asserts.** The grid bounded by the down-map ceiling, the strip by `max_strip`, the finger delta clamped; ≥2 positive invariants per function (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — a pure surface over proven seams.
