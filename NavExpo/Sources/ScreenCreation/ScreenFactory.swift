//
//  ScreenFactory.swift
//  NavExpo
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI
import NavigationKit
import HomeFeature
import ListFeature
import ProfileFeature

// MARK: - App Screen Factory Implementation

public struct ScreenFactory: AppScreenFactoryProtocol {
    @MainActor
    public func makeHomeDetail1(navigator: AppNavigator) -> AnyView {
        AnyView(HomeDetail1Screen(navigator: navigator))
    }
    
    @MainActor
    public func makeHomeDetail2(navigator: AppNavigator) -> AnyView {
        AnyView(HomeDetail2Screen(navigator: navigator))
    }
    
    @MainActor
    public func makeListDetail1(navigator: AppNavigator) -> AnyView {
        AnyView(ListDetail1Screen(navigator: navigator))
    }
    
    @MainActor
    public func makeListDetail2(navigator: AppNavigator) -> AnyView {
        AnyView(ListDetail2Screen(navigator: navigator))
    }
    
    @MainActor
    public func makeProfileDetail1(navigator: AppNavigator) -> AnyView {
        AnyView(ProfileDetail1Screen(navigator: navigator))
    }
    
    @MainActor
    public func makeProfileDetail2(navigator: AppNavigator) -> AnyView {
        AnyView(ProfileDetail2Screen(navigator: navigator))
    }
}
