/// A one-dimensional layout dimension with two components. A relative scale and an absolute offset.
public struct LayoutDimension: Sendable, Hashable, Equatable {
    /// The relative scale component of the dimension.
    public var scale: Double
    /// The absolute offset component of the dimension in pixels.
    public var offset: Double
    /// If it has a offset component.
    public var hasOffset: Bool {
        return offset != 0
    }

    /// Create a new `LayoutDimension` with the specified scale and offset.
    /// - Parameters:
    ///   - scale: The relative scale component.
    ///   - offset: The absolute offset component.
    public init(scale: Double, offset: Double) {
        self.scale = scale
        self.offset = offset
    }

    /// Create a new `LayoutDimension` with the specified scale and an offset of zero.
    /// - Parameter scale: The relative scale component.
    public static func scale(_ scale: Double) -> LayoutDimension {
        return LayoutDimension(scale: scale, offset: 0)
    }

    /// Create a new `LayoutDimension` with the specified offset and a scale of zero.
    /// - Parameter offset: The absolute offset component.
    public static func offset(_ offset: Double) -> LayoutDimension {
        return LayoutDimension(scale: 0, offset: offset)
    }

    /// Resolve the layout dimension to an absolute value based on a given total size.
    /// - Parameter parentSize: The total size to resolve against.
    /// - Returns: The resolved absolute value.
    public func resolve(parentSize: Double) -> Double {
        return (scale * parentSize) + offset
    }
}
