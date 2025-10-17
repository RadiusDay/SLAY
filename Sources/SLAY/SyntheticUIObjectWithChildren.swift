/// A synthetic UI object that can have children of a specified type.
open class SyntheticUIObjectWithChildren: SyntheticUIObject {
    public typealias ChildType = any UIObject

    private var _children: [UniqueID: ChildType] = [:]
    private var _childrenOrder: [UniqueID] = [] {
        didSet { layoutEngine?.needsLayout = true }
    }
    public override var children: [UniqueID: any UIObject] { _children }
    public override var childrenOrder: [UniqueID] { _childrenOrder }

    /// Add a child to the UI object.
    /// - Parameter child: The child UI object to add.
    public func addChild(_ child: ChildType) {
        guard _children[child.id] == nil else { return }
        _children[child.id] = child
        _childrenOrder.append(child.id)
        child.setLocalParent(self)
        LayoutEngine.modifyEngine(for: child, with: self.layoutEngine)
    }

    /// Remove a child from the UI object.
    /// - Parameter id: The unique ID of the child to remove.
    public override func removeChild(_ id: UniqueID) {
        guard let child = _children[id] else { return }
        _children[id] = nil
        _childrenOrder.removeAll { $0 == id }
        child.setLocalParent(nil)
        LayoutEngine.modifyEngine(for: child, with: nil)
    }

    /// Move a child to a new position in the children order.
    /// - Parameters:
    ///   - id: The unique ID of the child to move.
    public func moveChild(_ id: UniqueID, to newIndex: Int) {
        guard _children[id] != nil else { return }
        _childrenOrder.removeAll { $0 == id }
        _childrenOrder.insert(id, at: newIndex)
    }

    /// Remove all children from the UI object.
    public func removeAllChildren() {
        for child in _children.values {
            child.setLocalParent(nil)
            LayoutEngine.modifyEngine(for: child, with: nil)
        }
        _children.removeAll()
        _childrenOrder.removeAll()
    }
}
