# Tablecloth -- Grain's application database and artifact store

**Language:** EN
**Status:** Living -- vector search folded in from mandate/ on Keaton's word (`20261111`)
**Where this sits:** home is [`../README.md`](../README.md) -- the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Voice:** Kyri
**Kin:** `pond/apps/tablecloth.rye` (the Brix-facing naming layer) -- `brushstroke/tablecloth.rye` (Brushstroke surface) -- `context/LEXICON.md`

Tablecloth is Grain's application database and artifact store. The naming layer
(`pond/apps/tablecloth.rye`) binds human-readable names to content-addressed beads in
Mantra's BeadStore. The vector store (this directory) holds the embeddings a model
turns meaning into, and answers the one question a vector store exists for: *which of
my records is nearest this query?*

## The vector store

These files carry the vector search capability that folded in from `mandate/` on
`20261111`. The design essay at
`active-designing/date/20261111/20261111-121521_mandate-folds-into-tablecloth-colloquium-born.md`
records the decision and its evidence.

- **Cosine similarity, via unit vectors.** Nearness is the angle between two
  directions. The store normalizes every vector to length one on upsert, so a query
  is a plain dot product, every norm already spent at upsert time.
- **Zero-copy.** A query borrows each record where it sits, reading it in place by
  reference and accumulating the dot product.
- **Bounded, exact.** The store (`max_records`), the dimension (`max_dim`), and the
  result count (`max_k`) each name a maximum, enforced at the edge. Search is exact
  brute-force k-nearest -- every record considered -- correct at this scale.
- **Profile-loaded dimension.** The active dimension is data, set at `init(dim)`,
  bounded by the comptime `max_dim`. One compiled binary serves any dimension from
  1 to `max_dim`.
- **Approximate index.** `query_approx` is a SimHash / random-hyperplane LSH index
  beside the exact path.
- **Object-storage backing.** The whole store serializes to one portable blob --
  `snapshot` writes it, `restore` rebuilds it, with every field validated against
  the store's bounds.
- **Full CRUD.** `upsert`, `query`, and `remove` close create-read-update-delete,
  each bounded.

## The naming layer

`pond/apps/tablecloth.rye` is the naming layer over `mantra/beading.rye`'s
content-addressed BeadStore. Artifacts are beaded into the shared store; the catalog
binds human names to content addresses. The whole digest and bead-index recipe prove
themselves.

## Build and prove

```
mkdir -p tablecloth/bin
rye build tablecloth/store.rye -femit-bin=tablecloth/bin/store
tablecloth/bin/store selftest
rishi/bin/rishi run tools/t/tablecloth_store_witness.rish
```

## Gleaner

Gleaner is a designed Tablecloth aspect (Lexicon line 464) -- the public signal
fetcher. Not yet built; named here so the next hand finds the connection.
