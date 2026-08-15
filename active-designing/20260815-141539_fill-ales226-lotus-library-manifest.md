# Fill lotus-audio — Lotus library_manifest: a keeper's whole catalog, content-addressed

**Stamp:** `20260815.141539` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Chapter:** Six-Chapter double-seat, Chapter C (Lotus · the creative suite) · waymark **lotus-audio** · rung **lotus-audio**
**Kin:** [`../lotus/album_manifest.rye`](../lotus/album_manifest.rye) (lotus-audio — the sealed album content-address this reads and mirrors one level up) · [`../lotus/seal.rye`](../lotus/seal.rye) (lotus-audio — the verify-before-trust frame reused whole) · [`20260815-140211_fill-ales224-lotus-album-manifest.md`](20260815-140211_fill-ales224-lotus-album-manifest.md)

## The crux

lotus-audio sealed a single record's content address, and lotus-audio drew its page. Yet a working creator holds more than one record — a musician a discography, a podcaster many seasons, a filmmaker a body of work. That whole catalog wants one short, citable, sealed name, so a keeper can publish, cite, or compare an entire body of work without shipping a byte of audio to do it. This rung seats it.

The honest crux is *how* the catalog composes upward. The album frame (lotus-audio) laid whole bundles side by side, and that worked because a record's bundles total tens of megabytes. A library that inlined whole album frames the same way would multiply an album's own ceiling by the catalog size — tens of gigabytes in one buffer, past `u32`, past any real keeper's RAM. The composition that scales is the one lotus-audio already chose: **content-addressing.** A library names each album by the Sha256 of its sealed `album_manifest` bytes, exactly as an album manifest names each track by the Sha256 of its bundle. Digests compose upward where bytes cannot — a library manifest stays a few kilobytes no matter how large the records it fixes.

This is `album_manifest` one level up, unchanged in shape: `track → album`, `bundle → album_manifest`. No new hash, no new frame, no new grammar — the seal binds the listing's text, and each album's own content address (its manifest digest) binds that whole album.

## What lotus-audio adds

`lotus/library_manifest.rye`, standing on `seal.rye` (lotus-audio) and `album_manifest.rye` (lotus-audio):

- `AlbumIn { name, album_manifest }` — an album's display name and its sealed lotus-audio `album_manifest` bytes (the album's content address in full).
- `seal_library_manifest(out, albums) → u32` — hash each album's `album_manifest` bytes, then render a `count <n>` line and one `album <name> <digest>` line per album inside a `seal.begin`/`finish` frame under the header `format lotus-library-v1`. Refuses `TooManyAlbums` past the bound, `NameTooLong` for a name that is not a single token, `Overflow` rather than writing past the buffer.
- `open_library_manifest(text) → LibraryManifest` — `seal.open` recomputes and refuses `DigestMismatch` / `BadRecord` before a field is read; only a whole record's body is parsed into the ordered `(name, digest)` catalog.
- `verify_library(lm, albums) → void` — confirm a collection of `album_manifest`s in hand IS the record the library names: the count must match, then each album's name and recomputed `album_manifest` Sha256 must match, in order. A swapped, edited, missing, or added album refuses by name before the catalog is trusted.

`LibraryManifestError = seal.SealError || error{ BadLibraryManifest, NameTooLong, TooManyAlbums, CountMismatch, AlbumNameMismatch, AlbumDigestMismatch }`.

## The laws the witness proves on metal

- **THE CONTENT-ADDRESS LAW** — seal then open recovers the count and every `(name, digest)` in order; `verify_library` accepts the exact albums.
- **THE TAMPER LAW** — a flipped byte in any album's manifest refuses `AlbumDigestMismatch`; a swapped album name `AlbumNameMismatch`; a dropped album `CountMismatch`.
- **THE SEAL LAW** — a tampered body refuses `DigestMismatch`; a wrong header `BadRecord` (inherited from lotus-audio).
- **THE GRAMMAR LAW** — a spaced name refuses `NameTooLong` at seal; a count past the bound `TooManyAlbums`; a malformed body `BadLibraryManifest` at open.
- **THE ATOMIC LAW** — a too-small buffer refuses `Overflow`, nothing truncated.

## Honest scope

Software only, purely local — a Sha256 record over in-process bytes, siloed to `lotus/`. Content-addressing, never a signature: it proves a catalog's identity is whole, **not** who made it — no key, no custody, no real file, no DAC, no network, no funds, no real device. No custody gate. The signed carry that names *who made it* remains a later crypto seam on Keaton's word.
