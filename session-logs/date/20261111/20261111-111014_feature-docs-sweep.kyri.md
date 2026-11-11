format session-log-v1
stamp 20261111.111014
session-header 20261111-105128_onboarding-ux-chapter-plan.kyri.md
voice Kyri
title feature docs sweep -- four Teacher pages for docs-geode/features/
prompt kg on movement 2 of the onboarding UX chapter: write feature documentation for all four shipped Terrarium modules
think survey complete from prior context -- C-ABI headers, Swift UI code, and Rye sources all read for Surf Social, Surf Relay, Lotus Audio, and Mantra Store
think each page needs: what it does (opening paragraph), what you see in Terrarium (UI walkthrough), how the internals work (data shape or protocol), the C-ABI surface (function table), and a what-to-read-next section
think Teacher at the Door register -- assume no background, first principles in order, one new idea at a time, concrete before abstract
think created docs-geode/features/ directory, wrote README index and four feature pages
obs Surf Relay page includes the full wire protocol table (PUBLISH/REQUEST/EVENTS/ACK) and the bounded store limits (256 pubkeys, 64 events each) -- these are the numbers a reader needs to understand why old posts disappear
obs Lotus Audio page splits playback and recording into separate C-ABI tables since they are separate subsystems with separate lifecycle (open/start/stop/close for each)
obs Mantra page explains content addressing from first principles before naming any function -- the concept is what a newcomer needs, the API table is reference
obs review caught two factual inaccuracies: surf-social.md said data persists to ~/.grain/surf/ when it actually goes through the Mantra blob store at ~/.grain/mantra/; surf-relay.md said relay functions take address as a string when the C-ABI takes a 4-byte IPv4 array and uint16_t port. Both corrected before commit
obs added features/ room row to docs-geode/README.md table so the crushed_index_witness sees the new room
file [docs-geode/features/README.md](../../docs-geode/features/README.md) index page with four-row feature table
file [docs-geode/features/surf-social.md](../../docs-geode/features/surf-social.md) Surf Social feature page -- identity, feed, follow, persistence, 21 C-ABI functions documented
file [docs-geode/features/surf-relay.md](../../docs-geode/features/surf-relay.md) Surf Relay feature page -- wire protocol, bounded store, relay server build instructions
file [docs-geode/features/lotus-audio.md](../../docs-geode/features/lotus-audio.md) Lotus Audio feature page -- playback, recording, mixer, waveform, WAV export, 19 C-ABI functions documented
file [docs-geode/features/mantra-store.md](../../docs-geode/features/mantra-store.md) Mantra Store feature page -- content-addressed blob store, catalog, disk layout, 10 C-ABI functions documented
file [README.md](../../README.md) fascia badge updated 60.161 to 60.162
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia description updated for feature docs sweep
file [docs-geode/README.md](../../docs-geode/README.md) added features/ room row to the crushed index table
recommend keep-going -- movement 3: readme-concrete-section, add a "what you see when you run it" section to the root README
