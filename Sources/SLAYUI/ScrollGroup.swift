import SLAY

/// A scrolling container that can hold other UI elements.
open class ScrollGroup: SyntheticUIObject {
    /// Local platform-specific data.
    public var userData: Any? = nil

    /// Scrolling direction options.
    public enum ScrollingDirection: Sendable, Hashable, Equatable {
        case none
        case horizontal
        case vertical
        case both
    }

    /// Scroll direction options.
    public enum ElasticScrollingBehavior: Sendable, Hashable, Equatable {
        case never
        case always
        case whenScrollable
    }

    /// Layout system specific to ScrollGroup elements.
    private final class ScrollGroupLayoutSystem: LayoutSystem {
        /// Do not use this. It will be ignored.
        public struct LayoutSettings: Hashable, LayoutSystemSettingsProtocol {
            public var id: Self { self }
        }
        /// Do not use this. It will be ignored.
        public struct LayoutProperties: Hashable, LayoutSystemPropertiesProtocol {
            public var id: Self { self }
        }

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
            guard let object = uiObject as? ScrollGroup else {
                return [:]
            }
            let padding = uiObject.padding.getAbsolute(with: env.layoutDirection)
            let paddedPosition = Vector2(
                x: absolutePosition.x + padding.leading,
                y: absolutePosition.y + padding.top
            )
            let paddedSize = Vector2(
                x: absoluteSize.x - (padding.leading + padding.trailing),
                y: absoluteSize.y - (padding.top + padding.bottom)
            )
            guard let child = object.contentView else {
                return [:]
            }

