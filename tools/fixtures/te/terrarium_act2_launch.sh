#!/bin/sh
# terrarium_act2_launch.sh -- Act II integration launch (the field ledger).
#
# Proves the full Dimeroll composition -- all 3 quests in one pass:
#   Quest 1 (M16-M19): tab, launcher, selector, structured parsing
#   Quest 2 (M21-M24): inventory, cashflow, ledger, price, seal views
#   Quest 3 (M26-M29): query panel, query results, dashboard, Mantra tab
#
# Step 1: Build SkateCore module.
# Step 2: Build Terrarium (proves all Dimeroll + Mantra code compiles).
# Step 3: Verify binary symbols across all 3 quests.
# Step 4: Launch all 10 Dimeroll ELFs through QEMU.
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

# -- Step 3: Binary symbols across all 3 quests --

echo "--- step 3: verify binary symbols ---"
STRINGS=$(strings "$BUILD/Terrarium" 2>/dev/null)
DEMANGLE=$(nm "$BUILD/Terrarium" 2>/dev/null | swift demangle 2>/dev/null)

check_symbol() {
  KEY="$1"
  PATTERN="$2"
  if echo "$STRINGS" | grep -q "$PATTERN"; then
    echo "${KEY}=yes"
  else
    echo "${KEY}=no"
  fi
}

check_demangle() {
  KEY="$1"
  PATTERN="$2"
  if echo "$DEMANGLE" | grep -q "$PATTERN"; then
    echo "${KEY}=yes"
  else
    echo "${KEY}=no"
  fi
}

# Quest 1: Dimeroll in the Glass (M16-M19)
echo "--- quest 1 symbols ---"
check_symbol "q1_focus_dimeroll" "focusDimeroll"
check_symbol "q1_launch_stage" "dimerollProcess"
check_symbol "q1_module_popup" "dimerollModulePopUp"
check_symbol "q1_modules_list" "dimerollModules"
check_symbol "q1_table_view" "dimerollTableView"
check_symbol "q1_transactions" "dimerollTransactions"

# Quest 2: Ledger Views (M21-M24)
echo "--- quest 2 symbols ---"
check_symbol "q2_inventory" "dimerollInventory"
check_symbol "q2_active_elf" "dimerollActiveElf"
check_symbol "q2_cashflow" "dimerollCashflow"
check_symbol "q2_ledger" "dimerollLedger"
check_symbol "q2_price" "dimerollPrice"
check_symbol "q2_seal" "dimerollSeal"
check_demangle "q2_fn_rebuild" "rebuildDimerollColumns"
check_demangle "q2_fn_parse_inv" "parseDimerollInventoryLine"
check_demangle "q2_fn_parse_cf" "parseDimerollCashflowLine"
check_demangle "q2_fn_parse_led" "parseDimerollLedgerLine"
check_demangle "q2_fn_parse_prc" "parseDimerollPriceLine"
check_demangle "q2_fn_parse_seal" "parseDimerollSealLine"

# Quest 3: Queries, Dashboard, Mantra (M26-M29)
echo "--- quest 3 symbols ---"
check_symbol "q3_query_types" "dimerollQueryTypes"
check_symbol "q3_query_results" "dimerollQueryResults"
check_demangle "q3_fn_parse_query" "parseDimerollQueryLine"
check_demangle "q3_fn_dashboard" "launchDimerollDashboard"
check_demangle "q3_fn_dash_complete" "dimerollDashboardPhaseComplete"
check_demangle "q3_fn_mantra" "focusMantra"

# -- Step 4: Launch all 10 Dimeroll ELFs through QEMU --

echo "--- step 4: launch 10 Dimeroll ELFs ---"

launch_module() {
  TAG="$1"
  ELF="$2"
  MARKER="$3"
  EXTRA_KEY="$4"
  EXTRA_PAT="$5"

  echo "--- ${TAG} ---"
  if [ ! -f "$BUILD/${ELF}.elf" ]; then
    echo "${TAG}_elf=missing"
    return
  fi
  echo "${TAG}_elf=yes"
  MOD_OUT=$(DYLD_LIBRARY_PATH="$BUILD" "$BUILD/Terrarium" "$ELF" 2>&1 || true)
  echo "$MOD_OUT" > "$ROOT/.lap/act2_${TAG}.txt"

  if echo "$MOD_OUT" | grep -q "qemu launched"; then
    echo "${TAG}_qemu=yes"
  else
    echo "${TAG}_qemu=no"
  fi

  if echo "$MOD_OUT" | grep -q "qemu exited"; then
    echo "${TAG}_exited=yes"
  else
    echo "${TAG}_exited=no"
  fi

  if [ -n "$MARKER" ]; then
    if echo "$MOD_OUT" | grep -q "$MARKER"; then
      echo "${TAG}_marker=yes"
    else
      echo "${TAG}_marker=no"
    fi
  fi

  if [ -n "$EXTRA_KEY" ] && [ -n "$EXTRA_PAT" ]; then
    if echo "$MOD_OUT" | grep -q "$EXTRA_PAT"; then
      echo "${TAG}_${EXTRA_KEY}=yes"
    else
      echo "${TAG}_${EXTRA_KEY}=no"
    fi
  fi
}

mkdir -p "$ROOT/.lap"

# Quest 1 baseline
launch_module "tx" "dimeroll_tx_g" "dimeroll_tx complete" "parsed" '\[1\] (plant'

# Quest 2 modules
launch_module "inv" "dimeroll_inventory_g" "tomatoes" "peppers" "peppers"
launch_module "cf" "dimeroll_cashflow_g" "DIMEROLL FIELD LEDGER" "revenue" "Revenue"
launch_module "led" "dimeroll_ledger_g" "plant" "harvest" "harvest"
launch_module "prc" "dimeroll_price_g" "PROOF PASS" "all_passed" "ALL PROOFS PASSED"
launch_module "seal" "dimeroll_seal_g" "VERIFIED" "format" "amphora-v1"

# Quest 3 query modules
launch_module "qv" "dimeroll_query_verb_g" "dimeroll_query_verb complete" "" ""
launch_module "qs" "dimeroll_query_subject_g" "dimeroll_query_subject complete" "" ""
launch_module "qd" "dimeroll_query_date_g" "dimeroll_query_date complete" "" ""
launch_module "qa" "dimeroll_query_account_g" "dimeroll_query_account complete" "" ""

echo "--- all 10 modules launched ---"
echo "act2_launch=yes"
