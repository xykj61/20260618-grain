// TimelineView -- playback position indicator for the
// Lotus Audio tab. A thin horizontal bar with a moving
// playhead line that shows the current position within
// the clip.

import AppKit

@available(macOS 26.0, *)
class TimelineView: NSView {
    private var fraction: CGFloat = 0.0
    private let barColor = NSColor(
        red: 0.15, green: 0.12,
        blue: 0.07, alpha: 1.0
    )
    private let trackColor = NSColor(
        red: 0.25, green: 0.2,
        blue: 0.12, alpha: 1.0
    )
    private let playedColor = NSColor(
        red: 0.9, green: 0.65,
        blue: 0.3, alpha: 0.6
    )
    private let headColor = NSColor(
        red: 1.0, green: 0.8,
        blue: 0.4, alpha: 1.0
    )
    private let tickColor = NSColor(
        red: 0.3, green: 0.25,
        blue: 0.15, alpha: 0.8
    )

    override var isFlipped: Bool { true }

    override init(frame: NSRect) {
        super.init(frame: frame)
        wantsLayer = true
        layer?.backgroundColor = barColor.cgColor
        layer?.cornerRadius = 3
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func updatePosition(fraction: CGFloat) {
        let clamped = min(max(fraction, 0.0), 1.0)
        if abs(self.fraction - clamped) > 0.001 {
            self.fraction = clamped
            needsDisplay = true
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?
            .cgContext
        else { return }

        let w = bounds.width
        let h = bounds.height

        ctx.setFillColor(barColor.cgColor)
        ctx.fill(bounds)

        let trackInset: CGFloat = 2.0
        let trackRect = CGRect(
            x: trackInset,
            y: trackInset,
            width: w - trackInset * 2,
            height: h - trackInset * 2
        )
        ctx.setFillColor(trackColor.cgColor)
        let trackPath = CGPath(
            roundedRect: trackRect,
            cornerWidth: 2, cornerHeight: 2,
            transform: nil
        )
        ctx.addPath(trackPath)
        ctx.fillPath()

        drawTicks(ctx, w: w, h: h)

        let playedW = (w - trackInset * 2)
            * fraction
        if playedW > 0.5 {
            let playedRect = CGRect(
                x: trackInset,
                y: trackInset,
                width: playedW,
                height: h - trackInset * 2
            )
            ctx.setFillColor(playedColor.cgColor)
            let playedPath = CGPath(
                roundedRect: playedRect,
                cornerWidth: 2, cornerHeight: 2,
                transform: nil
            )
            ctx.addPath(playedPath)
            ctx.fillPath()
        }

        let headX = trackInset + playedW
        ctx.setStrokeColor(headColor.cgColor)
        ctx.setLineWidth(2.0)
        ctx.move(to: CGPoint(x: headX, y: 0))
        ctx.addLine(
            to: CGPoint(x: headX, y: h)
        )
        ctx.strokePath()

        let dotR: CGFloat = 3.0
        ctx.setFillColor(headColor.cgColor)
        ctx.fillEllipse(
            in: CGRect(
                x: headX - dotR,
                y: h / 2 - dotR,
                width: dotR * 2,
                height: dotR * 2
            )
        )
    }

    private func drawTicks(
        _ ctx: CGContext,
        w: CGFloat, h: CGFloat
    ) {
        ctx.setStrokeColor(tickColor.cgColor)
        ctx.setLineWidth(0.5)
        for i in 1..<4 {
            let x = w * CGFloat(i) / 4.0
            ctx.move(
                to: CGPoint(x: x, y: 1)
            )
            ctx.addLine(
                to: CGPoint(x: x, y: h - 1)
            )
        }
        ctx.strokePath()
    }
}
