/// A structure representing a font with its properties.
public struct Font: Sendable, Hashable, Equatable {
    /// The style of the font.
    public enum FontStyle: Sendable, Hashable, Equatable {
        /// The normal style.
        case normal
        /// The italic style.
        case italic
    }

    /// The name of the font (e.g., "Arial", "Helvetica", "System").
    public var fontName: String
    /// The size of the font in points.
    public var pointSize: Float
    /// The weight of the font (e.g., 400 for normal, 700 for bold).
    ///
    /// The range is typically from 100 to 900.
    public var weight: Float
    /// The style of the font.
    public var style: FontStyle = .normal

    /// Create a new `Font` instance.
    /// - Parameters:
    ///   - fontName: The name of the font.
    ///   - pointSize: The size of the font in points.
    ///   - weight: The weight of the font (e.g., 400 for normal, 700 for bold).
    ///   - style: The style of the font. Defaults to `.normal`.
    public init(fontName: String, pointSize: Float, weight: Float, style: FontStyle = .normal) {
        self.fontName = fontName
        self.pointSize = pointSize
        self.weight = weight
        self.style = style
    }

    /// A static property representing the system font with default size and weight.
    public static var system: Font {
        return Font(fontName: "System", pointSize: 12.0, weight: 400.0)
    }
}
