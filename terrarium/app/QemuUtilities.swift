// QemuUtilities -- QMP socket protocol and PPM image parsing.
//
// Free functions for QEMU screendump capture over QMP Unix sockets
// and P6 PPM binary image decoding into NSImage.

import AppKit
import Darwin

// -- QMP over Unix socket -------------------------------------------

func qmpScreendump(
    socketPath: String,
    outputPath: String
) -> Bool {
    let fd = socket(AF_UNIX, SOCK_STREAM, 0)
    guard fd >= 0 else { return false }
    defer { Darwin.close(fd) }

    var addr = sockaddr_un()
    addr.sun_family = sa_family_t(AF_UNIX)
    withUnsafeMutablePointer(
        to: &addr.sun_path.0
    ) { dst in
        socketPath.withCString { src in
            _ = strcpy(dst, src)
        }
    }

    let connectOK = withUnsafePointer(to: &addr) {
        $0.withMemoryRebound(
            to: sockaddr.self, capacity: 1
        ) {
            connect(
                fd, $0,
                socklen_t(
                    MemoryLayout<sockaddr_un>.size
                )
            )
        }
    }
    guard connectOK == 0 else { return false }

    _ = qmpRecv(fd)

    let cap =
        "{\"execute\":\"qmp_capabilities\"}\n"
    qmpSend(fd, cap)
    _ = qmpRecv(fd)

    let cmd = "{\"execute\":\"screendump\","
        + "\"arguments\":{\"filename\":\""
        + outputPath + "\"}}\n"
    qmpSend(fd, cmd)
    let resp = qmpRecv(fd)

    return resp.contains("return")
}

func qmpSend(_ fd: Int32, _ msg: String) {
    let bytes = Array(msg.utf8)
    _ = Darwin.write(fd, bytes, bytes.count)
}

func qmpRecv(_ fd: Int32) -> String {
    var pfd = pollfd(
        fd: fd, events: Int16(POLLIN), revents: 0
    )
    let ready = poll(&pfd, 1, 3000)
    guard ready > 0 else { return "" }

    var buf = [UInt8](repeating: 0, count: 4096)
    let n = Darwin.read(fd, &buf, buf.count - 1)
    guard n > 0 else { return "" }
    return String(
        bytes: buf[0..<n], encoding: .utf8
    ) ?? ""
}

// -- PPM parsing ----------------------------------------------------

func parsePPM(path: String) -> NSImage? {
    guard let data = try? Data(
        contentsOf: URL(fileURLWithPath: path)
    ) else {
        return nil
    }

    guard data.count > 10,
          data[0] == 0x50, data[1] == 0x36
    else { return nil }

    var off = 2

    func skipWS() {
        while off < data.count {
            let c = data[off]
            if c == 0x23 {
                while off < data.count,
                      data[off] != 0x0a
                {
                    off += 1
                }
            } else if c == 0x20 || c == 0x09
                        || c == 0x0a || c == 0x0d
            {
                off += 1
            } else {
                break
            }
        }
    }

    func readInt() -> Int {
        skipWS()
        var val = 0
        while off < data.count {
            let c = data[off]
            if c >= 0x30, c <= 0x39 {
                val = val * 10 + Int(c - 0x30)
                off += 1
            } else {
                break
            }
        }
        return val
    }

    let width = readInt()
    let height = readInt()
    _ = readInt()
    guard width > 0, height > 0 else { return nil }

    off += 1

    let pixels = width * height
    guard data.count >= off + pixels * 3 else {
        return nil
    }

    var rgba = [UInt8](
        repeating: 255, count: pixels * 4
    )
    for i in 0..<pixels {
        let s = off + i * 3
        rgba[i * 4 + 0] = data[s + 0]
        rgba[i * 4 + 1] = data[s + 1]
        rgba[i * 4 + 2] = data[s + 2]
        rgba[i * 4 + 3] = 255
    }

    guard let provider = CGDataProvider(
        data: Data(rgba) as CFData
    ) else { return nil }

    guard let cgImg = CGImage(
        width: width,
        height: height,
        bitsPerComponent: 8,
        bitsPerPixel: 32,
        bytesPerRow: width * 4,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGBitmapInfo(
            rawValue: CGImageAlphaInfo
                .premultipliedLast.rawValue
        ),
        provider: provider,
        decode: nil,
        shouldInterpolate: false,
        intent: .defaultIntent
    ) else { return nil }

    return NSImage(
        cgImage: cgImg,
        size: NSSize(width: width, height: height)
    )
}
