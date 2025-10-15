import AppKit
import SLAY
import SLAYUI

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

    public func setClipsToBounds(_ clips: Bool) {
        nsTextField.clipsToBounds = clips
    }
}

@MainActor fileprivate struct TextStorage {
    var view: NSTextView
    var constraints: [NSLayoutConstraint] = []
}

extension Text: AppKitRenderable {
    public var nsView: NSView {
        nsTextField
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

        label.clipsToBounds = _clipsToBounds
        label.wantsLayer = true

        userData = TextStorage(view: label, constraints: [])
        return label
    }

    private var nsAlignment: NSTextAlignment {
        switch _multilineTextAlignment {
        case .leading: return .natural
        case .center: return .center
        case .trailing: return .right
        }
    }
}
