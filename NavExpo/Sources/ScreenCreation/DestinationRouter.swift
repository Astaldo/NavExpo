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
    public func destination(for route: AppRoute) -> AnyView {
        self.destinationWithConfig(for: route).0
    }
    
    @MainActor
    public func destinationWithConfig(for route: AppRoute) -> (AnyView, NavigationBarDataFactory) {
        switch route {
        case .home:
            return self.screenFactory.makeHomeRoot(navigator: navigator)
        case .homeDetail1:
            return self.screenFactory.makeHomeDetail1(navigator: navigator)
        case .homeDetail2:
            return self.screenFactory.makeHomeDetail2(navigator: navigator)
        case .list:
            return self.screenFactory.makeListRoot(navigator: navigator)
        case .listDetail1:
            return self.screenFactory.makeListDetail1(navigator: navigator)
        case .listDetail2:
            return self.screenFactory.makeListDetail2(navigator: navigator)
        case .profile:
            return self.screenFactory.makeProfileRoot(navigator: navigator)
        case .profileDetail1:
            return self.screenFactory.makeProfileDetail1(navigator: navigator)
        case .profileDetail2:
            return self.screenFactory.makeProfileDetail2(navigator: navigator)
        }
    }
}
