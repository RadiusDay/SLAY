public final class AbsoluteLayoutSystem: LayoutSystem {
    /// The settings used by the absolute layout system.
    public struct LayoutSettings: Hashable, LayoutSystemSettingsProtocol {
        public var id: Self { self }
    }

    /// The properties used by the absolute layout system.
    public struct LayoutProperties: Hashable, LayoutSystemPropertiesProtocol {
        public var id: Self { self }
        /// The anchor point for positioning the UI object.
        /// (0,0) is the top-left corner, (1,1) is the bottom-right corner.
        public var anchorPoint: Vector2 = Vector2(x: 0, y: 0)
        /// The position of the UI object relative to its parent, using layout dimensions.
        public var x: LayoutDimension = .offset(0)
        /// The position of the UI object relative to its parent, using layout dimensions.
        public var y: LayoutDimension = .offset(0)

        /// Create a new instance of the layout settings.
        /// - Parameters:
        ///   - anchorPoint: The anchor point for positioning the UI object.
        ///   - x: The x position relative to the parent.
        ///   - y: The y position relative to the parent.
        public init(
            anchorPoint: Vector2 = Vector2(x: 0, y: 0),
            x: LayoutDimension = .offset(0),
            y: LayoutDimension = .offset(0)
        ) {
            self.anchorPoint = anchorPoint
            self.x = x
            self.y = y
        }
    }

    /// Create a new instance of the absolute layout system.
    public init() {}

    public func measure(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        parentSize: LayoutSystemMeasureResult
    ) -> LayoutSystemMeasureResult {
        return LayoutSystemMeasureResult(
            minWidth: uiObject.minWidth ?? .offset(0),
            maxWidth: uiObject.maxWidth ?? .offset(.infinity),
            width: uiObject.width,
            minHeight: uiObject.minHeight ?? .offset(0),
            maxHeight: uiObject.maxHeight ?? .offset(.infinity),
            height: uiObject.height
        )
    }

    public func resolve(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        measureResults: [UniqueID: LayoutSystemMeasureResult]
    ) -> LayoutSystemMeasureResult {
        return .init(
            minWidth: uiObject.minWidth ?? .offset(0),
            maxWidth: uiObject.maxWidth ?? .offset(.infinity),
            width: uiObject.width,
            minHeight: uiObject.minHeight ?? .offset(0),
            maxHeight: uiObject.maxHeight ?? .offset(.infinity),
            height: uiObject.height
        )
    }

    public func finalize(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        absoluteSize: Vector2,
        absolutePosition: Vector2,
        resolveResults: [UniqueID: LayoutSystemMeasureResult]
    ) -> [UniqueID: LayoutSystemFinalizedResult] {
        var results: [UniqueID: LayoutSystemFinalizedResult] = [:]
        let padding = uiObject.padding.getAbsolute(with: env.textDirection)
        let paddedPosition = Vector2(
            x: absolutePosition.x + padding.leading,
            y: absolutePosition.y + padding.top
        )
        let paddedSize = Vector2(
            x: absoluteSize.x - (padding.leading + padding.trailing),
            y: absoluteSize.y - (padding.top + padding.bottom)
        )

        for childID in uiObject.childrenOrder {
            guard let child = uiObject.children[childID] else { continue }
            let childLayout = resolveResults[child.id]!
            let childSettings =
                child.layoutProperties as? AbsoluteLayoutSystem.LayoutProperties
                ?? AbsoluteLayoutSystem.LayoutProperties()
            var resolved = childLayout.resolve(in: paddedSize)
            let finalizedSize = child.layoutSystem.getDependentSize(
                env: env,
                uiObject: child,
                resolveResults: resolveResults,
                width: resolved.width,
                height: resolved.height,
                minWidth: resolved.minWidth,
                minHeight: resolved.minHeight,
                maxWidth: resolved.maxWidth,
                maxHeight: resolved.maxHeight,
            )
            resolved.width = finalizedSize.0 ?? resolved.width
            resolved.height = finalizedSize.1 ?? resolved.height
            var result = resolved.smallestPossibleSize()
            if let ratio = child.aspectRatio {
                result = AspectRatio.solve(
                    ratio,
                    width: resolved.width,
                    height: resolved.height,
                    minWidth: resolved.minWidth,
                    minHeight: resolved.minHeight,
                    maxWidth: resolved.maxWidth,
                    maxHeight: resolved.maxHeight
                )
            }
            let childPosition = Vector2(
                x: paddedPosition.x + childSettings.x.resolve(parentSize: paddedSize.x)
                    - (result.x * childSettings.anchorPoint.x),
                y: paddedPosition.y + childSettings.y.resolve(parentSize: paddedSize.y)
                    - (result.y * childSettings.anchorPoint.y)
            )
            results[childID] = LayoutSystemFinalizedResult(
                absolutePosition: childPosition,
                absoluteSize: result
            )
        }
        return results
    }

    public func getDependentSize(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        resolveResults: [UniqueID: LayoutSystemMeasureResult],
        width: Double?,
        height: Double?,
        minWidth: Double?,
        minHeight: Double?,
        maxWidth: Double?,
        maxHeight: Double?,
    ) -> (Double?, Double?) {
        let padding = uiObject.padding.getAbsolute(with: env.textDirection)
        let paddingWidth = padding.leading + padding.trailing
        let paddingHeight = padding.top + padding.bottom
        let clamppedWidth =
            width != nil ? nil : max(min(maxWidth ?? .infinity, paddingWidth), minWidth ?? 0)
        let clamppedHeight =
            height != nil ? nil : max(min(maxHeight ?? .infinity, paddingHeight), minHeight ?? 0)
        return (clamppedWidth, clamppedHeight)
    }
}
