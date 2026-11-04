format session-log-v1
stamp 20261104.153430
session-header [20261104-045214_ssh-decouple-and-nib-amend.kyri.md](20261104-045214_ssh-decouple-and-nib-amend.kyri.md)
voice Kyri
title Orbit 14 -- Glow Meets the Screen tutorial
prompt kg -- continue the glow-language journey, Orbit 14
think Orbit 14 spec (CHECKLIST lines 199-205): Bhakta-at-Door tutorial walking a newcomer from the REPL demo (Orbit 11) to the layout demo (Orbit 12), covering how Glow drives Brushstroke, the layout model, and how to change what appears on screen
think wrote docs-geode/tutorials/glow-meets-the-screen.md -- sections covering bridge architecture (Glow expression -> repl_eval.rye -> Rye module -> AppKit window), building and running both the REPL and layout demo, reading the layout code (entry table, geometry constants, row_y function), and an exercise that changes one entry in the table
think verified Bhakta witness GREEN: pages=62 miss=0 verdict=ok -- the new tutorial carries its Style line correctly
think updated tutorials README with row for the new tutorial, checked off Orbit 14 in CHECKLIST, bumped fascia 60.058 to 60.059 in both ITINERARY and root README
obs the tutorial follows Bhakta's moves -- one new idea at a time, concrete before abstract, the bridge diagram shown first and then named, the exercise grounded in a change the reader can see with their own eyes and then revert
obs three code fences carry real build commands the prior orbit proved on metal; the REPL interaction examples and the layout demo output table match the actual programs
[docs-geode/tutorials/glow-meets-the-screen.md](../../docs-geode/tutorials/glow-meets-the-screen.md) Bhakta-at-Door tutorial -- Glow reaches a window
[docs-geode/tutorials/README.md](../../docs-geode/tutorials/README.md) added row for Glow Meets the Screen
[tablecloth/20261103-184811_glow-language-journey/CHECKLIST.md](../../tablecloth/20261103-184811_glow-language-journey/CHECKLIST.md) Orbit 14 checked off
[construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.058 to 60.059, Glow 11-14
[README.md](../../README.md) fascia badge 60.058 to 60.059, Glow 11-14
recommend keep-going -- Orbit 15 awaits: grow docs-geode/cookbook/ from 3 to at least 8 pages and add glow-stdlib.md reference page
