# Building Vantage

**Style:** Bhakta at the Door setting, with Radiant warmth
**Status:** Living
**Room:** checkable

---

## What this page teaches

This page shows you what Vantage is, what lives inside it, how to
build it, and how to run its selftests. By the end you will have
built two Rye modules and seen them prove themselves on your own
machine.

## What Vantage is

Vantage is the room where Grain's application logic lives, written
in Rye. When a person uses Terrarium on macOS, or when a browser
loads a Grain page, the data and the rules come from the same
place: the Rye source files in `vantage/`.

The platform shell -- Swift on macOS, JavaScript in a browser --
handles the window, the buttons, and the screen. Vantage handles
everything the window shows: which lessons exist, what order they
come in, how many there are, and what the navigation rules are.

This separation means the logic is written once and proven once,
and every platform that wants to show Bloom content calls the same
functions.

## What lives inside

The `vantage/` directory holds two Rye modules today:

- **`bloom.rye`** (544 lines) -- the Bloom educational tab. It
  defines seven content galaxies (Curriculum, Lineage Teachings,
  Ecology, Guides, Essays, Tutorials, and Network Demos), the
  files inside each one, the separator titles and bodies between
  sections, and the navigation logic that decides whether a Next
  or Previous button should appear.

- **`dimeroll.rye`** (290 lines) -- the Dimeroll accounting tab.
  It defines eleven modules (Dashboard, Transactions, Inventory,
  Cash Flow, Ledger, Seal, Price, and four query types), along
  with query-type metadata and placeholder hints.

Both modules export their functions with C-compatible calling
conventions, which is how a Swift or JavaScript shell reaches them
across the language boundary.

## The FFI surface

FFI stands for Foreign Function Interface. It is the door between
two languages. Vantage modules export functions that any language
can call, as long as that language knows how to call a C function.

Bloom exports twelve functions:

| Function | Returns | What it answers |
|---|---|---|
| `bloom_galaxy_count` | a number | how many galaxies exist |
| `bloom_total_files` | a number | how many lesson files there are in all |
| `bloom_separator_count` | a number | how many section separators there are |
| `bloom_total_lessons` | a number | files plus separators |
| `bloom_galaxy_name` | a string | the display name of one galaxy |
| `bloom_galaxy_directory` | a string | the filesystem directory of one galaxy |
| `bloom_galaxy_file_count` | a number | how many files one galaxy holds |
| `bloom_galaxy_file_name` | a string | the filename of one lesson in one galaxy |
| `bloom_galaxy_separator_title` | a string | the section header text |
| `bloom_galaxy_separator_body` | a string | the section description text |
| `bloom_can_prev_ffi` | true or false | whether a Previous button should show |
| `bloom_can_next_ffi` | true or false | whether a Next button should show |

A shell that wants to display Bloom content calls these functions
and builds its own interface from the answers. The Swift shell in
`terrarium/app/` does exactly this today.

## Building

Vantage is built with the Rye toolchain, which uses the Zig
compiler bundled at `vendor/zig-toolchain/zig`. You do not need to
install anything beyond what the tree already carries.

To build the Bloom module as a native binary:

```
env RYE_ZIG=vendor/zig-toolchain/zig \
  rye/bin/rye build vantage/bloom.rye \
  -femit-bin=vantage/bin/bloom
```

To build the Dimeroll module:

```
env RYE_ZIG=vendor/zig-toolchain/zig \
  rye/bin/rye build vantage/dimeroll.rye \
  -femit-bin=vantage/bin/dimeroll
```

Both commands produce a native executable in `vantage/bin/`. The
`bin/` and `lib/` directories under `vantage/` are gitignored
build artifacts -- they are produced fresh on each build.

## Running the selftests

Each module carries its own selftest. The selftest exercises the
module's data and logic without any platform shell, proving that
the content is correctly structured.

```
vantage/bin/bloom selftest
```

A passing run prints:

```
vantage-bloom selftest GREEN -- 15 claims
```

The fifteen claims verify bounds, galaxy structure, file counts,
separator correctness, navigation logic, and filesystem path
construction. If any claim fails, the program stops and names
what went wrong.

## Building as a shared library

The Terrarium macOS shell links Vantage as a dynamic library
rather than as a standalone program. The Swift build system
handles this automatically through the `module.modulemap` in
`vantage/include/`. You do not need to build the library by
hand to use Terrarium -- Xcode does it as part of the app build.

If you want to build the library manually for another purpose:

```
env RYE_ZIG=vendor/zig-toolchain/zig \
  rye/bin/rye build-lib vantage/bloom.rye \
  -dynamic \
  -femit-bin=vantage/lib/libbloom.dylib
```

## What to read next

- [Vantage WASM Compilation](vantage-wasm-compilation.md) shows
  how to compile the same Rye source to WebAssembly for a browser.
- [Navigating Bloom Demos in Terrarium](bloom-demos-in-terrarium.md)
  shows how to use the Bloom content inside the macOS application.

---

*May the bridge between languages feel like a door held open,
and may the selftest stay green on every machine that builds it.*
