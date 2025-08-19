// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ListFeature",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ListFeature",
            targets: ["ListFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../../Shared")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ListFeature",
            dependencies: [
                .product(name: "FoundationKit", package: "Shared"),
                .product(name: "NavigationKit", package: "Shared")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                .unsafeFlags(
                    [
                        "-Xfrontend", "-warn-concurrency",
                        "-Xfrontend", "-enable-actor-data-race-checks"
                    ],
                    .when(configuration: .debug)
                )
            ]
        ),
        .testTarget(
            name: "ListFeatureTests",
            dependencies: ["ListFeature"]
        ),
    ]
)
