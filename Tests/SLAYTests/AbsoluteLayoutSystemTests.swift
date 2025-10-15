import Testing

@testable import SLAY

@Test func zeroDimension() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    engine.setRootNode(root)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 0, y: 0), "Root size should be (0, 0)")
}

@Test func scaledRoot() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .scale(0.5)
    root.height = .scale(0.5)
    engine.setRootNode(root)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 0, y: 0), "Root size should be (0, 0)")
}

@Test func zeroDimensionWithChild() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .offset(100)
    child.height = .offset(100)
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 0, y: 0), "Root size should be (0, 0)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 100, y: 100), "Child size should be (100, 100)")
}

@Test func fixedSize() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(300)
    engine.setRootNode(root)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 300, y: 300), "Root size should be (300, 300)")
}

@Test func zeroSizeWithScaleChild() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .scale(0.5)
    child.height = .scale(0.5)
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 0, y: 0), "Root size should be (0, 0)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 0, y: 0), "Child size should be (0, 0)")
}

@Test func fixedSizeWithScaleChild() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(400)
    root.height = .offset(400)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .scale(0.5)
    child.height = .scale(0.5)
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 400, y: 400), "Root size should be (400, 400)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 200, y: 200), "Child size should be (200, 200)")
}

@Test func fixedSizeWithOffsetAndScaleChild() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(400)
    root.height = .offset(400)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .init(scale: 0.5, offset: 50)
    child.height = .init(scale: 0.5, offset: 50)
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 400, y: 400), "Root size should be (400, 400)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 250, y: 250), "Child size should be (250, 250)")
}

@Test func scaledChildInFixedParent() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    engine.setRootNode(root)

    let parent = SyntheticUIObjectWithChildren()
    parent.width = .offset(400)
    parent.height = .offset(400)
    root.addChild(parent)

    let child = SyntheticUIObject()
    child.width = .scale(0.5)
    child.height = .scale(0.5)
    parent.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 0, y: 0), "Root size should be (0, 0)")
    #expect(parent.absolutePosition == Vector2(x: 0, y: 0), "Parent position should be (0, 0)")
    #expect(parent.absoluteSize == Vector2(x: 400, y: 400), "Parent size should be (400, 400)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 200, y: 200), "Child size should be (200, 200)")
}

@Test func scaledChildInScaledParent() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(800)
    root.height = .offset(800)
    engine.setRootNode(root)

    let parent = SyntheticUIObjectWithChildren()
    parent.width = .scale(0.5)
    parent.height = .scale(0.5)
    root.addChild(parent)

    let child = SyntheticUIObject()
    child.width = .scale(0.5)
    child.height = .scale(0.5)
    parent.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 800, y: 800), "Root size should be (800, 800)")
    #expect(parent.absolutePosition == Vector2(x: 0, y: 0), "Parent position should be (0, 0)")
    #expect(parent.absoluteSize == Vector2(x: 400, y: 400), "Parent size should be (400, 400)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 200, y: 200), "Child size should be (200, 200)")
}

@Test func paddedChild() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(400)
    root.height = .offset(400)
    root.padding = .init(all: 50)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .scale(1.0)
    child.height = .scale(1.0)
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 400, y: 400), "Root size should be (400, 400)")
    #expect(child.absolutePosition == Vector2(x: 50, y: 50), "Child position should be (50, 50)")
    #expect(child.absoluteSize == Vector2(x: 300, y: 300), "Child size should be (300, 300)")
}

@Test func paddedDefaultSize() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.padding = .init(all: 50)
    engine.setRootNode(root)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 100, y: 100), "Root size should be (100, 100)")
}

@Test func anchoredChild() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(400)
    root.height = .offset(400)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .offset(100)
    child.height = .offset(100)
    child.layoutSystem = AbsoluteLayoutSystem()
    child.layoutProperties = AbsoluteLayoutSystem.LayoutProperties(
        anchorPoint: Vector2(x: 0.5, y: 0.5),
        x: .scale(0.5),
        y: .offset(100)
    )
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 400, y: 400), "Root size should be (400, 400)")
    #expect(child.absolutePosition == Vector2(x: 150, y: 50), "Child position should be (150, 50)")
    #expect(child.absoluteSize == Vector2(x: 100, y: 100), "Child size should be (100, 100)")
}

