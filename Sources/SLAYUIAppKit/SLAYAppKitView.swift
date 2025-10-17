import AppKit
import SLAY
import SLAYUI

public class SLAYAppKitView: NSView {
    public struct SizeConstraints {
        public var minWidth: Double?
        public var maxWidth: Double?
        public var minHeight: Double?
        public var maxHeight: Double?
        public var width: Double?
        public var height: Double?
    }

    public let engine: LayoutEngine = .init()
    public let rootView: SyntheticUIObjectWithChildren = .init()
    private var sizeConstraints: [NSLayoutConstraint] = []
    private var realBounds: CGRect = .zero
    public var onSizeConstraintsChange: ((SizeConstraints) -> Void)?

    public init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false

        engine.setRootNode(rootView)
        engine.env.layoutDirection =
            NSApp.userInterfaceLayoutDirection == .rightToLeft ? .rightToLeft : .leftToRight
        engine.objectPlacer = { [weak self] info in
            guard let self else { return }
            // Check if object is this
            if info.object.id == self.rootView.id {
                // Set size and position
                self.frame = CGRect(
                    x: rootView.absolutePosition.x,
                    y: rootView.absolutePosition.y,
                    width: rootView.absoluteSize.x,
                    height: rootView.absoluteSize.y
                )
                return
            }
            let parentRenderable = info.parent as? AppKitRenderable
            let parentView =
                info.parent.id == self.rootView.id
                ? self : parentRenderable?.nsView
            guard let parentView else { return }
            let renderable = info.object as? AppKitRenderable
            guard let renderable else { return }
            let objectView = renderable.nsView
            renderable.removeAllChildViews()

            // Make y relative to bottom
            let offset = parentRenderable?.getContentOffset() ?? .zero
            let relativeY =
                info.parent.absolutePosition.y + info.parent.absoluteSize.y
                - (info.position.y + info.size.y + offset.y)
            let relativeX = info.position.x + offset.x - info.parent.absolutePosition.x
            objectView.translatesAutoresizingMaskIntoConstraints = false
            renderable.setBounds(
                CGRect(
                    x: relativeX,
                    y: relativeY,
                    width: info.size.x,
                    height: info.size.y
                )
            )

            if let parentRenderable {
                parentRenderable.addChildView(child: renderable, size: info.size)
            } else {
                parentView.addSubview(objectView)
            }
        }

        Timer.scheduledTimer(
            timeInterval: 1.0 / 60.0,
            target: self,
            selector: #selector(timer),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func timer() {
        let originalWidth = rootView.width
        let originalHeight = rootView.height
        let needsLayout = engine.needsLayout
        rootView.width = .offset(Double(realBounds.width))
        rootView.height = .offset(Double(realBounds.height))
        engine.needsLayout = needsLayout

        if realBounds.width == rootView.absoluteSize.x
            && realBounds.height == rootView.absoluteSize.y && !engine.needsLayout
        {
            return
        }

        defer {
            let needsLayout = engine.needsLayout
            rootView.width = originalWidth
            rootView.height = originalHeight
            engine.needsLayout = needsLayout
        }
        engine.compute()
        if !engine.needsLayout {
            return
        }

        NSLayoutConstraint.deactivate(sizeConstraints)
        let newSizeConstraints = SizeConstraints(
            minWidth: rootView.minWidth?.resolve(parentSize: 0),
            maxWidth: rootView.maxWidth?.resolve(parentSize: 0),
            minHeight: rootView.minHeight?.resolve(parentSize: 0),
            maxHeight: rootView.maxHeight?.resolve(parentSize: 0),
            width: originalWidth?.resolve(parentSize: 0),
            height: originalHeight?.resolve(parentSize: 0)
        )

        if let onSizeConstraintsChange {
            onSizeConstraintsChange(newSizeConstraints)
            return
        }

        if let minWidth = newSizeConstraints.minWidth {
            sizeConstraints.append(widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth))
        }
        if let maxWidth = newSizeConstraints.maxWidth {
            sizeConstraints.append(self.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth))
        }
        if let minHeight = newSizeConstraints.minHeight {
            sizeConstraints.append(
                self.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
            )
        }
        if let maxHeight = newSizeConstraints.maxHeight {
            sizeConstraints.append(
                self.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight)
            )
        }
        if let width = newSizeConstraints.width {
            sizeConstraints.append(self.widthAnchor.constraint(equalToConstant: width))
        }
        if let height = newSizeConstraints.height {
            sizeConstraints.append(self.heightAnchor.constraint(equalToConstant: height))
        }

        NSLayoutConstraint.activate(sizeConstraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layout() {
        super.layout()

        self.realBounds = .init(
            x: self.bounds.origin.x,
            y: self.bounds.origin.y,
            width: self.bounds.width,
            height: self.bounds.height
        )
        engine.needsLayout = true
        timer()
    }

    public override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        engine.needsLayout = true
        timer()
    }
}
