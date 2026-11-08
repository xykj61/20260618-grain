#ifndef VANTAGE_SURF_H
#define VANTAGE_SURF_H

#include <stdint.h>
#include <stdbool.h>

void surf_init(void);

int32_t surf_keypair_from_seed(
    const uint8_t *seed,
    uint8_t *pubkey_out,
    uint8_t *secret_out
);

void surf_event_id(
    const uint8_t *pubkey,
    uint32_t kind,
    uint64_t created_at,
    const uint8_t *content,
    uint32_t content_len,
    uint8_t *id_out
);

int32_t surf_sign_event(
    const uint8_t *id,
    const uint8_t *secret,
    uint8_t *sig_out
);

bool surf_verify_event(
    const uint8_t *id,
    const uint8_t *sig,
    const uint8_t *pubkey
);

int32_t surf_feed_add(
    const uint8_t *pubkey,
    uint32_t kind,
    uint64_t created_at,
    const uint8_t *content,
    uint32_t content_len,
    const uint8_t *sig,
    const uint8_t *id
);

uint32_t surf_feed_count(void);

uint32_t surf_feed_list(
    uint8_t *buf,
    uint32_t buf_len
);

uint32_t surf_feed_get_content(
    uint32_t index,
    uint8_t *buf,
    uint32_t buf_len
);

int32_t surf_selftest(void);

#endif
