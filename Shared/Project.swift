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
            dependencies: [
                .external(name: "ComposableArchitecture")
            ]
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
        )
    ]
)
