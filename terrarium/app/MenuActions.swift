// MenuActions.swift -- menu setup and navigation actions.
//
// Extension on AppDelegate: setupMenu, focus switching,
// sidebar toggle, tab management shortcuts.

import AppKit

extension AppDelegate {

    // -- scene switching ---------------------------------------------

    func setupMenu() {
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

        // -- Shortcuts menu -------------------

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

    // -- Shortcut actions -----------------

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
}
