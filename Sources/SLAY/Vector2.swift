/// A structure representing a 2D vector.
public struct Vector2: Sendable, Hashable, Equatable, CustomStringConvertible {
    /// The x component of the vector.
    public var x: Double
    /// The y component of the vector.
    public var y: Double

    /// Create a new `Vector2` with the specified x and y components.
    /// - Parameters:
    ///   - x: The x component.
    ///   - y: The y component.
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public var description: String {
        return "<Vec2 \(x), \(y)>"
    }

    public static let zero = Vector2(x: 0, y: 0)
}
