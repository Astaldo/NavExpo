import SwiftUI
import FoundationKit

// MARK: - App Navigator

public protocol NavigatorProtocol: ObservableObject {
    @MainActor func push(_ route: AppRoute)
    @MainActor func push(_ route: AppRoute, transition: NavigationTransition)
    @MainActor func setPath(_ routes: [AppRoute])
    @MainActor func popToRoot()
    @MainActor func pop()
}

public final class AppNavigator: NavigatorProtocol {
    @Published public var path: NavigationPath
    public weak var uiNavigationProxy: UINavigationProxy?
    
    public init(path: NavigationPath = .init()) {
        self.path = path
    }

    @MainActor
    public func push(_ route: AppRoute) {
        // Use slide as fallback, but ideally this should come from the environment
        push(route, transition: .slide)
    }
    
    @MainActor
    public func push(_ route: AppRoute, transition: NavigationTransition) {
        // Always append to SwiftUI path for consistency
        self.path.append(route)
        
        // If UIKit proxy is available, push the route directly (proxy will handle view building)
        if let proxy = uiNavigationProxy {
            proxy.push(route, transition: transition)
        }
    }

    @MainActor
    public func setPath(_ routes: [AppRoute]) {
        // Always update SwiftUI path
        self.path = NavigationPath(routes)
        
        // If UIKit proxy is available, update UIKit stack
        if let proxy = uiNavigationProxy {
            proxy.popToRoot(animated: false)
            for route in routes {
                proxy.push(route, animated: false)
            }
        }
    }

    @MainActor
    public func popToRoot() {
        // Always update SwiftUI path
        self.path = NavigationPath()
        
        // If UIKit proxy is available, pop UIKit stack
        if let proxy = uiNavigationProxy {
            proxy.popToRoot()
        }
    }
    
    @MainActor
    public func pop() {
        // Always update SwiftUI path
        if !path.isEmpty {
            path.removeLast()
        }
        
        // If UIKit proxy is available, pop UIKit stack
        if let proxy = uiNavigationProxy {
            proxy.pop()
        }
    }
    
}
