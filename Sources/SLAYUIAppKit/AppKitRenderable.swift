import AppKit

public protocol AppKitRenderable {
    @MainActor var nsView: NSView { get }
    @MainActor func setBounds(_ rect: CGRect)
}
