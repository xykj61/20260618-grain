# Launching the App

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** vision

---

## What this tutorial teaches

This tutorial walks through launching Terrarium for the first time. By
the end, you will know what the application window looks like, how the
tab bar works, how Terrarium finds your project files, and what
"building" means.

## What Terrarium is

Terrarium is a native macOS application written in Swift. It puts Grain's
entire system on your screen -- an emulated RISC-V computer, an
educational curriculum, a financial ledger, and an event log, each in its
own tab. The name comes from a terrarium: a living world under glass,
where you can observe everything that happens inside.

## Building the application

Before you can launch Terrarium, its source code must be compiled into a
program your Mac can run. This is called building. The build has two
steps:

1. **Build SkateCore.** This is the shared library that provides the
   display framework. The Swift compiler reads the source files under
   `skate/Sources/SkateCore/` and produces a compiled module and a
   dynamic library.

2. **Build Terrarium.** The Swift compiler reads `terrarium/app/main.swift`
   -- the single file that defines the application -- and links it against
   SkateCore to produce the Terrarium executable.

When the build succeeds, the executable appears at
`terrarium/.build/Terrarium`. If something goes wrong during building,
the compiler prints error messages explaining what it could not
understand. Most build errors come from a missing file or a typo in the
source code.

## What you see when it opens

When you launch Terrarium, a window appears with a tab bar across the
top. The tabs are:

- **Terminal** -- where the emulated RISC-V computer runs
- **Bloom** -- where the educational curriculum is displayed
- **Dimeroll** -- where the financial ledger is shown
- **Mantra** -- where the append-only event log is displayed

The Terminal tab is selected by default. You will see a dark area where
text output from the emulated computer appears.

## How the app finds the project

Terrarium looks for the Grain project directory by walking upward from
its own location on disk. It expects to find folders like `bloom/`,
`rye/`, and `terrarium/` in the project root. Once it finds the root, it
can load curriculum pages from `bloom/`, read witness scripts from
`tools/`, and display the Dimeroll ledger.

If Terrarium cannot find the project root, it will still launch, but
some tabs will show placeholder content instead of live data.

## How to tell it started correctly

A successful launch shows:

- The window appears with the tab bar visible
- The Terminal tab shows a text area ready for input
- Clicking the Bloom tab displays the curriculum -- the ten stages, the
  lineage teachings, and the ecology pages
- No error dialogs appear

If you see an error message about a missing library, it usually means
the build step was incomplete. Rebuild both SkateCore and Terrarium and
try again.

## Something to try

Launch Terrarium and click through each tab. You do not need to run
anything yet -- just look at what each tab shows when the application
first opens. Notice how the Bloom tab already has content (the
curriculum pages loaded from disk), while the Terminal tab waits for
you to start the emulator.

---

*A window opens. Four tabs wait. Each one holds a piece of the system,
ready to show you what it knows -- and the first step is simply to
look.*
