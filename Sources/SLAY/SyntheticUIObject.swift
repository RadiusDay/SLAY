/// A synthetic UI object that conforms to the `UIObject` protocol and uses a specified layout system.
///
/// If you want children, use `SyntheticUIObjectWithChildren`.
open class SyntheticUIObject: UIObject {
    // Id
    public var id = UniqueID.generate()

    // Generated
    public var absolutePosition = Vector2(x: 0, y: 0)
    public var absoluteSize = Vector2(x: 0, y: 0)

    // Sizing
    public var minWidth: LayoutDimension? {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var maxWidth: LayoutDimension? {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var width: LayoutDimension? {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var minHeight: LayoutDimension? {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var maxHeight: LayoutDimension? {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var height: LayoutDimension? {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var padding: LayoutInsets = LayoutInsets(all: 0) {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var aspectRatio: Double? = nil {
        didSet { layoutEngine?.needsLayout = true }
    }

    // Children
    private weak var _parent: (any UIObject & AnyObject)?
    public var parent: (any UIObject)? { _parent }
    open var children: [UniqueID: any UIObject] { [:] }
    open var childrenOrder: [UniqueID] { [] }

    // Layout system
    public weak var _layoutEngine: LayoutEngine?
    public var layoutEngine: LayoutEngine? { _layoutEngine }
    open var layoutSystem: any LayoutSystem = AbsoluteLayoutSystem() {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var layoutProperties: (any LayoutSystemPropertiesProtocol)? = nil {
        didSet { layoutEngine?.needsLayout = true }
    }
    public var layoutSettings: (any LayoutSystemSettingsProtocol)? = nil {
        didSet { layoutEngine?.needsLayout = true }
    }

    /// Set the layout engine for the UI object.
    public func setLocalLayoutEngine(_ layoutEngine: LayoutEngine?) {
        self._layoutEngine = layoutEngine
    }

    /// Set the parent of the UI object.
    public func setLocalParent(_ parent: (any UIObject & AnyObject)?) {
        self._parent = parent
    }

    public init() {}
}
