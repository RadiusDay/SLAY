/// Data structure used for measuring UI elements in the layout system.
/// Contains optional minimum, maximum, and preferred dimensions.
public struct LayoutSystemMeasureResult: Sendable {
    public var minWidth: LayoutDimension = .offset(0)
    public var maxWidth: LayoutDimension = .offset(.infinity)
    public var width: LayoutDimension? = nil
    public var minHeight: LayoutDimension = .offset(0)
    public var maxHeight: LayoutDimension = .offset(.infinity)
    public var height: LayoutDimension? = nil

    public struct Resolved {
        public var minWidth: Double
        public var maxWidth: Double
        public var width: Double?
        public var minHeight: Double
        public var maxHeight: Double
        public var height: Double?

        /// Get the smallest possible size given the parent size.
        /// - Parameter parentSize: The size of the parent container.
        /// - Returns: The smallest possible size as a `Vector2`.
        public func smallestPossibleSize() -> Vector2 {
            return Vector2(
                x: max(max(minWidth, min(width ?? 0, maxWidth)), 0),
                y: max(max(minHeight, min(height ?? 0, maxHeight)), 0)
            )
        }

        /// Initialize a new `Resolved` instance.
        /// - Parameters:
        ///   - minWidth: The resolved minimum width.
        ///   - maxWidth: The resolved maximum width.
        ///   - width: The resolved preferred width.
        ///   - minHeight: The resolved minimum height.
        ///   - maxHeight: The resolved maximum height.
        ///   - height: The resolved preferred height.
        public init(
            minWidth: Double = 0,
            maxWidth: Double = .infinity,
            width: Double? = nil,
            minHeight: Double = 0,
            maxHeight: Double = .infinity,
            height: Double? = nil
        ) {
            self.minWidth = minWidth
            self.maxWidth = maxWidth
            self.width = width
            self.minHeight = minHeight
            self.maxHeight = maxHeight
            self.height = height
        }
    }

    /// Resolve the measure result into absolute values based on a given parent size.
    /// - Parameter parentSize: The size of the parent container.
    /// - Returns: A `Vector2` containing the resolved width and height.
    public func resolve(in parentSize: Vector2) -> Resolved {
        return Resolved(
            minWidth: minWidth.resolve(parentSize: parentSize.x),
            maxWidth: maxWidth.resolve(parentSize: parentSize.x),
            width: width?.resolve(parentSize: parentSize.x),
            minHeight: minHeight.resolve(parentSize: parentSize.y),
            maxHeight: maxHeight.resolve(parentSize: parentSize.y),
            height: height?.resolve(parentSize: parentSize.y)
        )
    }

    /// Initialize a new `LayoutSystemMeasureResult` instance.
    /// - Parameters:
    ///   - minWidth: The minimum width as a `LayoutDimension`.
    ///   - maxWidth: The maximum width as a `LayoutDimension`.
    ///   - width: The preferred width as an optional `LayoutDimension`.
    ///   - minHeight: The minimum height as a `LayoutDimension`.
    ///   - maxHeight: The maximum height as a `LayoutDimension`.
    ///   - height: The preferred height as an optional `LayoutDimension`.
    /// - Returns: A new instance of `LayoutSystemMeasureResult`.
    public init(
        minWidth: LayoutDimension = .offset(0),
        maxWidth: LayoutDimension = .offset(.infinity),
        width: LayoutDimension? = nil,
        minHeight: LayoutDimension = .offset(0),
        maxHeight: LayoutDimension = .offset(.infinity),
        height: LayoutDimension? = nil
    ) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.width = width
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.height = height
    }
}

/// Finalized layout data structure containing absolute position and size.
/// This is used after the layout has been resolved and finalized.
public struct LayoutSystemFinalizedResult: Sendable {
    public var absolutePosition: Vector2
    public var absoluteSize: Vector2

    /// Initialize a new `LayoutSystemFinalizedResult` instance.
    /// - Parameters:
    ///   - absolutePosition: The absolute position of the UI element.
    ///   - absoluteSize: The absolute size of the UI element.
    public init(absolutePosition: Vector2, absoluteSize: Vector2) {
        self.absolutePosition = absolutePosition
        self.absoluteSize = absoluteSize
    }
}

public protocol LayoutSystemPropertiesProtocol: Identifiable, Equatable {}
public protocol LayoutSystemSettingsProtocol: Identifiable, Equatable {}

/// A protocol that defines a layout system for arranging UI elements.
public protocol LayoutSystem: Identifiable {
    associatedtype LayoutSettings: LayoutSystemSettingsProtocol
    associatedtype LayoutProperties: LayoutSystemPropertiesProtocol

    /// The measure phase of the layout system.
    ///
    /// This is a downward pass that calculates the size requirements of the UI elements.
    func measure(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        parentSize: LayoutSystemMeasureResult
    ) -> LayoutSystemMeasureResult

    /// The layout phase of the layout system.
    ///
    /// This is an upward pass that determines the final positions and sizes of the UI elements.
    func resolve(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        measureResults: [UniqueID: LayoutSystemMeasureResult]
    ) -> LayoutSystemMeasureResult

    /// Finalize the layout of the UI elements.
    ///
    /// This is a downward pass that applies the calculated positions and sizes to the UI elements.
    func finalize(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        absoluteSize: Vector2,
        absolutePosition: Vector2,
        resolveResults: [UniqueID: LayoutSystemMeasureResult]
    ) -> [UniqueID: LayoutSystemFinalizedResult]

    /// Get dependent sizes based on resolved measurements.
    func getDependentSize(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        resolveResults: [UniqueID: LayoutSystemMeasureResult],
        width: Double?,
        height: Double?,
        minWidth: Double?,
        minHeight: Double?,
        maxWidth: Double?,
        maxHeight: Double?,
    ) -> (Double?, Double?)
}
