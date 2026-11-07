# The Handheld Surface

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this page teaches

A handheld surface is a small device you carry with you -- a phone, a
tablet, or something in between -- that connects to your home forge and
asks it questions on your behalf. It holds your key, shows you the
answers, and keeps the conversation sealed between your hand and your
home.

This page explains what a handheld surface is, what it needs, and how it
fits beside the forge.

## Why a separate device

A home forge is powerful, yet it stays at home. You cannot carry 128
gigabytes of memory in your pocket, and you should not have to. The work
divides naturally:

- **Heavy thinking** happens at home, on the forge.
- **Asking and reading** happens wherever you are, on the handheld.

This is the two-body design: two devices, each doing what it does well,
joined by a sealed channel that carries your own key.

## What the handheld needs

A handheld surface needs three things:

1. **A key only you hold.** The device carries your identity -- a
   cryptographic key that proves you are you, without asking anyone
   else's permission. When the handheld asks the forge a question, the
   key seals the channel so nobody in between can read it.

2. **Low power and long life.** The handheld does not run the model
   itself. It sends questions and receives answers, which takes very
   little energy. A device built for this work can last a full day on a
   single charge, because it is not trying to do the heavy thinking
   locally.

3. **Firmware you can inspect.** The programs running on the device's
   own chips -- the radio, the screen controller, the storage -- should
   be ones a community can read and verify. No single device today
   maximizes firmware freedom, security, and open inference all at once.
   The two-body design is honest about this: the handheld prioritizes
   simplicity and openness, while the forge handles the rest.

## How the two bodies talk

The channel between the handheld and the forge is called Comlink. It
carries questions from your hand to your home and answers back again,
sealed by your key the whole way.

When you are at home, the channel runs over your local network -- fast
and private by default. When you are away, the channel runs over the
wider network, yet the seal stays the same. Nobody between you and your
forge can read the conversation, because the key never leaves your
device.

## What a handheld surface is not

A handheld surface is not a phone that does everything. It does not try
to run a language model on its own processor, and it does not send your
questions to a company's cloud. It is a window into your own forge --
light, simple, and honest about where the thinking happens.

It is also not a device that works alone. Without a forge to answer it,
the handheld is a key and a screen. The two-body design needs both
halves to do its full work, and that honesty is the point: a device that
claims to do everything on its own is making a promise about either
privacy or capability that it cannot keep.

## The three-way choice

No single device today gives you everything at once:

- **Firmware freedom** -- a device whose every chip runs code you can
  read. Processors from Rockchip and similar makers come closest.
- **Hardened security** -- a device whose operating system is locked
  down against tampering. GrapheneOS on a Pixel phone is the current
  standard here.
- **Open inference** -- a device powerful enough to run a language model
  locally. AMD's current mobile processors come closest.

The two-body design does not pretend this trade-off away. It splits the
work: the handheld takes the first two (simplicity and openness), while
the forge at home takes the third (inference power). Between them, you
get all three -- honestly, without a single device that claims to be
everything and delivers on none of it fully.

---

*May every hand that reaches find its own forge answering.*
