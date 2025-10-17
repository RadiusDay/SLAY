import AppKit
import SLAY
import SLAYUI

private class SLAYNSScrollView: NSScrollView {
    public var contentOffsetChange: ((Vector2) -> Void)?
    public var ignoreContentOffsetChanges: Bool = true
    public var lastContentOffset: NSPoint = .zero

    public override func tile() {
        let contentViewOrigin = self.contentView.bounds.origin
        super.tile()
        if contentViewOrigin != self.contentView.bounds.origin {
            self.contentView.bounds.origin = contentViewOrigin
        }
    }

    override func reflectScrolledClipView(_ clipView: NSClipView) {
        super.reflectScrolledClipView(clipView)
        guard !ignoreContentOffsetChanges else { return }

        let clipBounds = clipView.bounds

        let convertedOffset = Vector2(
            x: Double(clipBounds.origin.x),
            y: -Double(clipBounds.origin.y)
        )

        contentOffsetChange?(convertedOffset)
    }

    public override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        contentView.scroll(to: lastContentOffset)
    }
}

extension ScrollGroup: GroupProtocol {
    public func setBackgroundColor(_ color: Color) {
        nsScrollView.backgroundColor = color.nsColor
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

extension ScrollGroup: ScrollGroupProtocol {
    private func getTargetPosition(offset: Vector2) -> Vector2 {
        guard let storage = userData as? ScrollGroupStorage else {
            return offset
        }
        let horizontal = _scrollingDirection == .horizontal || _scrollingDirection == .both
        let vertical = _scrollingDirection == .vertical || _scrollingDirection == .both
        return Vector2(
            x: horizontal
                ? offset.x
                : layoutEngine?.env.layoutDirection == .rightToLeft
                    ? storage.contentSize.x - storage.preCommitSize.x : 0,
            y: vertical ? offset.y : 0
        )
    }

    @MainActor private func setContentOffsetInternal(_ offset: Vector2) {
        let contentView = nsScrollView.contentView
        let cachedIgnore = nsScrollView.ignoreContentOffsetChanges
        nsScrollView.ignoreContentOffsetChanges = true
        defer {
            nsScrollView.ignoreContentOffsetChanges = cachedIgnore
        }
        let convertedOffset = NSPoint(
            x: offset.x,
            y: -offset.y
        )
        nsScrollView.lastContentOffset = convertedOffset
        contentView.scroll(to: convertedOffset)
    }

    public func setContentOffset(_ offset: Vector2) {
        setContentOffsetInternal(offset)
        layoutEngine?.needsLayout = true
    }

    public func setScrollingDirection(_ direction: ScrollingDirection) {
        if _elasticScrollingBehavior == .whenScrollable {
            setElasticScrollingBehavior(.whenScrollable)
        }
    }

    public func setElasticScrollingBehavior(_ behavior: ScrollGroup.ElasticScrollingBehavior) {
        let horizontal = _scrollingDirection == .horizontal || _scrollingDirection == .both
        let vertical = _scrollingDirection == .vertical || _scrollingDirection == .both
        switch behavior {
        case .never:
            nsScrollView.verticalScrollElasticity = .none
            nsScrollView.horizontalScrollElasticity = .none
        case .always:
            nsScrollView.verticalScrollElasticity = vertical ? .allowed : .none
            nsScrollView.horizontalScrollElasticity = horizontal ? .allowed : .none
        case .whenScrollable:
            let contentSize = (userData as? ScrollGroupStorage)?.contentSize ?? .zero
            nsScrollView.verticalScrollElasticity =
                (vertical && contentSize.y > nsScrollView.frame.height) ? .allowed : .none
            nsScrollView.horizontalScrollElasticity =
                (horizontal && contentSize.x > nsScrollView.frame.width) ? .allowed : .none
        }
    }
}

@MainActor fileprivate struct ScrollGroupStorage {
    var scrollView: SLAYNSScrollView
    var lastFrameSize: Vector2 = .zero
    var preCommitSize: Vector2 = .zero
    var contentSize: Vector2 = .zero
}

extension ScrollGroup: AppKitRenderable {
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
        nsScrollView
    }

    @MainActor private var nsScrollView: SLAYNSScrollView {
        if let scrollView = userData as? ScrollGroupStorage {
            return scrollView.scrollView
        }
        let scrollView = SLAYNSScrollView()
        userData = ScrollGroupStorage(scrollView: scrollView)
        scrollView.wantsLayer = true
        let layer = scrollView.makeBackingLayer()
        scrollView.layer = layer
        scrollView.scrollsDynamically = false
        scrollView.autoresizesSubviews = false
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        setElasticScrollingBehavior(_elasticScrollingBehavior)
        setContentOffsetInternal(contentOffset)
        updateLayerProperties(layer: layer)
        scrollView.contentOffsetChange = { [weak self] offset in
            guard let self, nsScrollView.documentView != nil else { return }
            let targetOffset = self.getTargetPosition(offset: offset)
            if targetOffset != offset {
                self.setContentOffsetInternal(targetOffset)
            }
            if targetOffset != self.contentOffset {
                layoutEngine?.needsLayout = true
            }
            changeContentOffsetEmbedderInternal(targetOffset)
        }

        return scrollView
    }

    public func getContentOffset() -> Vector2 {
        return contentOffset
    }

    public func setBounds(_ rect: CGRect) {
        let scrollView = nsScrollView
        scrollView.frame = rect
        let layer = scrollView.makeBackingLayer()
        updateLayerProperties(layer: layer)
        scrollView.layer = layer

        guard var storage = userData as? ScrollGroupStorage else { return }
        storage.preCommitSize = Vector2(x: Double(rect.width), y: Double(rect.height))
        userData = storage
    }

    public func addChildView(child: AppKitRenderable, size: Vector2) {
        guard nsScrollView.documentView !== child.nsView else { return }
        nsScrollView.documentView = child.nsView

        guard var storage = userData as? ScrollGroupStorage else { return }
        let lastSize: Vector2 = storage.lastFrameSize

        let newSize = storage.preCommitSize
        storage.lastFrameSize = newSize
        storage.contentSize = size
        userData = storage
        setElasticScrollingBehavior(_elasticScrollingBehavior)

        if newSize != lastSize {
            let realScrollAnchorX =
                layoutDirectionRelative && layoutEngine?.env.layoutDirection == .rightToLeft
                ? 1 - scrollAnchor.x
                : scrollAnchor.x
            let newContentOffsetX =
                contentOffset.x + abs(newSize.x - lastSize.x) * realScrollAnchorX
            let newContentOffsetY = contentOffset.y + abs(newSize.y - lastSize.y) * scrollAnchor.y
            // Clamp to child size
            let clampedX = max(0, min(newContentOffsetX, max(0, size.x - newSize.x)))
            let clampedY = max(0, min(newContentOffsetY, max(0, size.y - newSize.y)))
            print(clampedX, clampedY)
            changeContentOffsetEmbedderInternal(Vector2(x: clampedX, y: clampedY))
        }

        // Persist the scroll position
        setContentOffsetInternal(getTargetPosition(offset: contentOffset))

        let layer = nsView.makeBackingLayer()
        nsView.layer = layer
        updateLayerProperties(layer: layer)

        nsScrollView.ignoreContentOffsetChanges = false
    }

    public func removeAllChildViews() {
        nsScrollView.documentView = nil
        nsScrollView.ignoreContentOffsetChanges = true
    }
}
