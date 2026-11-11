# Mantra Store

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261111.120000` - **Status:** Living

---

Mantra is a content-addressed blob store. You hand it bytes and it gives you
back a digest -- a fixed-length fingerprint computed from the content itself.
Ask for that digest later and you get the same bytes, guaranteed, because the
address is the content. A catalog sits on top: a table mapping human-readable
paths to digests, so you can find a blob by name as well as by hash.

## What you see in Terrarium

Open the **Mantra** tab. Three things appear:

1. **Store path** -- the directory on disk where blobs and the catalog live,
   shown in a monospace label. By default this is `~/.grain/mantra/`.

2. **Entry count** -- how many entries the catalog holds.

3. **Catalog table** -- a scrollable list with three columns: **Path** (the
   human-readable name), **Digest** (the content hash, truncated for display),
   and **Size** (the blob size in bytes). Each row represents one piece of
   stored content.

The tab loads the catalog from `~/.grain/mantra/catalog.kyri` on open. Blobs
live as flat files under `~/.grain/mantra/blobs/`, each named by its digest.

## How content addressing works

When you add content to Mantra, the module computes a cryptographic digest of
the bytes. That digest becomes the blob's address. To verify a blob later, you
recompute the digest and compare -- if the bytes have changed, the digest will
not match. This is the same principle behind Git objects and content-addressed
storage systems everywhere: the address proves the content.

`mantra_verify` does exactly this check: it takes a digest and the bytes, and
returns whether they match.

## The C-ABI surface

The Rye module exports through `vantage/include/vantage_mantra.h`:

| Function | What it does |
|---|---|
| `mantra_init` | initialize the Mantra runtime |
| `mantra_digest` | compute a digest from a byte buffer |
| `mantra_verify` | check whether bytes match a digest |
| `mantra_catalog_add` | add a path-to-digest mapping |
| `mantra_catalog_count` | return the number of catalog entries |
| `mantra_catalog_list` | list catalog entries into a caller-owned buffer |
| `mantra_catalog_get_digest` | look up a digest by path |
| `mantra_catalog_save` | persist the catalog to disk |
| `mantra_catalog_load` | restore the catalog from disk |
| `mantra_selftest` | prove the module's own invariants |

## Where it lives on disk

```
~/.grain/mantra/
    catalog.kyri      the path-to-digest table
    blobs/            one file per blob, named by digest
```

Both the catalog and the blob directory are created automatically when
`mantra_init` runs for the first time.

## What to read next

- [Terrarium Quick Start](../tutorials/terrarium-quick-start.md) -- build
  Mantra as part of the full stack
- The Vantage bridge source at `mantra/mantra_vantage.rye`
