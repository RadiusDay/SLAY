/// Layout engine that manages the layout of UI objects.
public final class LayoutEngine {
    public struct Environment {
        public var textDirection: TextDirection = .leftToRight
    }
    public struct PlacementInfo {
        public var parent: any UIObject
        public var object: any UIObject
        public var position: Vector2
        public var size: Vector2
    }

    private final class InternalRootUIObject: SyntheticUIObject {}

    private var internalRoot = InternalRootUIObject()
    public private(set) var rootNode: any UIObject
    public var env: Environment = Environment()
    public var objectPlacer: ((PlacementInfo) -> Void)? = nil
    public var needsLayout: Bool = true

    /// Create a new layout engine with the given root node.
    /// - Parameter rootNode: The root UI object to layout.
    public init() {
        self.rootNode = SyntheticUIObject()
    }

    /// Set the root node of the layout engine.
    /// - Parameter rootNode: The new root UI object.
    public func setRootNode(_ rootNode: any UIObject) {
        self.rootNode = rootNode
        rootNode.setLocalParent(internalRoot)
        LayoutEngine.modifyEngine(for: rootNode, with: self)
    }

    /// Modify the layout engine for a UI object and its descendants.
    /// - Parameters:
    ///   - object: The UI object to modify.
    ///   - engine: The new layout engine to set.
    internal static func modifyEngine(for object: any UIObject, with engine: LayoutEngine?) {
        var stack = [object]
        while !stack.isEmpty {
            let object = stack.removeLast()
            object.setLocalLayoutEngine(engine)
        }
    }

    /// Perform layout computation.
    public func compute() {
        guard needsLayout else { return }
        needsLayout = false

        var measureResults: [UniqueID: LayoutSystemMeasureResult] = [
            internalRoot.id: .init()
        ]

        // Measure phase (top-down)
        var virtualStack: [(parent: any UIObject, object: any UIObject)] = [
            (parent: internalRoot, object: rootNode)
        ]
        var discoveryStack: [(parent: any UIObject, object: any UIObject)] = [
            (parent: internalRoot, object: rootNode)
        ]
        while !virtualStack.isEmpty {
            let current = virtualStack.removeLast()
            let parent = current.parent
            let object = current.object

            let parentMeasure = measureResults[parent.id]!
            let measure = object.layoutSystem.measure(
                env: env,
                uiObject: object,
                parentSize: parentMeasure
            )
            measureResults[object.id] = measure

            for childID in object.childrenOrder.reversed() {
                if let child = object.children[childID] {
                    virtualStack.append((parent: object, object: child))
                    discoveryStack.append((parent: object, object: child))
                }
            }
        }

        // Resolve phase (bottom-up)
        var resolveResults: [UniqueID: LayoutSystemMeasureResult] = [:]
        while !discoveryStack.isEmpty {
            let current = discoveryStack.removeLast()
            let object = current.object

            let resolve = object.layoutSystem.resolve(
                env: env,
                uiObject: object,
                measureResults: measureResults
            )
            resolveResults[object.id] = resolve
        }

        // Calculate root size
        let sizing = resolveResults[rootNode.id]!
        var resolved = sizing.resolve(in: .init(x: 0, y: 0))
        let finalizedSize = rootNode.layoutSystem.getDependentSize(
            env: env,
            uiObject: rootNode,
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
        if let ratio = rootNode.aspectRatio {
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

        // Finalize phase (top-down)
        var finalizedResults: [UniqueID: LayoutSystemFinalizedResult] = [
            rootNode.id: .init(absolutePosition: .init(x: 0, y: 0), absoluteSize: result)
        ]
        virtualStack = [(parent: internalRoot, object: rootNode)]
        while !virtualStack.isEmpty {
            let current = virtualStack.removeLast()
            let parent = current.parent
            var object = current.object

            let selfFinalized = finalizedResults[object.id]!

            object.absolutePosition = selfFinalized.absolutePosition
            object.absoluteSize = selfFinalized.absoluteSize
            objectPlacer?(
                PlacementInfo(
                    parent: parent,
                    object: object,
                    position: selfFinalized.absolutePosition,
                    size: selfFinalized.absoluteSize
                )
            )
            let childrenFinalized = object.layoutSystem.finalize(
                env: env,
                uiObject: object,
                absoluteSize: selfFinalized.absoluteSize,
                absolutePosition: selfFinalized.absolutePosition,
                resolveResults: resolveResults
            )
            for (childID, childFinalized) in childrenFinalized {
                finalizedResults[childID] = childFinalized
            }
            for childID in object.childrenOrder.reversed() {
                if let child = object.children[childID] {
                    virtualStack.append((parent: object, object: child))
                }
            }
        }
    }
}
