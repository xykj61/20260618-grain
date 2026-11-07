format session-log-v1
stamp 20261107.135957
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Vantage/Station/Carry cross-platform design dialogue
prompt design RFC for write-once cross-platform architecture: vantage/ (shared logic), station/ (desktop shell), carry/ (mobile shell), refactor terrarium/ coupling
think elder grain-sketchbook: Vantage was a VM (x86_64 Limine -> RISC-V64 emulation), Carry Core was mobile FFI (api/auth/crypto/websocket). Both names are free to redefine since Terrarium now holds the emulation role.
think main.swift is 3,831 lines, 78 functions, one AppDelegate class -- three layers tangled: platform shell (~1,200 lines AppKit), application logic (~1,800 lines Bloom/Dimeroll), emulation bridge (~800 lines QEMU/UART/wire)
think Pond is the OS application host (enclosure policy, customs, apps/) -- governs what an app may do. Vantage is what the app actually does -- write-once logic. Keep them separate: Pond hosts, Vantage runs inside the host.
think WASM target: Zig can compile wasm32-freestanding, needs extern FFI layer to JS for DOM/events/routing. Same constraints as RISC-V freestanding -- no libc, no POSIX. Scope as later quest, prove abstraction on macOS first.
think DVUI is immediate-mode (like Dear ImGui), AppKit is retained-mode. Station abstraction needs to accommodate both paradigms behind a trait interface.
think Carry (iOS/Android) is hardest: two platform bridges (Swift UIKit + Kotlin JNI), strong lifecycle opinions (backgrounding, state restoration, push). Defer to second journey.
obs proposed architecture: vantage/ (write-once logic) -> station/ (desktop: macos/wasm/linux) and carry/ (mobile: ios/android), terrarium/ keeps only RISC-V emulation bridge, pond/ stays OS host
obs five design questions raised for Keaton: (1) Pond vs Vantage distinction, (2) what stays in terrarium, (3) WASM as station target vs own shell, (4) DVUI immediate-mode vs retained-mode, (5) Carry deferral
obs proposed 75-movement journey: Quest 1 extract Vantage, Quest 2 Station macOS, Quest 3 Station WASM, Quest 4 Station Linux, Quest 5 Teacher molt-breach and tools cleanup
file [gratitude/grain-sketchbook/src/grain_carry_core/](../../gratitude/grain-sketchbook/src/grain_carry_core/) elder mobile FFI layer: api, auth, crypto, email, ffi, style, utils, validation, websocket
file [gratitude/grain-sketchbook/src/vantage/](../../gratitude/grain-sketchbook/src/vantage/) elder VM: RISC-V core, Basin integration, x86_64 boot via Limine
file [terrarium/app/main.swift](../../terrarium/app/main.swift) 3,831 lines surveyed for layer separation: platform shell, application logic, emulation bridge
file [pond/README.md](../../pond/README.md) application module charter: customs, enclosure policy, apps/ floor
recommend check-in (Claude) -- Keaton's word on Pond/Vantage distinction, scope, and quest shape before RFC document
