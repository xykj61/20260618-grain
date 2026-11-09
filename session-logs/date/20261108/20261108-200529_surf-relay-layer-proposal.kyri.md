format session-log-v1
stamp 20261108.200529
editor Claude Code
provider Anthropic
product Claude Code
role repository
modality text
model claude-opus-4-6
model_status active runtime
voice Kyri
title Surf relay layer proposal -- Comlink wire for social feed exchange
prompt Keaton asked to work on the relay layer for Surf Social
think Comlink already has substantial wire infrastructure -- sealed datagrams over UDP (hosted_wire.rye) and virtio-net (device_wire.rye), peer discovery with gossip (discovery/gossip.rye), introduction gate (discovery/introduce.rye), d12-d60 fractal topology, turn-routing with key rotation
think Surf is local-only today -- feed holds only own events. Relay lets events travel between peers: publish to relay, subscribe to peer's relay, receive signed events
think proposed 5-movement SLC: relay wire format (reuse wire_format.rye seal/open), relay server (hosted UDP, Mantra persistence per pubkey), relay client C exports in surf_vantage.rye, Terrarium relay UI (address field, publish toggle, fetch button), integration witness (two identities, relay server, publish-subscribe round trip)
obs Comlink wire_format.rye uses ChaCha20-Poly1305 sealed, X25519 key agreement, Ed25519 signed -- 528-byte capacity datagrams
obs Surf events are variable-size (up to ~4200 bytes with max content) which exceeds wire_format's 528-byte capacity -- either fragment or use a separate Surf-specific wire format that sits beside Comlink's sealed layer
obs discovery/gossip.rye already has bounded peer table (256 peers, fanout 8), introduction gate with hop limit (2), and descriptor exchange -- substantial infrastructure waiting for Surf to plug into
file [comlink/wire_format.rye](../../comlink/wire_format.rye) sealed datagram layout, 528-byte capacity
file [comlink/hosted_wire.rye](../../comlink/hosted_wire.rye) UDP localhost sealed wire
file [comlink/discovery/gossip.rye](../../comlink/discovery/gossip.rye) peer discovery with bounded table
file [surf/surf_vantage.rye](../../surf/surf_vantage.rye) current Surf module -- 22 C exports, local-only feed
recommend check-in (Claude) -- relay SLC shape proposed, five movements. Needs Keaton's word on the shape and on the wire format question (528-byte datagram vs larger Surf-specific frame).
