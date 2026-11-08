#ifndef VANTAGE_MANTRA_H
#define VANTAGE_MANTRA_H

#include <stdint.h>
#include <stdbool.h>

void mantra_init(void);

void mantra_digest(const uint8_t *data_ptr, uint32_t data_len,
                   uint8_t *digest_out);

bool mantra_verify(const uint8_t *name_ptr, const uint8_t *data_ptr,
                   uint32_t data_len);

int32_t mantra_catalog_add(const uint8_t *digest_ptr,
                           const uint8_t *path_ptr, uint32_t path_len,
                           uint64_t size);

uint32_t mantra_catalog_count(void);

uint32_t mantra_catalog_list(uint8_t *buf_ptr, uint32_t buf_len);

bool mantra_catalog_get_digest(const uint8_t *path_ptr, uint32_t path_len,
                               uint8_t *digest_out);

uint32_t mantra_catalog_save(uint8_t *out_ptr, uint32_t out_len);

bool mantra_catalog_load(const uint8_t *data_ptr, uint32_t data_len);

int32_t mantra_selftest(void);

#endif
