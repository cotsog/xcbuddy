// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "xcbuddy",
    targets: [
        .target(
            name: "ProjectDescription",
            dependencies: []),
        .testTarget(
            name: "ProjectDescriptionTests",
            dependencies: ["ProjectDescription"]
        ),
    ]
)
