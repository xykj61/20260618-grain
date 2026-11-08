# Vantage WASM Compilation

**Style:** Teacher at the Door setting, with Radiant warmth
**Status:** Living
**Room:** checkable

---

## What this page teaches

This page shows you how to compile Vantage's Rye modules into
WebAssembly, the binary format that runs inside a web browser.
By the end you will understand what WASM and WASI are, how to
build a Vantage module for the browser, and what the resulting
file contains.

## What WebAssembly is

WebAssembly, or WASM, is a way to run compiled programs inside
a web browser. A program written in Rye, C, Rust, or any other
compiled language can be translated into WASM, and then a browser
can run it the same way it runs JavaScript.

This matters for Grain because the same Bloom data model that
runs natively on macOS can also run in a browser, without being
rewritten in JavaScript. The logic stays in Rye. The browser
provides the window.

## What WASI is

WASI stands for WebAssembly System Interface. It is a standard
set of functions that give a WASM program access to things it
would normally get from an operating system: reading files,
writing output, generating random numbers.

A program that imports WASI functions can run anywhere that
provides those functions -- a browser with a WASI polyfill, a
server-side runtime like Node.js, or a dedicated WASM runtime
like Wasmtime.

Vantage modules use WASI because Rye's standard library needs
a few system-level services (memory allocation, basic I/O).
The program does not read or write files at runtime -- WASI is
there so the standard library can start up correctly.

## Building for WASM

The Rye toolchain can target WASM directly. The build command
uses a project-relative path so it works on any machine:

```sh
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

env RYE_ZIG="$ROOT/vendor/zig-toolchain/zig" \
  "$ROOT/rye/bin/rye" build "$ROOT/vantage/bloom.rye" \
  -target wasm32-wasi-musl \
  -rdynamic \
  -femit-bin="$ROOT/vantage/lib/bloom_wasi.wasm"
```

Three things in this command deserve explanation:

- **`-target wasm32-wasi-musl`** tells the compiler to produce
  a 32-bit WebAssembly binary that expects WASI functions to be
  available. The `musl` part means it uses a minimal C library
  implementation suitable for WASM.

- **`-rdynamic`** tells the linker to export all functions that
  use C-compatible calling conventions. Without this flag, the
  WASM file would only export `_start` and `memory`, and none
  of the twelve Bloom FFI functions would be reachable from
  JavaScript.

- **`-femit-bin=...`** names where the output file goes. The
  `vantage/lib/` directory is gitignored, so build artifacts
  stay out of the repository.

## What the WASM file contains

The resulting `bloom_wasi.wasm` file is roughly 1.5 megabytes.
It exports fifteen symbols:

- **`memory`** -- the module's linear memory, which JavaScript
  can read to extract strings
- **`__stack_pointer`** -- internal use by the runtime
- **`_start`** -- the entry point that initializes the module
- **Twelve Bloom FFI functions** -- the same twelve listed in
  [Building Vantage](building-vantage.md), each callable from
  JavaScript after the module initializes

It imports thirty-two functions from `wasi_snapshot_preview1`,
the standard WASI namespace. These are things like `fd_write`
(write to a file descriptor), `fd_read` (read from one),
`random_get` (fill a buffer with random bytes), and
`proc_exit` (exit the program). In a browser, a small
JavaScript library called a WASI polyfill provides these.

## Reading strings from WASM memory

Several Bloom functions return a pointer to a string inside the
module's memory. To read that string from JavaScript, you walk
the memory byte by byte until you find a zero (the null
terminator that marks the end of a C string):

```javascript
function readCStr(ptr, memory) {
  if (ptr === 0) return '';
  const bytes = new Uint8Array(memory.buffer);
  let end = ptr;
  while (bytes[end] !== 0) end++;
  return new TextDecoder().decode(bytes.slice(ptr, end));
}
```

This is a standard pattern for any WASM module that returns
C-style strings. The `memory` object comes from the module's
exports.

## Path construction for tracked scripts

If you write a build or test script that will be committed to
this tree, derive the project root once at the top and build
every path from it:

```sh
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
```

This follows the single-stranded pattern: one derivation, used
everywhere, so the script works on any clone without a baked
absolute path. The `$HOME` expansion happens at runtime, and
the script never names a specific user's home directory.

## What to try next

The WASM binary is ready for a browser shell. The next step on
this path is a minimal HTML page that loads `bloom_wasi.wasm`
with a WASI polyfill, calls `bloom_galaxy_count`, and renders
the result on screen. That page would be the first Grain
content visible in a browser -- the same seven galaxies, the
same fifty-three lessons, served from the same Rye source that
runs on macOS today.

## What to read next

- [Building Vantage](building-vantage.md) covers the native
  build and selftest, and lists all twelve FFI functions.
- [Navigating Bloom Demos in Terrarium](bloom-demos-in-terrarium.md)
  shows the same content running in the macOS application.

---

*May the same logic run in every window, and may the boundary
between one platform and another feel like a threshold rather
than a wall.*
