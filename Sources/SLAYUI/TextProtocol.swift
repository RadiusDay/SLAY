import SLAY

/// Basic protocol for a text element.
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
}
