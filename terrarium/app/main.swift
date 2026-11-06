// Terrarium -- a living world under glass.
//
// A macOS window that launches qemu-system-riscv32 or riscv64 as a
// dependent process and captures its serial output.  For framebuffer
// stages, the window also displays QEMU's framebuffer via QMP screendump.
//
// Build:  swiftc -parse-as-library -module-name SkateCore -emit-module \
//           -emit-module-path terrarium/.build/SkateCore.swiftmodule \
//           -emit-library -o terrarium/.build/libSkateCore.dylib \
//           -swift-version 6 skate/Sources/SkateCore/*.swift
//         swiftc -I terrarium/.build -L terrarium/.build -lSkateCore \
//           -o terrarium/.build/Terrarium terrarium/app/main.swift
// Run:    terrarium/.build/Terrarium [stage]
//         (defaults to "hello")

import AppKit
import Darwin
import Foundation
import SkateCore

// -- Configuration --------------------------------------------------

let stage: String = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "hello"

let isFramebufStage = stage == "framebuf"
    || stage == "aurora_console"
let isWireStage = stage == "wire"
let isMantraWireStage = stage == "mantra_wire"
    || stage == "mantra_wire64"
let is64Bit = stage.hasSuffix("64")
    || stage.hasSuffix("_g")
let isMultiHart = stage.hasPrefix("multi_hart")

let repoRoot: String = {
    let url = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()  // app/
        .deletingLastPathComponent()  // terrarium/
        .deletingLastPathComponent()  // repo root
    return url.path
}()

let elfPath = "\(repoRoot)/terrarium/.build/\(stage).elf"

