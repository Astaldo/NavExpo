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
    public var prefersLargeTitles: Bool = true
    public var backButtonHidden: Bool = false
    public var leftBarButtonItems: [UIBarButtonItem] = []
    public var rightBarButtonItems: [UIBarButtonItem] = []
    
    public init() {}
}

// MARK: - Navigation Configuration Protocol

/// Protocol that SwiftUI views can conform to for declaring their navigation bar configuration upfront
public protocol NavigationConfigurable {
    /// The navigation bar configuration for this view
    var navigationConfiguration: NavigationBarData { get }
}

// MARK: - Configuration Extraction Utilities

public extension UINavigationProxy {
    /// Extracts navigation configuration from a view if it conforms to NavigationConfigurable
    static func extractNavigationConfiguration<V: View>(from view: V) -> NavigationBarData? {
        guard let configurableView = view as? NavigationConfigurable else {
            return nil
        }
        return configurableView.navigationConfiguration
    }
    
    /// Creates a NavigationBarData with just a title (convenience method)
    static func navigationConfiguration(title: String) -> NavigationBarData {
        var config = NavigationBarData()
        config.title = title
        return config
    }
    
    /// Creates a NavigationBarData with title and colors (convenience method)
    static func navigationConfiguration(title: String, backgroundColor: UIColor?, foregroundColor: UIColor?) -> NavigationBarData {
        var config = NavigationBarData()
        config.title = title
        config.backgroundColor = backgroundColor
        config.foregroundColor = foregroundColor
        return config
    }
}

// MARK: - NavigationBarData Convenience Extensions

public extension NavigationBarData {
    /// Applies a color theme to the navigation bar
    mutating func applyColorTheme(background: UIColor?, foreground: UIColor?) {
        self.backgroundColor = background
        self.foregroundColor = foreground
    }
    
    /// Applies a predefined color theme
    mutating func applyPresetTheme(_ theme: NavigationColorTheme) {
        switch theme {
        case .blue:
            applyColorTheme(background: .systemBlue, foreground: .white)
        case .green:
            applyColorTheme(background: .systemGreen, foreground: .black)
        case .red:
            applyColorTheme(background: .systemRed, foreground: .white)
        case .purple:
            applyColorTheme(background: .systemPurple, foreground: .white)
        case .clear:
            applyColorTheme(background: .clear, foreground: .label)
        }
    }
}

// MARK: - Navigation Color Themes

public enum NavigationColorTheme {
    case blue
    case green
    case red
    case purple
    case clear
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
        
        // Extract navigation configuration from view before creating hosting controller
        let navigationConfig = Self.extractNavigationConfiguration(from: view) ?? NavigationBarData()
        
        let hosting = ConfigurableHostingController(rootView: view.environment(\.uinc, self), navConfig: navigationConfig)
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
    
    /// Applies navigation configuration to a hosting controller before it's pushed
    @MainActor
    func applyNavigationConfiguration(_ config: NavigationBarData, to viewController: UIViewController) {
        guard let nav = navController else { return }
        let navigationItem = viewController.navigationItem
        
        // Apply title
        navigationItem.title = config.title
        navigationItem.largeTitleDisplayMode = config.titleDisplayMode
        
        // Apply bar button items
        navigationItem.leftBarButtonItems = config.leftBarButtonItems
        navigationItem.rightBarButtonItems = config.rightBarButtonItems
        
        // Apply back button visibility
        navigationItem.hidesBackButton = config.backButtonHidden
        
        // Apply navigation bar styling (colors, visibility, large titles preference)
        nav.setNavigationBarHidden(config.isHidden, animated: false)
        nav.navigationBar.prefersLargeTitles = config.prefersLargeTitles
        
        // Apply appearance customization if colors are specified
        if config.backgroundColor != nil || config.foregroundColor != nil {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            
            if let bgColor = config.backgroundColor {
                appearance.backgroundColor = bgColor
            }
            
            if let fgColor = config.foregroundColor {
                appearance.titleTextAttributes[.foregroundColor] = fgColor
                appearance.largeTitleTextAttributes[.foregroundColor] = fgColor
            }
            
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance
            nav.navigationBar.compactAppearance = appearance
        }
    }
    
    @MainActor
    public func updateNavigationBar() {
        guard let nav = navController,
              let topViewController = nav.topViewController else { return }
        
        // Prefer stored config from our hosting controller if available
        guard let configurable = topViewController as? ConfigurableHostingControllerProtocol else {
            self.applyNavigationConfiguration(self.navigationBarData, to: topViewController)
            return
        }
        self.applyNavigationConfiguration(configurable.navConfig, to: topViewController)
    }
}
