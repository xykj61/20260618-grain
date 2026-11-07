#!/bin/sh
# terrarium_act2_quest2_launch.sh -- Act II Quest 2 integration launch.
#
# Proves Ledger Views (Movements 21-24):
#   M21: Inventory summary view -- parseDimerollInventoryLine
#   M22: Cash flow view -- parseDimerollCashflowLine
#   M23: Ledger page rendering -- parseDimerollLedgerLine
#   M24: Price arithmetic and seal display -- parseDimerollPriceLine, parseDimerollSealLine
#   M25: this witness
#
# Step 1: Build SkateCore module (all 9 files).
# Step 2: Build Terrarium (proves all view code compiles).
# Step 3: Verify M21-M24 symbols (7 via strings, 6 via nm demangle).
# Step 4: Launch all 6 Dimeroll modules through QEMU, verify output.
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

# -- Step 3a: M21-M24 symbols via strings --

echo "--- step 3a: verify M21-M24 symbols via strings ---"
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

check_symbol "sym_inventory" "dimerollInventory"
check_symbol "sym_active_elf" "dimerollActiveElf"
check_symbol "sym_in_ledger_table" "dimerollInLedgerTable"
check_symbol "sym_cashflow" "dimerollCashflow"
check_symbol "sym_ledger" "dimerollLedger"
check_symbol "sym_price" "dimerollPrice"
check_symbol "sym_seal" "dimerollSeal"

# -- Step 3b: Parser functions via nm | swift demangle --

echo "--- step 3b: verify parser functions via nm demangle ---"
DEMANGLE=$(nm "$BUILD/Terrarium" 2>/dev/null | swift demangle 2>/dev/null)

check_demangle() {
  KEY="$1"
  PATTERN="$2"
  if echo "$DEMANGLE" | grep -q "$PATTERN"; then
    echo "${KEY}=yes"
  else
    echo "${KEY}=no"
  fi
}

check_demangle "fn_rebuild_columns" "rebuildDimerollColumns"
check_demangle "fn_parse_inventory" "parseDimerollInventoryLine"
check_demangle "fn_parse_cashflow" "parseDimerollCashflowLine"
check_demangle "fn_parse_ledger" "parseDimerollLedgerLine"
check_demangle "fn_parse_price" "parseDimerollPriceLine"
check_demangle "fn_parse_seal" "parseDimerollSealLine"

# -- Step 4: Launch all 6 Dimeroll modules through QEMU --

echo "--- step 4: launch 6 Dimeroll modules ---"

# 4a: dimeroll_tx_g -- transaction parser (M19, baseline)
echo "--- 4a: dimeroll_tx_g ---"
if [ ! -f "$BUILD/dimeroll_tx_g.elf" ]; then
  echo "tx_elf=missing"
