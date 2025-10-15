import SLAY

/// A container that can hold other UI elements and apply background color, corner radius, and clipping.
open class Group: SyntheticUIObjectWithChildren {
    /// Local platform-specific data.
    public var userData: Any? = nil

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
    public private(set) var _clipToBounds: Bool = false
    /// Whether the group clips its children to its bounds.
    @MainActor public var clipToBounds: Bool {
        get { _clipToBounds }
        set {
            _clipToBounds = newValue
            (self as? GroupProtocol)?.setClipToBounds(clipToBounds)
        }
    }

    typealias Children = any UIObject
}
