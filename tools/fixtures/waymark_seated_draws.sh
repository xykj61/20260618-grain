#!/bin/sh
# Re-derive seated corpus-drawn waymarks against a sorted-unique corpus file.
# Usage: waymark_seated_draws.sh <corpus.txt>
# Expects one [A-Z]{4} word per line; exits non-zero on any mismatch.
set -eu
corpus="${1:?corpus path required}"
size="$(wc -l < "$corpus" | tr -d ' ')"
draw() {
  name="$1"
  expect="$2"
  hash8="$(printf '%s' "$name" | openssl dgst -sha3-512 | awk '{print $NF}' | cut -c1-8)"
  dec="$(printf '%d' "0x$hash8")"
  idx="$((dec % size + 1))"
  word="$(awk -v n="$idx" 'NR==n' "$corpus")"
  if [ "$word" != "$expect" ]; then
    echo "RED: $name -> $word (want $expect)" >&2
    exit 1
  fi
  echo "OK $name -> $word"
}
draw grapheneos-pixel-mobile-emulation pixel-glass
draw glow-application-framework-and-publishing glow-publishing
draw glow-english-qwerty-glass-keyboard-3 glass-keyboard
draw sala-broadcast-live-session-fold seva-broadcast
draw glow-glass-hearth-display-and-wired-sync hearth-display
draw glow-language-rune-heads-nest-and-lowering-2 glow-language
draw source-pier-papers-identity-refresh source-identity
draw djinn-bozo-exec-keaton-murr-hats djinn-exec
