# open-image — a keeper reads what is *inside* each installed book, not only how many

**Stamp:** `20260813.184630` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- self-approved design round · **Chapter A** (Hardware & Right-to-Repair) · **waymark open-image** · Photos-app journey · rung **open-image**
**Kin:** [`../pond/apps/preset_list.rye`](../pond/apps/preset_list.rye) (open-image) · [`../pond/apps/preset_store.rye`](../pond/apps/preset_store.rye) (open-image) · [`../image/filter_preset.rye`](../image/filter_preset.rye) (open-image)

## Where the road stands

open-image gave a keeper an honest index of their installed filter books — each book's name and *how many* presets it holds, read from a verified reopen. The daily question a keeper actually asks, though, runs one step deeper: *which* filters does a book hold? A count of nine says nothing about whether `noir` and `vivid` are on the shelf. open-image named this deeper index as its first horizon — a richer summary line carrying each book's preset names — and by Lila and the Long Return that is the next crux: the detail is read every time a keeper chooses a book, so the effort compounds, and it extends the proven grammar rather than inventing a new one.

## The keystone (open-image)

`pond/apps/preset_detail.rye`, mirroring `preset_list` seam-for-seam yet carrying the preset names:

- `detail_books(cat, store, out)` — walk the catalog, select every `.presets` artifact, `open_book` each **verified** (open-image — every bead proven against its digest and the whole against its recorded address before parse), and record a bounded `BookDetail`: the book's name plus the name of every preset it holds, each copied out of the verified reopen. The honesty guarantee stands unchanged from open-image — a tampered book makes the *whole* detailing refuse `DigestMismatch` rather than advertise a phantom.
- `render_detail` / `parse_detail` — the detailing travels both ways as a `format preset-detail-v1` record, one `book <name> <count> <preset…>` line per entry, so `render(parse(render(x)))` is a fixed point (open-image's idiom).

## The new property this rung earns

Beyond open-image's count, this rung carries a **self-consistency invariant that travels**: the declared `<count>` must equal the number of preset names that follow it on the line. A record whose header promises nine presets but lists eight names refuses `BadDetail` — the count can never drift from the names it counts, at the text edge, both ways. This is a property open-image's count-only line could not state, because it had nothing to check the count against.

## The properties the witness proves

1. **Names every installed book's presets** — the stock book details to its nine preset names in defined order (`vivid pop mono noir bright auto soft sharp sketch`), the custom book to its own; the non-book artifact is skipped, never opened.
2. **True names** — each preset name read from a verified reopen, not a stored string.
3. **Travels both ways** — the detailing renders to a bounded record and parses back to the same names, a fixed point.
4. **Count agrees with names** — a record whose count does not match its listed names refuses `BadDetail`.
5. **Refusals named** — a bad header, unknown tag, over-long name, malformed count, over-ceiling preset run, or count/name mismatch refuse `BadDetail`; too many entries `TooManyEntries`.
6. **Honest as a whole** — a tampered book makes the whole detailing refuse `DigestMismatch`.

No network, no key, no funds — a detailing reads the catalog, stores nothing.

## Horizons (named, not half-built)

- The Skate view of the detail (compose open-image's down-map or a plain text panel), a book shown as a shelf of named chips.
- Each preset carrying its edit-verb summary too (a nested body over `render_edits`) — a full contents page, not only names.
- The served detail — a Comlink-served contents page of a keeper's installed books (stops at the Comlink-served custody gate).
