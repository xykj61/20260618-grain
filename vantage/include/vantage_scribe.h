#ifndef VANTAGE_SCRIBE_H
#define VANTAGE_SCRIBE_H

#include <stdint.h>
#include <stdbool.h>

void scribe_settings_init(void);

bool scribe_settings_load(const uint8_t *ptr, uint32_t len);

uint32_t scribe_settings_save(uint8_t *out, uint32_t max);

const char *scribe_settings_theme(void);
uint32_t scribe_settings_font_size(void);
bool scribe_settings_sidebar_visible(void);
uint32_t scribe_settings_recent_limit(void);
bool scribe_settings_audio_monitor(void);

bool scribe_settings_set_theme(const char *theme);
bool scribe_settings_set_font_size(uint32_t size);
void scribe_settings_set_sidebar_visible(bool visible);
bool scribe_settings_set_recent_limit(uint32_t limit);
void scribe_settings_set_audio_monitor(bool enabled);

#endif
