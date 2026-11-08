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
uint32_t lotus_audio_clip_length(void);
uint32_t lotus_audio_callback_count(void);
uint32_t lotus_audio_sample_rate(void);

void lotus_audio_set_loop(bool on);
bool lotus_audio_is_looping(void);
void lotus_audio_seek_start(void);

void lotus_audio_set_gain(float gain);
float lotus_audio_get_gain(void);

// -- recording --
bool lotus_record_open(uint32_t sample_rate);
bool lotus_record_start(void);
bool lotus_record_stop(void);
void lotus_record_close(void);
bool lotus_record_is_open(void);
bool lotus_record_is_recording(void);
uint32_t lotus_record_meter_peak(void);
uint32_t lotus_record_sample_count(void);
uint32_t lotus_record_read_buf(
    int16_t *out, uint32_t max_out
);
bool lotus_record_to_playback(void);
uint32_t lotus_record_export_wav(
    uint8_t *out, uint32_t max_out
);

#endif
