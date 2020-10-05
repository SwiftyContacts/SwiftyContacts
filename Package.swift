// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyContacts",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .watchOS(.v3),
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
            dependencies: []
        ),
        .testTarget(
            name: "SwiftyContactsTests",
            dependencies: ["SwiftyContacts"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
