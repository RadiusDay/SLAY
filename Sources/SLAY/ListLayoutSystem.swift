public final class ListLayoutSystem: LayoutSystem {
    /// The settings used by the absolute layout system.
    public struct LayoutSettings: Hashable, LayoutSystemSettingsProtocol {
        public var id: Self { self }

        public enum Direction: Int, Hashable, Equatable {
            case horizontal
            case horizontalReverse
            case horizontalLeftToRight
            case horizontalRightToLeft
            case vertical
            case verticalReverse

            public func horizontalLayout() -> Bool {
                switch self {
                case .horizontal, .horizontalReverse, .horizontalLeftToRight,
                    .horizontalRightToLeft:
                    return true
                case .vertical, .verticalReverse:
                    return false
                }
            }

            public func reversedLayout(_ layoutDirection: LayoutDirection) -> Bool {
                switch self {
                case .horizontalLeftToRight, .vertical:
                    return false
                case .horizontalRightToLeft, .verticalReverse:
                    return true
                case .horizontal:
                    return layoutDirection == .rightToLeft
                case .horizontalReverse:
                    return layoutDirection == .leftToRight
                }
            }
        }

        public enum MainAxisDistribution: Int, Hashable, Equatable {
            case start
            case center
            case end
            case spaceBetween
            case spaceAround
            case spaceEvenly
        }

        public enum CrossAxisDistribution: Int, Hashable, Equatable {
            case start
            case center
            case end
            case spaceBetween
            case spaceAround
            case spaceEvenly
            case stretch
        }

        public enum CrossAxisAlignment: Int, Hashable, Equatable {
            case start
            case center
            case end
            case stretch
        }

        public enum WrapMode: Int, Hashable, Equatable {
            case noWrap
            // case wrap
        }

        /// The direction of the children.
        public var direction: Direction = .horizontal
        /// The spacing between children in pixels.
        public var spacing: Double = 0
        /// Distribution along the main axis.
        public var mainAxisDistribution: MainAxisDistribution = .start
        /// Distribution along the cross axis.
        public var crossAxisDistribution: CrossAxisDistribution = .stretch
        /// Alignment along the cross axis.
        public var crossAxisAlignment: CrossAxisAlignment = .stretch
        /// Wrapping behavior.
        public var wrapMode: WrapMode = .noWrap

        /// Create a new instance of the layout settings.
        /// - Parameters:
        ///   - direction: The direction of the children.
        ///   - spacing: The spacing between children in pixels.
        ///   - mainAxisDistribution: Distribution along the main axis.
        ///   - crossAxisDistribution: Distribution along the cross axis.
        ///   - crossAxisAlignment: Alignment along the cross axis.
        ///   - wrapMode: Wrapping behavior.
        public init(
            direction: Direction = .horizontal,
            spacing: Double = 0,
            mainAxisDistribution: MainAxisDistribution = .start,
            crossAxisDistribution: CrossAxisDistribution = .stretch,
            crossAxisAlignment: CrossAxisAlignment = .stretch,
            wrapMode: WrapMode = .noWrap
        ) {
            self.direction = direction
            self.spacing = spacing
            self.mainAxisDistribution = mainAxisDistribution
            self.crossAxisDistribution = crossAxisDistribution
            self.crossAxisAlignment = crossAxisAlignment
            self.wrapMode = wrapMode
        }
    }

    /// The properties used by the absolute layout system.
    public enum LayoutProperties: Hashable, LayoutSystemPropertiesProtocol {
        public var id: Self { self }
        /// Properties for absolute positioning within a list layout.
        public struct Absolute: Identifiable, Hashable, Equatable {
            public var id: Self { self }
            /// The anchor point for positioning the UI object.
            /// (0,0) is the top-left corner, (1,1) is the bottom-right corner.
            public var anchorPoint: Vector2 = .zero
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
                anchorPoint: Vector2 = .zero,
                x: LayoutDimension = .offset(0),
                y: LayoutDimension = .offset(0)
            ) {
                self.anchorPoint = anchorPoint
                self.x = x
                self.y = y
            }
        }

        /// Properties for flex positioning within a list layout.
        public struct Item: Identifiable, Hashable, Equatable {
            public var id: Self { self }
            /// The flex grow factor.
            public var grow: Double = 0
            /// The flex shrink factor.
            public var shrink: Double = 1
            // /// The flex basis dimension.
            // public var basis: LayoutDimension = .offset(0)
            /// The alignment override for this item along the cross axis.
            public var crossAxisAlignment: LayoutSettings.CrossAxisAlignment? = nil
        }

        case item(Item)
        case absolute(Absolute)

        /// Create a new instance of a flex layout property.
        /// - Parameters:
        ///   - grow: The flex grow factor.
        ///   - shrink: The flex shrink factor.
        ///   - crossAxisAlignment: The alignment override for this item along the cross axis.
        public init(
            grow: Double = 0,
            shrink: Double = 1,
            basis: LayoutDimension = .offset(0),
            crossAxisAlignment: LayoutSettings.CrossAxisAlignment? = nil
        ) {
            self = .item(Item(grow: grow, shrink: shrink, crossAxisAlignment: crossAxisAlignment))
        }

        /// Create a new instance of an absolute layout property.
        /// - Parameters:
        ///   - anchorPoint: The anchor point for positioning the UI object.
        ///   - x: The x position relative to the parent.
        ///   - y: The y position relative to the parent.
        public init(
            anchorPoint: Vector2 = .zero,
            x: LayoutDimension = .offset(0),
            y: LayoutDimension = .offset(0)
        ) {
            self = .absolute(Absolute(anchorPoint: anchorPoint, x: x, y: y))
        }

        public static var defaultValue: LayoutProperties {
            return .item(Item())
        }
    }

    /// Create a new instance of the absolute layout system.
    public init() {}

    private func calculateFlex(
        env: LayoutEngine.Environment,
        uiObject: any UIBaseObject,
        resolveResults: [UniqueID: LayoutSystemMeasureResult],
        resolved: [UniqueID: (
            size: LayoutSystemMeasureResult.Resolved,
            properties: ListLayoutSystem.LayoutProperties.Item
        )],
        width: Double?,
        height: Double?,
        minWidth: Double,
        minHeight: Double,
        maxWidth: Double,
        maxHeight: Double
    ) -> ([UniqueID: Vector2], Vector2) {
        let settings =
            uiObject.layoutSettings as? ListLayoutSystem.LayoutSettings
            ?? ListLayoutSystem.LayoutSettings()
        let horizontalLayout = settings.direction.horizontalLayout()
        let padding = uiObject.padding.getAbsolute(with: env.layoutDirection)
        let horizontalPadding = padding.leading + padding.trailing
        let verticalPadding = padding.top + padding.bottom
        let mainAxisPadding =
            horizontalLayout ? horizontalPadding : verticalPadding
        let spacing = max(0, settings.spacing)

        var fixedSize = horizontalLayout ? width != nil : height != nil
        var childMain = 0.0
        var childCross = 0.0
        let maxMainAxis =
            horizontalLayout ? width ?? maxWidth : height ?? maxHeight
        var totalFlexGrow = 0.0
        var totalFlexShrink = 0.0
        var sizes: [UniqueID: Vector2] = [:]

        // Measure pass
        for id in uiObject.childrenOrder {
            guard let (size, properties) = resolved[id] else { continue }

            totalFlexGrow += max(0, properties.grow)
            totalFlexShrink += max(0, properties.shrink)

            let child = uiObject.children[id]!
            let finalizedSize = child.layoutSystem.getDependentSize(
                env: env,
                uiObject: child,
                resolveResults: resolveResults,
                width: size.width,
                height: size.height,
                minWidth: size.minWidth,
                minHeight: size.minHeight,
                maxWidth: size.maxWidth,
                maxHeight: size.maxHeight
            )
            var result = size.smallestPossibleSize()
            result.x = finalizedSize.0 ?? result.x
            result.y = finalizedSize.1 ?? result.y

            if let ratio = child.aspectRatio {
                result = AspectRatio.solve(
                    ratio,
                    width: size.width,
                    height: size.height,
                    minWidth: size.minWidth,
                    minHeight: size.minHeight,
                    maxWidth: size.maxWidth,
                    maxHeight: size.maxHeight
                )
            }

            let mainSize = horizontalLayout ? result.x : result.y
            let gap = childMain == 0 ? 0 : spacing

            if childMain + mainSize + gap > maxMainAxis - mainAxisPadding {
                fixedSize = true
            }

            childMain += mainSize + gap
            childCross = max(childCross, horizontalLayout ? result.y : result.x)
            sizes[id] = result
        }

        // Early return for size-measurement phase
        if !fixedSize {
            return (
                sizes,
                Vector2(
                    x: horizontalLayout
                        ? max(childMain + horizontalPadding, minWidth)
                        : max(childCross + horizontalPadding, minWidth),
                    y: horizontalLayout
                        ? max(childCross + verticalPadding, minHeight)
                        : max(childMain + verticalPadding, minHeight)
                )
            )
        }

        var remainingMain =
            (horizontalLayout ? width ?? maxWidth : height ?? maxHeight)
            - mainAxisPadding - childMain

        if remainingMain < 0 && totalFlexShrink > 0 {
            var unfrozen = Set<UniqueID>(sizes.keys)
            while remainingMain < 0 && !unfrozen.isEmpty {
                var anyFrozen = false

                var fastForward = 0.0
                var flexFastForward = 0.0
                for id in unfrozen {
                    guard let size = sizes[id],
                        let child = uiObject.children[id],
                        let res = resolved[id]
                    else { continue }

                    let properties = res.properties
                    let mainSize = horizontalLayout ? size.x : size.y
                    let shrink = max(0, properties.shrink)
                    guard shrink > 0 else { continue }

                    let shrinkAmount = (remainingMain * shrink) / totalFlexShrink
                    let newMainSize = mainSize + shrinkAmount

                    let clampedMain =
                        horizontalLayout
                        ? max(res.size.minWidth, min(res.size.maxWidth, newMainSize))
                        : max(res.size.minHeight, min(res.size.maxHeight, newMainSize))

                    let finalized = child.layoutSystem.getDependentSize(
                        env: env,
                        uiObject: child,
                        resolveResults: resolveResults,
                        width: horizontalLayout ? clampedMain : size.x,
                        height: horizontalLayout ? size.y : clampedMain,
                        minWidth: res.size.minWidth,
                        minHeight: res.size.minHeight,
                        maxWidth: res.size.maxWidth,
                        maxHeight: res.size.maxHeight
                    )

                    var result = res.size.smallestPossibleSize()
                    result.x = finalized.0 ?? result.x
                    result.y = finalized.1 ?? result.y

                    if let ratio = child.aspectRatio {
                        result = AspectRatio.solve(
                            ratio,
                            width: horizontalLayout ? clampedMain : size.x,
                            height: horizontalLayout ? size.y : clampedMain,
                            minWidth: res.size.minWidth,
                            minHeight: res.size.minHeight,
                            maxWidth: horizontalLayout
                                ? min(clampedMain, res.size.maxWidth) : size.x,
                            maxHeight: horizontalLayout
                                ? size.y : min(clampedMain, res.size.maxHeight)
                        )
                    }

                    let actualMain = min(
                        horizontalLayout ? result.x : result.y,
                        clampedMain
                    )
                    if horizontalLayout {
                        result.x = actualMain
                    } else {
                        result.y = actualMain
                    }

                    sizes[id] = result

                    if actualMain != newMainSize {
                        flexFastForward += shrink
                        unfrozen.remove(id)
                        anyFrozen = true
                    }

                    fastForward += (actualMain - mainSize)
                }

                remainingMain -= fastForward
                totalFlexShrink -= flexFastForward
                if !anyFrozen { break }
            }
        } else if remainingMain > 0 && totalFlexGrow > 0 {
            var unfrozen = Set<UniqueID>(sizes.keys)
            while remainingMain > 0 && !unfrozen.isEmpty {
                var anyFrozen = false

                var fastForward = 0.0
                var flexFastForward = 0.0
                for id in unfrozen {
                    guard let size = sizes[id],
                        let child = uiObject.children[id],
                        let res = resolved[id]
                    else { continue }

                    let properties = res.properties
                    let mainSize = horizontalLayout ? size.x : size.y
                    let grow = max(0, properties.grow)
                    guard grow > 0 else { continue }

                    let growAmount = (remainingMain * grow) / totalFlexGrow
                    let newMainSize = mainSize + growAmount

                    let clampedMain =
                        horizontalLayout
                        ? max(res.size.minWidth, min(res.size.maxWidth, newMainSize))
                        : max(res.size.minHeight, min(res.size.maxHeight, newMainSize))

                    let finalized = child.layoutSystem.getDependentSize(
                        env: env,
                        uiObject: child,
                        resolveResults: resolveResults,
                        width: horizontalLayout ? clampedMain : size.x,
                        height: horizontalLayout ? size.y : clampedMain,
                        minWidth: res.size.minWidth,
                        minHeight: res.size.minHeight,
                        maxWidth: res.size.maxWidth,
                        maxHeight: res.size.maxHeight
                    )

                    var result = res.size.smallestPossibleSize()
                    switch horizontalLayout {
                    case true:
                        result.x = finalized.0 ?? clampedMain
                    case false:
                        result.y = finalized.1 ?? clampedMain
                    }
                    result.x = finalized.0 ?? result.x
                    result.y = finalized.1 ?? result.y

                    if let ratio = child.aspectRatio {
                        result = AspectRatio.solve(
                            ratio,
                            width: horizontalLayout ? clampedMain : size.x,
                            height: horizontalLayout ? size.y : clampedMain,
                            minWidth: res.size.minWidth,
                            minHeight: res.size.minHeight,
                            maxWidth: horizontalLayout
                                ? min(clampedMain, res.size.maxWidth) : size.x,
                            maxHeight: horizontalLayout
                                ? size.y : min(clampedMain, res.size.maxHeight)
                        )
                    }

                    let actualMain = min(
                        horizontalLayout ? result.x : result.y,
                        clampedMain
                    )
                    if horizontalLayout {
                        result.x = actualMain
                    } else {
                        result.y = actualMain
                    }

                    sizes[id] = result

                    if actualMain != newMainSize {
                        flexFastForward += grow
                        unfrozen.remove(id)
                        anyFrozen = true
                    }

                    fastForward += (actualMain - mainSize)
                }

                remainingMain -= fastForward
                totalFlexGrow -= flexFastForward
                if !anyFrozen { break }
            }
        }

        // Final total size
        let totalMain =
            sizes.reduce(0.0) { $0 + (horizontalLayout ? $1.value.x : $1.value.y) }
            + max(0, Double(sizes.count - 1)) * spacing
        let totalCross = sizes.reduce(0.0) {
            max($0, horizontalLayout ? $1.value.y : $1.value.x)
        }

        let totalSize = Vector2(
            x: horizontalLayout
                ? max(minWidth, min(maxWidth, totalMain + horizontalPadding))
                : max(minWidth, min(maxWidth, totalCross + horizontalPadding)),
            y: horizontalLayout
                ? max(minHeight, min(maxHeight, totalCross + verticalPadding))
                : max(minHeight, min(maxHeight, totalMain + verticalPadding))
        )

        return (sizes, totalSize)
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
        let settings =
            uiObject.layoutSettings as? ListLayoutSystem.LayoutSettings
            ?? ListLayoutSystem.LayoutSettings()
        let horizontalLayout = settings.direction.horizontalLayout()
        let reversedLayout = settings.direction.reversedLayout(env.layoutDirection)
        var results: [UniqueID: LayoutSystemFinalizedResult] = [:]
        let padding = uiObject.padding.getAbsolute(with: env.layoutDirection)
        let paddedPosition = Vector2(
            x: absolutePosition.x + padding.leading,
            y: absolutePosition.y + padding.top
        )
        let paddedSize = Vector2(
            x: absoluteSize.x - (padding.leading + padding.trailing),
            y: absoluteSize.y - (padding.top + padding.bottom)
        )

        var flexSizes:
            [UniqueID: (
                size: LayoutSystemMeasureResult.Resolved,
                properties: ListLayoutSystem.LayoutProperties.Item
            )] = [:]

        for childID in uiObject.childrenOrder {
            guard let child = uiObject.children[childID] else { continue }
            let childLayout = resolveResults[child.id]!
            let childSettings =
                child.layoutProperties as? ListLayoutSystem.LayoutProperties
                ?? ListLayoutSystem.LayoutProperties.defaultValue
            let resolved = childLayout.resolve(in: paddedSize)

            if case .item(let itemSettings) = childSettings {
                flexSizes[child.id] = (size: resolved, properties: itemSettings)
                continue
            }

            let finalizedSize = child.layoutSystem.getDependentSize(
                env: env,
                uiObject: child,
                resolveResults: resolveResults,
                width: resolved.width,
                height: resolved.height,
                minWidth: resolved.minWidth,
                minHeight: resolved.minHeight,
                maxWidth: resolved.maxWidth,
                maxHeight: resolved.maxHeight
            )
            var result = resolved.smallestPossibleSize()
            result.x = finalizedSize.0 ?? result.x
            result.y = finalizedSize.1 ?? result.y
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
            guard case .absolute(let absSettings) = childSettings else { continue }
            let childPosition = Vector2(
                x: paddedPosition.x + absSettings.x.resolve(parentSize: paddedSize.x)
                    - (result.x * absSettings.anchorPoint.x),
                y: paddedPosition.y + absSettings.y.resolve(parentSize: paddedSize.y)
                    - (result.y * absSettings.anchorPoint.y)
            )
            results[childID] = LayoutSystemFinalizedResult(
                absolutePosition: childPosition,
                absoluteSize: result
            )
        }

        let (flexChildSizes, _) = calculateFlex(
            env: env,
            uiObject: uiObject,
            resolveResults: resolveResults,
            resolved: flexSizes,
            width: absoluteSize.x,
            height: absoluteSize.y,
            minWidth: absoluteSize.x,
            minHeight: absoluteSize.y,
            maxWidth: absoluteSize.x,
            maxHeight: absoluteSize.y
        )

        var mainAxisOffset = 0.0
        let defaultSpacing = max(0, settings.spacing)
        var spacing = 0.0
        let finalMain = horizontalLayout ? paddedSize.x : paddedSize.y
        let totalSize = flexChildSizes.reduce(0.0) {
            $0 + (horizontalLayout ? $1.value.x : $1.value.y)
        }
        let totalPadding = max(0, Double(flexChildSizes.count - 1)) * defaultSpacing
        let leftTopOffset = finalMain - totalSize - totalPadding
        switch settings.mainAxisDistribution {
        case .start:
            mainAxisOffset = reversedLayout ? leftTopOffset : 0
            spacing = defaultSpacing
        case .center:
            mainAxisOffset = leftTopOffset / 2
            spacing = defaultSpacing
        case .end:
            mainAxisOffset = reversedLayout ? 0 : leftTopOffset
            spacing = defaultSpacing
        case .spaceBetween:
            spacing =
                flexChildSizes.count > 1
                ? max(defaultSpacing, (finalMain - totalSize) / Double(flexChildSizes.count - 1))
                : 0
            mainAxisOffset =
                reversedLayout
                ? finalMain - totalSize - (spacing * Double(flexChildSizes.count - 1)) : 0

        case .spaceAround:
            spacing =
                flexChildSizes.count > 0
                ? max(defaultSpacing, (finalMain - totalSize) / Double(flexChildSizes.count))
                : 0
            let spaceBetweenOffset = max(
                0,
                (finalMain - totalSize) / Double(flexChildSizes.count * 2)
            )
            mainAxisOffset =
                reversedLayout
                ? finalMain - totalSize - spacing * Double(flexChildSizes.count - 1)
                    - spaceBetweenOffset
                : spaceBetweenOffset
        case .spaceEvenly:
            spacing =
                flexChildSizes.count > 0
                ? max(defaultSpacing, (finalMain - totalSize) / (Double(flexChildSizes.count) + 1))
                : 0
            let spaceEvenlyOffset = max(
                0,
                (finalMain - totalSize) / (Double(flexChildSizes.count) + 1)
            )
            mainAxisOffset =
                reversedLayout
                ? finalMain - totalSize - spacing * Double(flexChildSizes.count - 1)
                    - spaceEvenlyOffset
                : spaceEvenlyOffset
        }

        let crossAxisPadded = horizontalLayout ? paddedSize.y : paddedSize.x
        let childrenOrder =
            reversedLayout
            ? uiObject.childrenOrder.reversed()
            : uiObject.childrenOrder
        for childID in childrenOrder {
            guard let childSize = flexChildSizes[childID],
                let (resolved, itemSettings) = flexSizes[childID]
            else { continue }
            let crossAlign = itemSettings.crossAxisAlignment ?? settings.crossAxisAlignment
            let mainAxisSize = horizontalLayout ? childSize.x : childSize.y
            var crossAxisSize = horizontalLayout ? childSize.y : childSize.x
            var crossAxisOffset = 0.0
            switch crossAlign {
            case .start:
                crossAxisOffset = 0
            case .center:
                crossAxisOffset = (crossAxisPadded - crossAxisSize) / 2
            case .end:
                crossAxisOffset = crossAxisPadded - crossAxisSize
            case .stretch:
                crossAxisOffset = 0
                crossAxisSize =
                    horizontalLayout
                    ? max(resolved.minHeight, min(resolved.maxHeight, crossAxisPadded))
                    : max(resolved.minWidth, min(resolved.maxWidth, crossAxisPadded))
            }
            let childPosition = Vector2(
                x: horizontalLayout
                    ? paddedPosition.x + mainAxisOffset
                    : paddedPosition.x + crossAxisOffset,
                y: horizontalLayout
                    ? paddedPosition.y + crossAxisOffset
                    : paddedPosition.y + mainAxisOffset
            )
            let finalSize = Vector2(
                x: horizontalLayout ? mainAxisSize : crossAxisSize,
                y: horizontalLayout ? crossAxisSize : mainAxisSize
            )
            results[childID] = LayoutSystemFinalizedResult(
                absolutePosition: childPosition,
                absoluteSize: finalSize
            )
            mainAxisOffset += mainAxisSize + spacing
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
        let padding = uiObject.padding.getAbsolute(with: env.layoutDirection)

        // If both width and height are set, nothing to do
        if width != nil && height != nil {
            return (nil, nil)
        }

        let horizontalPadding = padding.leading + padding.trailing
        let verticalPadding = padding.top + padding.bottom

        // Filter out absolute positioned items
        var sizes:
            [UniqueID: (
                size: LayoutSystemMeasureResult.Resolved,
                properties: ListLayoutSystem.LayoutProperties.Item
            )] = [:]
        for childID in uiObject.childrenOrder {
            let child = uiObject.children[childID]!
            let childLayout = resolveResults[child.id]!
            let childSettings =
                child.layoutProperties as? ListLayoutSystem.LayoutProperties
                ?? ListLayoutSystem.LayoutProperties.defaultValue
            guard case .item(let childSettings) = childSettings else { continue }

            var resolved: LayoutSystemMeasureResult.Resolved = .init()
            if let width {
                let finalWidth = max(0, width - horizontalPadding)
                resolved.width = childLayout.width?.resolve(parentSize: finalWidth)
                resolved.minWidth = childLayout.minWidth.resolve(parentSize: finalWidth)
                resolved.maxWidth = childLayout.maxWidth.resolve(parentSize: finalWidth)
            } else {
                resolved.width =
                    childLayout.width?.hasOffset == true
                    ? childLayout.width?.resolve(parentSize: 0) : nil
                resolved.minWidth =
                    childLayout.minWidth.hasOffset
                    ? childLayout.minWidth.resolve(parentSize: 0) : 0
                resolved.maxWidth =
                    childLayout.maxWidth.hasOffset
                    ? childLayout.maxWidth.resolve(parentSize: 0) : .infinity
            }
            if let height {
                let finalHeight = max(0, height - verticalPadding)
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
            sizes[child.id] = (size: resolved, properties: childSettings)
        }

        if sizes.isEmpty {
            let finalWidth =
                width != nil
                ? nil : max(minWidth ?? 0, min(maxWidth ?? .infinity, horizontalPadding))
            let finalHeight =
                height != nil
                ? nil : max(minHeight ?? 0, min(maxHeight ?? .infinity, verticalPadding))
            return (finalWidth, finalHeight)
        }

        let (_, flexSize) = calculateFlex(
            env: env,
            uiObject: uiObject,
            resolveResults: resolveResults,
            resolved: sizes,
            width: width != nil ? max(0, width! - horizontalPadding) : nil,
            height: height != nil ? max(0, height! - verticalPadding) : nil,
            minWidth: max(0, (minWidth ?? 0) - horizontalPadding),
            minHeight: max(0, (minHeight ?? 0) - verticalPadding),
            maxWidth: max(0, (maxWidth ?? .infinity) - horizontalPadding),
            maxHeight: max(0, (maxHeight ?? .infinity) - verticalPadding)
        )

        return (flexSize.x, flexSize.y)
    }
}
