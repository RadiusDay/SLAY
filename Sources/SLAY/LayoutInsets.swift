/// Insets for layout purposes, similar to CSS margin/padding.
public struct LayoutInsets: Sendable, Hashable, Equatable {
    public var absolute: Bool = false
    public var top: Double
    public var bottom: Double
    public var leading: Double
    public var trailing: Double

    /// Create new layout insets.
    /// - Parameters:
    ///   - absolute: If true, the insets are left to right regardless of text direction. Defaults to false.
    ///   - top: The top inset in pixels.
    ///   - bottom: The bottom inset in pixels.
    ///   - leading: The leading inset in pixels.
    ///   - trailing: The trailing inset in pixels.
    public init(
        absolute: Bool = false,
        top: Double,
        bottom: Double,
        leading: Double,
        trailing: Double
    ) {
        self.absolute = absolute
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }

    /// Create new layout insets with uniform values.
    /// - Parameters:
    ///   - absolute: If true, the insets are left to right regardless of text direction. Defaults to false.
    ///   - all: The inset value for all sides in pixels.
    public init(absolute: Bool = false, all: Double) {
        self.absolute = absolute
        self.top = all
        self.bottom = all
        self.leading = all
        self.trailing = all
    }

    /// Create new layout insets with symmetric values.
    /// - Parameters:
    ///   - absolute: If true, the insets are left to right regardless of text direction. Defaults to false.
    ///   - vertical: The inset value for top and bottom in pixels.
    ///   - horizontal: The inset value for leading and trailing in pixels.
    public init(absolute: Bool = false, vertical: Double, horizontal: Double) {
        self.absolute = absolute
        self.top = vertical
        self.bottom = vertical
        self.leading = horizontal
        self.trailing = horizontal
    }

    /// Convert the insets to absolute left/right insets based on text direction.
    /// - Parameter textDirection: The text direction to use for conversion.
    /// - Returns: A tuple containing the top, bottom, left, and right insets
    public func getAbsolute(with textDirection: TextDirection) -> LayoutInsets {
        if absolute {
            return self
        } else {
            switch textDirection {
            case .leftToRight:
                return LayoutInsets(
                    absolute: true,
                    top: top,
                    bottom: bottom,
                    leading: leading,
                    trailing: trailing
                )
            case .rightToLeft:
                return LayoutInsets(
                    absolute: true,
                    top: top,
                    bottom: bottom,
                    leading: trailing,
                    trailing: leading
                )
            }
        }
    }
}
