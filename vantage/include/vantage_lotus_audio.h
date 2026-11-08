//! vantage/include/vantage_lotus_audio.h -- C header for the
//! Lotus Audio Vantage FFI bridge. Generated from
//! lotus/lotus_vantage_audio.rye exports; keep in sync.

#ifndef VANTAGE_LOTUS_AUDIO_H
#define VANTAGE_LOTUS_AUDIO_H

#include <stdint.h>
#include <stdbool.h>

bool lotus_audio_init_test_tone(
    uint32_t num_samples, uint32_t sample_rate
);
bool lotus_audio_start(void);
bool lotus_audio_stop(void);
void lotus_audio_close(void);

bool lotus_audio_is_open(void);
bool lotus_audio_is_playing(void);
uint32_t lotus_audio_position(void);
uint32_t lotus_audio_callback_count(void);
uint32_t lotus_audio_sample_rate(void);

void lotus_audio_set_loop(bool on);
bool lotus_audio_is_looping(void);
void lotus_audio_seek_start(void);

#endif
