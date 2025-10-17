import AppKit
import SLAY
import SLAYUI

extension Text: GroupProtocol {
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

extension Text: TextProtocol {
    public func calculateSize(ideals: Vector2?) -> Vector2 {
        let font = self._font.nsFont
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = nsAlignment
        paragraph.lineBreakMode = .byWordWrapping

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph,
        ]
        let attributedString = NSAttributedString(string: _text, attributes: attributes)

        let containerWidth =
            if let ideals, ideals.x.isFinite {
                CGFloat(ideals.x)
            } else {
                CGFloat.greatestFiniteMagnitude
            }
        let containerHeight =
            if let ideals, ideals.y.isFinite {
                CGFloat(ideals.y)
            } else {
                CGFloat.greatestFiniteMagnitude
            }
        let containerSize = CGSize(width: containerWidth, height: containerHeight)
        let boundingRect = attributedString.boundingRect(
            with: containerSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading]
        )
        let width = ceil(boundingRect.width)
        let height = ceil(boundingRect.height)
        return Vector2(x: Double(width), y: Double(height))
    }

    public func setText(_ text: String) {
        nsTextField.string = text
    }

    public func setFont(_ font: Font) {
        nsTextField.font = font.nsFont
    }

    public func setColor(_ color: Color) {
        nsTextField.textColor = color.nsColor
    }

    public func setMultilineTextAlignment(_ alignment: Text.MultilineTextAlignment) {
        nsTextField.alignment = nsAlignment
    }
}

@MainActor fileprivate struct TextStorage {
    var view: NSTextView
    var constraints: [NSLayoutConstraint] = []
}

extension Text: AppKitRenderable {
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
        nsTextField
    }

    @MainActor private var nsTextField: NSTextView {
        if let field = userData as? TextStorage {
            return field.view
        }

        // Create text container with a large size
        let textContainer = NSTextContainer()
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.widthTracksTextView = false
        textContainer.heightTracksTextView = false

        // Create layout manager
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        // Create text storage with content
        let textStorage = NSTextStorage(string: text)
        textStorage.addLayoutManager(layoutManager)

        // Create text view
        let label = NSTextView(frame: .zero, textContainer: textContainer)
        label.isSelectable = false
        label.isEditable = false
        label.drawsBackground = false
        label.backgroundColor = .clear
        label.textContainerInset = .zero
        label.alignment = nsAlignment
        label.font = _font.nsFont
        label.wantsLayer = true
        let layer = label.makeBackingLayer()
        label.layer = layer
        updateLayerProperties(layer: layer)

        userData = TextStorage(view: label, constraints: [])
        return label
    }

    public func setBounds(_ rect: CGRect) {
        let view = nsTextField
        guard var field = userData as? TextStorage else {
            return
        }
        NSLayoutConstraint.deactivate(field.constraints)
        field.constraints = [
            view.widthAnchor.constraint(equalToConstant: rect.width),
            view.heightAnchor.constraint(equalToConstant: rect.height),
        ]
        NSLayoutConstraint.activate(field.constraints)
        // Set the frame origin after setting constraints to avoid conflicts.
        view.frame.origin = rect.origin
        userData = field

        // Update layer properties
        let layer = view.makeBackingLayer()
        view.layer = layer
        updateLayerProperties(layer: layer)
    }

    private var nsAlignment: NSTextAlignment {
        let rtl = (layoutEngine?.env.layoutDirection == .rightToLeft)
        switch _multilineTextAlignment {
        case .leading: return rtl ? .right : .left
        case .center: return .center
        case .trailing: return rtl ? .left : .right
        }
    }

    public func getContentOffset() -> Vector2 {
        return .zero
    }

    public func addChildView(child: AppKitRenderable, size: Vector2) {
        // Not supported
    }

    public func removeAllChildViews() {
        // Not supported
    }
}
