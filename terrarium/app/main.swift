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
//         rye/bin/rye build-lib vantage/bloom.rye -dynamic \
//           -femit-bin=vantage/lib/libbloom.dylib
//         rye/bin/rye build-lib vantage/dimeroll.rye -dynamic \
//           -femit-bin=vantage/lib/libdimeroll.dylib
//         swiftc -I terrarium/.build -I vantage/include \
//           -L terrarium/.build -L vantage/lib \
//           -lSkateCore -lbloom -ldimeroll \
//           -o terrarium/.build/Terrarium terrarium/app/*.swift \
//           -framework AppKit
// Run:    DYLD_LIBRARY_PATH=terrarium/.build:vantage/lib \
//           terrarium/.build/Terrarium [stage]
//         (defaults to "hello")

import AppKit
import Darwin
import Foundation
import SkateCore
import VantageBloom
import VantageDimeroll

// -- Configuration --------------------------------------------------

let isInteractive = CommandLine.arguments.count <= 1

let stage: String = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "hello"

let isFramebufStage = stage == "framebuf"
    || stage == "aurora_console"
let isWireStage = stage == "wire"
let isMantraWireStage = stage == "mantra_wire"
    || stage == "mantra_wire64"
let isContentWireStage = stage == "content_wire"
    || stage == "realidream"
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

