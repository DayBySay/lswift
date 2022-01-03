// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "lswift",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "lswift", targets: ["lswift"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .upToNextMajor(from: "0.2.4")),
    ],
    targets: [
        .target(
            name: "lswift",
            dependencies: [
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
            ]),
        .testTarget(
            name: "lswiftTests",
            dependencies: ["lswift"]),
    ]
)
