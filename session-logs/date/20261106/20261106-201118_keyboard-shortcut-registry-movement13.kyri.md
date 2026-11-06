format session-log-v1
stamp 20261106.201118
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Keyboard shortcut registry -- Movement 13
prompt kg -- Movement 13, keyboard shortcut registry with Cmd+T, Cmd+W, Cmd+[
think Shortcuts menu as a dedicated NSMenu beside View, three NSMenuItems with key equivalents
think status bar at the bottom of the window -- NSTextField with dark background, monospaced font, 22px height
think split view frame adjusted upward by statusH to make room for the label below it
think newTab creates dynamic NSTabViewItems with placeholder NSView, increments nextTabId counter
think closeTab guards built-in tabs by checking identifier against "terminal" and "grid" strings
think previousTab wraps to last tab when index is zero, otherwise decrements
think showShortcutStatus updates the label text on every shortcut activation
obs Shortcuts menu lives beside View menu -- three items: New Tab (Cmd+T), Close Tab (Cmd+W), Previous Tab (Cmd+[)
obs status bar: NSTextField at y=0, dark background (white: 0.12), monospacedSystemFont 11pt, shows "Ready" on launch
obs split view frame origin.y raised by 22px so status bar sits below it cleanly
obs closeTab refuses when fewer than 3 items or when selected item is Terminal/Grid -- shows refusal message in status
obs Quest 2 witness GREEN (16 proofs), Terrarium builds clean with two-step build
file [terrarium/app/main.swift](../../terrarium/app/main.swift) Shortcuts menu, status bar NSTextField, newTab/closeTab/previousTab @objc methods, showShortcutStatus helper
file [active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md](../../active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md) Movement 13 marked done
file [active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md](../../active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md) Movement 13 row added
recommend keep-going -- next: Movement 14, status bar with connection state and active module name