// -- Application delegate -------------------------------------------

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var textView: NSTextView!
    var imageView: NSImageView?
    var qemuProcess: Process?
    var outputPipe: Pipe!
    var qmpSocketPath: String?
    var screendumpDone = false
    var serialBuffer = ""
    var inputPipe: Pipe?
    var wireAckSent = false
    var mantraVerifySent = false
    var frameGridView: FrameGridView?
    var serialLines: [String] = []
    var scrollView: NSScrollView?
    var gridContainer: NSView?

    func applicationDidFinishLaunching(_ note: Notification) {
        let mask: NSWindow.StyleMask = [
            .titled, .closable, .miniaturizable,
            .resizable,
        ]
        let winW: CGFloat = 1040
        var winH: CGFloat = 480

        if isFramebufStage {
            winH = 760
        }

        let frame = NSRect(
            x: 200, y: 100, width: winW, height: winH
        )
        window = NSWindow(
            contentRect: frame,
            styleMask: mask,
            backing: .buffered,
            defer: false
        )
        window.title = "Terrarium -- \(stage)"
        window.minSize = NSSize(width: 600, height: 300)

        let contentBounds = window.contentView!.bounds
        var splitFrame = contentBounds

        if isFramebufStage {
            let imgH: CGFloat = 480
            let imgFrame = NSRect(
                x: 0,
                y: contentBounds.height - imgH,
                width: contentBounds.width,
                height: imgH
            )
            let iv = NSImageView(frame: imgFrame)
            iv.imageScaling = .scaleProportionallyUpOrDown
            iv.wantsLayer = true
            iv.layer?.backgroundColor =
                NSColor.black.cgColor
            window.contentView?.addSubview(iv)
            imageView = iv

            splitFrame = NSRect(
                x: 0, y: 0,
                width: contentBounds.width,
                height: contentBounds.height - imgH
            )
        }

        let splitView = NSSplitView(frame: splitFrame)
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.autoresizingMask = [.width, .height]

        let sv = NSScrollView(
            frame: NSRect(
                x: 0, y: 0,
                width: splitFrame.width * 0.6,
                height: splitFrame.height
            )
        )
        sv.autoresizingMask = [.width, .height]
        sv.hasVerticalScroller = true
        sv.wantsLayer = true
        scrollView = sv

        textView = NSTextView(frame: sv.bounds)
        textView.isEditable = false
        textView.isSelectable = true
        textView.autoresizingMask = [.width, .height]
        textView.font = NSFont.monospacedSystemFont(
            ofSize: 14, weight: .regular
        )
        textView.backgroundColor = NSColor.black
        textView.textColor = NSColor(
            red: 0.0, green: 0.9, blue: 0.4, alpha: 1.0
        )
        sv.documentView = textView

        splitView.addSubview(sv)

        if #available(macOS 26.0, *) {
            let fgv = FrameGridView()
            frameGridView = fgv

            let gc = NSView(
                frame: NSRect(
                    x: 0, y: 0,
                    width: splitFrame.width * 0.4,
                    height: splitFrame.height
                )
            )
            gc.wantsLayer = true
            gc.layer?.backgroundColor =
                NSColor.black.cgColor
            gc.autoresizingMask =
                [.width, .height]
            gridContainer = gc

            let gridSize = fgv.idealSize
            fgv.frame = NSRect(
                x: 8,
                y: 8,
                width: gridSize.width,
                height: gridSize.height
            )
            fgv.autoresizingMask = [.minYMargin]
            gc.addSubview(fgv)

            splitView.addSubview(gc)
        } else {
            let placeholder = NSView(
                frame: NSRect(
                    x: 0, y: 0,
                    width: splitFrame.width * 0.4,
                    height: splitFrame.height
                )
            )
            placeholder.wantsLayer = true
            placeholder.layer?.backgroundColor =
                NSColor.black.cgColor
            splitView.addSubview(placeholder)
        }

        window.contentView?.addSubview(splitView)

        splitView.setPosition(
            splitFrame.width * 0.6,
            ofDividerAt: 0
        )

        window.makeKeyAndOrderFront(nil)

        setupMenu()
        updateFocusIndicator()

        appendLine("Terrarium -- a living world under glass")
        appendLine("stage: \(stage)")
        appendLine("elf:   \(elfPath)")
        appendLine("---")

        launchQemu()
    }

    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool { true }

    // -- scene switching (Movement 9) --------------------------------

    private func setupMenu() {
        let mainMenu = NSMenu()

        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu()
        let quitItem = NSMenuItem(
            title: "Quit Terrarium",
            action: #selector(
                NSApplication.terminate(_:)
            ),
            keyEquivalent: "q"
        )
        appMenu.addItem(quitItem)
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)

        let viewMenuItem = NSMenuItem()
        let viewMenu = NSMenu(title: "View")
        let termItem = NSMenuItem(
            title: "Focus Terminal",
            action: #selector(focusTerminal),
            keyEquivalent: "1"
        )
        termItem.keyEquivalentModifierMask = [.command]
        viewMenu.addItem(termItem)

        let gridItem = NSMenuItem(
            title: "Focus Grid",
            action: #selector(focusGrid),
            keyEquivalent: "2"
        )
        gridItem.keyEquivalentModifierMask = [.command]
        viewMenu.addItem(gridItem)

        viewMenuItem.submenu = viewMenu
        mainMenu.addItem(viewMenuItem)

        NSApp.mainMenu = mainMenu
    }

    @objc func focusTerminal() {
        window.makeFirstResponder(textView)
        updateFocusIndicator()
    }

    @objc func focusGrid() {
        if let fgv = frameGridView {
            window.makeFirstResponder(fgv)
        }
        updateFocusIndicator()
    }

    private static let focusBorderColor = NSColor(
        red: 0.3, green: 0.6, blue: 1.0, alpha: 0.8
    )

    func updateFocusIndicator() {
        let active = window.firstResponder

        let termFocused: Bool
        if active === textView
            || active is NSTextView
        {
            termFocused = true
        } else {
            termFocused = false
        }

        scrollView?.layer?.borderWidth =
            termFocused ? 2.0 : 0.0
        scrollView?.layer?.borderColor =
            Self.focusBorderColor.cgColor

        gridContainer?.layer?.borderWidth =
            termFocused ? 0.0 : 2.0
        gridContainer?.layer?.borderColor =
            Self.focusBorderColor.cgColor
    }

    // -- QEMU launch ------------------------------------------------

    func launchQemu() {
        guard FileManager.default.fileExists(
            atPath: elfPath
        ) else {
            appendLine("error: \(elfPath) not found")
            appendLine("run 'make terrarium-build' first")
            return
        }

        let proc = Process()
        proc.executableURL = URL(
            fileURLWithPath: findQemu()
        )

        if isFramebufStage {
            let sockPath = NSTemporaryDirectory()
                + "terrarium-qmp.sock"
            try? FileManager.default
                .removeItem(atPath: sockPath)
            qmpSocketPath = sockPath

            proc.arguments = [
                "-machine", "virt",
                "-bios", "none",
                "-display", "none",
                "-serial", "stdio",
                "-device", "ramfb",
                "-qmp",
                "unix:\(sockPath),server=on,wait=off",
                "-kernel", elfPath
            ]
        } else if isWireStage || isMantraWireStage {
            proc.arguments = [
                "-machine", "virt",
                "-bios", "none",
                "-display", "none",
                "-serial", "stdio",
                "-kernel", elfPath
            ]
        } else {
            var args = [
                "-machine", "virt",
                "-bios", "none",
                "-nographic",
                "-kernel", elfPath
            ]
            if isMultiHart { args += ["-smp", "2"] }
            proc.arguments = args
        }

        if isWireStage || isMantraWireStage {
            let inp = Pipe()
            proc.standardInput = inp
            inputPipe = inp
        }

        outputPipe = Pipe()
        proc.standardOutput = outputPipe
        proc.standardError = outputPipe

        outputPipe.fileHandleForReading
            .readabilityHandler = { [weak self] handle in
                let data = handle.availableData
                guard !data.isEmpty else { return }
                if let text = String(
                    data: data, encoding: .utf8
                ) {
                    DispatchQueue.main.async {
                        self?.appendText(text)
                        self?.serialBuffer += text
                        if isFramebufStage,
                           let buf = self?.serialBuffer,
                           buf.contains(
                               "FRAMEBUFFER READY"
                           )
                        {
                            self?.captureFramebuffer()
                        }
                        if isWireStage,
                           !(self?.wireAckSent
                               ?? true),
                           let buf =
                               self?.serialBuffer,
                           buf.range(
                               of: "WIRE:fact=.+\n",
                               options:
                                   .regularExpression
                           ) != nil
                        {
                            self?.handleWireFact()
                        }
                        if isMantraWireStage,
                           !(self?.mantraVerifySent
                               ?? true),
                           let buf =
                               self?.serialBuffer,
                           buf.range(
                               of: "MSTATE:[0-9a-f]{8}\n",
                               options: .regularExpression
                           ) != nil
                        {
                            self?.handleMantraWire()
                        }
                    }
                }
            }

        proc.terminationHandler = { [weak self] p in
            DispatchQueue.main.async {
                self?.appendLine(
                    "--- qemu exited "
                    + "(\(p.terminationStatus))"
                )
                self?.dumpAndExit(
                    status: p.terminationStatus
                )
            }
        }

        do {
            try proc.run()
            qemuProcess = proc
            appendLine(
                "qemu launched "
                + "(pid \(proc.processIdentifier))"
            )

            let timeout: Double =
                isFramebufStage ? 20
                : isMantraWireStage ? 30
                : 10
            DispatchQueue.global().asyncAfter(
                deadline: .now() + timeout
            ) { [weak self] in
                if proc.isRunning {
                    proc.terminate()
                    DispatchQueue.main.async {
                        self?.appendLine(
                            "--- \(Int(timeout))s timeout"
                        )
                    }
                }
            }
        } catch {
            appendLine("error launching qemu: \(error)")
        }
    }

    // -- Framebuffer capture via QMP screendump ---------------------

    func captureFramebuffer() {
        guard !screendumpDone else { return }
        screendumpDone = true

        appendLine(
            "--- capturing framebuffer via QMP..."
        )

        DispatchQueue.global().async { [weak self] in
            usleep(300_000)

            guard let sockPath = self?.qmpSocketPath
            else { return }

            let ppmPath = NSTemporaryDirectory()
                + "terrarium-fb.ppm"

            let ok = qmpScreendump(
                socketPath: sockPath,
                outputPath: ppmPath
            )

            if ok {
                usleep(500_000)
                if let image = parsePPM(path: ppmPath)
                {
                    DispatchQueue.main.async {
                        self?.imageView?.image = image
                        self?.appendLine(
                            "--- framebuffer displayed"
                        )
                        DispatchQueue.global()
                            .asyncAfter(
                                deadline: .now() + 2
                            ) {
                                self?.qemuProcess?
                                    .terminate()
                            }
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.appendLine(
                            "--- error: PPM parse "
                            + "failed"
                        )
                        self?.qemuProcess?.terminate()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.appendLine(
                        "--- error: QMP screendump "
                        + "failed"
                    )
                    self?.qemuProcess?.terminate()
                }
            }
        }
    }

    // -- Wire protocol ------------------------------------------------

    func handleWireFact() {
        guard !wireAckSent else { return }
        wireAckSent = true

        let lines = serialBuffer.components(
            separatedBy: "\n"
        )
        guard let factLine = lines.first(
            where: { $0.hasPrefix("WIRE:fact=") }
        ) else { return }

        let value = String(
            factLine.dropFirst("WIRE:fact=".count)
        )
        appendLine(
            "--- host received fact: \(value)"
        )

        let ack = "ACK:\(value)\n"
        if let data = ack.data(using: .utf8) {
            inputPipe?.fileHandleForWriting
                .write(data)
            appendLine(
                "--- host sent ACK: \(value)"
            )
        }
    }

    // -- Mantra wire protocol -----------------------------------------

    func handleMantraWire() {
        guard !mantraVerifySent else { return }
        mantraVerifySent = true

        let lines = serialBuffer.components(
            separatedBy: "\n"
        )

        guard let seedLine = lines.first(
            where: { $0.hasPrefix("MSEED:") }
        ) else {
            sendMantraVerify(ok: false)
            return
        }
        let seedHex = String(
            seedLine.dropFirst("MSEED:".count)
        )
        guard seedHex.count == 64,
              let seed = hexToBytes(seedHex),
              seed.count == 32
        else {
            sendMantraVerify(ok: false)
            return
        }

        let factLines = lines.filter {
            $0.hasPrefix("MFACT:")
        }
        guard !factLines.isEmpty else {
            sendMantraVerify(ok: false)
            return
        }

        guard let stateLine = lines.first(
            where: { $0.hasPrefix("MSTATE:") }
        ) else {
            sendMantraVerify(ok: false)
            return
        }
        let stateHex = String(
            stateLine.dropFirst("MSTATE:".count)
        )
        guard let guestState = UInt32(
            stateHex, radix: 16
        ) else {
            sendMantraVerify(ok: false)
            return
        }

        appendLine(
            "--- host: received \(factLines.count)"
            + " facts, replaying..."
        )

        var stateHash: UInt32 = 0
        for (i, line) in factLines.enumerated() {
            let body = String(
                line.dropFirst("MFACT:".count)
            )
            let parts = body.split(
                separator: ",", maxSplits: 4
            )
            guard parts.count == 5,
                  let seq = UInt32(
                      String(parts[0]), radix: 16
                  ),
                  let prevHash = UInt32(
                      String(parts[1]), radix: 16
                  ),
                  let payloadLen = UInt32(
                      String(parts[2]), radix: 16
                  ),
                  let tag = UInt32(
                      String(parts[3]), radix: 16
                  )
            else {
                appendLine(
                    "--- host: bad fact \(i)"
                )
                sendMantraVerify(ok: false)
                return
            }

            let payload = String(parts[4])

            guard prevHash == stateHash else {
                appendLine(
                    "--- host: chain break at \(i)"
                )
                sendMantraVerify(ok: false)
                return
            }

            var canon = [UInt8](
                repeating: 0, count: 76
            )
            writeU32BE(&canon, 0, seq)
            writeU32BE(&canon, 4, prevHash)
            writeU32BE(&canon, 8, payloadLen)
            let pBytes = Array(payload.utf8)
            for j in 0..<min(pBytes.count, 64) {
                canon[12 + j] = pBytes[j]
            }

            let expectedTag = keyedDjb2Sign(
                seed: seed, message: canon
            )
            guard tag == expectedTag else {
                appendLine(
                    "--- host: tag mismatch at "
                    + "\(i)"
                )
                sendMantraVerify(ok: false)
                return
            }

            var sh = Djb2Swift()
            sh.feedU32(stateHash)
            sh.feedU32(tag)
            sh.feed(canon)
            stateHash = sh.digest()

            appendLine(
                "--- host: fact \(i) verified,"
                + " state 0x"
                + String(stateHash, radix: 16)
            )
        }

        let ok = stateHash == guestState
        appendLine(
            "--- host replay state: 0x"
            + String(stateHash, radix: 16)
            + (ok ? " MATCH" : " MISMATCH")
        )
        sendMantraVerify(ok: ok)
    }

    func sendMantraVerify(ok: Bool) {
        let msg = ok
            ? "MVERIFY:ok\n"
            : "MVERIFY:fail\n"
        if let data = msg.data(using: .utf8) {
            inputPipe?.fileHandleForWriting
                .write(data)
            appendLine(
                "--- host sent: "
                + msg.trimmingCharacters(
                    in: .newlines
                )
            )
        }
    }

    // -- Helpers -----------------------------------------------------

    func appendLine(_ text: String) {
        appendText(text + "\n")
    }

    func appendText(_ text: String) {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(
                ofSize: 14, weight: .regular
            ),
            .foregroundColor: NSColor(
                red: 0.0, green: 0.9,
                blue: 0.4, alpha: 1.0
            )
        ]
        let attrStr = NSAttributedString(
            string: text, attributes: attrs
        )
        textView.textStorage?.append(attrStr)
        textView.scrollToEndOfDocument(nil)
        updateGrid()
    }

    func updateGrid() {
        guard #available(macOS 26.0, *),
              let fgv = frameGridView
        else { return }

        let allLines = serialBuffer.components(
            separatedBy: "\n"
        )
        let filtered = allLines.filter { !$0.isEmpty }
        let rows = SkateCoreBounds.rows
        let start = max(0, filtered.count - rows)
        let visible = Array(
            filtered[start..<filtered.count]
        )

        var grid = FrameGrid()
        try? grid.setPalette(
            slot: 1,
            color: SkateColor(
                red: 0, green: 230, blue: 102
            )
        )

        for (i, line) in visible.enumerated() {
            let bytes = Array(line.utf8.prefix(
                SkateCoreBounds.columns
            ))
            try? grid.writeRow(row: i, text: bytes)
            try? grid.paint(
                row: i,
                columns: 0..<min(
                    bytes.count,
                    SkateCoreBounds.columns
                ),
                paletteSlot: 1
            )
        }

        fgv.update(grid: grid)
    }

    func dumpAndExit(status: Int32) {
        if let text = textView.textStorage?.string {
            fputs(text, stdout)
        }
        NSApplication.shared.terminate(nil)
    }

    func findQemu() -> String {
        let arch = is64Bit ? "riscv64" : "riscv32"
        let candidates = [
            "/opt/homebrew/bin/qemu-system-\(arch)",
            "/usr/local/bin/qemu-system-\(arch)",
            "/usr/bin/qemu-system-\(arch)"
        ]
        for c in candidates {
            if FileManager.default
                .isExecutableFile(atPath: c)
            {
                return c
            }
        }
        return "qemu-system-\(arch)"
    }
}

