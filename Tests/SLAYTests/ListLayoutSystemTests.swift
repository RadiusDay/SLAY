import Testing

@testable import SLAY

@Test func horizontalLayoutWithFixedChildren() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(150)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100), "Child 1 size should be (100, 100)")
    #expect(child2.absolutePosition == Vector2(x: 100, y: 0), "Child 2 position should be (100, 0)")
    #expect(child2.absoluteSize == Vector2(x: 150, y: 100), "Child 2 size should be (150, 100)")
}

@Test func horizontalLayoutWithSpacing() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        spacing: 20,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child2.absolutePosition == Vector2(x: 120, y: 0), "Child 2 position should be (120, 0)")
}

@Test func verticalLayoutWithFixedChildren() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(200)
    root.height = .offset(600)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .vertical,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(150)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100), "Child 1 size should be (100, 100)")
    #expect(child2.absolutePosition == Vector2(x: 0, y: 100), "Child 2 position should be (0, 100)")
    #expect(child2.absoluteSize == Vector2(x: 100, y: 150), "Child 2 size should be (100, 150)")
}

@Test func verticalLayoutWithSpacing() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(200)
    root.height = .offset(600)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .vertical,
        spacing: 20,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child2.absolutePosition == Vector2(x: 0, y: 120), "Child 2 position should be (0, 120)")
}

@Test func horizontalLayoutWithFlexGrow() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    child1.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child1.absoluteSize == Vector2(x: 300, y: 100), "Child 1 size should be (300, 100)")
    #expect(child2.absolutePosition == Vector2(x: 300, y: 0), "Child 2 position should be (300, 0)")
    #expect(child2.absoluteSize == Vector2(x: 300, y: 100), "Child 2 size should be (300, 100)")
}

@Test func horizontalLayoutWithDifferentFlexGrow() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    child1.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 2)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(
        child1.absoluteSize == Vector2(x: 233.33333333333334, y: 100),
        "Child 1 should grow less"
    )
    #expect(child2.absolutePosition == Vector2(x: 233.33333333333334, y: 0), "Child 2 position")
    #expect(
        child2.absoluteSize == Vector2(x: 366.6666666666667, y: 100),
        "Child 2 should grow more"
    )
}

@Test func verticalLayoutWithFlexGrow() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(200)
    root.height = .offset(600)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .vertical,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    child1.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 300), "Child 1 size should be (100, 300)")
    #expect(child2.absolutePosition == Vector2(x: 0, y: 300), "Child 2 position should be (0, 300)")
    #expect(child2.absoluteSize == Vector2(x: 100, y: 300), "Child 2 size should be (100, 300)")
}

@Test func verticalLayoutWithFlexGrowAndAspectRatio() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(100)
    root.height = .offset(400)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .vertical,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    child1.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    child2.aspectRatio = 2  // Width should be double the height
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 300), "Child 1 size should be (100, 300)")
    #expect(child2.absolutePosition == Vector2(x: 0, y: 300), "Child 2 position should be (0, 300)")
    #expect(
        child2.absoluteSize == Vector2(x: 200, y: 100),
        "Child 2 width should be double its height"
    )
}

@Test func horizontalLayoutWithFlexShrink() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(200)
    child1.height = .offset(100)
    child1.layoutProperties = ListLayoutSystem.LayoutProperties(shrink: 1)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(200)
    child2.height = .offset(100)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(shrink: 1)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child1.absoluteSize == Vector2(x: 150, y: 100), "Child 1 should shrink to 150")
    #expect(child2.absolutePosition == Vector2(x: 150, y: 0), "Child 2 position should be (150, 0)")
    #expect(child2.absoluteSize == Vector2(x: 150, y: 100), "Child 2 should shrink to 150")
}

@Test func horizontalLayoutWithFlexShrinkAndAspectRatio() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(200)
    child1.height = .offset(100)
    child1.layoutProperties = ListLayoutSystem.LayoutProperties(shrink: 1)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(200)
    child2.height = .offset(100)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(shrink: 1)
    child2.aspectRatio = 2  // Width should be double the height
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 position should be (0, 0)")
    #expect(child1.absoluteSize == Vector2(x: 150, y: 100), "Child 1 should shrink to 150")
    #expect(child2.absolutePosition == Vector2(x: 150, y: 0), "Child 2 position should be (150, 0)")
    #expect(
        child2.absoluteSize == Vector2(x: 150, y: 75),
        "Child 2 width should be double its height"
    )
}

