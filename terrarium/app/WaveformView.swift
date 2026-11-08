// WaveformView -- pixel-buffer waveform rendering for the
// Lotus Audio tab. Follows the FrameGridView pattern: NSView
// subclass, override draw, CGContext, needsDisplay = true.

import AppKit

@available(macOS 26.0, *)
class WaveformView: NSView {
    private var samples: [Float] = []
    private let waveColor = NSColor(
        red: 0.9, green: 0.65,
        blue: 0.3, alpha: 1.0
    )
    private let bgColor = NSColor(
        red: 0.08, green: 0.06,
        blue: 0.03, alpha: 1.0
    )
    private let gridColor = NSColor(
        red: 0.2, green: 0.16,
        blue: 0.1, alpha: 0.5
    )

    override var isFlipped: Bool { true }

    override init(frame: NSRect) {
        super.init(frame: frame)
        wantsLayer = true
        layer?.backgroundColor = bgColor.cgColor
        layer?.cornerRadius = 4
        generateSquareWave()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func generateSquareWave() {
        let count = 512
        let period = 306
        samples = (0..<count).map { i in
            return (i % period) < (period / 2)
                ? Float(1.0) : Float(-1.0)
        }
        needsDisplay = true
    }

    func update(buffer: [Float]) {
        samples = buffer
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?
            .cgContext
        else { return }

        let w = bounds.width
        let h = bounds.height

        ctx.setFillColor(bgColor.cgColor)
        ctx.fill(bounds)

        drawGrid(ctx, w: w, h: h)

        guard !samples.isEmpty else { return }

        drawWaveform(ctx, w: w, h: h)
    }

    private func drawGrid(
        _ ctx: CGContext,
        w: CGFloat, h: CGFloat
    ) {
        ctx.setStrokeColor(gridColor.cgColor)
        ctx.setLineWidth(1.0)

        let midY = h / 2.0
        ctx.move(to: CGPoint(x: 0, y: midY))
        ctx.addLine(
            to: CGPoint(x: w, y: midY)
        )
        ctx.strokePath()

        let quarterY = h / 4.0
        ctx.setStrokeColor(
            gridColor.withAlphaComponent(0.25)
                .cgColor
        )
        ctx.move(
            to: CGPoint(x: 0, y: quarterY)
        )
        ctx.addLine(
            to: CGPoint(x: w, y: quarterY)
        )
        ctx.move(
            to: CGPoint(
                x: 0, y: h - quarterY
            )
        )
        ctx.addLine(
            to: CGPoint(
                x: w, y: h - quarterY
            )
        )
        ctx.strokePath()
    }

    private func drawWaveform(
        _ ctx: CGContext,
        w: CGFloat, h: CGFloat
    ) {
        let midY = h / 2.0
        let amplitude = h * 0.4
        let count = samples.count

        ctx.setStrokeColor(waveColor.cgColor)
        ctx.setLineWidth(2.0)
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)

        let startX: CGFloat = 0
        let startY = midY
            - CGFloat(samples[0]) * amplitude
        ctx.move(
            to: CGPoint(x: startX, y: startY)
        )

        for i in 1..<count {
            let x = w * CGFloat(i)
                / CGFloat(count - 1)
            let y = midY
                - CGFloat(samples[i]) * amplitude
            ctx.addLine(
                to: CGPoint(x: x, y: y)
            )
        }
        ctx.strokePath()

        let fill = waveColor
            .withAlphaComponent(0.15).cgColor
        ctx.setFillColor(fill)

        ctx.move(
            to: CGPoint(x: 0, y: midY)
        )
        for i in 0..<count {
            let x = w * CGFloat(i)
                / CGFloat(count - 1)
            let y = midY
                - CGFloat(samples[i]) * amplitude
            ctx.addLine(
                to: CGPoint(x: x, y: y)
            )
        }
        ctx.addLine(
            to: CGPoint(x: w, y: midY)
        )
        ctx.closePath()
        ctx.fillPath()
    }
}
