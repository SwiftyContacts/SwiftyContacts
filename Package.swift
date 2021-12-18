// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyContacts",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
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
    ]
)
