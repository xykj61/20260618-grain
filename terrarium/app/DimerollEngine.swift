// DimerollEngine -- QEMU stage launcher and output parsers.
//
// Extension on AppDelegate for launching Dimeroll QEMU stages,
// parsing their serial output into table data, and managing the
// dashboard multi-phase workflow.

import AppKit
import VantageDimeroll

extension AppDelegate {

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
                let idx = self?
                    .dimerollModulePopUp?
                    .indexOfSelectedItem ?? -1
                if idx == 0
                    && (self?.dimerollDashPhase ?? 3)
                        < 3
                {
                    self?.dimerollDashboardPhaseComplete()
                }
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
        dimerollDashInv.removeAll()
        dimerollDashCF.removeAll()
        dimerollDashSeal.removeAll()
        dimerollDashPhase = 3
        dimerollRawBuffer = ""
        dimerollInLedgerTable = false
        dimerollActiveElf = elfName
        rebuildDimerollColumns()
        dimerollTableView?.reloadData()
        if elfName == "dimeroll_dashboard" {
            launchDimerollDashboard()
        } else {
            launchDimerollStage(elfName)
        }
    }

    func launchDimerollDashboard() {
        dimerollDashInv.removeAll()
        dimerollDashCF.removeAll()
        dimerollDashSeal.removeAll()
        dimerollDashPhase = 0
        dimerollActiveElf = "dimeroll_inventory_g"
        launchDimerollStage(
            "dimeroll_inventory_g"
        )
    }

    func dimerollDashboardPhaseComplete() {
        dimerollDashPhase += 1
        if dimerollDashPhase == 1 {
            dimerollDashInv = dimerollInventory
            dimerollInventory.removeAll()
            dimerollRawBuffer = ""
            dimerollInLedgerTable = false
            dimerollActiveElf =
                "dimeroll_cashflow_g"
            dimerollTableView?.reloadData()
            launchDimerollStage(
                "dimeroll_cashflow_g"
            )
        } else if dimerollDashPhase == 2 {
            dimerollDashCF = dimerollCashflow
            dimerollCashflow.removeAll()
            dimerollRawBuffer = ""
            dimerollInLedgerTable = false
            dimerollActiveElf = "dimeroll_seal_g"
            dimerollTableView?.reloadData()
            launchDimerollStage(
                "dimeroll_seal_g"
            )
        } else {
            dimerollDashSeal = dimerollSeal
            dimerollSeal.removeAll()
            dimerollActiveElf =
                "dimeroll_dashboard"
            rebuildDimerollColumns()
            dimerollTableView?.reloadData()
        }
    }

    func dashboardRowCount() -> Int {
        var n = 0
        if !dimerollDashInv.isEmpty {
            n += 1 + dimerollDashInv.count
        }
        if !dimerollDashCF.isEmpty {
            n += 1 + dimerollDashCF.count
        }
        if !dimerollDashSeal.isEmpty {
            n += 1 + dimerollDashSeal.count
        }
        if n == 0 && dimerollDashPhase < 3 {
            n = 1
        }
        return n
    }

    func dashboardRowData(
        _ row: Int
    ) -> (String, String, Bool) {
        var r = row
        if !dimerollDashInv.isEmpty {
            if r == 0 {
                return ("INVENTORY", "", true)
            }
            r -= 1
            if r < dimerollDashInv.count {
                let d = dimerollDashInv[r]
                return (d.0, d.1, false)
            }
            r -= dimerollDashInv.count
        }
        if !dimerollDashCF.isEmpty {
            if r == 0 {
                return ("CASH FLOW", "", true)
            }
            r -= 1
            if r < dimerollDashCF.count {
                let d = dimerollDashCF[r]
                return (d.0, d.1, false)
            }
            r -= dimerollDashCF.count
        }
        if !dimerollDashSeal.isEmpty {
            if r == 0 {
                return ("SEAL", "", true)
            }
            r -= 1
            if r < dimerollDashSeal.count {
                let d = dimerollDashSeal[r]
                return (d.0, d.1, false)
            }
            r -= dimerollDashSeal.count
        }
        return ("Loading...", "", false)
    }

    func rebuildDimerollColumns() {
        guard let tbl = dimerollTableView
        else { return }
        while tbl.tableColumns.count > 0 {
            tbl.removeTableColumn(
                tbl.tableColumns[0]
            )
        }
        let mi: UInt32 = {
            let mods = dimerollModules
            if let found = mods.firstIndex(
                where: { $0.1 == dimerollActiveElf }
            ) {
                return UInt32(found)
            }
            return 1
        }()
        let cc = dimeroll_column_count(mi)
        for ci: UInt32 in 0..<cc {
            let title = String(
                cString: dimeroll_column_title(mi, ci)
            )
            let ident = String(
                cString: dimeroll_column_ident(mi, ci)
            )
            let width = CGFloat(
                dimeroll_column_width(mi, ci)
            )
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
}
