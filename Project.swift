import ProjectDescription

let project = Project(
    name: "NavExpo",
    packages: [
        .local(path: "Shared"),
        .local(path: "Features/HomeFeature"),
        .local(path: "Features/ListFeature"),
        .local(path: "Features/ProfileFeature"),
    ],
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
            sources: ["NavExpo/Sources/**"],
            resources: ["NavExpo/Resources/**"],
            dependencies: [
                .package(product: "NavigationKit"),
                .package(product: "HomeFeature"),
                .package(product: "ListFeature"),
                .package(product: "ProfileFeature"),
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
            sources: ["NavExpo/Tests/**"],
            resources: [],
            dependencies: [.target(name: "NavExpo")]
        ),
        .target(
            name: "FoundationKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.FoundationKit",
            infoPlist: .default,
            sources: ["Shared/Sources/FoundationKit/**"],
            resources: []
        ),
        .target(
            name: "FoundationKitTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.FoundationKitTests",
            infoPlist: .default,
            sources: ["Shared/Tests/FoundationKitTests/**"],
            resources: [],
            dependencies: [
                .package(product: "FoundationKit")
            ]
        ),
        .target(
            name: "NavigationKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.NavigationKit",
            infoPlist: .default,
            sources: ["Shared/Sources/NavigationKit/**"],
            resources: [],
            dependencies: [
                .package(product: "FoundationKit")
            ]
        ),
        .target(
            name: "NavigationKitTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NavigationKitTests",
            infoPlist: .default,
            sources: ["Shared/Tests/NavigationKitTests/**"],
            resources: [],
            dependencies: [
                .package(product: "NavigationKit"),
                .package(product: "FoundationKit")
            ]
        ),
    ]
)
