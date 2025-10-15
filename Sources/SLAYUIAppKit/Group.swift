import AppKit
import SLAY
import SLAYUI

extension Group: GroupProtocol {
    public func setBackgroundColor(_ color: Color) {
        nsView.layer?.backgroundColor = color.nsColor.cgColor
    }

    public func setCornerRadius(_ radius: Double) {
        nsView.layer?.cornerRadius = CGFloat(radius)
    }

    public func setClipToBounds(_ clips: Bool) {
        nsView.layer?.masksToBounds = clips
    }

    public func setTransformOrigin(_ point: Vector2) {
        guard let layer = nsView.layer else { return }

        let newAnchorPoint = CGPoint(x: point.x, y: 1.0 - point.y)
        let oldAnchorPoint = layer.anchorPoint

        var newPosition = layer.position
        newPosition.x += (newAnchorPoint.x - oldAnchorPoint.x) * layer.bounds.width
        newPosition.y += (newAnchorPoint.y - oldAnchorPoint.y) * layer.bounds.height

        layer.anchorPoint = newAnchorPoint
        layer.position = newPosition
    }

    public func setRotation(_ angle: Double) {
        nsView.layer?.transform = transform
    }

    public func setScale(_ scale: Double) {
        nsView.layer?.transform = transform
    }
}

extension Group: AppKitRenderable {
    private var transform: CATransform3D {
        var transform = CATransform3DIdentity

        // Apply scaling
        if _scale != 1.0 {
            transform = CATransform3DScale(transform, CGFloat(_scale), CGFloat(_scale), 1.0)
        }

        // Apply rotation
        if _rotation != 0 {
            let radians: CGFloat = CGFloat(_rotation * .pi / 180)
            transform = CATransform3DRotate(transform, radians, 0, 0, 1)
        }

        return transform
    }

    @MainActor private func updateLayerProperties(layer: CALayer) {
        layer.backgroundColor = _backgroundColor.nsColor.cgColor
        layer.cornerRadius = CGFloat(_cornerRadius)
        layer.masksToBounds = _clipToBounds

        let newAnchorPoint = CGPoint(x: _transformOrigin.x, y: 1.0 - _transformOrigin.y)
        let oldAnchorPoint = layer.anchorPoint

        var newPosition = layer.position
        newPosition.x += (newAnchorPoint.x - oldAnchorPoint.x) * layer.bounds.width
        newPosition.y += (newAnchorPoint.y - oldAnchorPoint.y) * layer.bounds.height

        layer.anchorPoint = newAnchorPoint
        layer.position = newPosition
        layer.transform = transform
    }

    public var nsView: NSView {
        if let userData = userData as? NSView {
            return userData
        }
        let view = NSView()
        userData = view
        let layer = view.makeBackingLayer()
        view.layer = layer
        updateLayerProperties(layer: layer)

        return view
    }

    public func setBounds(_ rect: CGRect) {
        nsView.frame = rect
        let layer = nsView.makeBackingLayer()
        nsView.layer = layer
        updateLayerProperties(layer: layer)
    }
}
