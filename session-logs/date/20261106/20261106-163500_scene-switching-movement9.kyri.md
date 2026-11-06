format session-log-v1
stamp 20261106.163500
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Scene switching -- Movement 9
prompt kg -- land Movement 9, Cmd+1 and Cmd+2 scene switching
think Cmd+1 and Cmd+2 best handled via NSMenu key equivalents -- the OS intercepts them before any view, clean and native
think scrollView and gridContainer were local variables in applicationDidFinishLaunching -- promoted to AppDelegate properties so the focus indicator can reach them
think focus indicator is a 2px blue border (0.3, 0.6, 1.0, 0.8) on the active pane's container, removed from the inactive one -- subtle, visible on black
think updateFocusIndicator reads window.firstResponder and checks whether it is an NSTextView (terminal focused) or not (grid focused)
think keyboard routing already works via the NSResponder chain -- whichever view is first responder receives keyDown/keyUp
obs NSMenu with View submenu is the standard macOS pattern -- also gives the app a Quit item with Cmd+Q for free
obs Both scrollView and gridContainer had wantsLayer already (gridContainer explicitly, scrollView added) so layer border properties work immediately
file [terrarium/app/main.swift](../../terrarium/app/main.swift) added scrollView/gridContainer properties, setupMenu with Cmd+1/Cmd+2, focusTerminal/focusGrid actions, updateFocusIndicator with blue border
file [active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md](../../active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md) checked off Movement 9
file [active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md](../../active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md) added Movement 9 row
recommend keep-going -- next: Movement 10, Quest 2 integration witness
