import SwiftUI
@_exported import SwiftNavigation
import FoundationKit

// MARK: - Feature Navigation

@MainActor
public final class FeatureNavigator<Route: Hashable>: ObservableObject {
    @Published public var path: NavigationPath = NavigationPath()

    // Keep typed path for better state management
    private var typedPath: [Route] = [] {
        didSet {
            path = NavigationPath(typedPath)
        }
    }

    public init() {}

    public func push(_ route: Route) {
        typedPath.append(route)
    }

    public func setPath(_ routes: [Route]) {
        typedPath = routes
    }

    public func popToRoot() {
        typedPath.removeAll()
    }

    public func pop() {
        _ = typedPath.popLast()
    }

    public func pop(to route: Route) {
        while let last = typedPath.last, last != route {
            _ = typedPath.popLast()
        }
    }

    // Expose typed routes for enhanced navigation features
    public var routes: [Route] {
        return typedPath
    }
}

// MARK: - Tab Navigation Helper

@MainActor
public final class TabNavigationState: ObservableObject {
    @Published public var selectedTab: Int = 0

    public init(selectedTab: Int = 0) {
        self.selectedTab = selectedTab
    }

    public func selectTab(_ index: Int) {
        self.selectedTab = index
    }
}

// MARK: - Deep Linking

public enum DeepLink: Equatable {
    case home
    case list
    case profile
    case profileDetail1
    case profileDetail2

    public init?(from url: URL) {
        guard url.scheme == "navexpo" else { return nil }
        guard url.host == "navexpo" else { return nil }

        switch url.pathComponents.patternMatched {
        case .pair(_, "home"):
            self = .home
        case .pair(_, "profile"):
            self = .profile
        case .triple(_, "profile", "detail1"):
            self = .profileDetail1
        case .quad(_, "profile", "detail1", "detail2"):
            self = .profileDetail2
        case .pair(_, "list"):
            self = .list
        default:
            return nil
        }
    }
}

// MARK: - Deep Link Handler Protocol

@MainActor
public protocol DeepLinkNavigator {
    func popToRoot()
    func setPathForDeepLink(_ components: [String])
}

extension FeatureNavigator: DeepLinkNavigator where Route: RawRepresentable, Route.RawValue == String {
    public func setPathForDeepLink(_ components: [String]) {
        let routes = components.compactMap { Route(rawValue: $0) }
        self.setPath(routes)
    }
}