// -- FrameGridView -- bounded 40x8 cell rendering --------------------

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

    // -- cursor and event processing (Movement 7) ----------------------

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

    // -- keyboard adapter (Movement 6) --------------------------------

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

// -- QMP over Unix socket -------------------------------------------

func qmpScreendump(
    socketPath: String,
    outputPath: String
) -> Bool {
    let fd = socket(AF_UNIX, SOCK_STREAM, 0)
    guard fd >= 0 else { return false }
    defer { Darwin.close(fd) }

    var addr = sockaddr_un()
    addr.sun_family = sa_family_t(AF_UNIX)
    withUnsafeMutablePointer(
        to: &addr.sun_path.0
    ) { dst in
        socketPath.withCString { src in
            _ = strcpy(dst, src)
        }
    }

    let connectOK = withUnsafePointer(to: &addr) {
        $0.withMemoryRebound(
            to: sockaddr.self, capacity: 1
        ) {
            connect(
                fd, $0,
                socklen_t(
                    MemoryLayout<sockaddr_un>.size
                )
            )
        }
    }
    guard connectOK == 0 else { return false }

    _ = qmpRecv(fd)

    let cap =
        "{\"execute\":\"qmp_capabilities\"}\n"
    qmpSend(fd, cap)
    _ = qmpRecv(fd)

    let cmd = "{\"execute\":\"screendump\","
        + "\"arguments\":{\"filename\":\""
        + outputPath + "\"}}\n"
    qmpSend(fd, cmd)
    let resp = qmpRecv(fd)

    return resp.contains("return")
}

