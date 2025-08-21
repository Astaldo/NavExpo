import ProjectDescription

let project = Project(
    name: "NavExpo",
    targets: [
        .target(
            name: "NavExpo",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.NavExpo",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleURLTypes": [
                        [
                            "CFBundleURLName": "io.tuist.NavExpo",
                            "CFBundleURLSchemes": ["navexpo"],
                        ]
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "FoundationKit", path: "../Shared"),
                .project(target: "HomeFeature", path: "../Features/HomeFeature"),
                .project(target: "ListFeature", path: "../Features/ListFeature"),
                .project(target: "ProfileFeature", path: "../Features/ProfileFeature"),
            ],
            settings: .settings(
                base: [
                    "OTHER_SWIFT_FLAGS": [
                        "-Xfrontend", "-strict-concurrency=complete"
                    ],
                ],
                configurations: [
                    .debug(name: "Debug", settings: [
                        "OTHER_SWIFT_FLAGS": [
                            "-Xfrontend", "-strict-concurrency=complete",
                            "-Xfrontend", "-warn-concurrency",
                            "-Xfrontend", "-enable-actor-data-race-checks",
                        ]
                    ]),
                    .release(name: "Release", settings: [:])
                ]
            )
        ),
        .target(
            name: "NavExpoTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NavExpoTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "NavExpo")]
        )
    ]
)
