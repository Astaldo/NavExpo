import SwiftUI
import FoundationKit

public final class FeatureNavigator<Route: Hashable>: ObservableObject {
    @Published public var path: NavigationPath

    public init(path: NavigationPath = .init()) {
        self.path = path
    }

    public func push(_ route: Route) {
        self.path.append(route)
    }

    public func setPath(_ routes: [Route]) {
        self.path = NavigationPath(routes)
    }

    public func popToRoot() {
        self.path = NavigationPath()
    }
}

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
