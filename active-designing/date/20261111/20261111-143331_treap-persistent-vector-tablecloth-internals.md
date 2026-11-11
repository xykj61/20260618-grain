# Treaps and Persistent Vectors -- Tablecloth's Internal Data Structure

**Language:** EN
**Status:** Checkable -- research, no code
**Room:** research for understanding
**Stamp:** `20261111.143331`
**Voice:** Kyri
**Style:** Gauge at Field
**Kin:** `tablecloth/README.md` -- `tablecloth/store.rye` -- `context/TAME_GUIDANCE.md` -- `foundations/20260729-224828_reds-first-and-the-allocation.md`

---

## The question

Tablecloth's vector store runs exact brute-force k-nearest search: every record
considered, every time. That is correct at this scale and will stay correct for a
long time. This essay asks what data structure Tablecloth should grow toward
when the scale outgrows brute force -- not to build one today, yet to know where
the road leads before walking it.

Two candidates rise from the ancestry: **treaps**, which Urbit's Hoon uses as the
basis for maps and sets, and **persistent vectors**, which Clojure uses for its
immutable collections. Both carry properties Tablecloth wants. Neither is free.

## Treaps -- a randomized BST with heap-ordered priorities

A treap (Aragon and Seidel, 1989) is a binary search tree where each node carries a
key and a random priority. The keys obey BST order (left < node < right); the
priorities obey heap order (parent >= children). The random priorities keep the tree
balanced in expectation, without rotations or rebalancing metadata.

**What they give.**

- **Expected O(log n)** for insert, delete, lookup, and split/merge. The bound is
  probabilistic and depends on the priority distribution rather than on the input order.
- **Structural sharing.** A persistent treap shares unchanged subtrees between versions,
  so an insert that touches O(log n) nodes copies O(log n) nodes and shares the rest.
  This is how Urbit's `++put:by` works: each mutation yields a new root, and the old root
  stays valid.
- **Split and merge.** A treap splits into "everything below k" and "everything above k"
  in O(log n), and two treaps merge in O(log n). These are the operations a range query
  and a bulk update want.
- **Deterministic shape from priorities.** Given the same set of (key, priority) pairs,
  the treap has exactly one shape, regardless of insertion order. This makes two
  independent treaps over the same data identical, which is a useful property for
  replication and verification.

**What they cost.**

- **Random access is O(log n)**, not O(1). A vector store that needs to read record i by
  index pays log n for each access, where a flat array pays 1. For a brute-force scan
  that reads every record, the difference is n log n vs n.
- **Cache locality is poor.** A tree's nodes are scattered in memory; a flat array is
  contiguous. For the dot-product inner loop -- the hot path of a vector query -- cache
  misses dominate, and a tree layout hurts.
- **Priority generation needs randomness.** The quality of the balance depends on the
  quality of the priorities. A weak source (a counter, a hash of the key alone) degrades
  to a BST. Tablecloth would need a bounded PRNG per store, seeded at construction.

**Where they fit Tablecloth.**

