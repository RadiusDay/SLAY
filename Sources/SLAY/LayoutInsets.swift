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

    private func clampZero(_ value: LayoutInsets) -> LayoutInsets {
        return LayoutInsets(
            absolute: value.absolute,
            top: max(0, value.top),
            bottom: max(0, value.bottom),
            leading: max(0, value.leading),
            trailing: max(0, value.trailing)
        )
    }

    /// Convert the insets to absolute left/right insets based on text direction.
    /// - Parameters:
    ///   - layoutDirection: The text direction to use for conversion.
    ///   - disableClamping: If true, negative inset values are not clamped to zero. Defaults to false.
    /// - Returns: A tuple containing the top, bottom, left, and right insets
    public func getAbsolute(
        with layoutDirection: LayoutDirection,
        disableClamping: Bool = false
    ) -> LayoutInsets {
        if absolute {
            return disableClamping ? self : clampZero(self)
        } else {
            switch layoutDirection {
            case .leftToRight:
                let insets = LayoutInsets(
                    absolute: true,
                    top: top,
                    bottom: bottom,
                    leading: leading,
                    trailing: trailing
                )
                return disableClamping ? insets : clampZero(insets)
            case .rightToLeft:
                let insets = LayoutInsets(
                    absolute: true,
                    top: top,
                    bottom: bottom,
                    leading: trailing,
                    trailing: leading
                )
                return disableClamping ? insets : clampZero(insets)
            }
        }
    }
}
