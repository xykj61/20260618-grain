#!/bin/sh
# terrarium_onboarding_scan.sh -- build the full Terrarium chain
# from the tutorial's five steps and report what succeeded.
#
# Run from the repository root:
#   sh tools/fixtures/te/terrarium_onboarding_scan.sh
#
# Prints key=value pairs the witness reads. Always exits 0 so the
# witness can read the output; the verdict line says what happened.

ROOT="${1:-.}"
cd "$ROOT"

RYE=rye/bin/rye
RYE_ZIG=vendor/zig-toolchain/zig
claims=0
proven=0

claim() { claims=$((claims + 1)); }
prove() { proven=$((proven + 1)); printf "%s=yes\n" "$1"; }
miss()  { printf "%s=no\n" "$1"; }

check_artifact() {
  claim
  if [ -f "$2" ] && [ -s "$2" ]; then
    prove "$1"
  else
    miss "$1"
  fi
}

mkdir -p terrarium/.build
mkdir -p vantage/lib

# -- Step 1: SkateCore --

printf "step=skatecore\n"
swiftc -parse-as-library -module-name SkateCore -emit-module \
  -emit-module-path terrarium/.build/SkateCore.swiftmodule \
  -emit-library -o terrarium/.build/libSkateCore.dylib \
  skate/Sources/SkateCore/*.swift 2>/dev/null || true

check_artifact skatecore_dylib terrarium/.build/libSkateCore.dylib
check_artifact skatecore_module terrarium/.build/SkateCore.swiftmodule

# -- Step 2: Vantage bridges --

printf "step=vantage_bloom\n"
$RYE build-lib vantage/bloom.rye -dynamic \
  -femit-bin=vantage/lib/libbloom.dylib 2>/dev/null || true
check_artifact vantage_bloom vantage/lib/libbloom.dylib

printf "step=vantage_dimeroll\n"
$RYE build-lib vantage/dimeroll.rye -dynamic \
  -femit-bin=vantage/lib/libdimeroll.dylib 2>/dev/null || true
check_artifact vantage_dimeroll vantage/lib/libdimeroll.dylib

printf "step=vantage_lotus_audio\n"
env RYE_ZIG="$RYE_ZIG" \
  $RYE build-lib lotus/lotus_vantage_audio.rye -dynamic \
  -femit-bin=vantage/lib/liblotus_audio.dylib \
  -lc -framework AudioToolbox -framework CoreAudio 2>/dev/null || true
check_artifact vantage_lotus_audio vantage/lib/liblotus_audio.dylib

printf "step=vantage_scribe\n"
$RYE build-lib scribe/scribe_vantage.rye -dynamic \
  -femit-bin=vantage/lib/libscribe.dylib 2>/dev/null || true
check_artifact vantage_scribe vantage/lib/libscribe.dylib

printf "step=vantage_mantra\n"
$RYE build-lib mantra/mantra_vantage.rye -dynamic \
  -femit-bin=vantage/lib/libmantra.dylib 2>/dev/null || true
check_artifact vantage_mantra vantage/lib/libmantra.dylib

printf "step=vantage_surf\n"
env RYE_ZIG="$RYE_ZIG" \
  $RYE build-lib surf/surf_vantage.rye -dynamic \
  -femit-bin=vantage/lib/libsurf.dylib -lc 2>/dev/null || true
check_artifact vantage_surf vantage/lib/libsurf.dylib

# -- Step 3: Terrarium binary --

printf "step=terrarium_binary\n"
swiftc -I terrarium/.build -I vantage/include \
  -L terrarium/.build -L vantage/lib \
  -lSkateCore -lbloom -ldimeroll -llotus_audio \
  -lscribe -lmantra -lsurf \
  -o terrarium/.build/Terrarium terrarium/app/*.swift \
  -framework AppKit 2>/dev/null || true
check_artifact terrarium_binary terrarium/.build/Terrarium

# -- Step 4: Binary is executable --

claim
if [ -x terrarium/.build/Terrarium ]; then
  prove terrarium_executable
else
  miss terrarium_executable
fi

# -- Verdict --

printf "claims=%d\n" "$claims"
printf "proven=%d\n" "$proven"
if [ "$claims" -eq "$proven" ]; then
  printf "verdict=ok\n"
else
  printf "verdict=failed\n"
fi
