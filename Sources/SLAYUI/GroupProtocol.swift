import SLAY

/// Basic protocol for a group of views.
public protocol GroupProtocol {
    /// Set the background color of the group.
    @MainActor func setBackgroundColor(_ color: Color)
    /// Set the corner radius of the group.
    @MainActor func setCornerRadius(_ radius: Double)
    /// Set the transform origin of the group.
    @MainActor func setTransformOrigin(_ point: Vector2)
    /// The rotation angle of the view in degrees.
    @MainActor func setRotation(_ angle: Double)
    /// The scale factor of the view.
    @MainActor func setScale(_ scale: Double)
    /// Set whether the group clips to its bounds.
    @MainActor func setClipToBounds(_ clips: Bool)
}
