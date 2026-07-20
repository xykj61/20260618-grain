# glow-language — Glow SLC · nest · product · ≤80 · glow-language–110 GREEN · 2026-07-20 (G0–G5 · bartis · nest/type) · draw → **glow-language**
| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **glow-language** | Eight rune heads + desk hop · `(lent)` · `(mix)` | `glow_run_desk_witness` · `glow_expr_witness` | **GREEN** (claimed `20260718.202730`) |
| **glow-language** | `(jam <face> <face>)` thin cell-pack · desks | `glow_expr` · `glow_lower_*` · desk | **GREEN** `20260718.203000` |
| **glow-language** | `:-` pair cell · ninth rune head | `glow_rune_cell` · `glow_lower_cell` · desk | **GREEN** `20260718.204500` |
| **glow-language** | `:+` triple cell · tenth rune head | `glow_rune_triple` · `glow_lower_triple` · desk | **GREEN** `20260718.205200` |
| **glow-language** | `:^` quad cell · eleventh rune head | `glow_rune_quad` · `glow_lower_quad` · desk | **GREEN** `20260718.205400` |
| **glow-language** | `:~` list cell · twelfth rune head | `glow_rune_list` · `glow_lower_list` · desk | **GREEN** `20260718.205715` |
| **glow-language** | `%-` one-arg call · thirteenth rune head | `glow_rune_call` · `glow_lower_call` · desk | **GREEN** `20260718.205959` |
| **glow-language** | `%+` two-arg call · fourteenth rune head | `glow_rune_call2` · `glow_lower_call2` · desk | **GREEN** `20260718.210823` |
| **glow-language** | `%^` three-arg call · fifteenth rune head | `glow_rune_call3` · `glow_lower_call3` · desk | **GREEN** `20260718.211059` |
| **glow-language** | `%*` named-arg call · sixteenth rune head | `glow_rune_calln` · `glow_lower_calln` · desk | **GREEN** `20260718.211343` |
| **glow-language** | Multi-line bare `=/` desk (2–4 lines) | `glow_lower_multi` · desk | **GREEN** `20260718.211817` |
| **glow-language** | Cross-line face→`%-` compose | `glow_lower_compose` · desk | **GREEN** `20260718.212131` |
| **glow-language** | Cross-line face→face→`%+` compose | `glow_lower_compose2` · desk | **GREEN** `20260718.221812` |
| **glow-language** | Typed multi-line `@u32` desks | `glow_lower_multi_typed` · desk | **GREEN** `20260718.223431` |
| **glow-language** | Thin `|%` / `++` / `--` core | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.224030` |
| **glow-language** | Two-arm battery (`double` · `inc`) | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.225150` |
| **glow-language** | Library emit (no `main`) | `glow_lower_core_lib` · consumer | **GREEN** `20260718.225150` |
| **glow-language** | Core payload `=/` sample | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.225931` |
| **glow-language** | Face→`|%` compose | `glow_lower_compose_core` · desk | **GREEN** `20260718.230846` |
| **glow-language** | Face→two-arm `|%` | `glow_lower_compose_core` · desk | **GREEN** `20260718.231511` |
| **glow-language** | Three-arm battery (`dec`) | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.231511` |
| **glow-language** | Typed payload `@u32` | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.232419` |
| **glow-language** | Face→three-arm `|%` | `glow_lower_compose_core` · desk | **GREEN** `20260718.233120` |
| **glow-language** | Two faces→`|%` `add` | `glow_lower_compose_core_add` · desk | **GREEN** `20260718.234122` |
| **glow-language** | Face→payload `|%` | `glow_lower_compose_core_payload` · desk | **GREEN** `20260718.234430` |
| **glow-language** | Open `++` arm body | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.235220` |
| **glow-language** | `/+` library compose | `glow_lower_compose_lib` · desk | **GREEN** `20260718.235530` |
| **glow-language** | Nest `++` arm body | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.235804` |
| **glow-language** | Face→open `|%` | `glow_lower_compose_core` · desk | **GREEN** `20260719.000132` |
| **glow-language** | `/+` nest library | `glow_lower_compose_lib` · desk | **GREEN** `20260719.000324` |
| **glow-language** | Payload+open `|%` | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.000745` |
| **glow-language** | `/+` payload library | `glow_lower_compose_lib` · desk | **GREEN** `20260719.001148` |
| **glow-language** | `(cue <face>)` thin unpack · desks | `glow_expr` · `glow_lower_*` · desk | **GREEN** `20260719.002221` |
| **glow-language** | `(jam (mix …) …)` one-deep nest · face | `glow_expr` · `glow_lower_face` · desk | **GREEN** `20260719.002726` |
| **glow-language** | Nest jam under `?:`/`?-`/`?~` arms | `glow_lower_*` · desks | **GREEN** `20260719.005207` |
| **glow-language** | Nest jam under open `++` | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260719.005650` |
| **glow-language** | `(jam … (mix …))` nest right | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.010409` |
| **glow-language** | `(jam (mix …) (mix …))` nest both | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.143329` |
| **glow-language** | `(cue (jam …))` nest round-trip | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.144929` |
| **glow-language** | Cross-line jam→cue compose | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.145738` |
| **glow-language** | `(cue (jam (mix …) …))` nest-left | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.150634` |
| **glow-language** | `(cue (jam … (mix …)))` nest-right | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.151831` |
| **glow-language** | `(cue (jam (mix …) (mix …)))` nest-both | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.153013` |
| **glow-language** | Bind→jam→cue product multi-line | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.153556` |
| **glow-language** | Bind→nest-jam→cue product multi-line | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.154112` |
| **glow-language** | Bind→nest-right-jam→cue product | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.154325` |
| **glow-language** | Bind→nest-both-jam→cue product | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.154840` |
| **glow-language** | Three-bind nest-left jam→cue | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.155553` |
| **glow-language** | Four-bind nest-both jam→cue | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.161949` |
| **glow-language** | Bind→inline cue-of-jam product | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.162549` |
| **glow-language** | Bind→inline nest-left cue-of-jam | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.163125` |
| **glow-language** | Bind→inline nest-right cue-of-jam | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.163527` |
| **glow-language** | Bind→inline nest-both cue-of-jam | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.163945` |
| **glow-language** | Face→`|%` cue-of-jam | `glow_lower_compose_core` · desk | **GREEN** `20260719.164640` |
| **glow-language** | Face→nest-left cue-of-jam | `glow_lower_compose_core` · desk | **GREEN** `20260719.165048` |
| **glow-language** | Face→nest-right cue-of-jam | `glow_lower_compose_core` · desk | **GREEN** `20260719.165404` |
| **glow-language** | Face→nest-both cue-of-jam | `glow_lower_compose_core` · desk | **GREEN** `20260719.165724` |
| **glow-language** | `/+` cue-of-jam library | `glow_lower_compose_lib` · desk | **GREEN** `20260719.170057` |
| **glow-language** | `/+` nest-left cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.170718` |
| **glow-language** | `/+` nest-right cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.171131` |
| **glow-language** | `/+` nest-both cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.171500` |
| **glow-language** | Face→payload cue-of-jam | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.171844` |
| **glow-language** | Face→payload nest-left cue-of-jam | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.172234` |
| **glow-language** | Face→payload nest-right cue-of-jam | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.172625` |
| **glow-language** | Face→payload nest-both cue-of-jam | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.173215` |
| **glow-language** | `/+` payload cue-of-jam library | `glow_lower_compose_lib` · desk | **GREEN** `20260719.173708` |
| **glow-language** | `/+` payload nest-left cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.174116` |
| **glow-language** | `/+` payload nest-right cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.174531` |
| **glow-language** | `/+` payload nest-both cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.175024` |
| **glow-language** | next-root product desk (`/+` · payload · cue-jam) | `glow_lower_compose_lib` · desk | **GREEN** `20260719.180837` |
| **glow-language** | session-root nest-left product desk | `glow_lower_compose_lib` · desk | **GREEN** `20260719.181259` |
| **glow-language** | NativeActivity-path Glow import seam | `stoa71_glow_import_seam_witness` | **GREEN** `20260719.182120` |
| **glow-language** | NativeActivity APK Glow import wire | `stoa72_glow_apk_import_witness` · pack | **GREEN** `20260719.182648` |
| **glow-language** | product-root write + Pixel install (expect 5) | write · `stoa73_…_install_onpath_host` | **GREEN** write `184836` · eyes `191719` |
| **glow-language–75** | `+$` / `$:` `@u32` mold (1–3 fields) | `glow_rune_mold` · `glow_lower_mold` · desk | **GREEN** `190825` · `192241` |
| **glow-language–83** | `$%` · cast · payload · multi · tag/pay · token stream | mold · named-cast · tokens | **GREEN** `192936`…`200706` |
| **glow-language–105** | Cast · alphabet · G4–G5 · bartis tidy | tokens · G5 · bartis | **GREEN** `201027`…`042300` |
| **glow-language** | Nest/type surface wording (nesting samples) | `glow_nest_type_surface_witness` | **GREEN** `20260720.042931` |
| **glow-language** | Nest/type thin implement (stated aura) | `glow_nest_type_witness` · bartis | **GREEN** `20260720.043251` |
| **glow-language** | Nest/type `$%` tag nest | `glow_nest_type_witness` · mold-kind | **GREEN** `20260720.145814` |
| **glow-language** | Named-mold bartis (`amount-mold`) | `glow_nest_type_witness` · bartis · desk | **GREEN** `20260720.150155` |
| **glow-language** | Nesting-refuse nest path | `glow_nest_type_witness` · barket horizon | **GREEN** `20260720.150635` |
| **glow-language** | Barket tokenize (`\|^` → 27) | `glow_barket_tokenize_witness` · alphabet | **GREEN** `20260720.151119` |
| **glow-language** | Barket header parse (stated demo) | `glow_barket_parse_witness` · tokenize | **GREEN** `20260720.174115` |
| **glow-language** | Barket identity lower (`barket_gate`) | `glow_barket_lower_witness` · `glow_run` | **GREEN** `20260720.175115` |
| **glow-language** | Barket argv sample | `glow_barket_lower_witness` · `--sample-argv` | **GREEN** `20260720.175643` |
| **glow-language** | Barket call-body double | `glow_barket_lower_witness` · `glow_run` | **GREEN** `20260720.180047` |
| **glow-language** | Barket call-body inc/dec | `glow_barket_lower_witness` · `glow_run` | **GREEN** `20260720.180445` |
| **glow-language** | Barket TAME tidy | `glow_barket_lower_witness` · `tame_style_scan_bans` | **GREEN** `20260720.180900` |
| **glow-language** | Named-mold barket | `glow_barket_lower_witness` · `glow_run` | **GREEN** `20260720.181347` |
| **glow-language** | Nesting-nests under stated mold | `glow_nest_type_witness` | **GREEN** `20260720.181950` |
| **glow-language** | Nesting-nests barket/bartis wire | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.182450` |
| **glow-language** | Barket nesting-through-nests | `glow_barket_lower_witness` | **GREEN** `20260720.182915` |
| **glow-language** | Count-mold named allowlist | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.183259` |
| **glow-language** | Kind-mold gate sample | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.183837` |
| **glow-language** | Xact-mold gate sample | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.184304` |
| **glow-language** | Xfer-mold gate sample | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.184953` |
| **glow-language** | Pair-mold gate sample | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.185502` |
| **glow-language** | Kind-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.190544` |
| **glow-language** | Xact-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.191033` |
| **glow-language** | Xfer-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.192038` |
| **glow-language** | Stated · nesting · gold vocabulary | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.192738` |
| **glow-language** | Pair-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.193357` |
| **glow-language** | Amount-mold argv sample | `glow_barket_lower_witness` · bartis · glow_run | **GREEN** `20260720.193805` |
| **glow-language** | Count-mold argv sample | `glow_barket_lower_witness` · bartis · glow_run | **GREEN** `20260720.194143` |
Smoke: `glow_barket_lower_witness` · `glow_barket_parse_witness` · `glow_nest_type_witness` · `glow_lower_bartis_witness` · Sibling: **glass-keyboard** · **hearth-display** · **usb-hearth** · **glow-publishing**.