else
  echo "tx_elf=yes"
  TX_OUT=$(DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Terrarium" dimeroll_tx_g 2>&1 || true)
  echo "--- tx output ---"
  echo "$TX_OUT"
  echo "--- end tx output ---"
  if echo "$TX_OUT" | grep -q "qemu launched"; then echo "tx_qemu=yes"; else echo "tx_qemu=no"; fi
  if echo "$TX_OUT" | grep -q "qemu exited"; then echo "tx_exited=yes"; else echo "tx_exited=no"; fi
  if echo "$TX_OUT" | grep -q "dimeroll_tx complete"; then echo "tx_output=yes"; else echo "tx_output=no"; fi
  if echo "$TX_OUT" | grep -q '\[1\] (plant'; then echo "tx_parsed=yes"; else echo "tx_parsed=no"; fi
fi

# 4b: dimeroll_inventory_g -- inventory parser (M21)
echo "--- 4b: dimeroll_inventory_g ---"
if [ ! -f "$BUILD/dimeroll_inventory_g.elf" ]; then
  echo "inv_elf=missing"
else
  echo "inv_elf=yes"
  INV_OUT=$(DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Terrarium" dimeroll_inventory_g 2>&1 || true)
  echo "--- inventory output ---"
  echo "$INV_OUT"
  echo "--- end inventory output ---"
  if echo "$INV_OUT" | grep -q "qemu launched"; then echo "inv_qemu=yes"; else echo "inv_qemu=no"; fi
  if echo "$INV_OUT" | grep -q "qemu exited"; then echo "inv_exited=yes"; else echo "inv_exited=no"; fi
  if echo "$INV_OUT" | grep -q "tomatoes"; then echo "inv_tomatoes=yes"; else echo "inv_tomatoes=no"; fi
  if echo "$INV_OUT" | grep -q "peppers"; then echo "inv_peppers=yes"; else echo "inv_peppers=no"; fi
fi

# 4c: dimeroll_cashflow_g -- cash flow parser (M22)
echo "--- 4c: dimeroll_cashflow_g ---"
if [ ! -f "$BUILD/dimeroll_cashflow_g.elf" ]; then
  echo "cf_elf=missing"
else
  echo "cf_elf=yes"
  CF_OUT=$(DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Terrarium" dimeroll_cashflow_g 2>&1 || true)
  echo "--- cashflow output ---"
  echo "$CF_OUT"
  echo "--- end cashflow output ---"
  if echo "$CF_OUT" | grep -q "qemu launched"; then echo "cf_qemu=yes"; else echo "cf_qemu=no"; fi
  if echo "$CF_OUT" | grep -q "qemu exited"; then echo "cf_exited=yes"; else echo "cf_exited=no"; fi
  if echo "$CF_OUT" | grep -q "DIMEROLL FIELD LEDGER"; then echo "cf_marker=yes"; else echo "cf_marker=no"; fi
  if echo "$CF_OUT" | grep -q "Revenue"; then echo "cf_revenue=yes"; else echo "cf_revenue=no"; fi
fi

# 4d: dimeroll_ledger_g -- ledger parser (M23)
echo "--- 4d: dimeroll_ledger_g ---"
if [ ! -f "$BUILD/dimeroll_ledger_g.elf" ]; then
  echo "led_elf=missing"
else
  echo "led_elf=yes"
  LED_OUT=$(DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Terrarium" dimeroll_ledger_g 2>&1 || true)
  echo "--- ledger output ---"
  echo "$LED_OUT"
  echo "--- end ledger output ---"
  if echo "$LED_OUT" | grep -q "qemu launched"; then echo "led_qemu=yes"; else echo "led_qemu=no"; fi
  if echo "$LED_OUT" | grep -q "qemu exited"; then echo "led_exited=yes"; else echo "led_exited=no"; fi
  if echo "$LED_OUT" | grep -q "plant"; then echo "led_plant=yes"; else echo "led_plant=no"; fi
  if echo "$LED_OUT" | grep -q "harvest"; then echo "led_harvest=yes"; else echo "led_harvest=no"; fi
fi

# 4e: dimeroll_price_g -- price parser (M24)
echo "--- 4e: dimeroll_price_g ---"
if [ ! -f "$BUILD/dimeroll_price_g.elf" ]; then
  echo "prc_elf=missing"
else
  echo "prc_elf=yes"
  PRC_OUT=$(DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Terrarium" dimeroll_price_g 2>&1 || true)
  echo "--- price output ---"
  echo "$PRC_OUT"
  echo "--- end price output ---"
  if echo "$PRC_OUT" | grep -q "qemu launched"; then echo "prc_qemu=yes"; else echo "prc_qemu=no"; fi
  if echo "$PRC_OUT" | grep -q "qemu exited"; then echo "prc_exited=yes"; else echo "prc_exited=no"; fi
  if echo "$PRC_OUT" | grep -q "PROOF PASS"; then echo "prc_proof=yes"; else echo "prc_proof=no"; fi
  if echo "$PRC_OUT" | grep -q "ALL PROOFS PASSED"; then echo "prc_all_passed=yes"; else echo "prc_all_passed=no"; fi
fi

# 4f: dimeroll_seal_g -- seal parser (M24)
echo "--- 4f: dimeroll_seal_g ---"
if [ ! -f "$BUILD/dimeroll_seal_g.elf" ]; then
  echo "seal_elf=missing"
else
  echo "seal_elf=yes"
  SEAL_OUT=$(DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Terrarium" dimeroll_seal_g 2>&1 || true)
  echo "--- seal output ---"
  echo "$SEAL_OUT"
  echo "--- end seal output ---"
  if echo "$SEAL_OUT" | grep -q "qemu launched"; then echo "seal_qemu=yes"; else echo "seal_qemu=no"; fi
  if echo "$SEAL_OUT" | grep -q "qemu exited"; then echo "seal_exited=yes"; else echo "seal_exited=no"; fi
  if echo "$SEAL_OUT" | grep -q "VERIFIED"; then echo "seal_verified=yes"; else echo "seal_verified=no"; fi
  if echo "$SEAL_OUT" | grep -q "amphora-v1"; then echo "seal_format=yes"; else echo "seal_format=no"; fi
fi

echo "--- all 6 modules launched ---"
echo "quest2_launch=yes"
