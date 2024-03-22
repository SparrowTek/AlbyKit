// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AlbyKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
    ],
    products: [
        .library(
            name: "AlbyKit",
            targets: ["AlbyKit"]),
    ],
    targets: [
        .target(
            name: "AlbyKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "AlbyKitTests",
            dependencies: ["AlbyKit"]),
    ]
)
