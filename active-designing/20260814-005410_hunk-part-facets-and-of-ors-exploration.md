# open-image — the faceted query: OR within a facet, AND across facets

**Stamp:** `20260814.005410` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable, no gate)
**Chapter:** A (Hardware & Right-to-Repair) · **waymark:** open-image · **journey:** parts-marketplace · **rung:** open-image
**Kin:** [`../image/part_and.rye`](../image/part_and.rye) (open-image conjunction) · [`../image/part_or.rye`](../image/part_or.rye) (open-image disjunction) · [`../image/part_filter.rye`](../image/part_filter.rye) (open-image `matches`) · [`../image/part_query.rye`](../image/part_query.rye) (open-image `parse_query`)

---

## Why this rung

open-image gave the marketplace an AND of clauses, open-image an OR of clauses. Yet a real facet sidebar runs on *both at once*, in a fixed shape: checking two values of **one** facet widens (a keeper wants stainless **or** brass), while checking **different** facets narrows (stainless-or-brass **and** under a dollar). That is the canonical faceted query — a **conjunction of disjunctions**: OR within a facet, AND across facets. This rung is that join, composing open-image's per-group union with open-image's across-group intersection, so the one grammar a hardware store actually needs stands whole.

## The crux

The durable property is that **a line is an AND of OR-groups, and a part is kept exactly when every group has at least one clause it matches**. The grammar carries the two levels plainly: the line is space-separated **groups**, each group a `|`-separated list of `key:value` clauses. `material:stainless-304|material:brass max:100` means *(stainless OR brass) AND (≤ 100 cents)*. No new matching rule is invented — a group is open-image's `matches_any` over its `|`-clauses, and the line is those group verdicts under AND, exactly as open-image already ANDs single clauses.

Three laws make the composition honest and checkable:

- **The backward-compatibility law.** A line with no `|` is an AND of one-clause groups — precisely open-image's conjunction. So `part_facets` filtered over a `|`-free line equals `part_and.filter_and` over the same line, part for part. The new grammar is a strict superset that never disturbs the old.
- **The identity law.** An empty line is zero groups — a match-*all* (the empty AND is true, the conjunction's identity), exactly as open-image's empty line is. A hand-built group holding zero clauses is a match-*none* for that group (the empty OR is false), so the whole line keeps nothing — the honest AND-of-OR composition, never softened.
- **The distribution cross-check.** `(a|b) AND c` keeps exactly the parts `a AND c` keeps unioned with those `b AND c` keeps — the algebra's own distribution, a free check against open-image run twice.

## Shape

`image/part_facets.rye`, composing the two proven layers:

- `parse_group(tok) -> !OrQuery` — read one space-free group (`key:value` clauses joined by `|`) into a open-image `OrQuery`, each clause parsed by open-image's `parse_query`. A group token always yields at least one clause.
- `parse_facets(text) -> !FacetQuery` — read the whole line into a bounded `FacetQuery` (`max_groups` groups, each a bounded `OrQuery`), tokenizing on space into groups and each group by `parse_group`. Zero groups is a match-all query.
- `matches_all_groups(cat, i, fq) -> bool` — does part `i` satisfy *every* group (each by open-image's `matches_any`)? Zero groups is trivially true (match-all).
- `count_facets` / `filter_facets` — the bounded count and the fresh sub-catalog over the same shared sheet, each part once in held order — an ordinary `PartCatalog` that paints, pages, and round-trips like any other.
- Refuses by name: a malformed clause surfaces `parse_query`'s own error (`UnknownKey`, `NoColon`, …); an over-long line refuses `TooManyGroups`; an over-wide group refuses `part_or`'s `TooManyClauses`; a hand-built over-long text operand refuses `QueryTextTooLong` before any walk.

## Boundaries

The faceted query reads and compares; it moves nothing. A price clause compares a recorded cent count (custody gate #3 untouched). No network, no key, no funds. The result borrows the caller's own sheet exactly as the AND and OR do, so it never dangles. Bringing the faceted grammar to glass (a `facets_search_shelf` mirroring open-image and open-image) is a named horizon on the next rung.

*May a keeper widen within a facet and narrow across them in one honest line — the sidebar's true grammar, each group a union, the line their intersection, and the empty query read exactly as the algebra says.*
