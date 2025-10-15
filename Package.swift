// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SLAY",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SLAY",
            targets: ["SLAY"]
        ),
        .library(
            name: "SLAYUI",
            targets: ["SLAYUI"]
        ),
        .library(
            name: "SLAYUIAppKit",
            targets: ["SLAYUIAppKit"]
        ),
    ],
    targets: [
        .target(
            name: "SLAY"
        ),
        .target(
            name: "SLAYUI",
            dependencies: ["SLAY"]
        ),
        .target(
            name: "SLAYUIAppKit",
            dependencies: ["SLAYUI"]
        ),
        .testTarget(
            name: "SLAYTests",
            dependencies: ["SLAY"]
        ),
    ]
)
