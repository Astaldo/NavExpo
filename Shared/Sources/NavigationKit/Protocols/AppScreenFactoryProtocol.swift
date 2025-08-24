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
    func makeHomeDetail1(navigator: AppNavigator) -> (any View, NavigationBarData)
    func makeHomeDetail2(navigator: AppNavigator) -> (any View, NavigationBarData)
    func makeListDetail1(navigator: AppNavigator) -> (any View, NavigationBarData)
    func makeListDetail2(navigator: AppNavigator) -> (any View, NavigationBarData)
    func makeProfileDetail1(navigator: AppNavigator) -> (any View, NavigationBarData)
    func makeProfileDetail2(navigator: AppNavigator) -> (any View, NavigationBarData)
}
