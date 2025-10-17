import SLAY

open class Text: SyntheticUIObject {
    /// Local platform-specific data.
    public var userData: Any? = nil

    /// Text alignment options for multiline text.
    public enum MultilineTextAlignment: Sendable, Hashable, Equatable {
        case leading
        case center
        case trailing
    }

    /// Layout system specific to Text elements.
    private final class TextLayoutSystem: LayoutSystem {
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
            let object = uiObject as? Text
            guard let object else {
                return LayoutSystemMeasureResult(
                    minWidth: uiObject.minWidth ?? .offset(0),
                    maxWidth: uiObject.maxWidth ?? .offset(.infinity),
                    width: uiObject.width,
                    minHeight: uiObject.minHeight ?? .offset(0),
                    maxHeight: uiObject.maxHeight ?? .offset(.infinity),
                    height: uiObject.height
                )
            }
            let ideals = (object as? TextProtocol)?.calculateSize(ideals: nil) ?? .zero
            return LayoutSystemMeasureResult(
                minWidth: uiObject.minWidth ?? .offset(0),
                maxWidth: uiObject.maxWidth ?? .offset(.infinity),
                width: uiObject.width ?? .offset(ideals.x),
                minHeight: uiObject.minHeight ?? .offset(0),
                maxHeight: uiObject.maxHeight ?? .offset(.infinity),
                height: uiObject.height ?? .offset(ideals.y)
            )
        }

        public func finalize(
            env: LayoutEngine.Environment,
            uiObject: any UIBaseObject,
            absoluteSize: Vector2,
            absolutePosition: Vector2,
            resolveResults: [UniqueID: LayoutSystemMeasureResult]
        ) -> [UniqueID: LayoutSystemFinalizedResult] {
            return [:]
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
            guard let object = uiObject as? Text else {
                return (nil, nil)
            }
            if width != nil && height != nil {
                return (nil, nil)
            }
            let ideals = Vector2(
                x: width ?? maxWidth ?? .infinity,
                y: height ?? maxHeight ?? .infinity
            )
            let size = (object as? TextProtocol)?.calculateSize(ideals: ideals) ?? .zero
            return (
                max(min(size.x, maxWidth ?? .infinity), minWidth ?? 0),
                max(min(size.y, maxHeight ?? .infinity), minHeight ?? 0)
            )
        }
    }

    /// The layout system used for text elements.
    private let textLayoutSystem = TextLayoutSystem()
    /// Override the layout system to use the text-specific layout system.
    public override var layoutSystem: any LayoutSystem {
        get { textLayoutSystem }
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
    /// The text content of the Text object.
    ///
    /// This is a non-isolated way to get the current value of the text.
    public private(set) var _text: String = ""
    /// The text content of the Text object.
    @MainActor public var text: String {
        get {
            _text
        }
        set {
            _text = newValue
            layoutEngine?.needsLayout = true
            (self as? TextProtocol)?.setText(newValue)
        }
    }
    /// The font used for rendering the text.
    ///
    /// This is a non-isolated way to get the current value of the font.
    public private(set) var _font: Font = .system
    /// The font used for rendering the text.
    @MainActor public var font: Font {
        get {
            _font
        }
        set {
            _font = newValue
            layoutEngine?.needsLayout = true
            (self as? TextProtocol)?.setFont(newValue)
        }
    }
    /// The multiline text alignment.
    ///
    /// This is a non-isolated way to get the current value of the alignment.
    public private(set) var _multilineTextAlignment: MultilineTextAlignment = .leading
    /// The multiline text alignment.
    @MainActor public var multilineTextAlignment: MultilineTextAlignment {
        get {
            _multilineTextAlignment
        }
        set {
            _multilineTextAlignment = newValue
            layoutEngine?.needsLayout = true
            (self as? TextProtocol)?.setMultilineTextAlignment(newValue)
        }
    }
    /// The color of the text.
    ///
    /// This is a non-isolated way to get the current value of the color.
    public private(set) var _color: Color = .black
    /// The color of the text.
    ///
    /// This is a non-isolated way to get the current value of the color.
    @MainActor public var color: Color {
        get {
            _color
        }
        set {
            _color = newValue
            layoutEngine?.needsLayout = true
            (self as? TextProtocol)?.setColor(newValue)
        }
    }
}
