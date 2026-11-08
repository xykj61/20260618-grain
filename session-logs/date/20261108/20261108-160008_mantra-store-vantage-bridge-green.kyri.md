format session-log-v1
stamp 20261108.160008
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Mantra store Vantage bridge -- 10 exports, 8 proves GREEN
prompt kg (continuing from Scribe SLC, Mantra filesystem SLC tablecloth created)
think Mantra bridge follows the proven Scribe pattern: static globals, C exports with callconv(.c), buffer-based I/O, selftest with prove functions returning error on failure.
think The bridge owns SHA3-256 computation and in-memory catalog. Swift will own disk I/O to ~/.grain/mantra/. This separation was decided because store.rye uses std.Io.Dir which may not work in build-lib context.
think Scoped 10 C exports: init, digest, verify, catalog_add, catalog_count, catalog_list, catalog_get_digest, catalog_save, catalog_load, selftest. Catalog bounded at 256 entries, paths at 255 bytes.
think Kyri serialization format: "format mantra-catalog-v1" header, then entry/digest/size triplets per blob. Parser streams line-by-line, emitting on the next "entry" or at end-of-input.
obs Clean build to dylib on first attempt. All 8 selftest proves GREEN on first run. The SHA3-256 from Rye's std.crypto works identically in build-lib as in standalone.
obs Digest is deterministic (same data same hash), verify correctly accepts matching content and rejects modified, catalog updates in place (same path replaces digest), save-load roundtrip preserves path and digest through Kyri format, load refuses mismatched format header.
loom mantra_vantage=selftest proves=8 exports=10 catalog_max=256 path_max=255
file [mantra/mantra_vantage.rye](../../mantra/mantra_vantage.rye) Mantra store Vantage bridge -- SHA3-256 content-addressing, in-memory catalog, Kyri serialization, 10 C exports, 8 prove functions
file [vantage/include/vantage_mantra.h](../../vantage/include/vantage_mantra.h) C header for Mantra FFI bridge
file [vantage/include/module.modulemap](../../vantage/include/module.modulemap) added VantageMantra module
file [construction/ITINERARY.md](../../construction/ITINERARY.md) fascia 60.145 to 60.146
file [README.md](../../README.md) fascia badge 60.145 to 60.146
file [active-tablecloth/date/202611/00/20261108-155213_mantra-filesystem-slc/CHECKLIST.md](../../active-tablecloth/date/202611/00/20261108-155213_mantra-filesystem-slc/CHECKLIST.md) movement 1 checked
file [active-tablecloth/date/202611/00/20261108-155213_mantra-filesystem-slc/PROGRESS.md](../../active-tablecloth/date/202611/00/20261108-155213_mantra-filesystem-slc/PROGRESS.md) bridge GREEN milestone logged
recommend keep-going -- next: Mantra tab scaffold, replace "coming in Act III" placeholder with store browser
