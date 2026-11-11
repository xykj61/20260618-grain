# Surf Relay

**Language:** EN - **Style:** Teacher at the Door setting, with Radiant warmth (see `../../context/TEACHER_STYLE.md`)
**Written:** `20261111.120000` - **Status:** Living

---

Surf Relay is a store-and-forward service that lets Surf Social posts travel
between peers. A relay server holds recent events in memory, accepts published
events from any client, and hands them back on request. Events self-authenticate
through their Ed25519 signatures, so the relay adds no cryptography of its own --
it stores what it receives and serves what it is asked for.

## What you see in Terrarium

The **Relay** controls sit inside the Social tab, below the follow field:

- **Address field** -- defaults to `127.0.0.1:38504`. Point it at any running
  relay server on your network.
- **Fetch** button -- pull events from the relay for every pubkey you follow.
  New posts appear in the timeline.
- **Auto-publish** checkbox -- when checked, every post you compose is
  automatically sent to the relay in the same gesture.
- **Status line** -- shows the result of the last relay operation (how many
  events were fetched or published, or what went wrong).

## How the wire protocol works

Relay frames travel over **UDP** on port **38504**, bounded at **8,192 bytes**
per frame. Four message types make up the protocol:

| Byte | Name | Direction | What it carries |
|---|---|---|---|
| `0x01` | PUBLISH | client to relay | one signed event |
| `0x02` | REQUEST | client to relay | a pubkey and a "since" timestamp |
| `0x03` | EVENTS | relay to client | zero or more events matching a request |
| `0x04` | ACK | relay to client | a one-byte status (ok, full, or invalid) |

A client publishes by sending a PUBLISH frame. The relay stores the event (up to
64 events per pubkey, 256 pubkeys total -- a ring buffer, oldest overwritten)
and responds with an ACK.

A client fetches by sending a REQUEST frame naming a pubkey and a timestamp. The
relay responds with an EVENTS frame containing every event for that key created
after the timestamp.

## The relay server

The server is a standalone Rye binary at `surf/relay_server.rye`. Build and run
it:

```
rye build surf/relay_server.rye -lc -femit-bin=surf/bin/relay-server
surf/bin/relay-server serve 1000
```

That serves 1,000 frames and exits. The server holds events in memory only --
there is no disk persistence yet, so restarting it clears the store.

## The C-ABI surface

Two functions in `vantage/include/vantage_surf.h` handle the client side:

| Function | What it does |
|---|---|
| `surf_relay_publish` | send a signed event to the relay at a given address |
| `surf_relay_fetch` | request events for a pubkey since a timestamp |

Both take the relay address as a 4-byte IPv4 address array and a `uint16_t`
port number. The Terrarium UI parses the text field into octets and port
before calling through.

## Bounds

| Quantity | Limit |
|---|---|
| Frame size | 8,192 bytes |
| Content per event | 4,096 bytes |
| Pubkeys per relay | 256 |
| Events per pubkey | 64 (ring buffer) |
| Relay port | 38504 |

## What to read next

- [Surf Social](surf-social.md) -- the identity, feed, and follow system the
  relay carries
- The wire format source at `surf/relay_format.rye`
- The server source at `surf/relay_server.rye`
