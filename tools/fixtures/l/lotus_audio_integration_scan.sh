#!/bin/sh
# tools/fixtures/l/lotus_audio_integration_scan.sh -- build and run the Lotus Audio bridge selftest.
#
# Exercises the complete Lotus Audio FFI surface end to end: init, play, stop,
# close, loop toggle, gain, recording, record-to-playback, WAV export.
# The selftest lives in lotus/lotus_vantage_audio.rye and asserts 15 claims.
#
#   sh tools/fixtures/l/lotus_audio_integration_scan.sh
#
# Emits key=value readings for the witness to gate.

set -e

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"

RYE_ZIG="$ROOT/vendor/zig-toolchain/zig"
if [ ! -x "$RYE_ZIG" ]; then
  echo "rye_zig=missing"
  echo "verdict=skip"
  exit 0
fi

RYE="$ROOT/rye/bin/rye"
if [ ! -x "$RYE" ]; then
  echo "rye=missing"
  echo "verdict=skip"
  exit 0
fi

# -- 1. build the bridge as a dynamic library --
echo "phase=build"
build_out=$( env RYE_ZIG="$RYE_ZIG" "$RYE" build-lib \
  lotus/lotus_vantage_audio.rye \
  -dynamic \
  -femit-bin=vantage/lib/liblotus_audio.dylib \
  -lc \
  -framework AudioToolbox \
  -framework CoreAudio 2>&1 ) || {
  echo "build_ok=no"
  echo "build_out=$build_out"
  echo "verdict=red"
  exit 1
}
echo "build_ok=yes"

if [ ! -f vantage/lib/liblotus_audio.dylib ]; then
  echo "dylib=missing"
  echo "verdict=red"
  exit 1
fi
echo "dylib=present"

# -- 2. run the bridge selftest --
echo "phase=selftest"
selftest_out=$( env RYE_ZIG="$RYE_ZIG" "$RYE" run \
  lotus/lotus_vantage_audio.rye \
  -lc \
  -framework AudioToolbox \
  -framework CoreAudio 2>&1 ) || {
  echo "selftest_exit=nonzero"
  echo "selftest_out=$selftest_out"
  echo "verdict=red"
  exit 1
}
echo "selftest_exit=0"

# -- 3. check the selftest output for the 15-claim GREEN line --
claims_green=no
if echo "$selftest_out" | grep -q "15 claims GREEN"; then
  claims_green=yes
fi
echo "claims_green=$claims_green"

# -- 4. check for the opening banner --
banner=no
if echo "$selftest_out" | grep -q "lotus_vantage_audio selftest"; then
  banner=yes
fi
echo "banner=$banner"

# -- 5. check recording claims appear --
recording_claims=0
echo "$selftest_out" | grep -q "recording:" && recording_claims=$((recording_claims + 1))
echo "$selftest_out" | grep -q "transfer" && recording_claims=$((recording_claims + 1))
echo "$selftest_out" | grep -q "read_buf:" && recording_claims=$((recording_claims + 1))
echo "$selftest_out" | grep -q "wav export\|no samples" && recording_claims=$((recording_claims + 1))
echo "recording_claims=$recording_claims"

# -- 6. check the C header declares all exports --
header="$ROOT/vantage/include/vantage_lotus_audio.h"
header_exports=0
for fn in lotus_audio_init_test_tone lotus_audio_start lotus_audio_stop \
          lotus_audio_close lotus_audio_is_open lotus_audio_is_playing \
          lotus_audio_set_loop lotus_audio_is_looping lotus_audio_set_gain \
          lotus_audio_position lotus_audio_clip_length lotus_audio_sample_rate \
          lotus_audio_callback_count lotus_record_open lotus_record_close \
          lotus_record_start lotus_record_stop lotus_record_is_open \
          lotus_record_is_recording lotus_record_sample_count \
          lotus_record_meter_peak lotus_record_to_playback \
          lotus_record_read_buf lotus_record_export_wav; do
  if grep -q "$fn" "$header" 2>/dev/null; then
    header_exports=$((header_exports + 1))
  fi
done
echo "header_exports=$header_exports"

# -- verdict --
if [ "$claims_green" = "yes" ] && [ "$banner" = "yes" ] && [ "$header_exports" -ge 23 ]; then
  echo "verdict=green"
else
  echo "verdict=red"
fi
