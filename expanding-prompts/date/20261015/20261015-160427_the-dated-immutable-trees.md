# The dated immutable trees -- a new deliberate beginning

**Stamp:** `20261015.160427` -- **Style:** Radiant, at the Door setting -- **Voice:** Kyri
**Audience:** a generic Acme Corporation employee tending any machine in this fleet.

## The idea, plainly

A tree that has grown fast and wide becomes hard to read all the way down. Rather than rewrite
the overgrown field in place, we begin a fresh, simple one beside it and let the elder rest as a
prototype. This is Gall's Law made literal: a working complex system grows from a working simple
one. Conway's Law rides with it: we shape the tree to match how the work truly happens -- one hand,
reading every line -- rather than how an org chart imagines it. The order is Simple, then Lovable,
then Complete.

Each tree now carries the date of its own first commit as an immutable prefix, the way the folders
inside it carry the date of their making: `YYYYMMDD-grain-<ship>`. The prefix never moves. It is held
as one strand -- a single variable a script prepends (`tools/g/grain_prefix.sh`) -- rather than written
into a thousand paths.

The new tree is `20261016-grain`, licensed under the GNU GPL version 3, so the near work -- a Caravan
supervisor in Rye, standing as a root task on the proved seL4 microkernel -- carries its freedoms to
whoever receives it. It begins nearly-blank on purpose, small enough to read entirely.

## What already landed on the originating pier (done, signed, verified)

- **Upstream repositories:** `xykj61/20260817-grain` (public, the full history copy), `grain-ww/grain`
  refreshed to today's seed and `grain-ww/20261015-grain` (public, the dated copy), and the two private
  new homes `xykj61/20261016-grain` and `grain-ww/20261016-grain`.
- **The tree** `~/20261016-grain-incense`: five signed commits (LICENSE, minimized context, README,
  the rule set, the foundations, the tooling seed), keys armed, fascia seeded at 70.0000, the seed
  publisher in place.
- **Disk:** the regenerable global Zig cache was cleared to reclaim room; all eight ship trees are intact.

## The hand-run steps, for each machine

Do these on the dallas-keeper pier, and on the macOS and Framework machines, each in turn.

1. **Pull, and choose the current tree.** Fetch and fast-forward the legacy tree. Where two folders
   could answer for one ship, keep the one that is newer and carries no uncommitted changes; set the
   others aside rather than deleting them.
2. **Rename the fleet folders (fleet quiesced).** Stop the watch and every loop first. From a shell
   that is NOT inside any grain tree, run `sh tools/f/fleet_rename_dated.sh 20260817`. It renames
   `~/grain-<ship>` to `~/20260817-grain-<ship>`, refuses a tree with uncommitted changes, skips a
   destination that exists, and repoints each moved tree's own `.git/config` signing and transport
   paths. A bare `~/grain` becomes `~/20260817-grain-incense`. The tree your shell is standing in must
   be renamed from a neutral shell and re-entered -- the shell cannot rename its own working directory
   out from under itself.
3. **Decouple the paths.** Source `tools/g/grain_prefix.sh` and use `$GRAIN_PREFIX` and `grain_home`
   where a script today writes a home path literally. The running watch is cut over last, after it is
   stopped, so a live process never reads a half-written script.
4. **Tomorrow, redate the private roots.** The private repositories are named 20261016; tomorrow,
   rebase each to its root and set the initial commit's date to 20261016 so the name and the date agree.
   Force-push the private repositories only.
5. **Arm the keys through the flow we already have.** Each machine's new tree takes its keyring and
   transport material through the fleet's existing birth-a-clone flow (`tools/b/birth_a_clone.rish`),
   which carries them into a newborn tree and rewrites the copied config to name that tree's own paths.
   The law is `.claude/rules/git-signing.md`: a tree carries its own keys, and the keyring is never
   tracked. No key material is written into this document; the flow does the carrying.

## Blind spots and open questions

- **The date name.** The earliest commit in the live `xy` history is dated 2026-07-13, while 20260817
  is the clean-history re-root date. The repositories and folders use 20260817 as instructed; confirm
  which date the name should honor.
- **GPLv3 and seL4.** The kernel is GPL-2.0 and the userlevel is BSD-2-Clause. A GPLv3 Caravan root
  task on the BSD userlevel is clean; any question of linking across GPL-2.0 and GPL-3.0 wants counsel
  before the first link rather than after.
- **The toolchain.** The new tree cannot yet run Glow, Rye, and Rishi; bootstrapping their toolchain
  from the 20260817-grain field is the first build lap, held so the tree stays readable while small.
- **The disk, long-term.** Clearing the cache bought room today; a larger volume or a standing prune
  would keep the loops from writing into a full disk some quiet night.

## The close

This is a good place to begin again: small enough to love, honest enough to trust, open enough that
whoever arrives next can read it all the way down. May the new field stay that way as it grows.