@Test func horizontalLayoutStartDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 should be at start")
    #expect(child2.absolutePosition == Vector2(x: 100, y: 0), "Child 2 should be at start")
}

@Test func horizontalLayoutStartOverflowDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.minWidth = .offset(200)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.minWidth = .offset(200)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 should be at start")
    #expect(child2.absolutePosition == Vector2(x: 200, y: 0), "Child 2 should overflow to right")
}

@Test func horizontalLayoutCenterDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .center
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 200, y: 0), "Child 1 should be centered")
    #expect(child2.absolutePosition == Vector2(x: 300, y: 0), "Child 2 should be centered")
}

@Test func horizontalLayoutCenterOverflowDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .center
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.minWidth = .offset(200)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.minWidth = .offset(200)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: -50, y: 0), "Child 1 should overflow to left")
    #expect(child2.absolutePosition == Vector2(x: 150, y: 0), "Child 2 should overflow to right")
}

@Test func horizontalLayoutEndDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .end
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 400, y: 0), "Child 1 should be at end")
    #expect(child2.absolutePosition == Vector2(x: 500, y: 0), "Child 2 should be at end")
}

@Test func horizontalLayoutEndOverflowDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .end
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.minWidth = .offset(200)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.minWidth = .offset(200)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: -100, y: 0), "Child 1 should overflow to left")
    #expect(child2.absolutePosition == Vector2(x: 100, y: 0), "Child 2 should overflow to right")
}

@Test func horizontalLayoutSpaceBetweenDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .spaceBetween
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    let child3 = SyntheticUIObject()
    child3.width = .offset(100)
    child3.height = .offset(100)
    root.addChild(child3)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 at start")
    #expect(child2.absolutePosition == Vector2(x: 250, y: 0), "Child 2 in middle")
    #expect(child3.absolutePosition == Vector2(x: 500, y: 0), "Child 3 at end")
}

@Test func horizontalLayoutSpaceBetweenOverflowDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        spacing: 10,
        mainAxisDistribution: .spaceBetween
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.minWidth = .offset(150)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.minWidth = .offset(150)
    child2.height = .offset(100)
    root.addChild(child2)

    let child3 = SyntheticUIObject()
    child3.minWidth = .offset(150)
    child3.height = .offset(100)
    root.addChild(child3)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 should overflow to left")
    #expect(child2.absolutePosition == Vector2(x: 160, y: 0), "Child 2 in middle")
    #expect(child3.absolutePosition == Vector2(x: 320, y: 0), "Child 3 should overflow to right")
}

@Test func horizontalLayoutSpaceAroundDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .spaceAround
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    let child3 = SyntheticUIObject()
    child3.width = .offset(100)
    child3.height = .offset(100)
    root.addChild(child3)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 50, y: 0), "Child 1 with space around")
    #expect(child2.absolutePosition == Vector2(x: 250, y: 0), "Child 2 with space around")
    #expect(child3.absolutePosition == Vector2(x: 450, y: 0), "Child 3 with space around")
}

@Test func horizontalLayoutSpaceAroundDistributionOverflowDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        spacing: 10,
        mainAxisDistribution: .spaceAround
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.minWidth = .offset(150)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.minWidth = .offset(150)
    child2.height = .offset(100)
    root.addChild(child2)

    let child3 = SyntheticUIObject()
    child3.minWidth = .offset(150)
    child3.height = .offset(100)
    root.addChild(child3)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 should overflow to left")
    #expect(child2.absolutePosition == Vector2(x: 160, y: 0), "Child 2 in middle")
    #expect(child3.absolutePosition == Vector2(x: 320, y: 0), "Child 3 should overflow to right")
}

@Test func horizontalLayoutSpaceEvenlyDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(700)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        mainAxisDistribution: .spaceEvenly
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    let child3 = SyntheticUIObject()
    child3.width = .offset(100)
    child3.height = .offset(100)
    root.addChild(child3)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 100, y: 0), "Child 1 with even spacing")
    #expect(child2.absolutePosition == Vector2(x: 300, y: 0), "Child 2 with even spacing")
    #expect(child3.absolutePosition == Vector2(x: 500, y: 0), "Child 3 with even spacing")
}

@Test func horizontalLayoutSpaceEvenlyOverflowDistribution() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(300)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        spacing: 10,
        mainAxisDistribution: .spaceEvenly
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.minWidth = .offset(150)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.minWidth = .offset(150)
    child2.height = .offset(100)
    root.addChild(child2)

    let child3 = SyntheticUIObject()
    child3.minWidth = .offset(150)
    child3.height = .offset(100)
    root.addChild(child3)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0), "Child 1 should overflow to left")
    #expect(child2.absolutePosition == Vector2(x: 160, y: 0), "Child 2 in middle")
    #expect(child3.absolutePosition == Vector2(x: 320, y: 0), "Child 3 should overflow to right")
}

