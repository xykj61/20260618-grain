// Terrarium -- a living world under glass.
//
// A macOS window that launches qemu-system-riscv32 as a dependent
// process and captures its serial output.  The glass you look
// through.
//
// Build:  swiftc -o terrarium/.build/Terrarium terrarium/app/main.swift
// Run:    terrarium/.build/Terrarium [stage]
//         (defaults to "hello")

import AppKit
import Foundation

// -- Configuration --------------------------------------------------

let stage: String = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "hello"

let repoRoot: String = {
    let url = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()  // app/
        .deletingLastPathComponent()  // terrarium/
        .deletingLastPathComponent()  // repo root
    return url.path
}()

let elfPath = "\(repoRoot)/terrarium/.build/\(stage).elf"

// -- Application delegate -------------------------------------------

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var textView: NSTextView!
    var qemuProcess: Process?
    var outputPipe: Pipe!

    func applicationDidFinishLaunching(_ note: Notification) {
        let frame = NSRect(x: 200, y: 200, width: 720, height: 480)
        window = NSWindow(
            contentRect: frame,
            styleMask: [.titled, .closable, .resizable,
                        .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Terrarium -- \(stage)"
        window.minSize = NSSize(width: 400, height: 240)

        let scrollView = NSScrollView(frame: window.contentView!.bounds)
        scrollView.autoresizingMask = [.width, .height]
        scrollView.hasVerticalScroller = true

        textView = NSTextView(frame: scrollView.bounds)
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

        scrollView.documentView = textView
        window.contentView?.addSubview(scrollView)
        window.makeKeyAndOrderFront(nil)

        appendLine("Terrarium -- a living world under glass")
        appendLine("stage: \(stage)")
        appendLine("elf:   \(elfPath)")
        appendLine("---")

        launchQemu()
    }

    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool { true }

    // -- QEMU launch ------------------------------------------------

    func launchQemu() {
        guard FileManager.default.fileExists(atPath: elfPath) else {
            appendLine(
                "error: \(elfPath) not found"
            )
            appendLine(
                "run 'make terrarium-build' first"
            )
            return
        }

        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: findQemu())
        proc.arguments = [
            "-machine", "virt",
            "-bios", "none",
            "-nographic",
            "-kernel", elfPath
        ]

        outputPipe = Pipe()
        proc.standardOutput = outputPipe
        proc.standardError = outputPipe

        outputPipe.fileHandleForReading
            .readabilityHandler = { [weak self] handle in
                let data = handle.availableData
                guard !data.isEmpty else { return }
                if let text = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self?.appendText(text)
                    }
                }
            }

        proc.terminationHandler = { [weak self] p in
            DispatchQueue.main.async {
                self?.appendLine(
                    "--- qemu exited with status \(p.terminationStatus)"
                )
                self?.dumpAndExit(status: p.terminationStatus)
            }
        }

        do {
            try proc.run()
            qemuProcess = proc
            appendLine("qemu-system-riscv32 launched (pid \(proc.processIdentifier))")

            DispatchQueue.global().asyncAfter(
                deadline: .now() + 10
            ) { [weak self] in
                if proc.isRunning {
                    proc.terminate()
                    DispatchQueue.main.async {
                        self?.appendLine(
                            "--- 10s timeout, QEMU terminated"
                        )
                    }
                }
            }
        } catch {
            appendLine("error launching qemu: \(error)")
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
                red: 0.0, green: 0.9, blue: 0.4, alpha: 1.0
            )
        ]
        let attrStr = NSAttributedString(
            string: text, attributes: attrs
        )
        textView.textStorage?.append(attrStr)
        textView.scrollToEndOfDocument(nil)
    }

    func dumpAndExit(status: Int32) {
        if let text = textView.textStorage?.string {
            fputs(text, stdout)
        }
        NSApplication.shared.terminate(nil)
    }

    func findQemu() -> String {
        let candidates = [
            "/opt/homebrew/bin/qemu-system-riscv32",
            "/usr/local/bin/qemu-system-riscv32",
            "/usr/bin/qemu-system-riscv32"
        ]
        for c in candidates {
            if FileManager.default.isExecutableFile(atPath: c) {
                return c
            }
        }
        return "qemu-system-riscv32"
    }
}

// -- Main -----------------------------------------------------------

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.activate()
app.run()
