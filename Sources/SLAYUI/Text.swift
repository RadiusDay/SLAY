import SLAY

public protocol TextProtocol: AnyObject {
    /// Calculate the ideal size of the text given optional ideal dimensions.
    /// - Parameter ideals: Optional ideal dimensions to constrain the text size.
    /// - Returns: The calculated ideal size as a `Vector2`.
    func calculateSize(
        ideals: Vector2?
    ) -> Vector2
    /// Set the text content.
    @MainActor func setText(_ text: String)
    /// Set the font of the text.
    @MainActor func setFont(_ font: Font)
    /// Set the color of the text.
    @MainActor func setColor(_ color: Color)
    /// Set the multiline text alignment.
    @MainActor func setMultilineTextAlignment(_ alignment: Text.MultilineTextAlignment)
    /// Clip the text to its bounds.
    @MainActor func setClipsToBounds(_ clips: Bool)
}

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
            let ideals = (object as? TextProtocol)?.calculateSize(ideals: nil) ?? .init(x: 0, y: 0)
            return LayoutSystemMeasureResult(
                minWidth: uiObject.minWidth ?? .offset(0),
                maxWidth: uiObject.maxWidth ?? .offset(.infinity),
                width: uiObject.width ?? .offset(ideals.x),
                minHeight: uiObject.minHeight ?? .offset(0),
                maxHeight: uiObject.maxHeight ?? .offset(.infinity),
                height: uiObject.height ?? .offset(ideals.y)
            )
        }

        func finalize(
            env: LayoutEngine.Environment,
            uiObject: any UIBaseObject,
            absoluteSize: Vector2,
            absolutePosition: Vector2,
            resolveResults: [UniqueID: LayoutSystemMeasureResult]
        ) -> [UniqueID: LayoutSystemFinalizedResult] {
            return [:]
        }

        func getDependentSize(
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
            let size = (object as? TextProtocol)?.calculateSize(ideals: ideals) ?? .init(x: 0, y: 0)
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

    /// If the text should clip to its bounds.
    ///
    /// This is a non-isolated way to get the current value of the clipsToBounds.
    public private(set) var _clipsToBounds: Bool = true
    /// If the text should clip to its bounds.
    @MainActor public var clipsToBounds: Bool {
        get {
            _clipsToBounds
        }
        set {
            _clipsToBounds = newValue
            (self as? TextProtocol)?.setClipsToBounds(newValue)
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
