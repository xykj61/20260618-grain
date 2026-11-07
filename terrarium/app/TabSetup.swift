import AppKit
import VantageBloom
import VantageDimeroll

extension AppDelegate {

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

}
