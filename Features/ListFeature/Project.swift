import ProjectDescription

let project = Project(
    name: "ListFeature",
    targets: [
        .target(
            name: "ListFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.NavExpo.ListFeature",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/ListFeature/**"],
            dependencies: [
                .project(target: "NavigationKit", path: "../../Shared")
            ]
        ),
        .target(
            name: "ListFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NavExpo.ListFeatureTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Tests/ListFeatureTests/**"],
            dependencies: [
                .target(name: "ListFeature")
            ]
        )
    ]
)
