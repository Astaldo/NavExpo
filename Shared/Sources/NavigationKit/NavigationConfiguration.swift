//
//  Untitled.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI
import UIKit

// MARK: - Navigation Configuration

public enum NavigationMode: Sendable {
    case uikit
    case swiftui
}

public enum NavigationTransition {
    case slide
    case fade
    case custom(CATransition)
}

public struct NavigationConfiguration {
    public let mode: NavigationMode
    public let defaultTransition: NavigationTransition
    public let prefersLargeTitles: Bool
    public let isNavigationBarHidden: Bool
    
    public init(
        mode: NavigationMode = .swiftui,
        defaultTransition: NavigationTransition = .slide,
        prefersLargeTitles: Bool = true,
        isNavigationBarHidden: Bool = false
    ) {
        self.mode = mode
        self.defaultTransition = defaultTransition
        self.prefersLargeTitles = prefersLargeTitles
        self.isNavigationBarHidden = isNavigationBarHidden
    }
}

// MARK: - Environment

private struct UINavigationProxyKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue = UINavigationProxy()
}

private struct NavigationConfigurationKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue = NavigationConfiguration()
}

public extension EnvironmentValues {
    var uinc: UINavigationProxy {
        get { self[UINavigationProxyKey.self] }
        set { self[UINavigationProxyKey.self] = newValue }
    }
    
    var navigationConfiguration: NavigationConfiguration {
        get { self[NavigationConfigurationKey.self] }
        set { self[NavigationConfigurationKey.self] = newValue }
    }
}
