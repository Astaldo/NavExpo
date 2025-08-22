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
        switch route {
        case .home:
            return AnyView(EmptyView()) // Root views are handled separately
        case .homeDetail1:
            return screenFactory.makeHomeDetail1(navigator: navigator)
        case .homeDetail2:
            return screenFactory.makeHomeDetail2(navigator: navigator)
        case .list:
            return AnyView(EmptyView()) // Root views are handled separately
        case .listDetail1:
            return screenFactory.makeListDetail1(navigator: navigator)
        case .listDetail2:
            return screenFactory.makeListDetail2(navigator: navigator)
        case .profile:
            return AnyView(EmptyView()) // Root views are handled separately
        case .profileDetail1:
            return screenFactory.makeProfileDetail1(navigator: navigator)
        case .profileDetail2:
            return screenFactory.makeProfileDetail2(navigator: navigator)
        }
    }
}
