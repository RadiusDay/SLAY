import CoreFoundation
import Testing

@testable import SLAY

// Rounding utility
fileprivate func floorTwo(_ value: Double) -> Double {
    return floor(value * 100) / 100
}

// Most test cases are 16:9 aspect ratio

@Test func horizontalStandard16By9() async throws {
    let result = AspectRatio.solve(16 / 9, width: nil, height: 1080)
    #expect(result.x == 1920, "Width should be 1920")
    #expect(result.y == 1080, "Height should be 1080")
}

@Test func verticalStandard16By9() async throws {
    let result = AspectRatio.solve(16 / 9, width: 1920, height: nil)
    #expect(result.x == 1920, "Width should be 1920")
    #expect(result.y == 1080, "Height should be 1080")
}

@Test func horizontalMinWidth16By9() async throws {
    let result = AspectRatio.solve(16 / 9, width: nil, height: 1080, minWidth: 2000)
    #expect(result.x == 2000, "Width should be 2000")
    #expect(result.y == 1125, "Height should be 1125")
}

@Test func verticalMinHeight16By9() async throws {
    let result = AspectRatio.solve(16 / 9, width: 1920, height: nil, minHeight: 1100)
    #expect(floorTwo(result.x) == 1955.55, "Width should be 1955.55")
    #expect(result.y == 1100, "Height should be 1100")
}

@Test func horizontalMinWidthAndHeight16By9() async throws {
    let result = AspectRatio.solve(
        16 / 9,
        width: nil,
        height: 1080,
        minWidth: 2000,
        minHeight: 1200
    )
    #expect(floorTwo(result.x) == 2133.33, "Width should be 2133.33")
    #expect(result.y == 1200, "Height should be 1200")
}

@Test func verticalMinWidthAndHeight16By9() async throws {
    let result = AspectRatio.solve(
        16 / 9,
        width: 1920,
        height: nil,
        minWidth: 2000,
        minHeight: 1200
    )
    #expect(floorTwo(result.x) == 2133.33, "Width should be 2133.33")
    #expect(result.y == 1200, "Height should be 1200")
}

// 1:1 aspect ratio

@Test func horizontalStandard1By1() async throws {
    let result = AspectRatio.solve(1 / 1, width: nil, height: 1080)
    #expect(result.x == 1080, "Width should be 1080")
    #expect(result.y == 1080, "Height should be 1080")
}

@Test func verticalStandard1By1() async throws {
    let result = AspectRatio.solve(1 / 1, width: 1080, height: nil)
    #expect(result.x == 1080, "Width should be 1080")
    #expect(result.y == 1080, "Height should be 1080")
}

// Unsatisfiable aspect ratio
@Test func horizontalUnsatisfiableAspectRatio() async throws {
    let result = AspectRatio.solve(
        16 / 9,
        width: nil,
        height: 1080,
        minWidth: 3000,
        minHeight: 2000,
        maxWidth: 3500,
        maxHeight: 2500
    )
    #expect(result.x == 3000, "Width should be 3000")
    #expect(result.y == 2000, "Height should be 2000")
}

@Test func verticalUnsatisfiableAspectRatio() async throws {
    let result = AspectRatio.solve(
        16 / 9,
        width: 1080,
        height: nil,
        minWidth: 3000,
        minHeight: 2000,
        maxWidth: 3500,
        maxHeight: 2500
    )
    #expect(result.x == 3000, "Width should be 3000")
    #expect(result.y == 2000, "Height should be 2000")
}

// Choose larger width/height when both provided

@Test func bothDimensionsLargestPreferred() async throws {
    let result = AspectRatio.solve(16 / 9, width: 1280, height: 1080)
    #expect(result.x == 1920, "Width should be 1920")
    #expect(result.y == 1080, "Height should be 1080")
}

// Width and height provided

@Test func bothDimensionsProvidedAspectRatio() async throws {
    let result = AspectRatio.solve(16 / 9, width: 1920, height: 1080)
    #expect(result.x == 1920, "Width should be 1920")
    #expect(result.y == 1080, "Height should be 1080")
}

@Test func bothDimensionsProvidedUnsatisfiableMaxWidth() async throws {
    let result = AspectRatio.solve(16 / 9, width: 640, height: 1080, maxWidth: 1280)
    #expect(result.x == 1280, "Width should be 1280")
    #expect(result.y == 720, "Height should be 720")
}

@Test func bothDimensionsProvidedUnsatisfiableMaxHeight() async throws {
    let result = AspectRatio.solve(16 / 9, width: 1920, height: 360, maxHeight: 1080)
    #expect(result.x == 1920, "Width should be 1920")
    #expect(result.y == 1080, "Height should be 1080")
}
