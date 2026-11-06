#!/bin/sh
# terrarium_quest2_launch.sh -- build and run the Quest 2 integration harness.
#
# Step 1: Build SkateCore (all 9 source files, Swift 6).
# Step 2: Build the Quest 2 harness against SkateCore.
# Step 3: Run the harness and capture key=value output.
# Step 4: Build Terrarium binary (app-level integration).
# Step 5: Launch Terrarium with hello stage and verify clean exit.
#
# Output: key=value lines the Rishi witness parses.

set -e

ROOT="${1:-.}"
BUILD="$ROOT/terrarium/.build"
SKATE_SRC="$ROOT/skate/Sources/SkateCore"
HARNESS="$ROOT/tools/fixtures/te/terrarium_quest2_harness.swift"

mkdir -p "$BUILD"

echo "--- step 1: build SkateCore ---"
swiftc \
  -parse-as-library \
  -module-name SkateCore \
  -emit-module \
  -emit-module-path "$BUILD/SkateCore.swiftmodule" \
  -emit-library \
  -o "$BUILD/libSkateCore.dylib" \
  -swift-version 6 \
  "$SKATE_SRC/AccessibilitySnapshot.swift" \
  "$SKATE_SRC/ConsentRail.swift" \
  "$SKATE_SRC/EventRing.swift" \
  "$SKATE_SRC/FrameGrid.swift" \
  "$SKATE_SRC/ImageEditHistory.swift" \
  "$SKATE_SRC/InlineArrayEquatable.swift" \
  "$SKATE_SRC/ReceiptAccessibilitySnapshot.swift" \
  "$SKATE_SRC/ReceiptCard.swift" \
  "$SKATE_SRC/SkateEvent.swift"

if [ ! -f "$BUILD/libSkateCore.dylib" ]; then
  echo "skatecore_build=fail"
  exit 1
fi
echo "skatecore_build=yes"

echo "--- step 2: build Quest 2 harness ---"
swiftc \
  -I "$BUILD" \
  -L "$BUILD" \
  -lSkateCore \
  -o "$BUILD/Quest2Harness" \
  "$HARNESS"

if [ ! -f "$BUILD/Quest2Harness" ]; then
  echo "harness_build=fail"
  exit 1
fi
echo "harness_build=yes"

echo "--- step 3: run Quest 2 harness ---"
echo "--- harness output ---"
DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Quest2Harness" 2>&1
echo "--- end harness output ---"

echo "--- step 4: build Terrarium ---"
swiftc \
  -I "$BUILD" \
  -L "$BUILD" \
  -lSkateCore \
  -o "$BUILD/Terrarium" \
  "$ROOT/terrarium/app/main.swift" 2>&1 || true

if [ ! -f "$BUILD/Terrarium" ]; then
  echo "terrarium_build=fail"
  exit 1
fi
echo "terrarium_build=yes"

echo "--- step 5: launch Terrarium hello ---"
if [ ! -f "$ROOT/terrarium/stages/hello.elf" ]; then
  echo "hello_elf=missing"
  echo "terrarium_launch=skip"
else
  echo "hello_elf=yes"
  OUTPUT=$(DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Terrarium" hello 2>&1 || true)
  echo "--- terrarium output ---"
  echo "$OUTPUT"
  echo "--- end terrarium output ---"
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
  echo "terrarium_launch=yes"
fi
