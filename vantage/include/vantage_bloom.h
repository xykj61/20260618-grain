//! vantage/include/vantage_bloom.h -- C header for the
//! Bloom tab data model. Generated from vantage/bloom.rye
//! FFI exports; keep in sync with that module.

#ifndef VANTAGE_BLOOM_H
#define VANTAGE_BLOOM_H

#include <stdint.h>
#include <stdbool.h>

uint32_t bloom_galaxy_count(void);
uint32_t bloom_total_files(void);
uint32_t bloom_separator_count(void);
uint32_t bloom_total_lessons(void);

const char *bloom_galaxy_name(uint32_t index);
const char *bloom_galaxy_directory(uint32_t index);
uint32_t bloom_galaxy_file_count(uint32_t index);
const char *bloom_galaxy_file_name(
    uint32_t galaxy_idx, uint32_t file_idx
);

const char *bloom_galaxy_separator_title(uint32_t index);
const char *bloom_galaxy_separator_body(uint32_t index);

bool bloom_can_prev_ffi(uint32_t index);
bool bloom_can_next_ffi(uint32_t index, uint32_t count);

#endif
