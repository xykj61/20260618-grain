/// terrarium_quest2_harness.swift -- headless integration proof for Quest 2.
///
/// Exercises the SkateCore types that Movements 6-9 landed:
///   6. EventRing keyboard adapter (SkateEvent enum, EventRing<SkateEvent>)
///   7. FrameGrid cursor (arrow key events drive cursor, palette marks position)
///   8. ConsentRail integration (folded/expanded frames, content verification)
///   9. Scene switching (type-level: all types compose without conflict)
///
/// Built against libSkateCore.dylib, run headlessly.
/// Output: key=value lines the witness parses.

import SkateCore

@available(macOS 26.0, *)
func testSkateEventTypes() -> Int {
    var passed = 0

    let events: [SkateEvent] = [
        .keyDown(keyCode: 125, character: 0),
        .keyUp(keyCode: 125, character: 0),
        .mouseDown(row: 0, column: 0),
        .mouseMove(row: 1, column: 1),
        .mouseUp(row: 1, column: 1),
    ]
    if events.count == 5 {
        print("skateevent_cases=yes")
        passed += 1
    } else {
        print("skateevent_cases=fail")
    }

    if events[0] == SkateEvent.keyDown(keyCode: 125, character: 0),
       events[0] != events[1] {
        print("skateevent_equatable=yes")
        passed += 1
    } else {
        print("skateevent_equatable=fail")
    }

    return passed
}

@available(macOS 26.0, *)
func testEventRing() -> Int {
    var passed = 0
    var ring = EventRing<SkateEvent>()

    let down = SkateEvent.keyDown(keyCode: 125, character: 0)
    let right = SkateEvent.keyDown(keyCode: 124, character: 0)

    do {
        try ring.append(down)
        try ring.append(right)
        print("eventring_append=yes")
        passed += 1
    } catch {
        print("eventring_append=fail")
        return passed
    }

    if ring.count == 2 {
        print("eventring_count=yes")
        passed += 1
    } else {
        print("eventring_count=fail")
    }

    let first = ring.removeFirst()
    let second = ring.removeFirst()
    if first == down, second == right, ring.isEmpty {
        print("eventring_drain=yes")
        passed += 1
    } else {
        print("eventring_drain=fail")
    }

    return passed
}

@available(macOS 26.0, *)
func testFrameGrid() -> Int {
    var passed = 0
    var grid = FrameGrid()

    let text: [UInt8] = Array("Hello SkateCore".utf8)
    do {
        try grid.writeRow(row: 0, text: text)
        print("framegrid_write=yes")
        passed += 1
    } catch {
        print("framegrid_write=fail")
        return passed
    }

    if grid.cell(row: 0, column: 0) == UInt8(ascii: "H"),
       grid.cell(row: 0, column: 4) == UInt8(ascii: "o") {
        print("framegrid_read=yes")
        passed += 1
    } else {
        print("framegrid_read=fail")
    }

    do {
        try grid.setPalette(slot: 1, color: SkateColor(red: 0, green: 255, blue: 0))
        try grid.paint(row: 0, columns: 0..<5, paletteSlot: 1)
        if grid.paletteIndex(row: 0, column: 0) == 1,
           grid.paletteIndex(row: 0, column: 5) == 0 {
            print("framegrid_paint=yes")
            passed += 1
        } else {
            print("framegrid_paint=fail")
        }
    } catch {
        print("framegrid_paint=fail")
    }

    return passed
}