func qmpSend(_ fd: Int32, _ msg: String) {
    let bytes = Array(msg.utf8)
    _ = Darwin.write(fd, bytes, bytes.count)
}

func qmpRecv(_ fd: Int32) -> String {
    var pfd = pollfd(
        fd: fd, events: Int16(POLLIN), revents: 0
    )
    let ready = poll(&pfd, 1, 3000)
    guard ready > 0 else { return "" }

    var buf = [UInt8](repeating: 0, count: 4096)
    let n = Darwin.read(fd, &buf, buf.count - 1)
    guard n > 0 else { return "" }
    return String(
        bytes: buf[0..<n], encoding: .utf8
    ) ?? ""
}

// -- PPM parsing ----------------------------------------------------

func parsePPM(path: String) -> NSImage? {
    guard let data = try? Data(
        contentsOf: URL(fileURLWithPath: path)
    ) else {
        return nil
    }

    guard data.count > 10,
          data[0] == 0x50, data[1] == 0x36
    else { return nil }

    var off = 2

    func skipWS() {
        while off < data.count {
            let c = data[off]
            if c == 0x23 {
                while off < data.count,
                      data[off] != 0x0a
                {
                    off += 1
                }
            } else if c == 0x20 || c == 0x09
                        || c == 0x0a || c == 0x0d
            {
                off += 1
            } else {
                break
            }
        }
    }

    func readInt() -> Int {
        skipWS()
        var val = 0
        while off < data.count {
            let c = data[off]
            if c >= 0x30, c <= 0x39 {
                val = val * 10 + Int(c - 0x30)
                off += 1
            } else {
                break
            }
        }
        return val
    }

    let width = readInt()
    let height = readInt()
    _ = readInt()
    guard width > 0, height > 0 else { return nil }

    off += 1

    let pixels = width * height
    guard data.count >= off + pixels * 3 else {
        return nil
    }

    var rgba = [UInt8](
        repeating: 255, count: pixels * 4
    )
    for i in 0..<pixels {
        let s = off + i * 3
        rgba[i * 4 + 0] = data[s + 0]
        rgba[i * 4 + 1] = data[s + 1]
        rgba[i * 4 + 2] = data[s + 2]
        rgba[i * 4 + 3] = 255
    }

    guard let provider = CGDataProvider(
        data: Data(rgba) as CFData
    ) else { return nil }

    guard let cgImg = CGImage(
        width: width,
        height: height,
        bitsPerComponent: 8,
        bitsPerPixel: 32,
        bytesPerRow: width * 4,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGBitmapInfo(
            rawValue: CGImageAlphaInfo
                .premultipliedLast.rawValue
        ),
        provider: provider,
        decode: nil,
        shouldInterpolate: false,
        intent: .defaultIntent
    ) else { return nil }

    return NSImage(
        cgImage: cgImg,
        size: NSSize(width: width, height: height)
    )
}

