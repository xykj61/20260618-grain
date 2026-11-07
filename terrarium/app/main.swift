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
    ]
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
    var dimerollRawBuffer: String = ""
    var dimerollActiveElf: String = ""
    var dimerollInLedgerTable: Bool = false
    var dimerollQueryTypePopUp: NSPopUpButton?
    var dimerollQueryParamField: NSTextField?
    let dimerollQueryTypes: [(
        String, String, String
    )] = [
        ("By Verb", "dimeroll_query_verb_g",
         "sell"),
        ("By Subject",
         "dimeroll_query_subject_g",
         "tomatoes"),
        ("By Date", "dimeroll_query_date_g",
         "2026-01-01"),
        ("By Account",
         "dimeroll_query_account_g",
         "farm-main"),
    ]
    let dimerollModules: [(String, String)] = [
        ("Transactions", "dimeroll_tx_g"),
        ("Inventory", "dimeroll_inventory_g"),
        ("Cash Flow", "dimeroll_cashflow_g"),
        ("Ledger", "dimeroll_ledger_g"),
        ("Seal", "dimeroll_seal_g"),
        ("Price", "dimeroll_price_g"),
        ("Query by Verb", "dimeroll_query_verb_g"),
        ("Query by Subject",
         "dimeroll_query_subject_g"),
        ("Query by Date",
         "dimeroll_query_date_g"),
        ("Query by Account",
         "dimeroll_query_account_g"),
    ]
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
        launchDimerollStage("dimeroll_tx_g")
    }

    func launchDimerollStage(_ name: String) {
        if let p = dimerollProcess,
           p.isRunning
        {
            p.terminate()
            p.waitUntilExit()
        }
        guard let dtv = dimerollTextView
        else { return }

        let elf = "\(repoRoot)/terrarium/.build/"
            + "\(name).elf"
        guard FileManager.default.fileExists(
            atPath: elf
        ) else {
            DispatchQueue.main.async {
                dtv.string += "error: \(elf) not found\n"
            }
            return
        }

        let arch = "riscv64"
        let candidates = [
            "/opt/homebrew/bin/qemu-system-\(arch)",
            "/usr/local/bin/qemu-system-\(arch)",
            "/usr/bin/qemu-system-\(arch)",
        ]
        var qemuBin = "qemu-system-\(arch)"
        for c in candidates {
            if FileManager.default
                .isExecutableFile(atPath: c)
            {
                qemuBin = c
                break
            }
        }

        let proc = Process()
        proc.executableURL = URL(
            fileURLWithPath: qemuBin
        )
        proc.arguments = [
            "-machine", "virt",
            "-bios", "none",
            "-nographic",
            "-kernel", elf,
        ]

        let pipe = Pipe()
        proc.standardOutput = pipe
        proc.standardError = pipe

        pipe.fileHandleForReading
            .readabilityHandler = {
                [weak self] handle in
                let data = handle.availableData
                guard !data.isEmpty else { return }
                if let text = String(
                    data: data, encoding: .utf8
                ) {
                    DispatchQueue.main.async {
                        self?.appendDimeroll(text)
                    }
                }
            }

        proc.terminationHandler = {
            [weak self] p in
            DispatchQueue.main.async {
                self?.appendDimeroll(
                    "\n--- dimeroll exited "
                    + "(\(p.terminationStatus))\n"
                )
            }
        }

        do {
            try proc.run()
            dimerollProcess = proc
            DispatchQueue.main.async {
                dtv.string += "launched \(name) "
                    + "(pid \(proc.processIdentifier))"
                    + "\n\n"
            }
        } catch {
            DispatchQueue.main.async {
                dtv.string += "error: \(error)\n"
            }
        }
    }

    func appendDimeroll(_ text: String) {
        guard let dtv = dimerollTextView
        else { return }
        dtv.textStorage?.append(
            NSAttributedString(
                string: text,
                attributes: [
                    .font: NSFont
                        .monospacedSystemFont(
                            ofSize: 14,
                            weight: .regular
                        ),
                    .foregroundColor: NSColor(
                        red: 0.9, green: 0.8,
                        blue: 0.3, alpha: 1.0
                    ),
                ]
            )
        )
        dtv.scrollToEndOfDocument(nil)
        parseDimerollTransactions(text)
    }

    func parseDimerollTransactions(
        _ text: String
    ) {
        dimerollRawBuffer += text
        while let range = dimerollRawBuffer.range(
            of: "\n"
        ) {
            let lineEnd = range.lowerBound
            let line = String(
                dimerollRawBuffer[
                    dimerollRawBuffer.startIndex..<lineEnd
                ]
            )
            dimerollRawBuffer = String(
                dimerollRawBuffer[range.upperBound...]
            )
            if dimerollActiveElf
                == "dimeroll_inventory_g"
            {
                parseDimerollInventoryLine(line)
            } else if dimerollActiveElf
                == "dimeroll_cashflow_g"
            {
                parseDimerollCashflowLine(line)
            } else if dimerollActiveElf
                == "dimeroll_ledger_g"
            {
                parseDimerollLedgerLine(line)
            } else if dimerollActiveElf
                == "dimeroll_price_g"
            {
                parseDimerollPriceLine(line)
            } else if dimerollActiveElf
                == "dimeroll_seal_g"
            {
                parseDimerollSealLine(line)
            } else if dimerollActiveElf
                .hasPrefix("dimeroll_query_")
            {
                parseDimerollQueryLine(line)
            } else {
                parseDimerollLine(line)
            }
        }
    }

    func parseDimerollLine(_ line: String) {
        let trimmed = line.trimmingCharacters(
            in: .whitespaces
        )
        guard trimmed.hasPrefix("["),
              let close = trimmed.firstIndex(of: "]"),
              let open = trimmed.firstIndex(of: "("),
              let end = trimmed.lastIndex(of: ")")
        else { return }
        let numStart = trimmed.index(
            after: trimmed.startIndex
        )
        let numStr = String(
            trimmed[numStart..<close]
        ).trimmingCharacters(in: .whitespaces)
        guard let num = Int(numStr) else { return }
        let inner = String(
            trimmed[
                trimmed.index(after: open)..<end
            ]
        )
        let parts = inner.split(
            separator: " ",
            omittingEmptySubsequences: true
        ).map(String.init)
        guard parts.count >= 3 else { return }
        let verb = parts[0]
        let subject = parts[1]
        let qty = parts[2]
        var unit = "-"
        var price = "-"
        if parts.count >= 4 {
            let fourth = parts[3]
            if Int(fourth) != nil {
                price = fourth
            } else {
                unit = fourth
            }
        }
        if parts.count >= 5 {
            price = parts[4]
        }
        dimerollTransactions.append(
            (num, verb, subject, qty, price, unit)
        )
        dimerollTableView?.reloadData()
    }

    func parseDimerollInventoryLine(
        _ line: String
    ) {
        let trimmed = line.trimmingCharacters(
            in: .whitespaces
        )
        if trimmed.hasPrefix(
            "--- DIMEROLL FIELD LEDGER ---"
        ) {
            dimerollInLedgerTable = true
            return
        }
        if trimmed.hasPrefix("-- SLC GATE --") {
            dimerollInLedgerTable = false
            return
        }
        guard dimerollInLedgerTable else { return }
        guard trimmed.hasPrefix("|") else { return }
        let cells = trimmed.split(
            separator: "|",
            omittingEmptySubsequences: true
        ).map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        guard cells.count >= 2 else { return }
        let subj = cells[0]
        let qty = cells[1]
        if subj == "Subject" || subj.hasPrefix("-") {
            return
        }
        dimerollInventory.append((subj, qty))
        dimerollTableView?.reloadData()
    }

    func parseDimerollCashflowLine(
        _ line: String
    ) {
        let trimmed = line.trimmingCharacters(
            in: .whitespaces
        )
        if trimmed.hasPrefix(
            "--- DIMEROLL FIELD LEDGER ---"
        ) {
            dimerollInLedgerTable = true
            return
        }
        if trimmed.hasPrefix("-- SLC GATE --") {
            dimerollInLedgerTable = false
            return
        }
        guard dimerollInLedgerTable else { return }
        guard trimmed.hasPrefix("|") else { return }
        let cells = trimmed.split(
            separator: "|",
            omittingEmptySubsequences: true
        ).map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        guard cells.count >= 2 else { return }
        let subj = cells[0]
        let rev = cells[1]
        if subj == "Subject" || subj.hasPrefix("-") {
            return
        }
        dimerollCashflow.append((subj, rev))
        dimerollTableView?.reloadData()
    }

    func parseDimerollLedgerLine(
        _ line: String
    ) {
        let trimmed = line.trimmingCharacters(
            in: .whitespaces
        )
        if trimmed.hasPrefix(
            "--- DIMEROLL FIELD LEDGER ---"
        ) {
            dimerollInLedgerTable = true
            return
        }
        if trimmed.hasPrefix("-- SLC GATE --") {
            dimerollInLedgerTable = false
            return
        }
        guard dimerollInLedgerTable else { return }
        let cells = trimmed.split(
            separator: "|",
            omittingEmptySubsequences: true
        ).map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        guard cells.count >= 6 else { return }
        guard let _ = Int(cells[0]) else { return }
        dimerollLedger.append((
            cells[0], cells[1], cells[2],
            cells[3], cells[4], cells[5]
        ))
        dimerollTableView?.reloadData()
    }

    func parseDimerollPriceLine(
        _ line: String
    ) {
        let trimmed = line.trimmingCharacters(
            in: .whitespaces
        )
        if trimmed.contains(" x "),
           trimmed.contains(" = ")
        {
            let verb: String
            if trimmed.hasPrefix("sell") {
                verb = "sell"
            } else if trimmed.hasPrefix("buy") {
                verb = "buy"
            } else {
                return
            }
            let afterVerb = trimmed.dropFirst(
                verb.count
            ).trimmingCharacters(
                in: .whitespaces
            )
            let calc = afterVerb
            dimerollPrice.append((
                verb, calc, ""
            ))
            dimerollTableView?.reloadData()
            return
        }
        if trimmed.contains("PROOF PASS") {
            let parts = trimmed.split(
                separator: ":",
                maxSplits: 1
            )
            guard parts.count == 2 else { return }
            let item = String(parts[0]).trimmingCharacters(
                in: .whitespaces
            )
            let cents = String(parts[1]).trimmingCharacters(
                in: .whitespaces
            ).replacingOccurrences(
                of: " PROOF PASS", with: ""
            )
            if let lastIdx = dimerollPrice.lastIndex(
                where: { $0.0 == "sell" || $0.0 == "buy" }
            ), dimerollPrice[lastIdx].2.isEmpty {
                dimerollPrice[lastIdx].2 = cents
            } else {
                dimerollPrice.append((
                    item, "PROOF", cents
                ))
            }
            dimerollTableView?.reloadData()
            return
        }
        if trimmed.contains(":") {
            let parts = trimmed.split(
                separator: ":",
                maxSplits: 1
            )
            guard parts.count == 2 else { return }
            let label = String(parts[0]).trimmingCharacters(
                in: .whitespaces
            )
            let amount = String(parts[1]).trimmingCharacters(
                in: .whitespaces
            )
            if !label.isEmpty, !amount.isEmpty,
               label != "proofs"
            {
                dimerollPrice.append((
                    label, amount, ""
                ))
                dimerollTableView?.reloadData()
            }
        }
    }

    func parseDimerollSealLine(
        _ line: String
    ) {
        let trimmed = line.trimmingCharacters(
            in: .whitespaces
        )
        if trimmed.hasPrefix(
            "--- DIMEROLL FIELD LEDGER ---"
        ) {
            dimerollInLedgerTable = true
            return
        }
        if trimmed.hasPrefix("-- SLC GATE --") {
            dimerollInLedgerTable = false
            return
        }
        guard dimerollInLedgerTable else { return }
        if trimmed.contains(":") {
            let parts = trimmed.split(
                separator: ":",
                maxSplits: 1
            )
            guard parts.count == 2 else { return }
            let field = String(parts[0]).trimmingCharacters(
                in: .whitespaces
            )
            let value = String(parts[1]).trimmingCharacters(
                in: .whitespaces
            )
            if !field.isEmpty {
                dimerollSeal.append((field, value))
                dimerollTableView?.reloadData()
            }
        } else if !trimmed.isEmpty {
            dimerollSeal.append((trimmed, ""))
            dimerollTableView?.reloadData()
        }
    }

    func parseDimerollQueryLine(
        _ line: String
    ) {
        let trimmed = line.trimmingCharacters(
            in: .whitespaces
        )
        guard trimmed.contains("|") else { return }
        let cells = trimmed.split(
            separator: "|",
            omittingEmptySubsequences: true
        ).map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        guard cells.count >= 5 else { return }
        if cells[0] == "#"
            || cells[0].hasPrefix("-")
        {
            return
        }
        guard let _ = Int(cells[0]) else { return }
        dimerollQueryResults.append((
            cells[0], cells[1], cells[2],
            cells[3], cells[4]
        ))
        dimerollTableView?.reloadData()
    }

    @objc func dimerollModuleChanged(
        _ sender: NSPopUpButton
    ) {
        let idx = sender.indexOfSelectedItem
        guard idx >= 0,
              idx < dimerollModules.count
        else { return }
        let (label, elfName) = dimerollModules[idx]
        guard let dtv = dimerollTextView
        else { return }
        dtv.string = "Dimeroll -- \(label)\n"
            + String(
                repeating: "=",
                count: 12 + label.count
            )
            + "\n\n"
        dimerollTransactions.removeAll()
        dimerollInventory.removeAll()
        dimerollCashflow.removeAll()
        dimerollLedger.removeAll()
        dimerollPrice.removeAll()
        dimerollSeal.removeAll()
        dimerollQueryResults.removeAll()
        dimerollRawBuffer = ""
        dimerollInLedgerTable = false
        dimerollActiveElf = elfName
        rebuildDimerollColumns()
        dimerollTableView?.reloadData()
        launchDimerollStage(elfName)
    }

    func rebuildDimerollColumns() {
        guard let tbl = dimerollTableView
        else { return }
        while tbl.tableColumns.count > 0 {
            tbl.removeTableColumn(
                tbl.tableColumns[0]
            )
        }
        let cols: [(String, String, CGFloat)]
        if dimerollActiveElf
            == "dimeroll_inventory_g"
        {
            cols = [
                ("Subject", "subject", 160),
                ("On Hand", "qty", 100),
            ]
        } else if dimerollActiveElf
            == "dimeroll_cashflow_g"
        {
            cols = [
                ("Subject", "subject", 160),
                ("Revenue", "revenue", 100),
            ]
        } else if dimerollActiveElf
            == "dimeroll_ledger_g"
        {
            cols = [
                ("#", "num", 40),
                ("Verb", "verb", 80),
                ("Subject", "subject", 100),
                ("Qty", "qty", 70),
                ("Price", "price", 70),
                ("Total", "total", 80),
            ]
        } else if dimerollActiveElf
            == "dimeroll_price_g"
        {
            cols = [
                ("Item", "item", 80),
                ("Calculation", "calc", 200),
                ("Cents", "cents", 80),
            ]
        } else if dimerollActiveElf
            == "dimeroll_seal_g"
        {
            cols = [
                ("Field", "field", 120),
                ("Value", "value", 200),
            ]
        } else if dimerollActiveElf
            == "dimeroll_query_verb_g"
        {
            cols = [
                ("#", "num", 40),
                ("Subject", "col1", 100),
                ("Qty", "col2", 70),
                ("Unit", "col3", 70),
                ("Price", "col4", 80),
            ]
        } else if dimerollActiveElf
            == "dimeroll_query_subject_g"
        {
            cols = [
                ("#", "num", 40),
                ("Verb", "col1", 80),
                ("Qty", "col2", 70),
                ("Unit", "col3", 70),
                ("Price", "col4", 80),
            ]
        } else if dimerollActiveElf
            == "dimeroll_query_date_g"
        {
            cols = [
                ("#", "num", 40),
                ("Day", "col1", 100),
                ("Verb", "col2", 80),
                ("Subject", "col3", 100),
                ("Qty", "col4", 70),
            ]
        } else if dimerollActiveElf
            == "dimeroll_query_account_g"
        {
            cols = [
                ("#", "num", 40),
                ("Verb", "col1", 80),
                ("Qty", "col2", 70),
                ("Unit", "col3", 70),
                ("Price", "col4", 80),
            ]
        } else {
            cols = [
                ("#", "num", 40),
                ("Verb", "verb", 80),
                ("Subject", "subject", 100),
                ("Quantity", "qty", 80),
                ("Price", "price", 80),
                ("Unit", "unit", 70),
            ]
        }
        for (title, ident, width) in cols {
            let col = NSTableColumn(
                identifier:
                    NSUserInterfaceItemIdentifier(
                        ident
                    )
            )
            col.title = title
            col.width = width
            col.minWidth = 40
            tbl.addTableColumn(col)
        }
    }

    @objc func dimerollRunClicked(
        _ sender: NSButton
    ) {
        guard let popUp = dimerollModulePopUp
        else { return }
        dimerollModuleChanged(popUp)
    }

    @objc func dimerollQueryTypeChanged(
        _ sender: NSPopUpButton
    ) {
        let idx = sender.indexOfSelectedItem
        if idx >= 0,
           idx < dimerollQueryTypes.count
        {
            dimerollQueryParamField?
                .placeholderString =
                dimerollQueryTypes[idx].2
        }
    }

    @objc func dimerollQueryRunClicked(
        _ sender: NSButton
    ) {
        guard let qp = dimerollQueryTypePopUp
        else { return }
        let idx = qp.indexOfSelectedItem
        guard idx >= 0,
              idx < dimerollQueryTypes.count
        else { return }
        let (label, elfName, _) =
            dimerollQueryTypes[idx]
        guard let dtv = dimerollTextView
        else { return }
        dtv.string = "Dimeroll -- Query \(label)\n"
            + String(
                repeating: "=",
                count: 18 + label.count
            )
            + "\n\n"
        dimerollTransactions.removeAll()
        dimerollInventory.removeAll()
        dimerollCashflow.removeAll()
        dimerollLedger.removeAll()
        dimerollPrice.removeAll()
        dimerollSeal.removeAll()
        dimerollQueryResults.removeAll()
        dimerollRawBuffer = ""
        dimerollInLedgerTable = false
        dimerollActiveElf = elfName
        rebuildDimerollColumns()
        dimerollTableView?.reloadData()
        if let mp = dimerollModulePopUp {
            let moduleIdx =
                dimerollModules.firstIndex {
                    $0.1 == elfName
                }
            if let mi = moduleIdx {
                mp.selectItem(at: mi)
            }
        }
        launchDimerollStage(elfName)
    }

    @objc func dimerollViewToggled(
        _ sender: NSSegmentedControl
    ) {
        let showTable = sender.selectedSegment == 0
        dimerollTableScrollView?.isHidden =
            !showTable
        if let sv = dimerollTextView?
            .enclosingScrollView
        {
            sv.isHidden = showTable
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
              ident != "dimeroll"
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

    // -- Status bar state (Movement 14) ----

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
            "M16 \(stage) "
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
                self?.updateStatusBar()
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
            updateStatusBar()
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

// -- Sidebar data source (Movement 12) --------------------------------

extension AppDelegate: NSTableViewDataSource {
    func numberOfRows(
        in tableView: NSTableView
    ) -> Int {
        if tableView === dimerollTableView {
            if dimerollActiveElf
                == "dimeroll_inventory_g"
            {
                return dimerollInventory.count
            }
            if dimerollActiveElf
                == "dimeroll_cashflow_g"
            {
                return dimerollCashflow.count
            }
            if dimerollActiveElf
                == "dimeroll_ledger_g"
            {
                return dimerollLedger.count
            }
            if dimerollActiveElf
                == "dimeroll_price_g"
            {
                return dimerollPrice.count
            }
            if dimerollActiveElf
                == "dimeroll_seal_g"
            {
                return dimerollSeal.count
            }
            if dimerollActiveElf
                .hasPrefix("dimeroll_query_")
            {
                return dimerollQueryResults.count
            }
            return dimerollTransactions.count
        }
        return sidebarModules.count
    }
}

extension AppDelegate: NSTableViewDelegate {
    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        if tableView === dimerollTableView {
            return dimerollCellView(
                tableColumn: tableColumn,
                row: row
            )
        }
        let id = NSUserInterfaceItemIdentifier(
            "ModuleCell"
        )
        var cell = tableView.makeView(
            withIdentifier: id, owner: nil
        ) as? NSTextField
        if cell == nil {
            let tf = NSTextField(
                labelWithString: ""
            )
            tf.identifier = id
            tf.textColor = NSColor.white
            tf.font = NSFont.systemFont(
                ofSize: 13
            )
            cell = tf
        }
        cell?.stringValue = sidebarModules[row]
        return cell
    }

    func dimerollCellView(
        tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        guard let colId = tableColumn?.identifier
                  .rawValue
        else { return nil }
        let val: String
        if dimerollActiveElf
            == "dimeroll_inventory_g"
        {
            guard row < dimerollInventory.count
            else { return nil }
            let inv = dimerollInventory[row]
            switch colId {
            case "subject": val = inv.0
            case "qty": val = inv.1
            default: val = ""
            }
        } else if dimerollActiveElf
            == "dimeroll_cashflow_g"
        {
            guard row < dimerollCashflow.count
            else { return nil }
            let cf = dimerollCashflow[row]
            switch colId {
            case "subject": val = cf.0
            case "revenue": val = cf.1
            default: val = ""
            }
        } else if dimerollActiveElf
            == "dimeroll_ledger_g"
        {
            guard row < dimerollLedger.count
            else { return nil }
            let lg = dimerollLedger[row]
            switch colId {
            case "num": val = lg.0
            case "verb": val = lg.1
            case "subject": val = lg.2
            case "qty": val = lg.3
            case "price": val = lg.4
            case "total": val = lg.5
            default: val = ""
            }
        } else if dimerollActiveElf
            == "dimeroll_price_g"
        {
            guard row < dimerollPrice.count
            else { return nil }
            let pr = dimerollPrice[row]
            switch colId {
            case "item": val = pr.0
            case "calc": val = pr.1
            case "cents": val = pr.2
            default: val = ""
            }
        } else if dimerollActiveElf
            == "dimeroll_seal_g"
        {
            guard row < dimerollSeal.count
            else { return nil }
            let sl = dimerollSeal[row]
            switch colId {
            case "field": val = sl.0
            case "value": val = sl.1
            default: val = ""
            }
        } else if dimerollActiveElf
            .hasPrefix("dimeroll_query_")
        {
            guard row < dimerollQueryResults.count
            else { return nil }
            let qr = dimerollQueryResults[row]
            switch colId {
            case "num": val = qr.0
            case "col1": val = qr.1
            case "col2": val = qr.2
            case "col3": val = qr.3
            case "col4": val = qr.4
            default: val = ""
            }
        } else {
            guard row < dimerollTransactions.count
            else { return nil }
            let tx = dimerollTransactions[row]
            switch colId {
            case "num": val = "\(tx.0)"
            case "verb": val = tx.1
            case "subject": val = tx.2
            case "qty": val = tx.3
            case "price": val = tx.4
            case "unit": val = tx.5
            default: val = ""
            }
        }
        let cellId = NSUserInterfaceItemIdentifier(
            "DimerollCell"
        )
        var cell = dimerollTableView?.makeView(
            withIdentifier: cellId, owner: nil
        ) as? NSTextField
        if cell == nil {
            let tf = NSTextField(
                labelWithString: ""
            )
            tf.identifier = cellId
            tf.isBordered = false
            tf.drawsBackground = false
            tf.textColor = NSColor(
                red: 0.9, green: 0.8,
                blue: 0.3, alpha: 1.0
            )
            tf.font = NSFont
                .monospacedSystemFont(
                    ofSize: 13, weight: .regular
                )
            cell = tf
        }
        cell?.stringValue = val
        return cell
    }

    func tableViewSelectionDidChange(
        _ notification: Notification
    ) {
        guard let obj = notification.object
            as? NSTableView,
              obj === sidebarTableView,
              let table = sidebarTableView
        else { return }
        let row = table.selectedRow
        guard row >= 0,
              row < sidebarModules.count
        else { return }
        switch sidebarModules[row] {
        case "Terminal":
            focusTerminal()
        case "Grid":
            focusGrid()
        case "Dimeroll":
            focusDimeroll()
        default:
            break
        }
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
