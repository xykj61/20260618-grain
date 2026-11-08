// StatusAndHelpers.swift -- status bar and text helpers.
//
// Extension on AppDelegate: updateStatusBar, tabView
// delegate, updateFocusIndicator, appendLine, appendText,
// updateGrid.

import AppKit
import SkateCore

extension AppDelegate {

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
