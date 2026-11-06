// InlineArray + Equatable -- retroactive conformance until the stdlib ships it.
// Swift 6.3.3 does not synthesize Equatable for InlineArray<N, E> where E: Equatable,
// so SkateCore types storing InlineArray cannot rely on synthesized conformance.
// This extension fills the gap. When a future Swift version adds it natively,
// the @retroactive annotation ensures a clean migration.

@available(macOS 26.0, *)
extension InlineArray: @retroactive Equatable where Element: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    for i in 0..<lhs.count {
      if lhs[i] != rhs[i] { return false }
    }
    return true
  }
}