class AppDelegate: NSObject,
    NSApplicationDelegate, NSTabViewDelegate {
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
    var contentReqCount = 0
    var frameGridView: FrameGridView?
    var serialLines: [String] = []
    var scrollView: NSScrollView?
    var gridContainer: NSView?
    var tabView: NSTabView?
    var sidebarSplitView: NSSplitView?
    var sidebarScrollView: NSScrollView?
    var sidebarTableView: NSTableView?
    var sidebarVisible = true
    let sidebarModules = [
        "Terminal", "Grid",
        "Dimeroll", "Mantra",
        "Bloom",
    ]
    var bloomTextView: NSTextView?
    var bloomLessonIndex: Int = 0
    var bloomTitleLabel: NSTextField?
    var bloomLessons: [(String, String)] = []
    var dimerollTextView: NSTextView?
    var dimerollProcess: Process?
    var dimerollModulePopUp: NSPopUpButton?
    var dimerollTableView: NSTableView?
    var dimerollTableScrollView: NSScrollView?
    var dimerollViewToggle: NSSegmentedControl?
    var dimerollTransactions: [(
        Int, String, String, String, String, String
    )] = []
    var dimerollInventory: [(String, String)] = []
    var dimerollCashflow: [(String, String)] = []
    var dimerollLedger: [(
        String, String, String,
        String, String, String
    )] = []
    var dimerollPrice: [(
        String, String, String
    )] = []
    var dimerollSeal: [(String, String)] = []
    var dimerollQueryResults: [(
        String, String, String,
        String, String
    )] = []
    var dimerollDashInv: [(String, String)] = []
    var dimerollDashCF: [(String, String)] = []
    var dimerollDashSeal: [(String, String)] = []
    var dimerollDashPhase: Int = 0
    var dimerollRawBuffer: String = ""
    var dimerollActiveElf: String = ""
    var dimerollInLedgerTable: Bool = false
    var dimerollQueryTypePopUp: NSPopUpButton?
    var dimerollQueryParamField: NSTextField?
    var dimerollQueryTypes: [(
        String, String, String
    )] {
        (0..<dimeroll_query_type_count()).map { i in
            (
                String(cString: dimeroll_query_type_label(i)),
                String(cString: dimeroll_query_type_elf(i)),
                String(cString: dimeroll_query_type_placeholder(i))
            )
        }
    }
    var dimerollModules: [(String, String)] {
        (0..<dimeroll_module_count()).map { i in
            (
                String(cString: dimeroll_module_label(i)),
                String(cString: dimeroll_module_elf(i))
            )
        }
    }
    var nextTabId = 3
    var shortcutStatusLabel: NSTextField?
    var connectionLabel: NSTextField?
    var moduleLabel: NSTextField?
    var infoLabel: NSTextField?

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

        // -- Tab bar (Movement 11) ---------------------

        let tv = NSTabView(frame: splitFrame)
        tv.tabViewType = .topTabsBezelBorder
        tv.autoresizingMask = [.width, .height]
        tabView = tv
        tv.delegate = self

        // Tab 1: Terminal
        let termTab = NSTabViewItem(
            identifier: "terminal"
        )
        termTab.label = "Terminal"

        let sv = NSScrollView(
            frame: NSRect(
                x: 0, y: 0,
                width: splitFrame.width,
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
        termTab.view = sv
        tv.addTabViewItem(termTab)

        // Tab 2: Grid
        let gridTab = NSTabViewItem(
            identifier: "grid"
        )
        gridTab.label = "Grid"

        if #available(macOS 26.0, *) {
            let fgv = FrameGridView()
            frameGridView = fgv

            let gc = NSView(
                frame: NSRect(
                    x: 0, y: 0,
                    width: splitFrame.width,
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

            gridTab.view = gc
        } else {
            let placeholder = NSView(
                frame: NSRect(
                    x: 0, y: 0,
                    width: splitFrame.width,
                    height: splitFrame.height
                )
            )
            placeholder.wantsLayer = true
            placeholder.layer?.backgroundColor =
                NSColor.black.cgColor
            gridTab.view = placeholder
        }
        tv.addTabViewItem(gridTab)

        // -- Sidebar (Movement 12) --------------------

        let sidebarW: CGFloat = 180

        let split = NSSplitView(frame: splitFrame)
        split.isVertical = true
        split.dividerStyle = .thin
        split.autoresizingMask = [.width, .height]
        sidebarSplitView = split

        let sidebarFrame = NSRect(
            x: 0, y: 0,
            width: sidebarW,
            height: splitFrame.height
        )
        let ssc = NSScrollView(frame: sidebarFrame)
        ssc.hasVerticalScroller = true
        ssc.autoresizingMask = [.width, .height]
        sidebarScrollView = ssc

        let col = NSTableColumn(
            identifier: NSUserInterfaceItemIdentifier(
                "module"
            )
        )
        col.title = "Modules"
        col.width = sidebarW - 20

        let table = NSTableView()
        table.addTableColumn(col)
        table.headerView = nil
        table.rowHeight = 28
        table.backgroundColor = NSColor(
            white: 0.15, alpha: 1.0
        )
        table.style = .plain
        table.dataSource = self
        table.delegate = self
        sidebarTableView = table
        ssc.documentView = table

        split.addSubview(ssc)
        split.addSubview(tv)
        split.setPosition(
            sidebarW, ofDividerAt: 0
        )
        split.setHoldingPriority(
            .defaultHigh, forSubviewAt: 0
        )

        // -- Status bar (Movement 14) ---------

        let statusH: CGFloat = 22
        let barW = splitFrame.width
        let statusContainer = NSView(
            frame: NSRect(
                x: 0, y: 0,
                width: barW, height: statusH
            )
        )
        statusContainer.wantsLayer = true
        statusContainer.layer?.backgroundColor =
            NSColor(white: 0.12, alpha: 1.0).cgColor
        statusContainer.autoresizingMask = [
            .width, .maxYMargin,
        ]

        let statusFont = NSFont.monospacedSystemFont(
            ofSize: 11, weight: .regular
        )
        let statusColor = NSColor.lightGray

        func makeStatusField(
            _ x: CGFloat, _ w: CGFloat,
            align: NSTextAlignment = .left
        ) -> NSTextField {
            let f = NSTextField(
                frame: NSRect(
                    x: x, y: 0,
                    width: w, height: statusH
                )
            )
            f.isEditable = false
            f.isBordered = false
            f.drawsBackground = false
            f.textColor = statusColor
            f.font = statusFont
            f.alignment = align
            return f
        }

        let connField = makeStatusField(
            0, 120
        )
        connField.autoresizingMask = [.maxXMargin]

        let modField = makeStatusField(
            120, barW - 240, align: .center
        )
        modField.autoresizingMask = [.width]

        let infoField = makeStatusField(
            barW - 120, 120, align: .right
        )
        infoField.autoresizingMask = [.minXMargin]

        statusContainer.addSubview(connField)
        statusContainer.addSubview(modField)
        statusContainer.addSubview(infoField)

        connectionLabel = connField
        moduleLabel = modField
        infoLabel = infoField
        shortcutStatusLabel = modField

        split.frame = NSRect(
            x: 0, y: statusH,
            width: splitFrame.width,
            height: splitFrame.height - statusH
        )

        window.contentView?.addSubview(split)
        window.contentView?.addSubview(statusContainer)

        window.makeKeyAndOrderFront(nil)

        setupMenu()
        updateFocusIndicator()
        updateStatusBar()

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

        viewMenu.addItem(NSMenuItem.separator())

        let sidebarItem = NSMenuItem(
            title: "Toggle Sidebar",
            action: #selector(toggleSidebar),
            keyEquivalent: "0"
        )
        sidebarItem.keyEquivalentModifierMask =
            [.command]
        viewMenu.addItem(sidebarItem)

        viewMenuItem.submenu = viewMenu
        mainMenu.addItem(viewMenuItem)

        // -- Shortcuts menu (Movement 13) ------

        let shortcutsMenuItem = NSMenuItem()
        let shortcutsMenu = NSMenu(
            title: "Shortcuts"
        )

        let newTabItem = NSMenuItem(
            title: "New Tab",
            action: #selector(newTab),
            keyEquivalent: "t"
        )
        newTabItem.keyEquivalentModifierMask =
            [.command]
        shortcutsMenu.addItem(newTabItem)

        let closeTabItem = NSMenuItem(
            title: "Close Tab",
            action: #selector(closeTab),
            keyEquivalent: "w"
        )
        closeTabItem.keyEquivalentModifierMask =
            [.command]
        shortcutsMenu.addItem(closeTabItem)

        let backTabItem = NSMenuItem(
            title: "Previous Tab",
            action: #selector(previousTab),
            keyEquivalent: "["
        )
        backTabItem.keyEquivalentModifierMask =
            [.command]
        shortcutsMenu.addItem(backTabItem)

        shortcutsMenuItem.submenu = shortcutsMenu
        mainMenu.addItem(shortcutsMenuItem)

        NSApp.mainMenu = mainMenu
    }

    @objc func focusTerminal() {
        tabView?.selectTabViewItem(at: 0)
        window.makeFirstResponder(textView)
    }

    @objc func focusGrid() {
        tabView?.selectTabViewItem(at: 1)
        if let fgv = frameGridView {
            window.makeFirstResponder(fgv)
        }
    }

    @objc func toggleSidebar() {
        guard let split = sidebarSplitView,
              let ssc = sidebarScrollView
        else { return }
        if sidebarVisible {
            ssc.isHidden = true
            split.setPosition(0, ofDividerAt: 0)
        } else {
            ssc.isHidden = false
            split.setPosition(
                180, ofDividerAt: 0
            )
        }
        sidebarVisible = !sidebarVisible
    }

    // -- Shortcut actions (Movement 13) ---

    @objc func newTab() {
        guard let tv = tabView else { return }
        let item = NSTabViewItem(
            identifier: "tab-\(nextTabId)"
        )
        item.label = "Tab \(nextTabId)"
        let placeholder = NSView()
        placeholder.wantsLayer = true
        placeholder.layer?.backgroundColor =
            NSColor(white: 0.1, alpha: 1.0).cgColor
        item.view = placeholder
        tv.addTabViewItem(item)
        tv.selectTabViewItem(item)
        nextTabId += 1
        showShortcutStatus("Cmd+T: New Tab")
    }

    @objc func closeTab() {
        guard let tv = tabView else { return }
        guard tv.numberOfTabViewItems > 2
        else {
            showShortcutStatus(
                "Cmd+W: cannot close built-in tab"
            )
            return
        }
        guard let sel = tv.selectedTabViewItem,
              let ident = sel.identifier as? String,
              ident != "terminal",
              ident != "grid",
              ident != "dimeroll",
              ident != "mantra",
              ident != "bloom"
        else {
            showShortcutStatus(
                "Cmd+W: cannot close built-in tab"
            )
            return
        }
        tv.removeTabViewItem(sel)
        showShortcutStatus("Cmd+W: Close Tab")
    }

    @objc func previousTab() {
        guard let tv = tabView else { return }
        let count = tv.numberOfTabViewItems
        guard count > 0 else { return }
        let cur = tv.indexOfTabViewItem(
            tv.selectedTabViewItem!
        )
        let prev = cur > 0 ? cur - 1 : count - 1
        tv.selectTabViewItem(at: prev)
        showShortcutStatus(
            "Cmd+[: Previous Tab"
        )
    }

    func showShortcutStatus(_ text: String) {
        moduleLabel?.stringValue = text
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2.0
        ) { [weak self] in
            self?.updateStatusBar()
        }
    }

    // -- Status bar state ----

    func updateStatusBar() {
        let alive =
            qemuProcess?.isRunning == true
        let dot = alive ? "🟢" : "🔴"
        let state = alive
            ? "connected" : "stopped"
        connectionLabel?.stringValue =
            " \(dot) \(state)"

        var modName = "Terminal"
        if let sel =
            tabView?.selectedTabViewItem,
            let ident =
                sel.identifier as? String
        {
            switch ident {
            case "terminal": modName = "Terminal"
            case "grid": modName = "FrameGrid"
            case "dimeroll": modName = "Dimeroll"
            default: modName = sel.label
            }
        }
        moduleLabel?.stringValue = modName

        infoLabel?.stringValue =
            "\(stage) "
    }

    func tabView(
        _ tabView: NSTabView,
        didSelect tabViewItem: NSTabViewItem?
    ) {
        updateStatusBar()
    }

    func updateFocusIndicator() {
        // tabs make the active view obvious
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
