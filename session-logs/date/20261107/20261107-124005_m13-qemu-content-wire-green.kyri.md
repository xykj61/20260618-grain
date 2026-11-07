format session-log-v1
stamp 20261107.124005
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title M13 -- QEMU content wire GREEN
prompt continue M13: prove content request-response inside Terrarium QEMU emulator
think freestanding guest cannot use std.crypto or std.posix -- no SHA3-256, no UDP sockets
think UART wire protocol: guest writes CREQ to serial TX, Swift host reads serial pipe, looks up bloom content, responds with CRESP header and payload
think djb2 (32-bit) replaces SHA3-256 for freestanding integrity verification
think ELF naming convention: Swift app derives elfPath from stage name, so content_wire stage needs content_wire.elf
think serial buffer chunking: QEMU delivers bytes in arbitrary chunks, so components(separatedBy: "\n") creates partial trailing element
think fix: dropLast() on split array when buffer lacks trailing newline, ensuring only complete lines are processed as CREQs
obs UART wire protocol CREQ/CRESP is the freestanding equivalent of the UDP wire from M8-M10 -- same content addressing, different transport
obs djb2 hash is 32-bit and not cryptographic, yet sufficient for integrity verification on a freestanding target where std.crypto is unavailable
obs serial buffer partial-line processing was the subtle red -- first CREQ worked, second arrived split across chunks, partial line matched CREQ prefix with 3 comma-splits despite being truncated
file [terrarium/src/comlink_content.rye](../../terrarium/src/comlink_content.rye) freestanding RISC-V guest: UART I/O, djb2 hash, CREQ/CRESP protocol, 3 requests
file [terrarium/comlink_content_witness.rish](../../terrarium/comlink_content_witness.rish) witness: builds guest ELF, builds Swift app, runs content_wire stage, asserts GREEN + djb2 + 3 claims
file [terrarium/app/main.swift](../../terrarium/app/main.swift) serial buffer fix: dropLast() for incomplete lines, CREQ/CRESP relay to bloom content
file [active-tablecloth/date/202611/00/20261107-090000_mantra-slc-comlink-realidream/CHECKLIST.md](../../active-tablecloth/date/202611/00/20261107-090000_mantra-slc-comlink-realidream/CHECKLIST.md) M13 checked off with GREEN results
recommend keep-going -- next: commit M13 work, amend nib, push, then M14 silo remaining Bloom rooms onto galaxies
