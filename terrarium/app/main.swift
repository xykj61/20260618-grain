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

    @objc func focusDimeroll() {
        guard let tv = tabView else { return }
        for i in 0..<tv.numberOfTabViewItems {
            let item = tv.tabViewItem(at: i)
            if let ident = item.identifier as? String,
               ident == "dimeroll"
            {
                tv.selectTabViewItem(at: i)
                if let dtv = dimerollTextView {
                    window.makeFirstResponder(dtv)
                }
                return
            }
        }
        let item = NSTabViewItem(
            identifier: "dimeroll"
        )
        item.label = "Dimeroll"
        let container = NSView(
            frame: NSRect(
                x: 0, y: 0, width: 600,
                height: 400
            )
        )
        container.autoresizingMask =
            [.width, .height]

        let popUp = NSPopUpButton(
            frame: NSRect(
                x: 8, y: 0, width: 250,
                height: 28
            ),
            pullsDown: false
        )
        popUp.autoresizingMask = [.minYMargin]
        for (label, _) in dimerollModules {
            popUp.addItem(withTitle: label)
        }
        popUp.target = self
        popUp.action =
            #selector(dimerollModuleChanged(_:))
        dimerollModulePopUp = popUp

        let runBtn = NSButton(
            frame: NSRect(
                x: 266, y: 0, width: 60,
                height: 28
            )
        )
        runBtn.autoresizingMask = [.minYMargin]
        runBtn.title = "Run"
        runBtn.bezelStyle = .rounded
        runBtn.target = self
        runBtn.action =
            #selector(dimerollRunClicked(_:))

        let toggle = NSSegmentedControl(
            labels: ["Table", "Raw"],
            trackingMode: .selectOne,
            target: self,
            action: #selector(
                dimerollViewToggled(_:)
            )
        )
        toggle.selectedSegment = 0
        dimerollViewToggle = toggle

        let queryLabel = NSTextField(
            labelWithString: "Query:"
        )
        queryLabel.font =
            NSFont.systemFont(ofSize: 12)
        queryLabel.textColor = .secondaryLabelColor

        let queryPopUp = NSPopUpButton(
            frame: .zero, pullsDown: false
        )
        for (label, _, _) in dimerollQueryTypes {
            queryPopUp.addItem(withTitle: label)
        }
        queryPopUp.target = self
        queryPopUp.action = #selector(
            dimerollQueryTypeChanged(_:)
        )
        dimerollQueryTypePopUp = queryPopUp

        let queryParam = NSTextField(
            frame: .zero
        )
        queryParam.placeholderString =
            dimerollQueryTypes[0].2
        queryParam.font =
            NSFont.monospacedSystemFont(
                ofSize: 12, weight: .regular
            )
        queryParam.isEditable = false
        queryParam.isBezeled = true
        queryParam.bezelStyle = .roundedBezel
        dimerollQueryParamField = queryParam

        let queryRunBtn = NSButton(
            frame: .zero
        )
        queryRunBtn.title = "Run Query"
        queryRunBtn.bezelStyle = .rounded
        queryRunBtn.target = self
        queryRunBtn.action = #selector(
            dimerollQueryRunClicked(_:)
        )

        let sv = NSScrollView(
            frame: NSRect(
                x: 0, y: 0, width: 600,
                height: 368
            )
        )
        sv.autoresizingMask = [.width, .height]
        sv.hasVerticalScroller = true
        sv.wantsLayer = true
        let dtv = NSTextView(frame: sv.bounds)
        dtv.isEditable = false
        dtv.isSelectable = true
        dtv.autoresizingMask = [.width, .height]
        dtv.font = NSFont.monospacedSystemFont(
            ofSize: 14, weight: .regular
        )
        dtv.backgroundColor = NSColor(
            white: 0.05, alpha: 1.0
        )
        dtv.textColor = NSColor(
            red: 0.9, green: 0.8, blue: 0.3,
            alpha: 1.0
        )
        dtv.string = "Dimeroll -- Field Ledger\n"
            + "========================\n\n"
        sv.documentView = dtv
        dimerollTextView = dtv
        sv.isHidden = true

        let tableSV = NSScrollView(
            frame: NSRect(
                x: 0, y: 0, width: 600,
                height: 368
            )
        )
        tableSV.autoresizingMask =
            [.width, .height]
        tableSV.hasVerticalScroller = true
        tableSV.wantsLayer = true
        let tbl = NSTableView()
        tbl.style = .plain
        tbl.backgroundColor = NSColor(
            white: 0.05, alpha: 1.0
        )
        tbl.gridStyleMask = []
        tbl.headerView = NSTableHeaderView()
        tbl.rowHeight = 22
        let cols: [(String, String, CGFloat)] = [
            ("#", "num", 40),
            ("Verb", "verb", 80),
            ("Subject", "subject", 100),
            ("Quantity", "qty", 80),
            ("Price", "price", 80),
            ("Unit", "unit", 70),
        ]
        for (title, ident, width) in cols {
            let col = NSTableColumn(
                identifier: NSUserInterfaceItemIdentifier(
                    ident
                )
            )
            col.title = title
            col.width = width
            col.minWidth = 40
            tbl.addTableColumn(col)
        }
        tbl.dataSource = self
        tbl.delegate = self
        tableSV.documentView = tbl
        dimerollTableView = tbl
        dimerollTableScrollView = tableSV

        container.addSubview(sv)
        container.addSubview(tableSV)
        container.addSubview(popUp)
        container.addSubview(runBtn)
        container.addSubview(toggle)
        container.addSubview(queryLabel)
        container.addSubview(queryPopUp)
        container.addSubview(queryParam)
        container.addSubview(queryRunBtn)

        popUp.translatesAutoresizingMaskIntoConstraints
            = false
        runBtn
            .translatesAutoresizingMaskIntoConstraints
            = false
        toggle
            .translatesAutoresizingMaskIntoConstraints
            = false
        queryLabel
            .translatesAutoresizingMaskIntoConstraints
            = false
        queryPopUp
            .translatesAutoresizingMaskIntoConstraints
            = false
        queryParam
            .translatesAutoresizingMaskIntoConstraints
            = false
        queryRunBtn
            .translatesAutoresizingMaskIntoConstraints
            = false
        sv.translatesAutoresizingMaskIntoConstraints
            = false
        tableSV
            .translatesAutoresizingMaskIntoConstraints
            = false
        NSLayoutConstraint.activate([
            popUp.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: 4
            ),
            popUp.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 8
            ),
            popUp.widthAnchor.constraint(
                equalToConstant: 250
            ),
            popUp.heightAnchor.constraint(
                equalToConstant: 28
            ),
            runBtn.centerYAnchor.constraint(
                equalTo: popUp.centerYAnchor
            ),
            runBtn.leadingAnchor.constraint(
                equalTo: popUp.trailingAnchor,
                constant: 8
            ),
            runBtn.widthAnchor.constraint(
                equalToConstant: 60
            ),
            runBtn.heightAnchor.constraint(
                equalToConstant: 28
            ),
            toggle.centerYAnchor.constraint(
                equalTo: popUp.centerYAnchor
            ),
            toggle.leadingAnchor.constraint(
                equalTo: runBtn.trailingAnchor,
                constant: 12
            ),
            queryLabel.topAnchor.constraint(
                equalTo: popUp.bottomAnchor,
                constant: 6
            ),
            queryLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 8
            ),
            queryPopUp.centerYAnchor.constraint(
                equalTo: queryLabel.centerYAnchor
            ),
            queryPopUp.leadingAnchor.constraint(
                equalTo: queryLabel.trailingAnchor,
                constant: 4
            ),
            queryPopUp.widthAnchor.constraint(
                equalToConstant: 120
            ),
            queryPopUp.heightAnchor.constraint(
                equalToConstant: 26
            ),
            queryParam.centerYAnchor.constraint(
                equalTo: queryLabel.centerYAnchor
            ),
            queryParam.leadingAnchor.constraint(
                equalTo: queryPopUp.trailingAnchor,
                constant: 6
            ),
            queryParam.widthAnchor.constraint(
                equalToConstant: 140
            ),
            queryParam.heightAnchor.constraint(
                equalToConstant: 24
            ),
            queryRunBtn.centerYAnchor.constraint(
                equalTo: queryLabel.centerYAnchor
            ),
            queryRunBtn.leadingAnchor.constraint(
                equalTo: queryParam.trailingAnchor,
                constant: 6
            ),
            queryRunBtn.heightAnchor.constraint(
                equalToConstant: 26
            ),
            sv.topAnchor.constraint(
                equalTo: queryLabel.bottomAnchor,
                constant: 6
            ),
            sv.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),
            sv.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            ),
            sv.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            ),
            tableSV.topAnchor.constraint(
                equalTo: queryLabel.bottomAnchor,
                constant: 6
            ),
            tableSV.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),
            tableSV.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            ),
            tableSV.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            ),
        ])

        item.view = container
        tv.addTabViewItem(item)
        tv.selectTabViewItem(item)
        window.makeFirstResponder(dtv)
        dimerollActiveElf = "dimeroll_dashboard"
        rebuildDimerollColumns()
        launchDimerollDashboard()
    }

    @objc func focusMantra() {
        guard let tv = tabView else { return }
        for i in 0..<tv.numberOfTabViewItems {
            let item = tv.tabViewItem(at: i)
            if let ident = item.identifier as? String,
               ident == "mantra"
            {
                tv.selectTabViewItem(at: i)
                return
            }
        }
        let item = NSTabViewItem(
            identifier: "mantra"
        )
        item.label = "Mantra"

        let container = NSView()
        container.wantsLayer = true
        container.layer?.backgroundColor =
            NSColor(
                red: 0.06, green: 0.04, blue: 0.08,
                alpha: 1.0
            ).cgColor

        let label = NSTextField(labelWithString:
            "Mantra -- coming in Act III"
        )
        label.font = NSFont.systemFont(
            ofSize: 18, weight: .medium
        )
        label.textColor = NSColor(
            red: 0.7, green: 0.5, blue: 0.9,
            alpha: 1.0
        )
        label.alignment = .center
        label.translatesAutoresizingMaskIntoConstraints
            = false
        container.addSubview(label)

        let sub = NSTextField(labelWithString:
            "Signed, sealed, and witnessed"
        )
        sub.font = NSFont.systemFont(
            ofSize: 13, weight: .regular
        )
        sub.textColor = NSColor(
            red: 0.5, green: 0.4, blue: 0.6,
            alpha: 0.8
        )
        sub.alignment = .center
        sub.translatesAutoresizingMaskIntoConstraints
            = false
        container.addSubview(sub)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(
                equalTo: container.centerXAnchor
            ),
            label.centerYAnchor.constraint(
                equalTo: container.centerYAnchor,
                constant: -12
            ),
            sub.centerXAnchor.constraint(
                equalTo: container.centerXAnchor
            ),
            sub.topAnchor.constraint(
                equalTo: label.bottomAnchor,
                constant: 8
            ),
        ])

        item.view = container
        tv.addTabViewItem(item)
        tv.selectTabViewItem(item)
    }

    func loadBloomLessons() {
        bloomLessons = []
        let gc = bloom_galaxy_count()
        for gi: UInt32 in 0..<gc {
            let sepTitle = String(
                cString: bloom_galaxy_separator_title(gi)
            )
            if !sepTitle.isEmpty {
                let sepBody = String(
                    cString:
                        bloom_galaxy_separator_body(gi)
                )
                bloomLessons.append(
                    (sepTitle, sepBody)
                )
            }
            let dir = String(
                cString: bloom_galaxy_directory(gi)
            )
            let fc = bloom_galaxy_file_count(gi)
            for fi: UInt32 in 0..<fc {
                let file = String(
                    cString:
                        bloom_galaxy_file_name(gi, fi)
                )
                let path = "\(repoRoot)/bloom"
                    + "/\(dir)/\(file)"
                if let text = try? String(
                    contentsOfFile: path,
                    encoding: .utf8
                ) {
                    let lines = text.components(
                        separatedBy: "\n"
                    )
                    let title = lines.first?
                        .replacingOccurrences(
                            of: "# ", with: ""
                        ) ?? file
                    bloomLessons.append(
                        (title, text)
                    )
                }
            }
        }
        if bloomLessons.isEmpty {
            bloomLessons.append((
                "No lessons found",
                "Could not load curriculum from "
                    + "\(repoRoot)/bloom"
            ))
        }
    }

    func showBloomLesson(_ index: Int) {
        guard index >= 0,
              index < bloomLessons.count
        else { return }
        let (title, content) = bloomLessons[index]
        bloomTitleLabel?.stringValue =
            "\(title)  (\(index + 1)"
            + " of \(bloomLessons.count))"
        bloomTextView?.string = content
        bloomTextView?
            .scrollToBeginningOfDocument(nil)
    }

    @objc func bloomPrev() {
        if bloomLessonIndex > 0 {
            bloomLessonIndex -= 1
            showBloomLesson(bloomLessonIndex)
        }
    }

    @objc func bloomNext() {
        if bloomLessonIndex < bloomLessons.count - 1
        {
            bloomLessonIndex += 1
            showBloomLesson(bloomLessonIndex)
        }
    }

    @objc func focusBloom() {
        guard let tv = tabView else { return }
        for i in 0..<tv.numberOfTabViewItems {
            let item = tv.tabViewItem(at: i)
            if let ident = item.identifier
                as? String,
               ident == "bloom"
            {
                tv.selectTabViewItem(at: i)
                return
            }
        }

        if bloomLessons.isEmpty {
            loadBloomLessons()
        }

        let item = NSTabViewItem(
            identifier: "bloom"
        )
        item.label = "Bloom"

        let container = NSView()
        container.wantsLayer = true
        container.layer?.backgroundColor =
            NSColor(
                red: 0.04, green: 0.06,
                blue: 0.04, alpha: 1.0
            ).cgColor

        let navBar = NSView()
        navBar.wantsLayer = true
        navBar.layer?.backgroundColor =
            NSColor(
                red: 0.08, green: 0.12,
                blue: 0.08, alpha: 1.0
            ).cgColor
        navBar.translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(navBar)

        let prevBtn = NSButton(
            title: "Previous",
            target: self,
            action: #selector(bloomPrev)
        )
        prevBtn.bezelStyle = .inline
        prevBtn.contentTintColor = NSColor(
            red: 0.5, green: 0.8,
            blue: 0.5, alpha: 1.0
        )
        prevBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        navBar.addSubview(prevBtn)

        let titleLbl = NSTextField(
            labelWithString:
                bloomLessons.isEmpty
                ? "Bloom"
                : bloomLessons[0].0
        )
        titleLbl.font = NSFont.systemFont(
            ofSize: 15, weight: .medium
        )
        titleLbl.textColor = NSColor(
            red: 0.6, green: 0.9,
            blue: 0.6, alpha: 1.0
        )
        titleLbl.alignment = .center
        titleLbl
            .translatesAutoresizingMaskIntoConstraints =
            false
        navBar.addSubview(titleLbl)
        bloomTitleLabel = titleLbl

        let nextBtn = NSButton(
            title: "Next",
            target: self,
            action: #selector(bloomNext)
        )
        nextBtn.bezelStyle = .inline
        nextBtn.contentTintColor = NSColor(
            red: 0.5, green: 0.8,
            blue: 0.5, alpha: 1.0
        )
        nextBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        navBar.addSubview(nextBtn)

        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView
            .translatesAutoresizingMaskIntoConstraints =
            false
        scrollView.drawsBackground = false
        container.addSubview(scrollView)

        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = NSColor(
            red: 0.04, green: 0.06,
            blue: 0.04, alpha: 1.0
        )
        textView.textColor = NSColor(
            red: 0.85, green: 0.9,
            blue: 0.85, alpha: 1.0
        )
        textView.font =
            NSFont.monospacedSystemFont(
                ofSize: 13, weight: .regular
            )
        textView.textContainerInset =
            NSSize(width: 20, height: 16)
        textView.autoresizingMask = [.width]
        if let tc = textView.textContainer {
            tc.widthTracksTextView = true
        }
        scrollView.documentView = textView
        bloomTextView = textView

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(
                equalTo: container.topAnchor
            ),
            navBar.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),
            navBar.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            ),
            navBar.heightAnchor.constraint(
                equalToConstant: 40
            ),
            prevBtn.leadingAnchor.constraint(
                equalTo: navBar.leadingAnchor,
                constant: 12
            ),
            prevBtn.centerYAnchor.constraint(
                equalTo: navBar.centerYAnchor
            ),
            titleLbl.centerXAnchor.constraint(
                equalTo: navBar.centerXAnchor
            ),
            titleLbl.centerYAnchor.constraint(
                equalTo: navBar.centerYAnchor
            ),
            nextBtn.trailingAnchor.constraint(
                equalTo: navBar.trailingAnchor,
                constant: -12
            ),
            nextBtn.centerYAnchor.constraint(
                equalTo: navBar.centerYAnchor
            ),
            scrollView.topAnchor.constraint(
                equalTo: navBar.bottomAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            ),
        ])

        bloomLessonIndex = 0
        showBloomLesson(0)

        item.view = container
        tv.addTabViewItem(item)
        tv.selectTabViewItem(item)
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
        } else if isWireStage || isMantraWireStage
            || isContentWireStage
        {
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

        if isWireStage || isMantraWireStage
            || isContentWireStage
        {
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
                        if isContentWireStage,
                           let buf =
                               self?.serialBuffer,
                           buf.range(
                               of: "CREQ:[^\n]+\n",
                               options:
                                   .regularExpression
                           ) != nil
                        {
                            self?.handleContentWire()
                        }
                    }
                }
            }

        proc.terminationHandler = { [weak self] p in
            DispatchQueue.main.async {
                self?.updateStatusBar()
                self?.appendLine(
                    "--- qemu exited "
                    + "(\(p.terminationStatus))"
                )
                if !isInteractive {
                    self?.dumpAndExit(
                        status: p.terminationStatus
                    )
                }
            }
        }

        do {
            try proc.run()
            qemuProcess = proc
            updateStatusBar()
            appendLine(
                "qemu launched "
                + "(pid \(proc.processIdentifier))"
            )

            if !isInteractive {
                let timeout: Double =
                    stage == "realidream" ? 210
                    : isFramebufStage ? 20
                    : isMantraWireStage ? 30
                    : isContentWireStage ? 30
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
