// QemuLauncher -- QEMU process launch, framebuffer
// capture, and process lifecycle.

import AppKit

extension AppDelegate {

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

    // -- Process lifecycle -------------------------------------------

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
