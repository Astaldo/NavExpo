// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shared",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "NavigationKit",
            targets: ["NavigationKit"]
        ),
        .library(
            name: "FoundationKit",
            targets: ["FoundationKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "NavigationKit",
            dependencies: [
                "FoundationKit",
                .product(name: "SwiftNavigation", package: "swift-navigation"),
                .product(name: "SwiftUINavigation", package: "swift-navigation")
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
        .target(
            name: "FoundationKit",
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
            name: "FoundationKitTests",
            dependencies: ["FoundationKit"]
        ),
        .testTarget(
            name: "NavigationKitTests",
            dependencies: ["NavigationKit"]
        )
    ]
)