@Test func horizontalLayoutCrossAxisCenter() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .center
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 50), "Child should be centered vertically")
}

@Test func horizontalLayoutCrossAxisEnd() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .end
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 100), "Child should be at bottom")
}

@Test func horizontalLayoutCrossAxisStretch() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .stretch
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(50)
    root.addChild(child1)

    engine.compute()

    #expect(child1.absoluteSize == Vector2(x: 100, y: 200), "Child should stretch to full height")
}

@Test func verticalLayoutCrossAxisCenter() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(200)
    root.height = .offset(600)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .vertical,
        crossAxisAlignment: .center
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    engine.compute()

    #expect(
        child1.absolutePosition == Vector2(x: 50, y: 0),
        "Child should be centered horizontally"
    )
}

@Test func verticalLayoutCrossAxisStretch() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(200)
    root.height = .offset(600)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .vertical,
        crossAxisAlignment: .stretch
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(50)
    child1.height = .offset(100)
    root.addChild(child1)

    engine.compute()

    #expect(child1.absoluteSize == Vector2(x: 200, y: 100), "Child should stretch to full width")
}

@Test func horizontalLayoutWithPadding() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.padding = .init(all: 20)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 20, y: 20), "Child should be offset by padding")
}

@Test func verticalLayoutWithPadding() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(200)
    root.height = .offset(600)
    root.padding = .init(all: 20)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(direction: .vertical)
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 20, y: 20), "Child should be offset by padding")
}

@Test func listLayoutWithAbsoluteChild() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(400)
    root.height = .offset(400)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    child1.layoutProperties = ListLayoutSystem.LayoutProperties(
        anchorPoint: Vector2(x: 0.5, y: 0.5),
        x: .scale(0.5),
        y: .scale(0.5)
    )
    root.addChild(child1)

    engine.compute()

    #expect(
        child1.absolutePosition == Vector2(x: 150, y: 150),
        "Absolute child should be centered"
    )
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100))
}

@Test func horizontalLayoutMixedFlexAndFixed() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    root.addChild(child2)

    let child3 = SyntheticUIObject()
    child3.width = .offset(100)
    child3.height = .offset(100)
    root.addChild(child3)

    engine.compute()

    #expect(child1.absolutePosition == Vector2(x: 0, y: 0))
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100))
    #expect(child2.absolutePosition == Vector2(x: 100, y: 0))
    #expect(child2.absoluteSize == Vector2(x: 400, y: 100), "Middle child should grow")
    #expect(child3.absolutePosition == Vector2(x: 500, y: 0))
    #expect(child3.absoluteSize == Vector2(x: 100, y: 100))
}

@Test func emptyListLayout() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    engine.compute()

    #expect(root.absoluteSize == Vector2(x: 600, y: 200), "Root should maintain size")
}

@Test func singleChildLayout() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child = SyntheticUIObject()
    child.width = .offset(100)
    child.height = .offset(100)
    root.addChild(child)

    engine.compute()

    #expect(child.absolutePosition == Vector2(x: 0, y: 0))
    #expect(child.absoluteSize == Vector2(x: 100, y: 100))
}

@Test func flexGrowWithMaxConstraint() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.maxWidth = .offset(200)
    child1.height = .offset(100)
    child1.layoutProperties = ListLayoutSystem.LayoutProperties(grow: 1)
    root.addChild(child1)

    engine.compute()

    #expect(
        child1.absoluteSize.x <= 200,
        "Child should not exceed max width"
    )
}

@Test func individualCrossAxisAlignment() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.width = .offset(600)
    root.height = .offset(200)
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        crossAxisAlignment: .start
    )
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(50)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(50)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(
        crossAxisAlignment: .end
    )
    root.addChild(child2)

    engine.compute()

    #expect(child1.absolutePosition.y == 0, "Child 1 should be at start")
    #expect(child2.absolutePosition.y == 150, "Child 2 should override to end")
}

