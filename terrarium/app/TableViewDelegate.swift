// TableViewDelegate -- sidebar and Dimeroll table
// data source and delegate.

import AppKit

extension AppDelegate: NSTableViewDataSource {
    func numberOfRows(
        in tableView: NSTableView
    ) -> Int {
        if tableView.tag == 9001 {
            return mantraCatalogRows.count
        }
        if tableView === audioTrackTable {
            return audioTracks.count
        }
        if tableView === dimerollTableView {
            if dimerollActiveElf
                == "dimeroll_dashboard"
            {
                return dashboardRowCount()
            }
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
        if tableView.tag == 9001 {
            return mantraCatalogCellView(
                tableColumn: tableColumn,
                row: row
            )
        }
        if tableView === audioTrackTable {
            return audioTrackCellView(
                tableColumn: tableColumn,
                row: row
            )
        }
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
            == "dimeroll_dashboard"
        {
            let d = dashboardRowData(row)
            let tf = NSTextField(
                labelWithString: ""
            )
            tf.textColor = NSColor(
                red: 0.95, green: 0.88,
                blue: 0.62, alpha: 1.0
            )
            tf.font = NSFont.monospacedSystemFont(
                ofSize: 12, weight: .regular
            )
            if d.2 {
                tf.font =
                    NSFont.monospacedSystemFont(
                        ofSize: 12, weight: .bold
                    )
                tf.stringValue =
                    colId == "label" ? d.0 : ""
            } else {
                switch colId {
                case "label": tf.stringValue = d.0
                case "value": tf.stringValue = d.1
                default: break
                }
            }
            return tf
        } else if dimerollActiveElf
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

    func audioTrackCellView(
        tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        guard let colId = tableColumn?.identifier
                  .rawValue,
              row < audioTracks.count
        else { return nil }
        let cellId = NSUserInterfaceItemIdentifier(
            "TrackCell"
        )
        var cell = audioTrackTable?.makeView(
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
                blue: 0.6, alpha: 1.0
            )
            tf.font = NSFont
                .monospacedSystemFont(
                    ofSize: 12, weight: .regular
                )
            cell = tf
        }
        let track = audioTracks[row]
        switch colId {
        case "name":
            cell?.stringValue = track.name
        case "gain":
            cell?.stringValue = String(
                format: "%.1f", track.gain
            )
        default:
            break
        }
        return cell
    }

    func mantraCatalogCellView(
        tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        guard let colId = tableColumn?.identifier
                  .rawValue,
              row < mantraCatalogRows.count
        else { return nil }
        let entry = mantraCatalogRows[row]
        let val: String
        switch colId {
        case "path": val = entry.0
        case "digest": val = entry.1
        case "size": val = entry.2
        default: val = ""
        }
        let tf = NSTextField(
            labelWithString: val
        )
        tf.isBordered = false
        tf.drawsBackground = false
        tf.textColor = NSColor(
            red: 0.8, green: 0.7,
            blue: 0.95, alpha: 1.0
        )
        tf.font = NSFont.monospacedSystemFont(
            ofSize: 12, weight: .regular
        )
        return tf
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
        case "Mantra":
            focusMantra()
        case "Bloom":
            focusBloom()
        case "Audio":
            focusAudio()
        case "Social":
            focusSocial()
        default:
            break
        }
    }
}
