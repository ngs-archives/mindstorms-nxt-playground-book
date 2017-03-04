extension Int {
    public func times(f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
}
