// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyContacts",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftyContacts",
            targets: ["SwiftyContacts"]
        ),
    ],
targets: [
        .target(
            name: "SwiftyContacts",
            dependencies: [],
            swiftSettings: []
        ),
        .testTarget(
            name: "SwiftyContactsTests",
            dependencies: ["SwiftyContacts"],
            swiftSettings: []
        ),
    ]
)