            let childLayout = resolveResults[child.id]!
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
                x: paddedPosition.x - object._contentOffset.x,
                y: paddedPosition.y - object._contentOffset.y
            )
            return [
                child.id: .init(absolutePosition: childPosition, absoluteSize: result)
            ]
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
            maxHeight: Double?
        ) -> (Double?, Double?) {
            guard let object = uiObject as? ScrollGroup else {
                return (nil, nil)
            }
            if width != nil && height != nil {
                return (nil, nil)
            }

            let padding = object.padding.getAbsolute(with: env.layoutDirection)
            let paddingWidth = padding.leading + padding.trailing
            let paddingHeight = padding.top + padding.bottom

            if let contentView = object.contentView {
                let childLayout = resolveResults[contentView.id]!
                var resolved: LayoutSystemMeasureResult.Resolved = .init()
                if let width {
                    let finalWidth = max(0, width - paddingWidth)
                    resolved.width = childLayout.width?.resolve(parentSize: finalWidth)
                    resolved.minWidth = childLayout.minWidth.resolve(parentSize: finalWidth)
                    resolved.maxWidth = childLayout.maxWidth.resolve(parentSize: finalWidth)
                } else {
                    resolved.width =
                        contentView.width?.hasOffset == true
                        ? childLayout.width?.resolve(parentSize: 0) : nil
                    resolved.minWidth =
                        childLayout.minWidth.hasOffset
                        ? childLayout.minWidth.resolve(parentSize: 0) : 0
                    resolved.maxWidth =
                        childLayout.maxWidth.hasOffset
                        ? childLayout.maxWidth.resolve(parentSize: 0) : .infinity
                }
                if let height {
                    let finalHeight = max(0, height - paddingHeight)
                    resolved.height = childLayout.height?.resolve(parentSize: finalHeight)
                    resolved.minHeight = childLayout.minHeight.resolve(parentSize: finalHeight)
                    resolved.maxHeight = childLayout.maxHeight.resolve(parentSize: finalHeight)
                } else {
                    resolved.height =
                        childLayout.height?.hasOffset == true
                        ? childLayout.height?.resolve(parentSize: 0) : nil
                    resolved.minHeight =
                        childLayout.minHeight.hasOffset
                        ? childLayout.minHeight.resolve(parentSize: 0) : 0
                    resolved.maxHeight =
                        childLayout.maxHeight.hasOffset
                        ? childLayout.maxHeight.resolve(parentSize: 0) : .infinity
                }
                let finalizedSize = contentView.layoutSystem.getDependentSize(
                    env: env,
                    uiObject: contentView,
                    resolveResults: resolveResults,
                    width: resolved.width,
                    height: resolved.height,
                    minWidth: resolved.minWidth,
                    minHeight: resolved.minHeight,
                    maxWidth: resolved.maxWidth,
                    maxHeight: resolved.maxHeight
                )
                if let aspectRatio = contentView.aspectRatio {
                    let solved = AspectRatio.solve(
                        aspectRatio,
                        width: finalizedSize.0 ?? resolved.width,
                        height: finalizedSize.1 ?? resolved.height,
                        minWidth: resolved.minWidth,
                        minHeight: resolved.minHeight,
                        maxWidth: resolved.maxWidth,
                        maxHeight: resolved.maxHeight
                    )
                    resolved.width = solved.x
                    resolved.height = solved.y
                }
                let clamppedWidth =
                    width != nil
                    ? nil
                    : max(
                        min(
                            min(maxWidth ?? .infinity, paddingWidth),
                            (finalizedSize.0 ?? .infinity) + paddingWidth
                        ),
                        minWidth ?? 0
                    )
                let clamppedHeight =
                    height != nil
                    ? nil
                    : max(
                        min(
                            min(maxHeight ?? .infinity, paddingHeight),
                            (finalizedSize.1 ?? .infinity) + paddingHeight
                        ),
                        minHeight ?? 0
                    )
                return (clamppedWidth, clamppedHeight)
            }

            let clamppedWidth =
                width != nil ? nil : max(min(maxWidth ?? .infinity, paddingWidth), minWidth ?? 0)
            let clamppedHeight =
                height != nil
                ? nil : max(min(maxHeight ?? .infinity, paddingHeight), minHeight ?? 0)
            return (clamppedWidth, clamppedHeight)
        }
    }

    /// The scroll group's layout engine.
    private let scrollLayoutSystem = ScrollGroupLayoutSystem()
    /// Override the layout system to use the text-specific layout system.
    public override var layoutSystem: any LayoutSystem {
        get { scrollLayoutSystem }
        set {}
    }
    /// The background color of the group.
    ///
    /// This is a non-isolated way to get the current value of the background color.
    public private(set) var _backgroundColor: Color = .clear
    /// The background color of the group.
    @MainActor public var backgroundColor: Color {
        get { _backgroundColor }
        set {
            _backgroundColor = newValue
            (self as? GroupProtocol)?.setBackgroundColor(backgroundColor)
        }
    }
    /// The corner radius of the group.
    ///
    /// This is a non-isolated way to get the current value of the corner radius.
    public private(set) var _cornerRadius: Double = 0
    /// The corner radius of the group.
    @MainActor public var cornerRadius: Double {
        get { _cornerRadius }
        set {
            _cornerRadius = newValue
            (self as? GroupProtocol)?.setCornerRadius(cornerRadius)
        }
    }
    /// The transform origin of the group.
    ///
    /// This is a non-isolated way to get the current value of the transform origin.
    public private(set) var _transformOrigin: Vector2 = Vector2(x: 0.5, y: 0.5)
    /// The transform origin of the group.
    @MainActor public var transformOrigin: Vector2 {
        get { _transformOrigin }
        set {
            _transformOrigin = newValue
            (self as? GroupProtocol)?.setTransformOrigin(_transformOrigin)
        }
    }
    /// The rotation angle of the group in degrees.
    ///
    /// This is a non-isolated way to get the current value of the rotation angle.
    public private(set) var _rotation: Double = 0
    /// The rotation angle of the group in degrees.
    @MainActor public var rotation: Double {
        get { _rotation }
        set {
            _rotation = newValue
            (self as? GroupProtocol)?.setRotation(_rotation)
        }
    }
    /// The scale factor of the group.
    ///
    /// This is a non-isolated way to get the current value of the scale factor.
    public private(set) var _scale: Double = 1.0
    /// The scale factor of the group.
    @MainActor public var scale: Double {
        get { _scale }
        set {
            _scale = newValue
            (self as? GroupProtocol)?.setScale(_scale)
        }
    }
    /// Whether the group clips its children to its bounds.
    ///
    /// This is a non-isolated way to get the current value of the clipping property.
    public private(set) var _clipToBounds: Bool = true
    /// Whether the group clips its children to its bounds.
    @MainActor public var clipToBounds: Bool {
        get { _clipToBounds }
        set {
            _clipToBounds = newValue
            (self as? GroupProtocol)?.setClipToBounds(clipToBounds)
        }
    }
    /// The content view.
    public private(set) var contentView: (any UIObject)? = nil
    /// The content offset of the scroll group.
    ///
    /// This is a non-isolated way to get the current value of the content offset.
    ///
    /// DO NOT SET THIS UNLESS YOU KNOW WHAT YOU ARE DOING.
    public var _contentOffset: Vector2 = .zero
    /// The content offset of the scroll group.
    @MainActor public var contentOffset: Vector2 {
        get { _contentOffset }
        set {
            _contentOffset = newValue
            (self as? ScrollGroupProtocol)?.setContentOffset(_contentOffset)
        }
    }
    /// The scrolling direction of the scroll group.
    ///
    /// This is a non-isolated way to get the current value of the scroll direction.
    public var _scrollingDirection: ScrollingDirection = .none
    /// The scrolling direction of the scroll group.
    @MainActor public var scrollDirection: ScrollingDirection {
        get { _scrollingDirection }
        set {
            _scrollingDirection = newValue
            (self as? ScrollGroupProtocol)?.setScrollingDirection(_scrollingDirection)
        }
    }
    /// The scroll anchor point.
    ///
    /// This is where the content will be anchored when the scroll group is resized.
    /// (0, 0) is the top-left corner, (1, 1) is the bottom-right corner.
    public var scrollAnchor: Vector2 = .zero
    /// The directions of which elastic scrolling is enabled.
    ///
    /// This is a non-isolated way to get the current value of the scroll direction.
    public var _elasticScrollingBehavior: ElasticScrollingBehavior = .always
    /// The directions of which elastic scrolling is enabled.
    @MainActor public var elasticScrollingBehavior: ElasticScrollingBehavior {
        get { _elasticScrollingBehavior }
        set {
            _elasticScrollingBehavior = newValue
            (self as? ScrollGroupProtocol)?.setElasticScrollingBehavior(_elasticScrollingBehavior)
        }
    }

    public override var childrenOrder: [UniqueID] {
        guard let contentView else {
            return []
        }
        return [contentView.id]
    }
    public override var children: [UniqueID: any UIObject] {
        guard let contentView else {
            return [:]
        }
        return [contentView.id: contentView]
    }

    public override func removeChild(_ id: UniqueID) {
        if contentView?.id == id {
            contentView = nil
        }
    }

    public func setContent(_ child: (any UIObject)?) {
        if let oldValue = contentView {
            oldValue.removeFromParent()
        }
        if let newValue = child {
            newValue.setLocalParent(self)
            LayoutEngine.modifyEngine(for: newValue, with: self.layoutEngine)
        }
        contentView = child
    }
}
