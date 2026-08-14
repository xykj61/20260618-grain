# open-image — the touch session: finger down · move · up become a live cursor

**Stamp:** `20260813.201244` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Chapter:** A (Hardware & Right-to-Repair) · **Waymark:** open-image · rung **open-image**
**Kin:** [`preset_scroll_input.rye`](../pond/apps/preset_scroll_input.rye) (open-image) · [`preset_scroll_drag.rye`](../pond/apps/preset_scroll_drag.rye) (open-image) · [`preset_scroll_fling.rye`](../pond/apps/preset_scroll_fling.rye) (open-image) · [`../.claude/rules/lila-and-the-long-return.md`](../.claude/rules/lila-and-the-long-return.md)

---

## Where the touch-scroll journey stands

The journey has grown whole in parts: open-image the cursor, open-image the scrollbar, open-image the painted view, open-image the input seam, open-image the pixel-drag quantizer, open-image the fling. Each is a clean piece, and each is called separately. What a real device event loop wants is not six pieces — it is **one object it hands raw finger events to**. A touchscreen reports `finger down`, a stream of `finger move`, then `finger up`; between frames it `tick`s. The surface underneath should just scroll, drag under the finger, and coast when released. That single driver is the capstone crux — the durable public face of the whole stack.

## The crux — one small state machine

A touch session is three phases and the transitions between them:

- **idle** → `finger_down(y)` records where the finger landed and enters **dragging** (and cancels any coast in progress — the classic *grab-to-stop*).
- **dragging** → `finger_move(y)` drags the cursor by the pixel delta since the last position (open-image), remembering that delta as the live velocity.
- **dragging** → `finger_up()` releases: if the finger was still moving, it seeds a **fling** from the last velocity (open-image) and enters **flinging**; if it had come to rest, it returns to **idle**.
- **flinging** → `tick()` steps the fling one frame; when the fling settles, it returns to **idle**.

Every motion routes through the already-proven pieces, so the session invents no arithmetic and no new clamp — it is pure composition and a phase label. The one behaviour it *adds* is grab-to-stop: a fresh `finger_down` during a coast cancels the fling, exactly as a finger on a coasting list stops it dead.

## Shape

`pond/apps/preset_touch_scroll.rye`:

- `TouchScroll { phase, last_y, velocity, quant, fling, friction }` — the phase label, the last finger position, the live velocity, open-image's quantizer, and open-image's fling. `open(cell_px, friction_num, friction_den)` validates the cell height (open-image) and the friction (open-image) once, refusing `BadCellHeight` / `BadFriction`.
- `finger_down(y)` · `finger_move(cursor, y)` · `finger_up()` — the three events. Deltas are taken in `i64` and clamped to `i32` so a wild jump never wraps; the fling seed is clamped into the fling's own velocity cap so `finger_up` never fails.
- `tick(cursor)` — step one frame of coast, returning whether the session is still flinging; `settle(cursor)` runs the whole coast to rest under open-image's bounded ceiling.
- `is_flinging()` · `is_idle()` — the phase reads a surface paints against.

## What it proves on metal

Over the same real five-book library, a two-row viewport, a ten-pixel cell:

- **A pure drag** (down, a move, then a still finger before release) moves the cursor by the drag and returns to **idle** — no fling.
- **A flick** (down, a move while still travelling, release) enters **flinging**, and settling the coast advances the cursor further before it comes to rest **idle**.
- **Grab-to-stop:** a `finger_down` during a coast cancels the fling — the cursor freezes where the finger caught it, no further motion.
- Every clamp is inherited: a hard flick lands bottom-pinned, never past; the cursor never leaves its library through any event stream.
- `BadCellHeight` and `BadFriction` refuse at `open`.

## Not this rung

- **Velocity smoothing** (averaging the last few move deltas for a steadier fling seed) is a refinement — the last delta is the honest simple seed; named, not built.
- **Rubber-band overscroll** stays the named horizon from open-image.
- The **served-marketplace module-assembly ruling** (open-image checkpoint) stays held for Keaton's word.

*A touchscreen speaks three verbs — down, move, up — and one clock tick; the session is the small grammar that turns them into a page that scrolls, drags, and coasts to rest.*
