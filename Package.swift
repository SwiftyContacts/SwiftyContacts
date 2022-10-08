// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyContacts",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
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
