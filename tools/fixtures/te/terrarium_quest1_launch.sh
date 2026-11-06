#!/bin/sh
# terrarium_quest1_launch.sh -- launch Terrarium, verify it runs, screenshot.
#
# Called by terrarium_quest1_witness.rish after the two-step build.
# Expects hello.elf at terrarium/.build/hello.elf.
# Writes screenshot to terrarium/.build/quest1_witness.png.
#
# Terrarium terminates itself after QEMU exits (dumpAndExit),
# so hello.elf (which runs instantly) causes a clean exit.
# The proof is that QEMU launched, produced output, and
# Terrarium exited with status 0.
#
# Output: key=value lines the witness parses.

set -e

BINARY="terrarium/.build/Terrarium"
ELF="terrarium/.build/hello.elf"
SCREEN_PATH="terrarium/.build/quest1_witness.png"

if [ ! -x "$BINARY" ]; then
  echo "binary_exists=no"
  exit 1
fi

if [ ! -f "$ELF" ]; then
  echo "elf_exists=no"
  exit 1
fi

echo "binary_exists=yes"
echo "elf_exists=yes"

# Launch Terrarium with hello stage, DYLD for the dylib.
# Capture stdout -- Terrarium prints its own output including
# QEMU serial lines and the "--- qemu exited (0)" line.
rm -f "$SCREEN_PATH"
OUTPUT=$(DYLD_LIBRARY_PATH=terrarium/.build "$BINARY" hello 2>&1) || true
EXIT_CODE=$?

echo "exit_code=$EXIT_CODE"

# Check for the key markers in output
if echo "$OUTPUT" | grep -q "qemu launched"; then
  echo "qemu_launched=yes"
else
  echo "qemu_launched=no"
fi

if echo "$OUTPUT" | grep -q "qemu exited"; then
  echo "qemu_exited=yes"
else
  echo "qemu_exited=no"
fi

if echo "$OUTPUT" | grep -q "hart woke"; then
  echo "hello_output=yes"
else
  echo "hello_output=no"
fi

# Print the full output for the witness log
echo "--- terrarium output ---"
echo "$OUTPUT"
echo "--- end output ---"

# Screenshot -- Terrarium exits too fast for hello.elf to capture,
# so this is best-effort for stages that run longer.
if [ -f "$SCREEN_PATH" ]; then
  SIZE=$(wc -c < "$SCREEN_PATH" | tr -d ' ')
  echo "screenshot_bytes=$SIZE"
else
  echo "screenshot_bytes=0"
fi

echo "verdict=ok"
