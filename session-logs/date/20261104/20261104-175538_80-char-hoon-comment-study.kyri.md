format session-log-v1
stamp 20261104.175538
session-header [20261104-164949_orbit-1-root-consolidation-survey.kyri.md](20261104-164949_orbit-1-root-consolidation-survey.kyri.md)
voice Kyri
title 80-char line width and Hoon comment study -- yes to both
prompt Keaton asked whether to adopt Urbit's 80-char line width instead of TigerBeetle's 100, whether to adopt Hoon's column-57 inline comment pattern for Glow, to verify DJINN's MIT license merge, and to study Urbit source for comment beauty
think measured Hoon core (hoon.hoon, arvo.hoon, zuse.hoon, lull.hoon) -- 28,132 lines, 99.8% within 80 chars, only 64 lines over; the standard is effectively 80 held by tall-form discipline alone
think measured column-57 pattern -- 78.5% of inline comments (2,361 of 3,007) align `::` at column 57; code at 1-56, pad, `::` at 57-58, comment text to ~78; average comment portion 13.6 chars
think censused our tree -- 297,024 lines over 80 in living files; incremental cost of 80 vs 100 is 163,584 lines in the 81-100 gap; Glow cheapest at 622 lines, Rye biggest at 130,952
think TigerBeetle chose 100 for Zig's wider signatures; Hoon's tall form keeps code naturally under 56 chars; the 80-char limit and tall form are mutually reinforcing
think accessibility argument: 80 fits tablets in portrait, phones in landscape, split-pane terminals, GitHub diff view, and printed code; 100 fails the first three
think Q10 license gate CLEAR -- DJINN merged MIT license to grain-os main at commit 80d14c5; submodule pointer advances 0e26780 to 80d14c5
obs the recommendation: yes to 80 chars (safety -- accessible code on more devices), yes to column-57 `::` (joy -- the beauty Hoon already found), phase the ratchet starting with Glow (cheapest), then Rye (biggest), then Rishi/shell/prose on touch
obs this is the first departure from TigerBeetle's standard -- toward Urbit's elder discipline, for accessibility reasons TigerBeetle's own physical reasoning supports (a good typographic measure on more screens)
obs the 80-char standard and the column-57 pattern are one decision wearing two names -- the width is what makes the right-margin comment column work, and the comment column is what makes the width beautiful
orbit round 15 Pisces -- the ocean dissolves; the ancestor's beauty dissolves into our own code
rota none -- pure research and response composition, no rota this lap
[active-designing/date/20261104/20261104-175538_80-char-line-width-and-hoon-comment-study.md](../../active-designing/date/20261104/20261104-175538_80-char-line-width-and-hoon-comment-study.md) comprehensive study recommending 80-char width and column-57 `::` pattern for Glow
recommend check in (either) -- Keaton's word seats the 80-char standard and the column-57 pattern; the ratchet phasing follows from that word
