import AppKit
import VantageBloom
import VantageDimeroll
import VantageLotus

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

    @objc func focusAudio() {
        guard let tv = tabView else { return }
        for i in 0..<tv.numberOfTabViewItems {
            let item = tv.tabViewItem(at: i)
            if let ident = item.identifier
                as? String,
               ident == "audio"
            {
                tv.selectTabViewItem(at: i)
                return
            }
        }

        let item = NSTabViewItem(
            identifier: "audio"
        )
        item.label = "Audio"

        let container = NSView()
        container.wantsLayer = true
        container.layer?.backgroundColor =
            NSColor(
                red: 0.06, green: 0.04,
                blue: 0.02, alpha: 1.0
            ).cgColor

        let titleLbl = NSTextField(
            labelWithString: "Lotus Audio"
        )
        titleLbl.font = NSFont.systemFont(
            ofSize: 18, weight: .medium
        )
        titleLbl.textColor = NSColor(
            red: 0.9, green: 0.75,
            blue: 0.5, alpha: 1.0
        )
        titleLbl.alignment = .center
        titleLbl
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(titleLbl)

        let statusLbl = NSTextField(
            labelWithString: "Stopped"
        )
        statusLbl.font =
            NSFont.monospacedSystemFont(
                ofSize: 13, weight: .regular
            )
        statusLbl.textColor = NSColor(
            red: 0.7, green: 0.6,
            blue: 0.45, alpha: 1.0
        )
        statusLbl.alignment = .center
        statusLbl
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(statusLbl)

        let playBtn = NSButton(
            title: "Play Test Tone",
            target: nil,
            action: nil
        )
        playBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(playBtn)

        let stopBtn = NSButton(
            title: "Stop",
            target: nil,
            action: nil
        )
        stopBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(stopBtn)

        playBtn.target = self
        playBtn.action =
            #selector(audioPlayPressed(_:))
        stopBtn.target = self
        stopBtn.action =
            #selector(audioStopPressed(_:))

        let loopBtn = NSButton(
            title: "Loop: On",
            target: nil,
            action: nil
        )
        loopBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        loopBtn.tag = 900
        container.addSubview(loopBtn)
        loopBtn.target = self
        loopBtn.action =
            #selector(audioLoopToggled(_:))

        let tempoLbl = NSTextField(
            labelWithString: "BPM:"
        )
        tempoLbl.font = NSFont.systemFont(
            ofSize: 13, weight: .regular
        )
        tempoLbl.textColor = NSColor(
            red: 0.7, green: 0.6,
            blue: 0.45, alpha: 1.0
        )
        tempoLbl
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(tempoLbl)

        let tempoField = NSTextField(string: "120")
        tempoField.font =
            NSFont.monospacedSystemFont(
                ofSize: 13, weight: .regular
            )
        tempoField.textColor = NSColor(
            red: 0.9, green: 0.8,
            blue: 0.6, alpha: 1.0
        )
        tempoField.backgroundColor = NSColor(
            red: 0.12, green: 0.09,
            blue: 0.05, alpha: 1.0
        )
        tempoField.isBordered = true
        tempoField.alignment = .center
        tempoField
            .translatesAutoresizingMaskIntoConstraints =
            false
        tempoField.tag = 901
        container.addSubview(tempoField)

        let waveform = WaveformView(
            frame: NSRect(
                x: 0, y: 0,
                width: 400, height: 120
            )
        )
        waveform
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(waveform)
        audioWaveformView = waveform

        let recBtn = NSButton(
            title: "Record",
            target: self,
            action: #selector(
                audioRecordPressed(_:)
            )
        )
        recBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        recBtn.tag = 902
        container.addSubview(recBtn)

        let recStopBtn = NSButton(
            title: "Stop Rec",
            target: self,
            action: #selector(
                audioRecordStopPressed(_:)
            )
        )
        recStopBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(recStopBtn)

        let exportBtn = NSButton(
            title: "Export WAV",
            target: self,
            action: #selector(
                audioExportWavPressed(_:)
            )
        )
        exportBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(exportBtn)

        let panelBox = NSView()
        panelBox.wantsLayer = true
        panelBox.layer?.backgroundColor =
            NSColor(
                red: 0.09, green: 0.07,
                blue: 0.04, alpha: 1.0
            ).cgColor
        panelBox.layer?.cornerRadius = 6
        panelBox
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(panelBox)

        let rateLbl = NSTextField(
            labelWithString: "Sample Rate: --"
        )
        rateLbl.font =
            NSFont.monospacedSystemFont(
                ofSize: 12, weight: .regular
            )
        rateLbl.textColor = NSColor(
            red: 0.7, green: 0.6,
            blue: 0.45, alpha: 1.0
        )
        rateLbl
            .translatesAutoresizingMaskIntoConstraints =
            false
        rateLbl.tag = 910
        panelBox.addSubview(rateLbl)

        let timeLbl = NSTextField(
            labelWithString: "Rec Time: --"
        )
        timeLbl.font =
            NSFont.monospacedSystemFont(
                ofSize: 12, weight: .regular
            )
        timeLbl.textColor = NSColor(
            red: 0.7, green: 0.6,
            blue: 0.45, alpha: 1.0
        )
        timeLbl
            .translatesAutoresizingMaskIntoConstraints =
            false
        timeLbl.tag = 911
        panelBox.addSubview(timeLbl)

        let peakLbl = NSTextField(
            labelWithString: "Peak: --"
        )
        peakLbl.font =
            NSFont.monospacedSystemFont(
                ofSize: 12, weight: .regular
            )
        peakLbl.textColor = NSColor(
            red: 0.7, green: 0.6,
            blue: 0.45, alpha: 1.0
        )
        peakLbl
            .translatesAutoresizingMaskIntoConstraints =
            false
        peakLbl.tag = 912
        panelBox.addSubview(peakLbl)

        let trackLabel = NSTextField(
            labelWithString: "Tracks"
        )
        trackLabel.font = NSFont.systemFont(
            ofSize: 14, weight: .medium
        )
        trackLabel.textColor = NSColor(
            red: 0.9, green: 0.75,
            blue: 0.5, alpha: 1.0
        )
        trackLabel
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(trackLabel)

        let nameCol = NSTableColumn(
            identifier: NSUserInterfaceItemIdentifier(
                "name"
            )
        )
        nameCol.title = "Name"
        nameCol.width = 200

        let gainCol = NSTableColumn(
            identifier: NSUserInterfaceItemIdentifier(
                "gain"
            )
        )
        gainCol.title = "Gain"
        gainCol.width = 60

        let trackTable = NSTableView()
        trackTable.addTableColumn(nameCol)
        trackTable.addTableColumn(gainCol)
        trackTable.headerView = NSTableHeaderView()
        trackTable.usesAlternatingRowBackgroundColors =
            false
        trackTable.backgroundColor = NSColor(
            red: 0.08, green: 0.06,
            blue: 0.03, alpha: 1.0
        )
        trackTable.gridColor = NSColor(
            red: 0.2, green: 0.16,
            blue: 0.1, alpha: 1.0
        )
        trackTable.gridStyleMask = .solidHorizontalGridLineMask
        trackTable.rowHeight = 24
        trackTable.allowsMultipleSelection = false
        trackTable.dataSource = self
        trackTable.delegate = self
        audioTrackTable = trackTable

        let scrollView = NSScrollView()
        scrollView.documentView = trackTable
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .bezelBorder
        scrollView.drawsBackground = true
        scrollView.backgroundColor = NSColor(
            red: 0.08, green: 0.06,
            blue: 0.03, alpha: 1.0
        )
        scrollView
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(scrollView)

        let addTrackBtn = NSButton(
            title: "+ Track",
            target: self,
            action: #selector(
                audioAddTrackPressed(_:)
            )
        )
        addTrackBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(addTrackBtn)

        let removeTrackBtn = NSButton(
            title: "- Track",
            target: self,
            action: #selector(
                audioRemoveTrackPressed(_:)
            )
        )
        removeTrackBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(removeTrackBtn)

        // -- Mixer panel --
        let mixerLabel = NSTextField(labelWithString: "Mixer")
        mixerLabel.font = NSFont.boldSystemFont(ofSize: 13)
        mixerLabel.textColor = NSColor(
            red: 0.9, green: 0.75, blue: 0.5, alpha: 1.0
        )
        mixerLabel
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(mixerLabel)

        let gainLabel = NSTextField(
            labelWithString: "Gain"
        )
        gainLabel.font = NSFont.monospacedSystemFont(
            ofSize: 11, weight: .regular
        )
        gainLabel.textColor = NSColor(
            red: 0.8, green: 0.7, blue: 0.5, alpha: 1.0
        )
        gainLabel
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(gainLabel)

        let gainSlider = NSSlider(
            value: 1.0,
            minValue: 0.0,
            maxValue: 2.0,
            target: self,
            action: #selector(
                audioGainSliderChanged(_:)
            )
        )
        gainSlider.tag = 920
        gainSlider
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(gainSlider)

        let gainVal = NSTextField(
            labelWithString: "1.00"
        )
        gainVal.tag = 921
        gainVal.font = NSFont.monospacedSystemFont(
            ofSize: 11, weight: .regular
        )
        gainVal.textColor = NSColor(
            red: 0.9, green: 0.8, blue: 0.6, alpha: 1.0
        )
        gainVal
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(gainVal)

        let panLabel = NSTextField(
            labelWithString: "Pan"
        )
        panLabel.font = NSFont.monospacedSystemFont(
            ofSize: 11, weight: .regular
        )
        panLabel.textColor = NSColor(
            red: 0.8, green: 0.7, blue: 0.5, alpha: 1.0
        )
        panLabel
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(panLabel)

        let panSlider = NSSlider(
            value: 0.0,
            minValue: -1.0,
            maxValue: 1.0,
            target: self,
            action: #selector(
                audioPanSliderChanged(_:)
            )
        )
        panSlider.tag = 922
        panSlider
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(panSlider)

        let panVal = NSTextField(
            labelWithString: "C"
        )
        panVal.tag = 923
        panVal.font = NSFont.monospacedSystemFont(
            ofSize: 11, weight: .regular
        )
        panVal.textColor = NSColor(
            red: 0.9, green: 0.8, blue: 0.6, alpha: 1.0
        )
        panVal
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(panVal)

        let soloBtn = NSButton(
            title: "Solo",
            target: self,
            action: #selector(
                audioSoloPressed(_:)
            )
        )
        soloBtn.tag = 924
        soloBtn.bezelStyle = .rounded
        soloBtn.setButtonType(.toggle)
        soloBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(soloBtn)

        let muteBtn = NSButton(
            title: "Mute",
            target: self,
            action: #selector(
                audioMutePressed(_:)
            )
        )
        muteBtn.tag = 925
        muteBtn.bezelStyle = .rounded
        muteBtn.setButtonType(.toggle)
        muteBtn
            .translatesAutoresizingMaskIntoConstraints =
            false
        container.addSubview(muteBtn)

        NSLayoutConstraint.activate([
            panelBox.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            panelBox.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -24
            ),
            panelBox.topAnchor.constraint(
                equalTo: exportBtn.bottomAnchor,
                constant: 16
            ),
            panelBox.heightAnchor.constraint(
                equalToConstant: 76
            ),
            rateLbl.leadingAnchor.constraint(
                equalTo: panelBox.leadingAnchor,
                constant: 12
            ),
            rateLbl.topAnchor.constraint(
                equalTo: panelBox.topAnchor,
                constant: 10
            ),
            timeLbl.leadingAnchor.constraint(
                equalTo: panelBox.leadingAnchor,
                constant: 12
            ),
            timeLbl.topAnchor.constraint(
                equalTo: rateLbl.bottomAnchor,
                constant: 4
            ),
            peakLbl.leadingAnchor.constraint(
                equalTo: panelBox.leadingAnchor,
                constant: 12
            ),
            peakLbl.topAnchor.constraint(
                equalTo: timeLbl.bottomAnchor,
                constant: 4
            ),
            trackLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            trackLabel.topAnchor.constraint(
                equalTo: panelBox.bottomAnchor,
                constant: 16
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -24
            ),
            scrollView.topAnchor.constraint(
                equalTo: trackLabel.bottomAnchor,
                constant: 8
            ),
            scrollView.heightAnchor.constraint(
                equalToConstant: 120
            ),
            addTrackBtn.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            addTrackBtn.topAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: 8
            ),
            removeTrackBtn.leadingAnchor.constraint(
                equalTo: addTrackBtn.trailingAnchor,
                constant: 12
            ),
            removeTrackBtn.topAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: 8
            ),
            mixerLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            mixerLabel.topAnchor.constraint(
                equalTo: addTrackBtn.bottomAnchor,
                constant: 16
            ),
            gainLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            gainLabel.topAnchor.constraint(
                equalTo: mixerLabel.bottomAnchor,
                constant: 10
            ),
            gainLabel.widthAnchor.constraint(
                equalToConstant: 36
            ),
            gainSlider.leadingAnchor.constraint(
                equalTo: gainLabel.trailingAnchor,
                constant: 8
            ),
            gainSlider.centerYAnchor.constraint(
                equalTo: gainLabel.centerYAnchor
            ),
            gainSlider.widthAnchor.constraint(
                equalToConstant: 160
            ),
            gainVal.leadingAnchor.constraint(
                equalTo: gainSlider.trailingAnchor,
                constant: 8
            ),
            gainVal.centerYAnchor.constraint(
                equalTo: gainLabel.centerYAnchor
            ),
            panLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            panLabel.topAnchor.constraint(
                equalTo: gainLabel.bottomAnchor,
                constant: 8
            ),
            panLabel.widthAnchor.constraint(
                equalToConstant: 36
            ),
            panSlider.leadingAnchor.constraint(
                equalTo: panLabel.trailingAnchor,
                constant: 8
            ),
            panSlider.centerYAnchor.constraint(
                equalTo: panLabel.centerYAnchor
            ),
            panSlider.widthAnchor.constraint(
                equalToConstant: 160
            ),
            panVal.leadingAnchor.constraint(
                equalTo: panSlider.trailingAnchor,
                constant: 8
            ),
            panVal.centerYAnchor.constraint(
                equalTo: panLabel.centerYAnchor
            ),
            soloBtn.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            soloBtn.topAnchor.constraint(
                equalTo: panLabel.bottomAnchor,
                constant: 10
            ),
            muteBtn.leadingAnchor.constraint(
                equalTo: soloBtn.trailingAnchor,
                constant: 12
            ),
            muteBtn.topAnchor.constraint(
                equalTo: panLabel.bottomAnchor,
                constant: 10
            ),
        ])

        NSLayoutConstraint.activate([
            titleLbl.centerXAnchor.constraint(
                equalTo: container.centerXAnchor
            ),
            titleLbl.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: 24
            ),
            statusLbl.centerXAnchor.constraint(
                equalTo: container.centerXAnchor
            ),
            statusLbl.topAnchor.constraint(
                equalTo: titleLbl.bottomAnchor,
                constant: 12
            ),
            playBtn.centerXAnchor.constraint(
                equalTo: container.centerXAnchor,
                constant: -60
            ),
            playBtn.topAnchor.constraint(
                equalTo: statusLbl.bottomAnchor,
                constant: 16
            ),
            stopBtn.centerXAnchor.constraint(
                equalTo: container.centerXAnchor,
                constant: 60
            ),
            stopBtn.topAnchor.constraint(
                equalTo: statusLbl.bottomAnchor,
                constant: 16
            ),
            loopBtn.centerXAnchor.constraint(
                equalTo: container.centerXAnchor,
                constant: -40
            ),
            loopBtn.topAnchor.constraint(
                equalTo: playBtn.bottomAnchor,
                constant: 12
            ),
            tempoLbl.leadingAnchor.constraint(
                equalTo: loopBtn.trailingAnchor,
                constant: 16
            ),
            tempoLbl.centerYAnchor.constraint(
                equalTo: loopBtn.centerYAnchor
            ),
            tempoField.leadingAnchor.constraint(
                equalTo: tempoLbl.trailingAnchor,
                constant: 6
            ),
            tempoField.centerYAnchor.constraint(
                equalTo: loopBtn.centerYAnchor
            ),
            tempoField.widthAnchor.constraint(
                equalToConstant: 60
            ),
            waveform.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 24
            ),
            waveform.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -24
            ),
            waveform.topAnchor.constraint(
                equalTo: loopBtn.bottomAnchor,
                constant: 16
            ),
            waveform.heightAnchor.constraint(
                equalToConstant: 120
            ),
            recBtn.centerXAnchor.constraint(
                equalTo: container.centerXAnchor,
                constant: -60
            ),
            recBtn.topAnchor.constraint(
                equalTo: waveform.bottomAnchor,
                constant: 16
            ),
            recStopBtn.centerXAnchor.constraint(
                equalTo: container.centerXAnchor,
                constant: 60
            ),
            recStopBtn.topAnchor.constraint(
                equalTo: waveform.bottomAnchor,
                constant: 16
            ),
            exportBtn.centerXAnchor.constraint(
                equalTo: container.centerXAnchor
            ),
            exportBtn.topAnchor.constraint(
                equalTo: recBtn.bottomAnchor,
                constant: 12
            ),
        ])

        item.view = container
        tv.addTabViewItem(item)
        tv.selectTabViewItem(item)
    }

    @objc func audioPlayPressed(
        _ sender: NSButton
    ) {
        if !lotus_audio_is_open() {
            lotus_audio_set_loop(true)
            let ok = lotus_audio_init_test_tone(
                44100, 44100
            )
            if !ok {
                updateAudioStatus("Init failed")
                return
            }
        }
        lotus_audio_seek_start()
        if lotus_audio_start() {
            let loopTxt = lotus_audio_is_looping()
                ? " (loop)" : ""
            updateAudioStatus(
                "Playing -- D2 144.16 Hz\(loopTxt)"
            )
            let rate = lotus_audio_sample_rate()
            setStatusPanelField(
                tag: 910,
                text: "Sample Rate: \(rate) Hz"
            )
        } else {
            updateAudioStatus("Start failed")
        }
    }

    @objc func audioLoopToggled(
        _ sender: NSButton
    ) {
        let nowOn = !lotus_audio_is_looping()
        lotus_audio_set_loop(nowOn)
        sender.title = nowOn
            ? "Loop: On" : "Loop: Off"
        if lotus_audio_is_playing() {
            let loopTxt = nowOn
                ? " (loop)" : ""
            updateAudioStatus(
                "Playing -- D2 144.16 Hz\(loopTxt)"
            )
        }
    }

    @objc func audioStopPressed(
        _ sender: NSButton
    ) {
        if lotus_audio_is_playing() {
            if lotus_audio_stop() {
                updateAudioStatus("Stopped")
            } else {
                updateAudioStatus("Stop failed")
            }
        } else if lotus_audio_is_open() {
            lotus_audio_close()
            updateAudioStatus("Closed")
        }
    }

    @objc func audioRecordPressed(
        _ sender: NSButton
    ) {
        if !lotus_record_is_open() {
            let ok = lotus_record_open(44100)
            if !ok {
                updateAudioStatus(
                    "Record init failed"
                )
                return
            }
        }
        if lotus_record_start() {
            updateAudioStatus("Recording...")
            startRecordWaveformTimer()
        } else {
            updateAudioStatus("Record start failed")
        }
    }

    @objc func audioRecordStopPressed(
        _ sender: NSButton
    ) {
        stopRecordWaveformTimer()
        if lotus_record_is_recording() {
            if lotus_record_stop() {
                let n = lotus_record_sample_count()
                let pk = lotus_record_meter_peak()
                if lotus_record_to_playback() {
                    updateAudioStatus(
                        "Recorded \(n) samples"
                            + " (peak \(pk))"
                    )
                    updateAudioStatusPanel(
                        samples: n, peak: pk
                    )
                } else {
                    updateAudioStatus(
                        "Recorded 0 samples"
                    )
                }
            } else {
                updateAudioStatus(
                    "Record stop failed"
                )
            }
        } else if lotus_record_is_open() {
            lotus_record_close()
            updateAudioStatus("Record closed")
        }
    }

    @objc func audioExportWavPressed(
        _ sender: NSButton
    ) {
        let count = lotus_record_sample_count()
        guard count > 0 else {
            updateAudioStatus("Nothing to export")
            return
        }
        // invariant: max WAV file size is bounded by
        // header (44) + samples * 2.
        let maxBytes = 44 + Int(count) * 2
        var wavBuf = [UInt8](
            repeating: 0, count: maxBytes
        )
        let wrote = lotus_record_export_wav(
            &wavBuf, UInt32(maxBytes)
        )
        guard wrote > 0 else {
            updateAudioStatus("WAV encode failed")
            return
        }
        let panel = NSSavePanel()
        panel.allowedContentTypes = [
            .init(
                filenameExtension: "wav"
            ) ?? .data
        ]
        panel.nameFieldStringValue =
            "recording.wav"
        panel.canCreateDirectories = true
        let resp = panel.runModal()
        guard resp == .OK,
              let url = panel.url
        else {
            updateAudioStatus("Export cancelled")
            return
        }
        let data = Data(
            wavBuf[0..<Int(wrote)]
        )
        do {
            try data.write(to: url)
            updateAudioStatus(
                "Exported \(wrote) bytes"
                    + " to \(url.lastPathComponent)"
            )
        } catch {
            updateAudioStatus(
                "Write failed: \(error)"
            )
        }
    }

    private func startRecordWaveformTimer() {
        stopRecordWaveformTimer()
        audioRecordTimer = Timer.scheduledTimer(
            withTimeInterval: 0.05,
            repeats: true
        ) { [weak self] _ in
            self?.pollRecordingBuffer()
        }
    }

    private func stopRecordWaveformTimer() {
        audioRecordTimer?.invalidate()
        audioRecordTimer = nil
    }

    private func pollRecordingBuffer() {
        let n = lotus_record_sample_count()
        guard n > 0 else { return }
        let displayCount = min(Int(n), 2048)
        var raw = [Int16](
            repeating: 0, count: displayCount
        )
        let got = lotus_record_read_buf(
            &raw, UInt32(displayCount)
        )
        guard got > 0 else { return }
        let floats = raw[0..<Int(got)].map {
            Float($0) / 32768.0
        }
        audioWaveformView?.update(
            buffer: Array(floats)
        )
        let pk = lotus_record_meter_peak()
        updateAudioStatus(
            "Recording... \(n) samples"
                + " (peak \(pk))"
        )
        updateAudioStatusPanel(
            samples: n, peak: pk
        )
    }

    private func updateAudioStatusPanel(
        samples: UInt32, peak: UInt32
    ) {
        let rate = lotus_audio_sample_rate()
        let rateTxt: String
        if rate > 0 {
            rateTxt = "Sample Rate: \(rate) Hz"
        } else {
            rateTxt = "Sample Rate: --"
        }
        let timeTxt: String
        if rate > 0 && samples > 0 {
            let secs = Double(samples)
                / Double(rate)
            let mins = Int(secs) / 60
            let remSecs = secs
                - Double(mins * 60)
            timeTxt = String(
                format: "Rec Time: %d:%05.2f",
                mins, remSecs
            )
        } else {
            timeTxt = "Rec Time: --"
        }
        let peakDb: String
        if peak > 0 {
            let norm = Double(peak) / 32768.0
            let db = 20.0 * log10(norm)
            peakDb = String(
                format: "Peak: %d (%.1f dB)",
                peak, db
            )
        } else {
            peakDb = "Peak: --"
        }
        setStatusPanelField(
            tag: 910, text: rateTxt
        )
        setStatusPanelField(
            tag: 911, text: timeTxt
        )
        setStatusPanelField(
            tag: 912, text: peakDb
        )
    }

    private func setStatusPanelField(
        tag: Int, text: String
    ) {
        guard let tv = tabView else { return }
        for i in 0..<tv.numberOfTabViewItems {
            let item = tv.tabViewItem(at: i)
            if let ident = item.identifier
                as? String,
               ident == "audio",
               let v = item.view
            {
                if let lbl = v.viewWithTag(tag)
                    as? NSTextField
                {
                    lbl.stringValue = text
                    return
                }
                for sub in v.subviews {
                    if let lbl = sub
                        .viewWithTag(tag)
                        as? NSTextField
                    {
                        lbl.stringValue = text
                        return
                    }
                }
            }
        }
    }

    private func updateAudioStatus(
        _ text: String
    ) {
        guard let tv = tabView else { return }
        for i in 0..<tv.numberOfTabViewItems {
            let item = tv.tabViewItem(at: i)
            if let ident = item.identifier
                as? String,
               ident == "audio",
               let v = item.view
            {
                for sub in v.subviews {
                    if let lbl = sub
                        as? NSTextField,
                       lbl.font?
                        .fontDescriptor
                        .symbolicTraits
                        .contains(
                            .monoSpace
                        ) == true
                    {
                        lbl.stringValue = text
                        return
                    }
                }
            }
        }
    }

    @objc func audioAddTrackPressed(
        _ sender: Any?
    ) {
        let n = audioTracks.count + 1
        audioTracks.append(
            (
                name: "Track \(n)", gain: 1.0,
                pan: 0.0, solo: false, mute: false
            )
        )
        audioTrackTable?.reloadData()
        audioTrackTable?.selectRowIndexes(
            IndexSet(integer: audioTracks.count - 1),
            byExtendingSelection: false
        )
    }

    @objc func audioGainSliderChanged(
        _ sender: Any?
    ) {
        guard let slider = sender as? NSSlider
        else { return }
        let val = Float(slider.doubleValue)
        lotus_audio_set_gain(val)
        guard let table = audioTrackTable else {
            return
        }
        let row = table.selectedRow
        if row >= 0, row < audioTracks.count {
            audioTracks[row].gain = val
        }
        setStatusPanelField(
            tag: 921,
            text: String(format: "%.2f", val)
        )
    }

    @objc func audioPanSliderChanged(
        _ sender: Any?
    ) {
        guard let slider = sender as? NSSlider
        else { return }
        let val = Float(slider.doubleValue)
        guard let table = audioTrackTable else {
            return
        }
        let row = table.selectedRow
        if row >= 0, row < audioTracks.count {
            audioTracks[row].pan = val
        }
        let txt: String
        if val < -0.05 {
            txt = String(format: "L%.0f", -val * 100)
        } else if val > 0.05 {
            txt = String(format: "R%.0f", val * 100)
        } else {
            txt = "C"
        }
        setStatusPanelField(tag: 923, text: txt)
    }

    @objc func audioSoloPressed(
        _ sender: Any?
    ) {
        guard let table = audioTrackTable else {
            return
        }
        let row = table.selectedRow
        guard row >= 0,
              row < audioTracks.count
        else { return }
        audioTracks[row].solo.toggle()
    }

    @objc func audioMutePressed(
        _ sender: Any?
    ) {
        guard let table = audioTrackTable else {
            return
        }
        let row = table.selectedRow
        guard row >= 0,
              row < audioTracks.count
        else { return }
        audioTracks[row].mute.toggle()
        if audioTracks[row].mute {
            lotus_audio_set_gain(0.0)
        } else {
            lotus_audio_set_gain(
                audioTracks[row].gain
            )
        }
    }

    @objc func audioRemoveTrackPressed(
        _ sender: Any?
    ) {
        guard let table = audioTrackTable else {
            return
        }
        let row = table.selectedRow
        guard row >= 0,
              row < audioTracks.count,
              audioTracks.count > 1
        else { return }
        audioTracks.remove(at: row)
        table.reloadData()
        let newSel = min(
            row, audioTracks.count - 1
        )
        table.selectRowIndexes(
            IndexSet(integer: newSel),
            byExtendingSelection: false
        )
    }

}
