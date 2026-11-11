# Surf Social

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261111.120000` - **Status:** Living

---

Surf Social is a signed-post network built on Ed25519 cryptography. Every post
carries a public key, a signature, a timestamp, and the text itself. Nobody can
forge a post, and anyone can verify one, because the signature proves authorship
without needing a password server in between.

## What you see in Terrarium

Open the **Social** tab. Three things appear:

1. **Your identity** -- the first sixteen hex characters of your public key,
   shown at the top. A keypair is created from a random seed when you first
   open the tab and saved through the Mantra blob store so it persists
   across launches.

2. **A compose field** -- type a message and press Return. Your text is signed
   with your private key, added to the local feed, and displayed in the
   timeline below.

3. **A follow field** -- paste another user's public-key hex and press Follow.
   Posts from that key appear in your timeline alongside your own. A segmented
   control at the top lets you toggle between **All** (every post in the feed)
   and **Following** (only posts from keys you follow).

The post count updates live, and the timeline scrolls with newest posts at the
top.

## How the data is shaped

A post is called an **event** in the code. Each event carries:

- **pubkey** -- 32 bytes, the Ed25519 public key of the author
- **kind** -- a 4-byte integer (kind 1 is a text post)
- **created_at** -- an 8-byte Unix timestamp
- **content** -- up to 4,096 bytes of UTF-8 text
- **signature** -- 64 bytes, Ed25519 over the serialized event
- **event id** -- 64 hex characters, a SHA-256 digest of the event fields

The feed and the follow graph each serialize to blobs stored through the
Mantra store at `~/.grain/mantra/`. When you close and reopen Terrarium,
both are deserialized back into memory.

## The C-ABI surface

The Rye module at `surf/surf_vantage.rye` exports these functions through
`vantage/include/vantage_surf.h`:

| Function | What it does |
|---|---|
| `surf_init` | initialize the Surf runtime |
| `surf_keypair_from_seed` | derive an Ed25519 keypair from a 32-byte seed |
| `surf_event_id` | compute the SHA-256 event id for a set of fields |
| `surf_sign_event` | sign an event with a private key |
| `surf_verify_event` | verify an event's signature against its public key |
| `surf_feed_add` | append a verified event to the local feed |
| `surf_feed_count` | return the number of events in the feed |
| `surf_feed_list` | list event ids |
| `surf_feed_get_content` | read an event's text by index |
| `surf_feed_get_event` | read a full event by index |
| `surf_feed_serialize` / `_deserialize` | persist and restore the feed |
| `surf_follow` / `surf_unfollow` | add or remove a pubkey from the follow set |
| `surf_follow_count` | return the number of followed keys |
| `surf_follow_is_following` | check whether a pubkey is followed |
| `surf_feed_count_followed` | count events from followed keys only |
| `surf_feed_get_content_followed` | read text from the followed-only view |
| `surf_feed_followed_global_index` | map a followed-view index to the full feed |
| `surf_follow_serialize` / `_deserialize` | persist and restore the follow graph |
| `surf_selftest` | prove the module's own invariants |

## What to read next

- [Surf Relay](surf-relay.md) -- how posts travel between peers over UDP
- [Terrarium Quick Start](../tutorials/terrarium-quick-start.md) -- build and
  launch the whole stack