@Test func anchoredChildWithPadding() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(400)
    root.height = .offset(400)
    root.padding = .init(all: 50)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .offset(100)
    child.height = .offset(100)
    child.layoutSystem = AbsoluteLayoutSystem()
    child.layoutProperties = AbsoluteLayoutSystem.LayoutProperties(
        anchorPoint: Vector2(x: 0.5, y: 0.5),
        x: .scale(0.5),
        y: .offset(100)
    )
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 400, y: 400), "Root size should be (400, 400)")
    #expect(
        child.absolutePosition == Vector2(x: 150, y: 100),
        "Child position should be (150, 100)"
    )
    #expect(child.absoluteSize == Vector2(x: 100, y: 100), "Child size should be (100, 100)")
}

@Test func multipleChildren() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(400)
    root.height = .offset(400)
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    child1.layoutSystem = AbsoluteLayoutSystem()
    child1.layoutProperties = AbsoluteLayoutSystem.LayoutProperties(
        anchorPoint: Vector2(x: 0, y: 0),
        x: .offset(0),
        y: .offset(0)
    )
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    child2.layoutSystem = AbsoluteLayoutSystem()
    child2.layoutProperties = AbsoluteLayoutSystem.LayoutProperties(
        anchorPoint: Vector2(x: 1, y: 1),
        x: .scale(1.0),
        y: .scale(1.0)
    )
    root.addChild(child2)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 400, y: 400), "Root size should be (400, 400)")
    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100), "Child 1 size should be (100, 100)")
    #expect(
        child2.absolutePosition == Vector2(x: 300, y: 300),
        "Child 2 position should be (300, 300)"
    )
    #expect(child2.absoluteSize == Vector2(x: 100, y: 100), "Child 2 size should be (100, 100)")
}

@Test func negativeOffsets() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(400)
    root.height = .offset(400)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .offset(100)
    child.height = .offset(100)
    child.layoutSystem = AbsoluteLayoutSystem()
    child.layoutProperties = AbsoluteLayoutSystem.LayoutProperties(
        anchorPoint: Vector2(x: 0, y: 0),
        x: .offset(-50),
        y: .offset(-50)
    )
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 400, y: 400), "Root size should be (400, 400)")
    #expect(
        child.absolutePosition == Vector2(x: -50, y: -50),
        "Child position should be (-50, -50)"
    )
    #expect(child.absoluteSize == Vector2(x: 100, y: 100), "Child size should be (100, 100)")
}

@Test func compoundingScales() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(800)
    root.height = .offset(800)
    engine.setRootNode(root)

    let parent = SyntheticUIObjectWithChildren()
    parent.width = .scale(0.5)
    parent.height = .scale(0.5)
    root.addChild(parent)

    let child = SyntheticUIObjectWithChildren()
    child.width = .scale(0.5)
    child.height = .scale(0.5)
    parent.addChild(child)

    let grandchild = SyntheticUIObject()
    grandchild.width = .scale(0.5)
    grandchild.height = .scale(0.5)
    child.addChild(grandchild)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 800, y: 800), "Root size should be (800, 800)")
    #expect(parent.absolutePosition == Vector2(x: 0, y: 0), "Parent position should be (0, 0)")
    #expect(parent.absoluteSize == Vector2(x: 400, y: 400), "Parent size should be (400, 400)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 200, y: 200), "Child size should be (200, 200)")
    #expect(
        grandchild.absolutePosition == Vector2(x: 0, y: 0),
        "Grandchild position should be (0, 0)"
    )
    #expect(
        grandchild.absoluteSize == Vector2(x: 100, y: 100),
        "Grandchild size should be (100, 100)"
    )
}

@Test func aspectRatiosWidth() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(800)
    root.height = .offset(800)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .scale(1)
    child.maxWidth = .offset(400)
    child.aspectRatio = 2
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 800, y: 800), "Root size should be (800, 800)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 400, y: 200), "Child size should be (400, 200)")
}

@Test func aspectRatiosHeight() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(800)
    root.height = .offset(800)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.height = .scale(1)
    child.maxHeight = .offset(400)
    child.aspectRatio = 1 / 2
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 800, y: 800), "Root size should be (800, 800)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 200, y: 400), "Child size should be (200, 400)")
}

@Test func aspectRatiosBoth() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(160)
    root.height = .offset(160)
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .scale(1)
    child.height = .scale(1)
    child.maxWidth = .scale(1)
    child.maxHeight = .scale(1)
    child.aspectRatio = 16 / 9
    root.addChild(child)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(root.absoluteSize == Vector2(x: 160, y: 160), "Root size should be (160, 160)")
    #expect(child.absolutePosition == Vector2(x: 0, y: 0), "Child position should be (0, 0)")
    #expect(child.absoluteSize == Vector2(x: 160, y: 90), "Child size should be (160, 90)")
}
