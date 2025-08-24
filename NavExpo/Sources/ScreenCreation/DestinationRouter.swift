//
//  DestinationRouter.swift
//  NavExpo
//
//  Created by David Blake on 22/08/2025.
//

import NavigationKit
import SwiftUI

// MARK: - App Route Definition Implementation

public struct DestinationRouter: DestinationRouterProtocol {
    private let navigator: AppNavigator
    private let screenFactory: AppScreenFactoryProtocol
    
    public init(navigator: AppNavigator, screenFactory: AppScreenFactoryProtocol) {
        self.navigator = navigator
        self.screenFactory = screenFactory
    }
    
    @MainActor
    public func destination(for route: AppRoute) -> any View {
        self.destinationWithConfig(for: route).0
    }
    
    @MainActor
    public func destinationWithConfig(for route: AppRoute) -> (any View, NavigationBarData) {
        switch route {
        case .home:
            return (EmptyView(), NavigationBarData()) // Root views are handled separately
        case .homeDetail1:
            return self.screenFactory.makeHomeDetail1(navigator: navigator)
        case .homeDetail2:
            return self.screenFactory.makeHomeDetail2(navigator: navigator)
        case .list:
            return (EmptyView(), NavigationBarData()) // Root views are handled separately
        case .listDetail1:
            return self.screenFactory.makeListDetail1(navigator: navigator)
        case .listDetail2:
            return self.screenFactory.makeListDetail2(navigator: navigator)
        case .profile:
            return (EmptyView(), NavigationBarData()) // Root views are handled separately
        case .profileDetail1:
            return self.screenFactory.makeProfileDetail1(navigator: navigator)
        case .profileDetail2:
            return self.screenFactory.makeProfileDetail2(navigator: navigator)
        }
    }
}