// -- djb2 and Mantra helpers -----------------------------------------

struct Djb2Swift {
    var h: UInt32 = 5381

    mutating func feed(_ data: [UInt8]) {
        for byte in data {
            h = ((h &<< 5) &+ h) &+ UInt32(byte)
        }
    }

    mutating func feedU32(_ val: UInt32) {
        feed([
            UInt8((val >> 24) & 0xFF),
            UInt8((val >> 16) & 0xFF),
            UInt8((val >> 8) & 0xFF),
            UInt8(val & 0xFF),
        ])
    }

    func digest() -> UInt32 { h }
}

func keyedDjb2Sign(
    seed: [UInt8], message: [UInt8]
) -> UInt32 {
    var d = Djb2Swift()
    d.feed(seed)
    d.feed(message)
    return d.digest()
}

func hexToBytes(_ hex: String) -> [UInt8]? {
    let chars = Array(hex)
    guard chars.count % 2 == 0 else { return nil }
    var bytes = [UInt8]()
    var i = 0
    while i < chars.count {
        guard let hi = UInt8(
            String(chars[i]), radix: 16
        ),
        let lo = UInt8(
            String(chars[i + 1]), radix: 16
        ) else { return nil }
        bytes.append(hi << 4 | lo)
        i += 2
    }
    return bytes
}

func writeU32BE(
    _ buf: inout [UInt8], _ off: Int,
    _ val: UInt32
) {
    buf[off] = UInt8((val >> 24) & 0xFF)
    buf[off + 1] = UInt8((val >> 16) & 0xFF)
    buf[off + 2] = UInt8((val >> 8) & 0xFF)
    buf[off + 3] = UInt8(val & 0xFF)
}

// -- Main -----------------------------------------------------------

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.activate()
app.run()