Treaps are the right structure for **the naming layer** -- the catalog that maps
human-readable names to content addresses. That catalog is a key-value map with
ordered keys, and treaps are exactly key-value maps with ordered keys. The structural
sharing means a snapshot of the catalog is a pointer to a root, and the old catalog
survives the snapshot. The split/merge means a prefix query ("every name starting with
`receipt/`") is one split and one traversal.

Treaps are the **wrong** structure for the vector store's embedding matrix. The hot
path -- computing a dot product against every stored vector -- wants a contiguous
memory layout, not a tree of scattered nodes. A treap holding 10,000 128-dimensional
vectors would scatter 10,000 x 128 x 4 = 5 MB of floats across heap allocations, where
a flat array keeps them in one contiguous block that the prefetcher reads happily.

## Persistent vectors -- a wide trie with structural sharing

A persistent vector (Bagwell, 2001; adopted by Clojure and Scala) is a trie of
fixed-width arrays, typically branching factor 32. Each internal node holds up to 32
children; each leaf holds up to 32 elements. The tree is always balanced (every leaf at
the same depth), and the depth is ceil(log32(n)) -- at most 7 for 32^7 = 34 billion
elements.

**What they give.**

- **O(log32 n) lookup, update, append, and pop.** In practice this is 1-4 levels for
  any realistic collection, so it behaves like O(1) with a small constant.
- **Structural sharing.** An update copies one path from root to leaf -- ceil(log32(n))
  nodes of 32 pointers each -- and shares everything else. An append to a million-element
  vector copies roughly 4 nodes and shares the rest.
- **Contiguous leaves.** Each leaf holds 32 elements in a contiguous array. A scan over
  the whole vector reads leaves in order, hitting 32 elements per cache line fetch.
  This is much better than a tree of individual nodes, and only slightly worse than a
  flat array (the indirection per 32 elements costs one pointer chase).
- **Deterministic shape from size.** The trie structure depends only on the element count,
  not on the insertion order. Two vectors with the same elements in the same order have the
  same shape.

**What they cost.**

- **The constant factor is real.** Each level of indirection costs a pointer chase and a
  shift-and-mask to extract the index bits. For a tight inner loop (a dot product over
  128 floats), that overhead matters.
- **Deletion from the middle is expensive.** Removing element i requires copying every
  leaf after i. This is O(n) in the worst case, which makes persistent vectors poor for
  arbitrary removal. Tablecloth's `remove` operation would need a tombstone or a
  compaction strategy.
- **32-wide nodes waste space when partially filled.** A vector of 33 elements uses two
  leaves (one full, one with 1 element) and wastes 31 slots. At scale this amortizes; at
  small scale it is a constant overhead.

**Where they fit Tablecloth.**

Persistent vectors are the right structure for **the vector store's record list** -- the
ordered collection of (id, embedding) pairs that the query scans. The contiguous leaves
give reasonable cache behavior for the scan, the structural sharing gives cheap snapshots,
and the append path (upsert a new record) is effectively O(1).

The deletion problem is real yet bounded: Tablecloth's `remove` already reassigns by
swapping the last record into the removed slot and decrementing the count. That same
strategy works in a persistent vector -- swap and pop rather than splice.

## The two-structure answer

Tablecloth wants both, each in its own role:

| Structure | Role | Operations |
|---|---|---|
| **Treap** | naming catalog -- maps names to content addresses | insert, delete, lookup, prefix query, snapshot |
| **Persistent vector** | record store -- holds (id, embedding) pairs for scan | append, update-in-place, swap-and-pop, scan, snapshot |

The treap gives the naming layer ordered keys and cheap range queries. The persistent
vector gives the record store contiguous-leaf scans and cheap snapshots. Both give
structural sharing, so a snapshot of the whole database is two root pointers.

## What stays, and what this changes

**The brute-force scan stays.** At 10,000 records x 128 dimensions, exact k-nearest
takes roughly 5 ms on modern hardware. The persistent vector's leaf layout keeps that
scan nearly as fast as a flat array. The SimHash approximate index stays as the
acceleration path for when the scale justifies it.

**The flat arrays in `store.rye` become the migration target.** Today `store.rye` holds
embeddings in a flat `[max_records][max_dim]f32` array, norms in a flat `[max_records]f32`
array, and ids in a flat `[max_records]u64` array. Each of these becomes a persistent
vector, one element per record. The scan reads leaves in order, which gives the same
cache behavior as today's flat array with 32-element granularity.

**The naming layer in `pond/apps/tablecloth.rye` adopts the treap.** Today it uses a
flat list of name-to-address bindings. A treap gives it ordered keys, prefix queries,
and structural sharing for free.

## What this does not reach

**Implementation.** This essay names the structures and their roles. Writing them in Rye
is a separate lap, bounded by TAME: explicit widths, bounded allocations, named errors,
asserted invariants.

**Benchmarking.** The cache-locality claims above are argued from architecture, not
measured. A persistent vector with 32-element leaves should scan within 2x of a flat
array for a dot-product workload; that claim wants a witness on metal before the
migration proceeds.

**The approximate index.** SimHash is orthogonal to the storage structure. It indexes
over whatever the store holds, and it stays.

## Ancestry and gratitude

The treap descends from Aragon and Seidel's 1989 paper and lives in Urbit's Hoon as
the basis for `++by` (maps) and `++in` (sets). The persistent vector descends from
Bagwell's 2001 "Ideal Hash Trees" paper and lives in Clojure as the basis for `vector`
and `hash-map`. Both are studied through this tree's clean-room discipline -- ideas
cross the boundary in words, never in code.

---

*Two structures, each in its own role, each carrying the property the other lacks. The
treap gives ordered keys; the persistent vector gives contiguous scans. Together they
hold everything Tablecloth asks for, and the structural sharing means a snapshot of the
whole database is a pair of pointers.*
