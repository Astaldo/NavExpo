// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HomeFeature",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HomeFeature",
            targets: ["HomeFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../../Shared")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HomeFeature",
            dependencies: [
                .product(name: "FoundationKit", package: "Shared"),
                .product(name: "NavigationKit", package: "Shared")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                .unsafeFlags(
                    [
                        "-Xfrontend", "-warn-concurrency", "-Xfrontend",
                        "-enable-actor-data-race-checks"
                    ],
                    .when(configuration: .debug)
                )
            ]
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["HomeFeature"]
        ),
    ]
)
