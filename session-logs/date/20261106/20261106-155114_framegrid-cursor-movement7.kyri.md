format session-log-v1
stamp 20261106.155114
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title FrameGrid cursor -- Movement 7
prompt kg -- land Movement 7, FrameGrid cursor driven by EventRing
think Movement 7 adds a visible cursor to FrameGridView -- cursorRow and cursorCol properties bounded by SkateCoreBounds
think processEvents() drains the EventRing after each keyDown push -- arrow key codes (126 up, 125 down, 123 left, 124 right) move the cursor
think draw() renders the cursor by inverting the palette -- foreground color fills the cell background, defaultBG draws the text
think empty cells at the cursor position get a solid fill of defaultFG so the cursor is visible even on spaces
think wired processEvents() call after try eventRing.append() in keyDown -- events push and drain in the same callback
obs Clean separation: events flow through EventRing (platform-neutral) rather than reading NSEvent directly in the cursor logic
obs Cursor bounds clamped by SkateCoreBounds.rows and .columns -- the same constants FrameGrid uses, so the cursor cannot escape the grid
obs Two-step build clean, Terrarium launches, QEMU hello runs and exits -- existing flow unbroken
file [terrarium/app/main.swift](../../terrarium/app/main.swift) added cursorRow/cursorCol properties, cursor drawing in draw(), processEvents() method, wired processEvents into keyDown
file [active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md](../../active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md) checked off Movement 7
file [active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md](../../active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md) added Movement 7 row
recommend keep-going -- next: Movement 8, ConsentRail integration (consent prompt in FrameGrid, Enter accepts, Escape declines)
