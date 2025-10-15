/// Internal type for the layout system.
public protocol UIObject: UIBaseObject {
    /// Absolute position of the UI object.
    ///
    /// DO NOT SET THIS DIRECTLY. This is managed by the layout engine.
    var absolutePosition: Vector2 { get set }
    /// Absolute size of the UI object.
    ///
    /// DO NOT SET THIS DIRECTLY. This is managed by the layout engine.
    var absoluteSize: Vector2 { get set }

    /// Set the layout engine for the UI object.
    ///
    /// DO NOT CALL THIS UNLESS YOU KNOW WHAT YOU'RE DOING.
    func setLocalLayoutEngine(_ layoutEngine: LayoutEngine?)

    /// Set the parent of the UI object.
    ///
    /// DO NOT CALL THIS UNLESS YOU KNOW WHAT YOU'RE DOING.
    func setLocalParent(_ parent: (any UIObject & AnyObject)?)
}

/// A user interface object that can be laid out on the screen.
public protocol UIBaseObject {
    /// The unique identifier for the UI object.
    var id: UniqueID { get }

    /// Absolute position of the UI object.
    var absolutePosition: Vector2 { get }
    /// Absolute size of the UI object.
    var absoluteSize: Vector2 { get }

    /// Minimum width of the UI object.
    var minWidth: LayoutDimension? { get }
    /// Maximum width of the UI object.
    var maxWidth: LayoutDimension? { get }
    /// Preferred width of the UI object.
    var width: LayoutDimension? { get }
    /// Minimum height of the UI object.
    var minHeight: LayoutDimension? { get }
    /// Maximum height of the UI object.
    var maxHeight: LayoutDimension? { get }
    /// Preferred height of the UI object.
    var height: LayoutDimension? { get }

    /// Padding
    var padding: LayoutInsets { get }
    /// Aspect ratio (width / height)
    var aspectRatio: Double? { get }

    /// The layout engine
    ///
    /// Consumers: this must be weak.
    var layoutEngine: LayoutEngine? { get }
    /// The object's parent
    ///
    /// Consumers: this must be weak.
    var parent: (any UIObject)? { get }
    /// Children of the UI object.
    var children: [UniqueID: any UIObject] { get }
    /// The order of the children.
    var childrenOrder: [UniqueID] { get }

    /// The layout system to use for the UI object.
    var layoutSystem: any LayoutSystem { get }
    /// Layout settings for this object's layout system.
    var layoutSettings: (any LayoutSystemSettingsProtocol)? { get }
    /// Layout settings for the parent's layout system.
    var layoutProperties: (any LayoutSystemPropertiesProtocol)? { get }
}
