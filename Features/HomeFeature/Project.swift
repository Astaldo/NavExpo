import ProjectDescription

let project = Project(
    name: "HomeFeature",
    targets: [
        .target(
            name: "HomeFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.NavExpo.HomeFeature",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/HomeFeature/**"],
            dependencies: [
                .project(target: "FoundationKit", path: "../../Shared")
            ]
        ),
        .target(
            name: "HomeFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NavExpo.HomeFeatureTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Tests/HomeFeatureTests/**"],
            dependencies: [
                .target(name: "HomeFeature")
            ]
        )
    ]
)
