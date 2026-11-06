format session-log-v1
stamp 20261106.180959
session-header 20261104/20261104-190813_orbit3-rv32i-toolchain.kyri.md
voice Kyri
title Inventory summary view -- Movement 21 landed
prompt kg -- continue Realidream Composition Journey
think Movement 21 asks for an inventory summary view inside Terrarium's Dimeroll tab -- the same NSTableView that shows 6-column transactions for dimeroll_tx_g should show 2-column Subject/On Hand for dimeroll_inventory_g
think key design: reuse the same dimerollTableView rather than a second table, dynamically rebuilding columns based on the active module via rebuildDimerollColumns()
think inventory parser uses a state-machine: dimerollInLedgerTable flag detects the section between --- DIMEROLL FIELD LEDGER --- and -- SLC GATE -- markers in UART output, then extracts pipe-delimited rows filtering headers and delimiters
think three new properties: dimerollInventory array of (String, String) tuples, dimerollActiveElf tracking which ELF is running, dimerollInLedgerTable for the parser state machine
think dimerollModuleChanged clears both transaction and inventory arrays, resets flags, records the active ELF, rebuilds columns, then launches the stage
think numberOfRows and dimerollCellView both branch on dimerollActiveElf to serve inventory or transaction data from the same table
obs build clean on first attempt, all symbols verified -- dimerollInventory, dimerollActiveElf, dimerollInLedgerTable visible via strings, rebuildDimerollColumns and parseDimerollInventoryLine confirmed via nm demangle
obs QEMU output for dimeroll_inventory_g shows tomatoes 95, peppers 15, leaves 30 -- the expected inventory from the 9 farm transactions
[file](../../terrarium/app/main.swift) added dimerollInventory, dimerollActiveElf, dimerollInLedgerTable properties; parseDimerollInventoryLine state-machine parser; rebuildDimerollColumns dynamic column builder; routing in parseDimerollTransactions, numberOfRows, dimerollCellView
[file](../../active-tablecloth/20261106-131535_realidream-composition-journey/CHECKLIST.md) Movement 21 marked done
[file](../../active-tablecloth/20261106-131535_realidream-composition-journey/PROGRESS.md) Movement 21 row added
recommend keep-going -- next: Movement 22, cash flow view; then Movements 23-30 through Quest 2 and Quest 3
