import AppKit
import SLAY

public protocol AppKitRenderable {
    @MainActor var nsView: NSView { get }
    @MainActor func getContentOffset() -> Vector2
    @MainActor func setBounds(_ rect: CGRect)
    @MainActor func addChildView(child: AppKitRenderable, size: Vector2)
    @MainActor func removeAllChildViews()
}
