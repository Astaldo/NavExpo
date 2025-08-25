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

@MainActor
public struct ScreenFactory: AppScreenFactoryProtocol {
 
    public func makeHomeRoot(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let viewModel = HomeViewModel()
        let view = HomeRootScreen(navigator: navigator, viewModel: viewModel)
        return (AnyView(view), view.navigationConfiguration)
    }
    
    public func makeHomeDetail1(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let view = HomeDetail1Screen(navigator: navigator)
        return (AnyView(view), view.navigationConfiguration)
    }
    
    public func makeHomeDetail2(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let view = HomeDetail2Screen(navigator: navigator)
        return (AnyView(view), view.navigationConfiguration)
    }
    
    public func makeListRoot(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let view = ListRootScreen(navigator: navigator)
        return (AnyView(view), view.navigationConfiguration)
    }
    
    public func makeListDetail1(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let view = ListDetail1Screen(navigator: navigator)
        return (AnyView(view), view.navigationConfiguration)
    }
    
    public func makeListDetail2(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let view = ListDetail2Screen(navigator: navigator)
        return (AnyView(view), view.navigationConfiguration)
    }
    
    public func makeProfileRoot(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let view = ProfileRootScreen(navigator: navigator)
        return (AnyView(view), view.navigationConfiguration)
    }
    
    public func makeProfileDetail1(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let view = ProfileDetail1Screen(navigator: navigator)
        return (AnyView(view), view.navigationConfiguration)
    }
    
    public func makeProfileDetail2(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory) {
        let view = ProfileDetail2Screen(navigator: navigator)
        return (AnyView(view), view.navigationConfiguration)
    }
}
