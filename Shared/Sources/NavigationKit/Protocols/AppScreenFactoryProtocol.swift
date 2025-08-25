//
//  AppScreenFactoryProtocol.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI

// MARK: - Screen Factory Protocol

@MainActor
public protocol AppScreenFactoryProtocol {
    func makeHomeRoot(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
    func makeHomeDetail1(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
    func makeHomeDetail2(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
    func makeListRoot(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
    func makeListDetail1(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
    func makeListDetail2(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
    func makeProfileRoot(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
    func makeProfileDetail1(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
    func makeProfileDetail2(navigator: AppNavigator) -> (AnyView, NavigationBarDataFactory)
}
