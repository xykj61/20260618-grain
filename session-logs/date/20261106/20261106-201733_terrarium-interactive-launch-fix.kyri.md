format session-log-v1
stamp 20261106.201733
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Terrarium interactive launch fix -- app stays open for Keaton
prompt open the application for me

think The app exits immediately because `dumpAndExit` at line 2323 calls `NSApplication.shared.terminate(nil)` unconditionally from QEMU's `terminationHandler`. QEMU runs the "hello" ELF, exits, the handler fires, and the app dies before Keaton can see it.
think A 10-second timeout at line 1989 also terminates QEMU for non-framebuf stages, which triggers the same exit chain.
think The fix: detect interactive mode (no CLI stage argument) and skip both `dumpAndExit` and the timeout. Witnesses pass a stage argument explicitly, so headless behavior is unchanged.

obs Three edits to `terrarium/app/main.swift`: (1) `isInteractive` flag at line 23, true when `CommandLine.arguments.count <= 1`; (2) guard `dumpAndExit` behind `!isInteractive` in the termination handler; (3) guard the timeout dispatch behind `!isInteractive`. Build clean, app stays running with pid visible.

file [terrarium/app/main.swift](../../terrarium/app/main.swift) three edits: isInteractive flag, conditional dumpAndExit, conditional timeout

recommend check-in (Claude) -- Keaton confirms the window is visible and interactive, then send
