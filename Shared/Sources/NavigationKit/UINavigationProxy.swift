//
//  UINavigationProxy.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI

// MARK: - Navigation Bar Customization Data

public struct NavigationBarData {
    public var title: String?
    public var titleDisplayMode: UINavigationItem.LargeTitleDisplayMode = .always
    public var backgroundColor: UIColor?
    public var foregroundColor: UIColor?
    public var isHidden: Bool = false
    public var prefersLargeTitles: Bool = false
    public var backButtonHidden: Bool = false
    public var leftBarButtonItems: [UIBarButtonItem] = []
    public var rightBarButtonItems: [UIBarButtonItem] = []
    
    public init() {}
}


/// SwiftUI-friendly proxy you use from views to push/pop SwiftUI screens.
public final class UINavigationProxy: ObservableObject {
    weak var navController: UINavigationController?
    @Published public var navigationBarData = NavigationBarData()
    private weak var navigator: AppNavigator?
    private var destinationRouter: (any DestinationRouterProtocol)?
    
    init(navigator: AppNavigator? = nil) {
        self.navigator = navigator
    }
    
    func setNavigator(_ navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    func setDestinationRouter(_ destinationRouter: any DestinationRouterProtocol) {
        self.destinationRouter = destinationRouter
    }
    
    @MainActor
    public func push<V: View>(_ view: V, animated: Bool = true, transition: NavigationTransition = .slide) {
        guard let nav = navController else { return }
        
        let hosting = UIHostingController(rootView: view.environment(\.uinc, self))
        hosting.view.backgroundColor = .systemBackground
        
        if case .fade = transition {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            nav.view.layer.add(transition, forKey: kCATransition)
            nav.pushViewController(hosting, animated: false)
        } else if case .custom(let customTransition) = transition {
            nav.view.layer.add(customTransition, forKey: kCATransition)
            nav.pushViewController(hosting, animated: false)
        } else {
            nav.pushViewController(hosting, animated: animated)
        }
    }
    
    @MainActor
    public func push(_ route: AppRoute, animated: Bool = true, transition: NavigationTransition = .slide) {
        guard let destinationRouter = destinationRouter else {
            print("No route definition set on UINavigationProxy")
            self.push(Text("Route: \(route)"), animated: animated, transition: transition)
            return
        }
        
        let view = destinationRouter.destination(for: route)
        self.push(view, animated: animated, transition: transition)
    }

    @discardableResult
    @MainActor
    public func pop(animated: Bool = true, transition: NavigationTransition = .slide) -> Bool {
        guard let nav = navController else { return false }
        
        if case .fade = transition {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            nav.view.layer.add(transition, forKey: kCATransition)
            return nav.popViewController(animated: false) != nil
        } else if case .custom(let customTransition) = transition {
            nav.view.layer.add(customTransition, forKey: kCATransition)
            return nav.popViewController(animated: false) != nil
        } else {
            return nav.popViewController(animated: animated) != nil
        }
    }

    @MainActor
    public func popToRoot(animated: Bool = true, transition: NavigationTransition = .slide) {
        guard let nav = navController else { return }
        
        if case .fade = transition {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            nav.view.layer.add(transition, forKey: kCATransition)
            nav.popToRootViewController(animated: false)
        } else if case .custom(let customTransition) = transition {
            nav.view.layer.add(customTransition, forKey: kCATransition)
            nav.popToRootViewController(animated: false)
        } else {
            nav.popToRootViewController(animated: animated)
        }
    }

    /// Allows customizing the UINavigationBar appearance from SwiftUI if desired.
    @MainActor
    public var navigationBar: UINavigationBar? { navController?.navigationBar }
    
    @MainActor
    public func updateNavigationBar() {
        guard let nav = navController,
              let topViewController = nav.topViewController else { return }
        
        let data = navigationBarData
        
        // Update title
        topViewController.navigationItem.title = data.title
        topViewController.navigationItem.largeTitleDisplayMode = data.titleDisplayMode
        
        // Update navigation bar visibility
        nav.setNavigationBarHidden(data.isHidden, animated: true)
        nav.navigationBar.prefersLargeTitles = data.prefersLargeTitles
        
        // Update back button
        topViewController.navigationItem.hidesBackButton = data.backButtonHidden
        
        // Update bar button items
        topViewController.navigationItem.leftBarButtonItems = data.leftBarButtonItems
        topViewController.navigationItem.rightBarButtonItems = data.rightBarButtonItems
        
        // Update appearance
        if data.backgroundColor != nil || data.foregroundColor != nil {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            
            if let bgColor = data.backgroundColor {
                appearance.backgroundColor = bgColor
            }
            
            if let fgColor = data.foregroundColor {
                appearance.titleTextAttributes[.foregroundColor] = fgColor
                appearance.largeTitleTextAttributes[.foregroundColor] = fgColor
            }
            
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance
            nav.navigationBar.compactAppearance = appearance
        }
    }
}
