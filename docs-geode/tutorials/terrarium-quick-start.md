# Terrarium Quick Start

*From clone to a living world under glass. Five build steps, one launch,
everything on your own machine.*

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261111.105550`
**Status:** Living
**Room:** checkable
**You will need:** macOS with Xcode command-line tools installed (`xcode-select --install`), about ten minutes, and a terminal.
**Where this sits:** home is [`../../README.md`](../../README.md) - the whole
path from nothing to a signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

---

## What you are about to do

You are going to build Terrarium -- the macOS native application that brings
the whole Grain stack together in one window. When you are done you will have
a running app with five tabs:

- **Bloom** -- educational content organized into galaxies of lessons
- **Dimeroll** -- an accounting ledger with chart of accounts
- **Audio** -- a mixer and waveform display powered by CoreAudio
- **Social** -- a feed where identities post, follow, and relay over UDP
- **Store** -- a content-addressed blob store you can browse

Each tab is backed by a Rye module compiled to a native shared library.
The Swift shell in `terrarium/app/` calls those libraries through a C
bridge, which is how one window holds five modules written in two
languages.

## 1. Clone

If you already have the tree, skip to step 2.

```sh
git clone https://github.com/grain-ww/grain.git
cd grain
```

The public seed is `grain-ww/grain`. Everything below runs from the
repository root.

## 2. Build SkateCore

SkateCore is the Swift framework that Terrarium's UI components share.
It compiles from the `skate/Sources/SkateCore/` directory into a dynamic
library.

```sh
swiftc -parse-as-library -module-name SkateCore -emit-module \
  -emit-module-path terrarium/.build/SkateCore.swiftmodule \
  -emit-library -o terrarium/.build/libSkateCore.dylib \
  skate/Sources/SkateCore/*.swift
```

When this finishes you will see two new files in `terrarium/.build/`:
`libSkateCore.dylib` and `SkateCore.swiftmodule`.

## 3. Build the Vantage bridges

Each Rye module exposes its logic through a C-compatible shared library.
Six modules need building. The Rye compiler lives at `rye/bin/rye` and the
Zig toolchain at `vendor/zig-toolchain/zig` -- both are carried in the
tree, so there is nothing to install.

```sh
# Bloom -- educational content
rye/bin/rye build-lib vantage/bloom.rye -dynamic \
  -femit-bin=vantage/lib/libbloom.dylib

# Dimeroll -- accounting
rye/bin/rye build-lib vantage/dimeroll.rye -dynamic \
  -femit-bin=vantage/lib/libdimeroll.dylib

# Lotus Audio -- mixer and waveform (needs CoreAudio)
env RYE_ZIG=vendor/zig-toolchain/zig \
  rye/bin/rye build-lib lotus/lotus_vantage_audio.rye -dynamic \
  -femit-bin=vantage/lib/liblotus_audio.dylib \
  -lc -framework AudioToolbox -framework CoreAudio

# Scribe -- settings and configuration
rye/bin/rye build-lib scribe/scribe_vantage.rye -dynamic \
  -femit-bin=vantage/lib/libscribe.dylib

# Mantra -- content-addressed blob store
rye/bin/rye build-lib mantra/mantra_vantage.rye -dynamic \
  -femit-bin=vantage/lib/libmantra.dylib

# Surf -- social identity, feed, and relay
env RYE_ZIG=vendor/zig-toolchain/zig \
  rye/bin/rye build-lib surf/surf_vantage.rye -dynamic \
  -femit-bin=vantage/lib/libsurf.dylib -lc
```

Each command produces one `.dylib` file in `vantage/lib/`. The C headers
that Swift reads live in `vantage/include/module.modulemap`.

## 4. Build Terrarium

Now the Swift shell links against everything you just built:

```sh
swiftc -I terrarium/.build -I vantage/include \
  -L terrarium/.build -L vantage/lib \
  -lSkateCore -lbloom -ldimeroll -llotus_audio \
  -lscribe -lmantra -lsurf \
  -o terrarium/.build/Terrarium terrarium/app/*.swift \
  -framework AppKit
```

This produces the binary at `terrarium/.build/Terrarium`.

## 5. Launch

Tell the system where to find the shared libraries, then run:

```sh
DYLD_LIBRARY_PATH=terrarium/.build:vantage/lib \
  terrarium/.build/Terrarium
```

A window opens. You will see a sidebar on the left with five tabs. Click
each one to explore:

- **Bloom** shows galaxies of educational content with navigation buttons
- **Dimeroll** shows a chart of accounts and transaction categories
- **Audio** shows a mixer panel with gain faders and a waveform display
- **Social** shows a compose field and a timeline -- posts you create here
  are signed with an Ed25519 identity generated on first launch
- **Store** shows a three-column catalog of content-addressed blobs

## If something goes wrong

**`swiftc` not found.** Install Xcode command-line tools:
`xcode-select --install`.

**`rye/bin/rye` not found.** The Rye compiler is carried in the tree.
If it is missing, the public seed may not include it -- follow
[The First Hour](the-first-hour.md) to fetch and build the toolchain
first.

**Library not found at runtime.** Make sure `DYLD_LIBRARY_PATH` names
both `terrarium/.build` and `vantage/lib`, separated by a colon.

**AudioToolbox framework error.** The Lotus Audio bridge needs
CoreAudio, which ships with macOS. If the framework is missing, check
that Xcode command-line tools are installed.

## What to read next

- [Building Vantage](building-vantage.md) -- how the Rye-to-C bridge
  works and how to run each module's selftest
- [Bloom Demos in Terrarium](bloom-demos-in-terrarium.md) -- navigating
  the educational content
- [The First Hour](the-first-hour.md) -- the longer path from nothing
  to a working tree, including the Rye toolchain build

---

*May the living world under glass feel glad to be opened, and may
every tab answer as clearly as the code that backs it.*
