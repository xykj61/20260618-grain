format session-log-v1
stamp 20261107.103729
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantra SLC Movement 6 -- content request format witness GREEN
prompt kg (carry-forward from prior context)
think M6 defines the plaintext localhost content request frame -- a peer asks another for bolt/revision/path, carrying its Kumara pubkey
think wrote comlink/content_request.rye: request frame [pubkey_32 | bolt_len_u8 | bolt | revision_u32_LE | path_len_u8 | path], response frame [status_u8 | payload_len_u16_LE | payload]
think three status codes: ok (0), not_yet (1), never (2) -- matching the recall_lap1 semantics already proven in M2-M5
think wrote comlink/content_request_witness.rye with four claims: (1) request round-trip preserves all fields, (2) Kumara pubkey survives round-trip and can be recovered as PublicKey, (3) all three response statuses encode/decode correctly with payload, (4) malformed frames refused with named errors
think M7 survey already answered in prior context: std.c.sendto and std.c.recvfrom available, comlink/hosted_wire.rye demonstrates the full localhost UDP pattern
obs content_request.rye is intentionally simpler than wire_format.rye -- plaintext on localhost, no crypto, because the SLC transport is trusted
obs four claims GREEN on metal, three refusal paths proven (RequestTooShort, ResponseTooShort, UnknownStatus)
[comlink/content_request.rye](../../comlink/content_request.rye) plaintext localhost content request format -- encode/decode for request and response frames
[comlink/content_request_witness.rye](../../comlink/content_request_witness.rye) witness proving round-trip encoding, Kumara identity, status codes, and refusal paths
recommend keep-going -- next: Movement 8 of Mantra SLC (implement localhost UDP request-response, ~siya sends to ~sunflower)
