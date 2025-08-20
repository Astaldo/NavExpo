import ProjectDescription

let project = Project(
    name: "Shared",
    targets: [
        .target(
            name: "FoundationKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.NavExpo.FoundationKit",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/FoundationKit/**"],
            dependencies: []
        ),
        .target(
            name: "FoundationKitTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NavExpo.FoundationKitTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Tests/FoundationKitTests/**"],
            dependencies: [
                .target(name: "FoundationKit")
            ]
        ),
        .target(
            name: "NavigationKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.NavExpo.NavigationKit",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/NavigationKit/**"],
            dependencies: [
                .target(name: "FoundationKit")
            ]
        ),
        .target(
            name: "NavigationKitTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NavExpo.NavigationKitTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Tests/NavigationKitTests/**"],
            dependencies: [
                .target(name: "NavigationKit")
            ]
        )
    ]
)
