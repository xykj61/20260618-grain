#!/bin/sh
# terrarium_act2_quest1_launch.sh -- Act II Quest 1 integration launch.
#
# Proves Dimeroll in the Glass (Movements 16-19):
#   M16: Dimeroll tab -- focusDimeroll, dedicated view
#   M17: Stage launcher -- launchDimerollStage, QEMU per module
#   M18: Module selector -- NSPopUpButton, 10 Dimeroll modules
#   M19: Structured output parsing -- NSTableView, transaction parser
#
# Step 1: Build SkateCore module (all 9 files).
# Step 2: Build Terrarium (proves all Dimeroll UI code compiles).
# Step 3: Verify Dimeroll symbols in the binary (12 checks).
# Step 4: Launch Terrarium with dimeroll_tx_g stage, verify output.
#
# Output: key=value lines the Rishi witness parses.

set -e

ROOT="${1:-.}"
BUILD="$ROOT/terrarium/.build"
SKATE_SRC="$ROOT/skate/Sources/SkateCore"

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

# -- Step 2: Build Terrarium --

echo "--- step 2: build Terrarium ---"
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

# -- Step 3: Dimeroll binary symbols --

echo "--- step 3: verify Dimeroll symbols in binary ---"
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

# M16: Dimeroll tab
check_symbol "sym_focus_dimeroll" "focusDimeroll"

# M17: Stage launcher (dimerollProcess is the NSTask property set by launchDimerollStage)
check_symbol "sym_launch_stage" "dimerollProcess"

# M18: Module selector
check_symbol "sym_module_popup" "dimerollModulePopUp"
check_symbol "sym_module_changed" "dimerollModuleChanged"
check_symbol "sym_run_clicked" "dimerollRunClicked"
check_symbol "sym_modules_list" "dimerollModules"
check_symbol "sym_popup_button" "NSPopUpButton"

# M19: Structured output parsing
check_symbol "sym_table_view" "dimerollTableView"
check_symbol "sym_view_toggled" "dimerollViewToggled"
check_symbol "sym_raw_buffer" "dimerollRawBuffer"
check_symbol "sym_transactions" "dimerollTransactions"
check_symbol "sym_tx_stage" "dimeroll_tx_g"

# -- Step 4: Launch with dimeroll_tx_g --

echo "--- step 4: launch Terrarium dimeroll_tx_g ---"
if [ ! -f "$BUILD/dimeroll_tx_g.elf" ]; then
  echo "dimeroll_elf=missing"
  echo "terrarium_launch=skip"
else
  echo "dimeroll_elf=yes"
  OUTPUT=$(DYLD_LIBRARY_PATH="$BUILD" \
    "$BUILD/Terrarium" dimeroll_tx_g 2>&1 || true)
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

  if echo "$OUTPUT" | grep -q "dimeroll_tx complete"; then
    echo "dimeroll_output=yes"
  else
    echo "dimeroll_output=no"
  fi

  if echo "$OUTPUT" | grep -q '\[1\] (plant'; then
    echo "tx_line_parsed=yes"
  else
    echo "tx_line_parsed=no"
  fi

  echo "terrarium_launch=yes"
fi
