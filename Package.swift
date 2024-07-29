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
    dependencies: [
        .package(url: "https://github.com/breez/breez-sdk-liquid-swift.git", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "AlbyKit",
            dependencies: [
                .product(name: "BreezSDKLiquid", package: "breez-sdk-liquid-swift"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "AlbyKitTests",
            dependencies: ["AlbyKit"]),
    ]
)
