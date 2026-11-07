# Surf Social -- A Social Surface on the Grain Network

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

This page explains what Surf Social is, how it works on top of the
Grain network, and why a social surface built this way is different
from what most people use today. You will learn how posts are stored,
how feeds are assembled, and what it means for every message to belong
to the person who wrote it.

## What Surf Social is

Surf Social is a way for people on a Grain network to share updates,
photographs, and messages with each other. It is built on top of
Skate and Brushstroke -- the display and interface layers of the Grain
operating system -- so it runs on the same machine that runs everything
else. There is no separate app to download, no account to create with
a company, and no server in between.

The name comes from the same place as Skate: a surface you move across.
Surf is the social surface -- the place where a person reads what their
neighbors and colleagues have shared, and shares their own work in
return.

## How it works

Every galaxy in a Puddle can run a Surf instance. Here is what happens
underneath:

### Posts are Mantra facts

When ~marjoram writes a post -- say, "tomatoes ripening in field 3" --
that post becomes a fact in the Mantra log. It carries:

- The text of the post
- A timestamp from ~marjoram's local clock
- ~marjoram's Kumara signature, proving it wrote the post
- An optional attachment hash, if a photograph is included

The post is stored on ~marjoram's own machine first. It does not go to
a central server because there is no central server. It lives where it
was written.

### Feeds are local

When ~basil opens its Surf feed, here is what happens:

1. ~basil's machine checks which galaxies ~basil follows. Suppose
   ~basil follows ~marjoram, ~sunflower, and ~oregano.

2. For each followed galaxy, ~basil's machine asks over Comlink:
   "What have you posted since I last checked?"

3. Each galaxy sends back its recent Mantra facts tagged as Surf posts.

4. ~basil's machine assembles these into a chronological feed --
   newest first, with no algorithm deciding what to show or hide.

The feed is assembled locally. No third party decides what ~basil sees.
The order is simple: newest first. Every post that ~basil's followed
galaxies have published appears in that order, without exception.

### Comments are exchanges

When ~oregano wants to comment on ~marjoram's post, it composes a
Mantra fact that references ~marjoram's original post by its hash:

```
type: comment
ref: <hash of marjoram's post>
from: ~oregano
text: Those look wonderful -- save me a crate?
```

~oregano signs this and sends it through Comlink to ~marjoram. Both
galaxies add the comment to their local Mantra logs. When ~basil
refreshes its feed and sees ~marjoram's post, it also fetches the
comments, including ~oregano's reply.

## A walkthrough

Here is a short exchange among three galaxies:

1. **~marjoram posts.** "Tomatoes ripening in field 3. First harvest
   this Saturday." The post is signed, stored locally, and available
   to any galaxy that follows ~marjoram.

2. **~basil sees it.** ~basil's Surf feed refreshes and pulls
   ~marjoram's new post. ~basil reads it in the feed alongside posts
   from ~sunflower and ~oregano.

3. **~oregano comments.** ~oregano opens ~marjoram's post in its own
   Surf view and writes: "We will bring crates. How many do you need?"
   The comment is a signed Mantra fact referencing ~marjoram's post.

4. **~marjoram replies.** "Twelve should be enough. Thank you."
   Another signed fact, referencing ~oregano's comment.

5. **Everyone sees the thread.** Any galaxy following ~marjoram can
   pull the original post and its comments. The thread is a chain of
   signed facts, each pointing to the one before it.

## Design principles

### No central server

Every post lives on the machine of the person who wrote it. There is no
company holding a copy of everyone's posts on its own computers. If
~marjoram's machine goes offline, ~marjoram's posts are unavailable
until it comes back -- but they are never lost, because ~marjoram's own
disk holds them.

### Posts are signed and verifiable

Every post carries a Kumara signature. If someone claims ~basil said
something, anyone can check the signature against ~basil's public key.
A post without a valid signature is rejected. This means posts cannot
be forged or altered after the fact.

### The feed is yours

Your machine assembles your feed from the galaxies you chose to follow.
No algorithm promotes some posts over others. No company sells access
to your attention. The order is chronological, and the selection is
yours.

### Everything is append-only

Posts and comments are facts in the Mantra log. Once written and signed,
they are not edited or deleted by the system. A person can post a
correction or a retraction, and that too becomes a signed fact in the
log. The history stays whole, the way a journal does.

## Something to try

Think about a social network you use today. Pick one post from your
feed and ask: where does this post live? On your phone? On a company's
server? On both? Who decides whether you see it? Now imagine that same
post as a signed fact on your own machine, pulled into your feed because
you chose to follow the person who wrote it. What changes about your
relationship to that post?

---

*May the words you share travel on your own terms, and may every voice
on the network speak as itself.*
