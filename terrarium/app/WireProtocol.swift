// WireProtocol -- UART wire protocol handlers.
//
// Extension on EmulatorController for the three wire protocols:
// simple fact-ack, Mantra chain verification, and content request.

import Foundation

extension AppDelegate {

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

    func hostDjb2(_ data: Data) -> UInt32 {
        var h: UInt32 = 5381
        for byte in data {
            h = h &* 33 &+ UInt32(byte)
        }
        return h
    }

    func handleContentWire() {
        let complete = serialBuffer.hasSuffix("\n")
            ? serialBuffer.components(separatedBy: "\n")
            : Array(
                serialBuffer.components(
                    separatedBy: "\n"
                ).dropLast()
            )
        let creqs = complete.filter {
            $0.hasPrefix("CREQ:")
        }
        guard creqs.count > contentReqCount else {
            return
        }
        let req = creqs[contentReqCount]
        contentReqCount += 1

        let body = String(
            req.dropFirst("CREQ:".count)
        )
        let parts = body.split(
            separator: ",", maxSplits: 2
        )
        guard parts.count == 3 else {
            appendLine(
                "--- host: bad CREQ: \(body)"
            )
            return
        }
        let bolt = String(parts[1])
        let path = String(parts[2])

        let filePath =
            "\(repoRoot)/bloom/\(bolt)/\(path).md"
        appendLine(
            "--- host: CREQ \(bolt)/\(path)"
        )

        guard let fileData = FileManager.default
            .contents(atPath: filePath)
        else {
            let resp = "CRESP:404,00000000,0\n"
            if let d = resp.data(using: .utf8) {
                inputPipe?.fileHandleForWriting
                    .write(d)
            }
            appendLine("--- host: 404")
            return
        }

        let digest = hostDjb2(fileData)
        let hex = String(digest, radix: 16)
        let padded = String(
            repeating: "0",
            count: max(0, 8 - hex.count)
        ) + hex
        let hdr =
            "CRESP:200,\(padded),\(fileData.count)\n"
        if let hdrData = hdr.data(using: .utf8) {
            inputPipe?.fileHandleForWriting
                .write(hdrData)
            inputPipe?.fileHandleForWriting
                .write(fileData)
        }
        appendLine(
            "--- host: 200, \(fileData.count) bytes"
            + ", djb2=\(padded)"
        )
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
}
