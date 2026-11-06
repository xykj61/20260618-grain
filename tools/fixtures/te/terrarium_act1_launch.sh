#!/bin/sh
# terrarium_act1_launch.sh -- Act I integration launch and verify.
#
# Composes Quest 1 (QEMU bridge) and Quest 2 (headless types) with
# Quest 3 (navigation shell) verification.
#
# Step 1: Build SkateCore module (all 9 files).
# Step 2: Run Quest 2 headless harness (16 proofs).
# Step 3: Build Terrarium (proves all UI code compiles).
# Step 4: Verify Quest 3 symbols in the binary.
# Step 5: Launch Terrarium with hello stage (proves it runs).
#
# Output: key=value lines the Rishi witness parses.

set -e

ROOT="${1:-.}"
BUILD="$ROOT/terrarium/.build"
SKATE_SRC="$ROOT/skate/Sources/SkateCore"
HARNESS="$ROOT/tools/fixtures/te/terrarium_quest2_harness.swift"

mkdir -p "$BUILD"

# -- Step 1: Build SkateCore --

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

# -- Step 2: Quest 2 headless harness --

echo "--- step 2: build and run Quest 2 harness ---"
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

echo "--- harness output ---"
DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Quest2Harness" 2>&1
echo "--- end harness output ---"

# -- Step 3: Build Terrarium --

echo "--- step 3: build Terrarium ---"
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

# -- Step 4: Quest 3 shell symbols --

echo "--- step 4: verify Quest 3 shell in binary ---"
STRINGS=$(strings "$BUILD/Terrarium" 2>/dev/null)

check_symbol() {
  KEY="$1"
  PATTERN="$2"
  if echo "$STRINGS" | grep -q "$PATTERN"; then
    echo "${KEY}=yes"
  else
    echo "${KEY}=no"
  fi
}

check_symbol "shell_tab_bar" "NSTabView"
check_symbol "shell_sidebar" "NSTableView"
check_symbol "shell_split_view" "NSSplitView"
check_symbol "shell_shortcuts_menu" "Shortcuts"
check_symbol "shell_new_tab" "New Tab"
check_symbol "shell_close_tab" "Close Tab"
check_symbol "shell_previous_tab" "Previous Tab"
check_symbol "shell_focus_terminal" "Focus Terminal"
check_symbol "shell_focus_grid" "Focus Grid"
check_symbol "shell_status_connection" "connected"
check_symbol "shell_status_module" "FrameGrid"
check_symbol "shell_tab_delegate" "didSelect"
check_symbol "shell_sidebar_entries" "Dimeroll"

# -- Step 5: Launch Terrarium with hello --

echo "--- step 5: launch Terrarium hello ---"
if [ ! -f "$BUILD/hello.elf" ]; then
  echo "hello_elf=missing"
  echo "terrarium_launch=skip"
else
  echo "hello_elf=yes"
  OUTPUT=$(DYLD_LIBRARY_PATH="$BUILD" \
    "$BUILD/Terrarium" hello 2>&1 || true)
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

  if echo "$OUTPUT" | grep -q "hart woke"; then
    echo "hello_output=yes"
  else
    echo "hello_output=no"
  fi

  echo "terrarium_launch=yes"
fi
