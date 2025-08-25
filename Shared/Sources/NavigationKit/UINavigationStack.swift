//
//  UINavigationStack.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI
import UIKit

// MARK: - Navigation Configuration Extraction

/// Utility for extracting NavigationBarDataFactory from SwiftUI views,
/// even when wrapped in modifier chains that obscure the original type
private struct NavigationConfigExtractor {
    
    /// Maximum depth to search to prevent infinite recursion
    private static let maxRecursionDepth = 10
    
    /// Extracts NavigationBarDataFactory from a view, searching through modifier chains if needed
    /// - Parameter view: The SwiftUI view to extract configuration from
    /// - Returns: NavigationBarDataFactory if found, nil otherwise
    static func extract<V: View>(from view: V) -> NavigationBarDataFactory? {
        return extractWithDepth(from: view, currentDepth: 0)
    }
    
    /// Internal extraction method with depth tracking
    private static func extractWithDepth<V>(from view: V, currentDepth: Int) -> NavigationBarDataFactory? {
        // Safety check: prevent excessive recursion
        guard currentDepth < maxRecursionDepth else {
            return nil
        }
        
        // Fast path: direct NavigationConfigurable conformance
        if let configurable = view as? NavigationConfigurable {
            return configurable.navigationConfiguration
        }
        
        // Mirror-based recursive search
        return searchRecursively(in: view, currentDepth: currentDepth)
    }
    
    /// Recursively search through view properties using Mirror reflection
    private static func searchRecursively<V>(in view: V, currentDepth: Int) -> NavigationBarDataFactory? {
        let mirror = Mirror(reflecting: view)
        
        // Search through all properties of the view
        for child in mirror.children {
            // Check if this property is NavigationConfigurable
            if let configurable = child.value as? NavigationConfigurable {
                return configurable.navigationConfiguration
            }
            
            // Recursively search in this property
            if let found = extractWithDepth(from: child.value, currentDepth: currentDepth + 1) {
                return found
            }
        }
        
        return nil
    }
}

// MARK: - The SwiftUI View

/// A SwiftUI container that can use either UIKit UINavigationController or SwiftUI NavigationStack under the hood.
public struct UINavigationStack<Content: View>: View {
    private let content: Content
    private let configuration: NavigationConfiguration
    private let navigator: AppNavigator?
    private let desinationRouter: (any DestinationRouterProtocol)?

    public init(navigator: AppNavigator, desinationRouter: any DestinationRouterProtocol, configuration: NavigationConfiguration = NavigationConfiguration(), @ViewBuilder _ content: () -> Content) {
        self.configuration = configuration
        self.content = content()
        self.navigator = navigator
        self.desinationRouter = desinationRouter
    }
    
    public init(configuration: NavigationConfiguration = NavigationConfiguration(), @ViewBuilder _ content: () -> Content) {
        self.configuration = configuration
        self.content = content()
        self.navigator = nil
        self.desinationRouter = nil
    }
    
    public var body: some View {
        switch configuration.mode {
        case .uikit:
            // UIKit Navigation Mode
            UINavigationContainer(
                content: self.content,
                configuration: self.configuration,
                navigator: self.navigator,
                destinationRouter: self.desinationRouter
            )
                .ignoresSafeArea(edges: .bottom) // matches typical UINavigationController behavior
                .environment(\.navigationConfiguration, configuration)
        case .swiftui:
            // SwiftUI Navigation Mode
            if let navigator = self.navigator, let desinationRouter = self.desinationRouter {
                SwiftUINavigationView(navigator: navigator, destinationRouter: desinationRouter) {
                    content
                }
                .environment(\.navigationConfiguration, configuration)
            } else {
                // Fallback for cases without navigator
                NavigationStack {
                    content
                }
                .environment(\.navigationConfiguration, configuration)
            }
        }
    }
}


// MARK: - UIViewControllerRepresentable

private struct UINavigationContainer<Content: View>: UIViewControllerRepresentable {
    let content: Content
    let configuration: NavigationConfiguration
    let navigator: AppNavigator?
    let destinationRouter: (any DestinationRouterProtocol)?

    func makeCoordinator() -> Coordinator {
        Coordinator(navigator: self.navigator, destinationRouter: self.destinationRouter)
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let proxy = context.coordinator.proxy
        
        // Extract navigation configuration factory from content (handles modifiers)
        let navConfigFactory = NavigationConfigExtractor.extract(from: content)
        
        let root = ConfigurableHostingController(rootView: content.environment(\.uinc, proxy), navConfigFactory: navConfigFactory)
        root.view.backgroundColor = UIColor.systemBackground

        let nav = UINavigationController(rootViewController: root)

        // Wire things up
        proxy.navController = nav
        nav.interactivePopGestureRecognizer?.delegate = context.coordinator
        nav.delegate = context.coordinator

        // Apply configuration
        nav.setNavigationBarHidden(self.configuration.isNavigationBarHidden, animated: false)
        nav.navigationBar.prefersLargeTitles = self.configuration.prefersLargeTitles

        // Default appearance that plays nicely with SwiftUI
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance

        return nav
    }

    func updateUIViewController(_ nav: UINavigationController, context: Context) {
        let proxy = context.coordinator.proxy
        
        // Keep the proxy pointing at the current navigation controller
        proxy.navController = nav

        // Update navigation bar based on proxy data
        proxy.updateNavigationBar()
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
        let proxy: UINavigationProxy
        let navigator: AppNavigator?

        init(navigator: AppNavigator?, destinationRouter: (any DestinationRouterProtocol)?) {
            self.navigator = navigator
            self.proxy = UINavigationProxy(navigator: navigator)
            super.init()
            
            // Wire up the navigator and route definition to the proxy
            if let navigator = navigator {
                navigator.uiNavigationProxy = proxy
            }
            if let destinationRouter = destinationRouter {
                proxy.setDestinationRouter(destinationRouter)
            }
        }

        // Keep the pop gesture working while allowing it on non-root controllers
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let nav = self.proxy.navController else { return true }
            return nav.viewControllers.count > 1
        }
        
        // UINavigationControllerDelegate method to update navigation bar when view appears
        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            if let vc = viewController as? ConfigurableHostingControllerProtocol {
                let navConfig = vc.navConfigFactory?()
                self.proxy.applyNavigationConfiguration(navConfig, to: viewController)
            }
        }
    }
}

// MARK: - SwiftUI Navigation View

private struct SwiftUINavigationView<Content: View>: View {
    @ObservedObject private var navigator: AppNavigator
    private let content: Content
    private let destinationRouter: any DestinationRouterProtocol
  
    init(navigator: AppNavigator, destinationRouter: any DestinationRouterProtocol, @ViewBuilder content: () -> Content) {
        self.navigator = navigator
        self.destinationRouter = destinationRouter
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            content
                .navigationDestination(for: AppRoute.self) { route in
                    AnyView(self.destinationRouter.destination(for: route))
                }
        }
    }
}
