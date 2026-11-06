/// A platform-neutral input event for the Surf and Skate core.
///
/// AppKit translates its callbacks into these values. The enum
/// carries only what the headless core needs to respond: which
/// key or button, and where the pointer sat. No NSEvent escapes
/// this boundary.
@available(macOS 26.0, *)
public enum SkateEvent: Sendable, Equatable {
    case keyDown(keyCode: UInt16, character: UInt8)
    case keyUp(keyCode: UInt16, character: UInt8)
    case mouseDown(row: Int, column: Int)
    case mouseMove(row: Int, column: Int)
    case mouseUp(row: Int, column: Int)
}
