// FrameGridView -- bounded 40x8 cell rendering for Terrarium.
//
// A custom NSView that draws a FrameGrid character grid with cursor
// support and a ConsentRail overlay.  Uses SkateCore types exclusively
// for its data model.

import AppKit
import SkateCore

@available(macOS 26.0, *)
class FrameGridView: NSView {
    private var grid = FrameGrid()
    private(set) var eventRing = EventRing<SkateEvent>()
    private var cursorRow: Int = 0
    private var cursorCol: Int = 0
    private var activeConsent: ConsentRail?
    private var consentCallback: ((Bool) -> Void)?
    private let cellFont: NSFont
    private let cellWidth: CGFloat
    private let cellHeight: CGFloat
    private let defaultFG = NSColor(
        red: 0.0, green: 0.9, blue: 0.4, alpha: 1.0
    )
    private let defaultBG = NSColor.black

    override var isFlipped: Bool { true }

    init() {
        let font = NSFont.monospacedSystemFont(
            ofSize: 14, weight: .regular
        )
        cellFont = font
        let sample = NSAttributedString(
            string: "M",
            attributes: [.font: font]
        )
        let size = sample.size()
        cellWidth = ceil(size.width)
        cellHeight = ceil(size.height)

        let totalW = cellWidth
            * CGFloat(SkateCoreBounds.columns)
        let totalH = cellHeight
            * CGFloat(SkateCoreBounds.rows)
        super.init(
            frame: NSRect(
                x: 0, y: 0,
                width: totalW, height: totalH
            )
        )
        wantsLayer = true
        layer?.backgroundColor = defaultBG.cgColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    var idealSize: NSSize {
        NSSize(
            width: cellWidth
                * CGFloat(SkateCoreBounds.columns),
            height: cellHeight
                * CGFloat(SkateCoreBounds.rows)
        )
    }

    func update(grid newGrid: FrameGrid) {
        grid = newGrid
        needsDisplay = true
    }

    func showConsent(
        rail: ConsentRail,
        callback: @escaping (Bool) -> Void
    ) {
        activeConsent = rail
        consentCallback = callback
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?
            .cgContext
        else { return }

        ctx.setFillColor(defaultBG.cgColor)
        ctx.fill(bounds)

        for row in 0..<SkateCoreBounds.rows {
            for col in 0..<SkateCoreBounds.columns {
                let x = CGFloat(col) * cellWidth
                let y = CGFloat(row) * cellHeight

                let palIdx = grid.paletteIndex(
                    row: row, column: col
                ) ?? 0
                let bgColor: NSColor
                if palIdx != 0,
                   let c = grid.color(at: palIdx)
                {
                    bgColor = NSColor(
                        red: CGFloat(c.red) / 255.0,
                        green: CGFloat(c.green) / 255.0,
                        blue: CGFloat(c.blue) / 255.0,
                        alpha: 1.0
                    )
                    let cellRect = NSRect(
                        x: x, y: y,
                        width: cellWidth,
                        height: cellHeight
                    )
                    ctx.setFillColor(bgColor.cgColor)
                    ctx.fill(cellRect)
                }

                let byte = grid.cell(
                    row: row, column: col
                ) ?? 0x20
                guard byte != 0x20 else { continue }
                let scalar = Unicode.Scalar(byte)
                let ch = String(Character(scalar))

                let fg: NSColor
                if palIdx != 0,
                   let c = grid.color(at: palIdx)
                {
                    let lum = 0.299
                        * Double(c.red) / 255.0
                        + 0.587
                        * Double(c.green) / 255.0
                        + 0.114
                        * Double(c.blue) / 255.0
                    fg = lum > 0.5
                        ? NSColor.black
                        : NSColor.white
                } else {
                    fg = defaultFG
                }

                let isCursor =
                    row == cursorRow && col == cursorCol
                let drawFG: NSColor
                if isCursor {
                    let cursorBG = fg
                    let cellRect = NSRect(
                        x: x, y: y,
                        width: cellWidth,
                        height: cellHeight
                    )
                    ctx.setFillColor(cursorBG.cgColor)
                    ctx.fill(cellRect)
                    drawFG = defaultBG
                } else {
                    drawFG = fg
                }

                let attrs: [NSAttributedString.Key: Any]
                    = [
                        .font: cellFont,
                        .foregroundColor: drawFG,
                    ]
                let str = NSAttributedString(
                    string: ch, attributes: attrs
                )
                str.draw(at: NSPoint(x: x, y: y))
            }
        }

        // draw cursor on empty cells
        let cx = CGFloat(cursorCol) * cellWidth
        let cy = CGFloat(cursorRow) * cellHeight
        let cursorByte = grid.cell(
            row: cursorRow, column: cursorCol
        ) ?? 0x20
        if cursorByte == 0x20 {
            let cursorRect = NSRect(
                x: cx, y: cy,
                width: cellWidth,
                height: cellHeight
            )
            ctx.setFillColor(defaultFG.cgColor)
            ctx.fill(cursorRect)
        }

        drawConsentOverlay(ctx)
    }

    private func drawConsentOverlay(
        _ ctx: CGContext
    ) {
        guard let rail = activeConsent else { return }

        let overlayRows = 3
        let startRow =
            SkateCoreBounds.rows - overlayRows
        let overlayBG = NSColor(
            red: 0.1, green: 0.1,
            blue: 0.3, alpha: 1.0
        )
        let consentFG = NSColor(
            red: 1.0, green: 1.0,
            blue: 0.6, alpha: 1.0
        )
        let promptFG = NSColor(
            red: 0.7, green: 0.7,
            blue: 0.7, alpha: 1.0
        )

        let bgRect = NSRect(
            x: 0,
            y: CGFloat(startRow) * cellHeight,
            width: cellWidth
                * CGFloat(SkateCoreBounds.columns),
            height: cellHeight * CGFloat(overlayRows)
        )
        ctx.setFillColor(overlayBG.cgColor)
        ctx.fill(bgRect)

        let frame = rail.still(disclosure: .folded)
        for lineIdx in 0..<frame.lineCount {
            guard let bytes =
                frame.accessibilityLine(row: lineIdx)
            else { continue }
            let row = startRow + lineIdx
            let cols = min(
                bytes.count,
                SkateCoreBounds.columns
            )
            for col in 0..<cols {
                let byte = bytes[col]
                guard byte != 0x20 else { continue }
                let scalar = Unicode.Scalar(byte)
                let ch = String(Character(scalar))
                let x = CGFloat(col) * cellWidth
                let y = CGFloat(row) * cellHeight
                let attrs:
                    [NSAttributedString.Key: Any] = [
                        .font: cellFont,
                        .foregroundColor: consentFG,
                    ]
                let str = NSAttributedString(
                    string: ch, attributes: attrs
                )
                str.draw(at: NSPoint(x: x, y: y))
            }
        }

        let prompt =
            "[Enter] accept  [Esc] decline"
        let promptRow = startRow + overlayRows - 1
        for (col, byte) in
            prompt.utf8.prefix(
                SkateCoreBounds.columns
            ).enumerated()
        {
            let scalar = Unicode.Scalar(byte)
            let ch = String(Character(scalar))
            let x = CGFloat(col) * cellWidth
            let y = CGFloat(promptRow) * cellHeight
            let attrs:
                [NSAttributedString.Key: Any] = [
                    .font: cellFont,
                    .foregroundColor: promptFG,
                ]
            let str = NSAttributedString(
                string: ch, attributes: attrs
            )
            str.draw(at: NSPoint(x: x, y: y))
        }
    }

    // -- cursor and event processing --

    private func processEvents() {
        var changed = false
        while let ev = eventRing.removeFirst() {
            if activeConsent != nil {
                switch ev {
                case .keyDown(let keyCode, _):
                    if keyCode == 36 {
                        resolveConsent(accepted: true)
                        changed = true
                    } else if keyCode == 53 {
                        resolveConsent(accepted: false)
                        changed = true
                    }
                default:
                    break
                }
                continue
            }
            switch ev {
            case .keyDown(let keyCode, let ch):
                switch keyCode {
                case 126: // up
                    if cursorRow > 0 {
                        cursorRow -= 1
                        changed = true
                    }
                case 125: // down
                    if cursorRow
                        < SkateCoreBounds.rows - 1
                    {
                        cursorRow += 1
                        changed = true
                    }
                case 123: // left
                    if cursorCol > 0 {
                        cursorCol -= 1
                        changed = true
                    }
                case 124: // right
                    if cursorCol
                        < SkateCoreBounds.columns - 1
                    {
                        cursorCol += 1
                        changed = true
                    }
                default:
                    if ch == 0x63 {
                        showTestConsent()
                        changed = true
                    }
                }
            default:
                break
            }
        }
        if changed {
            needsDisplay = true
        }
    }

    private func resolveConsent(accepted: Bool) {
        let cb = consentCallback
        activeConsent = nil
        consentCallback = nil
        needsDisplay = true
        cb?(accepted)
    }

    private func showTestConsent() {
        guard activeConsent == nil else { return }
        guard let rail = try? ConsentRail(
            purpose: "read terminal output",
            recipientID: "terrarium-host",
            expiresAt: "2026-12-31",
            consentStatus: "pending"
        ) else { return }
        showConsent(rail: rail) { _ in }
    }

    // -- keyboard adapter --

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        let code = event.keyCode
        let ch: UInt8
        if let chars = event.characters,
           let first = chars.first,
           first.asciiValue != nil
        {
            ch = first.asciiValue!
        } else {
            ch = 0
        }
        let skateEvent = SkateEvent.keyDown(
            keyCode: code, character: ch
        )
        do {
            try eventRing.append(skateEvent)
        } catch {
            // ring full -- drop the event
        }
        processEvents()
    }

    override func keyUp(with event: NSEvent) {
        let code = event.keyCode
        let ch: UInt8
        if let chars = event.characters,
           let first = chars.first,
           first.asciiValue != nil
        {
            ch = first.asciiValue!
        } else {
            ch = 0
        }
        let skateEvent = SkateEvent.keyUp(
            keyCode: code, character: ch
        )
        do {
            try eventRing.append(skateEvent)
        } catch {
            // ring full -- drop the event
        }
    }
}