@Test func dynamicSizingHorizontalWithPadding() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        spacing: 20,
        crossAxisAlignment: .start
    )
    root.padding = .init(all: 20)
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(
        root.absoluteSize == Vector2(x: 260, y: 140),
        "Root should size to fit children with padding and spacing"
    )
    #expect(child1.absolutePosition == Vector2(x: 20, y: 20), "Child 1 position with padding")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100), "Child 1 size should be (100, 100)")
    #expect(
        child2.absolutePosition == Vector2(x: 140, y: 20),
        "Child 2 position with padding and spacing"
    )
    #expect(child2.absoluteSize == Vector2(x: 100, y: 100), "Child 2 size should be (100, 100)")
}

@Test func dynamicSizingVerticalWithPadding() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .vertical,
        spacing: 20,
        crossAxisAlignment: .start
    )
    root.padding = .init(all: 20)
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(
        root.absoluteSize == Vector2(x: 140, y: 260),
        "Root should size to fit children with padding and spacing"
    )
    #expect(child1.absolutePosition == Vector2(x: 20, y: 20), "Child 1 position with padding")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100), "Child 1 size should be (100, 100)")
    #expect(
        child2.absolutePosition == Vector2(x: 20, y: 140),
        "Child 2 position with padding and spacing"
    )
    #expect(child2.absoluteSize == Vector2(x: 100, y: 100), "Child 2 size should be (100, 100)")
}

@Test func dynamicSizingHorizontalWithPaddingAspectRatio() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        spacing: 20,
        crossAxisAlignment: .start
    )
    root.padding = .init(all: 20)
    root.aspectRatio = 2.0
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(
        root.absoluteSize == Vector2(x: 280, y: 140),
        "Root should size to fit children with padding and spacing, respecting aspect ratio"
    )
    #expect(child1.absolutePosition == Vector2(x: 20, y: 20), "Child 1 position with padding")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100), "Child 1 size should be (100, 100)")
    #expect(
        child2.absolutePosition == Vector2(x: 140, y: 20),
        "Child 2 position with padding and spacing"
    )
    #expect(child2.absoluteSize == Vector2(x: 100, y: 100), "Child 2 size should be (100, 100)")
}

@Test func dynamicSizingVerticalWithPaddingAspectRatio() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .vertical,
        spacing: 20,
        crossAxisAlignment: .start
    )
    root.padding = .init(all: 20)
    root.aspectRatio = 0.5
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(100)
    child1.height = .offset(100)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .offset(100)
    child2.height = .offset(100)
    root.addChild(child2)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(
        root.absoluteSize == Vector2(x: 140, y: 280),
        "Root should size to fit children with padding and spacing, respecting aspect ratio"
    )
    #expect(child1.absolutePosition == Vector2(x: 20, y: 20), "Child 1 position with padding")
    #expect(child1.absoluteSize == Vector2(x: 100, y: 100), "Child 1 size should be (100, 100)")
    #expect(
        child2.absolutePosition == Vector2(x: 20, y: 140),
        "Child 2 position with padding and spacing"
    )
    #expect(child2.absoluteSize == Vector2(x: 100, y: 100), "Child 2 size should be (100, 100)")
}

@Test func absoluteElementInDynamicSizingLayout() async throws {
    let engine = LayoutEngine()
    let root = SyntheticUIObjectWithChildren()
    root.layoutSystem = ListLayoutSystem()
    root.layoutSettings = ListLayoutSystem.LayoutSettings(
        direction: .horizontal,
        spacing: 20,
        crossAxisAlignment: .start
    )
    root.padding = .init(all: 20)
    engine.setRootNode(root)

    let child1 = SyntheticUIObject()
    child1.width = .offset(200)
    child1.height = .offset(200)
    root.addChild(child1)

    let child2 = SyntheticUIObject()
    child2.width = .scale(1)
    child2.height = .scale(1)
    child2.layoutProperties = ListLayoutSystem.LayoutProperties(
        anchorPoint: Vector2(x: 0.5, y: 0.5),
        x: .scale(0.5),
        y: .scale(0.5)
    )
    root.addChild(child2)

    engine.compute()

    #expect(root.absolutePosition == Vector2(x: 0, y: 0), "Root position should be (0, 0)")
    #expect(
        root.absoluteSize == Vector2(x: 240, y: 240),
        "Root should size to fit children with padding and spacing"
    )
    #expect(child1.absolutePosition == Vector2(x: 20, y: 20), "Child 1 position with padding")
    #expect(child1.absoluteSize == Vector2(x: 200, y: 200), "Child 1 size should be (200, 200)")
    #expect(
        child2.absolutePosition == Vector2(x: 20, y: 20),
        "Child 2 should be centered over Child 1"
    )
    #expect(child2.absoluteSize == Vector2(x: 200, y: 200), "Child 2 size should match Child 1")
}
