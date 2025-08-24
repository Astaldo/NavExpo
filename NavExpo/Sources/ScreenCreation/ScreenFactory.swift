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
    public func makeHomeDetail1(navigator: AppNavigator) -> (any View, NavigationBarData) {
        let view = HomeDetail1Screen(navigator: navigator)
        return (view, view.navigationConfiguration)
    }
    
    @MainActor
    public func makeHomeDetail2(navigator: AppNavigator) -> (any View, NavigationBarData) {
        let view = HomeDetail2Screen(navigator: navigator)
        return (view, view.navigationConfiguration)
    }
    
    @MainActor
    public func makeListDetail1(navigator: AppNavigator) -> (any View, NavigationBarData) {
        let view = ListDetail1Screen(navigator: navigator)
        return (view, view.navigationConfiguration)
    }
    
    @MainActor
    public func makeListDetail2(navigator: AppNavigator) -> (any View, NavigationBarData) {
        let view = ListDetail2Screen(navigator: navigator)
        return (view, view.navigationConfiguration)
    }
    
    @MainActor
    public func makeProfileDetail1(navigator: AppNavigator) -> (any View, NavigationBarData) {
        let view = ProfileDetail1Screen(navigator: navigator)
        return (view, view.navigationConfiguration)
    }
    
    @MainActor
    public func makeProfileDetail2(navigator: AppNavigator) -> (any View, NavigationBarData) {
        let view = ProfileDetail2Screen(navigator: navigator)
        return (view, view.navigationConfiguration)
    }
}
