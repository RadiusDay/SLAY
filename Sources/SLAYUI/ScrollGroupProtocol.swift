import SLAY

public protocol ScrollGroupProtocol {
    /// Set the content offset of the scroll group.
    @MainActor func setContentOffset(_ offset: Vector2)
    /// Set the elastic scrolling behavior of the scroll group.
    @MainActor func setElasticScrollingBehavior(_ behavior: ScrollGroup.ElasticScrollingBehavior)
    /// Set the scrolling direction of the scroll group.
    @MainActor func setScrollingDirection(_ direction: ScrollGroup.ScrollingDirection)
}
