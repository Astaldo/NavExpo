// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .framework,
            "Dependencies": .framework,
            "Clocks": .framework,
            "ConcurrencyExtras": .framework,
            "CombineSchedulers": .framework,
            "IdentifiedCollections": .framework,
            "IssueReporting": .framework,
            "OrderedCollections": .framework,
            "_CollectionsUtilities": .framework,
            "DependenciesMacros": .framework,
            "SwiftUINavigationCore": .framework,
            "Perception": .framework,
            "PerceptionCore": .framework,
            "CasePaths": .framework,
            "CustomDump": .framework,
            "XCTestDynamicOverlay": .framework
        ]
    )
#endif

let package = Package(
    name: "NavExpo",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.22.0")
    ]
)
