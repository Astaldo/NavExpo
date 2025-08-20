import ProjectDescription

let project = Project(
    name: "ProfileFeature",
    targets: [
        .target(
            name: "ProfileFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.NavExpo.ProfileFeature",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/ProfileFeature/**"],
            dependencies: [
                .project(target: "NavigationKit", path: "../../Shared")
            ]
        ),
        .target(
            name: "ProfileFeatureTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NavExpo.ProfileFeatureTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Tests/ProfileFeatureTests/**"],
            dependencies: [
                .target(name: "ProfileFeature")
            ]
        )
    ]
)