@available(macOS 26.0, *)
func testConsentRail() -> Int {
    var passed = 0

    do {
        let rail = try ConsentRail(
            purpose: "test witness",
            recipientID: "quest2-harness",
            expiresAt: "2026-12-31",
            consentStatus: "pending"
        )

        let folded = rail.still(disclosure: .folded)
        if folded.lineCount == 2 {
            print("consentrail_folded=yes")
            passed += 1
        } else {
            print("consentrail_folded=fail")
        }

        let expanded = rail.still(disclosure: .expanded)
        if expanded.lineCount == 4 {
            print("consentrail_expanded=yes")
            passed += 1
        } else {
            print("consentrail_expanded=fail")
        }

        if let line = folded.accessibilityLine(row: 0) {
            let text = String(decoding: line, as: UTF8.self)
            if text.contains("pending") {
                print("consentrail_content=yes")
                passed += 1
            } else {
                print("consentrail_content=fail")
            }
        } else {
            print("consentrail_content=fail")
        }
    } catch {
        print("consentrail_init=fail")
    }

    return passed
}

@available(macOS 26.0, *)
func testIntegrationFlow() -> Int {
    var passed = 0
    var ring = EventRing<SkateEvent>()

    let sequence: [SkateEvent] = [
        .keyDown(keyCode: 125, character: 0),
        .keyDown(keyCode: 124, character: 0),
        .keyDown(keyCode: 124, character: 0),
        .keyDown(keyCode: 36, character: 0x0D),
    ]

    do {
        for event in sequence {
            try ring.append(event)
        }
        print("integration_append=yes")
        passed += 1
    } catch {
        print("integration_append=fail")
        return passed
    }

    if ring.count == 4 {
        print("integration_count=yes")
        passed += 1
    } else {
        print("integration_count=fail")
    }

    var drained: [SkateEvent] = []
    while let event = ring.removeFirst() {
        drained.append(event)
    }
    if drained == sequence, ring.isEmpty {
        print("integration_order=yes")
        passed += 1
    } else {
        print("integration_order=fail")
    }

    return passed
}

@available(macOS 26.0, *)
func testCursorMovement() -> Int {
    var passed = 0
    var grid = FrameGrid()
    var cursorRow = 0
    var cursorCol = 0

    try! grid.writeRow(row: 0, text: Array("Cursor test".utf8))

    var ring = EventRing<SkateEvent>()
    try! ring.append(.keyDown(keyCode: 124, character: 0))
    try! ring.append(.keyDown(keyCode: 124, character: 0))
    try! ring.append(.keyDown(keyCode: 125, character: 0))

    while let event = ring.removeFirst() {
        switch event {
        case .keyDown(let keyCode, _):
            switch keyCode {
            case 126: cursorRow = max(0, cursorRow - 1)
            case 125: cursorRow = min(SkateCoreBounds.rows - 1, cursorRow + 1)
            case 123: cursorCol = max(0, cursorCol - 1)
            case 124: cursorCol = min(SkateCoreBounds.columns - 1, cursorCol + 1)
            default: break
            }
        default: break
        }
    }

    if cursorRow == 1, cursorCol == 2 {
        print("cursor_position=yes")
        passed += 1
    } else {
        print("cursor_position=fail row=\(cursorRow) col=\(cursorCol)")
    }

    do {
        try grid.setPalette(slot: 2, color: SkateColor(red: 255, green: 255, blue: 255))
        try grid.paint(row: cursorRow, columns: cursorCol..<(cursorCol + 1), paletteSlot: 2)
        if grid.paletteIndex(row: cursorRow, column: cursorCol) == 2 {
            print("cursor_paint=yes")
            passed += 1
        } else {
            print("cursor_paint=fail")
        }
    } catch {
        print("cursor_paint=fail")
    }

    return passed
}

if #available(macOS 26.0, *) {
    print("quest2_harness: begin")

    var total = 0
    total += testSkateEventTypes()
    total += testEventRing()
    total += testFrameGrid()
    total += testConsentRail()
    total += testIntegrationFlow()
    total += testCursorMovement()

    print("proofs_passed=\(total)")
    let expected = 16
    print("proofs_expected=\(expected)")

    if total == expected {
        print("verdict=ok")
    } else {
        print("verdict=fail proofs_missing=\(expected - total)")
    }
} else {
    print("macos_version=too_old")
    print("verdict=fail")
}
